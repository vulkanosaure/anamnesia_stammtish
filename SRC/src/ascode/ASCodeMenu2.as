package ascode 
{
	import data2.asxml.ASCode;
	import data2.asxml.ObjectSearch;
	import data2.fx.delay.DelayManager;
	import data2.navigation.Navigation;
	import model.ModelHeader;
	import model.ModelQuestions;
	import model.translation.Translation;
	import view.ViewMainScreen;
	import view.ViewMenu2;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ASCodeMenu2 extends ASCode
	{
		private var _listquestion:Array;
		
		public function ASCodeMenu2() 
		{
			
		}
		
		override public function exec():void 
		{
			super.exec();
			
			Navigation.addCallback("", "screen_menu2", Navigation.CALLBACK_GOTO, onGotoScreen);
			Navigation.addCallback("", "screen_menu2", Navigation.CALLBACK_QUIT, onQuitScreen);
			
			ViewMenu2.init();
		}
		
		private function onQuitScreen():void 
		{
			trace("ASCodeMenu2.onQuitScreen");
			ViewMenu2.playDiapo(false);
		}
		
		private function onGotoScreen():void 
		{
			trace("ASCodeMenu2.onGotoScreen");
			
			var _temp:int = ModelHeader.getTemperature();
			var _time:Number = ModelHeader.getTsDay();
			
			_listquestion = ModelQuestions.getQuestions(_temp, _time);
			ViewMenu2.updateContent(_listquestion);
			trace("_listquestion : " + _listquestion);
			
			ViewMenu2.hideAll();
			DelayManager.add("", 1000, function():void
			{
				ViewMenu2.playDiapo(true);
			});
		}
		
		
		
		public function onClickBtnSmall(_index:int):void
		{
			trace("ASCodeMenu2.onClickBtnSmall(" + _index + ")");
			
			initContent(_index);
			Navigation.gotoScreen("", "screen_main");
		}
		
		public function onClickBtnBig():void
		{
			trace("ASCodeMenu2.onClickBtnBig");
			
			initContent(-1);
			Navigation.gotoScreen("", "screen_main");
		}
		
		private function initContent(_index:int):void 
		{
			
			//il faut indexdxml + tags
			var _realindex:int = ViewMenu2.getRealIndex(_index);
			trace("_realindex : " + _realindex);
			
			var _obj:Object = _listquestion[_realindex];
			trace("_obj : " + _obj);
			
			var _listtags:Array = String(_obj["tags"]).split(",");
			
			var _indexxml:int = _obj["indexxml"];
			trace("_listtags : " + _listtags + ", _indexxml : " + _indexxml);
			trace("type : " + _obj.cattype);
			
			Translation.addDynamic("text_title", "questions.item", "text", "text_title", "MS900_24_FFFFFF");
			Translation.setDynamicIndex("text_title", _indexxml);
			Translation.translate("", ["text_title"]);
			
			
			var _ascodeScreenMain:ASCodeScreenMain = ASCodeScreenMain(ObjectSearch.getID("ascodescreenmain"));
			_ascodeScreenMain.initContent(_listtags, null, false, "", _obj.cattype, _obj.img_bg);
		}
		
	}

}