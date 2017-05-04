package data2.net.imageloader 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class ImageLoaderEvent extends Event 
	{
		public static const PROGRESS:String = "ImageLoaderEvent_PROGRESS";
		public static const COMPLETE:String = "ImageLoaderEvent_COMPLETE";
		
		public var group:String;
		public var progress:Number;
		
		
		public function ImageLoaderEvent(type:String, _group:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			group = _group;
		} 
		
		public override function clone():Event 
		{ 
			return new ImageLoaderEvent(type, group, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ImageLoaderEvent", "type", "group", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}