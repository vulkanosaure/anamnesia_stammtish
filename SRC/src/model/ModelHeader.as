package model 
{
	import com.adobe.serialization.json_custom.JSON2;
	import data2.math.Math2;
	import data2.net.Ajax;
	import flash.events.Event;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ModelHeader 
	{
		static public const APP_ID:String = "5dbd638c087f9c0025f6c4618c7f87fb";
		static public const CITY_NAME:String = "strasbourg";
		private static var callback_getWeatherInfo:Function;
		static private var _temp:Number;
		
		public function ModelHeader() 
		{
			
		}
		
		public static function getCurrentTime():String
		{
			var _time:Date = new Date();
			var _strhour:String = String(_time.getHours());
			if (_strhour.length == 1) _strhour = "0" + _strhour;
			
			var _strmin:String = String(_time.getMinutes());
			if (_strmin.length == 1) _strmin = "0" + _strmin;
			
			var _output:String = _strhour + ":" + _strmin;
			
			return _output;
		}
		
		
		public static function getTimestamp():Number
		{
			var _time:Date = new Date();
			return _time.time;
		}
		
		public static function getTsDay():Number
		{
			var _time:Date = new Date();
			var _tsday:int = _time.getHours() * 3600 + _time.getMinutes() * 60;
			return _tsday;
		}
		
		public static function getTemperature():int
		{
			return _temp;
		}
		
		static public function getWeatherInfo(_callback:Function):void 
		{
			callback_getWeatherInfo = _callback;
			
			var _ajax:Ajax = new Ajax();
			_ajax.addEventListener(Event.COMPLETE, ongetWeatherInfoComplete);
			_ajax.outputMode = Ajax.OUTPUT_DATA;
			_ajax.call("http://api.openweathermap.org/data/2.5/weather?q=" + CITY_NAME + ",fr&APPID=" + APP_ID, false, null, "GET");
			
		}
		
		static private function ongetWeatherInfoComplete(e:Event):void 
		{
			//trace("ModelHeader.ongetWeatherInfoComplete");
			var _ajax:Ajax = Ajax(e.target);
			var _obj:Object = JSON2.decode(_ajax.outputData);
			if (_obj.cod == "404") return;
			
			_temp = _obj.main.temp;
			var _icon:String = _obj.weather[0].icon;
			
			_temp -= 273.15;
			_temp = Math2.round(_temp, 1)
			_icon = _icon.substr(0, 2);
			
			var _data:Object = { "temp" : _temp, "icon" : _icon };
			callback_getWeatherInfo(_data);
			
		}
		
	}

}