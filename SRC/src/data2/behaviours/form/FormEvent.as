package data2.behaviours.form 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class FormEvent extends Event 
	{
		public static const SUBMIT:String = "formSubmit";
		public static const COMPLETE_SERVER:String = "formCompleteServer";
		public static const ERROR_SUBMIT:String = "formErrorSubmit";
		public static const VALID_SUBMIT:String = "validSubmit";
		
		
		public var listErrors:Array;
		public var serverOutput:Object;
		public var submitID:String;
		public var inputs:Object;
		
		
		
		public function FormEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new FormEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("FormEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}