package data.layout.timeline 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vincent
	 */
	public class TimelineEvent extends Event 
	{
		public static const USER_CHANGE:String = "userChange";
		public var progress:Number;
		
		public function TimelineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new TimelineEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TimelineEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}