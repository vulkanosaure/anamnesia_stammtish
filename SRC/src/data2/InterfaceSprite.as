/*
todo : 
	
*/

package data2 
{
	import data2.asxml.BtnEffectHandler;
	import data2.asxml.DynamicStateDef;
	import data2.asxml.ObjectSearch;
	import data2.layoutengine.LayoutSprite;
	import data2.asxml.ASCode;
	import data2.asxml.OnClickHandler;
	import data2.behaviours.Behaviour;
	import data2.display.Image;
	import data2.dynamiclist.DynamicList;
	import data2.dynamiclist.DynamicListEvent;
	import data2.dynamiclist.IDynamicItem;
	import data2.text.Text;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author 
	 */
	public class InterfaceSprite extends LayoutSprite
	{
		private const MAX_RECURSIVITY_TEMPLATE:int = 0;
		
		
		public var customdata:Object = new Object();
		
		private var _behaviours:Array;
		private var _dynamicStatesDefs:Array;
		private var _template:String;
		private var _objtpl:Sprite;
		private var _maskDef:Rectangle;
		private var _behaviourChildrens:Array;
		private var _ascodeInstance:ASCode;
		
		private var _bInitClick:Boolean = false;
		
		private var _onclick:String;
		private var _onmouseover:String;
		private var _onmouseout:String;
		private var _onmousedown:String;
		
		private var _clickableMargin:Number;
		public var cm_vert:Number;
		public var cm_horiz:Number;
		public var cm_left:Number;
		public var cm_right:Number;
		public var cm_top:Number;
		public var cm_bottom:Number;
		
		
		private var _clickableSprite:Boolean = true;
		
		private var _btneffect:String = "";
		private var _touchable:Boolean = true;
		
		
		
		
		
		
		
		
		public function InterfaceSprite() 
		{
			_behaviourChildrens = new Array();
		}
		
		public function addBehaviour(_behaviour:Behaviour):void
		{
			if (_behaviourChildrens.length > 0) throw new Error("you must add childrens after behaviours");
			if (_behaviours == null) _behaviours = new Array();
			_behaviours.push(_behaviour);
			_behaviour.interfaceSprite = this;
		}
		
		//temp
		public function getBehaviour(_index:int):Behaviour
		{
			return Behaviour(_behaviours[_index]);
		}
		
		public function getBehaviours():Array 
		{
			if (_behaviours == null) _behaviours = new Array();
			return _behaviours;
		}
		
		
		public function addDynamicStateDef(_dsd:DynamicStateDef):void 
		{
			if (_dynamicStatesDefs == null) _dynamicStatesDefs = new Array();
			_dynamicStatesDefs.push(_dsd);
		}
		
		public function getDynamicStateDefs():Array
		{
			if (_dynamicStatesDefs == null) _dynamicStatesDefs = new Array();
			return _dynamicStatesDefs;
		}
		
		
		
		public function resetChildren():void
		{
			var _len:int = (_behaviours != null) ? _behaviours.length : 0;
			_behaviourChildrens = new Array();
			for (var i:int = 0; i < _len; i++) 
			{
				var _behaviour:Behaviour = Behaviour(_behaviours[i]);
				_behaviour.resetBehaviour();
			}
			while (this.numChildren) this.removeChildAt(0);
		}
		
		
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			registerChild(child);
			return super.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			registerChild(child);
			return super.addChildAt(child, index);
		}
		
		public function simpleAddChild(child:DisplayObject):DisplayObject 
		{
			return super.addChild(child);
		}
		public function simpleAddChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			return super.addChildAt(child, index);
		}
		
		
		public function updateBehaviours():void
		{
			var _len:int = (_behaviours != null) ? _behaviours.length : 0;
			//trace("is " + ObjectSearch.formatObject(this) + " : _len : " + _len);
			for (var i:int = 0; i < _len; i++) {
				var _b:Behaviour = Behaviour(_behaviours[i]);
				//trace(" -- _b : " + _b);
				_b.update();
			}
		}
		public function initBehaviours():void
		{
			
			var _len:int = (_behaviours != null) ? _behaviours.length : 0;
			for (var i:int = 0; i < _len; i++) {
				var _b:Behaviour = Behaviour(_behaviours[i]);
				_b.init();
			}
		}
		
		
		
		
		
		
		public function initBtnEffect():void 
		{
			if (_btneffect != "") {
				var _btnEffectHandler:BtnEffectHandler = new BtnEffectHandler();
				_btnEffectHandler.init(this, _btneffect);
			}
		}
		
		
		
		public function initOnClick(_dynamicIndex:int):void
		{
			if (_bInitClick) return;
			
			if (_onclick != null) initOnClickSub(_dynamicIndex, MouseEvent.CLICK, _onclick);
			if (_onmouseover != null) initOnClickSub(_dynamicIndex, MouseEvent.MOUSE_OVER, _onmouseover);
			if (_onmouseout != null) initOnClickSub(_dynamicIndex, MouseEvent.MOUSE_OUT, _onmouseout);
			if (_onmousedown != null) initOnClickSub(_dynamicIndex, MouseEvent.MOUSE_DOWN, _onmousedown);
			
		}
		
		
		
		private function initOnClickSub(_dynamicIndex:int, _mouseevent:String, _value:String):void
		{
			_bInitClick = true;
			
			var _tabinst:Array = _value.split(OnClickHandler.INSTRUCTION_SEPARATOR);
			for (var i:* in _tabinst) {
				var _inst:String = _tabinst[i];
				var _onClickHandler:OnClickHandler = new OnClickHandler(this, _dynamicIndex);
				_onClickHandler.init(_mouseevent, _inst);
				
			}
		}
		
		public function instanciateTemplate():void
		{
			var _class:Class = getDefinitionByName(_template) as Class;
			_objtpl = Sprite(new _class());
		}
		
		
		public function initTemplate():void
		{
			initTemplateRec(_objtpl, this, 0);
		}
		
		
		
		
		
		private function initTemplateRec(_objtpl:DisplayObjectContainer, _container:DisplayObjectContainer, _lvl:int):Boolean
		{
			var _numChildren:int = _objtpl.numChildren;
			var _autoSucess:Boolean = false;
			
			for (var i:int = _numChildren - 1; i >= 0; i--)
			{
				var _child:DisplayObject = _objtpl.getChildAt(i);
				var _iscomplexitem:Boolean = false;
				
				
				var _name:String = _child.name;
				if (_name.substr(0, 1) == "$") {
					//elmt complexe
					_name = _name.substr(1, _name.length - 1);
					_iscomplexitem = true;
					
					var _dobj:DisplayObject = this.getChildByName(_name);
					if (_dobj != null) {
						
						var _childsuccess:Boolean = false;
						_autoSucess = true;
						
						if (_child is DisplayObjectContainer && (!(_dobj is InterfaceSprite) || InterfaceSprite(_dobj).template == "")) {
							var _dobjchild:DisplayObjectContainer = DisplayObjectContainer(_child);
							_childsuccess = initTemplateRec(_dobjchild, _dobjchild, _lvl + 1);
						}
						
						
						if (!_childsuccess) {
							
							if (_lvl > 0) _child.visible = false;
							_container.addChildAt(_dobj, 0);
							
							if (_dobj is LayoutSprite) {
								var _ls:LayoutSprite = LayoutSprite(_dobj);
								_ls.marginLeft = _child.x + "px";
								_ls.marginTop = _child.y + "px";
							}
							else{
								_dobj.x = _child.x;
								_dobj.y = _child.y;
							}
							
							//reconnaissance de certaines class
							if (_dobj is Image) {
								_dobj.width = _child.width;
								_dobj.height = _child.height;
								Image(_dobj).resizeType = Image.CROP_FIT;
							}
							else if (_dobj is Text) {
								_dobj.width = _child.width;
							}
						}
						else if (_lvl == 0) {
							this.addChildAt(_child, 0);
						}
					}
					else throw new Error("complex elmt with name \"" + _name + "\" was not found in " + this + ", " + this.name+", template : "+this.template);
					
				}
				else if (_lvl == 0) {
					//elmt simple
					//trace("add elmt simple " + _child);
					this.addChildAt(_child, 0);
				}
				
			}
			return _autoSucess;
		}
		
		
		
		//_____________________________________________________________________________
		//set / get
		
		public function get template():String {return _template;}
		
		public function set template(value:String):void { _template = value; }
		
		public function get objtpl():Sprite {return _objtpl;}
		
		public function get ascodeInstance():ASCode {return _ascodeInstance;}
		
		public function set ascodeInstance(value:ASCode):void {_ascodeInstance = value;}
		
		public function get behaviours():Array { return _behaviours; }
		
		public function set touchable(_value:Boolean):void
		{
			_touchable = _value;
			this.mouseEnabled = _value;
			this.mouseChildren = _value;
		}
		public function get touchable():Boolean
		{
			return _touchable;
		}
		
		
		public function set maskDef(value:String):void 
		{
			var _tab:Array = value.split(",");
			var _len:int = _tab.length;
			if (_len != 2 && _len != 4) throw new Error("wrong format for property \"maskDef\" (" + value + ") format must be x1,y1,x2,y2 or x2,y2");
			
			var _x1:Number = (_len == 2) ? 0 : Number(Math.round(_tab[0]));
			var _y1:Number = (_len == 2) ? 0 : Number(Math.round(_tab[1]));
			var _x2:Number = (_len == 2) ? Number(Math.round(_tab[0])) : Number(_tab[2]);
			var _y2:Number = (_len == 2) ? Number(Math.round(_tab[1])) : Number(_tab[3]);
			//trace("_x1 : " + _x1 + ", _y1 : " + _y1 + ", _x2 : " + _x2 + ", _y2 : " + _y2);
			
			var _nbchild:int = this.numChildren;
			for (var i:int = _nbchild - 1; i >= 0; i--)
			{
				var _child:DisplayObject = this.getChildAt(i);
				if (_child.name == "is_mask")  this.removeChildAt(i);
			}
			
			var _mask:Sprite = new Sprite();
			_mask.name = "is_mask";
			var _g:Graphics = _mask.graphics;
			_g.clear();
			_g.beginFill(0x00ff00);
			_g.drawRect(_x1, _y1, _x2 - _x1, _y2 - _y1);
			simpleAddChild(_mask);
			this.mask = _mask;
			
			_maskDef = new Rectangle(_x1, _y1, _x2 - _x1, _y2 - _y1);
		}
		
		
		
		
		public function set onclick(value:String):void {_onclick = value;}
		public function set onmouseover(value:String):void {_onmouseover = value;}
		public function set onmouseout(value:String):void {_onmouseout = value;}
		public function set onmousedown(value:String):void {_onmousedown = value;}
		
		
		public function set btneffect(value:String):void { _btneffect = value; }
		
		public function set clickableSprite(value:Boolean):void { _clickableSprite = value; }
		
		public function get clickableSprite():Boolean { return _clickableSprite; }
		
		
		//_______________________________________________
		
		public function get clickableMargin():Number {return _clickableMargin;}
		
		public function set clickableMargin(value:Number):void {_clickableMargin = value;}
		
		
		
		
		
		
		
		
		private static function tracelvl(_msg:String, _lvl:int):void
		{
			var _space:String = "";
			for (var i:int = 0; i < _lvl; i++) _space += "   ";
			trace(_space + _msg);
		}
		
		
		
		
		
		//_____________________________________________________________________________
		//private functions
		
		private function registerChild(child:DisplayObject):void
		{
			var _len:int = (_behaviours != null) ? _behaviours.length : 0;
			_behaviourChildrens.push(child);
			for (var i:int = 0; i < _len; i++) 
			{
				var _behaviour:Behaviour = Behaviour(_behaviours[i]);
				_behaviour.add(child);
			}
		}
		
		
		
		
		
		
		
		//____________________________________________________________________________________________
		//events
		
		
	}

}

/*
2 types de behaviour

- autonome qui s'init (Menu)
- inotonome, qui s'update qd on le sait de l'exterieur (Layout)


*/