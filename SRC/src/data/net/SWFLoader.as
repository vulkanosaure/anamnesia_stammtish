/*
DESCRIPTION :
sert à faire communiquer 2 swf facilement




EXAMPLE :

coté parent_____________________________________


var swfLoader = new SWFLoader("child.swf");
addChild(swfLoader);

swfLoader.addEventListener(SWFLoaderEvent.COMPLETE, onComplete);
function onComplete(e:Event):void
{
	swfLoader.vars.vartest = 2;
	swfLoader.send();
}



coté enfant_____________________________________

import data.net.SWFLoaderEvent;
this.loaderInfo.sharedEvents.addEventListener(SWFLoaderEvent.SEND_VARS, onSend);
function onSend(e:SWFLoaderEvent):void
{
	trace(e.vars.vartest);
}




TODO :
	eventuellement : rendre SWFLoader et SWFLoaderEvent dynamic pour ne pas avoir a imbriquer les variables dans vars
	essayer de supprimer les vars apres envoi, voir si ça marche (copie ou pointeur...)


*/


package data.net {
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.net.URLRequest;
	import data.net.SWFLoaderEvent;
	
	
	public class SWFLoader extends Loader{
		
		//params
		
		
		//private vars
		private var se:EventDispatcher;
		private var swf:Sprite;
		private var waitingFunctions:Array;
		private var url:String;
		
		public var vars:Object;
		
		
		
		//_______________________________________________________________
		//public functions
		
		public function SWFLoader(_url:String, _x:Number=0, _y:Number=0, _content:DisplayObject=null) 
		{ 
			url = _url;
			
			vars = new Object();
			waitingFunctions = new Array();
			
			if (_url == "") {
				onComplete(new Event(""));
				swf = Sprite(_content);
			}
			else{
				this.load(new URLRequest(_url));
				this.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			}
			
			this.x = _x;
			this.y = _y;
		}
		
		
		
		public function send(_eventType:String=""):void
		{
			if(_eventType=="") _eventType = SWFLoaderEvent.SEND_VARS;
			var e:SWFLoaderEvent = new SWFLoaderEvent(_eventType, vars);
			se.dispatchEvent(e);
		}
		
		public function execFunction(_funcName:String, ...args):*
		{
			//trace("SWFLoader.execFunction(" + _funcName + ", " + args + ")");
			
			if (swf != null)  return execFunction_sub(_funcName, args);
			else waitingFunctions.push( {"funcName" : _funcName, "args" : args} );
			
		}
		
		public function addChildListener(_type:String, _handler:Function):void
		{
			se.addEventListener(_type, _handler);
		}
		
		
		
		//_______________________________________________________________
		//private functions
		
		private function execFunction_sub(_fname:String, _args:Array):*
		{
			//trace("execFunction_sub(" + _fname + ", " + _args+") _args.length : "+_args.length);
			if (swf == null) throw new Error("swf is null, you shouldn't call execFunction_sub at this time");
			var _func:Function = swf[_fname];
			var _return:*;
			if (_args.length == 0) _return = _func();
			else if (_args.length == 1) _return = _func(_args[0]);
			else if (_args.length == 2) _return = _func(_args[0], _args[1]);
			else if (_args.length == 3) _return = _func(_args[0], _args[1], _args[2]);
			else if (_args.length == 4) _return = _func(_args[0], _args[1], _args[2], _args[3]);
			else if (_args.length == 5) _return = _func(_args[0], _args[1], _args[2], _args[3], _args[4]);
			else if (_args.length == 6) _return = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5]);
			else if (_args.length == 7) _return = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6]);
			else if (_args.length == 8) _return = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7]);
			else if (_args.length == 9) _return = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8]);
			else throw new Error("sorry, i didn't think anyone would ever need that much args in a function...");
			
			return _return;
		}
		
		
		
		public function get sharedEvents():EventDispatcher
		{
			return se;
		}
		
		
		
		//_______________________________________________________________
		//events handlers
		
		private function onComplete(e:Event):void
		{
			swf = Sprite(this.content);
			
			se = this.contentLoaderInfo.sharedEvents;
			dispatchEvent(new SWFLoaderEvent(SWFLoaderEvent.COMPLETE));
			
			for (var i:int = 0; i < waitingFunctions.length; i++) {
				var _obj:Object = waitingFunctions[i];
				execFunction_sub(_obj.funcName, _obj.args);
			}
			waitingFunctions = new Array();
		}
		
		
		private function onIOError(e:IOErrorEvent):void 
		{
			throw new Error("SWFLoader : swf not found\n" + e.text);
		}
		
		
	}
	
}