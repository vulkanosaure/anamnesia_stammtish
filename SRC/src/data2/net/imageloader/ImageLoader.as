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
		
		private static var _displayReports:Boolean = false;
		
		private static var _items:Object;
		private static var _group2load:ImageLoaderInstance;
		
		private static var _eventDispatcher:EventDispatcher;
		
		
		
		
		public function ImageLoader() 
		{
			throw new Error("is static");
		}
		
		
		
		
		public static function add(_loader:Loader, _src:String, _group:String = ""):void
		{
			//trace("ImageLoader.add(" + _loader + ", " + _src + ", " + _group + ")");
			if (_group == "") _group = GROUP_DEFAULT;
			
			if (_items == null) _items = new Object();
			
			var _tabgroup:ImageLoaderInstance;
			
			if (_items[_group] == undefined) {
				_tabgroup = new ImageLoaderInstance(_group);
				_items[_group] = _tabgroup;
				_tabgroup.addEventListener(ImageLoaderEvent.COMPLETE, onComplete);
				
				
				
			}
			else {
				_tabgroup = ImageLoaderInstance(_items[_group]);
			}
			
			_tabgroup.add(_loader, _src, _group);
			
			
		}
		
		static private function onComplete(e:ImageLoaderEvent):void 
		{
			trace("ImageLoader.onComplete " + e.group);
			if (_displayReports) displayReport(e.group);
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
			
			_group2load = ImageLoaderInstance(_items[_group]);
			
			if (_group2load.nbitem == 0){
				if (_eventDispatcher == null) _eventDispatcher = new EventDispatcher();
				_eventDispatcher.dispatchEvent(new ImageLoaderEvent(ImageLoaderEvent.COMPLETE, GROUP_INIT));
				return;
			}
			
			_group2load.loadGroup();
		}
		
		
		
		
		public static function getImage(_src:String, _group:String = ""):DisplayObject
		{
			if (_group == "") _group = GROUP_DEFAULT;
			
			if (_items[_group] == null) {
				return null;
			}
			var _tab:ImageLoaderInstance = ImageLoaderInstance(_items[_group]);
			return _tab.getImage(_src);
			
			
		}
		
		
		
		public static function isGroupLoaded(_group:String):Boolean
		{
			var _tab:ImageLoaderInstance = _items[_group];
			return (_tab == null) ? false : _tab.isGroupLoaded();
			
			
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
		static public function resetGroup(__group:String):void 
		{
			var _group:ImageLoaderInstance = ImageLoaderInstance(_items[__group]);
			_group.resetGroup();
			
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
		
		
		
		
		
		
		
		
		
	}

}