package data2.debug.profiler 
{
	import data2.math.Math2;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author vinc
	 */
	public class Profiler 
	{
		public static var ENABLED:Boolean = true;
		
		private static var _objects:Object = new Object();
		private static var _timers:Object = new Object();
		private static var _groups:Array = new Array();
		private static var _countenterframe:int = 0;
		
		public function Profiler() 
		{
			throw new Error("is static");
			
		}
		
		
		
		
		public static function start(_id:String, _group:String = "root", _forceEnabled:Boolean = false):void
		{
			if (!ENABLED && !_forceEnabled) return;
			var _idmix:String = _group + "." + _id;
			var _timer:int = getTimer();
			_timers[_idmix] = _timer;
			
		}
		
		public static function end(_id:String, _group:String = "root", _forceEnabled:Boolean = false):void
		{
			if (!ENABLED && !_forceEnabled) return;
			if (_groups.indexOf(_group) == -1) _groups.push(_group);
			
			var _idmix:String = _group + "." + _id;
			var _timerprev:int = _timers[_idmix];
			var _timer:int = getTimer();
			var _delta:int = _timer - _timerprev;
			
			var _obj:ProfilerObject;
			if (_objects[_idmix] == undefined) {
				_obj = new ProfilerObject(_group, _id);
				_objects[_idmix] = _obj;
			}
			else {
				_obj = ProfilerObject(_objects[_idmix]);
			}
			_obj.time += _delta;
			
		}
		
		public static function getTime(_id:String, _group:String):int
		{
			var _idmix:String = _group + "." + _id;
			var _obj:ProfilerObject = ProfilerObject(_objects[_idmix]);
			return _obj.time;
		}
		
		
		public static function endEnterframe():void
		{
			if (!ENABLED) return;
			_countenterframe++;
		}
		
		
		public static function getBilan():String
		{
			if (!ENABLED) return "";
			var _str:String = "Profiler BILAN";
			var item:ProfilerObject;
			
			for each (var _group:String in _groups) 
			{
				_str += "_______________________________\n";
				_str += "group \"" + _group + "\"";
				
				
				var _totaltime:Number = 0;
				for each (item in _objects) 
				{
					if (item.group == _group) _totaltime += item.time;
				}
				
				var _timeperenterframe:Number = Math2.round(_totaltime / _countenterframe, 0.0001);
				_str += " totaltime : " + _totaltime + " ms, " + _timeperenterframe + " ms/e";
				_str += "\n";
				
				for each (item in _objects) 
				{
					if (item.group == _group) {
						var _percent:Number = Math.round((item.time / _totaltime) * 100);
						_timeperenterframe = Math2.round(item.time / _countenterframe, 0.0001);
						
						_str += "\t" + item.id + " : " + item.time + " ms, " + _timeperenterframe + " ms/e";
						_str += " (" + _percent + "%)";
						_str += "\n ";
					}
				}
				_str += "\n";
			}
			return _str;
		}
		
		
		public static function reset():void
		{
			if (!ENABLED) return;
			_objects = new Object();
			_timers = new Object();
			_groups = new Array();
			_countenterframe = 0;
		}
		
		
	}

}