package timertouch 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vinc
	 */
	public class TimerTouchEvent extends Event 
	{
		public static const NO_TOUCH:String = "notouch";
		static public const WAKE_UP:String = "wakeUp";
		
		public function TimerTouchEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new TimerTouchEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TimerTouchEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}