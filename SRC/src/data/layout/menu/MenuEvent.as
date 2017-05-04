package data.layout.menu{
	
	
	import flash.events.Event;
	public class MenuEvent extends Event{
		
		public static var CLICK:String = "MenuEvent_click";
		public static var ROLLOVER:String = "MenuEvent_rollover";
		public static var ROLLOUT:String = "MenuEvent_rollout";
		public static var MOVE:String = "MenuEvent_move";
		
		public var id:int;
		public var id_recursives:Array;
		
		public function MenuEvent(type:String, _id:int) 
		{ 
			super(type);
			id = _id;
			id_recursives = new Array();
		}
		
		public override function toString():String
		{
			var str:String = super.toString() + " [";
			str += "id : "+id;
			str += "]";
			return str;
		}
		
	}
	
}