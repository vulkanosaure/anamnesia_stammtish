package data2.display.scrollbar {
	
	
	import flash.events.Event;
	public class ScrollbarEvent extends Event{
		
		public static var SCROLL_SHOW:String = "scrollShow";
		public static var SCROLL_HIDE:String = "scrollHide";
		
		
		public function ScrollbarEvent(type:String) 
		{ 
			super(type);
		}
		
		public override function toString():String
		{
			var str:String = super.toString() + "\n[";
			
			str += "]";
			return str;
		}
		
	}
	
}