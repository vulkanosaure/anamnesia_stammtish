package data2.fx.swipe 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vinc
	 */
	public class SwipeEvent extends Event 
	{
		public var delta:int;
		public static const SWIPE:String = "swipe";
		
		public function SwipeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new SwipeEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SwipeEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}