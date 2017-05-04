package data2.debug 
{
	import data2.net.URLLoaderManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.system.System;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 
	 */
	public class RealTimeRefresh 
	{
		public static const MODE_REALTIME:String = "modeRealTime";
		public static const MODE_FOCUS:String = "modeFocus";
		
		
		static private const DELAY:Number = 1000;
		private static var SERVER_ENVIRONMENT:Boolean;
		
		private static var _urls:Array;
		private static var _savecontents:Object;
		private static var _timer:Timer;
		private static var _bfirst:Boolean;
		private static var _mode:String;
		private static var _baseContainer:DisplayObjectContainer;
		private static var _bInitDownload:Boolean;
		
		public function RealTimeRefresh() 
		{
			throw new Error("is static");
			
		}
		
		
		
		//_____________________________________________________________
		//public functions
		
		public static function add(_url:String):void
		{
			if (_urls == null) _urls = new Array();
			_urls.push(_url);
		}
		
		
		public static function init(_SERVER_ENVIRONMENT, __mode:String, __baseContainer:DisplayObjectContainer):void
		{
			SERVER_ENVIRONMENT = _SERVER_ENVIRONMENT;
			_mode = __mode;
			_baseContainer = __baseContainer;
			
			
			_bfirst = true;
			_bInitDownload = false;
			_savecontents = new Object();
			
			_baseContainer.addEventListener(Event.ACTIVATE, onFocusIn);
			
		}
		
		
		public static function initDownload():void
		{
			if (_mode == MODE_REALTIME) {
				_timer = new Timer(DELAY);
				_timer.addEventListener(TimerEvent.TIMER, onTimerEvent);
				_timer.start();
				_baseContainer.removeEventListener(Event.ACTIVATE, onFocusIn);
			}
			
			_bInitDownload = true;
			exec();
			
		}
		
		
		
		
		
		//_____________________________________________________________
		//private functions
		
		static private function exec():void 
		{
			var _len:int = _urls.length;
			var _nocache:Boolean = SERVER_ENVIRONMENT;
			
			
			URLLoaderManager.addEventListener(Event.COMPLETE, onLoaderComplete);
			for (var i:int = 0; i < _len; i++) 
			{
				var _url:String = _urls[i];
				URLLoaderManager.load(_url, _url, _nocache);
			}
		}
		
		
		
		static private function fileChanged():Boolean 
		{
			var _len:int = _urls.length;
			for (var i:int = 0; i < _len; i++) {
				var _url:String = _urls[i];
				
				var _newdata:String = URLLoaderManager.getData(_url);
				var _olddata:String = _savecontents[_url];
				if (_newdata != _olddata) return true;
				
			}
			return false;
		}
		
		
		static private function saveContents():void 
		{
			var _len:int = _urls.length;
			for (var i:int = 0; i < _len; i++) {
				
				var _url:String = _urls[i];
				var _data:String = URLLoaderManager.getData(_url);
				_savecontents[_url] = _data;
				
			}
		}
		
		
		static private function refresh():void 
		{
			if (ExternalInterface.available) {
				ExternalInterface.call("window.location.reload");
			}
			else {
				//todo
				//impossible to acces stage.loaderInfo.loader, it's locked since as3
				//loading self swf and adding it over the stage will cause trouble with stage access
				//maybe a full reset of everything and a reinstanciation of main constructor... ? (complexe)
				
			}
		}
		
		
		
		
		//_____________________________________________________________
		//events
		
		
		static private function onTimerEvent(e:TimerEvent):void 
		{
			//trace("RealTimeRefresh.onTimerEvent");
			
			//trace("memory : " + System.totalMemory);
			exec();
		}
		
		
		static private function onLoaderComplete(e:Event):void 
		{
			//trace("RealTimeRefresh.onLoaderComplete");
			
			if (!_bfirst || !_bInitDownload) {
				var _fileChanged:Boolean = fileChanged();
				if (_fileChanged) {
					trace("RealTimeRefresh.fileChanged !");
					refresh();
				}
			}
			saveContents();
			
			URLLoaderManager.reset();
			_bfirst = false;
			
		}
		
		
		static private function onFocusIn(e:Event):void 
		{
			//trace("onFocusIn");
			exec();
		}
		
		
	}

}