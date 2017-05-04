package ascode 
{
	import data2.asxml.ASCode;
	import data2.asxml.ObjectSearch;
	import data2.navigation.Navigation;
	import data2.text.Text;
	import model.ModelArticle;
	import model.translation.Translation;
	import view.ViewMainScreen;
	import view.ViewMenu;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ASCodeMenu extends ASCode
	{
		
		public function ASCodeMenu() 
		{
			
		}
		override public function exec():void 
		{
			Navigation.addCallback("", "screen_menu", Navigation.CALLBACK_QUIT, onQuitMenu);
		}
		
		private function onQuitMenu():void 
		{
			trace("onQuitMenu");
			Navigation.gotoScreen("submenu", "");
			Navigation.gotoScreen("submenu2", "");
		}
		
		
		
		public function onClickMenu(_idscreen:String):void
		{
			trace("onClickMenu(" + _idscreen + ")");
			
			//submenu
			if (_idscreen == "btn_escapade") {
				if (Navigation.getCurscreen("submenu") == "") {
					Navigation.gotoScreen("submenu", "submenu_on");
					
				}
				return;
			}
			else if (_idscreen == "btn_checkout") {
				if (Navigation.getCurscreen("submenu2") == "") {
					Navigation.gotoScreen("submenu2", "submenu2_on");
					
				}
				return;
			}
			
			//_______
			
			if (_idscreen == "screen_territoire") {
				Navigation.gotoScreen("", "screen_territoire");
			}
			else if (_idscreen == "embassadeurs") {
				Navigation.gotoScreen("", "screen_embassadeur");
			}
			
			else {
				
				Translation.add("text_title", "rubrics." + _idscreen + ".title", "MS900_24_FFFFFF");
				
				Navigation.gotoScreen("", "screen_main");
				
				var _typecat:String;
				var _listtags:Array = ModelArticle.getTagsByMenuItem(_idscreen);
				
				if (_listtags == 0 || _listtags[0] != "incontournable") {
					_typecat = ModelArticle.getTypeCatByMenuItem(_idscreen);
				}
				else {
					_typecat = "";
				}
				
				trace("_typecat :" + _typecat);
				
				var _ascodeScreenMain:ASCodeScreenMain = ASCodeScreenMain(ObjectSearch.getID("ascodescreenmain"));
				_ascodeScreenMain.initContent(_listtags, null, false, _idscreen, _typecat);
				
				
				
			}
			
			
			
			Translation.translate("", ["text_title"]);
			
			ViewMainScreen.layoutTitles();
			
			
			//Navigation.gotoScreen(_idscreen);
			
			
		}
		
		
		public function onClickBack():void 
		{
			
		}
		
		
		
		
	}

}