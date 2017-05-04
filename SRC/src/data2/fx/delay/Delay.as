/*
Permet de décaller dans le temps l'execution d'une fonction en lui passant des paramètres
S'utilise un peu comme une Tween :

import data.utils.Delay;
var d:Delay = new Delay(time_ms, maFonction, param1, param2);

_function maFonction(param1:int, param2:String){ ...

*/


package data2.fx.delay {
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Delay {
		
		//_params
		
		
		//private vars
		private var timer:Timer;
		
		private var _func:Function;
		private var _params:Array;
		private var _waiting:Boolean;
		private var _group:String;
		
		//_______________________________________________________________
		//public _functions
		
		public function Delay(t:Number, f:Function, args:Array) 
		{ 
			if (t < 0) throw new Error("arg t must be > than 0");
			_params = args;
			if(args.length>10) throw new Error("Class Delay doesn't accept more than 10 parameters, you need to edit the class");
			timer = new Timer(t, 1);
			_func = f;
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			_waiting = true;
		}
		
		
		
		
		public function stop():void
		{
			timer.stop();
			timer.reset();
		}
		public function pause():void
		{
			timer.stop();
		}
		
		public function resume():void
		{
			timer.start();
		}
		
		public function start():void
		{
			timer.start();
		}
		
		public function get waiting():Boolean
		{
			return _waiting;
		}
		
		
		public function get func():Function { return _func; }
		
		
		public function set params(value:Array):void 
		{
			_params = value;
		}
		
		public function get params():Array { return _params; }
		
		public function get group():String {return _group;}
		
		public function set group(value:String):void 
		{
			_group = value;
		}
		
		//_______________________________________________________________
		//private _functions
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		private function onTimer(e:TimerEvent):void
		{
			_waiting = false;
			var len:int = _params.length;
			if(len==0) _func();
			else if(len==1) _func(_params[0]);
			else if(len==2) _func(_params[0], _params[1]);
			else if(len==3) _func(_params[0], _params[1], _params[2]);
			else if(len==4) _func(_params[0], _params[1], _params[2], _params[3]);
			else if(len==5) _func(_params[0], _params[1], _params[2], _params[3], _params[4]);
			else if(len==6) _func(_params[0], _params[1], _params[2], _params[3], _params[4], _params[5]);
			else if(len==7) _func(_params[0], _params[1], _params[2], _params[3], _params[4], _params[5], _params[6]);
			else if(len==8) _func(_params[0], _params[1], _params[2], _params[3], _params[4], _params[5], _params[6], _params[7]);
			else if(len==9) _func(_params[0], _params[1], _params[2], _params[3], _params[4], _params[5], _params[6], _params[7], _params[8]);
			else if(len==10) _func(_params[0], _params[1], _params[2], _params[3], _params[4], _params[5], _params[6], _params[7], _params[8], _params[9]);
		}
		
	}
	
}