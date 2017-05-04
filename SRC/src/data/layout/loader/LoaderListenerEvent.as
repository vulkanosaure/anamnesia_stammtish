package data.layout.loader 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vincent
	 */
	public class LoaderListenerEvent extends Event 
	{
		public static const COMPLETE:String = "LoaderListenerEvent_complete";
		public static const PROGRESS:String = "LoaderListenerEvent_progress";
		public var progress:Number;
		
		public function LoaderListenerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new LoaderListenerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LoaderListenerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}