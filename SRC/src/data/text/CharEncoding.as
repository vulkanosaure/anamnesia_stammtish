package data.text 
{
	/**
	 * ...
	 * @author Vincent
	 */
	public class CharEncoding
	{
		
		public function CharEncoding() 
		{
			throw new Error("CharEncoding is static, can't be instanciated");
		}
		
		
		public static function TEDecodeSpecialChars(_str:String):String
		{
			_str = _str.replace(/&lt;/g, "<");
			_str = _str.replace(/&gt;/g, ">");
			_str = _str.replace(/&quot;/g, "\"");
			_str = _str.replace(/&amp;/g, "&");
			return _str;
		}
		
		public static function stripTags(_str:String):String
		{
			var _regexp:RegExp = new RegExp("<[^<]+?>", "gi");
			return _str.replace(_regexp, "");
			
		}
		
		public static function entityCodeToSymbol(_str:String):String
		{
			_str = _str.replace(/&‌Agrave;/g, "À");
			_str = _str.replace(/&‌Egrave; /g, "");
			_str = _str.replace(/a/g, "");
			_str = _str.replace(/a/g, "");
			_str = _str.replace(/a/g, "");
			_str = _str.replace(/a/g, "");
			_str = _str.replace(/a/g, "");
			_str = _str.replace(/a/g, "");
			_str = _str.replace(/a/g, "");
			_str = _str.replace(/a/g, "");
			
			return _str;
		}
		
		
		
		
		public static function removeAccent(_str:String):String
		{
			_str = _str.replace(/[àáâãäå]/g, "a");
			_str = _str.replace(/[ÀÁÂÃÄÅ]/g, "A");
			_str = _str.replace(/[èéêë]/g, "e");
			_str = _str.replace(/[ËÉÊÈ]/g, "E");
			_str = _str.replace(/[ìíîï]/g, "i");
			_str = _str.replace(/[ÌÍÎÏ]/g, "I");
			_str = _str.replace(/[ðòóôõöø]/g, "o");
			_str = _str.replace(/[ÐÒÓÔÕÖØ]/g, "O");
			_str = _str.replace(/[ùúûü]/g, "u");
			_str = _str.replace(/[ÙÚÛÜ]/g, "U");
			_str = _str.replace(/[ýýÿ]/g, "y");
			_str = _str.replace(/[ÝÝŸ]/g, "Y");
			_str = _str.replace(/[ç]/g, "c");
			_str = _str.replace(/[Ç]/g, "C");
			_str = _str.replace(/[ñ]/g, "n");
			_str = _str.replace(/[Ñ]/g, "N");
			_str = _str.replace(/[š]/g, "s");
			_str = _str.replace(/[Š]/g, "S");
			_str = _str.replace(/[ž]/g, "z");
			_str = _str.replace(/[Ž]/g, "Z");
			
			return _str;
		}
		
		
		public static function removeMajAccent(_str:String):String
		{
			_str = _str.replace(/[ÀÁÂÃÄÅ]/g, "A");
			_str = _str.replace(/[ËÉÊÈ]/g, "E");
			_str = _str.replace(/[ÌÍÎÏ]/g, "I");
			_str = _str.replace(/[ÐÒÓÔÕÖØ]/g, "O");
			_str = _str.replace(/[ÙÚÛÜ]/g, "U");
			_str = _str.replace(/[ÝÝŸ]/g, "Y");
			_str = _str.replace(/[Ç]/g, "C");
			_str = _str.replace(/[Ñ]/g, "N");
			_str = _str.replace(/[Š]/g, "S");
			_str = _str.replace(/[Ž]/g, "Z");
			
			//13 min, 12 maj
			//64 total en haut
			//sur les 64, si on enleve les maj ? 32 pile moitié
			
			//je peux compenser en retirant des choses (7)
			//  / @ # ; * ^ _
			
			
			//85 contenus => 113
			
			//nb min
			//nb maj
			//total 
			
			//sur
			//à èéê îï 
			
			return _str;
		}
		
		
		public static function removeMsWordChars(_str:String):String
		{
			//todo (', ..., oe)
			_str = _str.replace(/&oelig;/g, "oe");
			_str = _str.replace(/&hellip;/g, "...");
			_str = _str.replace(/&lsquo;/g, "'");
			_str = _str.replace(/&rsquo;/g, "'");
			
			return _str;
		}
		
		public static function replaceWeirdCharCodes(_str:String):String
		{
			var _len:int = _str.length;
			for (var i:int = 0; i < _len; i++) 
			{
				if (_str.charCodeAt(i) == 156) _str = CharEncoding.replaceCharAt(_str, i, "oe");
			}
			return _str;
		}
		
		public static function encodeObjectURL(_object:Object):String
		{
			var _tab:Array = new Array();
			for (var _key:* in _object) _tab.push(_key + "=" + _object[_key]);
			return _tab.join("&");
		}
		
		
		
		public static function addNumberSeparator(_value:String, _separator:String):String
		{
			var _isneg:Boolean = (_value.charAt(0) == "-");
			if (_isneg) _value = _value.substr(1, _value.length - 1);
			
			var _grouplen:uint = 3;
			var _len:int = _value.length;
			var _ind:int = _len - (_grouplen + 1);
			
			while (_ind >= 0) {
				_value = insertCharAfter(_value, _ind, _separator);
				_ind -= _grouplen;
			}
			
			if (_isneg) _value = "-" + _value;
			return _value;
		}
		
		
		public static function removeEndingPattern(_str:String, _pattern:String):String
		{
			var _len:uint = _str.length;
			var _lenPattern:uint = _pattern.length;
			if (_len == 0 || _lenPattern == 0 || _lenPattern > _len) return _str;
			while (_str.substr(_len - _lenPattern, _lenPattern) == _pattern) _str = _str.substr(0, _len - _lenPattern);
			return _str;
		}
		
		public static function removeDoubleLineBreaks(_str:String):String
		{
			_str = _str.replace(/\r\n/g, "\n");
			return _str;
		}
		public static function removeLineBreaks(_str:String):String
		{
			_str = _str.replace(/\n/g, "");
			return _str;
		}
		
		public static function formatTime(__sec:int):String
		{
			var _min:int = Math.floor(_sec / 60);
			var _sec:int = __sec % 60;
			var _strmin:String = String(_min);
			if (_strmin.length == 1) _strmin = "0" + _strmin;
			var _strsec:String = String(_sec);
			if (_strsec.length == 1) _strsec = "0" + _strsec;
			var _output:String = _strmin + ":" + _strsec;
			return _output;
		}
		
		
		public static function filterURLChars(_str:String):String
		{
			_str = removeAccent(_str);
			_str = _str.replace(" ", "-");
			_str = escape(_str);
			_str = _str.toLowerCase();
			return _str;
		}
		
		public static function getExtension(_str:String):String
		{
			var _indexOfPoint:int = _str.lastIndexOf(".");
			var _extension:String = _str.substr(_indexOfPoint + 1, _str.length - (_indexOfPoint + 1));
			return _extension;
		}
		
		static public function limitDecimalValues(_str:String, _nb:Number):String 
		{
			var _indexPoint:int = _str.indexOf(".");
			var _output:String = _str;
			if (_indexPoint != -1) {
				
				if (_nb > 0) {
					var _len:Number = _indexPoint + _nb + 1;
					_output = _output.substr(0, _len);
					while (_output.length < _len) _output += "0";
				}
				else {
					_output = _output.substr(0, _indexPoint);
				}
				
			}
			else {
				if (_nb > 0) {
					_output += ".";
					for (var i:int = 0; i < _nb; i++) _output += "0";
				}
			}
			
			return _output;
			
		}
		
		public static function changeCaseIndex(_str:String, _upper:Boolean, _index:int):String
		{
			if (_index != 0) throw new Error("todo (only index 0 ok now)");
			var _len:int = _str.length;
			var _letter1:String = _str.substr(0, 1);
			var _rest:String = _str.substr(1, _len - 1);
			var _output:String = "";
			if (_upper) _output += _letter1.toUpperCase();
			else _output += _letter1.toLowerCase();
			_output += _rest;
			return _output;
		}
		
		static public function version2number(_version:String):Number 
		{
			//if nb point <= 1, conversion normal
			//else 
			trace("________________________________________");
			var _tabmatch:Array = _version.match(/\./g);
			
			var _output:Number;
			if (_tabmatch.length > 1) {
				
				var _tab:Array = _version.split(".");
				_version = _tab[0] + ".";
				
				var _len:int = _tab.length;
				for (var i:int = 1; i < _len; i++) _version += _tab[i];
			}
			_output = Number(_version);
			
			return _output;
		}
		
		static public function nl2br(object:Object):void 
		{
			//todo
			
		}
		
		static public function br2nl(_str:String):String 
		{
			_str = _str.replace(/<br ?\/?> ?/g, "\n");
			return _str;
		}
		
		
		private static function insertCharAfter(_str:String, _index:uint, _char:String):String
		{
			var _len:uint = _str.length;
			var _part1:String = _str.substr(0, _index + 1);
			var _part2:String = _str.substr(_index + 1, _len - (_index + 1));
			return _part1 + _char + _part2;
		}
		
		
		private static function replaceCharAt(_str:String, _index:int, _insert:String):String
		{
			var _len:uint = _str.length;
			var _part1:String = _str.substr(0, _index);
			var _part2:String = _str.substr(_index + 1, _len - (_index + 1));
			return _part1 + _insert + _part2;
		}
	}

}