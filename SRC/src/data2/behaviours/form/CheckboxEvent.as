package data2.behaviours.form 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vincent
	 */
	public class CheckboxEvent extends Event 
	{
		public static const CHECK:String = "check";
		public static const UNCHECK:String = "unCheck";
		
		
		public function CheckboxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new CheckboxEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CheckboxEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}