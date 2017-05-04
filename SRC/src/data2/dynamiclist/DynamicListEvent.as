package data2.dynamiclist 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class DynamicListEvent extends Event 
	{
		public static const ITEM_READY:String = "itemReady";
		
		public var items:Array;
		
		
		public function DynamicListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new DynamicListEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DynamicListEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}