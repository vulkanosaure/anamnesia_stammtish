package events 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author vinc
	 */
	public class BroadCaster 
	{
		private static var _evtDispatcher:EventDispatcher;
		
		public function BroadCaster() 
		{
			throw new Error("is static");
		}
		
		
		public static function addEventListener(_evtname:String, _handler:Function):void
		{
			if (_evtDispatcher == null) _evtDispatcher = new EventDispatcher();
			_evtDispatcher.addEventListener(_evtname, _handler);
		}
		
		public static function dispatchEvent(_evt:Event):void
		{
			if (_evtDispatcher == null) _evtDispatcher = new EventDispatcher();
			_evtDispatcher.dispatchEvent(_evt);
		}
		
	}

}