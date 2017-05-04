package data.facebook.dialog 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vincent
	 */
	public class DialogFacebookEvent extends Event 
	{
		public static const CLOSE:String = "dialogFacebookClose";
		public static const VALID:String = "dialogFacebookValid";
		public static const UPDATE_BODY:String = "dialogFacebookUpdateBody";
		
		
		
		public function DialogFacebookEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new DialogFacebookEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DialogFacebookEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}