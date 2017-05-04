package data2.net 
{
	import data2.parser.StyleSheet2;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	/**
	 * ...
	 * @author Vincent
	 */
	public class URLLoaderManager extends EventDispatcher
	{
		//_______________________________________________________________________________
		// properties
		
		private static var loaders:Array;
		private static var firstLoad:Boolean = true;
		private static var cur_item:int;
		private static var _eventDispatcher:EventDispatcher;
		private static var listKeys:Object;
		
		
		public function URLLoaderManager() 
		{
			throw new Error("URLLoaderManager is static, don't instanciate");
			
		}
		
		
		
		
		
		public static function load(_url:String, _key:String="", _nocache:Boolean=false):void
		{
			if (firstLoad) {
				reset();
			}
			var _loader:URLLoader = new URLLoader();
			
			var _ind:int = loaders.length;	
			loaders.push([_loader, _url, _nocache]);
			if (cur_item == _ind) startLoadQueue(cur_item);
			
			if (_key != "") listKeys[_key] = _loader;
			
			firstLoad = false;
		}
		
		
		public static function getData(v:*):*
		{
			if (typeof v == "string") {
				if (listKeys[v] == undefined) throw new Error("key " + v + " doesn't exist");
				return URLLoader(listKeys[v]).data;
			}
			else return URLLoader(loaders[v][0]).data;
		}
		
		public static function getStylesheet(_key:String):StyleSheet2
		{
			var _data:* = getData(_key);
			var _styleSheet:StyleSheet2 = new StyleSheet2();
			_styleSheet.parseCSS(_data);
			return _styleSheet;
		}
		
		public static function getXml(_key:String):XMLList
		{
			var _data:* = getData(_key);
			//trace("_data : " + _data);
			var _xmllist:XMLList = XMLList(_data);
			return _xmllist;
		}
		
		
		public static function get length():uint
		{
			return loaders.length;
		}
		
		public static function addEventListener(_type:String, _func:Function):void
		{
			if (_eventDispatcher == null) _eventDispatcher = new EventDispatcher();
			_eventDispatcher.addEventListener(_type, _func);
		}
		
		public static function resetEventListeners():void 
		{
			_eventDispatcher = new EventDispatcher();
		}
		
		
		
		public static function reset():void 
		{
			firstLoad = true;
			cur_item = 0;
			
			var _len:int = (loaders != null) ? loaders.length : 0;
			for (var i:int = 0; i < _len; i++) 
			{
				var _l:URLLoader = URLLoader(loaders[i][0]);
				//no unload method for URLLoader, but apparently if no reference are keeped, garbage collector takes care of memory leaks
			}
			
			loaders = new Array();
			if (listKeys == null) listKeys = new Object();
			
		}
		
		
		public static function get progress():Number
		{
			
			var _len:int = loaders.length;
			var _byteLoaded:Number = 0;
			var _byteTotal:Number = 0;
			for (var i:int = 0; i < _len; i++) 
			{
				var _l:URLLoader = URLLoader(loaders[i][0]);
				_byteLoaded += _l.bytesLoaded;
				_byteTotal += _l.bytesTotal;
			}
			var _progress:Number = _byteLoaded / _byteTotal;
			return _progress;
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		private static function startLoadQueue(_ind:int):void
		{
			//trace("startLoadQueue(" + _ind + ")");
			var _url:String = loaders[_ind][1];
			var _request:URLRequest = new URLRequest(_url);
			
			var _nocache:Boolean = loaders[_ind][2];
			if(_nocache){
				var _variables:URLVariables = new URLVariables();  
				_variables.nocache = new Date().getTime(); 
				_request.data = _variables;
			}
			
			//trace("_url : " + _url + ", _nocache : " + _nocache);
			
			loaders[_ind][0].load(_request);
			loaders[_ind][0].addEventListener(Event.COMPLETE, onLoaderComplete);
			loaders[_ind][0].addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		
		
		private static function onLoaderComplete(e:Event):void 
		{
			//trace("ChargeurXMLList.onLoaderComplete");
			cur_item++;
			if (loaders[cur_item] == null) {
				_eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			}
			else startLoadQueue(cur_item);
			
		}
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		private static function onIOError(e:IOErrorEvent):void 
		{
			throw new Error("ChargeurXMLManager.onIOError " + e);
		}
		
		
	}

}