package data2.debug 
{
	import data2.net.URLLoaderManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.system.System;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 
	 */
	public class DebugUtils
	{
		private static var _trueOnces:Object;
		private static var _switchers:Object;
		
		public function DebugUtils() 
		{
			throw new Error("DebugUtils is static");
			
		}
		
		
		
		//_____________________________________________________________
		//public functions
		
		
		
		public static function switcher(_period:int, _id:String = "_base"):Boolean
		{
			if (_period < 1) _period = 1;
			if (_switchers == null) _switchers = new Object();
			if (_switchers[_id] == undefined) _switchers[_id] = 0;
			_switchers[_id]++;
			if (_switchers[_id] == _period) {
				return true;
				_switchers[_id] = 0;
			}
			else return false;
		}
		
		
		
		
		public static function trueOnce(_nbrepeat:int = 1, _id:String = "_base"):Boolean
		{
			if (_trueOnces == null) _trueOnces = new Object();
			if (_trueOnces[_id] == undefined) _trueOnces[_id] = 0;
			
			if (_trueOnces[_id] < _nbrepeat) {
				_trueOnces[_id]++;
				return true;
			}
			else return false;
		}
		
		
		
		
		
		
		//_____________________________________________________________
		//private functions
		
		
		
		
		
		//_____________________________________________________________
		//events
		
		
		
	}

}