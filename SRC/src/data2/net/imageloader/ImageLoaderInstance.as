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
	public class ImageLoaderInstance extends EventDispatcher
	{
		private var _groupName:String;
		private var _timer:Timer;
		private var _progressSave:Number;
		private var _tab:Vector.<ImageLoaderObject>;
		private var _idloading:int;
		
		
		public function ImageLoaderInstance(__groupName:String) 
		{
			_tab = new Vector.<ImageLoaderObject>();
			_groupName = __groupName;
		}
		
		
		
		public function add(_loader:Loader, _src:String, _group:String):void 
		{
			var _obj:ImageLoaderObject = new ImageLoaderObject(_loader, _src, _group);
			_tab.push(_obj);
		}
		
		
		
		public function loadGroup():void 
		{
			_idloading = 0;
			
			loadItem(_idloading);
			
			if (_timer == null) {
				_timer = new Timer(100);
				//_timer.start();
			}
			
			_progressSave = 0;
			_timer.addEventListener(TimerEvent.TIMER, onTimerEvent);
		}
		
		public function resetGroup():void 
		{
			if (_tab != null) {
				var _len:int = _tab.length;
				for each(var _obj:ImageLoaderObject in _tab) {
					_obj.loader.unload();
				}
			}
			_tab = new Vector.<ImageLoaderObject>();
			
		}
		
		public function isGroupLoaded():Boolean 
		{
			if (_tab == null) return false;
			for each(var _obj:ImageLoaderObject in _tab) {
				if (!_obj.loaded) return false;
			}
			return true;
		}
		
		public function getImage(_src:String):DisplayObject 
		{
			for each(var _obj:ImageLoaderObject in _tab) {
				if (_obj.src == _src && _obj.loaded) {
					return _obj.content;
				}
			}
			return null;
		}
		
		public function get nbitem():int 
		{
			return (_tab == null) ? 0 : _tab.length;
		}
		
		
		
		
		
		
		
		
		private function loadItem(_ind:int):void
		{
			/*
			trace("loadItem(" + _ind + ") _groupName " + _groupName);
			trace("_group2load : " + _group2load);
			*/
			var _obj:ImageLoaderObject = _tab[_ind];
			
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
		
		
		
		
		
		
		
		
		//_________________________________________________________________________________
		//events
		
		private function handleNext(e:Event):void
		{
			var _obj:ImageLoaderObject = _tab[_idloading];
			_obj.loaded = true;
			
			if (e != null) {
				var _loader:Loader = LoaderInfo(e.target).loader;
				_obj.content = _loader.content;
			}
			
			_idloading++;
			if (_idloading >= _tab.length) {
				trace("ImageLoader.COMPLETE");
				this.dispatchEvent(new ImageLoaderEvent(ImageLoaderEvent.COMPLETE, _groupName));
				_timer.removeEventListener(TimerEvent.TIMER, onTimerEvent);
				
				
			}
			else loadItem(_idloading);
		}
		
		
		
		
		private function onLoaderComplete(e:Event):void 
		{
			trace("ImageLoaderInstance.onLoaderComplete " + _idloading + ", len : " + _tab.length+", _groupName : "+_groupName);
			handleNext(e);
		}
		
		
		
		private function onIOError(e:IOErrorEvent):void 
		{
			trace("ChargeurXMLManager.onIOError " + e);
			handleNext(null);
		}
		
		
		
		private function onTimerEvent(e:Event):void 
		{
			/*
			var _progress:Number = getProgress(_group2load);
			
			if(_progress > _progressSave){
				var _evt:ImageLoaderEvent = new ImageLoaderEvent(ImageLoaderEvent.PROGRESS, _groupName);
				_evt.progress = _progress;
				_eventDispatcher.dispatchEvent(_evt);
				_progressSave = _progress;
			}
			*/
			
		}
		
		
		
	}

}