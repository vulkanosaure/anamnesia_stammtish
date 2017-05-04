package timertouch 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Vinc
	 */
	public class TimerTouch 
	{
		static private var _timer:Timer;
		static private var _evtDispatcher:EventDispatcher;
		static private var _isIddle:Boolean = false;
		
		public function TimerTouch() 
		{
			throw new Error("is static");
		}
		
		
		public static function init(_delay:Number, _stage:Stage):void
		{
			trace("TimerTouch.init(" + _delay + ")");
			_timer = new Timer(_delay * 1000, 1);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
			
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		static private function onMouseDown(e:MouseEvent):void 
		{
			//trace("TimerTouch.onMouseDown");
			setTouch();
		}
		
		static private function onTimer(e:TimerEvent):void 
		{
			//trace("TimerTouch.onTimer " + _timer.currentCount);
			_isIddle = true;
			dispatchEvent(new TimerTouchEvent(TimerTouchEvent.NO_TOUCH));
			
		}
		private static function setTouch():void
		{
			//trace("setTouch isIddle: " + _isIddle);
			_timer.reset();
			_timer.start();
			
			if (_isIddle) {
				_isIddle = false;
				dispatchEvent(new TimerTouchEvent(TimerTouchEvent.WAKE_UP));
			}
			
		}
		
		
		
		
		
		public static function addEventListener(_type:String, _func:Function):void
		{
			if (_evtDispatcher == null) _evtDispatcher = new EventDispatcher();
			_evtDispatcher.addEventListener(_type, _func);
		}
		public static function dispatchEvent(_evt:Event):void
		{
			if (_evtDispatcher == null) _evtDispatcher = new EventDispatcher();
			_evtDispatcher.dispatchEvent(_evt);
		}
		
		
	}

}