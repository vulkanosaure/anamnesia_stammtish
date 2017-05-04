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


package data.sound{
	
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
		var sound:Sound;
		var _url:*;
		var _position:Number;
		var channel:SoundChannel;
		var soundTransform:SoundTransform;
		
		// propriété set/get
		var _loop:Boolean;
		var _isPlaying:Boolean;
		
		
		
		
		
		
		// Constructeur
		public function EasySound( pUrl:* )
		{
			
			
			//propriétés [Embed(source="Q:/DATA_PROJEKT/2012/WWW/JEU-FLASH/SPACE-INVADERS/FLA-APP/src/ARfla.swf", mimeType="application/octet-stream")]par defaut
			_position = 0;
			soundTransform = new SoundTransform();
			soundTransform.volume = 1;
			_isPlaying = false;
			_loop = false;
			
			_url = pUrl;
			
			
			if (pUrl is Sound) {
				sound = pUrl;
			}
			else{
				sound = new Sound();
				sound.load( new URLRequest( _url ) );
			}
			
			// redirection des evenements
			sound.addEventListener( Event.OPEN, dispatchEvent );
			sound.addEventListener( Event.ID3, dispatchEvent );
			sound.addEventListener( ProgressEvent.PROGRESS, dispatchEvent );
			sound.addEventListener( Event.COMPLETE, dispatchEvent );
			sound.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			
		}
		
		
		
		public function play():void
		{
			if(isPlaying) return;
			_isPlaying = true;
			playSound();
		}
		
		public function stop():void
		{
			if(!isPlaying) return;
			channel.stop();
			_isPlaying = false;
		}
		
		
		public function pause():void
		{
			// Et mémorise la position du son
			if(!isPlaying) return;
			_position = channel.position;
			channel.stop();
			_isPlaying = false;
			
		}
		
		
		public function playPause():void
		{
			if(_isPlaying) pause();
			else play();
		}
		
		
		
		public function rewind():void
		{
			goto(0);
			if(isPlaying) this.play();
		}
		
		
		public function goto(v:Number):void
		{
			if(v<0) v = 0;
			if(v>1) v = 1;
			_position = sound.length * v;
			if(_isPlaying){
				channel.stop();
				playSound();
			}
		}
		
		
		
		
		
		
		
		//___________________________________________________________________
		//set / get
		
		public function set volume(v:Number):void
		{
			soundTransform.volume = v;
			if(isPlaying) channel.soundTransform = soundTransform;
		}
		public function get volume():Number
		{
			return soundTransform.volume;
		}
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		public function set loop(v:Boolean):void
		{
			_loop = v;
		}
		public function get loop():Boolean
		{
			return _loop;
		}
		public function get duration():Number
		{
			return sound.length / 1000;
		}
		public function get url():String
		{
			return _url;
		}
		
		public function get progress():Number
		{
			return (channel != null) ? (channel.position / sound.length) : 0;
		}
		
		public function set progress(value:Number):void 
		{
			if (value < 0) value = 0;
			if (value > 1) value = 1;
			
			_position = sound.length * value;
			if(_isPlaying){
				channel.stop();
				playSound();
			}
		}
		
		
		
		
		
		
		//_______________________________________________________________________________
		//private methods
		
		private function playSound():void
		{
			if(channel!=null) channel.stop();
			channel = sound.play( _position );
			channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			channel.addEventListener(Event.SOUND_COMPLETE, dispatchEvent);
			channel.soundTransform = soundTransform;
		}
		
		
		
		
		
		//_______________________________________________________________________________
		//events
		
		
		private function onIOError( pEvt:Event ):void
		{ 
			//trace("onIOError");
			throw new Error("url " + _url + " has not been found");
			
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
