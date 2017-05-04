package ascode 
{
	import data2.asxml.ASCode;
	import data2.asxml.ObjectSearch;
	import data2.fx.delay.DelayManager;
	import data2.navigation.Navigation;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import model.ModelHeader;
	import model.ModelLike;
	import model.translation.Translation;
	import view.ViewGlobal;
	import view.ViewHeader;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ASCodeHeader extends ASCode
	{
		private var _indexIcon:int;
		
		public function ASCodeHeader() 
		{
			
		}
		
		
		override public function exec():void 
		{
			super.exec();
			trace("ASCodeHeader.exec");
			
			ViewHeader.initIconWeather();
			
			_indexIcon = 0;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onkeydown);
			
			
			//timer hour
			var _delayHour:Number = (DataGlobal.DEBUG_MODE) ? 4000 : 60 * 1000;
			var _timerHour:Timer = new Timer(_delayHour);
			_timerHour.addEventListener(TimerEvent.TIMER, onTimerHour);
			_timerHour.start();
			onTimerHour(null);
			
			//timer weather
			var _delayWeather:Number = 2 * 60 * 1000;
			var _timerWeather:Timer = new Timer(_delayWeather);
			_timerWeather.addEventListener(TimerEvent.TIMER, onTimerWeather);
			_timerWeather.start();
			onTimerWeather(null);
			
			ViewHeader.setIconWeather(DataGlobal.LIST_ICON_WEATHER[0]);
			
			
			var _timerBump:Timer = new Timer(5000);
			_timerBump.addEventListener(TimerEvent.TIMER, onTimerBump);
			_timerBump.start();
			
			resetLike();
		}
		
		private function onTimerBump(e:TimerEvent):void 
		{
			ViewHeader.bumpBtnLike();
		}
		
		
		private function onTimerHour(e:TimerEvent):void 
		{
			//trace("onTimerHour");
			var _currentTime:String = ModelHeader.getCurrentTime();
			ViewHeader.updateTime(_currentTime);
		}
		
		private function onTimerWeather(e:TimerEvent):void 
		{
			trace("onTimerWeather");
			ModelHeader.getWeatherInfo(onWeatherInfoComplete);
		}
		
		private function onWeatherInfoComplete(_data:Object):void 
		{
			trace("onWeatherInfoComplete " + _data.temp + ", " + _data.icon);
			ViewHeader.updateWeatherInfo(_data);
			
		}
		
		private function onkeydown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.SPACE) {
				
				ViewHeader.setIconWeather(DataGlobal.LIST_ICON_WEATHER[_indexIcon]);
				_indexIcon++;
				if (_indexIcon >= DataGlobal.LIST_ICON_WEATHER.length) _indexIcon = 0;
			}
		}
		
		
		public function onClickBtnLike():void
		{
			trace("onClickBtnLike");
			
			var _idscreen:String = "favourite";
			var _listindexes:Array = ModelLike.getList();
			
			Translation.add("text_title", "rubrics." + _idscreen + ".title", "MS900_24_FFFFFF");
			Translation.translate("", ["text_title"]);
			
			var _ascodeScreenMain:ASCodeScreenMain = ASCodeScreenMain(ObjectSearch.getID("ascodescreenmain"));
			
			
			if (Navigation.getCurscreen("") == "screen_main") {
				Navigation.gotoScreen("", "empty_screen");
				DelayManager.add("", 400, function():void
				{
					_ascodeScreenMain.initContent(null, _listindexes, true);
					Navigation.gotoScreen("", "screen_main");
				});
			}
			else {
				_ascodeScreenMain.initContent(null, _listindexes, true);
				Navigation.gotoScreen("", "screen_main");
			}
			
			
			
			ViewGlobal.setVisible("text_subtitle", false);
			
		}
		
		
		public function onClickCloseFooter():void
		{
			Navigation.gotoScreen("", "screen_menu");
		}
		
		
		
		public function resetLike():void
		{
			ModelLike.reset();
			ViewHeader.setBtnLikeNumber(ModelLike.getLength());
			ViewHeader.setBtnLikeVisible(false);
			
		}
		
		public function addItemLike(_index:int):void
		{
			ModelLike.add(_index);
			ViewHeader.setBtnLikeNumber(ModelLike.getLength());
			ViewHeader.setBtnLikeVisible(true);
			ViewHeader.bumpBtnLike();
		}
		
		
		
	}

}