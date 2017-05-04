package data.xml 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	/**
	 * ...
	 * @author Vincent
	 */
	public class ChargeurXMLList extends EventDispatcher
	{
		//_______________________________________________________________________________
		// properties
		
		private static var loaders:Array;
		private static var firstLoad:Boolean = true;
		private static var cur_item:int = 0;
		private static var _eventDispatcher:EventDispatcher;
		private static var listKeys:Object;
		
		
		public function ChargeurXMLList() 
		{
			throw new Error("ChargeurXMLList is static, don't instanciate");
		}
		
		
		
		
		
		public static function load(_url:String, _key:String=""):ChargeurXML
		{
			if (firstLoad) {
				loaders = new Array();
				listKeys = new Array();
			}
			var _loader:ChargeurXML = new ChargeurXML();
			
			var _ind:int = loaders.length;	
			loaders.push([_loader, _url]);
			if (cur_item == _ind) startLoadQueue(cur_item);
			
			if (_key != "") listKeys[_key] = _loader;
			
			firstLoad = false;
			return _loader;
		}
		
		
		public static function getContent(v:*):ChargeurXML
		{
			if (typeof v == "string") return listKeys[v];
			else return loaders[v][0] as ChargeurXML;
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
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		private static function startLoadQueue(_ind:int):void
		{
			//trace("startLoadQueue(" + _ind + ")");
			loaders[_ind][0].load(loaders[_ind][1]);
			loaders[_ind][0].addEventListener(Event.COMPLETE, onLoaderComplete);
			loaders[_ind][0].addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		private static function onLoaderComplete(e:Event):void 
		{
			//trace("ChargeurXMLList.onLoaderComplete");
			cur_item++;
			if (loaders[cur_item] == null) _eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			else startLoadQueue(cur_item);
			
		}
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		private static function onIOError(e:IOErrorEvent):void 
		{
			trace("ChargeurXMLManager.onIOError " + e);
		}
		
		
	}

}