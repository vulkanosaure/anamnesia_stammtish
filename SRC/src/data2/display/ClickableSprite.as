package data2.display 
{
	import data2.InterfaceSprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public class ClickableSprite
	{
		public static const CLICKABLE_SPRITE_NAME:String = "clickable_sprite";
		public static var DEBUG:Boolean = false;
		private static var list_dobjc:Array;
		
		public function ClickableSprite() 
		{
			
		}
		
		public static function updateClickable(_dobjc:DisplayObjectContainer):void
		{
			//trace("ClickableSprite");
			if (list_dobjc == null) list_dobjc = new Array();
			if (list_dobjc.indexOf(_dobjc) == -1) list_dobjc.push(_dobjc);
			
			var _bg:Sprite;
			
			var _childtest:DisplayObject = _dobjc.getChildByName(CLICKABLE_SPRITE_NAME);
			if (_childtest != null) {
				_bg = Sprite(_childtest);
			}
			else {
				_bg = new Sprite();
				_dobjc.addChild(_bg);
				_bg.name = CLICKABLE_SPRITE_NAME;
				_bg.alpha = (DEBUG) ? 0.25 : 0.0;
			}
			
			
			var _margin:Number = 7;	//default
			
			var _margin_left:Number = NaN;
			var _margin_right:Number = NaN;
			var _margin_top:Number = NaN;
			var _margin_bottom:Number = NaN;
			
			if (_dobjc is InterfaceSprite) {
				var _is:InterfaceSprite = InterfaceSprite(_dobjc);
				
				_margin_left = getMarginValue(_is, "left");
				_margin_right = getMarginValue(_is, "right");
				_margin_top = getMarginValue(_is, "top");
				_margin_bottom = getMarginValue(_is, "bottom");
			}
			
			if (isNaN(_margin_left)) _margin_left = _margin;
			if (isNaN(_margin_right)) _margin_right = _margin;
			if (isNaN(_margin_top)) _margin_top = _margin;
			if (isNaN(_margin_bottom)) _margin_bottom = _margin;
			
			
			
			
			_dobjc.removeChild(_bg);
			
			var _bounds:Rectangle;
			
			if (_dobjc is InterfaceSprite) {
				var _is:InterfaceSprite = InterfaceSprite(_dobjc);
				if (!isNaN(_is.layoutWidth) && !isNaN(_is.layoutHeight)) {
					_bounds = new Rectangle(0, 0, _is.layoutWidth, _is.layoutHeight);
				}
			}
			
			if (_bounds == null) _bounds = _dobjc.getBounds(_dobjc);
			
			_dobjc.addChild(_bg);
			var g:Graphics = _bg.graphics;
			g.clear();
			g.beginFill(0xFF0000);
			g.drawRect(_bounds.x - _margin_left, _bounds.y - _margin_top, _bounds.width + _margin_left + _margin_right, _bounds.height + _margin_top + _margin_bottom);
			
			
			
			var _len:int = _dobjc.numChildren;
			for (var i:int = 0; i < _len; i++) 
			{
				var _child:DisplayObject = _dobjc.getChildAt(i);
				if (_child != _bg) {
					if (_child is InteractiveObject) {
						if (_child is TextField) TextField(_child).selectable = false;
						InteractiveObject(_child).mouseEnabled = false;
						if (_child is DisplayObjectContainer) {
							DisplayObjectContainer(_child).mouseChildren = false;
						}
						
					}
				}
			}
			
			_dobjc.mouseEnabled = false;
			_bg.mouseEnabled = true;
			_bg.mouseChildren = true;
			_bg.buttonMode = true;
			
		}
		
		
		static private function getMarginValue(_is:InterfaceSprite, _side:String):Number 
		{
			var _output:Number = NaN;
			var _propside:String = (_side == "left" || _side == "right") ? "cm_horiz" : "cm_vert";
			var _propspec:String = "cm_" + _side;
			
			if (!isNaN(_is.clickableMargin)) _output = _is.clickableMargin;
			if (!isNaN(_is[_propside])) _output = _is[_propside];
			if (!isNaN(_is[_propspec])) _output = _is[_propspec];
			
			return _output;
		}
		
		
		
		
		
		public static function preventMouseEvent(_iobj:InteractiveObject):void
		{
			if (_iobj is TextField) TextField(_iobj).selectable = false;
			_iobj.mouseEnabled = false;
			if (_iobj is DisplayObjectContainer) {
				var _dobjc:DisplayObjectContainer = DisplayObjectContainer(_iobj);
				_dobjc.mouseChildren = false;
				var _len:int = _dobjc.numChildren;
				for (var i:int = 0; i < _len; i++) {
					var _child:DisplayObject = _dobjc.getChildAt(i);
					if (_child is InteractiveObject) preventMouseEvent(InteractiveObject(_child));
				}
			}
		}
		
		
		
		
		
		static public function isClickable(_dobjc:DisplayObjectContainer):Boolean 
		{
			return (_dobjc.getChildByName(CLICKABLE_SPRITE_NAME) != null);
		}
		
		
		
		static public function updateAll():void
		{
			var _len:int = (list_dobjc == null) ? 0 : list_dobjc.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _dobjc:DisplayObjectContainer = DisplayObjectContainer(list_dobjc[i]);
				updateClickable(_dobjc);
			}
		}
		
		static public function hideAll():void
		{
			var _len:int = (list_dobjc == null) ? 0 : list_dobjc.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _dobjc:DisplayObjectContainer = DisplayObjectContainer(list_dobjc[i]);
				
				var _clickableSprite:DisplayObject = _dobjc.getChildByName(CLICKABLE_SPRITE_NAME);
				if(_clickableSprite != null) _dobjc.removeChild(_clickableSprite);
			}
		}
	}

}