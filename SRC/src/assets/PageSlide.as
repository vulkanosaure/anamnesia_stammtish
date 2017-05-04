package assets 
{
	import assets.diapo.Component_diapo_big;
	import assets.pagination.Component_pagination;
	import data.display.FilledRectangle;
	import data.fx.transitions.SpriteTransitioner;
	import data2.asxml.ObjectSearch;
	import data2.display.scrollbar.Scrollbar;
	import data2.fx.swipe.SwipeEvent;
	import data2.fx.swipe.SwipeHandler;
	import data2.InterfaceSprite;
	import data2.text.Text;
	import fl.transitions.easing.Regular;
	import flash.display.Sprite;
	import flash.display.Stage;
	/**
	 * ...
	 * @author Vinc
	 */
	public class PageSlide 
	{
		private var _btnleft:InterfaceSprite;
		private var _btnright:InterfaceSprite;
		private var _pagination:Component_pagination;
		private var _diapo:Component_diapo_big;
		private var _slider:SpriteTransitioner;
		private var _indexPage:int;
		private var _nbpage:int;
		private var _swipe:SwipeHandler;
		private var _idscreen:String;
		
		
		public function PageSlide() 
		{
			
		}
		
		public function init(__idscreen:String, _stage:Stage, __nbpage:int):void 
		{
			_idscreen = __idscreen;
			_nbpage = __nbpage;
			
			_pagination = Component_pagination(getID("component_pagination_" + _idscreen));
			_pagination.initComponent();
			_pagination.nbitem = _nbpage;
			_pagination.updateComponent();
			
			//center
			var _paginationWidth:Number = _pagination.getWidth();
			_pagination.x = -Math.round(_paginationWidth * 0.5);
			
			_btnleft = getISprite("btn_" + _idscreen + "_prev");
			_btnright = getISprite("btn_" + _idscreen + "_next");
			
			var _maginbtn:Number = 36;
			_btnleft.x = Math.round(- _paginationWidth * 0.5 - _maginbtn - 215);
			_btnright.x = Math.round( + _paginationWidth * 0.5 + _maginbtn);
			
			
			
			_slider = new SpriteTransitioner();
			_slider.effect_in = Regular.easeOut;
			_slider.effect_in = Regular.easeOut;
			_slider.addTween("in", "x", -1300, 0, 0.55);
			_slider.addTween("out", "x", 0, +1300, 0.55);
			_slider.outNaN = true;
			
			var _container:Sprite = Sprite(ObjectSearch.getID("slider_text_" + _idscreen));
			_container.addChild(_slider);
			
			var _tabsp:Array = new Array();
			
			for (var i:int = 0; i < _nbpage; i++) 
			{
				var _sp:Sprite = addPage(i, _idscreen);
				_tabsp.push(_sp);
			}
			
			
			_swipe = new SwipeHandler();
			_swipe.addEventListener(SwipeEvent.SWIPE, onSwipe);
			_swipe.init(_stage, _tabsp, 1300);
			//_swipe.swipeback = true;
			
			
			_indexPage = 0;
			_slider.init(_indexPage);
			gotoPage(_indexPage);
			
		}
		
		
		public function gotoPrev():void 
		{
			_slider.inverseCoords = false;
			_indexPage--;
			gotoPage(_indexPage);
		}
		
		
		public function gotoNext():void 
		{
			_slider.inverseCoords = true;
			_indexPage++;
			gotoPage(_indexPage);
		}
		
		public function resetDiapo():void 
		{
			_indexPage = 0;
			gotoPage(_indexPage);
		}
		
		
		
		
		private function gotoPage(_index:int):void 
		{
			checkLimit();
			_slider.goto_(_index);
			_pagination.select(_index);
			
		}
		
		
		private function checkLimit():void 
		{
			var _lockleft:Boolean = (_indexPage <= 0);
			var _lockright:Boolean = (_indexPage >= _nbpage - 1);
			
			setBtnEnabled(_btnleft, !_lockleft);
			setBtnEnabled(_btnright, !_lockright);
			
		}
		
		private function setBtnEnabled(_btn:InterfaceSprite, _value:Boolean):void 
		{
			_btn.touchable = _value;
			_btn.alpha = (_value) ? 1.0 : 0.45;
			
			
		}
		
		
		private function onSwipe(e:SwipeEvent):void 
		{
			trace("PageSlide.onSwipe " + e.delta);
			
			var _transitionOK:Boolean = ((e.delta > 0 && _btnright.touchable) || (e.delta < 0 && _btnleft.touchable));
			
			if (_transitionOK) {
				if (e.delta > 0) gotoNext();
				else gotoPrev();
			}
			else {
				_swipe.cancelSwipe();
			}
			
		}
		
		private function addPage(_index:int, _idscreen:String):Sprite 
		{
			var _text:Text;
			
			var _container:Sprite = new Sprite();
			
			var _marginbg:Number = 200;
			var _bg:FilledRectangle = new FilledRectangle(0xff0000);
			_bg.alpha = 0.0;
			_bg.width = 702 + 2 * _marginbg;
			_bg.height = 490 + 2 * _marginbg;
			_bg.x = -_marginbg; _bg.y = -_marginbg;
			_container.addChild(_bg);
			
			_text = new Text();
			_container.addChild(_text);
			_text.width = 339;
			_text.embedFonts = true;
			_text.multiline = true;
			_text.x = 0;
			_text.name = "text0";
			
			var _idscreentext:String = _idscreen;
			if (_idscreentext == "embassadeur") _idscreentext = "embassadeurs";
			
			ObjectSearch.registerID(_text, "text_" + _idscreentext + "_" + _index + "_0", false);
			//trace("registerID(" + "text_" + _idscreentext + "_" + _index + "_0");
			/*
			_text.value = "<span class='MS300_15_FFFFFF'><span style='text-align:justify'></span></span>";
			_text.updateText();
			*/
			
			_text = new Text();
			_container.addChild(_text);
			_text.width = 339;
			_text.embedFonts = true;
			_text.multiline = true;
			_text.x = 363;
			_text.name = "text1";
			ObjectSearch.registerID(_text, "text_" + _idscreentext + "_" + _index + "_1", false);
			//trace("registerID(" + "text_" + _idscreentext + "_" + _index + "_1");
			/*
			if (_idscreen == "territoire") {
				_text.value = "<span class='MS300_15_FFFFFF'><span style='text-align:justify'></span></span>";
			}
			else {
				_text.value = "<span class='MS300_15_FFFFFF'><span style='text-align:justify'>EMB Ces dernières décennies ont vu de nouveaux liens se tisser entre la ville et la<br />campagne par l’arrivée de citadins dans les villages du Kochersberg. Cependant, l’extension des villages n’a guère altéré le cachet traditionnel du territoire<br />: villages à flanc de coteaux ou au creux des vallons, habitations regroupées autour des clochers, grands corps de fermes soigneusement entretenus ou restaurés, clochers traditionnels<br />à deux pans, croix rurales jalonnant les chemins vicinaux...</span></span>";
			}
			_text.updateText();
			*/
			
			
			_slider.addChild(_container);
			return _container;
		}
		
		
		
		
		
		
		
		
		
		protected function getID(_id:String):Object
		{
			return ObjectSearch.getID(_id);
		}
		
		protected function getSprite(_id:String):Sprite
		{
			return Sprite(ObjectSearch.getID(_id));
		}
		protected function getISprite(_id:String):InterfaceSprite
		{
			return InterfaceSprite(ObjectSearch.getID(_id));
		}
		protected function getScrollbar(_id:String):Scrollbar
		{
			return Scrollbar(ObjectSearch.getID(_id));
		}
		protected function getText(_id:String):Text
		{
			return Text(ObjectSearch.getID(_id));
		}
		
	}

}