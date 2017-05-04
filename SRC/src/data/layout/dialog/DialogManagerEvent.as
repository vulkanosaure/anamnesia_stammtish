package data.layout.dialog 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vincent
	 */
	public class DialogManagerEvent extends Event 
	{
		public static const CLOSE:String = "closeDialog";
		public var id_dialog:String;
		
		
		public function DialogManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new DialogManagerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DialogManagerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}