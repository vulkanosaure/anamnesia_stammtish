/*
 * Philosophie par rapport aux manipulation externes 
 * 
 * il faut 2 propriété
 * x standard qui touchera aux propriétés de layout
 * super_x qui touchera juste au x


*/	

package data2.layoutengine 
{
	import data2.asxml.ObjectSearch;
	import data2.display.ClickableSprite;
	import data2.parser.ColorDefinitions;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Vincent
	 */
	public class LayoutSprite extends Sprite
	{
		public static const RESIZE_NONE:String = "none";
		public static const RESIZE_PARENT2CHILD:String = "parent2child";
		public static const RESIZE_CHILD2PARENT:String = "child2parent";
		
		public static const RESIZE_OBJECT_NONE:String = "none";
		public static const RESIZE_OBJECT_SELF:String = "self";
		
		
		private var _classname:String;
		private var _id:String;
		
		
		//padding concerne les marges du child par rap au container
		private var _marginLeft:MarginObject = new MarginObject();
		private var _marginRight:MarginObject = new MarginObject();
		private var _marginTop:MarginObject = new MarginObject();
		private var _marginBottom:MarginObject = new MarginObject();
		
		//margin concerne les marges du container par rap au child
		private var _paddingLeft:MarginObject = new MarginObject();
		private var _paddingRight:MarginObject = new MarginObject();
		private var _paddingTop:MarginObject = new MarginObject();
		private var _paddingBottom:MarginObject = new MarginObject();
		
		private var _widthResizeType:String = RESIZE_NONE;
		private var _heightResizeType:String = RESIZE_NONE;
		
		private var _resizeObject:String = RESIZE_OBJECT_NONE;
		private var _resizeDisplayObject:DisplayObject;
		
		private var _layoutWidth:Number;
		private var _layoutHeight:Number;
		
		private var _maxWidth:Number;
		private var _maxHeight:Number;
		private var _minWidth:Number;
		private var _minHeight:Number;
		
		
		
		private var _containerMinWidth:Number;
		private var _containerMinHeight:Number;
		
		private var _overflowHidden:Boolean = false;
		
		//internal use only
		private var _minimumwidth:Number;
		private var _minimumheight:Number;
		
		private var _enabled:Boolean = false;
		private var _targetskin:String;
		
		//graphics
		
		private var _backgroundColor:String;
		private var _border:String;
		
		private var _backgroundColor_color:int;
		private var _backgroundColor_alpha:Number;
		
		private var _border_width:Number;
		private var _border_style:String;
		private var _border_color:uint;
		
		private var _enableInvalid:Boolean = true;
		
		
		
		
		public function LayoutSprite() 
		{
			//trace("construct LayoutSprite");
			
		}
		
		
		//_______________________________________________________
		//public functions
		
		public function layout_resize_width(_width:Number):void
		{
			//trace("layout_resize_width(" + _width + ") "+this.name+", "+this.classname+", _resizeObject : "+_resizeObject);
			if (_resizeObject == RESIZE_OBJECT_SELF) {
				super.width = _width;
			}
			else if (_resizeObject != RESIZE_OBJECT_NONE) {
				if (_resizeDisplayObject is LayoutSprite) LayoutSprite(_resizeDisplayObject).resizeObject = RESIZE_OBJECT_SELF;
				_resizeDisplayObject.width = _width;
			}
		}
		
		public function layout_resize_height(_height:Number):void
		{
			//trace("layout_resize_height(" + _height + ") "+this.name+", "+this.classname+", _resizeObject : "+_resizeObject);
			if (_resizeObject == RESIZE_OBJECT_SELF) {
				super.height = _height;
			}
			else if (_resizeObject != RESIZE_OBJECT_NONE) {
				_resizeDisplayObject.height = _height;
			}
		}
		
		
		override public function set width(value:Number):void 
		{
			layout_resize_width(value);
		}
		
		override public function set height(value:Number):void 
		{
			layout_resize_height(value);
		}
		
		override public function get width():Number 
		{
			if (isNaN(_layoutWidth)) {
				var _w:Number = super.width;
				if (!isNaN(_minWidth) && _w < _minWidth) _w = _minWidth;
				return _w;
			}
			else return _layoutWidth;
		}
		
		override public function get height():Number 
		{
			//trace("LayoutSprite " + ObjectSearch.formatObject(this) + ".get height : " + super.height + ", " + _layoutHeight + ")");
			//ObjectSearch.debugDisplayObject(this);
			
			if (isNaN(_layoutHeight)) {
				var _h:Number = super.height;
				if (!isNaN(_minHeight) && _h < _minHeight) _h = _minHeight;
				return _h;
			}
			else return _layoutHeight;
		}
		
		
		
		
		//_______________________________________________________
		//set / get
		
		
		public function get classname():String {return _classname;}
		
		public function set classname(value:String):void { _classname = value; }
		
		public function get id():String {return _id;}
		
		public function set id(value:String):void {_id = value;}
		
		
		public function set marginLeft(value:*):void
		{
			_marginLeft.set(value);
			enable();
			invalidLayout();
		}
		public function set marginRight(value:*):void
		{
			_marginRight.set(value);
			enable();
			invalidLayout();
		}
		public function set marginTop(value:*):void
		{
			_marginTop.set(value);
			enable();
			invalidLayout();
		}
		public function set marginBottom(value:*):void
		{
			_marginBottom.set(value);
			enable();
			invalidLayout();
		}
		
		
		public function set paddingLeft(value:String):void
		{
			_paddingLeft.set(value);
			invalidLayout(true);
		}
		public function set paddingRight(value:String):void
		{
			_paddingRight.set(value);
			invalidLayout(true);
		}
		public function set paddingTop(value:String):void
		{
			_paddingTop.set(value);
			invalidLayout(true);
		}
		public function set paddingBottom(value:String):void
		{
			_paddingBottom.set(value);
			invalidLayout(true);
		}
		
		
		public function get paddingbottom_type():String { return _paddingBottom.type; }
		public function get paddingbottom_value():Number { return _paddingBottom.value; }
		public function get paddingtop_type():String { return _paddingTop.type; }
		public function get paddingtop_value():Number { return _paddingTop.value; }
		public function get paddingright_type():String { return _paddingRight.type; }
		public function get paddingright_value():Number { return _paddingRight.value; }
		public function get paddingleft_type():String { return _paddingLeft.type; }
		public function get paddingleft_value():Number { return _paddingLeft.value; }
		public function get marginbottom_type():String { return _marginBottom.type; }
		public function get marginbottom_value():Number { return _marginBottom.value; }
		public function get margintop_type():String { return _marginTop.type; }
		public function get margintop_value():Number { return _marginTop.value; }
		public function get marginright_type():String { return _marginRight.type; }
		public function get marginright_value():Number { return _marginRight.value; }
		public function get marginleft_type():String { return _marginLeft.type; }
		public function get marginleft_value():Number { return _marginLeft.value; }
		
		
		
		
		
		override public function set x(value:Number):void 
		{
			super.x = value;
			this.marginLeft = value + "px";
		}
		override public function set y(value:Number):void 
		{
			super.y = value;
			this.marginTop = value + "px";
		}
		
		
		
		
		
		
		public function set super_x(value:Number):void
		{
			super.x = value;
		}
		public function set super_y(value:Number):void
		{
			super.y = value;
		}
		
		public function get super_x():Number { return this.x; }
		public function get super_y():Number { return this.y; }
		
		
		
		public function get layoutHeight():Number { return _layoutHeight; }
		
		public function set layoutHeight(value:Number):void 
		{
			_layoutHeight = value;
			invalidLayout();
		}
		
		
		public function get layoutWidth():Number { return _layoutWidth; }
		
		public function set layoutWidth(value:Number):void 
		{
			_layoutWidth = value;
			invalidLayout();
		}
		
		
		public function get containerMinHeight():Number { return _containerMinHeight; }
		
		public function set containerMinHeight(value:Number):void 
		{
			_containerMinHeight = value;
		}
		
		public function get containerMinWidth():Number { return _containerMinWidth; }
		
		public function set containerMinWidth(value:Number):void 
		{
			_containerMinWidth = value;
		}
		
		
		
		
		
		public function get heightResizeType():String { return _heightResizeType; }
		
		public function set heightResizeType(value:String):void 
		{
			if (value != RESIZE_NONE && value != RESIZE_PARENT2CHILD && value != RESIZE_CHILD2PARENT) throw new Error("wrong value for param heightResizeType ("+value+"), possible values : "+RESIZE_NONE+", "+RESIZE_PARENT2CHILD+", "+RESIZE_CHILD2PARENT);
			_heightResizeType = value;
			invalidLayout();
		}
		
		public function get widthResizeType():String { return _widthResizeType; }
		
		public function set widthResizeType(value:String):void 
		{
			if (value != RESIZE_NONE && value != RESIZE_PARENT2CHILD && value != RESIZE_CHILD2PARENT) throw new Error("wrong value for param heightResizeType ("+value+"), possible values : "+RESIZE_NONE+", "+RESIZE_PARENT2CHILD+", "+RESIZE_CHILD2PARENT);
			_widthResizeType = value;
			invalidLayout();
		}
		
		
		public function get overflowHidden():Boolean { return _overflowHidden; }
		
		public function set overflowHidden(value:Boolean):void 
		{
			_overflowHidden = value;
		}
		
		
		
		
		//internal use only
		
		public function get minimumheight():Number { return _minimumheight; }
		
		public function set minimumheight(value:Number):void 
		{
			_minimumheight = value;
		}
		
		public function get minimumwidth():Number { return _minimumwidth; }
		
		public function set minimumwidth(value:Number):void 
		{
			_minimumwidth = value;
		}
		
		
		
		public function get marginLeft():String {return _marginLeft.toString();}
		public function get marginTop():String {return _marginTop.toString();}
		public function get marginRight():String {return _marginRight.toString();}
		public function get marginBottom():String {return _marginBottom.toString();}
		
		public function get enabled():Boolean {return _enabled;}
		
		public function get resizeObject():String {return _resizeObject;}
		
		public function set resizeObject(value:String):void 
		{
			if (value != RESIZE_NONE && value != RESIZE_OBJECT_SELF) {
				var _obj:Object = ObjectSearch.search(this, value);
				if (!(_obj is DisplayObject)) throw new Error("resize-object \"" + _resizeObject + "\" must be a DisplayObject");
				_resizeDisplayObject = DisplayObject(_obj);
			}
			_resizeObject = value;
		}
		
		
		public function get targetskin():String {return _targetskin;}
		
		public function set targetskin(value:String):void { _targetskin = value; }
		
		public function set defaultType(value:String):void
		{
			_marginBottom.defaultType = value;
			_marginLeft.defaultType = value;
			_marginRight.defaultType = value;
			_marginTop.defaultType = value;
		}
		
		
		
		
		public function set backgroundColor(value:String):void 
		{
			_backgroundColor = value;
			_resizeObject = RESIZE_OBJECT_NONE;
			
			var _tab:Array = _backgroundColor.split(",");
			if (_tab.length == 0) throw new Error("wrong format for property \"backgroundColor\" (" + _backgroundColor + "), it must be 'color [alpha]'");
			
			if (_tab.length == 1) _backgroundColor_alpha = 1.0;
			else {
				var _stralpha:String = _tab[1];
				if (!_stralpha.match(/^[\d.]+$/)) throw new Error("wrong format for alpha option in LayoutSprite.backgroundColor (" + _stralpha + ")");
				_backgroundColor_alpha = Number(_stralpha);
			}
			
			var _strcolor:String = _tab[0];
			
			_backgroundColor_color = ColorDefinitions.get(_strcolor, false);
			
		}
		
		
		
		public function set border(value:String):void
		{
			_border = value;
			_resizeObject = RESIZE_OBJECT_NONE;
			
			//border:5px solid red;
			var _tab:Array = _border.split(",");
			var _strwidth:String = _tab[0];
			var _tabwidth:Array = _strwidth.match(/(\d+)px/);
			
			if (_tabwidth.length != 2) throw new Error("wrong format for border-width (" + _strwidth + "), must be '2px'");
			_border_width = Number(_tabwidth[1]);
			
			if (_tab[1] != undefined) _border_style = _tab[1];
			else _border_style = "solid";
			
			if (_tab[2] != undefined) {
				var _strcolor:String = _tab[2];
				_border_color = ColorDefinitions.get(_strcolor, false);
			}
			else _border_color = 0xFF0000;
			
			if (_border_style != "solid") throw new Error("LayoutSprite.border-style : only solid exists for the moment");
			
		}
		
		public function get maxWidth():Number {return _maxWidth;}
		
		public function set maxWidth(value:Number):void {_maxWidth = value;}
		
		public function get maxHeight():Number {return _maxHeight;}
		
		public function set maxHeight(value:Number):void {_maxHeight = value;}
		
		public function set enableInvalid(value:Boolean):void {_enableInvalid = value;}
		
		public function set minWidth(value:Number):void { _minWidth = value; }
		
		public function set minHeight(value:Number):void { _minHeight = value; }
		
		
		
		
		
		public function clearGraphics():void
		{
			var _objGraphics:DisplayObject = this.getChildByName("graphics_sprite");
			if (_objGraphics == null) return;
			var _g:Graphics = Sprite(_objGraphics).graphics;
			_g.clear();
		}
		
		
		
		public function updateGraphics():void
		{
			if (_backgroundColor == null && _border == null) return;
			
			var _objGraphics:DisplayObject = this.getChildByName("graphics_sprite");
			if (_objGraphics == null) {
				_objGraphics = new Sprite();
				var _sp:Sprite = Sprite(_objGraphics);
				_sp.name = "graphics_sprite";
				this.addChildAt(_sp, 0);
				_sp.mouseEnabled = false;
				_sp.mouseChildren = false;
			}
			
			//if (isNaN(_layoutWidth) || isNaN(_layoutHeight)) return;
			
			var _graphicw:Number, _graphich:Number;
			_graphicw = this.width;
			_graphich = this.height;
			
			//var _g:Graphics = this.graphics;
			var _g:Graphics = Sprite(_objGraphics).graphics;
			
			_g.clear();
			var _bounds:Rectangle;
			
			if (_backgroundColor != null) {
				//background color
				
				_bounds = new Rectangle(0, 0, _graphicw, _graphich);
				_g.beginFill(_backgroundColor_color, _backgroundColor_alpha);
				
				//trace("_backgroundColor def " + _backgroundColor_color + ", " + _backgroundColor_alpha);
			}
			
			if (_border != null) {
				//border 
				
				var _type:String = "internal";
				var _width:Number = _graphicw;
				var _height:Number = _graphich;
				var _left:Number, _top:Number, _w:Number, _h:Number;
				
				_left = (_type == "internal") ? _border_width / 2 : -_border_width / 2;
				_top = (_type == "internal") ? _border_width / 2 : -_border_width / 2;
				_w = (_type == "internal") ? _width - _border_width : _width + _border_width;
				_h = (_type == "internal") ? _height - _border_width : _height + _border_width;
				
				_bounds = new Rectangle(_left, _top, _w, _h);
				_g.lineStyle(_border_width, _border_color, 1, false, "normal", CapsStyle.NONE, JointStyle.MITER);
				//trace("_border def : " + _border_width + ", _type : " + _type + ", _width : " + _width + ", _height : " + _height);
				
			}
			
			//trace("_g.drawRect(" + _bounds.left + ", " + _bounds.top + ", " + _bounds.width + ", " + _bounds.height + ")");
			//trace("this.position : " + this.x + ", " + this.y + ", " + this.alpha + ", " + this.visible);
			
			_g.drawRect(_bounds.left, _bounds.top, _bounds.width, _bounds.height);
			
			//update clickablesprite if needed
			if (this.getChildByName(ClickableSprite.CLICKABLE_SPRITE_NAME) != null) {
				ClickableSprite.updateClickable(this);
			}
			
		}
		
		
		
		
		
		
		public function invalidLayout(_useChild:Boolean=false):void
		{
			if (!_enableInvalid) return;
			if (!_useChild) LayoutEngine.invalid(this);
			else {
				var _numChildren:int = this.numChildren;
				for (var i:int = 0; i < _numChildren; i++) 
				{
					var _child:DisplayObject = this.getChildAt(i);
					if (_child is DisplayObjectContainer) LayoutEngine.invalid(DisplayObjectContainer(_child));
				}
			}
		}
		
		
		
		public function invalidLayoutDimensions():void
		{
			if(_widthResizeType == RESIZE_CHILD2PARENT) _layoutWidth = NaN;
			if(_heightResizeType == RESIZE_CHILD2PARENT) _layoutHeight = NaN;
		}
		
		
		public function enable():void
		{
			_enabled = true;
		}
		public function disable():void
		{
			_enabled = false;
		}
		
		
		
		
	}

}