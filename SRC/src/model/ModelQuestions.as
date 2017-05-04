package model 
{
	import data2.asxml.Constantes;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ModelQuestions 
	{
		
		public function ModelQuestions() 
		{
			
		}
		
		
		public static function getQuestions(_temperature:int, _time:Number):Array
		{
			var _output:Array = new Array();
			
			var _rawdata:Object = Constantes.get("fr.questions.item");
			var _rawtab:Array = _rawdata as Array;
			var _len:int = _rawtab.length;
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _obj:Object = _rawtab[i];
				_obj["indexxml"] = i;
				var _meteofilter:String = String(_obj["meteo"]);
				var _timefilter:String = String(_obj["time"]);
				
				var _acceptmeteo:Boolean;
				var _accepttime:Boolean;
				
				if (_meteofilter == "*") _acceptmeteo = true;
				else {
					//15,25
					var _tab1:Array = convertFilter(_meteofilter, "meteo");
					_acceptmeteo = (_temperature >= _tab1[0] && _temperature <= _tab1[1]);
				}
				
				if (_timefilter == "*") _accepttime = true;
				else {
					//12:30,15:00
					var _tab2:Array = convertFilter(_timefilter, "time");
					_accepttime = (_time >= _tab2[0] && _time <= _tab2[1]);
				}
				
				var _accept:Boolean = (_acceptmeteo && _accepttime);
				if (_accept) _output.push(_obj);
				
			}
			
			return _output;
		}
		
		static private function convertFilter(_filter:String, _type:String):Array 
		{
			//meteo/time
			var _tab:Array = _filter.split(",");
			if (_tab.length != 2) throw new Error("filter must be of length = 2");
			
			for (var i:int = 0; i < _tab.length; i++) 
			{
				var _item:String = _tab[i];
				if (_type == "meteo") {
					_tab[i] = int(_item);
				}
				else if (_type == "time") {
					var _tabtime:Array = _item.split(":");
					var _hour:int = int(_tabtime[0]);
					var _min:int = int(_tabtime[1]);
					
					var _tsday:int = _hour * 3600 + _min * 60;
					_tab[i] = _tsday;
				}
			}
			
			return _tab;
		}
		
	}

}