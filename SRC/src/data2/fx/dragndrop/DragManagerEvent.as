package data2.fx.dragndrop 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class DragManagerEvent extends Event 
	{
		public static const COMPLETE:String = "dragManager_complete";
		public static const DRAG:String = "dragManager_drag";
		public static const DROP:String = "dragManager_drop";
		public static const DROP_ERROR:String = "dragManager_drop_error";
		
		
		public function DragManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new DragManagerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DragManagerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}