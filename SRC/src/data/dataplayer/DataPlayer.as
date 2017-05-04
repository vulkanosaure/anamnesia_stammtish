package data.dataplayer {
	
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.xml.XMLNode;
	import flash.text.Font;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.display.*;
	import flash.display.StageDisplayState;
	import flash.system.ApplicationDomain;
	import data.javascript.MacMouseWheel;
	
	
	import data.dataplayer.ControlBar;
	import data.xtends.MovieClipReverse;
	
	
	
	public class DataPlayer extends Sprite{
		
		//params
		public var url_player:String;
		public var dirxml:String;
		public var is_embarked:Boolean;
		public var bAdmin:Boolean;
		
		
		//private vars
		var xml:XMLList;
		var loaderOptions:URLLoader;
		var loaderGraphism:URLLoader;
		var loaderPaths:URLLoader;
		var urlvideo:String;
		var pagetitle:String;
		var capture_url:String;
		var url_player_complete:String;
		
		//MovieClip_addons ?
		var vpui:VideoPlayerUI;
		var l:Loader;
		var st:Stage;
		var skinURL:String;
		
		var _videowidth:Number;
		var _videoheight:Number
		
		
		
		
		//_______________________________________________________________
		//public functions
		
		public function DataPlayer(_stage:Stage, _urlplayer:String) 
		{ 
			st = _stage;
			url_player = _urlplayer;
			Font.registerFont(Font_form1);
			Font.registerFont(Font_form2);
			calque1();
			calque2();
		}
		
		public function getControlbar():ControlBar
		{
			return vpui.getControlbar();
		}
		
		public function reset():void
		{
			//todo
			l.unload();
			vpui.reset();
		}
		
		
		//_______________________________________________________________
		//private functions
		
		private function calque1()
		{
			loaderOptions = new URLLoader();
			loaderOptions.dataFormat = URLLoaderDataFormat.TEXT;
			loaderOptions.addEventListener(Event.COMPLETE, onOptionsLoaded);
			
			loaderGraphism = new URLLoader();
			loaderGraphism.dataFormat = URLLoaderDataFormat.TEXT;
			loaderGraphism.addEventListener(Event.COMPLETE, onGraphismLoaded);
			
			loaderPaths = new URLLoader();
			loaderPaths.dataFormat = URLLoaderDataFormat.TEXT;
			loaderPaths.addEventListener(Event.COMPLETE, onPathsLoaded);
			
			
			//flashvars
			var p:Object = st.loaderInfo.parameters;
			dirxml = "dataplayer-xml/";
			is_embarked = (p.embarquer!=1) ? false : true;
			bAdmin = (p.admin!=1) ? false : true;
			
			if(!is_embarked) MacMouseWheel.setup(st);
			
			/*
			if(p.skinURL=="" || p.skinURL==undefined) skinURL = "dataplayer-skin/skin_black.swf";
			else skinURL = p.skinURL;
			*/
		}
		
		
		
		private function calque2()
		{
			
			l = new Loader();
			//trace("url_player : "+url_player);
			l.load(new URLRequest(url_player+"dataplayer-skin.swf"));
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, onSkinLoaded);
			l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		
		
		
		
		
		//____________________________________________________________________________________
		//interface
		
		public function pause()
		{
			vpui.pause();
		}
		
		public function play():void
		{
			vpui.play();
		}
		
		public function playPause():void
		{
			vpui.playPause();
		}
		
		public function rewind():void
		{
			vpui.rewind();
		}
		
		public function clear()
		{
			vpui.clear();
		}
		
		public function init(url:String, _width:Number, _height:Number)
		{
			var bAutoSize:Boolean = true;
			if(url!=""){
				bAutoSize = false;
				urlvideo = url;
			}
			
			//trace("Dataplayer :: init("+url
			vpui.init(urlvideo, _width, _height, bAutoSize);
			vpui.update();
		}
		
		public function resize(w:Number, h:Number):void
		{
			vpui.resize(w, h);
			//vpui.update();
		}
		
		public function addEventListeners()
		{
			//trace("vpui : "+vpui);
			vpui.addEventListeners();
		}
		
		public function removeEventListeners()
		{
			vpui.removeEventListeners();
		}
		
		public function setFullscreen()
		{
			vpui.setFullscreen();
		}
		public function unsetFullscreen()
		{
			vpui.unsetFullscreen();
		}
		public function setSharingURL(_url:String)
		{
			vpui.setSharingURL(url_player+"#"+_url);
		}
		
		//
		public function setURLplayerComplete(str:String):void
		{
			url_player_complete = url_player +"#"+ str;
		}
		public function setPageTitle(str:String):void
		{
			pagetitle = str;
		}
		public function setCaptureURL(str:String):void
		{
			capture_url = str;
		}
		public function setFacebookURL(str:String):void
		{
			vpui.setFacebookURL(str);
		}
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
		
		private function onOptionsLoaded(e:Event):void
		{
			//trace("onOptionsLoaded");
			xml = new XMLList(e.target.data);
			var o1, o2, o3, o4, o5, o6, o7:Boolean;
			o1 = (xml.modules.embarquer==1)?true:false;
			o2 = (xml.modules.partager==1)?true:false;
			o3 = (xml.modules.envoyer==1)?true:false;
			o4 = (xml.modules.credit==1)?true:false;
			o5 = (xml.modules.volume==1)?true:false;
			o6 = (xml.modules.fullscreen==1)?true:false;
			o7 = (xml.modules.fermer==1)?true:false;
			
			var bShowInterface:Boolean = (xml.showInterface==1)?true:false;
			var bsmoothing:Boolean = (xml.smoothing==1)?true:false;
			var iddletime:Number = xml.controlbar.delai_disparition;
			var faddingtime:Number = xml.controlbar.duree_disparition;
			var autoplay:Boolean = (xml.autoplay==1)?true:false;
			var iconPauseAtStart:Boolean = (xml.iconPauseAtStart==1)?true:false;
			var autorewind:Boolean = (xml.autorewind==1) ? true : false;
			var loop:Boolean = (xml.loop==1)?true:false;
			if(is_embarked) o7 = false;
			
			vpui.setOptionsAvailability(o1, o2, o3, o4, o5, o6, o7);
			vpui.setOptions(autoplay, loop, bsmoothing, iconPauseAtStart, autorewind, xml.volumeDefaut, iddletime, faddingtime);
			
			//trace("xml.showInterface : "+bShowInterface);
			if(!bShowInterface) vpui.setInterfaceUnvisible();
			
			loaderGraphism.load(new URLRequest(url_player + dirxml + "graphism.xml"));
			loaderGraphism.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		
		
		private function onGraphismLoaded(e:Event):void
		{
			//trace("onGraphismLoaded");
			xml = new XMLList(e.target.data);
			var n:XMLList;
			n = xml.timer;
			
			
			vpui.setTimerFormat(n.taille, n.typo, n.couleur);
			vpui.setTimerPadding(n.padding_top, n.padding_left, n.padding_right);
			
			n = xml.cadre;
			if(is_embarked){
				n.epaisseur = 0;
				xml.video.padding = 0;
			}
			
			vpui.setFrame(n.couleur, n.epaisseur);
			n = xml.controlbar;
			vpui.setCBarProperty(n.padding_bottom, n.padding_side, n.padding_left, n.space_options, n.space_rewindplay);
			n = xml.btn_fermer;
			vpui.setPadding(xml.video.padding, n.padding_top, n.padding_right);
			n = xml.controlbar;
			vpui.setDimsBtns(n.width_options, n.height_options, xml.btn_fermer.width, xml.btn_fermer.height);
			
			loaderPaths.load(new URLRequest(url_player+dirxml+"config.xml"));
		}
		
		
		
		private function onPathsLoaded(e:Event):void
		{
			//trace("___onPathsLoaded");
			xml = new XMLList(e.target.data);
			var _pagetitle = (pagetitle==null || pagetitle=="") ? xml.page_title : pagetitle;
			var _urlplayer = (url_player==null || url_player=="") ? xml.url_player : url_player;
			var _urlplayercomplete = (url_player_complete==null || url_player_complete=="") ? _urlplayer : url_player_complete;
			
			_videowidth = xml.videoWidth;
			_videoheight = xml.videoHeight;
			//trace("DataPlayer::dims : "+_videowidth+", "+_videoheight);
			
			vpui.setPaths("dataplayer-php/", xml.capture, xml.gabarits, xml.url_credits, _urlplayer, _videowidth, _videoheight, _pagetitle, capture_url, _urlplayercomplete);
			urlvideo = xml.video;
			//trace("urlvideo : "+urlvideo);
			dispatchEvent(new Event("READY"));
			
		}
		
		
		
		function onSkinLoaded(e:Event)
		{
			//trace("onSkinLoaded");
			
			//récupération des classes de skin.swf
			var dmApp:ApplicationDomain = e.target.applicationDomain;
			
			var classEmbarquer:Class = dmApp.getDefinition("Option_embarquer") as Class;
			var mcEmbarquer:MovieClip = new classEmbarquer();
			var classPartager:Class = dmApp.getDefinition("Option_partager") as Class;
			var mcPartager:MovieClip = new classPartager();
			var classFermer:Class = dmApp.getDefinition("Option_fermer") as Class;
			var mcFermer:MovieClip = new classFermer();
			var classEnvoyer:Class = dmApp.getDefinition("Option_envoyer") as Class;
			var mcEnvoyer:MovieClip = new classEnvoyer();
			var classCredit:Class = dmApp.getDefinition("Option_credit") as Class;
			var mcCredit:MovieClip = new classCredit();
			var classFsOn:Class = dmApp.getDefinition("Option_fullscreen_on") as Class;
			var mcFsOn:MovieClip = new classFsOn();
			var classFsOff:Class = dmApp.getDefinition("Option_fullscreen_off") as Class;
			var mcFsOff:MovieClip = new classFsOff();
			var classVolume:Class = dmApp.getDefinition("Option_son") as Class;
			var mcVolume:MovieClip = new classVolume();
			var classSlideVolume:Class = dmApp.getDefinition("BarreNavigSon") as Class;
			var mcSlideVolume:MovieClip = new classSlideVolume();
			var classSlideVolume_track:Class = dmApp.getDefinition("BarreNavigSon_track") as Class;
			var mcSlideVolume_track:MovieClip = new classSlideVolume_track();
			var classSlideVolume_handle:Class = dmApp.getDefinition("BarreNavigSon_handle") as Class;
			var mcSlideVolume_handle:MovieClip = new classSlideVolume_handle();
			var classSlideVolume_mask:Class = dmApp.getDefinition("mask_volumeslider") as Class;
			var mcSlideVolume_mask:MovieClip = new classSlideVolume_mask();
			var classBtnScreenshot:Class = dmApp.getDefinition("Btn_screenshot") as Class;
			var mcBtnScreenshot:MovieClip = new classBtnScreenshot();
			var classmcBuffer:Class = dmApp.getDefinition("McBuffer") as Class;
			var mcBuffer:MovieClip = new classmcBuffer();
			
			var classIconpause:Class = dmApp.getDefinition("PictoPause") as Class;
			var mcIconpause:MovieClip = new classIconpause();
			//cbar
			var classBtnplay:Class = dmApp.getDefinition("Btn_play") as Class;
			var mcBtnplay:MovieClip = new classBtnplay();
			var classBtnpause:Class = dmApp.getDefinition("Btn_pause") as Class;
			var mcBtnpause:MovieClip = new classBtnpause();
			var classBtnrewind:Class = dmApp.getDefinition("Btn_rewind") as Class;
			var mcBtnrewind:MovieClip = new classBtnrewind();
			var classCbfond:Class = dmApp.getDefinition("ControlBar_fond") as Class;
			var mcCbfond:MovieClip = new classCbfond();
			var classTlfond:Class = dmApp.getDefinition("timeline_fond") as Class;
			var mcTlfond:MovieClip = new classTlfond();
			var classTldownload:Class = dmApp.getDefinition("timeline_download") as Class;
			var mcTldownload:MovieClip = new classTldownload();
			var classTlprogress:Class = dmApp.getDefinition("timeline_progress") as Class;
			var mcTlprogress:MovieClip = new classTlprogress();
			
			
			//______________________________________________
			
			
			vpui = new VideoPlayerUI(st, bAdmin);
			//vpui.addEventListener("VIDEO_CHANGE_SIZE", onVideoChangeSize);
			vpui.addEventListener("FULLSCREEN_ON", dispatchEvent);
			vpui.addEventListener("FULLSCREEN_OFF", dispatchEvent);
			vpui.addEventListener("FOCUS_INPUT", dispatchEvent);
			
			vpui.setMC(mcEmbarquer, mcPartager, mcFermer, mcEnvoyer, mcCredit, mcFsOn, mcFsOff, 
					   mcVolume, mcSlideVolume, mcSlideVolume_track, mcSlideVolume_handle, mcSlideVolume_mask, 
					   mcIconpause, mcBtnplay, mcBtnpause, mcBtnrewind,
					   mcCbfond, mcTlfond, mcTldownload, mcTlprogress, mcBtnScreenshot, mcBuffer);
			
			vpui.clear();
			
			//load xml
			loaderOptions.load(new URLRequest(url_player+dirxml+"options.xml"));
			loaderOptions.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			//positionnement ds la scène
			this.addChild(vpui);
		}
		
		
		private function onIOError(e:IOErrorEvent):void 
		{
			trace("DataPlayer.onIOError " + e);
		}
		
	}
	
}