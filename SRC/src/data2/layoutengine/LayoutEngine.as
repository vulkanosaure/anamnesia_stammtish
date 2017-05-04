/* 
 
 DOCUMENTATION :
 
 regles de positionnement :
 - padding concerne les marges du parent par rapport aux childrens
 - margins concerne les marges du child par rapport au parent
 - tout peut être définie en px ou en %

 3 types de redimensionnement : 
	- none (aucun)
	- child2parent : le child va se redimensionner (si les margin/padding l'imposent)
	- parent2child : le parent va se redimensionner a la taille minimale (si les margin/padding l'imposent)

- si un LayoutSprite est redimensionné manuellement, il faut renseigner son nouveau layoutwidth / layoutheight



CSS : 

- list properties : voir constantes LIST_PROPERTIES_CSS
- casse insensible pour les selector (mais pas pour les prop)
- on peut ajouter des - comme on veut (pour la lisibilité)
- on peut définir plusieurs feuilles de styles
- interdit de laisser un selecteur vide (fait bugger StyleSheet)
- css a la priorité sur définition as (sauf si faite après application du css, cad a l'apparition de l'objet)
- si on définit overflow-hidden à true, il faut que layoutwidth et layoutheight soient définis


TODO :

homotethie ?
minimum et maximum dims
un seul layout_resize pour width et height
detection d'un selecteur vide avt parsage css (throw error)
pouvoir l'appliquer a un objet qui n'existerait pas tout de suite mais s'instancierait plus tard	TODO
	applyCSS boucle sur les nouveaux arrivant (voir comment détecter un nouvel arrivant) et leur apply TOUS les css (puisque tout aura été défini)



 * */

