package data.form {
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.EventDispatcher;
	
	
	
	
	public class Input extends Sprite{
		
		//params
		
		public var required:Boolean = true;
		public var color_normal:int = 0x000000;
		public var color_error:int = 0xff0000;
		
		//private vars
		private var erased:Boolean;
		private var isErrorFilled:Boolean = false;
		private var isErrorFormat:Boolean = false;
		private var _tf:TextField;
		private var tft:TextFormat;
		
		private var _info:String;
		private var _error_msg:String;
		private var _error_format:String;
		private var regex:RegExp;
		
		private var _rememberValue:Boolean;
		private var _oldvalue:String;
		
		
		
		//_______________________________________________________________
		//public functions
		
		public function Input() 
		{ 
			_rememberValue = false;
		}
		//
		
		public function reset():void
		{
			_oldvalue = "";
			isErrorFilled = false;
			isErrorFormat = false;
			erased = false;
			_tf.text = _info;
			rewind();
			_tf.textColor = color_normal;
			//todo : textformat, color
		}
		
		public function rewind():void
		{
			_tf.scrollH = 0;
		}
		
		public function setErasable():void
		{
			isErrorFilled = false;
			isErrorFormat = false;
			erased = false;
		}
		
		public function setRegex(_regex:RegExp):void
		{
			regex = _regex;
		}
		
		public function getRegex():RegExp
		{
			return regex;
		}
		
		public function setTabIndex(i:int):void
		{
			//trace("     setTabIndex ("+i+")");
			_tf.tabIndex = i;
		}
		
		public function setSpecialError(_error:String):void
		{
			setError();
			_tf.text = _error;
		}
		
		public function set tf(_tfield:TextField):void
		{
			_tf = _tfield;
			_tf.addEventListener(FocusEvent.FOCUS_IN, onFocus);
			//_tf.addEventListener(FocusEvent.FOCUS_IN, dispatchFocus);
			_tf.addEventListener(Event.CHANGE, onChange);
			//_tf.tabEnabled = true;
		}
		
		public function isFilled():Boolean
		{
			if(!erased || _tf.text=="") return false;
			return true;
		}
		
		public function setInput(_str:String):void
		{
			_tf.text = _str;
			erased = true;
			_tf.setTextFormat(tft);
			_tf.textColor = color_normal;
		}
		
		public function empty():void
		{
			//trace("Input.empty");
			_tf.text = "";
		}
		
		public function setError():void
		{
			if(erased) _oldvalue = _tf.text;
			isErrorFilled = true;
			_tf.text = _error_msg;
			_tf.setTextFormat(tft);
			_tf.textColor = color_error;
			erased = false;
			rewind();
		}
		public function setErrorFormat():void
		{
			if(erased) _oldvalue = _tf.text;
			isErrorFormat = true;
			_tf.text = _error_format;
			_tf.setTextFormat(tft);
			_tf.textColor = color_error;
			erased = false;
		}
		
		public function get text():String
		{
			return _tf.text;
		}
		
		public function get error():Boolean
		{
			return (isErrorFilled || isErrorFormat);
		}
		
		
		public function get textfield():TextField
		{
			return _tf;
		}
		
		public function setTextFormat(_tft:TextFormat):void
		{
			tft = _tft;
			_tf.setTextFormat(tft);
		}
		
		
		public function set info(v:String):void
		{
			_info = v;
		}
		public function set error_msg(v:String):void
		{
			_error_msg = v;
		}
		public function set error_format(v:String):void
		{
			_error_format = v;
		}
		
		public function set restrict(_str:String):void
		{
			if(_str!="") _tf.restrict = _str;
		}
		
		public function set rememberValue(value:Boolean):void 
		{
			_rememberValue = value;
		}
		
		
		
		
		
		
		
		//_______________________________________________________________
		//private functions
		//temp
		private function dispatchFocus(e:FocusEvent):void
		{
			dispatchEvent(new Event("FOCUS_INPUT"));
		}
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		private function onFocus(e:FocusEvent):void
		{
			//trace("input :: onFocus "+_tf.tabIndex+", "+_tf.tabEnabled);
			if(!erased){
				_tf.text = (_rememberValue) ? _oldvalue : "";
				erased = true;
				isErrorFilled = false;
				isErrorFormat = false;
			}
			
			_tf.setTextFormat(tft);
			_tf.textColor = color_normal;
			
		}
		
		private function onChange(e:Event):void
		{
			_tf.setTextFormat(tft);
			_tf.textColor = color_normal;
		}
	}
	
}