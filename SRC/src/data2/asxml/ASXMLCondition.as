package data2.asxml 
{
	/**
	 * ...
	 * @author 
	 */
	public class ASXMLCondition 
	{
		private const LIST_COMPARATORS:Array = ["==", "!=", ">", "<", ">=", "<="];
		
		private var _cond:String;
		private var _val1:*;
		private var _val2:*;
		private var _comparator:String;
		
		public function ASXMLCondition() 
		{
			
		}
		
		public function set cond(value:String):void 
		{
			//trace("set cond(" + value + ")");
			_cond = value;
			//_cond = _cond.replace(/ /g, "");
			
			
		}
		
		public function getResult():Boolean
		{
			if (_cond == null) throw new Error("if : param cond must be set");
			
			//var _tab:Array = _cond.match(/^([\w\.\-]*)([=<>\!]{1,2})([\w\.\-]*)$/);
			var _regex_space:RegExp = new RegExp("^(.*) ([=<>\!]{1,2}) (.*)$", "s");
			var _regex_nospace:RegExp = new RegExp("^(.*?)([=<>\!]{1,2})(.*?)$", "s");
			
			
			var _tab:Array = _cond.match(_regex_space);
			if(_tab==null) _tab = _cond.match(_regex_nospace);
			//trace("_tab : " + _tab);
			
			if (_tab == null) throw new Error("ASXMLCondition : wrong format (" + _cond + ")");
			
			_val1 = _tab[1];
			_val2 = _tab[3];
			_comparator = _tab[2];
			
			//trace("_val1 : " + _val1 + ", _comparator : " + _comparator + ", _val2 : " + _val2);
			if (LIST_COMPARATORS.indexOf(_comparator) == -1) throw new Error("ASXMLCondition : comparator \"" + _comparator + "\" doesn't exist, existing comparators are " + LIST_COMPARATORS);
			
			
			var _result:Boolean;
			if (_comparator == "==") _result = (_val1 == _val2);
			else if (_comparator == "!=") _result = (_val1 != _val2);
			
			//need to be numbers
			else {
				var _num1:Number = Number(_val1);
				if (isNaN(_num1)) throw new Error("ASXMLCondition : value 1 \"" + _val1 + "\" must be a Number if used with comparator \"" + _comparator + "\"");
				
				var _num2:Number = Number(_val2);
				if (isNaN(_num2)) throw new Error("ASXMLCondition : value 2 \"" + _val2 + "\" must be a Number if used with comparator \"" + _comparator + "\"");
				
				
				//["==", "!=", ">", "<", ">=", "<="];
				if (_comparator == ">") _result = (_num1 > _num2);
				else if (_comparator == "<") _result = (_num1 < _num2);
				else if (_comparator == ">=") _result = (_num1 >= _num2);
				else if (_comparator == "<=") _result = (_num1 <= _num2);
				
			}
			
			return _result;
		}
		
		
	}

}