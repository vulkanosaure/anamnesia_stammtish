package ascode
{
	import data2.asxml.ASCode;
	import data2.asxml.Constantes;
	import data2.asxml.ObjectSearch;
	import data2.fx.delay.DelayManager;
	import data2.navigation.Navigation;
	import flash.display.DisplayObjectContainer;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import model.translation.Translation;
	import timertouch.TimerTouch;
	import timertouch.TimerTouchEvent;
	import view.ViewHeader;
	import view.ViewHome;
	
	/**
	 * ...
	 * @author Vinc
	 */
	public class ASCodeHome extends ASCode
	{
		private var _homelang:String;
		
		
		
		
		public function ASCodeHome()
		{
		
		}
		
		override public function exec():void
		{
			//ViewHome.initVideo();
			ViewHome.initBackground();
			
			
			TimerTouch.init(Number(Constantes.get("config.delay_iddle")), _stage);
			TimerTouch.addEventListener(TimerTouchEvent.NO_TOUCH, onTimerIddle);
			TimerTouch.addEventListener(TimerTouchEvent.WAKE_UP, onTimerWakeUp);
			
			
			
			DataGlobal.LIST_LANG = String(Constantes.get("config.list_langs")).split(",");
			trace("DataGlobal.LIST_LANG : " + DataGlobal.LIST_LANG);
			
			
			var _delay:Number = Number(Constantes.get("config.delay_anim_home")) * 1000;
			trace("_delay : " + _delay);
			var _timerHomeLang:Timer = new Timer(_delay);
			_homelang = DataGlobal.LIST_LANG[0];
			_timerHomeLang.addEventListener(TimerEvent.TIMER, onTimerHomeLang);
			_timerHomeLang.start();
			
			Navigation.addCallback("", "screen_home", Navigation.CALLBACK_GOTO, onGotoHome);
			Navigation.addCallback("", "screen_home", Navigation.CALLBACK_GOTO_TRANSITION, onGotoHomeTransition);
			
			
			var _nblang:int = DataGlobal.LIST_LANG.length;
			var _tablanginit:Array = ["fr", "en", "de"];
			var _x:Number = 0;
			var _space:Number = 66;
			var _deltapt:Point = new Point(16, 30);
			var _cumulpt:Point = new Point();
			var _widthbtn:Number = 50;
			var _xbase:Number = (_tablanginit.length * _space + _widthbtn) * 0.5 - (_nblang * _space + _widthbtn) * 0.5;
			for (var name:String in _tablanginit) 
			{
				var _lang:String = _tablanginit[name];
				var _exist:Boolean = (DataGlobal.LIST_LANG.indexOf(_lang) != -1);
				ViewHome.setItemVisible("btn_home_" + _lang, _exist);
				ViewHome.setItemVisible("btn_lang_" + _lang, _exist);
				
				if (_exist) {
					ViewHome.setItemPosition("btn_home_" + _lang, _x + _xbase, 0);
					_x += _space;
					
					ViewHome.setItemPosition("btn_lang_" + _lang, _cumulpt.x, _cumulpt.y);
					_cumulpt.x += _deltapt.x;
					_cumulpt.y += _deltapt.y;
				}
				//decalage, 16, 30
				//space 66
			}
			
			if (_nblang == 1) {
				
				ViewHome.setZoneClickable("btn_home_" + DataGlobal.LIST_LANG[0], 600);
				ViewHome.setItemVisible("btn_lang_" + DataGlobal.LIST_LANG[0], false);
				
			}
			
			
			
			
		}
		
		
		
		private function onGotoHome():void 
		{
			trace("onGotoHome");
			ViewHome.selectLang("");
			
			ViewHome.playDiapo(true);
			
		}
		
		private function onGotoHomeTransition():void 
		{
			trace("onGotoHomeTransition");
			
			var _mainContainer:DisplayObjectContainer = DataGlobal.container.parent.parent;
			if (_mainContainer != null && DataGlobal.id != null) {
				trace("try to call backtohome");
				_mainContainer["onBackToHome"](DataGlobal.id);
			}
			
		}
		
		
		
		
		public function onClickLang(_lang:String):void
		{
			ViewHome.selectLang(_lang);
			
			DelayManager.add("", 600, function():void {
				Translation.translate(_lang);
			
				ViewHeader.selectLang(_lang);
				Navigation.gotoScreen("", "screen_menu2");
			});
			
			ViewHome.playDiapo(false);
			
		}
		
		public function onClickLogoFooter():void
		{
			trace("ASCodeHome.onClickLogoFooter");
			//Navigation.gotoScreen("", "screen_home");
		}
		
		
		public function onClickLangHeader(_lang:String):void 
		{
			trace("ASCodeHome.onClickLangHeader " + _lang);
			Translation.translate(_lang);
			ViewHeader.selectLang(_lang);
			
		}
		
		public function onClickCredits():void
		{
			Navigation.gotoScreen("", "screen_credits");
		}
		
		public function onCloseCredits():void
		{
			Navigation.gotoPrevScreen();
		}
		
		public function onClickFAQ():void
		{
			trace("ASCodeHome.onClickFAQ");
			//todo
		}
		
		
		
		private function onTimerHomeLang(e:TimerEvent):void 
		{
			//trace("onTimerHomeLang " + Navigation.curscreen);
			if (Navigation.getCurscreen("") != "screen_home") return;
			
			var _indexof:int = DataGlobal.LIST_LANG.indexOf(_homelang);
			_indexof++;
			if (_indexof >= DataGlobal.LIST_LANG.length) _indexof = 0;
			_homelang = DataGlobal.LIST_LANG[_indexof];
			
			Translation.translate(_homelang, ["text_title_home", "text_subtitle_home", "text_header_day"]);
			
		}
		
		
		
		
		
		private function onTimerWakeUp(e:TimerTouchEvent):void 
		{
			trace("ASCodeHome.onTimerWakeUp");
			
		}
		
		private function onTimerIddle(e:TimerTouchEvent):void 
		{
			trace("ASCodeHome.onTimerIddle");
			
			if (Navigation.getCurscreen("") != "screen_home") {
				
				Navigation.gotoScreen("", "screen_home");
				ASCodeHeader(ObjectSearch.getID("ascodeheader")).resetLike();
				
				
			}
			
		}
		
		
	}

}