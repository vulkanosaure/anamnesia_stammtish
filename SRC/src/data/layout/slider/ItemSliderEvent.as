package data.layout.slider{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	public class ItemSliderEvent extends Event{
		
		// Ajouts de Hugo le 12/07/2010
		// END_SLIDE et INIT_ITEMS_OK

		public static var PREV_DISABLE:String  = "ItemSliderEvent_PREV_DISABLE";
		public static var NEXT_DISABLE:String  = "ItemSliderEvent_NEXT_DISABLE";
		public static var PREV_ENABLE:String   = "ItemSliderEvent_PREV_ENABLE";
		public static var NEXT_ENABLE:String   = "ItemSliderEvent_NEXT_ENABLE";
		public static var START_SLIDE:String   = "ItemSliderEvent_START_SLIDE";
		public static var END_SLIDE:String     = "ItemSliderEvent_END_SLIDE";
		public static var GOTO:String     = "ItemSliderEvent_GOTO";
		public static var INIT_ITEMS_OK:String = "ItemSliderEvent_INIT_ITEMS_OK";
		public var item_selected:DisplayObject;
		public var index:int;
		
		public function ItemSliderEvent(type:String) 
		{ 
			super(type);
		}
		
		public override function toString():String
		{
			var str:String = "";
			return str;
		}
		
	}
	
}