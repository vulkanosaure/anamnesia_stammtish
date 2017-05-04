package data.fx.mousepointer 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vincent
	 */
	public class MousePointerEvent extends Event 
	{
		public static const CLICK:String = "MP_click";
		
		
		public function MousePointerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new MousePointerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MousePointerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}