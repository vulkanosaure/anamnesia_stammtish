package data.diaporama {
	
	
	import flash.events.Event;
	
	public class DiapoEvent extends Event{
		
		public static var FIRST_IMG_LOADED:String = "firstImgLoaded";
		public static var END_LOOP:String = "endLoop";		
		public static var DISPLAY_IMG:String = "displayImg";
		
		public var id_image:int;
		public var text:String;
		
		
		public function DiapoEvent(type:String) 
		{ 
			super(type);
		}
		
		public override function toString():String
		{
			var str:String = super.toString();
			str += "\nid_image : "+id_image+", text : "+text;
			return str;
		}
	}
	
}