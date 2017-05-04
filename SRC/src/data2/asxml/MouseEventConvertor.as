package data2.asxml 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	/**
	 * ...
	 * @author Vinc
	 */
	public class MouseEventConvertor 
	{
		
		public function MouseEventConvertor() 
		{
			throw new Error("is static");
			
		}
		
		
		
		
		
		
		public static function addMouseListener(_target:DisplayObject, _type:String, _handler:Function):void 
		{
			if (Multitouch.supportsTouchEvents) _type = mouseToTouchEvent(_type);
			_target.addEventListener(_type, _handler);
		}
		
		public static function removeMouseListener(_target:DisplayObject, _type:String, _handler:Function):void 
		{
			if (Multitouch.supportsTouchEvents) _type = mouseToTouchEvent(_type);
			_target.removeEventListener(_type, _handler);
		}
		
		
		public static function mouseToTouchEvent(_type:String):String 
		{
			var _output:String;
			
			if (_type == MouseEvent.MOUSE_DOWN) _output = TouchEvent.TOUCH_BEGIN;
			else if (_type == MouseEvent.MOUSE_UP) _output = TouchEvent.TOUCH_END;
			else if (_type == MouseEvent.MOUSE_MOVE) _output = TouchEvent.TOUCH_MOVE;
			else throw new Error("can't convert event '" + _type + "'");
			
			return _output;
		}
		
		
		
	}

}