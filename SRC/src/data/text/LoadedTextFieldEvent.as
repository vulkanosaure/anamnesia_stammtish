package data.text 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vincent
	 */
	public class LoadedTextFieldEvent extends Event 
	{
		public static const UPDATE:String = "loadedTextFieldUpdate";
		public static const CSS_LOADED:String = "loadedTextFieldCssLoaded";
		public static const SRC_LOADED:String = "loadedTextFieldSrcLoaded";
		public static const CLICK_LINK:String = "loadedTextFieldClickLink";
		
		public var label:String;
		
		
		public function LoadedTextFieldEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new LoadedTextFieldEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LoadedTextFieldEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}