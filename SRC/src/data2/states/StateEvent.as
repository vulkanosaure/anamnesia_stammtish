package data2.states 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class StateEvent extends Event 
	{
		public static const COMPLETE:String = "stateEventComplete";
		public static const GOTO:String = "stateEventGoto";
		public var idstatemanager:String;
		public var idstate:String;
		public var prevstate:String;
		
		public function StateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new StateEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("StateEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}