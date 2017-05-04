/*
// Classe de gestion d'un son :

propriétés :
	volume:Number [0-1]
	duration:Number (lecture seule, seconds)
	loop:Boolean (defaut:false)
	isPlaying:Boolean (lecture seule)
	
méthodes :
	EasySound(_url:String)
	play()
	pause()
	playPause()
	goto(_percent:Number)
	rewind()

redirection des evenements :
	Event.OPEN
	ProgressEvent.PROGRESS
	Event.COMPLETE
	Event.ID3

*/


package data2.sound{
	
	// import des classes
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.events.ProgressEvent;
	
	
	
	// Notre classe qui hérite de EventDispatcher
	public class EasySound extends EventDispatcher{
		
		
		
		// Definition des propriétée
		private var sound:Sound;
		private var _url:String;
		private var _channel:String = "";
		
		private var _volume:Number;
		private var _position:Number;
		private var _soundChannel:SoundChannel;
		private var soundTransform:SoundTransform;
		private var _loaded:Boolean;
		private var _mute:Boolean;
		
		// propriété set/get
		private var _loop:Boolean;
		private var _isPlaying:Boolean;
		private var _isPaused:Boolean;
		private var _loadinit:Boolean;
		
		
		
		
		
		// Constructeur
		public function EasySound(pUrl:String, __loadinit:Boolean)
		{
			//propriétés par defaut
			_position = 0;
			soundTransform = new SoundTransform();
			
			_volume = 1;
			soundTransform.volume = _volume;
			_isPlaying = false;
			_isPaused = false;
			_loop = false;
			_mute = false;
			
			_url = pUrl;
			_loadinit = __loadinit;
			
			_loaded = false;
			sound = new Sound();
			if (_loadinit) sound.load(new URLRequest(_url));
			
			// redirection des evenements
			sound.addEventListener(Event.OPEN, dispatchEvent);
			sound.addEventListener(Event.ID3, dispatchEvent);
			sound.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
			sound.addEventListener(Event.COMPLETE, dispatchEvent);
			sound.addEventListener(Event.COMPLETE, onSoundLoaded);
			sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
		}
		
		private function onSoundLoaded(e:Event):void 
		{
			trace("EasySound.onSoundLoaded");
			_loaded = true;
		}
		
		
		
		public function play():void
		{
			if (isPlaying) return;
			//if (_mute) return;
			_isPlaying = true;
			_isPaused = false;
			playSound();
		}
		
		public function stop():void
		{
			if(!isPlaying) return;
			_soundChannel.stop();
			_isPlaying = false;
			_isPaused = false;
		}
		
		
		public function pause():void
		{
			// Et mémorise la position du son
			if(!isPlaying) return;
			_position = _soundChannel.position;
			_soundChannel.stop();
			_isPlaying = false;
			_isPaused = true;
			
		}
		
		
		public function playPause():void
		{
			if(_isPlaying) pause();
			else play();
		}
		
		
		
		public function rewind():void
		{
			goto_(0);
			if(isPlaying) this.play();
		}
		
		
		public function goto_(v:Number):void
		{
			if(v<0) v = 0;
			if(v>1) v = 1;
			_position = sound.length * v;
			if(_isPlaying){
				_soundChannel.stop();
				playSound();
			}
		}
		
		
		
		
		
		
		
		//___________________________________________________________________
		//set / get
		
		public function set volume(v:Number):void
		{
			_volume = v;
			updateVolume(_volume);
		}
		
		private function updateVolume(_value:Number):void
		{
			trace("EasySound.updateVolume(" + _value + "), _isPlaying : "+_isPlaying+", _ispaused : "+_isPaused+", _volume : "+_volume);
			soundTransform.volume = _value;
			if(isPlaying) _soundChannel.soundTransform = soundTransform;
		}
		
		public function get volume():Number
		{
			return _volume;
		}
		
		public function get isPlaying():Boolean{return _isPlaying;}
		public function set loop(v:Boolean):void{_loop = v;}
		
		
		public function get loop():Boolean { return _loop;
		}
		public function get duration():Number
		{
			return sound.length / 1000;
		}
		public function get url():String{return _url;}
		
		public function get progress():Number
		{
			return (_soundChannel != null) ? (_soundChannel.position / sound.length) : 0;
		}
		
		public function set progress(value:Number):void 
		{
			if (value < 0) value = 0;
			if (value > 1) value = 1;
			
			_position = sound.length * value;
			if(_isPlaying){
				_soundChannel.stop();
				playSound();
			}
		}
		
		public function set mute(value:Boolean):void 
		{
			_mute = value;
			/*
			if (_mute) {
				if (_isPlaying) pause();
			}
			else {
				if (_isPaused) play();
			}
			*/
			if (_mute) updateVolume(0);
			else updateVolume(_volume);
			
		}
		
		public function get mute():Boolean
		{
			return _mute;
		}
		
		public function get channel():String {return _channel;}
		
		public function set channel(value:String):void {_channel = value;}
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		//private methods
		
		private function playSound():void
		{
			if (_soundChannel != null) _soundChannel.stop();
			if (!_loadinit && !_loaded) sound.load(new URLRequest(_url));
			
			_soundChannel = sound.play(_position);
			_soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			_soundChannel.addEventListener(Event.SOUND_COMPLETE, dispatchEvent);
			_soundChannel.soundTransform = soundTransform;
		}
		
		
		
		
		
		//_______________________________________________________________________________
		//events
		
		
		private function onIOError(pEvt:Event):void
		{
			//trace("onIOError");
			throw new Error("url "+_url+" has not been found");
		}
		
		private function onSoundComplete(e:Event):void
		{
			//trace("EasySound :: onSoundComplete");
			_isPlaying = false;
			this.rewind();
			if(_loop){
				this.play();
				_isPlaying = true;
			}
		}
	}
	
}
