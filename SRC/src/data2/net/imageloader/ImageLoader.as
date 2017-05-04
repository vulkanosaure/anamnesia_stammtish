package data2.net.imageloader 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 
	 */
	public class ImageLoader 
	{
		public static const GROUP_INIT:String = "groupInit";
		public static const GROUP_RESET:String = "groupReset";
		public static const GROUP_DEFAULT:String = "groupDefault";
		
		private static var _eventDispatcher:EventDispatcher;
		private static var _items:Object;
		private static var _group2load:Array;
		private static var _groupName:String;
		private static var _idloading:int;
		private static var _timer:Timer;
		private static var _displayReports:Boolean = false;
		private static var _progressSave:Number;
		
		
		
		public function ImageLoader() 
		{
			throw new Error("is static");
		}
		
		
		public static function add(_loader:Loader, _src:String, _group:String = ""):void
		{
			//trace("ImageLoader.add(" + _loader + ", " + _src + ", " + _group + ")");
			if (_group == "") _group = GROUP_DEFAULT;
			
			if (_items == null) _items = new Object();
			
			var _tabgroup:Array;
			if (_items[_group] == undefined) {
				_tabgroup = new Array();
				_items[_group] = _tabgroup;
			}
			else {
				_tabgroup = _items[_group];
			}
			
			var _obj:ImageLoaderObject = new ImageLoaderObject(_loader, _src, _group);
			_tabgroup.push(_obj);
		}
		
		
		
		
		public static function loadGroup(_group:String = ""):void
		{
			trace("ImageLoader.loadGroup(" + _group + ")");
			
			if (_group == "") _group = GROUP_DEFAULT;
			
			if (_items == null) _items = new Object();
			//if (_items[_group] == undefined) throw new Error("group \"" + _group + "\" doesn't exist");
			if (_items[_group] == undefined) {
				if (_eventDispatcher == null) _eventDispatcher = new EventDispatcher();
				_eventDispatcher.dispatchEvent(new ImageLoaderEvent(ImageLoaderEvent.COMPLETE, GROUP_INIT));
				return;
			}
			
			_group2load = _items[_group];
			_groupName = _group;
			_idloading = 0;
			if (_group2load.length == 0){
				if (_eventDispatcher == null) _eventDispatcher = new EventDispatcher();
				_eventDispatcher.dispatchEvent(new ImageLoaderEvent(ImageLoaderEvent.COMPLETE, GROUP_INIT));
				return;
			}
			
			loadItem(_idloading);
			
			if (_timer == null) {
				_timer = new Timer(100);
				_timer.start();
			}
			
			_progressSave = 0;
			_timer.addEventListener(TimerEvent.TIMER, onTimerEvent);
		}
		
		
		
		
		public static function getImage(_src:String, _group:String = ""):DisplayObject
		{
			if (_group == "") _group = GROUP_DEFAULT;
			
			var _tab:Array = _items[_group];
			if (_tab == null) return null;
			
			for each(var _obj:ImageLoaderObject in _tab) {
				if (_obj.src == _src && _obj.loaded) {
					return _obj.content;
				}
			}
			return null;
		}
		
		
		
		public static function isGroupLoaded(_group:String):Boolean
		{
			var _tab:Array = _items[_group];
			if (_tab == null) return false;
			for each(var _obj:ImageLoaderObject in _tab) {
				if (!_obj.loaded) return false;
			}
			return true;
		}
		
		public static function groupExists(_group:String):Boolean
		{
			return (_items[_group] != undefined);
		}
		
		
		public static function addEventListener(_type:String, _func:Function):void
		{
			if (_eventDispatcher == null) _eventDispatcher = new EventDispatcher();
			_eventDispatcher.addEventListener(_type, _func);
		}
		
		public static function removeEventListener(_type:String, _func:Function):void
		{
			if (_eventDispatcher == null) _eventDispatcher = new EventDispatcher();
			_eventDispatcher.removeEventListener(_type, _func);
		}
		/*
		public static function resetEventListeners():void 
		{
			_eventDispatcher = new EventDispatcher();
		}
		*/
		static public function resetGroup(_group:String):void 
		{
			var _oldtab:Array = _items[_group];
			if (_oldtab != null) {
				var _len:int = _oldtab.length;
				for each(var _obj:ImageLoaderObject in _oldtab) {
					_obj.loader.unload();
				}
			}
			_items[_group] = new Array();
		}
		
		
		static public function set displayReports(value:Boolean):void { _displayReports = value; }
		
		
		static public function getLoadedData(_group:String, _index:int):DisplayObject
		{
			var _tab:Array = _items[_group];
			var _obj:ImageLoaderObject = ImageLoaderObject(_tab[_index]);
			return _obj.content;
			
		}
		
		
		
		
		//_________________________________________________________________________________
		//private functions
		
		
		private static function loadItem(_ind:int):void
		{
			/*
			trace("loadItem(" + _ind + ") _groupName " + _groupName);
			trace("_group2load : " + _group2load);
			*/
			var _obj:ImageLoaderObject = _group2load[_ind];
			
			if(!_obj.loaded){
				var _request:URLRequest = new URLRequest(_obj.src);
				_obj.loader.load(_request);
				_obj.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
				_obj.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			}
			else {
				onLoaderComplete(null);
			}
		}
		
		
		private static function getProgress(group2load:Array):Number 
		{
			var _len:int = group2load.length;
			var _bytesLoaded:Number = 0;
			var _bytesTotal:Number = 0;
			
			
			var _nbTotalNotNull:int = _len;
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _obj:ImageLoaderObject = ImageLoaderObject(group2load[i]);
				var _loader:Loader = _obj.loader;
				
				var _total:Number = _loader.contentLoaderInfo.bytesTotal;
				if (_total == 0) _nbTotalNotNull--;
				
				_bytesLoaded += _loader.contentLoaderInfo.bytesLoaded;
				_bytesTotal += _total;
				//trace("-- _bytesLoaded : " + _bytesLoaded + ", _bytesTotal : " + _bytesTotal);
			}
			
			var _percentNotNull:Number = _nbTotalNotNull / _len;
			
			var _progress:Number = _bytesLoaded / _bytesTotal;
			_progress *= _percentNotNull;
			if (isNaN(_progress)) _progress = 0;
			
			return _progress;
		}
		
		
		
		static private function displayReport(_group:String):void 
		{
			if (_items[_group] == undefined) {
				trace("_items[" + _group + "] is undefined");
				return;
			}
			var _groupItems:Array = _items[_group] as Array;
			
			var _len:int = _groupItems.length;
			var _totalByteLoaded:Number = 0;
			var _totalByteLoadednodoublon:Number = 0;
			
			var _tab:Array = new Array();
			var _srcs:Array = new Array();
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _ilobj:ImageLoaderObject = ImageLoaderObject(_groupItems[i]);
				var _byteloaded:Number = _ilobj.loader.contentLoaderInfo.bytesLoaded;
				_totalByteLoaded += _byteloaded;
				if (_srcs.indexOf(_ilobj.src) == -1) _totalByteLoadednodoublon += _byteloaded;
				
				
				_tab.push( { "src" : _ilobj.src, "byteloaded" : _byteloaded } );
				_srcs.push(_ilobj.src);
				
			}
			
			_tab.sortOn("byteloaded", Array.NUMERIC | Array.DESCENDING);
			
			trace("___________________________________________");
			trace("ImageLoader, group \"" + _group + "\", total size : " + Math.round(_totalByteLoaded / 1024) + " ko,  no doublon : " + Math.round(_totalByteLoadednodoublon / 1024));
			
			for each (var _obj:Object in _tab) 
			{
				trace("   -- " + Math.round(_obj.byteloaded / 1024) + " ko   " + _obj.src);
			}
			//trace("___________________________________________");
			
		}
		
		
		
		
		
		private static function srcExists(_src:String):Boolean
		{
			for (var _groupname:String in _items) 
			{
				var _tab:Array = _items[_groupname];
				var _len:int = _tab.length;
				for (var i:int = 0; i < _len; i++) 
				{
					var _ilo:ImageLoaderObject = ImageLoaderObject(_tab[i]);
					if (_ilo.src == _src) return true;
				}
			}
			return false;
		}
		
		
		
		
		//_________________________________________________________________________________
		//events
		
		private static function onLoaderComplete(e:Event):void 
		{
			//trace("ImageLoader.onLoaderComplete " + _idloading + ", len : " + _group2load.length+", _groupName : "+_groupName);
			
			var _obj:ImageLoaderObject = _group2load[_idloading];
			_obj.loaded = true;
			
			if (e != null) {
				var _loader:Loader = LoaderInfo(e.target).loader;
				_obj.content = _loader.content;
			}
			
			_idloading++;
			if (_idloading >= _group2load.length) {
				trace("ImageLoader.COMPLETE");
				_eventDispatcher.dispatchEvent(new ImageLoaderEvent(ImageLoaderEvent.COMPLETE, _groupName));
				_timer.removeEventListener(TimerEvent.TIMER, onTimerEvent);
				
				if (_displayReports) displayReport(_groupName);
			}
			else loadItem(_idloading);
			
		}
		
		
		
		private static function onIOError(e:IOErrorEvent):void 
		{
			throw new Error("ChargeurXMLManager.onIOError " + e);
		}
		
		
		
		static private function onTimerEvent(e:Event):void 
		{
			var _progress:Number = getProgress(_group2load);
			
			if(_progress > _progressSave){
				var _evt:ImageLoaderEvent = new ImageLoaderEvent(ImageLoaderEvent.PROGRESS, _groupName);
				_evt.progress = _progress;
				_eventDispatcher.dispatchEvent(_evt);
				_progressSave = _progress;
			}
			
		}
		
		
		
		
		
	}

}