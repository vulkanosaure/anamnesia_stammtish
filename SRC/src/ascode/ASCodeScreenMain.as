package ascode 
{
	import assets.Component_detail_img;
	import color.InterfaceColor;
	import com.adobe.utils.ArrayUtil;
	import data2.asxml.ASCode;
	import data2.asxml.Constantes;
	import data2.asxml.ObjectSearch;
	import data2.debug.profiler.Profiler;
	import data2.fx.delay.DelayManager;
	import data2.navigation.Navigation;
	import data2.net.imageloader.ImageLoader;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import model.ModelArticle;
	import model.ModelLike;
	import model.translation.Translation;
	import utils.Animation;
	import utils.virtualkeyboard.VirtualKeyboardEvent;
	import view.ViewGlobal;
	import view.ViewHeader;
	import view.ViewMainScreen;
	import view.ViewPrint;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ASCodeScreenMain extends ASCode
	{
		private var _filters:Array;
		private var _listindexes:Array;
		private var _listdata:Array;
		private var _selectedIndex:int;
		private var _indexXML:int;
		private var _favorite:Boolean;
		private var _listtags:Array;
		private var _binitactu:Boolean = false;
		private var _idscreen:String;
		private var _typecat:String;
		private var _dirmenu2:String;
		
		public function ASCodeScreenMain() 
		{
			
		}
		
		override public function exec():void 
		{
			super.exec();
			Navigation.addCallback("", "screen_main", Navigation.CALLBACK_QUIT, onQuitScreen);
			Navigation.addCallback("subscreen_detail", "subscreen_detail", Navigation.CALLBACK_GOTO, onOpenDetail);
			Navigation.addCallback("subscreen_detail", "subscreen_detail", Navigation.CALLBACK_QUIT, onQuitDetail);
			
			ViewMainScreen.handlerKeyboardInput = onKeyboardInput;
			ViewMainScreen.handlerSearch = onKeyboardEnter;
			ViewMainScreen.init(_stage);
			ViewPrint.init();	
			
		}
		
		private function onKeyboardInput(e:VirtualKeyboardEvent):void 
		{
			trace("onKeyboardInput " + e.charCode);
			ViewMainScreen.applyKeyboardInput(e);
		}
		private function onKeyboardEnter():void 
		{
			trace("onKeyboardEnter");
			applySearch();
		}
		
		
		
		
		public function initActu():void
		{
			var _nbactu:int = int(Constantes.get("config.nb_actu_right"));
			trace("_nbactu :" + _nbactu);
			
			var _listactu:Array = ModelArticle.getActu(_nbactu);
			var _nbactu:int = _listactu.length;
			
			ViewMainScreen.initActu(_nbactu, _listactu);
			
			
		}
		
		
		
		
		
		
		public function initContent(__listtags:Array, __listindexes:Array = null, __favorite:Boolean = false, __idscreen:String = "", __typecat:String = "", __dirmenu2:String = "", __search:String = ""):void
		{
			trace("initContent : ");
			
			
			_typecat = __typecat;
			_favorite = __favorite;
			_listtags = __listtags;
			_idscreen = __idscreen;
			_dirmenu2 = __dirmenu2;
			trace("_idscreen : " + _idscreen);
			
			if (!_binitactu) {
				initActu();
				_binitactu = true;
			}
			
			
			//if (DataGlobal.DEBUG_MODE) _favorite = true;
			
			if (_filters == null) _filters = [];
			else _filters.splice(0);
			trace("_filters.length : "+_filters.length);
			
			
			if (!_favorite) {
				Translation.add("text_subtitle", "screen_main.subtitle", "MS500_15_FFFFFF", "", false, true);
			}
			else {
				Translation.add("text_subtitle", "screen_main.subtitle_favourite", "MS500_15_FFFFFF", "", false, false);
			}
			_filters.push("text_subtitle");
			
			ViewGlobal.setVisible("btn_goto_mail", _favorite);
			ViewGlobal.setVisible("btn_print", _favorite);
			
			ViewGlobal.setVisible("text_subtitle", true);
			
			
			if (_listtags != null) _listindexes = ModelArticle.getIndexesByTags(_listtags, _typecat);
			else _listindexes = __listindexes;
			
			
			if (__search != "") {
				_listindexes = ModelArticle.getFilteredIndexes(_listindexes, __search);
			}
			
			trace("_listindexes : " + _listindexes);
			
			if (_listindexes.length == 0) {
				ViewMainScreen.setNoResultVisible(true);
			}
			else {
				ViewMainScreen.setNoResultVisible(false);
			}
			
			var _nbarticle:int = _listindexes.length;
			
			
			var _listArticle:Array = ModelArticle.getArticleByIndexes(_listindexes);
			_listdata = _listArticle;
			
			
			ViewMainScreen.initItems(_nbarticle, _favorite, _listdata, _idscreen);
			
			InterfaceColor.applyColor(DataGlobal.save_colors);
			InterfaceColor.applyColor_tab(DataGlobal.save_colors, ViewMainScreen.listBGItems);
			
			
			
			//trace("_listArticle : " + _listArticle);
			
			
			var _dir:String = (!_favorite) ? _idscreen : "favourite";
			trace("_dir1 : " + _dir);
			if (_dir == "") _dir = __dirmenu2;
			trace("_dir2 : " + _dir);
			
			
			if (_dir != "") {
				var _componentimg:Component_detail_img = Component_detail_img(ObjectSearch.getID("component_detail_img"));
				_componentimg.group = "";
				//_componentimg.urlimg = "images/detail/" + _dir + "/img-detail-header" + _indeximg + ".png";
				_componentimg.urlimg = "images/detail/" + _dir + "/img-detail-header.png";
				_componentimg.updateComponent();
			}
			
			
			Profiler.start("translation");
			//text_itemscroll_title/desc
			for (var i:int = 0; i < _nbarticle; i++) 
			{
				var _id:String;
				var _data:Object = _listArticle[i];
				
				_id = "text_itemscroll_title" + i;
				
				//Translation.addDynamic(_id, "list_articles.item", "title", _id, "MS900_15_FFFFFF", "");
				Translation.addDynamic(_id, "list_articles.item", "title", _id, "", "");
				Translation.setDynamicIndex(_id, _listindexes[i]);
				_filters.push(_id);
				
				ViewMainScreen.setDataScrollItem(i, _data);
				
			}
			Profiler.end("translation");
			
			
			Translation.setContentVariable("nbrep", String(_nbarticle));
			_filters.push("text_subtitle");
			
			ImageLoader.loadGroup();
			
			trace("perftest");
			Translation.translate("", _filters);
			
			
			trace(Profiler.getBilan());
			Profiler.reset();
			
			
			if (__search == "") {
				ViewMainScreen.resetInputFilter();
			}
			
		}
		
		
		
		public function onClickGotoMail():void
		{
			Navigation.gotoScreen("", "screen_entermail");
		}
		
		public function onClickPrint():void
		{
			trace("ASCodeScreenMain.onClickPrint");
			
			var _list:Array = ModelLike.getList();
			var _listArticles:Array = ModelArticle.getArticleByIndexes(_list);
			
			ViewPrint.print(_listArticles);
			
		}
		
		public function onClickSearch(_type:String):void
		{
			var _open:Boolean = (Navigation.getCurscreen("virtual_keyboard_filter") != "");
			if (!_open) {
				openKeyboardFilter();
			}
			else {
				if (_type == "btn") {
					applySearch();
				}
			}
		}
		
		
		private function openKeyboardFilter():void 
		{
			Navigation.gotoScreen("virtual_keyboard_filter", "virtual_keyboard_filter", 300);
			ViewMainScreen.setInputFilterFocus();
		}
		
		private function closeKeyboardFilter(_resetfield:Boolean):void 
		{
			Navigation.gotoScreen("virtual_keyboard_filter", "");
			if (_resetfield) ViewMainScreen.resetInputFilter();
		}
		
		
		private function applySearch():void 
		{
			var _search:String = ViewMainScreen.getFilterInput();
			if (_search != "") {
				trace("applySearch : " + _search);
				
				initContentFilter(_search);
				
			}
			closeKeyboardFilter(false);
		}
		
		private function initContentFilter(_filter:String):void
		{
			initContent(_listtags, null, false, _idscreen, _typecat, _dirmenu2, _filter);
		}
		
		
		
		public function onClickResetFilter():void
		{
			ViewMainScreen.setNoResultVisible(false);
			DelayManager.add("", 200, function():void{
				initContentFilter("");
			});
		}
		
		
		public function onClickCloseKeyboard():void
		{
			closeKeyboardFilter(true);
		}
		
		
		private function onQuitDetail():void 
		{
			ViewMainScreen.fadeItems("logo_footer", true);
			ViewMainScreen.fadeItems("btn_credit", true);
		}
		
		private function onOpenDetail():void 
		{
			ViewMainScreen.fadeItems("logo_footer", false);
			ViewMainScreen.fadeItems("btn_credit", false);
			
		}
		
		private function onQuitScreen():void 
		{
			Navigation.gotoScreen("subscreen_detail", "");
			resetListing();
			
		}
		
		private function resetListing():void 
		{
			ViewMainScreen.resetListing();
		}
		
		
		public function onClickNextPage():void
		{
			trace("ASCodeScreenMain.onClickNextPage");
			_selectedIndex++;
			DelayManager.add("", 450, updateDetail, _selectedIndex);
			Navigation.gotoScreen("subscreen_detail", "subscreen_detail", 300);
			
			ViewMainScreen.gotoDetailNext();
		}
		
		
		public function onClickPrevPage():void
		{
			trace("ASCodeScreenMain.onClickPrevPage");
			_selectedIndex--;
			DelayManager.add("", 450, updateDetail, _selectedIndex);
			Navigation.gotoScreen("subscreen_detail", "subscreen_detail", 300);
			
			ViewMainScreen.gotoDetailPrev();
			
		}
		
		public function onClickCloseDetail():void
		{
			trace("ASCodeScreenMain.onClickCloseDetail");
			Navigation.gotoScreen("subscreen_detail", "", 300);
		}
		
		public function onClickMenu():void
		{
			trace("ASCodeScreenMain.onClickMenu");
			if (Navigation.getCurscreen("virtual_keyboard_filter") != "") {
				closeKeyboardFilter(true);
			}
			
			Navigation.gotoScreen("", "screen_menu");
		}
		
		public function onClickItemListing(_index:int):void
		{
			trace("onClickItemListing " + _index);
			_selectedIndex = _index;
			updateDetail(_index);
			Navigation.gotoScreen("subscreen_detail", "subscreen_detail", 300);
			
		}
		
		
		private function updateDetail(_index:int):void
		{
			_indexXML = _listindexes[_index];
			trace("_indexXML : " + _indexXML);
			
			_filters.splice(0);
			var _id:String;
			
			_id = "text_detail_title";
			Translation.addDynamic(_id, "list_articles.item", "title", _id, "MS900_30_FFFFFF");
			Translation.setDynamicIndex(_id, _indexXML);
			_filters.push(_id);
			
			
			_id = "text_detail_desc";
			Translation.addDynamic(_id, "list_articles.item", "content", _id, "MS300_15_FFFFFF");
			Translation.setDynamicIndex(_id, _indexXML);
			_filters.push(_id);
			
			
			_id = "text_detail_infos";
			Translation.addDynamic(_id, "list_articles.item", "address", _id, "MS300_12_FFFFFF");
			Translation.setDynamicIndex(_id, _indexXML);
			_filters.push(_id);
			
			
			var _isFavourite:Boolean = ModelLike.contains(_indexXML);
			trace("_isFavourite : " + _isFavourite);
			ViewGlobal.setVisible("container_btn_like", !_isFavourite);
			
			var _data:Object = _listdata[_index];
			
			Translation.translate("", _filters);
			
			
			var _dir:String = (!_favorite) ? _idscreen : "favourite";
			ViewMainScreen.selectDetail(_index, _data, _dir);
			
			ViewMainScreen.layoutDetail();
		}
		
		
		
		public function onClickQRCode():void
		{
			
		}
		
		public function onClickLike():void
		{
			trace("onClickLike");
			ViewMainScreen.bumpBtnLike();
			ViewMainScreen.enableBtn("btn_like", false);
			DelayManager.add("", 300, ViewMainScreen.enableBtnVisual, "container_btn_like", false);
			
			ASCodeHeader(ObjectSearch.getID("ascodeheader")).addItemLike(_indexXML);
		}
		
		
		
		
		public function onClickItemListingCross(_index:int):void
		{
			trace("onClickItemListingCross(" + _index + ")");
			
			_listindexes.splice(_index, 1);
			ViewHeader.setBtnLikeNumber(ModelLike.getLength());
			
			initContent(null, _listindexes, _favorite);
			
			
			
		}
		
		
		
	}

}