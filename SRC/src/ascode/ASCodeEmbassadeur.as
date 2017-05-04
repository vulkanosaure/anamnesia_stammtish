package ascode 
{
	import data2.asxml.ASCode;
	import data2.navigation.Navigation;
	import view.ViewTerritoire;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ASCodeEmbassadeur extends ASCode
	{
		private const SCREEN_ID:String = "embassadeur";
		
		public function ASCodeEmbassadeur() 
		{
			
		}
		
		override public function exec():void 
		{
			super.exec();
			
			ViewTerritoire.init(_stage, SCREEN_ID, DataGlobal.NB_PAGE_EMBASSADEUR);
			
			Navigation.addCallback("", "screen_" + SCREEN_ID, Navigation.CALLBACK_GOTO, onGotoScreen);
			Navigation.addCallback("", "screen_" + SCREEN_ID, Navigation.CALLBACK_QUIT, onQuitScreen);
			
			
		}
		
		
		
		private function onGotoScreen():void 
		{
			trace("ASCodeTerritoire.onGotoScreen");
			ViewTerritoire.resetDiapo(SCREEN_ID);
		}
		
		
		private function onQuitScreen():void 
		{
			trace("ASCodeTerritoire.onQuitScreen");
			
		}
		
		
		
		
		public function onClickPrev():void
		{
			trace("ASCodeEmbassadeur.onClickPrev");
			ViewTerritoire.gotoPrev(SCREEN_ID);
			
		}
		
		
		public function onClickNext():void
		{
			trace("ASCodeEmbassadeur.onClickNext");
			ViewTerritoire.gotoNext(SCREEN_ID);
			
		}
		
	}

}