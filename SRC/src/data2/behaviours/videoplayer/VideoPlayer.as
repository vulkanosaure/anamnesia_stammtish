package data2.behaviours.videoplayer 
{
	import data2.asxml.DynamicStateDef;
	import data2.asxml.IDynamicStateContainer;
	import data2.behaviours.Behaviour;
	import data2.display.ClickableSprite;
	import data2.effects.Effect;
	import data2.math.ResizeCalculation;
	import data2.states.IStateActivation;
	import data2.states.StateUtils;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class VideoPlayer extends Behaviour implements IDynamicStateContainer, IStateActivation
	{
		private var _width:Number = 100;
		private var _height:Number = 100;
		private var _autosize:Boolean = false;
		private var _loop:Boolean = false;
		private var _autorewind:Boolean = false;
		private var _autoplay:Boolean = true;
		private var _effectshow:Effect;
		private var _effecthide:Effect;
		
		private var _video2:Video2;
		private var _loaded:Boolean;
		private var _isFullscreen:Boolean;
		
		private var _bgFullscreen:Sprite;
		private var _uiSprite:Sprite;
		private var _loadingSprite:Sprite;
		private var _iconPlay:Sprite;
		
		private var _videoProperty:Object;
		private var _uiProperty:Object;
		private var _loadingProperty:Object;
		private var _videoRealWidth:Number;
		private var _videoRealHeight:Number;
		
		
		
		public function VideoPlayer() 
		{
			trace("new VideoPlayer");
		}
		
		
		//___________________________________________________________________
		//public function
		
		
		override public function init():void 
		{
			trace("VideoPlayer.init");
			_video2 = new Video2();
			_video2.autoRewind = _autorewind;
			_video2.loop = _loop;
			
			_interfaceSprite.addChild(_video2);
			_video2.addEventListener(Video2Event.META_DATA, onVideoMeta);
			_video2.addEventListener(Video2Event.FINISHED, onVideoFinished);
			_video2.addEventListener(Video2Event.BUFFER_START, onBufferStart);
			_video2.addEventListener(Video2Event.BUFFER_STOP, onBufferStop);
			_video2.addEventListener(MouseEvent.CLICK, onClickPlayPause);
			
			_isFullscreen = false;
			
			
			if (!_autosize) {
				_interfaceSprite.layoutWidth = _width;
				_interfaceSprite.layoutHeight = _height;
			}
			
			
			var _tab:Array;
			_tab = StateUtils.getDisplayObjectByName(_interfaceSprite, "play");
			var _btnplay:InteractiveObject = (_tab.length > 0) ? InteractiveObject(_tab[0]) : null;
			
			_tab = StateUtils.getDisplayObjectByName(_interfaceSprite, "pause");
			var _btnpause:InteractiveObject = (_tab.length > 0) ? InteractiveObject(_tab[0]) : null;
			
			_tab = StateUtils.getDisplayObjectByName(_interfaceSprite, "fullscreen");
			var _btnfs:InteractiveObject = (_tab.length > 0) ? InteractiveObject(_tab[0]) : null;
			
			if (_btnplay != null) {
				_btnplay.addEventListener(MouseEvent.CLICK, onClickPlay);
				if(_btnplay is DisplayObjectContainer) ClickableSprite.updateClickable(DisplayObjectContainer(_btnplay));
			}
			if (_btnpause != null) {
				_btnpause.addEventListener(MouseEvent.CLICK, onClickPause);
				if(_btnpause is DisplayObjectContainer) ClickableSprite.updateClickable(DisplayObjectContainer(_btnpause));
			}
			if (_btnfs != null) {
				_btnfs.addEventListener(MouseEvent.CLICK, onClickFS);
				if(_btnfs is DisplayObjectContainer) ClickableSprite.updateClickable(DisplayObjectContainer(_btnfs));
			}
			
			_uiSprite = Sprite(_interfaceSprite.getChildByName("ui"));
			trace("_uiSprite : " + _uiSprite);
			if (_uiSprite != null) _interfaceSprite.addChild(_uiSprite);
			
			_loadingSprite = Sprite(_interfaceSprite.getChildByName("loading"));
			trace("_loadingSprite : " + _loadingSprite);
			if (_loadingSprite != null) _interfaceSprite.addChild(_loadingSprite);
			
			_iconPlay = Sprite(_interfaceSprite.getChildByName("icon_play"));
			trace("_iconPlay : " + _iconPlay);
			if (_iconPlay != null) {
				_interfaceSprite.addChild(_iconPlay);
				_iconPlay.addEventListener(MouseEvent.CLICK, onClickPlay);
			}
			
			
			
			
			//fullscreen
			_bgFullscreen = new Sprite();
			var _stage:Stage = _interfaceSprite.stage;
			trace("_stage : " + _stage);
			_stage.addEventListener(Event.FULLSCREEN, onFullscreen);
			
		}
		
		
		
		public function goto_(_dynStateDef:DynamicStateDef):void
		{
			trace("VideoPlayer.goto(" + _dynStateDef + ")");
			trace("_index : " + _dynStateDef.index);
			
			_loaded = false;
			//_video2.clear();
			_video2.setURL(_dynStateDef.src);
			this.play();
		}
		
		public function play():void 
		{
			_video2.play();
			if (_iconPlay != null) _iconPlay.visible = false;
		}
		
		public function stop():void 
		{
			_video2.stop();
			if (_iconPlay != null) _iconPlay.visible = true;
		}
		public function pause():void 
		{
			_video2.pause();
			if (_iconPlay != null) _iconPlay.visible = true;
		}
		
		
		
		//___________________________________________________________________
		//set / get
		
		public function set width(value:Number):void {_width = value;}
		
		public function set height(value:Number):void {_height = value;}
		
		public function set autosize(value:Boolean):void {_autosize = value;}
		
		public function set loop(value:Boolean):void {_loop = value;}
		
		public function set autorewind(value:Boolean):void{_autorewind = value;}
		
		public function set autoplay(value:Boolean):void { _autoplay = value; }
		
		
		public function set effectshow(value:Effect):void 
		{
			_effectshow = value;
		}
		
		public function set effecthide(value:Effect):void 
		{
			_effecthide = value;
		}
		
		public function get isPlaying():Boolean 
		{
			return _video2.isPlaying;
		}
		
		
		public function setFullscreen(_value:Boolean):void
		{
			if (!_loaded) return;
			trace("VideoPlayer.setFullscreen(" + _value + ")");
			
			var _stage:Stage = _interfaceSprite.stage;
			if (_value) {
				if (_stage.displayState == StageDisplayState.NORMAL && !_isFullscreen) {
					internal_setFullscreen();
				}
			}
			else{
				if (_stage.displayState == StageDisplayState.FULL_SCREEN && _isFullscreen) {
					//trace("yo");
					_stage.displayState = StageDisplayState.NORMAL;
				}
			}
		}
		
		
		public function state_activate():void
		{
			
		}
		public function state_deactivate():void
		{
			this.stop();
		}
		
		
		
		
		//___________________________________________________________________
		//private function
		
		
		private function internal_setFullscreen():void 
		{
			_uiProperty = new Object();
			if (_uiSprite != null) {
				_uiProperty.x = _uiSprite.x;
				_uiProperty.y = _uiSprite.y;
			}
			
			if (_loadingSprite != null) {
				_loadingProperty = new Object();
				_loadingProperty.x = _loadingSprite.x;
				_loadingProperty.y = _loadingSprite.y;
			}
			
			var _stage:Stage = _interfaceSprite.stage;
			if(_stage.displayState != StageDisplayState.FULL_SCREEN) _stage.displayState = StageDisplayState.FULL_SCREEN;
			var g:Graphics = _bgFullscreen.graphics;
			g.clear();
			g.beginFill(0x000000, 1);
			g.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			_bgFullscreen.x = 0;
			_bgFullscreen.y = 0;
			
			
			var _resizeDims:Point = ResizeCalculation.getResize(ResizeCalculation.BORDER, new Point(_videoRealWidth, _videoRealHeight), new Point(_stage.stageWidth, _stage.stageHeight));
			_video2.width = _resizeDims.x;
			_video2.height = _resizeDims.y;
			_video2.x = _stage.stageWidth / 2 - _resizeDims.x / 2;
			_video2.y = _stage.stageHeight / 2 - _resizeDims.y / 2;
			
			if (_uiSprite != null) {
				_uiSprite.x = _stage.stageWidth / 2 - _uiSprite.width / 2;
				_uiSprite.y = _stage.stageHeight - _uiSprite.height;
			}
			
			if (_loadingSprite != null){
				_loadingSprite.x = _stage.stageWidth / 2 - _loadingSprite.width / 2;
				_loadingSprite.y = _stage.stageHeight / 2 - _loadingSprite.height / 2;
			}
			
			_stage.addChild(_bgFullscreen);
			_stage.addChild(_video2);
			if (_uiSprite != null) _stage.addChild(_uiSprite);
			if (_loadingSprite != null) _stage.addChild(_loadingSprite);
			
			_isFullscreen = true;
			
		}
		
		private function internal_unsetFullscreen():void 
		{
			var _stage:Stage = _interfaceSprite.stage;
			
			/*if (_stage.contains(_bgFullscreen)) */_stage.removeChild(_bgFullscreen);
			_interfaceSprite.simpleAddChild(_video2);
			if (_uiSprite != null) _interfaceSprite.simpleAddChild(_uiSprite);
			if (_loadingSprite != null) _interfaceSprite.simpleAddChild(_loadingSprite);
			
			_video2.x = _videoProperty.x;
			_video2.y = _videoProperty.y;
			_video2.width = _videoProperty.width;
			_video2.height = _videoProperty.height;
			
			if (_uiSprite != null) {
				_uiSprite.x = _uiProperty.x;
				_uiSprite.y = _uiProperty.y;
			}
			
			if (_loadingSprite != null){
				_loadingSprite.x = _loadingProperty.x;
				_loadingSprite.y = _loadingProperty.y;
			}
			
			_isFullscreen = false;
		}
		
		
		
		
		
		
		
		
		
		//___________________________________________________________________
		//events
		
		
		
		private function onVideoMeta(e:Video2Event):void 
		{
			if (_loaded) return;
			_loaded = true;
			trace("VideoPlayer.onVideoMeta");
			
			_video2.init(e.obj.width, e.obj.height);
			_video2.rewind();
			if (_autoplay) this.play();
			else this.stop();
			
			if (!_autosize) {
				
				var _resizeDims:Point = ResizeCalculation.getResize(ResizeCalculation.BORDER, new Point(e.obj.width, e.obj.height), new Point(_width, _height));
				_video2.width = _resizeDims.x;
				_video2.height = _resizeDims.y;
				_video2.x = _width / 2 - _resizeDims.x / 2;
				_video2.y = _height / 2 - _resizeDims.y / 2;
			}
			else {
				_interfaceSprite.layoutWidth = e.obj.width;
				_interfaceSprite.layoutHeight = e.obj.height;
			}
			
			/*
			 * probleme, 
			 * qd on recommence une video,
			 * save des props :
				 * ui : avt de mettre en fullscreen (fonction internal_setFullscreen)
				 * video : a l'init de la vidéo
			 * 
			 * */
			
			
			//save props !fs
			
			_videoProperty = new Object();
			_videoProperty.x = _video2.x;
			_videoProperty.x = _video2.y;
			_videoProperty.width = _video2.width;
			_videoProperty.height = _video2.height;
			
			_videoRealWidth = e.obj.width;
			_videoRealHeight = e.obj.height;
			
			if (_isFullscreen) {
				if (_uiSprite != null) {
					_uiSprite.x = _uiProperty.x;
					_uiSprite.y = _uiProperty.y;
				}
				if (_loadingSprite != null) {
					_loadingSprite.x = _loadingProperty.x;
					_loadingSprite.y = _loadingProperty.y;
				}
				internal_setFullscreen();
			}
			
		}
		
		private function onVideoFinished(e:Video2Event):void 
		{
			trace("VideoPlayer.onVideoFinished");
			var _evt:Video2Event = new Video2Event(Video2Event.FINISHED);
			this.dispatchEvent(_evt);
			if (_autorewind) {
				_video2.rewind();
				this.stop();
			}
			
		}
		
		
		
		private function onClickPlayPause(e:MouseEvent):void 
		{
			if (isPlaying) this.pause();
			else this.play();
		}
		
		
		
		private function onClickPlay(e:MouseEvent):void 
		{
			trace("onClickPlay");
			this.play();
			
		}
		
		private function onClickPause(e:MouseEvent):void 
		{
			trace("onClickPause");
			this.pause();
			
		}
		
		private function onClickFS(e:MouseEvent):void 
		{
			//todo : empecher si la vidéo n'est pas chargée
			if (!_loaded) return;
			
			trace("onClickFS");
			if(!_isFullscreen) internal_setFullscreen();
			else {
				var _stage:Stage = _interfaceSprite.stage;
				_stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		
		private function onFullscreen(e:Event):void 
		{
			var _stage:Stage = _interfaceSprite.stage;
			if (_stage.displayState != StageDisplayState.FULL_SCREEN && _isFullscreen) {
				internal_unsetFullscreen();
			}
		}
		
		
		
		private function onBufferStart(e:Video2Event):void 
		{
			if (_loadingSprite != null) {
				_loadingSprite.visible = true;
			}
		}
		
		private function onBufferStop(e:Video2Event):void 
		{
			if (_loadingSprite != null) {
				_loadingSprite.visible = false;
			}
		}
		
		
		
	}

}