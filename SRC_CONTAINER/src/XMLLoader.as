package 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import utils.CacheManager;
	/**
	 * ...
	 * @author Vincent Huss
	 */
	public class XMLLoader 
	{
		private static var _handler:Function;
		static private var _urlloader:URLLoader;
		private static var _curlang:String;
		
		public function XMLLoader() 
		{
			
		}
		
		public static function init(__handler:Function):void
		{
			_handler = __handler;
			
			_curlang = "fr";
			var _url:String = "http://lebeaujardin.alsace/kiosk_export/export.xml";
			
			_urlloader = new URLLoader();
			_urlloader.addEventListener(Event.COMPLETE, onComplete);
			_urlloader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_urlloader.load(new URLRequest(_url));
			
		}
		
		static private function onComplete(e:Event):void 
		{
			trace("onComplete");
			trace(_urlloader.data);
			
			//CacheManager.writeFile("xml/dynamic-data-" + _curlang + ".xml", _urlloader.data, false);
			_handler();
			
		}
		
		static private function onError(e:IOErrorEvent):void 
		{
			trace("onError");
			_handler();
			
		}
		
	}

}