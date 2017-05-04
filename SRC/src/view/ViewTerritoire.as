package view 
{
	import assets.diapo.Component_diapo_big;
	import assets.PageSlide;
	import assets.pagination.Component_pagination;
	import data.display.FilledRectangle;
	import data.fx.transitions.SpriteTransitioner;
	import data2.asxml.Constantes;
	import data2.asxml.ObjectSearch;
	import data2.fx.swipe.SwipeEvent;
	import data2.fx.swipe.SwipeHandler;
	import data2.InterfaceSprite;
	import data2.mvc.ViewBase;
	import data2.text.Text;
	import fl.transitions.easing.Regular;
	import flash.display.Sprite;
	import flash.display.Stage;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ViewTerritoire extends ViewBase
	{
		private static const INDEX_TERRITOIRE:int = 0;
		private static const INDEX_EMBASSADEURS:int = 1;
		
		static private var _diapo:Component_diapo_big;
		static private var _listPageSlide:Object;
		
		
		public function ViewTerritoire() 
		{
			
		}
		
		
		
		public static function init(_stage:Stage, _idscreen:String, _nbpage:int):void
		{
			if (_listPageSlide == null) _listPageSlide = new Object();
			
			
			var _pageSlide:PageSlide = new PageSlide();
			_pageSlide.init(_idscreen, _stage, _nbpage);
			_listPageSlide[_idscreen] = _pageSlide
			
			
		}
		
		
		
		static private function initContent():void
		{
			
		}
		
		
		
		
		
		
		
		
		static public function initBackground():void
		{
			_diapo = new Component_diapo_big();
			_diapo.iddiapo = "";
			_diapo.listurl = ["images/bg/bg0.jpg", "images/bg/bg1.jpg", "images/bg/bg2.jpg"];
			
			var _delayTimer:Number = Number(Constantes.get("config.time_diapo_territoire"));
			_diapo.initComponent(true, _delayTimer);
			
			var _container:Sprite = getSprite("bg_territoire_diapo");
			_container.addChild(_diapo);
		}
		
		
		static public function playDiapo(_value:Boolean):void
		{
			(_value) ? _diapo.play() : _diapo.pause();
		}
		
		
		
		static public function gotoPrev(screenId:String):void 
		{
			PageSlide(_listPageSlide[screenId]).gotoPrev();
		}
		
		static public function gotoNext(screenId:String):void 
		{
			PageSlide(_listPageSlide[screenId]).gotoNext();
		}
		
		static public function resetDiapo(screenId:String):void 
		{
			PageSlide(_listPageSlide[screenId]).resetDiapo();
		}
		
		
		
		
		
	}

}