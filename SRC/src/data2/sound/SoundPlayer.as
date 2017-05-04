package data2.sound
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Vincent
	 */
	public class SoundPlayer
	{
		//_______________________________________________________________________________
		// properties
		
		private static var _obj:Object;
		private static var _eventList:Array;
		private static var _muteglobal:Boolean = false;
		private static var _mutedir:Array;
		private static var _mute:Boolean; 	//temp, retrocompatibility
		
		public function SoundPlayer() 
		{
			throw new Error("is static");
			_mute = false;
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public static function addSound(_url:String, _key:String, _loadinit:Boolean=false):void
		{
			if (_obj == null) _obj = new Object();
			_obj[_key] = new EasySound(_url, _loadinit);
			
			//mute handling
			if (_mutedir == null) _mutedir = new Array();
			var _s:EasySound = EasySound(_obj[_key]);
			var _dir:String = getDirectory(_key);
			var _mustMute:Boolean = (_mute || _mutedir.indexOf(_dir) != -1);
			trace("-- _key : " + _key + ", _dir : " + _dir + ", _mustMute : " + _mustMute);
			_s.mute = _mustMute;
		}
		
		public static function exists(_key:String):Boolean
		{
			if (_obj == null) _obj = new Object();
			return (_obj[_key] != undefined);
		}
		
		
		
		
		public static function mute(_value:Boolean, _dir:String):void
		{
			if (_mutedir == null) _mutedir = new Array();
			//todo : remove potential "/" at end of _dir
			while (_dir.charAt(_dir.length - 1) == "/") _dir = _dir.substr(0, _dir.length - 1);
			trace("mute(" + _value + ", " + _dir + ")");
			
			var _indexOf:int = _mutedir.indexOf(_dir);
			if (_value) {
				if (_dir == "") {
					_mute = true;
				}
				else{
					if (_indexOf == -1) _mutedir.push(_dir);
				}
			}
			else {
				//mute set to false remove all muted dir (it's a choice, maybe we'll need to change that later)
				if (_dir == "") {
					_mute = false;
					_mutedir = new Array();
				}
				else{
					if (_indexOf != -1) _mutedir.splice(_indexOf, 1);
				}
			}
			
			trace("_mutedir : " + _mutedir+", _indexOf : "+_indexOf);
			
		}
		
		
		public static function updateMute():void
		{
			//todo : cut sound playing
			for (var _key:String in _obj) 
			{
				var _s:EasySound = EasySound(_obj[_key]);
				var _dir:String = getDirectory(_key);
				var _mustMute:Boolean = (_mute || _mutedir.indexOf(_dir) != -1);
				trace("-- _key : " + _key + ", _dir : " + _dir + ", _mustMute : " + _mustMute);
				_s.mute = _mustMute;
				
			}
		}
		
		
		
		public static function stopChannel(_ch:String):void
		{
			stopSoundChannel(_ch);
		}
		
		
		
		public static function play(_key:String, _volume:Number=1.0, _loop:Boolean=false, _channel:String=""):void
		{
			//if (_mute) return;
			if (!exists(_key)) addSound(_key, _key, true);
			
			var _s:EasySound = EasySound(_obj[_key]);
			if (!_s.mute) _s.volume = _volume;
			
			_s.loop = _loop;
			_s.channel = _channel;
			
			if (_channel != "") stopSoundChannel(_channel);
			
			if (_s == null) throw new Error("no sound defined for key " + _key);
			_s.play();
		}
		
		
		
		
		
		
		public static function addSoundEvent(_item:EventDispatcher, _event:String, _key:String):void
		{
			if (_item == null) throw new Error("item is null (arg1)");
			if (_eventList == null) _eventList = new Array();
			//trace("SoundPlayer.addSoundEvent(" + _item + ", " + _event + ", " + _key + ")");
			if (getKey(_item, _event) == _key) throw new Error("a sound event has allready been added with item "+_item+", _event "+_event+", and key "+_key);
			
			_eventList.push( { "item" : _item, "event" : _event, "key" : _key} );
			_item.addEventListener(_event, onSoundEvent);
		}
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		private static function getKey(_item:Object, _event:String):String
		{
			var _len:int = _eventList.length;
			for (var i:int = 0; i < _len; i++) {
				var o:Object = _eventList[i];
				if (o.item == _item && o.event == _event) return o.key;
			}
			return "";
		}
		
		
		static private function stopSoundChannel(_ch:String):void 
		{
			for (var _key:String in _obj) 
			{
				var _sound:EasySound = EasySound(_obj[_key]);
				if (_sound.channel == _ch) _sound.stop();
			}
		}
		
		
		static private function getDirectory(_url:String):String 
		{
			var _tab:Array = _url.split("/");
			_tab.pop();
			return _tab.join("/");
		}
		
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		static private function onSoundEvent(e:Event):void 
		{
			var _key:String = getKey(e.currentTarget, e.type);
			play(_key);
		}
		
		
	}

}