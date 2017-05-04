/*
représente uniquement la vidéo
fournit une interface de manipulation

EXAMPLE :

videoPlayer = new VideoPlayer(false);
addChild(videoPlayer);
videoPlayer.addEventListener(VideoEvent.META_DATA, onVideoMeta);
videoPlayer.addEventListener(VideoEvent.FINISHED, onVideoFinished);
var firstMeta:Boolean = true;

private function onVideoMeta(e:VideoEvent):void 
{
	if (!firstMeta) return;
	firstMeta = false;

	//trace("onVideoMeta "+e.obj.width+", "+e.obj.height);
	videoPlayer.init(e.obj.width, e.obj.height);
	videoPlayer.rewind();
	videoPlayer.play();
}
*/

package data.video {
	
	import flash.net.NetStream;
	import flash.net.NetConnection;
	import flash.display.MovieClip;
	import flash.media.Video;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.display.BitmapData;
	import data.video.VideoEvent;
	
	
	public class VideoPlayer extends MovieClip{
		
		
		private const BUFFER_TIME = 8;
		
		private var ns:NetStream;
		private var nc:NetConnection;
		private var video:Video;
		private var url:String;
		private var client:Object;
		private var duration;
		private var st:SoundTransform;
		private var isplaying:Boolean;
		private var _loop:Boolean = false;
		private var firstMetaData:Boolean;
		public var autoRewind:Boolean;
		private var _bloaded:Boolean;
		
		
		public function VideoPlayer(_autoRewind:Boolean=true) 
		{ 
			autoRewind = _autoRewind;
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			nc.connect(null);
			st = new SoundTransform();
			isplaying = false;
			_bloaded = false;
		}
		
		public function init(_width:int, _height:int, _smoothing:Boolean=true)
		{
			//trace("VideoPlayer::init()");
			if(video!=null && this.contains(video)) this.removeChild(video);
			video = new Video(_width, _height);
			video.attachNetStream(ns);
			video.smoothing = _smoothing;
			addChild(video);
		}
		
		public function setURL(_url:String):void
		{
			//trace("VideoPlayer::setURL("+_url+")");
			//nc.connect(null);								//ligne qui a fait marcher nora et fait bugger mezzo
			firstMetaData = true;
			url = _url;
			ns.play(url);
			stop();
		}
		
		public function clear():void
		{
			while (numChildren) removeChildAt(0);
			if (ns != null) ns.close();
		}
		
		public override function set x(v:Number):void
		{
			//trace("Videoplayer.set x : "+v);
			super.x = v;
		}
		public override function set y(v:Number):void
		{
			//trace("Videoplayer.set y : "+v);
			super.y = v;
		}
		
		
		public function get currentTime():Number
		{
			return ns.time;
		}
		
		public function get totalTime():Number
		{
			return duration;
		}
		
		public override function play():void
		{
			ns.resume();
			//if(currentTime>=totalTime) ns.play(url);
			if(currentTime>=totalTime*0.99){
				ns.seek(0);
				ns.resume();
			}
			isplaying = true;
			
			this.dispatchEvent(new VideoEvent(VideoEvent.PLAY));
		}
		
		public override function stop():void
		{
			ns.pause();
			ns.seek(0);
			isplaying = false;
			
			this.dispatchEvent(new VideoEvent(VideoEvent.STOP));
		}
		
		public function rewind():void
		{
			ns.seek(0);
		}
		
		public function pause():void
		{
			if(ns!=null) ns.pause();
			isplaying = false;
			this.dispatchEvent(new VideoEvent(VideoEvent.STOP));
		}
		
		public function gotoPercent(v:Number):void
		{
			if(v<0) v=0;
			if(v>100) v=100;
			var time:Number = duration*v/100;
			ns.seek(time);
		}
		
		public function gotoTime(_time:Number):void
		{
			if (_time > duration) _time = duration;
			if (_time < 0) _time = 0;
			ns.seek(_time);
		}
		
		
		public function get progress():Number
		{
			return currentTime /totalTime * 100;
		}
		
		public function get download():Number
		{
			//trace("ns.bytesLoaded : "+ns.bytesLoaded+", ns.bytesTotal : "+ns.bytesTotal);
			if (ns == null) return 0;
			return 	ns.bytesLoaded / ns.bytesTotal * 100;
		}
		
		public function set volume(v:Number)
		{
			st.volume = v/100;
			ns.soundTransform = st;
		}
		
		public function get volume():Number
		{
			return st.volume * 100;
		}
		
		public function get isPlaying():Boolean
		{
			return isplaying;
		}
		
		public function set loop(b:Boolean):void
		{
			_loop = b;
		}
		
		public function get screenshot():BitmapData
		{
			var bmp:BitmapData = new BitmapData(width, height);
			bmp.draw(video);
			return bmp;
		}
		
		
		
		
		//_______________________________________________________________________________
		//private functions
		
		private function openStream()
		{
			//trace("openStream");
			ns = new NetStream(nc);
			ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			
			client = new Object();
			client.onMetaData = function(obj:Object){
				//trace("VideoPlayer::onMeta");
				if (!firstMetaData) return;
				firstMetaData = false;
				var e:VideoEvent = new VideoEvent(VideoEvent.META_DATA);
				e.obj = obj;
				duration = obj.duration;
				dispatchEvent(e);
				
				// gotoPercent(0);
				
			}
			
			ns.client = client;
			ns.bufferTime = BUFFER_TIME;
		}
		
		
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		//events handler
		
		private function netStatusHandler(event:NetStatusEvent):void {
			
			var code:String = event.info.code;
			//trace("netStatusHandler, code : "+code);
			
			if (!_bloaded && this.download >= 99) {
				_bloaded = true;
				dispatchEvent(new VideoEvent(VideoEvent.LOADED));
			}
			
			var bufferPercent:Number;
			if(ns!=null) bufferPercent = Math.ceil(ns.bufferLength/ns.bufferTime*100);
			else bufferPercent = 0;
			
			if(code=="NetConnection.Connect.Success"){
				openStream();
				gotoPercent(0);
			}
			else if(code=="NetStream.Play.StreamNotFound"){
				throw new Error("Unable to find the video : "+url);
			}
			else if(bufferPercent>=100 && code!="NetStream.Buffer.Flush"){
				//vidéo play
				dispatchEvent(new Event("BUFFERING_STOP"));
			}else if(code=="NetStream.Buffer.Flush" || code=="NetStream.Buffer.Full" || code=="NetStream.Buffer.Empty" || code=="NetStream.Play.Start"){
				//lecture vidéo finie ou buffer se "décharge"
				dispatchEvent(new Event("BUFFERING_STOP"));
			}
			else if(code=="NetStream.Seek.Notify"){
				//la vidéo est en pause, prete à démarrer
				dispatchEvent(new Event("BUFFERING_STOP"));
				//gotoPercent(0);
			}
			else if(code=="NetStream.Play.Stop"){
				//vidéo finie, on la rejoue si loop
				dispatchEvent(new VideoEvent(VideoEvent.FINISHED));
				trace("autoRewind : " + autoRewind + ", _loop : " + _loop);
				if(autoRewind) rewind();
				if(_loop){
					rewind();
					play();
				}
				else{
					pause();
					dispatchEvent(new Event("AUTOREWIND"));
				}
			}else{
				//buffer pas entièrement chargé
				dispatchEvent(new Event("BUFFERING_START"));
			}
			
		}
		
		
		
	}
	
}