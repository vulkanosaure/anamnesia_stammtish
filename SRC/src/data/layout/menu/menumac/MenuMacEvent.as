package data.layout.menu.menumac 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vincent
	 */
	public class MenuMacEvent extends Event 
	{
		public static const START_TWEEN:String = "startTween";
		public static const ENTER_TWEEN:String = "enterTween";
		public static const END_TWEEN:String = "endTween";
		
		
		public function MenuMacEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new MenuMacEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MenuMacEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}