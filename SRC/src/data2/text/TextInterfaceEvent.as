package data2.text 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class TextInterfaceEvent extends Event 
	{
		public static const UPDATE:String = "text_update";
		public static const LINK:String = "link";
		
		public var label:String;
		
		public function TextInterfaceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new TextInterfaceEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TextEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}