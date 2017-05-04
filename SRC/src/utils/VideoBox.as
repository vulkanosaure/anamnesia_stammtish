package utils {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	/*
	import org.osflash.signals.Signal;
	import virgile.app.Global;
	import virgile.events.VgEvent;
	import virgile.patterns.core.IDisposable;
	import virgile.utils.TimerUtils;
	*/
	
	public class VideoBox extends Sprite/* implements IDisposable*/ {
		
		public const STATUS_PLAYING:String = "playing";
		public const STATUS_PAUSED:String = "paused";
		public const STATUS_STOPPED:String = "stopped";
		
		private var _screen:Video;
		private var _bmp:Bitmap;
		private var _ns:NetStream;
		private var _nc:NetConnection;
		private var _metaData:Object;
		private var _source:String;
		private var _mediaWidth:Number;
		private var _mediaHeight:Number;
		private var _duration:Number;
		private var _loaded:Boolean;
		private var _nsClient:Object;
		private var _state:String;
		/*
		private var _playbackStateChanged:Signal;
		private var _playheadPositionChanged:Signal;
		*/
		private var _smoothing:Boolean = false;
		private var _volume:Number = 1;
		private var _pan:Number = 0;
		private var _userData:Object;
		
		public var rewindOnStop:Boolean = true;
		public var loop:Boolean = false;
		public var useSnapshot:Boolean = false;
		
		
		
		public function VideoBox() {
			super();
			
			_userData = new Object();
			/*
			_playbackStateChanged = new Signal(VideoBox, String);
			_playheadPositionChanged = new Signal(VideoBox, Number);
			*/
			_loaded = false;
			
			_build();
			
			_ncConnect();
		}
		public function load(source:String):void {
			_source = source;
			if(_nsClient)
				_nsClient.onMetaData = _nsMetaData;
			_loaded = false;
			_source = source;
			play();
		}
		public function dispose(e:Event = null):void {
			_screen.attachNetStream(null);
			
			if (_nc) {
				try {
					_nc.close();
				}
				catch (err:Error) {
				}
				_nc.removeEventListener(NetStatusEvent.NET_STATUS, _ncStatus);
				_nc.removeEventListener(IOErrorEvent.IO_ERROR, _ncError);
				_nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, _ncError);
				_nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _ncError);
			}
			
			if (_ns) {
				try {
					_ns.close();
				}
				catch (err:Error) {
				}
				_ns.removeEventListener(NetStatusEvent.NET_STATUS, _nsStatus);
				_ns.removeEventListener(IOErrorEvent.IO_ERROR, _nsError);
				_ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, _nsError);
			}
			
			removeChildren();
			_screen = null;
			_ns = null;
			_nc = null;
			_metaData = null;
			/*
			_playbackStateChanged = null;
			_playheadPositionChanged = null;
			*/
		}
		public function setRessource(source:String):void {
			stop();
			if(_nsClient)
				_nsClient.onMetaData = _nsMetaData;
			_clearData();
			_source = source;
		}
		public function get ressource():String {
			return _source;
		}
		public function get smoothing():Boolean{
			return _smoothing;
		}
		public function set smoothing(smoothing:Boolean):void {
			_smoothing = smoothing;
			if(_screen)
				_screen.smoothing = smoothing;
			if (_bmp)
				_bmp.smoothing = _smoothing;
		}
		public function get isLoaded():Boolean {
			return _loaded;
		}
		public function get userData():Object {
			return _userData;
		}
		
		//	##################################################################################################################
		//	PLAYBACK UTILITIES
		
		public function togglePause(e:Event = null):void{
			isPlaying ? pause() : resume();
		}
		public function pause(e:Event = null):void {
			//trace("\t\t ---------------------------- [VideoBox.pause]");
			_ns.pause();
			_setState(STATUS_PAUSED);
		}
		public function resume(e:Event = null):void {
			//trace("\t\t ---------------------------- [VideoBox.resume]");
			_ns.resume();
			_setState(STATUS_PLAYING);
		}
		public function play(e:Event = null):void {
			//trace("\t\t ---------------------------- [VideoBox.play]");
			if (!_ns)
				return;
				
			if (_loaded)
				resume();
			else {
				_ns.close();
				_setState(STATUS_PLAYING);
				_ns.play(_source, 0, -1, true);
				
			}
		}
		public function stop(e:Event = null):void {
			//trace("\t\t ---------------------------- [VideoBox.stop]");
			if (!_ns)
				return;
			
			if(rewindOnStop){
				position = 0;
				_ns.pause();
				//_playheadPositionChanged.dispatch(this, 0);
			}
			else {
				_ns.pause();
				//_playheadPositionChanged.dispatch(this, 1);
			}
			_setState(STATUS_STOPPED);
		}
		public function empty():void {
			_ns.close();
			
			if(_bmp.bitmapData)
				_bmp.bitmapData.dispose();
			_screen.clear();
			
			_clearData();
			
			_setState(STATUS_STOPPED);
		}
		
		
		//	##################################################################################################################
		//	PLAYBACK STATE
		/*
		public function get playbackStateChanged():Signal {
			return _playbackStateChanged;
		}
		public function get playheadPositionChanged():Signal {
			return _playheadPositionChanged;
		}
		*/
		public function get isPlaying():Boolean {
			return _state == STATUS_PLAYING;
		}
		public function get isPaused():Boolean {
			return _state == STATUS_PAUSED;
		}
		public function get isStopped():Boolean {
			return _state == STATUS_STOPPED;
		}
		public function get state():String {
			return _state;
		}
		private function _setState(state:String):void {
			switch(state) {
				case STATUS_PLAYING:
					addEventListener(Event.ENTER_FRAME, _frameTick);
					_state = state;
					break;
				case STATUS_PAUSED:
				case STATUS_STOPPED:
					removeEventListener(Event.ENTER_FRAME, _frameTick);
					_state = state;
					break;
			}
			//_playbackStateChanged.dispatch(this, _state);
		}
		private function _frameTick(e:Event):void {
			/*
			if(duration >= 0)
				_playheadPositionChanged.dispatch(this, position / duration);
				*/
		}
		
		
		//	##################################################################################################################
		//	SEEK UTILITIES
		
		/** Current playhead position (in milliseconds) */
		public function get position():Number {
			if (!_metaData) 
				return 0;
			return _ns.time * 1000;
		}
		public function set position(position:Number):void {
			if (!_loaded)
				_ns.play(_source);
			if (duration < 0)
				return;
			
			if (position < 0)
				position = 0;
			else if (position > duration)
				position = duration;
			
			_ns.seek(position * .001);
			//_playheadPositionChanged.dispatch(this, position / duration);
		}
		/** Current playhead position as a ratio from 0 to 1 */
		public function get positionRatio():Number {
			return position / duration;
		}
		public function set positionRatio(positionRatio:Number):void {
			position = duration * positionRatio;
		}
		/** Current track duration (in milliseconds) or a negative value if information is unavailable */
		public function get duration():Number {
			return _duration;
		}
		
		
		//	##################################################################################################################
		//	VOLUME UTILITIES
		
		/** volume control */
		public function set volume(volume:Number):void {
			var transform:SoundTransform;
			
			_volume = volume;
			
			if(_ns){
				transform = _ns.soundTransform;
				transform.volume = volume;
				_ns.soundTransform = transform;
			}
		}
		public function get volume():Number {
			return _volume;
		}
		/** pan control */
		public function set pan(pan:Number):void {
			var transform:SoundTransform;
			
			_pan = pan;
			
			if(_ns){
				transform = _ns.soundTransform;
				transform.pan = pan;
				_ns.soundTransform = transform;
			}
		}
		public function get pan():Number {
			return _pan;
		}
		
		
		// 	########################################################################################################################################
		//	DIMENSION MANAGEMENT
		
		public function forceMediaDimensions(mediaWidth:Number, mediaHeight:Number):void {
			_mediaWidth = mediaWidth;
			_mediaHeight = mediaHeight;
		}
		/** video source height (in pixels) */
		public function get mediaHeight():Number {
			return _mediaHeight;
		}
		/** video source width (in pixels) */
		public function get mediaWidth():Number {
			return _mediaWidth;
		}
		/** @inheritDoc */
		override public function get width():Number {
			return _screen.width;
		}
		override public function set width(width:Number):void {
			_screen.width = width;
		}
		/** @inheritDoc */
		override public function get height():Number {
			return _screen.height;
		}
		override public function set height(height:Number):void {
			_screen.height = height;
		}	
		
		
		//	##################################################################################################################
		//	NETCONNECTION UTILITIES
		
		private function _ncConnect():void {
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, _ncStatus, false, 0, true);
			_nc.addEventListener(IOErrorEvent.IO_ERROR, _ncError, false, 0, true);
			_nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, _ncError, false, 0, true);
			_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _ncError, false, 0, true);
			try {
				_nc.connect(null);
			}
			catch(e:IOErrorEvent){
			}
		}
		private function _ncStatus(e:NetStatusEvent):void {
			switch(e.info.code) {
				// The connection attempt succeeded
				case "NetConnection.Connect.Success":
					_nsConnect();
					break;
				// The connection was closed successfully
				case "NetConnection.Connect.Closed":
				// The connection attempt did not have permission to access the application
					break;
				case "NetConnection.Connect.Rejected":
				// The connection attempt failed
					break;
				case "NetConnection.Connect.Failed":
					trace("[VideoPlayer.ncStatus] An error occurred during NetConnection connection \"" + e.info.code + "\"");
					break;
				// Packet encoded in an unidentified format
				case "NetConnection.Call.BadVersion":
				// The NetConnection.call method was not able to invoke the server-side method or command
					break;
				case "NetConnection.Call.Failed":
				// An Action Message Format (AMF) operation is prevented for security reasons
				// Either the AMF URL is not in the same domain as the SWF file, or the AMF server does not have a policy file that trusts the domain of the SWF file
					break;
				case "NetConnection.Call.Prohibited":
					trace("[VideoPlayer.ncStatus] An error occurred during NetConnection call: \"" + e.info.code + "\"");
					break;
			}
		}
		private function _ncError(e:Event):void {
			trace("[VideoPlayer.ncError] " + e.toString());
		}
		
		
		//	##################################################################################################################
		//	NETSTREAM UTILITIES
		
		private function _nsConnect():void {
			_ns = new NetStream(_nc);
			_ns.backBufferTime = 0;
			_ns.inBufferSeek = false;
			
			_nsClient = new Object();
			_nsClient.onMetaData = _nsMetaData;
			_nsClient.onPlayStatus = _nsPlayStatus;
			_ns.client = _nsClient;
			
			_ns.addEventListener(NetStatusEvent.NET_STATUS, _nsStatus, false, 0, true);
			_ns.addEventListener(IOErrorEvent.IO_ERROR, _nsError, false, 0, true);
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, _nsError, false, 0, true);
			
			_screen.attachNetStream(_ns);
			
			volume = volume;
			pan = pan;
		}
		private function _nsStatus(e:NetStatusEvent=null):void {
			switch(e.info.code) {
				
				// ----------------------- PLAYBACK
				
				// Playback has started
				case "NetStream.Play.Start":
					//_setState(STATUS_PLAYING);
					break;
					
				// The stream is paused
				case "NetStream.Pause.Notify":
					//_setState(STATUS_PAUSED);
					break;
					
				// The stream is resumed
				case "NetStream.Unpause.Notify":
					//_setState(STATUS_PLAYING);
					break;
				
				// Playback has stopped
				case "NetStream.Play.Stop":
					 //_checkLoop();
					//_setState(STATUS_STOPPED);
					break;
				
				//	Player does not detect any supported tracks (video, audio or data) and will not try to play the file. For Flash Player 9 Update 3 and later
				case "NetStream.Play.NoSupportedTrackFound":
				
				//	Player detects an invalid file structure and will not try to play this type of file. For Flash Player 9 Update 3 and later
				case "NetStream.Play.FileStructureInvalid":
				
				// The FLV passed to the play() method can"t be found
				case "NetStream.Play.StreamNotFound":
				
				// An error has occurred in playback for a reason other than those listed elsewhere in this table, such as the subscriber not having read access
				case "NetStream.Play.Failed" :
					trace("[VideoPlayer.nsStatus] Playback failed (source: " + _source + ") ; " + e.info.code);
					break;
					
					
				case "NetStream.Buffer.Empty":
					//_checkLoop()
					break;
				
				
				// ----------------------- SEEK
				
				// The seek operation is complete.
				case "NetStream.Seek.Notify":
					break;
					
				// The seek fails, which happens if the stream is not seekable
				case "NetStream.Seek.Failed":
					break;
					
				// For video downloaded with progressive download, the user has tried to seek or play past the end of the video data that has downloaded thus far,
				// or past the end of the video once the entire file has downloaded.
				// The "message.details"  property contains a time code that indicates the last valid position to which the user can seek.
				case "NetStream.Seek.InvalidTime":
					break;
			}
		}
		private function _nsError(e:Event):void {
			trace("[VideoPlayer.nsError] " + e.toString());
		}
		private function _nsPlayStatus(o:Object):void {
			switch(o.code) {
				case "NetStream.Play.Complete" :
					_checkLoop();
					break;
			}
		}
		private function _nsMetaData(data:Object):void {
			
			delete _nsClient.onMetaData;
			
			// --- avoid multiple metadata analysis for looped video
			if (_metaData != null) {
				trace("[VideoBox._nsMetaData] Cancels metadata analysis");
				return;
			}
			
			_loaded = true;
			
			_metaData = data;
			_mediaWidth = ("width" in _metaData) ? Number(_metaData.width) : -1;
			_mediaHeight = ("height" in _metaData) ? Number(_metaData.height) : -1;
			_duration = ("duration" in _metaData) ? Number(_metaData.duration) * 1000 : -1;
			trace("[VideoBox._nsMetaData] duration: " + _duration.toFixed(3));
			
			// --- render video at the right size
			_screen.width = _mediaWidth;
			_screen.height = _mediaHeight;
			
			// ---	prepare for snapshot
			if (useSnapshot) {
				trace("[VideoBox._nsMetaData] Create snapshot size: " + _mediaWidth + " x " + _mediaHeight + " px");
				
				//TimerUtils.Method(100, _snapshot);
				_ns.pause();
			}
			// ---	or consider yourself as complete
			else {
				//dispatchEvent(new VgEvent(VgEvent.COMMAND_COMPLETE));
			}
			
			//dispatchEvent(new VgEvent(VgEvent.METADATA_RECEIVED));
		}
		private function _snapshot():void {
			var bmpd:BitmapData;
			
			if(_mediaWidth > 0 && _mediaHeight > 0){
				bmpd = new BitmapData(_mediaWidth, _mediaHeight, true, 0x00000000);
				bmpd.drawWithQuality(this, null, null, null, null, false, StageQuality.BEST);
				_bmp.bitmapData = bmpd;
				_bmp.smoothing = _smoothing;
			}
			else {
				
			}
			
			trace("[VideoBox._snapshot] Do " + (_state == STATUS_PLAYING ? "" : "not ") + "restart");
			if(_state == STATUS_PLAYING)
				resume();
			//dispatchEvent(new VgEvent(VgEvent.COMMAND_COMPLETE));
		}
		
		
		//	##################################################################################################################
		//	PRIVATE UTILITIES
		
		private function _checkLoop():void {
			if (loop) {
				//dispatchEvent(new VgEvent(VgEvent.PLAYBACK_ITERATION_COMPLETE));
				position = 0;
				resume();
			}
			else {
				stop();
				//dispatchEvent(new VgEvent(VgEvent.PLAYBACK_COMPLETE));
			}
		}
		private function _build():void {
			_bmp = new Bitmap();
			addChild(_bmp);
			
			_screen = new Video();
			_screen.smoothing = _smoothing;
			addChild(_screen);
		}
		private function _clearData():void {
			_source = null;
			_metaData = null;
			if(_bmp.bitmapData){
				_bmp.bitmapData.dispose();
				_bmp.bitmapData = null;
			}
			_duration = -1;
			_mediaWidth = -1;
			_mediaHeight = -1;
			_loaded = false;
		}
	}
}