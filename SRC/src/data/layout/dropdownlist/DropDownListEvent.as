package data.layout.dropdownlist {
	
	
	import flash.events.Event;
	public class DropDownListEvent extends Event{
		
		public var idNode:int;
		public var header:DropDownListHeader;
		public static var CLICK_HEADER:String = "DropDownListEvent_click_header";
		public static var OVER_HEADER:String = "DropDownListEvent_over_header";
		public static var OUT_HEADER:String = "DropDownListEvent_out_header";
		public static var OPEN_ITEM:String = "DropDownListEvent_open_item";
		public static var CLOSE_ITEM:String = "DropDownListEvent_close_item";
		public static var UPDATE:String = "DropDownListEvent_update";
		public static var TWEEN:String = "DropDownListEvent_tween";
		
		public function DropDownListEvent(type:String) 
		{ 
			super(type);
		}
		
		public override function toString():String
		{
			var str:String = super.toString() + "\n[";
			str += "idNode : "+this.idNode;
			str += "]";
			return str;
		}
		
		
	}
	
}