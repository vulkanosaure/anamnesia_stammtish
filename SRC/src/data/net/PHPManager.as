/*
UTILISATION :
	import data.net.PHPManager;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestHeader;
	var phpm:PHPManager = new PHPManager();
	phpm.exec("fichier.php");
	phpm.addEventListener(Event.COMPLETE, onComplete);

INSERTION VARIABLES :
	//a faire avant l'appel de exec()
	phpm.varsIn.mavar1 = "blabla";
	
RECUPERATION VARIABLES :
	//a faire dans onComplete
	phpm.varsOut.varsortie

EVENEMENTS DISPO :
	Event.COMPLETE
	ProgressEvent.PROGRESS
	IOErrorEvent.IO_ERROR
	en rajouter si nécéssaire...
*/



package data.net {
	
	import flash.net.URLVariables;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.net.navigateToURL;
	import flash.net.URLRequestHeader;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent; 
	import flash.events.EventDispatcher;
	
	
	public class PHPManager extends EventDispatcher{
		
		
		public static const OUTPUT_VARIABLES:String = "outputVariables";
		public static const OUTPUT_DATA:String = "outputData";
		
		//variables publiques d'entrée et sortie
		public var varsIn:URLVariables;
		public var varsOut:URLVariables;
		private var _outputData:String;
		private var _outputMode:String = OUTPUT_VARIABLES;
		
		
		public static const POST:String = "POST";
		public static const GET:String = "GET";
		
		
		public function PHPManager() 
		{ 
			reset();
			
		}
		
		public function reset():void
		{
			varsIn = new URLVariables();
		}
		
		public function exec(phpFile:String, _open:Boolean=false, _target:String=null, _method:String="POST"):void
		{
			varsOut = new URLVariables();
			var req:URLRequest = new URLRequest(phpFile);
			
			
			if(!_open) req.method = URLRequestMethod.POST;
			else req.method = _method;
			req.data = varsIn;
			var varLoader:URLLoader = new URLLoader;
			varLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			//redirection des evenements... (en rajouter si nécéssaire...)
			varLoader.addEventListener(Event.COMPLETE, onComplete);
			varLoader.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
			varLoader.addEventListener(IOErrorEvent.IO_ERROR , onIOErrorEvent);
			varLoader.addEventListener(IOErrorEvent.IO_ERROR , dispatchEvent);
			
			
			if(_open) navigateToURL(req, _target);
			else varLoader.load(req);
		}
		
		
		public function get outputData():String { return _outputData; }
		
		public function set outputMode(value:String):void 
		{
			if (value != OUTPUT_DATA && value != OUTPUT_VARIABLES) throw new Error("wrong value for property outputMode");
			_outputMode = value;
		}
		
		
		//____________________________________________________________________________________________
		// Events
		
		private function onComplete(e:Event):void
		{
			var l:URLLoader = e.currentTarget as URLLoader;
			
			if(_outputMode==OUTPUT_VARIABLES){
				//stocke les variables de retour ds un objet varsOut pour un acces plus intuitif
				try {
					varsOut.decode(l.data);
				} catch(e:Error){
					trace('Error URLVariable.decode() : wrong format : ', l.data);
				}
			}
			//trace("PHPManager ::varsOut : " + varsOut);
			else {
				_outputData = l.data;
			}
			
			this.dispatchEvent(e);
		}
		
		
		private function onIOErrorEvent(e:IOErrorEvent):void
		{
			trace("onIOErrorEvent");
		}
		
		
		
		
	}
	
}
