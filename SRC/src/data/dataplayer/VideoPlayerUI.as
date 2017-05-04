package data.dataplayer {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.FullScreenEvent;
	import flash.display.StageDisplayState;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.geom.Point;

	
	import data.video.VideoPlayer;
	import data.video.VideoEvent;
	import data.dataplayer.ControlBar;
	import data.dataplayer.Option;
	import data.dataplayer.VolumeEvent;
	import data.dataplayer.TimelineEvent;
	
	import data.dataplayer.pages.*;
	import data.net.PHPManager;
	
	
	
	
	
	
	public class VideoPlayerUI extends MovieClip{
		
		var fs_on:Boolean = false;
		var st:Stage;
		var url:String;
		var autoplay:Boolean;
		var loop:Boolean;
		var videoWidth:int;
		var videoHeight:int;
		var video_resize_width:Number;
		var video_resize_height:Number;
		var video_resize_x:Number;
		var video_resize_y:Number;
		var video_width:Number;
		var video_height:Number;
		var _width:int;
		var _height:int;
		var cbWidth:Number;
		var cbHeight:Number;
		
		//displayobjects
		var videoplayer:VideoPlayer;
		var controlbar:ControlBar;
		var iconPause:MovieClip;
		var mcCadre:MovieClip;
			//controlbar
		var tlFond:MovieClip;
		var tlDownload:MovieClip;
		var tlProgress:MovieClip;
		var mcBuffer:MovieClip;
		
		var option_fermer:Option;
		var btnScreenshot:MovieClip;
		var count_iddle:int;
		var cbar_displayed:Boolean;
		var mouseOverCBar:Boolean;
		var autosize:Boolean;
		var smoothing:Boolean = true;
		var iconPauseAtStart:Boolean = false;
		var autorewind:Boolean = true;
		var iddletime:int;
		var framerate:int;
		var bAdmin:Boolean;
		var firstMetaData = true;
		var firstMetaData2 = true;
		var bclickfullscreen:Boolean = false;
		var bInterfaceVisible:Boolean = true;
		
		var fade_in:Boolean = false;
		var fade_out:Boolean = false;
		var fade_speed:Number;
		var fadingtime:Number;
		
		var frame_color:int;
		var frame_thickness:int;
		
		var padding:Number;
		
		var phpDir:String;
		var sshotDir:String;
		var templateDir:String;
		
		var cbar_pbottom:Number;
		var cbar_pside:Number;
		var cbar_pleft:Number;
		
		var btnclose_pright:Number;
		var btnclose_ptop:Number;
		var btnclose_width:Number;
		var btnclose_height:Number;
		
		//pages
		var cache_page:Shape;
		var page_embarquer:Page_embarquer;
		var page_partager:Page_partager;
		var page_envoyer:Page_envoyer;
		var page_credit:Page_credit;
		
		
		
		
		
		//============================================================================
		//public functions
		
		//appelé 1 seule fois
		public function VideoPlayerUI(stage:Stage, _admin:Boolean=false) 
		{ 
			st = stage;
			bAdmin = _admin;
			count_iddle = 0;
			cbar_displayed = true;
			mouseOverCBar = false;
			framerate = st.frameRate;
			
			//trace("Constructor VideoPlayerUI");
			videoplayer = new VideoPlayer();
			
			controlbar = new ControlBar(st);
			mcCadre = new MovieClip();
			
			page_embarquer = new Page_embarquer();
			page_partager = new Page_partager();
			page_envoyer = new Page_envoyer(stage);
			page_credit = new Page_credit();
			
			
			
			//addEventListener(...)
			
			videoplayer.addEventListener(VideoEvent.META_DATA, onMetaData);
			
			
			cache_page = new Shape();
			cache_page.visible = false;
			page_embarquer.visible = false;
			page_partager.visible = false;
			page_envoyer.visible = false;
			page_credit.visible = false;
		}
		
		
		function onMetaData(e:VideoEvent)
		{
			//trace("VideoPlayerUI::onMetaData");
			if(firstMetaData2) resizeAfterMeta(e.obj.width, e.obj.height);
			firstMetaData2 = false;
		}
		
		
		public function resize(w:Number, h:Number):void
		{
			videoWidth = w;
			videoHeight = h;
			resizeAfterMeta(video_width, video_height);
			redraw();
			setFullscreen();
			controlbar.x += 10;
			if(videoplayer.isPlaying) iconPause.visible = false;
		}
		
		public function getControlbar():ControlBar
		{
			return controlbar;
		}
		
		public function reset():void
		{
			videoplayer.clear();
		}
		
		private function resizeAfterMeta(w:Number, h:Number):void
		{
			video_width = w;
			video_height = h;
			//trace("video_dims : "+video_width+", "+video_height);
			
			//Redimensionnement et centrage en mode border (tester avec padding et frame)
			//trace("autosize : "+autosize);
			
			if(!autosize){
				//trace("videoWidth : "+videoWidth+", videoHeight : "+videoHeight);
				
				var pt_resize:Point = getBorderResize(video_width, video_height, videoWidth-2*padding, videoHeight-2*padding);
				video_resize_width = pt_resize.x;
				video_resize_height = pt_resize.y;
				videoplayer.width = video_resize_width;
				videoplayer.height = video_resize_height;
				
				video_resize_x = videoWidth/2 - video_resize_width/2;
				video_resize_y = videoHeight/2 - video_resize_height/2;
				videoplayer.x = video_resize_x;
				videoplayer.y = video_resize_y;
				
				
			}
			
			if(firstMetaData){
				redraw();
			}
		}
		
		
		
		private function getBorderResize(_wbase, _hbase, _wtarget, _htarget):Point
		{
			var _scalex, _scaley, _scale:Number;
			_scalex = _wtarget / _wbase;
			_scaley = _htarget / _hbase;
			_scale = (_scalex < _scaley) ? _scalex : _scaley;
			return new Point(_wbase*_scale, _hbase*_scale);
		}
		
		
		private function redraw():void
		{
			//trace("VPUI :: redraw()");
			//trace("dims : "+videoWidth+", "+videoHeight);
			page_embarquer.videoWidth = videoWidth;
			page_embarquer.videoHeight = videoHeight;
			page_embarquer.init();
			
			
			_width = videoWidth + 2*padding;
			_height = videoHeight + 2*padding;
			
			videoplayer.x = padding;
			videoplayer.y = padding;
			
			videoplayer.buttonMode = true;
			//init la taille de VideoPlayerUI
			
			var _w:Number = _width - 2*cbar_pside;
			if(!autosize) _w -= 2*padding;
			
			controlbar.setDimensions(_w, cbHeight);
			controlbar.setElements();
			controlbar.setProgress(0);
			setElements();
			iconPause.visible= (!autoplay && iconPauseAtStart);
			dispatchEvent(new Event("VIDEO_CHANGE_SIZE"));
			addEventListener(Event.ENTER_FRAME, updateProgress);
			firstMetaData = false;
		}
		
		//nettoie tout pour qu'on puisse relancer une nouvelle video
		public function clear():void
		{
			videoplayer.clear();
			controlbar.clear();
			while(numChildren) removeChildAt(0);
		}
		
		override public function play():void
		{
			playVideo();
		}
		
		public function pause():void
		{
			pauseVideo();
		}
		
		public function rewind():void
		{
			videoplayer.rewind();
		}
		
		
		public function addEventListeners():void
		{
			addEventListener(Event.ENTER_FRAME, updateDownload);
			addEventListener(Event.ENTER_FRAME, handleIddleness);
			addEventListener(Event.ENTER_FRAME, handleFading);
			videoplayer.addEventListener(MouseEvent.CLICK, onClickVideo);
			videoplayer.addEventListener("BUFFERING_START", onStartBuffering);
			videoplayer.addEventListener("BUFFERING_STOP", onStopBuffering);
			videoplayer.addEventListener("AUTOREWIND", onAutoRewind);
			
			st.addEventListener(MouseEvent.MOUSE_MOVE, onmousemove);
			st.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			
			
			controlbar.addEventListener("VOLUME_CHANGE", onVolumeChange);
			controlbar.addEventListener(TimelineEvent.CHANGE_PLAYHEAD, onClickTimeline);
			controlbar.addEventListener(ControlEvent.PLAY, onPlay);
			controlbar.addEventListener(ControlEvent.PAUSE, onPause);
			controlbar.addEventListener(ControlEvent.REWIND, onRewind);
			controlbar.addEventListener("CLICK_FULLSCREEN", onClickFullscreen);
			controlbar.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverCBar);
			controlbar.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutCBar);
			controlbar.addEventListener("CLICK_EMBARQUER", onClickEmbarquer);
			controlbar.addEventListener("CLICK_PARTAGER", onClickPartager);
			controlbar.addEventListener("CLICK_ENVOYER", onClickEnvoyer);
			controlbar.addEventListener("CLICK_CREDIT", onClickCredit);
			page_embarquer.addEventListener("CLOSE", onClosePage);
			page_partager.addEventListener("CLOSE", onClosePage);
			page_envoyer.addEventListener("CLOSE", onClosePage);
			page_envoyer.addEventListener("FOCUS_INPUT", dispatchEvent);
			page_credit.addEventListener("CLOSE", onClosePage);
			page_embarquer.addEventListener("PAGE_VISIBLE", onOpenPage);
			page_partager.addEventListener("PAGE_VISIBLE", onOpenPage);
			page_envoyer.addEventListener("PAGE_VISIBLE", onOpenPage);
			page_credit.addEventListener("PAGE_VISIBLE", onOpenPage);
		}
		
		public function removeEventListeners():void
		{
			removeEventListener(Event.ENTER_FRAME, updateDownload);
			removeEventListener(Event.ENTER_FRAME, handleIddleness);
			removeEventListener(Event.ENTER_FRAME, handleFading);
			videoplayer.removeEventListener(MouseEvent.CLICK, onClickVideo);
			
			st.removeEventListener(MouseEvent.MOUSE_MOVE, onmousemove);
			st.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			
			
			controlbar.removeEventListener("VOLUME_CHANGE", onVolumeChange);
			controlbar.removeEventListener(TimelineEvent.CHANGE_PLAYHEAD, onClickTimeline);
			controlbar.removeEventListener(ControlEvent.PLAY, onPlay);
			controlbar.removeEventListener(ControlEvent.PAUSE, onPause);
			controlbar.removeEventListener(ControlEvent.REWIND, onRewind);
			controlbar.removeEventListener("CLICK_FULLSCREEN", onClickFullscreen);
			controlbar.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverCBar);
			controlbar.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutCBar);
			controlbar.removeEventListener("CLICK_EMBARQUER", onClickEmbarquer);
			controlbar.removeEventListener("CLICK_PARTAGER", onClickPartager);
			controlbar.removeEventListener("CLICK_ENVOYER", onClickEnvoyer);
			controlbar.removeEventListener("CLICK_CREDIT", onClickCredit);
			page_embarquer.removeEventListener("CLOSE", onClosePage);
			page_partager.removeEventListener("CLOSE", onClosePage);
			page_envoyer.removeEventListener("CLOSE", onClosePage);
			page_envoyer.removeEventListener("FOCUS_INPUT", dispatchEvent);
			page_credit.removeEventListener("CLOSE", onClosePage);
			page_embarquer.removeEventListener("PAGE_VISIBLE", onOpenPage);
			page_partager.removeEventListener("PAGE_VISIBLE", onOpenPage);
			page_envoyer.removeEventListener("PAGE_VISIBLE", onOpenPage);
			page_credit.removeEventListener("PAGE_VISIBLE", onOpenPage);
		}
		
		
		
		
		//appelé 1 seule fois
		public function setMC(embarquer:MovieClip, partager:MovieClip, fermer:MovieClip, 
							  envoyer:MovieClip, credit:MovieClip, fson:MovieClip, fsoff:MovieClip, volume:MovieClip, 
							  slidevolume:MovieClip, sv_track:MovieClip, sv_handle:MovieClip, sv_mask:MovieClip,
							  iconpause:MovieClip, btnplay:MovieClip, btnpause:MovieClip,
							  btnrewind:MovieClip, cbfond:MovieClip, tlfond:MovieClip, tldownload:MovieClip,
							  tlprogress:MovieClip, btnscreenshot:MovieClip, mcbuffer:MovieClip):void
		{
			
			var array2resize:Array = new Array();
			array2resize = [embarquer, partager, fermer, envoyer, credit, fson, fsoff, volume, slidevolume, sv_track, sv_handle, sv_mask, btnplay, btnpause, btnrewind, cbfond, tlfond, tldownload, tlprogress, btnscreenshot];
			for(var i in array2resize) array2resize[i].scaleX = array2resize[i].scaleY = 1.5;
			
			
			
			mcBuffer = mcbuffer;
			iconPause = iconpause;
			//control bar
			tlFond = tlfond;
			tlDownload = tldownload;
			tlProgress = tlprogress;
			
			option_fermer = new Option(false, fermer);
			option_fermer.addEventListener(MouseEvent.CLICK, onClose);
			btnScreenshot = btnscreenshot;
			btnScreenshot.addEventListener(MouseEvent.CLICK, onScreenshot);
			iconPause.addEventListener(MouseEvent.CLICK, onClickVideo);
			iconPause.buttonMode = true;
			
			controlbar.setOptionsMC(embarquer, partager, envoyer, credit, volume, fson, fsoff, slidevolume, sv_track, sv_handle, sv_mask);
			controlbar.setControlsMC(btnplay, btnpause, btnrewind);
			controlbar.setOtherMC(cbfond);
			controlbar.setTimelineMC(tlfond, tldownload, tlprogress);
			
			cbHeight = cbfond.height;
			
		}
		
		
		public function setOptionsAvailability(embarquer:Boolean, partager:Boolean, envoyer:Boolean, 
											   credit:Boolean, vol:Boolean, fs:Boolean, fermer:Boolean)
		{
			option_fermer.available = fermer;
			controlbar.setOptionsAvailability(embarquer, partager, envoyer, credit, vol, fs);
		}
		
		
		public function setOptions(_autoplay:Boolean, _loop:Boolean, _smoothing:Boolean, _iconPauseAtStart:Boolean, _autorewind:Boolean, _voldefaut:Number, _iddletime:Number, _fadingtime:Number)
		{
			autoplay = _autoplay;
			loop = _loop;
			if(_voldefaut<0) _voldefaut = 0;
			if(_voldefaut>100) _voldefaut = 100;
			volume = _voldefaut;
			fadingtime = _fadingtime;
			iddletime = _iddletime;
			smoothing = _smoothing;
			iconPauseAtStart = _iconPauseAtStart;
			autorewind = _autorewind;
			videoplayer.autoRewind = autorewind;
			
			if(fadingtime<1) fadingtime = 1;	//secu /0 =>bug
			fade_speed = 1/(fadingtime/1000*framerate);
		}
		
		public function setPaths(phpdir:String, sshotdir:String, templatedir:String, _urlcredits:String, _urlplayer:String, _videowidth:Number, _videoheight:Number,  _pagetitle:String, _captureurl:String, _urlplayercomplete:String)
		{
			phpDir = phpdir;
			page_envoyer.phpdir = phpDir;
			sshotDir = sshotdir;
			templateDir = templatedir;
			page_credit.urlcredits = _urlcredits;
			
			page_embarquer.urlplayer = _urlplayer;
			page_partager.urlplayer = _urlplayercomplete;
			page_envoyer.urlplayer = _urlplayer;
			page_envoyer.urlcredits = _urlcredits;
			page_envoyer.pagetitle = _pagetitle;
			page_envoyer.captureurl = _captureurl;
			page_envoyer.urlplayercomplete = _urlplayercomplete;
			videoWidth = _videowidth;
			videoHeight = _videoheight;
			/*
			trace("______________________________");
			trace("urlcredits : "+_urlcredits);
			trace("_urlplayer : "+_urlplayer);
			trace("_urlplayercomplete : "+_urlplayercomplete);
			trace("_pagetitle : "+_pagetitle);
			trace("_captureurl : "+_captureurl);
			*/
			/*
			urlcredits : addresse de notre agence
			urlplayer : addresse principal vers le site
			pagetitle : envoyé dans le mail
			captureurl : url vers la capture envoyé ds le mail (null si 1seul player, sinon besoin de différencier)
			urlplayercomplete : addresse exacte vers la page contenant le player
			*/
			
			
		}
		public function setSharingURL(_url:String)
		{
			page_partager.urlplayer = _url;
		}
		
		public function setFacebookURL(str:String)
		{
			page_partager.urlfacebook = str;
		}
		
		public function setTimerFormat(size:int, font:String, color:int)
		{
			controlbar.setTimerFormat(size, font, color);
		}
		
		public function setTimerPadding(ptop:Number, pleft:Number, pright:Number)
		{
			controlbar.setTimerPadding(ptop, pleft, pright);
		}
		
		public function setFrame(color:int, thickness:Number)
		{
			frame_color = color;
			frame_thickness = thickness;
		}
		
		public function setCBarProperty(pbottom:Number, pside:Number, pleft:Number, spaceoptions:Number, spacerewindplay:Number)
		{
			cbar_pbottom = pbottom;
			cbar_pside = pside;
			cbar_pleft = pleft;
			controlbar.setBtnPaddings(spaceoptions, spacerewindplay);
		}
		
		public function setPadding(_padding:Number, close_ptop:Number, close_pright:Number)
		{
			padding = _padding;
			btnclose_ptop = close_ptop;
			btnclose_pright = close_pright;
		}
		
		public function setDimsBtns(opt_width:Number, opt_height:Number, close_width:Number, close_height:Number)
		{
			btnclose_width = close_width;
			btnclose_height = close_height;
			controlbar.setDimsBtn(opt_width, opt_height);
		}
		
		
		public function set volume(v:Number)
		{
			controlbar.volume = v;
			videoplayer.volume = v;
		}
		
		
		public function playPause():void
		{
			if(videoplayer.isPlaying) pauseVideo();
			else playVideo();
		}
		
		
		//appelé pour autant de vidéos qu'on veut lancer
		public function init(_url:String, _width:Number=-1, _height:Number=-1, _autosize:Boolean=true):void
		{
			//trace("VideoPlayerUI :: init (_autosize:"+_autosize+")");
			autosize = _autosize;
			url = _url;
			page_embarquer.urlvideo = url;
			controlbar.autoplay = autoplay;
			mcBuffer.visible = true;
			if(_width!=-1) videoWidth = _width;
			if(_width!=-1) videoHeight = _height;
			
			videoplayer.init(videoWidth, videoHeight, smoothing);
			videoplayer.setURL(url);
			videoplayer.loop = loop;
			if(autoplay) videoplayer.play();
			
		}
		
		public function update():void
		{
			redraw();
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//============================================================================
		//private functions
		
		private function setElements()
		{
			addChild(videoplayer);
			addChild(controlbar);
			addChild(iconPause);
			addChild(mcBuffer);
			addChild(cache_page);
			addChild(page_embarquer);
			addChild(page_partager);
			addChild(page_envoyer);
			addChild(page_credit);
			addChild(mcCadre);
			
			//btn fermer
			if(option_fermer.available){
				option_fermer.gotoAndStop(1);
				addChild(option_fermer);
			}
			
			//btn screenshot
			if(bAdmin) addChild(btnScreenshot);
			btnScreenshot.buttonMode = true;
			
			positionElements(fs_on);
			
		}
		
		public function setInterfaceUnvisible():void
		{
			controlbar.visible = false;
			bInterfaceVisible = false;
		}
		
		
		private function positionElements(fs:Boolean)
		{
			var w:Number;
			var h:Number;
			if(!fs){
				if(autosize){
					w = _width;
					h = _height;
				}
				else{
					w = _width - 2 * padding;
					h = _height - 2 * padding;
				}
			}
			else{
				//w = videoplayer.width;
				//h = videoplayer.height;
				w = st.stageWidth;
				h = st.stageHeight;
			}
			
			iconPause.x = w / 2 - iconPause.width/2;
			iconPause.y = h / 2 - iconPause.height/2;
			
			mcBuffer.x = w / 2;
			mcBuffer.y = h / 2;
			
			var fermer_width:Number = btnclose_width;
			option_fermer.x = w - fermer_width - btnclose_pright;
			option_fermer.y = 0 + btnclose_ptop;
			btnScreenshot.x = padding;
			btnScreenshot.y = padding;
			if(fs) controlbar.x = w/2 - controlbar.width/2;
			else controlbar.x = cbar_pside;
			
			controlbar.x += cbar_pleft;
			controlbar.y = h - cbHeight - cbar_pbottom;
			
			
			var g:Graphics = mcCadre.graphics;
			g.clear();
			
			if(!fs && frame_thickness>0){
				g.lineStyle(frame_thickness, frame_color, 100);
				g.drawRect(0+frame_thickness/2, 0+frame_thickness/2, w-frame_thickness, h-frame_thickness);
			}
			
			
			
			//cache pages
			cache_page.graphics.clear();
			cache_page.graphics.beginFill(0x000000, 0.8);
			cache_page.graphics.drawRect(0, 0, w, h);
			
			
			//pages
			page_embarquer.setX(w/2 - page_embarquer.width/2);
			page_embarquer.setY(h/2 - page_embarquer.height/2);
			page_partager.setX(w/2 - page_partager.width/2);
			page_partager.setY(h/2 - page_partager.height/2);
			page_envoyer.setX(w/2 - page_envoyer.width/2);
			page_envoyer.setY(h/2 - page_envoyer.height/2);
			page_credit.setX(w/2 - page_credit.width/2);
			page_credit.setY(h/2 - page_credit.height/2);
			
		}
		
		
		public function setFullscreen()
		{
			bclickfullscreen = true;
			var vp:VideoPlayer = videoplayer;
			
			var pt_resize:Point = getBorderResize(video_width, video_height, st.stageWidth, st.stageHeight);
			vp.width = pt_resize.x;
			vp.height = pt_resize.y;
			
			vp.x = st.stageWidth/2 - vp.width/2;
			vp.y = st.stageHeight/2 - vp.height/2;
			
			controlbar.fullscreen = true;
			positionElements(true);
			controlbar.alpha = 1;
			fs_on = true;
		}
		
		public function unsetFullscreen()
		{
			bclickfullscreen = false;
			var vp:VideoPlayer = videoplayer;
			if(autosize){
				vp.width = videoWidth;
				vp.height = videoHeight;
				vp.x = padding;
				vp.y = padding;
			}
			else{
				vp.x = video_resize_x;
				vp.y = video_resize_y;
				vp.width = video_resize_width;
				vp.height = video_resize_height;
			}
			controlbar.fullscreen = false;
			positionElements(false);
			controlbar.alpha = 1;
			fs_on = false;
		}
		
		private function showCBar():void
		{
			if(!bInterfaceVisible) return;
			fade_in = true;
			fade_out = false;
			cbar_displayed = true;
			controlbar.sliderVisible = false;
			controlbar.visible = true;
			option_fermer.visible = true;
		}
		
		private function hideCBar()
		{
			fade_out = true;
			fade_in = false;
			cbar_displayed = false;
		}
		
		private function explainPosition(_dobj:DisplayObject):void
		{
			var _parent:DisplayObject = _dobj;
			trace("explainPosition("+_dobj+")");
			while(true){
				trace("   "+_parent+".pos : ["+_parent.x+", "+_parent.y+"]");
				if(_parent==stage) break;
				_parent = _parent.parent;
				
			}
		}
		
		
		private function playVideo()
		{
			videoplayer.play();
			controlbar.status = "play";
			iconPause.visible = false;
		}
		
		private function pauseVideo(_bAutorewind:Boolean=false)
		{
			videoplayer.pause();
			controlbar.status = "pause";
			iconPause.visible = true;
			if(!iconPauseAtStart && _bAutorewind) iconPause.visible = false;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		//============================================================================
		//events handler
		private function updateProgress(e:Event)
		{
			controlbar.setProgress(videoplayer.progress);
			controlbar.currentTime = videoplayer.currentTime;
		}
		
		private function updateDownload(e:Event)
		{
			controlbar.setDownload(videoplayer.download);
		}
		
		
		private function onClose(e:MouseEvent)
		{
			//trace("onClose");
			this.dispatchEvent(new Event("CLOSE_PLAYER"));
		}
		
		private function onVolumeChange(e:Event)
		{
			videoplayer.volume = controlbar.volume;
		}
		
		private function onClickTimeline(te:TimelineEvent)
		{
			videoplayer.gotoPercent(te.percent);
		}
		
		
		private function onPlay(e:ControlEvent)
		{
			//trace("onPlay");
			playVideo();
		}
		private function onPause(e:ControlEvent)
		{
			//trace("onPause");
			pauseVideo();
		}
		private function onRewind(e:ControlEvent)
		{
			//trace("onRewind");
			videoplayer.rewind();
		}
		
		
		
		private function onClickFullscreen(e:Event)
		{
			if(st.displayState == StageDisplayState.NORMAL) fs_on = false;
			fs_on = !fs_on;
			controlbar.alpha = 0;
			if(fs_on) dispatchEvent(new Event("FULLSCREEN_ON"));
			else dispatchEvent(new Event("FULLSCREEN_OFF"));
		}
		
		
		
		private function handleIddleness(e:Event)
		{
			count_iddle++;
			if(cbar_displayed){
				if(count_iddle > iddletime/1000 * framerate){
					//trace("handleIddleness");
					if(!mouseOverCBar) hideCBar();
				}
			}
		}
		
		private function onmousemove(e:MouseEvent)
		{
			var pt:Point = this.globalToLocal(new Point(st.mouseX, st.mouseY));
			if((pt.x<0 || pt.y<0 || pt.x>_width || pt.y>_height) && !fs_on){
				if(cbar_displayed) hideCBar();
				return;
			}
			count_iddle = 0;
			if(!cbar_displayed){
				showCBar();
			}
		}
		
		private function onMouseLeave(e:Event)
		{
			//trace("onMouseLeave");
			hideCBar();
		}
		private function onClickVideo(e:MouseEvent)
		{
			//trace("onClickVideo");
			playPause();
			//explainPosition(videoplayer);
		}
		
		private function handleFading(e:Event):void
		{
			if(!bInterfaceVisible) return;
			if(fade_in){
				controlbar.alpha += fade_speed;
				option_fermer.alpha += fade_speed;
				if(controlbar.alpha >= 1){
					controlbar.alpha = 1;
					option_fermer.alpha = 1;
					fade_in = false;
				}
			}
			else if(fade_out){
				controlbar.alpha -= fade_speed;
				option_fermer.alpha -= fade_speed;
				if(controlbar.alpha <= 0){
					controlbar.alpha = 0;
					option_fermer.alpha = 0;
					fade_out = false;
					controlbar.visible = false;
					option_fermer.visible = false;
					controlbar.sliderVisible = false;
				}
			}
		}
		
		private function onMouseOverCBar(e:MouseEvent)
		{
			mouseOverCBar = true;
		}
		
		private function onMouseOutCBar(e:MouseEvent)
		{
			mouseOverCBar = false;
		}
		
		
		
		
		private function onClickEmbarquer(e:Event)
		{
			trace("vpui::onClickEmbarquer");
			if(fs_on) st.displayState = StageDisplayState.NORMAL;
			closeAllPages();
			page_embarquer.visible = true;
			
		}
		private function onClickPartager(e:Event)
		{
			trace("vpui::onClickPartager");
			if(fs_on) st.displayState = StageDisplayState.NORMAL;
			closeAllPages();
			page_partager.visible = true;
		}
		private function onClickEnvoyer(e:Event)
		{
			trace("vpui::onClickEnvoyer");
			if(fs_on) st.displayState = StageDisplayState.NORMAL;
			closeAllPages();
			page_envoyer.visible = true;
			
		}
		private function onClickCredit(e:Event)
		{
			trace("vpui::onClickCredit");
			if(fs_on) st.displayState = StageDisplayState.NORMAL;
			closeAllPages();
			page_credit.visible = true;
		}
		
		private function closeAllPages():void
		{
			page_embarquer.visible = false;
			page_partager.visible = false;
			page_envoyer.visible = false;
			page_credit.visible = false;
		}
		
		
		private function onClosePage(e:Event)
		{
			//trace("onClosePage "+e.target);
			e.target.visible = false;
			cache_page.visible = false;
			videoplayer.mouseEnabled = true;
			iconPause.mouseEnabled = true;
			iconPause.mouseChildren = true;
			controlbar.mouseEnabled = true;
			controlbar.mouseChildren = true;
			controlbar.unlock();
			
		}
		
		private function onOpenPage(e:Event)
		{
			//trace("onOpenPage "+e.target);
			//cache_page.visible = true;
			pauseVideo();
			videoplayer.mouseEnabled = false;
			iconPause.mouseEnabled = false;
			iconPause.mouseChildren = false;
			controlbar.lock();
			if(fs_on) st.displayState = StageDisplayState.NORMAL;
		}
		
		
		private function onScreenshot(e:MouseEvent)
		{
			trace("onScreenshot");
			var bmpdata:BitmapData = videoplayer.screenshot;
			
			var tab = new Array();
			for(var y:int=0;y<bmpdata.height;y++){
				for(var x:int=0;x<bmpdata.width;x++){
					tab.push(bmpdata.getPixel(x, y));
				}
			}
			var phpm:PHPManager = new PHPManager();
			phpm.varsIn.width = videoWidth;
			phpm.varsIn.height = videoHeight;
			phpm.varsIn.name = "../dataplayer-imgs/capture.jpg";
			phpm.varsIn.tab = tab = tab.toString();
			phpm.exec(phpDir+"/generate_jpg.php");
			phpm.addEventListener(Event.COMPLETE, onPhpComplete);
			btnScreenshot.gotoAndStop("loading");
		}
		
		private function onPhpComplete(e:Event)
		{
			//trace("onPhpComplete");
			btnScreenshot.gotoAndStop("normal");
		}
		
		
		private function onStartBuffering(e:Event)
		{
			mcBuffer.visible = true;
		}
		private function onStopBuffering(e:Event)
		{
			mcBuffer.visible = false;
		}
		
		private function onAutoRewind(e:Event)
		{
			//trace("onAutoRewind");
			pauseVideo(true);
		}
	}
	
}


