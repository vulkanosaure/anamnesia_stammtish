package ascode 
{
	import data2.asxml.ASCode;
	import data2.asxml.ObjectSearch;
	import data2.fx.swipe.SwipeEvent;
	import data2.fx.swipe.SwipeHandler;
	import data2.navigation.Navigation;
	import flash.display.Sprite;
	import view.ViewTerritoire;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ASCodeTerritoire extends ASCode
	{
		private const SCREEN_ID:String = "territoire";
		
		public function ASCodeTerritoire() 
		{
			
		}
		
		
		override public function exec():void 
		{
			super.exec();
			
			ViewTerritoire.initBackground();
			ViewTerritoire.init(_stage, SCREEN_ID, DataGlobal.NB_PAGE_TERRITOIRE);
			
			Navigation.addCallback("", "screen_territoire", Navigation.CALLBACK_GOTO, onGotoScreen);
			Navigation.addCallback("", "screen_territoire", Navigation.CALLBACK_QUIT, onQuitScreen);
			
			
		}
		
		
		
		private function onGotoScreen():void 
		{
			trace("ASCodeTerritoire.onGotoScreen");
			ViewTerritoire.playDiapo(true);
			ViewTerritoire.resetDiapo(SCREEN_ID);
		}
		
		
		private function onQuitScreen():void 
		{
			trace("ASCodeTerritoire.onQuitScreen");
			ViewTerritoire.playDiapo(false);
			
		}
		
		
		
		
		public function onClickPrev():void
		{
			trace("ASCodeTerritoire.onClickPrev");
			ViewTerritoire.gotoPrev(SCREEN_ID);
			
		}
		
		
		public function onClickNext():void
		{
			trace("ASCodeTerritoire.onClickNext");
			ViewTerritoire.gotoNext(SCREEN_ID);
			
		}
		
	}

}