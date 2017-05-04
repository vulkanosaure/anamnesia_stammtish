package data.form.autocompletion 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vincent
	 */
	public class AutoCompletionEvent extends Event 
	{
		public static const SELECT_ENTRY:String = "selectEntry";
		public var identry:String;
		public var typeentry:String;
		
		public function AutoCompletionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new AutoCompletionEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AutoCompletionEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}