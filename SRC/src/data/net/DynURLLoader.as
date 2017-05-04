package data.net {
	
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	public dynamic class DynURLLoader extends URLLoader {
		
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		// 						VARIABLES						//
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		
		public static const EVENT_LOAD_PROGRESS:String = "loadProgress";
		public static const EVENT_LOAD_COMPLETE:String = "loadComplete";
		public static const EVENT_LOAD_INIT:String = "loadInit";
		
		private var requete:URLRequest;
		private var startTime:Number;
		private var _loadingInfo:Object = new Object();
		
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		// 					CONSTRUCTEUR					//
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		
		public function DynURLLoader() {
			super();
			this.addEventListener(ProgressEvent.PROGRESS, onProgress);
			this.addEventListener(Event.COMPLETE, onComplete);
		}
		
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		// 		FONCTIONS EVENEMENTIELLES		//
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		
		private function onComplete(event:Event):void {
			dispatchEvent(new Event(EVENT_LOAD_COMPLETE));
			_loadingInfo.elapsedTime = getTimer() - startTime;
		}
		
		private function onProgress(event:ProgressEvent):void {
			dispatchEvent(new Event(EVENT_LOAD_PROGRESS));
			_loadingInfo.bytesLoaded = event.bytesLoaded;
			_loadingInfo.bytesTotal = event.bytesTotal;
			_loadingInfo.ratio = event.bytesLoaded / event.bytesTotal;
			_loadingInfo.elapsedTime = getTimer() - startTime;
			_loadingInfo.estimatedTime = (_loadingInfo.bytesTotal * _loadingInfo.elapsedTime) / _loadingInfo.bytesLoaded;
			_loadingInfo.remainingTime = _loadingInfo.estimatedTime - _loadingInfo.elapsedTime;
		}
		
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		// 				FONCTIONS DIVERSES			//
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		
		public function loadURL(pUrl:String) {
			startTime = getTimer();
			requete = new URLRequest(pUrl);
			dispatchEvent(new Event(EVENT_LOAD_INIT));
			load(requete);
		}
		
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		// 						ACCESSEURS					//
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		
		public function get loadingInfo():Object {
			return _loadingInfo;
		}
		
	}
}