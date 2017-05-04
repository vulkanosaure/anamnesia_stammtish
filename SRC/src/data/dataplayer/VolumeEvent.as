package data.dataplayer {
	
	
	import flash.events.Event;
	
	public class VolumeEvent extends Event{
		
		public static var VOLUME_CHANGE:String = "volumeChange";
		public var volume:Number;
		
		public function VolumeEvent(type:String, _volume:Number)
		{ 
			super(type);
			volume = _volume;
		}
		
		
		
	}
	
}