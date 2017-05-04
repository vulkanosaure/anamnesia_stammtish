package data.video {
	
	
	import flash.events.Event;
	public class VideoEvent extends Event{
		
		
		public var obj:Object;
		public static const META_DATA:String = "onMetaData";
		public static const LOADING:String = "videoLoading";
		public static const LOADED:String = "videoLoaded";
		public static const FINISHED:String = "videoFinished";
		public static const PLAY:String = "play";
		public static const STOP:String = "stop";
		
		
		public function VideoEvent(type:String) 
		{ 
			super(type);
		}
		
		public override function toString():String
		{
			var str:String = super.toString() + "\n[";
			for(var i in obj) str +=  i+":"+obj[i]+", ";
			str += "]";
			return str;
		}
		
	}
	
}