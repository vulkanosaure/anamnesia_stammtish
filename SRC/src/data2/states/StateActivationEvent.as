package data2.states 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class StateActivationEvent extends Event 
	{
		public static const ACTIVATE:String = "stateActivationActivate";
		public static const DEACTIVATE:String = "stateActivationDeactivate";
		
		public function StateActivationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new StateActivationEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("StateActivationEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}