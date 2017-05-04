package data.dataplayer {
	import flash.events.Event;
	public class TimelineEvent extends Event{
		
		public static var CHANGE_PLAYHEAD:String = "changePlayhead";
		public var percent:Number;
		public function TimelineEvent(type:String) 
		{
			super(type);
			
		}
	
	}
	
}