package data.text 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	/**
	 * ...
	 * @author Vincent
	 */
	public class CSSLoader extends EventDispatcher
	{
		//_______________________________________________________________________________
		// properties
		
		private static var _loader:URLLoader;
		private static var _styleSheet:StyleSheet;
		private static var _eventDispatcher:EventDispatcher;
		
		public function CSSLoader() 
		{
			throw new Error("CSSLoaded is static, don't instanciate");
		}
		
		public static function load(_url:String):void
		{
			if (_loader == null) {
				_loader = new URLLoader();
				_loader.addEventListener(Event.COMPLETE, onLoaded);
			}
			_loader.load(new URLRequest(_url));
			
		}
		
		public static function addEventListener(_type:String, _func:Function):void
		{
			if (_eventDispatcher == null) _eventDispatcher = new EventDispatcher();
			_eventDispatcher.addEventListener(_type, _func);
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public static function get styleSheet():StyleSheet
		{
			return _styleSheet;
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		static private function onLoaded(e:Event):void 
		{
			//trace("CSSLoader.onLoaded");
			if (_styleSheet == null) _styleSheet = new StyleSheet();
			_styleSheet.parseCSS(e.target.data);
			if (_eventDispatcher != null) _eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		
	}

}