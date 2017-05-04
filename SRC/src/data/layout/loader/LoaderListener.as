package data.layout.loader 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	/**
	 * ...
	 * @author Vincent
	 */
	public class LoaderListener extends EventDispatcher
	{
		//_______________________________________________________________________________
		// properties
		
		private var _items:Array;
		private var _sprite:Sprite;
		
		public function LoaderListener() 
		{
			_sprite = new Sprite();
			_items = new Array();
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function add(_loader:Loader):void
		{
			_items.push(_loader);
		}
		
		public function start():void
		{
			_sprite.addEventListener(Event.ENTER_FRAME, onEnterframe);
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		private function onEnterframe(e:Event):void 
		{
			var _len:int = _items.length;
			
			var _bytestotal:Number = 0;
			var _bytesloaded:Number = 0;
			
			for (var i:int = 0; i < _len; i++) 
			{
				
				var l:Loader = Loader(_items[i]);
				//trace(" -- " + i + " : " + l.contentLoaderInfo.bytesTotal + " / " + l.contentLoaderInfo.bytesLoaded);
				_bytestotal += l.contentLoaderInfo.bytesTotal;
				_bytesloaded += l.contentLoaderInfo.bytesLoaded;
				
				if (l.contentLoaderInfo.bytesTotal ==0) return;
			}
			//trace("______________________");
			
			//trace("LoaderListener.onEnterframe " + _bytesloaded + " / " + _bytestotal);
			
			var _evt:LoaderListenerEvent = new LoaderListenerEvent(LoaderListenerEvent.PROGRESS);
			_evt.progress = _bytesloaded / _bytestotal;
			this.dispatchEvent(_evt);
			
			if (_bytesloaded >= _bytestotal) {
				this.dispatchEvent(new LoaderListenerEvent(LoaderListenerEvent.COMPLETE));
				_sprite.removeEventListener(Event.ENTER_FRAME, onEnterframe);
			}
		}
		
		
	}

}