package data2.behaviours.form 
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author 
	 */
	public class InputText extends Input
	{
		private const LIST_REGEX:Object = { "email" : /^[a-z0-9._-]+@[a-z0-9._-]{2,}\.[a-z]{2,5}$/};
		
		
		
		//params
		private var _info:String;
		private var _info_required:String;
		private var _info_format:String;
		private var _required:Boolean;
		private var _regex:String;
		private var _regexValue:RegExp;
		private var _restrict:String;
		private var _color:int = -1;
		private var _color_info:int = -1;
		private var _color_error:int = -1;
		private var _maxChars:int = -1;
		private var _upperCase:Boolean = false;
		private var _lowerCase:Boolean = false;
		private var _tf:TextField;
		
		
		//private vars
		private var _erased:Boolean;
		private var _isErrorFilled:Boolean = false;
		private var _isErrorFormat:Boolean = false;
		private var _tft:TextFormat;
		private var _rememberValue:Boolean;
		private var _oldvalue:String;
		
		
		
		
		
		public function InputText() 
		{
			_tft = new TextFormat();
			
			//default values
			_required = true;
			_rememberValue = true;
			_info_format = "Format incorrect";
		}
		
		
		override public function reset():void 
		{
			_oldvalue = "";
			_isErrorFilled = false;
			_isErrorFormat = false;
			_erased = false;
			
			//trace("_info : " + _info);
			_tf.text = _info;
			var _c:int = (_color_info == -1) ? _color : _color_info;
			_tf.textColor = _c;
			
			rewind();
		}
		
		
		public function isFilled():Boolean
		{
			if(!_erased || _tf.text=="") return false;
			return true;
		}
		
		
		
		public function setContent(_str:String):void
		{
			_tf.text = _str;
			//_tf.setTextFormat(_tft);
			_tf.textColor = _color;
			_erased = true;
		}
		
		
		public function setError(_str:String):void
		{
			if (_erased) _oldvalue = _tf.text;
			_isErrorFilled = true;
			
			_tf.text = _str;
			//_tf.setTextFormat(_tft);
			_tf.textColor = _color_error;
			_erased = false;
			rewind();
		}
		
		
		public function empty():void
		{
			_tf.text = "";
		}
		
		public function rewind():void
		{
			_tf.scrollH = 0;
		}
		
		
		
		
		
		//________________________________________________________
		//set / get
		
		public function set restrict(value:String):void
		{
			_restrict = value;
			if (_tf != null) _tf.restrict = _restrict;
		}
		
		public function set regex(value:String):void 
		{
			if (LIST_REGEX[value] == null) throw new Error("regex " + value + " doesn't exist");
			_regex = value;
			_regexValue = LIST_REGEX[value];
			
		}
		
		public function set required(value:Boolean):void {_required = value;}
		
		public function set info(value:String):void { _info = value; }
		
		public function set info_required(value:String):void {_info_required = value;}
		
		public function set info_format(value:String):void {_info_format = value;}
		
		public function set color(value:int):void { _color = value; }
		
		public function set color_info(value:int):void {_color_info = value;}
		
		public function set color_error(value:int):void {_color_error = value;}
		
		public function set tf(value:TextField):void
		{
			//trace("InputText.set tf " + value);
			_tf = value;
			_tf.addEventListener(FocusEvent.FOCUS_IN, onFocus);
			_tf.addEventListener(Event.CHANGE, onChange);
			
			if (_maxChars != -1) _tf.maxChars = _maxChars;
			if (_restrict != null) _tf.restrict = _restrict;
		}
		
		
		public function get info():String {return _info;}
		
		public function get info_required():String {return _info_required;}
		
		public function get info_format():String {return _info_format;}
		
		public function get required():Boolean {return _required;}
		
		public function get regexValue():RegExp { return _regexValue; }
		
		public function get regex():String {return _regex;}
		
		public function get restrict():String {return _restrict;}
		
		public function get color():int { return _color; }
		
		public function get color_info():int {return _color_info;}
		
		public function get color_error():int {return _color_error;}
		
		public function get tf():TextField {return _tf;}
		
		
		
		public function get content():String 
		{
			return _tf.text;
		}
		
		public function get isErrorFilled():Boolean {return _isErrorFilled;}
		
		override public function set tab_index(value:int):void 
		{
			super.tab_index = value;
			_tf.tabIndex = value;
		}
		
		
		public function set maxChars(value:int):void
		{
			_maxChars = value;
			if (_tf != null) _tf.maxChars = _maxChars;
		}
		
		public function set upperCase(value:Boolean):void 
		{
			_upperCase = value;
		}
		
		public function set lowerCase(value:Boolean):void 
		{
			_lowerCase = value;
		}
		
		
		
		
		
		
		
		//________________________________________________________
		//private functions
		
		
		
		
		
		
		
		
		
		//________________________________________________________
		//events
		
		private function onFocus(e:FocusEvent):void
		{
			//trace("input :: onFocus "+_tf.tabIndex+", "+_tf.tabEnabled);
			if(!_erased){
				_tf.text = (_rememberValue) ? _oldvalue : "";
				_erased = true;
				_isErrorFilled = false;
				_isErrorFormat = false;
			}
			
			//_tf.setTextFormat(_tft);
			_tf.textColor = _color;
			
		}
		
		private function onChange(e:Event):void
		{
			//_tf.setTextFormat(_tft);
			_tf.textColor = _color;
			
			if (_upperCase) _tf.text = _tf.text.toUpperCase();
			if (_lowerCase) _tf.text = _tf.text.toLowerCase();
		}
	}

}