package
{
	import lol;
	import ascode.ASCodeEmbassadeur;
	import ascode.ASCodeEntermail;
	import ascode.ASCodeHeader;
	import ascode.ASCodeHome;
	import ascode.ASCodeMain;
	import ascode.ASCodeMenu;
	import ascode.ASCodeMenu2;
	import ascode.ASCodeScreenMain;
	import ascode.ASCodeTerritoire;
	import assets.Component_detail_img;
	import assets.Component_item_scroll;
	import assets.Component_zone_meteo;
	import assets.pagination.Component_pagination;
	import color.InterfaceColor;
	import data.events.DynEvent;
	import data.utils.PositioningTool;
	import data2.asxml.Constantes;
	import data2.asxml.OnClickHandler;
	import data2.debug.InterfaceTrace;
	import data2.display.buttons.TouchButton;
	import data2.display.ClickableSprite;
	import flash.display.Loader;
	import flash.display.StageQuality;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import data.javascript.SWFAddress;
	import data.utils.Delay;
	import data2.asxml.ASXMLFileContent;
	import data2.asxml.ConstantesProvider;
	import data2.asxml.DynamicStateDef;
	import data2.behaviours.layout.GridLayout;
	import data2.behaviours.mousepointer.MousePointer;
	import data2.behaviours.videoplayer.VideoPlayer;
	import data2.debug.ASPannel;
	import data2.debug.ASXMLTracer;
	import data2.debug.DebugPannel;
	import data2.layoutengine.LayoutEngine;
	import data2.layoutengine.LayoutSprite;
	import data.abstrait.Document;
	import data.javascript.MacMouseWheel;
	import data2.asxml.ASXML;
	import data2.asxml.ObjectSearch;
	import data2.debug.RealTimeRefresh;
	import data2.asxml.Sessions;
	import data2.behaviours.form.Form;
	import data2.behaviours.layout.HLayout;
	import data2.behaviours.layout.ItemSlider;
	import data2.behaviours.layout.Spacer;
	import data2.behaviours.layout.VLayout;
	import data2.behaviours.menu.Menu;
	import data2.display.Image;
	import data2.display.scrollbar.Scrollbar;
	import data2.display.skins.Skin;
	import data2.effects.BGinEffect;
	import data2.effects.Effect;
	import data2.effects.FadeEffect;
	import data2.effects.MEffect;
	import data2.effects.RotationEffect;
	import data2.effects.SlideEffect;
	import data2.effects.SlideFadeEffect;
	import data2.effects.ToogleEffect;
	import data2.effects.ZoomEffect;
	import data2.InterfaceSprite;
	import data2.net.imageloader.ImageLoader;
	import data2.net.imageloader.ImageLoaderEvent;
	import data2.net.URLLoaderManager;
	import data2.display.skins.Skin;
	import data2.states.StateEngine;
	import data2.states.StateEvent;
	import data2.states.stateparser.StateParser;
	import data2.sound.SoundPlayer;
	import data2.text.Text;
	import data2.text.TextStylesheetConverter;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import timertouch.TimerTouch;
	import view.ViewGlobal;
	import view.ViewHome;
	
	/**
	 * ...
	 * @author
	 */
	public class MainInterface extends MovieClip
	{
		public const INTERFACE_DIMS:Point = new Point(1920, 1080);
		
		public var SERVER_ENVIRONMENT:Boolean;
		public var DEBUG_MODE:Boolean;
		public var LOAD_IMG_INIT:Boolean = true;
		public var DEBUG_POSITION:Boolean;
		
		public function MainInterface()
		{
			
			Sessions.set("lang", "fr");
			
			var _flashvars:Object = this.loaderInfo.parameters;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		
		}
		
		private function init(e:Event = null):void
		{
			trace("MainInterface.init");
			
			DataGlobal.container = this;
			DEBUG_POSITION = DataGlobal.DEBUG_MODE;
			
			trace("this.parent : " + this.parent);
			ObjectSearch.flashvarsObject = this.loaderInfo.parameters;
			
			
			Font.registerFont(Font1);
			Font.registerFont(Font2);
			Font.registerFont(Font3);
			Font.registerFont(Font4);
			Font.registerFont(Font5);
			Font.registerFont(Font6);
			Font.registerFont(Font7);
			Font.registerFont(Font8);
			Font.registerFont(Font9);
			Font.registerFont(Font10);
			Font.registerFont(Font11);
			Font.registerFont(Font12);
			
			
			
			Text.DEFAULT_SELECTABLE = false;
			Text.DEFAULT_DEBUGBORDER = DEBUG_POSITION;
			ClickableSprite.DEBUG = DataGlobal.DEBUG_CLICKABLE;
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			Multitouch.mapTouchToMouse = true;
			
			
			trace("flashvars DEBUG_MODE : " + ObjectSearch.flashvars("DEBUG_MODE"));
			DEBUG_MODE = (ObjectSearch.flashvars("DEBUG_MODE") == "1");
			trace("DEBUG_MODE : " + DEBUG_MODE);
			
			MacMouseWheel.setup(stage);
			LayoutEngine.layoutSize = new Point(INTERFACE_DIMS.x, INTERFACE_DIMS.y);
			
			SERVER_ENVIRONMENT = (this.loaderInfo.url.search("http://") != -1);
			trace("SERVER_ENVIRONMENT : " + SERVER_ENVIRONMENT);
			
			var _nocache:Boolean = (DEBUG_MODE && SERVER_ENVIRONMENT);
			//trace("_nocache : " + _nocache);
			
			//URLLoaderManager.reset();
			URLLoaderManager.addEventListener(Event.COMPLETE, onURLLoaded);
			URLLoaderManager.load("interface-runtime/text.css", "stylesheet_text", _nocache);
			URLLoaderManager.load("interface-runtime/layout.css", "layout", _nocache);
			URLLoaderManager.load("interface-runtime/states.xml", "states", _nocache);
			URLLoaderManager.load("interface-runtime/effects.css", "effects", _nocache);
			URLLoaderManager.load("interface-runtime/main.xml", "asxml", _nocache);
			if (!SERVER_ENVIRONMENT)
				URLLoaderManager.load("interface-runtime/flashvars.xml", "flashvars", _nocache);
			
			if (DEBUG_MODE)
			{
				RealTimeRefresh.add("interface-runtime/text.css");
				RealTimeRefresh.add("interface-runtime/layout.css");
				RealTimeRefresh.add("interface-runtime/states.xml");
				RealTimeRefresh.add("interface-runtime/effects.css");
				RealTimeRefresh.add("interface-runtime/main.xml");
				RealTimeRefresh.init(SERVER_ENVIRONMENT, RealTimeRefresh.MODE_FOCUS, stage);
				
				
				DebugPannel.init(stage);
			}
			
			if (DEBUG_POSITION) {
				if (!DataGlobal.DEBUG_CLICKABLE) OnClickHandler.UPDATE_CLICKABLE = false;
				PositioningTool.init(stage);
			}
			
		
			//not generic
		
		}
		
		private function onURLLoaded(e:Event):void
		{
			URLLoaderManager.resetEventListeners();
			
			trace("MainInterface.onURLLoaded");
			
			//base
			ASXML.registerClass(Sprite);
			ASXML.registerClass(MovieClip);
			ASXML.registerClass(LayoutSprite);
			ASXML.registerClass(InterfaceSprite);
			ASXML.registerClass(TextField);
			//noyau
			ASXML.registerClass(DynamicStateDef);
			ASXML.registerClass(ConstantesProvider);
			ASXML.registerClass(ASXMLTracer);
			
			//display
			ASXML.registerClass(Image);
			ASXML.registerClass(Text);
			ASXML.registerClass(Skin);
			ASXML.registerClass(Scrollbar);
			ASXML.registerClass(TouchButton);
			
			//behaviours
			ASXML.registerClass(HLayout);
			ASXML.registerClass(VLayout);
			ASXML.registerClass(GridLayout);
			ASXML.registerClass(ItemSlider);
			ASXML.registerClass(Spacer);
			ASXML.registerClass(Form);
			ASXML.registerClass(Menu);
			ASXML.registerClass(MousePointer);
			ASXML.registerClass(VideoPlayer);
			//effects
			ASXML.registerClass(Effect);
			ASXML.registerClass(MEffect);
			ASXML.registerClass(FadeEffect);
			ASXML.registerClass(RotationEffect);
			ASXML.registerClass(SlideEffect);
			ASXML.registerClass(SlideFadeEffect);
			ASXML.registerClass(ZoomEffect);
			ASXML.registerClass(ToogleEffect);
			//sound
			ASXML.registerClass(SoundPlayer);
			
			//custom project
			ASXML.registerClass(Component_zone_meteo);
			ASXML.registerClass(Component_item_scroll);
			ASXML.registerClass(Component_pagination);
			ASXML.registerClass(Component_detail_img);
			
			//ascode
			ASXML.registerClass(ASCodeMain);
			ASXML.registerClass(ASCodeHome);
			ASXML.registerClass(ASCodeMenu);
			ASXML.registerClass(ASCodeHeader);
			ASXML.registerClass(ASCodeScreenMain);
			ASXML.registerClass(ASCodeMenu2);
			ASXML.registerClass(ASCodeTerritoire);
			ASXML.registerClass(ASCodeEmbassadeur);
			ASXML.registerClass(ASCodeEntermail);
			
			
			//effects
			
			//flashvars default
			if (!SERVER_ENVIRONMENT)
				ObjectSearch.setDefaultFlashvars(URLLoaderManager.getXml("flashvars"));
			
			//text css conversion
			TextStylesheetConverter.init(URLLoaderManager.getStylesheet("stylesheet_text")); //stylesheet
			
			ASXML.addEventListener(Event.COMPLETE, onASXMLComplete);
			ASXML.init(URLLoaderManager.getData("asxml"), this, stage, DEBUG_MODE);
			
		
		}
		
		private function onASXMLComplete(e:Event):void
		{
			trace("onASXMLComplete");
			
			
			
			
			ASXML.removeEventListener(Event.COMPLETE, onASXMLComplete);
			
			if (LOAD_IMG_INIT)
			{
				ImageLoader.displayReports = false;
				ImageLoader.addEventListener(ImageLoaderEvent.COMPLETE, onImageLoaderComplete);
				ImageLoader.loadGroup(ImageLoader.GROUP_INIT);
					//ImageLoader.addEventListener(ImageLoaderEvent.PROGRESS, onImageLoaderProgress);
			}
			else
			{
				onImageLoaderComplete(null);
			}
		
		}
		
		private function onImageLoaderComplete(e:Event):void
		{
			
			trace("onImageLoaderComplete");
			//ImageLoader.resetEventListeners();
			ImageLoader.removeEventListener(ImageLoaderEvent.COMPLETE, onImageLoaderComplete);
			
			LayoutEngine.init(stage, this, null, URLLoaderManager.getData("layout"));
			ASXML.finalInitItem();
			ASXML.ascodeExec();
			LayoutEngine.start();
			
			StateParser.init(stage, this, URLLoaderManager.getXml("states"), URLLoaderManager.getData("effects"));
			StateParser.debug = DEBUG_MODE;
			
			ASXML.initItemBtnEffect();
			
			StateEngine.registerPropertySet();
			StateEngine.dispatchEvent(new StateEvent(StateEvent.COMPLETE));
			
			//devrait se faire plus tot dans l'idéal car si on fait bugger, pas de rechargement pour ces fichiers
			if (DEBUG_MODE)
			{
				var _importedFiles:Array = ASXML.importedFiles;
				for (var i:int = 0; i < _importedFiles.length; i++)
				{
					var _filename:String = ASXMLFileContent(_importedFiles[i]).name;
					//trace("_filename : " + _filename);
					RealTimeRefresh.add(_filename);
				}
				RealTimeRefresh.initDownload();
			}
			
			var _params:Object = this.loaderInfo.parameters;
			trace("______________\nparams");
			for (var name:String in _params)
			{
				trace("_params[" + name + "] : " + _params[name]);
			}
			
			
			
			//ImageLoader.loadGroup("thumbs");
			/*
			var _interfaceTracer:InterfaceTrace = new InterfaceTrace();
			_interfaceTracer.init(this);
			*/
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onkeydown);
			stage.quality = StageQuality.HIGH_16X16;
			/*
			this.rotation = 59;
			this.x = 600;
			*/
		
		}
		
		private function onkeydown(e:KeyboardEvent):void
		{
		/*
		   trace("onkeydown");
		   if (e.keyCode == Keyboard.SPACE) {
		   resetLang("en");
		   }
		 */
		
		}
		
		
		
		
		
		/*__________________________________________________________________________________________________*/
		//shared function
		
		public function updateData():void
		{
			trace("MainInterface.updateData " + DataGlobal.id);
			ViewGlobal.updateData();
			
		}
		
		public function runDiapo():void
		{
			trace("MainInterface.runDiapo");
			ViewHome.runDiapo();
		}
		
	}

}