package data2.layoutengine 
{
	import data2.asxml.ObjectSearch;
	import data2.display.ClickableSprite;
	import data2.display.skins.Skin;
	import data2.parser.StyleSheet2;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Vincent
	 */
	
	
	public class LayoutEngine
	{
		private static const HORIZONTAL:String = "horizontal";
		private static const VERTICAL:String = "vertical";
		
		private static const REGEX_STYLENAME:RegExp = /^[\#|.|*]{1}[a-zA-Z_\d]+$/;
		private static const LIST_PROPERTIES_CSS:Array = [
		"widthResizeType",
		"heightResizeType",
		"resizeObject",
		"marginLeft",
		"marginRight",
		"marginTop",
		"marginBottom",
		"paddingLeft",
		"paddingRight",
		"paddingTop",
		"paddingBottom",
		"layoutWidth",
		"layoutHeight",
		"containerMinWidth",
		"containerMinHeight",
		"overflowHidden",
		"width",
		"height",
		"backgroundColor",
		"border",
		"maxWidth",
		"maxHeight"
		];
		
		private static var _stage:Stage;
		private static var _baseContainer:DisplayObjectContainer;
		private static var _measureQueue:LayoutQueue;
		private static var _layoutQueue:LayoutQueue;
		
		private static var _objectphase1:Array;
		
		private static var _styleSheet:StyleSheet2;
		private static var _styleSheetStr:String;
		private static var _cssfiles:Array;
		private static var _countCssLoaded:int;
		private static var _evtDispatcher:EventDispatcher;
		
		private static var _layoutSize:Point;
		
		
		public function LayoutEngine() 
		{
			throw new Error("is static");
			
		}
		
		
		
		//________________________________________________________________________________________________________
		//public functions
		
		
		public static function init(__stage:Stage, __baseContainer:DisplayObjectContainer, __cssfiles:Array=null, __stylesheetStr:String=null):void
		{
			_stage = __stage;
			_baseContainer = __baseContainer;
			_cssfiles = __cssfiles;
			_stage.addEventListener(Event.RESIZE, onStageResize);
			
			_styleSheetStr = __stylesheetStr;
			_styleSheet = new StyleSheet2();
			
			if (_measureQueue == null) _measureQueue = new LayoutQueue();
			if (_layoutQueue == null) _layoutQueue = new LayoutQueue();
			
			
			_styleSheet.parseCSS(__stylesheetStr);
			validStylesheet(_styleSheet);
			applyCSS(_stage);
			
		}
		
		public static function start():void
		{
			_stage.addEventListener(Event.ENTER_FRAME, onEnterframe);
			update();
		}
		
		
		
		public static function addEventListener(_type:String, _handler:Function):void
		{
			if (_evtDispatcher == null) _evtDispatcher = new EventDispatcher();
			_evtDispatcher.addEventListener(_type, _handler);
		}
		
		
		public static function applyCSS(_dobjc:DisplayObjectContainer):void
		{
			var _listChildrens:Array = getChildList(_dobjc);
			var _len:uint = _listChildrens.length;
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _child:DisplayObject = DisplayObject(_listChildrens[i]);
				if (_child is DisplayObjectContainer) {
					
					if (_child is LayoutSprite) {
						
						var _styleClass:Object = _styleSheet.getStyle("." + ObjectSearch.getClassName(_child));
						var _styleName:Object = _styleSheet.getStyle("*" + DisplayObjectContainer(_child).name);
						var _styleID:Object = _styleSheet.getStyle("#" + LayoutSprite(_child).id);
						
						var _ls:LayoutSprite = LayoutSprite(_child);
						applyCSStoObject(_ls, _styleClass);
						applyCSStoObject(_ls, _styleName);
						applyCSStoObject(_ls, _styleID);
					}
					applyCSS(DisplayObjectContainer(_child));
				}
			}
		}
		
		
		
		
		//________________________________________________________________________________________________________
		//events
		
		private static function onCssLoaded(e:Event):void 
		{
			//trace("onCssLoaded");
			var _content:String = e.target.data;
			//_content = _content.replace(/-/g, "");
			_styleSheet.parseCSS(_content);
			validStylesheet(_styleSheet);
			
			_countCssLoaded++;
			if (_countCssLoaded == _cssfiles.length) {
				//todo : changer car la, ne fonctionne que pour les élements définis avant le chargement des css
				applyCSS(_stage);
				_stage.addEventListener(Event.ENTER_FRAME, onEnterframe);
				
				if (_evtDispatcher == null) _evtDispatcher = new EventDispatcher();
				_evtDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private static function onStageResize(e:Event):void 
		{
			invalid(_baseContainer);
		}
		
		
		private static function onEnterframe(e:Event):void 
		{
			update();
		}
		
		
		
		
		//________________________________________________________________________________________________________
		//private functions
		
		
		//CSS
		
		private static function loadCSS(_urlcss:String)
		{
			//trace("loadCSS(" + _urlcss + ")");
			var _urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onCssLoaded);
			_urlLoader.load(new URLRequest(_urlcss));
		}
		
		private static function validStylesheet(_ss:StyleSheet2):void
		{
			var _list:Array = _ss.styleNames;
			var _len:uint = _list.length;
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _stylename:String = _list[i];
				if (_stylename.match(REGEX_STYLENAME) == null) throw new Error("invalid stylename " + _stylename + ", " + REGEX_STYLENAME);
			}
		}
		
		
		
		private static function applyCSStoObject(_ls:LayoutSprite, _styleObj:Object):void
		{
			_ls.enableInvalid = false;
			for (var i in _styleObj) {
				var _prop:String = String(i);
				var _value:* = _styleObj[i];
				
				if (LIST_PROPERTIES_CSS.indexOf(_prop) == -1)
					throw new Error("property " + _prop + " not available on LayoutSprite. Available properties are : \n" + LIST_PROPERTIES_CSS.join("\n"));
					
				//trace("---  set prop " + _prop + ", " + _value);
				
				//conversion en boolean
				if (_value == "true") _value = true;
				else if (_value == "false") _value = false;
				
				//trace(_ls + "[" + _prop + "] = " + _value);
				
				_ls[_prop] = _value;
				
			}
			
			_ls.enableInvalid = true;
			_ls.invalidLayout(false);
			_ls.invalidLayout(true);
			
		}
		
		
		
		private static function countObject(_obj:Object):int
		{
			var _count:int = 0;
			for (var i in _obj) _count++;
			return _count;
		}
		
		
		
		
		
		
		/*
		INVALIDATION :
		
		global invalid : 
			si l'element invalidé a un parent en RESIZE_PARENT2CHILD
				invalidMesure sur parent
				invalid sur parent
			invalidLayout sur tous les child
			
		invalidLayout :
			invalidLayout sur tous les child
		*/
		
		
		//only used by LayoutSprite, call LayoutSprite.invalidLayout();
		public static function invalid(__sprite:DisplayObjectContainer):void
		{
			//trace("LayoutEngine.invalid(" + ObjectSearch.formatObject(__sprite) + ")");
			
			//optimisation
			if (_measureQueue != null && _measureQueue.contains(__sprite)) {
				if (_layoutQueue != null && _layoutQueue.contains(__sprite)) {
					return;
				}
			}
			
			var _parent:DisplayObjectContainer = __sprite.parent;
			
			
			//si l'element invalidé a un parent en RESIZE_PARENT2CHILD
			if (_parent != null && _parent is LayoutSprite) {
				var _lsparent:LayoutSprite = LayoutSprite(_parent);
				if (_lsparent.widthResizeType == LayoutSprite.RESIZE_PARENT2CHILD || _lsparent.heightResizeType == LayoutSprite.RESIZE_PARENT2CHILD) {
					invalidMeasure(_lsparent);
					invalid(_lsparent);
				}
			}
			invalidLayout(__sprite);
		}
		
		
		private static function invalidMeasure(__sprite:DisplayObjectContainer):void
		{
			if (_measureQueue == null) _measureQueue = new LayoutQueue();
			if (__sprite is LayoutSprite) {
				LayoutSprite(__sprite).minimumwidth = 0;
				LayoutSprite(__sprite).minimumheight = 0;
			}
			_measureQueue.add(__sprite);
		}
		
		private static function invalidLayout(__sprite:DisplayObjectContainer):void
		{
			if (_layoutQueue == null) _layoutQueue = new LayoutQueue();
			
			_layoutQueue.add(__sprite);
			/*
			//new test
			if (__sprite is LayoutSprite) {
				var _ls:LayoutSprite = LayoutSprite(__sprite);
				_ls.invalidLayoutDimensions();
			}
			*/
			
			var _listChildrens:Array = getChildList(__sprite);
			var _len:uint = _listChildrens.length;
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _child:DisplayObject = DisplayObject(_listChildrens[i]);
				if (_child is Sprite) {
					invalidLayout(Sprite(_child));
				}
			}
		}
		
		
		
		
		public static function update(_base:DisplayObjectContainer=null):void
		{
			if (_base == null) _base = _baseContainer;
			
			var _lenMeasureQueue:int = _measureQueue.length;
			var _lenLaoutQueue:int = _layoutQueue.length;
			
			
			if (_lenMeasureQueue > 0 || _lenLaoutQueue > 0) {
				clearGraphics(_base);
				/*
				for (var i:int = 0; i < _lenMeasureQueue; i++) 
				{
					var _obj:Object = _measureQueue.getChildAt(i);
					if (_obj is LayoutSprite) LayoutSprite(_obj).invalidLayoutDimensions();
				}
				*/
				for (var i:int = 0; i < _lenLaoutQueue; i++) 
				{
					var _obj:Object = _layoutQueue.getChildAt(i);
					if (_obj is LayoutSprite) LayoutSprite(_obj).invalidLayoutDimensions();
				}
			}
			
			
			if (_lenMeasureQueue > 0) {
				phase_measure(_base);
			}
			if (_lenLaoutQueue > 0) {
				phase_layout(_base);
			}
			
			if (_lenMeasureQueue > 0 || _lenLaoutQueue > 0) {
				updateGraphics(_base);
				
				_measureQueue.reset();
				_layoutQueue.reset();
			}
			
		}
		
		
		private static function clearGraphics(_base:DisplayObjectContainer):void
		{
			var _len:int = _base.numChildren;
			for (var i:int = 0; i < _len; i++) 
			{
				var _child:DisplayObject = _base.getChildAt(i);
				if (_child is LayoutSprite) {
					var _ls:LayoutSprite = LayoutSprite(_child);
					_ls.clearGraphics();
				}
				if (_child is DisplayObjectContainer) {
					var _dobjc:DisplayObjectContainer = DisplayObjectContainer(_child);
					clearGraphics(_dobjc);
				}
			}
		}
		private static function updateGraphics(_base:DisplayObjectContainer):void
		{
			var _len:int = _base.numChildren;
			for (var i:int = 0; i < _len; i++) 
			{
				var _child:DisplayObject = _base.getChildAt(i);
				if (_child is LayoutSprite) {
					var _ls:LayoutSprite = LayoutSprite(_child);
					_ls.updateGraphics();
				}
				if (_child is DisplayObjectContainer) {
					var _dobjc:DisplayObjectContainer = DisplayObjectContainer(_child);
					updateGraphics(_dobjc);
				}
			}
		}
		
		
		
		
		//_____________________________________________________
		//inverse scan
		
		
		
		private static function phase_measure(__baseContainer:DisplayObjectContainer):void
		{
			var _child:DisplayObjectContainer = get_deepest_direct_sprite(__baseContainer);
			phase_measure_recursive(_child);
		}
		
		
		
		private static function phase_measure_recursive(_child:DisplayObjectContainer):void
		{
			//trace("phase_measure_recursive(" + _child + ")");
			
			var _parent:DisplayObjectContainer = _child.parent;
			if (_parent == null) return;
			
			if (_parent is LayoutSprite && _child is LayoutSprite && !(_child is Skin)) {
				
				//new : filtre les parents de invalidList
				if (_measureQueue.contains(_parent)) { 
					
					fit_parent2child(LayoutSprite(_parent), LayoutSprite(_child));
				}
			}
			
			var cur_index:int = _parent.getChildIndex(_child);
			
			//si le parent a d'autre child
			
			var findDeeperSprite:Boolean = false;
			
			if (getChildList(_parent).length > cur_index + 1) {
				
				var __child:Sprite = getNextSprite(_parent, cur_index);
				if (__child != null) {
					var __deepestsprite:Sprite = get_deepest_direct_sprite(__child);
					findDeeperSprite = true;
					phase_measure_recursive(__deepestsprite);
					
				}
			}
			
			if(!findDeeperSprite) {
				phase_measure_recursive(_parent);
			}
			
		}
		
		
		private static function get_deepest_direct_sprite(_dobjc:DisplayObjectContainer):Sprite
		{
			var _child:DisplayObjectContainer;
			while (getChildList(_dobjc).length) {
				_child = getFirstSprite(_dobjc);
				if (_child != null) _dobjc = _child;
				else break;
			}
			return Sprite(_dobjc);
		}
		private static function getFirstSprite(_dobjc:DisplayObjectContainer):Sprite
		{
			var _listChildrens:Array = getChildList(_dobjc);
			var _len:uint = _listChildrens.length;
			for(var i:int = 0; i < _len; i++) {
				var _child:DisplayObject = DisplayObject(_listChildrens[i]);
				if (_child is Sprite) return Sprite(_child);
			}
			return null;
		}
		
		private static function getNextSprite(_container:DisplayObjectContainer, _curind:int):Sprite
		{
			var _listChildrens:Array = getChildList(_container);
			var _len:uint = _listChildrens.length;
			for (var i:int = _curind+1; i < _len; i++) 
			{
				var _child:DisplayObject = DisplayObject(_listChildrens[i]);
				if (_child is Sprite) return Sprite(_child);
			}
			return null;
		}
		
		
		
		
		
		
		private static function phase_layout(_dobjc:DisplayObjectContainer):void
		{
			//trace("phase_layout : " + _dobjc);
			
			var _listChildrens:Array = getChildList(_dobjc);
			var _len:uint = _listChildrens.length;
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _child:DisplayObject = DisplayObject(_listChildrens[i]);
				
				if (_child is DisplayObjectContainer) {
					if (_child is LayoutSprite) {
						
						//new : filtre les enfant de invalidList
						if (_layoutQueue.contains(_child)) {
							
							fit_child2parent(_dobjc, LayoutSprite(_child));
						}
						
					}
					phase_layout(DisplayObjectContainer(_child));
				}
			}
		}
		
		
		
		
		
		
		
		
		
		//____________________________________________________________________
		//layout algorythms
		
		//cette fonction doit redimensionner le parent en fonction du child
		private static function fit_parent2child(_parent:LayoutSprite, _child:LayoutSprite):void
		{
			var _width:Number = fit_parent2child_side(_parent, _child, HORIZONTAL);
			var _height:Number = fit_parent2child_side(_parent, _child, VERTICAL);
			
			
			if (!isNaN(_width)) {
				//si pour ce tour, la dimension trouvée est supérieur au dimensions précedente, on la valide
				if (_width > _parent.minimumwidth) {
					_parent.layout_resize_width(_width);
					_parent.minimumwidth = _width;
					_parent.layoutWidth = _width;
				}
			}
			
			if (!isNaN(_height)) {
				//si pour ce tour, la dimension trouvée est supérieur au dimensions précedente, on la valide
				if (_height > _parent.minimumheight) {
					_parent.layout_resize_height(_height);
					_parent.minimumheight = _height;
					_parent.layoutHeight = _height;
				}
			}
			
			//_parent.updateGraphics();
		}
		
		
		
		private static function fit_parent2child_side(_parent:LayoutSprite, _child:LayoutSprite, _side:String):Number
		{
			var _propresizetype:String = (_side == HORIZONTAL) ? "widthResizeType" : "heightResizeType";
			var _side1:String = (_side == HORIZONTAL) ? "left" : "top";
			var _side2:String = (_side == HORIZONTAL) ? "right" : "bottom";
			var _pointprop:String = (_side == HORIZONTAL) ? "x" : "y";
			
			if (_parent[_propresizetype] == LayoutSprite.RESIZE_PARENT2CHILD) {
				/*
				if (_child[_propresizetype] == LayoutSprite.RESIZE_CHILD2PARENT) 
					throw new Error(ObjectSearch.formatObject(_child) + " can't have resize " + LayoutSprite.RESIZE_CHILD2PARENT + " with parent " + ObjectSearch.formatObject(_parent) + " of resize " + LayoutSprite.RESIZE_PARENT2CHILD + " (" + _side + ")");
					*/
				var margin1_type:String = _child["margin" + _side1 + "_type"];
				var margin2_type:String = _child["margin" + _side2 + "_type"];
				var padding1_type:String = _parent["padding" + _side1 + "_type"];
				var padding2_type:String = _parent["padding" + _side2 + "_type"];
				var margin1_value:Number = _child["margin" + _side1 + "_value"];
				var margin2_value:Number = _child["margin" + _side2 + "_value"];
				var padding1_value:Number = _parent["padding" + _side1 + "_value"];
				var padding2_value:Number = _parent["padding" + _side2 + "_value"];
				
				if (isNaN(margin1_value)) margin1_value = 0;
				if (isNaN(margin2_value)) margin2_value = 0;
				if (isNaN(padding1_value)) padding1_value = 0;
				if (isNaN(padding2_value)) padding2_value = 0;
				
				
				
				
				var percent_margin:Number = 0;
				var pixel_margin:Number = 0;
				if (margin1_type == MarginObject.TYPE_PERCENT) percent_margin += margin1_value;
				else pixel_margin += margin1_value;
				if (margin2_type == MarginObject.TYPE_PERCENT) percent_margin += margin2_value;
				else pixel_margin += margin2_value;
				
				var percent_padding:Number = 0;
				var pixel_padding:Number = 0;
				if (padding1_type == MarginObject.TYPE_PERCENT) percent_padding += padding1_value;
				else pixel_padding += padding1_value;
				if (padding2_type == MarginObject.TYPE_PERCENT) percent_padding += padding2_value;
				else pixel_padding += padding2_value;
				
				//( - percent * dimension) / (percent - 1)
				
				percent_margin /= 100;
				percent_padding /= 100;
				var addpxpercent:Number;
				var childdims:Point = getObjectDimensions(_child);
				var dimchild:Number = childdims[_pointprop];
				
				
				//add margins
				dimchild += pixel_margin;
				addpxpercent =  ( - percent_margin * dimchild) / (percent_margin - 1);
				var dims_without_padding:Number = dimchild + addpxpercent;
				
				
				//add paddings
				dims_without_padding += pixel_padding;
				addpxpercent =  ( - percent_padding * dims_without_padding) / (percent_padding - 1);
				var dim_total = dims_without_padding + addpxpercent;
				
				return dim_total;
				
			}
			return NaN;
		}
		
		
		
		
		
		private static function fit_child2parent(_containerdobj:DisplayObjectContainer, _child:LayoutSprite):void
		{
			//si _container n'est pas un LayoutSprite, on créé un nouveau LayoutSprite (value par defaut donc)
			//on lui attribue les mm dimensions que _container (exception pour stage)
			//
			
			//trace("fit_child2parent(" + _containerdobj + ", " + _child + ")");
			
			var _container:LayoutSprite;
			if (!(_containerdobj is LayoutSprite)) {
				_container = new LayoutSprite();
				
				
				var _stagewidth:Number = (_layoutSize == null) ? _stage.stageWidth : _layoutSize.x;
				var _stageheight:Number = (_layoutSize == null) ? _stage.stageHeight : _layoutSize.y;
				
				_container.layoutWidth = (_containerdobj == _baseContainer) ? _stagewidth : _container.width;
				_container.layoutHeight = (_containerdobj == _baseContainer) ? _stageheight : _container.height;
			}
			else {
				_container = LayoutSprite(_containerdobj);
			}
			
			
			var paddings:Object = new Object();
			var margins:Object = new Object();
			
			var containerdims:Point = getObjectDimensions(_container);
			var childdims:Point = getObjectDimensions(_child);
			containerdims.x = Math.floor(containerdims.x);
			containerdims.y = Math.floor(containerdims.y);
			
			
			if (!isNaN(_child.containerMinWidth) && containerdims.x < _child.containerMinWidth) containerdims.x = _child.containerMinWidth;
			if (!isNaN(_child.containerMinHeight) && containerdims.y < _child.containerMinHeight) containerdims.y = _child.containerMinHeight;
			
			
			paddings["l"] = getMarginValue(_container.paddingleft_type, _container.paddingleft_value, containerdims.x);
			paddings["r"] = getMarginValue(_container.paddingright_type, _container.paddingright_value, containerdims.x);
			paddings["t"] = getMarginValue(_container.paddingtop_type, _container.paddingtop_value, containerdims.y);
			paddings["b"] = getMarginValue(_container.paddingbottom_type, _container.paddingbottom_value, containerdims.y);
			
			if (isNaN(paddings["l"])) paddings["l"] = 0;
			if (isNaN(paddings["r"])) paddings["r"] = 0;
			if (isNaN(paddings["t"])) paddings["t"] = 0;
			if (isNaN(paddings["b"])) paddings["b"] = 0;
			
			//substract paddings
			containerdims.x -= paddings["l"] + paddings["r"];
			containerdims.y -= paddings["t"] + paddings["b"];
			
			margins["l"] = getMarginValue(_child.marginleft_type, _child.marginleft_value, containerdims.x);
			margins["r"] = getMarginValue(_child.marginright_type, _child.marginright_value, containerdims.x);
			margins["t"] = getMarginValue(_child.margintop_type, _child.margintop_value, containerdims.y);
			margins["b"] = getMarginValue(_child.marginbottom_type, _child.marginbottom_value, containerdims.y);
			
			
			var horizPosWidth:Array = fit_child2parent_side(_child, paddings["l"], paddings["r"], margins["l"], margins["r"], containerdims.x, childdims.x, HORIZONTAL);
			var verticPosWidth:Array = fit_child2parent_side(_child, paddings["t"], paddings["b"], margins["t"], margins["b"], containerdims.y, childdims.y, VERTICAL);
			
			var _x:Number = horizPosWidth[0];
			var _width:Number = horizPosWidth[1];
			var _y:Number = verticPosWidth[0];
			var _height:Number = verticPosWidth[1];
			
			
			if(_child.enabled){
				_child.super_x = Math.round(_x);
				_child.super_y = Math.round(_y);
			}
			
			if (_child.widthResizeType==LayoutSprite.RESIZE_CHILD2PARENT && _width != _child.layoutWidth) {
				_child.layout_resize_width(_width);
				_child.layoutWidth = _width;
			}
			if (_child.heightResizeType==LayoutSprite.RESIZE_CHILD2PARENT && _height != _child.layoutHeight) {
				_child.layout_resize_height(_height);
				_child.layoutHeight = _height;
			}
			
			
			//_child.updateGraphics();
			
			//gestion overflow hidden
			if (_child.overflowHidden) {
				//if (_child.mask == null) {
					if (isNaN(_child.layoutWidth) || isNaN(_child.layoutHeight)) throw new Error("you must define property layoutWidth and layoutHeight if you set overflowHidden to true");
					
					//trace("mask = null");
					var _mask:Sprite;
					if (_child.mask == null) {
						_mask = new Sprite();
						_child.mask = _mask;
						_containerdobj.addChild(_mask);
					}
					else _mask = Sprite(_child.mask);
					drawRect(_mask, _child.layoutWidth, _child.layoutHeight);
					
				//}
				_child.mask.x = _child.x;
				_child.mask.y = _child.y;
			}
			
		}
		
		public static function getChildPositionInUnit(_child:LayoutSprite, _prop:String, _unit:String):Number
		{
			var _mode:String;
			var _offset:String;
			
			if (_prop == "marginLeft" || _prop == "marginRight") _mode = HORIZONTAL;
			else if (_prop == "marginTop" || _prop == "marginBottom") _mode = VERTICAL;
			else throw new Error("wrong value for property (" + _prop + ")");
			
			if (_prop == "marginLeft" || _prop == "marginTop") _offset = "start";
			else _offset = "end";
			
			var _propPosition:String;
			if (_mode == HORIZONTAL) _propPosition = "x";
			else _propPosition = "y";
			
			var _dimensions:Point = getObjectDimensions(_child);
			var _dimensionsParent:Point = getObjectDimensions(_child.parent);
			var _output:Number;
			
			var _position:Number = _child[_propPosition];
			var _dim:Number = _dimensions[_propPosition];
			var _dimParent:Number = _dimensionsParent[_propPosition];
			
			if (_unit == MarginObject.TYPE_PIXEL) {
				if (_offset == "start") _output = _position;
				else _output = _dimParent - _position - _dim;
			}
			else if (_unit == MarginObject.TYPE_PERCENT) {
				if (_offset == "start") _output = _position / _dimParent;
				else _output = (_position + _dim) / _dimParent;
				_output *= 100;		//convert to percentage
			}
			return _output;
			
		}
		
		
		
		private static function fit_child2parent_side(_child:LayoutSprite, _paddingstart:Number, _paddingend:Number, _marginstart:Number, _marginend:Number, _containerdim:Number, _childdim:Number, _mode:String):Array
		{
			var _position:Number;
			var _dimension:Number = _childdim;
			
			var marginstart_type:String = (_mode==HORIZONTAL) ? _child.marginleft_type : _child.margintop_type;
			var marginend_type:String = (_mode==HORIZONTAL) ? _child.marginright_type : _child.marginbottom_type;
			var marginstart_value:Number = (_mode==HORIZONTAL) ? _child.marginleft_value : _child.margintop_value;
			var marginend_value:Number = (_mode == HORIZONTAL) ? _child.marginright_value : _child.marginbottom_value;
			
			var child_resizeable:Boolean = (_mode == HORIZONTAL) ? (_child.widthResizeType==LayoutSprite.RESIZE_CHILD2PARENT ) : (_child.heightResizeType==LayoutSprite.RESIZE_CHILD2PARENT );
			
			//si les 2 cotés opposés st définis en %
			if (!child_resizeable && marginstart_type == MarginObject.TYPE_PERCENT && marginend_type == MarginObject.TYPE_PERCENT) {
				var _pospercent:Number = marginstart_value / (marginstart_value + marginend_value);
				if (isNaN(_pospercent)) _pospercent = 0.5; 		//si division par 0
				_position = _containerdim * _pospercent - _childdim * _pospercent;
			}
			else {
				var _safemargins:Array = [_marginstart, _marginend];
				if (isNaN(_safemargins[0])) _safemargins[0] = 0;
				if (isNaN(_safemargins[1])) _safemargins[1] = 0;
				
				if (child_resizeable) {
					_dimension = _containerdim - _safemargins[0] - _safemargins[1];
					
					
					//handling max dimensions
					
					var _bMaxDim:Boolean = false;
					if (_mode == HORIZONTAL && !isNaN(_child.maxWidth) && _dimension > _child.maxWidth) {
						_dimension = _child.maxWidth;
						_bMaxDim = true;
					}
					if (_mode == VERTICAL && !isNaN(_child.maxHeight) && _dimension > _child.maxHeight) {
						_dimension = _child.maxHeight;
						_bMaxDim = true;
					}
					
					//if max dims have occured, we reconsider the non-resizeable behaviour above
					if (_bMaxDim) {
						var _pospercent:Number = marginstart_value / (marginstart_value + marginend_value);
						if (isNaN(_pospercent)) _pospercent = 0.5; 		//si division par 0
						_position = _containerdim * _pospercent - _dimension * _pospercent;
					}
					
				}
				
				if(!_bMaxDim){
					if (!isNaN(_marginend)) _position = _containerdim - _dimension - _marginend;
					if (!isNaN(_marginstart)) _position = _marginstart;
				}
			}
			if (isNaN(_position)) _position = 0;
			_position += _paddingstart;
			return [_position, _dimension];
		}
		
		
		
		private static function getMarginValue(_marginchildtype:String, _marginchildvalue:Number, _containerdim:Number):Number
		{
			var _value:Number = _marginchildvalue;
			if (_marginchildtype == MarginObject.TYPE_PERCENT) {
				_value *= _containerdim / 100;
			}
			return _value;
		}
		
		
		
		public static function getObjectDimensions(_s:DisplayObjectContainer):Point
		{
			var _dims:Point;
			
			var _clickableSprite:DisplayObject;
			_clickableSprite = _s.getChildByName(ClickableSprite.CLICKABLE_SPRITE_NAME);
			if (_clickableSprite != null) _s.removeChild(_clickableSprite);
			
			var _stagewidth:Number = (_layoutSize == null) ? _stage.stageWidth : _layoutSize.x;
			var _stageheight:Number = (_layoutSize == null) ? _stage.stageHeight : _layoutSize.y;
			
			if (_s == _baseContainer) _dims = new Point(_stagewidth, _stageheight);
			else if (!(_s is LayoutSprite)) _dims = new Point(_s.width, _s.height);
			else {
				var _ls:LayoutSprite = LayoutSprite(_s);
				var _width:Number = (isNaN(_ls.layoutWidth)) ? _ls.width : _ls.layoutWidth;
				var _height:Number = (isNaN(_ls.layoutHeight)) ? _ls.height : _ls.layoutHeight;
				_dims = new Point(_width, _height);
			}
			
			if (_clickableSprite != null) _s.addChild(_clickableSprite);
			return _dims;
		}
		
		
		
		
		private static function trace2(_object:Object):void
		{
			for (var i:* in _object) {
				trace(i + " : " + _object[i]);
			}
		}
		
		private static function drawRect(_sp:Sprite, _width:Number, _height:Number):void
		{
			var g:Graphics = _sp.graphics;
			g.clear();
			g.beginFill(0x000000, 1);
			g.drawRect(0, 0, _width, _height);
		}
		
		private static function getChildList(_container:DisplayObjectContainer):Array
		{
			var _tab:Array = new Array();
			var _numchild:uint = _container.numChildren;
			for (var i:int = 0; i < _numchild; i++) 
			{
				var _child:DisplayObject;
				try {
					_child = _container.getChildAt(i);
					_tab.push(_child);
				}
				catch (e) {
					
				}
			}
			return _tab;
		}
		
		static public function set layoutSize(value:Point):void {_layoutSize = value;}
		
		static public function get layoutSize():Point { return _layoutSize; }
		
		
	}
	
	
	
	
	

}