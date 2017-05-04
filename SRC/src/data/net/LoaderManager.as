/*
 * Classe Statique
 * peut s'utiliser depuis toutes les classe d'un meme projet
 * contient une liste de loader et gère une file d'attente
 * 
 * dispatch des Event pour prévenir
 * comment faire correspondre un addEvent avec la bonne image
 * 
 * il faut retourner une reference vers le loader
 * 
 * */


package data.net 
{
	/**
	 * ...
	 * @author Vincent
	 */
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	 
	public class LoaderManager
	{
		
		private static var loaders:Array;
		private static var firstLoad:Boolean = true;
		private static var cur_item:int = 0;
		private static var evtDispatcher:EventDispatcher;
		
		
		public function LoaderManager() 
		{
			throw new Error("LoaderManager can't be instanciated !");
		}
		
		
		public static function load(_url:String, _key:String=""):Loader
		{
			if (firstLoad) loaders = new Array();
			var _loader:Loader = new Loader();
			
			var _ind:int = loaders.length;	
			loaders.push([_loader, _url, _key]);
			if (cur_item==_ind) startLoadQueue(cur_item);
			
			firstLoad = false;
			return _loader;
		}
		
		
		public static function getLoader(_key:String):Loader
		{
			var _len:int = loaders.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _tab:Array = loaders[i];
				if (_tab[2] == _key) return Loader(_tab[0]);
			}
			throw new Error("loader with key " + _key + " wasn't found");
		}
		
		public static function addEventListener(_type:String, _handler:Function):void
		{
			if (evtDispatcher == null) evtDispatcher = new EventDispatcher();
			evtDispatcher.addEventListener(_type, _handler);
		}
		
		
		
		
		
		static private function startLoadQueue(_ind:int):void
		{
			//trace("startLoadQueue(" + _ind + ")");
			loaders[_ind][0].load(new URLRequest(loaders[_ind][1]));
			loaders[_ind][0].contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			loaders[_ind][0].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		
		
		
		
		
		static private function onLoaderComplete(e:Event):void 
		{
			//trace("onLoaderComplete");
			cur_item++;
			if (loaders[cur_item] == null) {
				if (evtDispatcher != null) evtDispatcher.dispatchEvent(new Event(Event.COMPLETE));
				
			}
			else startLoadQueue(cur_item);
			
		}
		
		static private function onIOError(e:IOErrorEvent):void 
		{
			trace("LoaderManager.onIOError " + e);
		}
		
		
	}

}