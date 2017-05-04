package data.utils 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Vincent
	 */
	public class RealTimer extends EventDispatcher
	{
		//_______________________________________________________________________________
		// properties
		
		var timer:Timer;
		var cadence:Number;
		var serverscript:String;
		var _repeatCount:uint;
		
		var date_start:Number;
		var date_end:Number;
		var date_pause:Number;
		
		var urlloader:URLLoader;
		var serverTime:Number;
		
		
		
		
		public function RealTimer(_cadence:Number, _serverscript:String) 
		{
			timer = new Timer(_cadence);
			timer.addEventListener(TimerEvent.TIMER, onTimerEvent);
			
			cadence = _cadence;
			serverscript = _serverscript;
			
			this.reset();
		}
		
		
		public function reset():void
		{
			
		}
		
		
		public function start():void
		{
			timer.start();
		}
		
		public function stop():void
		{
			timer.stop();
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		private function updateServerTime():void
		{
			urlloader = new URLLoader(new URLRequest(serverscript));
			urlloader.dataFormat = URLLoaderDataFormat.TEXT;
			urlloader.addEventListener(Event.COMPLETE, onGetServerTime);
		}
		
		private function onUpdateServerTime(e:Event):void 
		{
			trace("onGetServerTime");
			serverTime = Number(URLLoader(e.target).data;
			trace("serverTime : " + serverTime);
			
			
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}