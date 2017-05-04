package data.dataplayer {
	import flash.events.Event;
	public class ControlEvent extends Event{
		
		public static var PLAY:String = "play";
		public static var PAUSE:String = "pause";
		public static var REWIND:String = "rewind";
		
		
		public function ControlEvent(type:String) 
		{
			super(type);
			
		}
	
	}
	
}