package view 
{
	import assets.Asset_component_actu;
	import assets.Component_detail_img;
	import assets.Component_item_scroll;
	import assets.pagination.Component_pagination;
	import assets.TextInput;
	import color.InterfaceColor;
	import data2.asxml.ObjectSearch;
	import data2.display.scrollbar.Scrollbar;
	import data2.fx.delay.DelayManager;
	import data2.InterfaceSprite;
	import data2.math.Math2;
	import data2.mvc.ViewBase;
	import data2.net.imageloader.ImageLoader;
	import data2.text.Text;
	import fl.transitions.easing.Regular;
	import fl.transitions.easing.Strong;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import model.translation.Translation;
	import org.qrcode.QRCode;
	import utils.Animation;
	import utils.virtualkeyboard.AzertyKeyboardType;
	import utils.virtualkeyboard.geom.XPoint;
	import utils.virtualkeyboard.KBKey;
	import utils.virtualkeyboard.VirtualKeyboard;
	import utils.virtualkeyboard.VirtualKeyboardEvent;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ViewMainScreen extends ViewBase
	{
		static public const INTERLINE_ITEMS:int = 87;
		static private var _pagination:Component_pagination;
		static private var _indexpage:int;
		
		
		static private var _nbpage:int;
		static private var _listQRCodes:Array;
		
		static private var _listItems:Vector.<Component_item_scroll>;
		static private var _listActus:Vector.<Asset_component_actu>;
		static private var _listBGItems:Vector.<Sprite>;
		static private var _lenItems:int;
		static private var _lenActu:int;
		static private var _bmask:Boolean = false;
		static private var _scrollmain:Scrollbar;
		static private var _scrollactu:Scrollbar;
		static private var _container:Sprite;
		static private var _containerActu:Sprite;
		
		static private var _handlerKeyboardInput:Function;
		static private var _handlerSearch:Function;
		
		static private var _inputFilter:TextInput;
		
		
		
		public function ViewMainScreen() 
		{
			
		}
		
		
		static public function init(_stage:Stage):void 
		{
			//content fake
			var _container:Sprite = getSprite("scroll_main_content");
			_listItems = new Vector.<Component_item_scroll>();
			_listBGItems = new Vector.<Sprite>();
			
			_listActus = new Vector.<Asset_component_actu>();
			
			
			_scrollmain = getScrollbar("scroll_main");
			_scrollmain.optimizeFunction = optimizeScrollMain;
			
			_scrollactu = getScrollbar("scroll_zone_list_actu");
			_scrollactu.optimizeFunction = optimizeScrollActu;
			
			
			
			var _keyboard:VirtualKeyboard = new VirtualKeyboard("filter");
			_keyboard._stage = _stage;
			_keyboard.keyboardType = new AzertyKeyboardType(new XPoint(74, 103), 23, 17, KBKey);
			_keyboard.addEventListener(VirtualKeyboardEvent.INPUT, _handlerKeyboardInput);
			_keyboard.scaleX = _keyboard.scaleY = 0.8;
			
			var _container:Sprite = getSprite("virtual_keyboard_container_filter");
			_container.addChild(_keyboard);
			
			
			var _containerInput:Sprite = getSprite("zone_input_filter_sub");
			_inputFilter = new TextInput();
			_inputFilter.x = 10; _inputFilter.y = 12;
			_inputFilter.width = 509 - _inputFilter.x * 2;
			_containerInput.addChild(_inputFilter);
			_inputFilter.mouseEnabled = false;
			
		}
		
		
		
		static private function optimizeScrollActu():void 
		{
			var _scrolly:Number = _scrollactu.getScrollY() - 600;
			var _scrollyend:Number = _scrolly + 1050;
			
			for (var i:int = 0; i < _lenActu; i++) 
			{
				var _child:Asset_component_actu = _listActus[i];
				var _y:Number = _child.y;
				
				if (_y > _scrolly && _y < _scrollyend) {
					if (!_containerActu.contains(_child)) _containerActu.addChild(_child);
				}
				else {
					if (_containerActu.contains(_child)) _containerActu.removeChild(_child);
				}
			}
		}
		
		
		
		static private function optimizeScrollMain():void 
		{
			//get ind min and max
			var _scrolly:Number = _scrollmain.getScrollY();
			
			var _indstart:int = Math.floor(_scrolly / INTERLINE_ITEMS);
			var _indend:int = _indstart + 5;
			
			for (var i:int = 0; i < _lenItems; i++) 
			{
				var _child:Component_item_scroll = _listItems[i];
				
				if (i >= _indstart && i <= _indend) {
					if (!_container.contains(_child)) _container.addChild(_child);
				}
				else {
					if (_container.contains(_child)) _container.removeChild(_child);
				}
			}
		}
		
		
		
		
		
		
		static public function initItems(_len:int, _favourite:Boolean, _listdata:Array, _idscreen:String, _listtags:Array):void 
		{
			trace("initItems " + _listtags);
			
			_container = getSprite("scroll_main_content");
			var _nbitem:int = _listItems.length;
			_lenItems = _len;
			
			var _tfttitle:TextFormat = new TextFormat("Museo Sans 900", 15, 0xFFFFFF);
			_tfttitle.leading = -1;
			
			var _tftdesc:TextFormat = new TextFormat("Museo Sans 500", 15, 0xFFFFFF);
			
			
			//instanciation
			
			for (var i:int = 0; i < _len; i++) 
			{
				if (i >= _nbitem) {
					var _item:Component_item_scroll = new Component_item_scroll();
					_item.index = i;
					_item.group = "";
					_item.tfttitle = _tfttitle;
					_item.tftdesc = _tftdesc;
					
					
					_item.initComponent();
					_listItems.push(_item);
					_listBGItems.push(_item.bg);
					
				}
				
			}
			
			//addchild / position
			
			while (_container.numChildren) {
				
				_container.removeChildAt(0);
			}
			for (var i:int = 0; i < _len; i++) 
			{
				var _item:Component_item_scroll = _listItems[i];
				
				_item.y = i * INTERLINE_ITEMS;
				_item.setBtnDeleteVisible(_favourite);
				
				if (_listtags != null && _listtags.indexOf("actualite") != -1) {
					var _obj:Object = _listdata[i];
					_item.ts = _obj.date;
				}
				else {
					_item.resetTS();
				}
			}
			
			
			getScrollbar("scroll_main").contentheight = _len * INTERLINE_ITEMS;
			getScrollbar("scroll_main").update();
			
			_indexpage = 0;
			_nbpage = _len;
			
			ViewMainScreen.initPagination(_nbpage);
			ViewMainScreen.selectPagination(_indexpage);
			
		}
		
		
		
		
		
		static public function fadeItems(_id:String, _value:Boolean):void 
		{
			var _sp:Sprite = getSprite(_id);
			
			var _start:Number = (_value) ? 0 : 1;
			var _end:Number = (!_value) ? 0 : 1;
			_twm.tween(_sp, "alpha", _start, _end, 0.3);
		}
		
		static public function initPagination(_nbpage:Number):void 
		{
			if (_pagination == null) {
				_pagination = Component_pagination(getID("component_pagination_detail"));
				_pagination.initComponent();
			}
			
			if (_nbpage < 40) {
				_pagination.nbitem = _nbpage;
				_pagination.updateComponent();
				_pagination.x = Math.round( -_pagination.getWidth());
				_pagination.visible = true;
			}
			else {
				_pagination.visible = false;
			}
			
			
			
		}
		
		static public function selectPagination(_index:int):void
		{
			
			_pagination.select(_index);
		}
		
		
		
		
		
		
		
		static public function selectDetail(_index:int, _data:Object, _dir:String):void 
		{
			_indexpage = _index;
			trace("selectDetail : " + _index + " / " + _nbpage);
			
			lockBtnNavigation();
			ViewMainScreen.selectPagination(_indexpage);
			
			enableBtnVisual("container_btn_like", true);
			enableBtn("btn_like", true);
			
			
			var _componentimg:Component_detail_img = Component_detail_img(ObjectSearch.getID("component_detail_img"));
			//var _indeximg:int = Math2.random(1, 10, 1);
			
			if (!_bmask) {
				var _mask:Sprite = new mask_img_detail();
				getSprite("asset_detail_img").addChild(_mask);
				_componentimg.mask = _mask;
				_bmask = true;
			}
			
			
			
			
			var _containerqrcode:Sprite = getSprite("btn_qrcode");
			if (_data["url"] != "") {
				var _bmpqrcode:Bitmap = generateQRCode(_data["url"]);
				while (_containerqrcode.numChildren) _containerqrcode.removeChildAt(0);
				_containerqrcode.addChild(_bmpqrcode);
				_containerqrcode.visible = true;
			}
			else {
				_containerqrcode.visible = false;
			}
			
			
			
			//InterfaceColor.applyColor_object(_containerqrcode, 0xFFFFFF);
			
		}
		
		static public function generateQRCode(_url:String):Bitmap 
		{
			trace("generateQRCode(" + _url + ")");
			if (_listQRCodes == null) _listQRCodes = new Array();
			
			var _indexof:int = -1;
			var _len:int = _listQRCodes.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _obj:Object = _listQRCodes[i];
				if (_obj["url"] == _url) {
					_indexof = i;
					break;
				}
			}
			
			var _bmpqrcode:Bitmap;
			if (_indexof == -1) {
				var _qrcode:QRCode = new QRCode();
				_qrcode.encode(_url);
				_bmpqrcode = new Bitmap(_qrcode.bitmapData);
				_bmpqrcode.blendMode = BlendMode.ADD;
				_bmpqrcode.smoothing = true;
				_listQRCodes.push( { "url" : _url, "bmp" : _bmpqrcode } );
				
				var _width:int = _qrcode.bitmapData.width;
				var _height:int = _qrcode.bitmapData.height;
				
				for (var _x:int = 0; _x < _width; _x++) 
				{
					for (var _y:int = 0; _y < _height; _y++) 
					{
						var _col:uint = _qrcode.bitmapData.getPixel(_x, _y);
						var _col2:uint = (_col == 0xFFFFFF) ? 0x00000000 : 0xFFFFFFFF;
						_qrcode.bitmapData.setPixel32(_x, _y, _col2);
						
					}
				}
				
			}
			else {
				_bmpqrcode = Bitmap(_listQRCodes[_indexof]["bmp"]);
			}
			
			return _bmpqrcode;
		}
		
		
		
		
		static public function applyKeyboardInput(e:VirtualKeyboardEvent):void 
		{
			var _text:String = _inputFilter.text;
			
			if (e.charCode == Keyboard.BACKSPACE) {
				_text = _text.substr(0, _text.length - 1);
			}
			else	{
				
				var _addChar:String;
				if (e.charCode == Keyboard.ENTER){
					_handlerSearch();
					return;
				}
				else {
					_addChar = String.fromCharCode(e.charCode);
				}
				
				_addChar = _addChar.toLowerCase();
				_text += _addChar;
				
			}
			
			_inputFilter.text = _text;
		}
		
		
		
		
		static private function lockBtnNavigation():void 
		{
			var _lockleft:Boolean = (_indexpage == 0);
			var _lockright:Boolean = (_indexpage == _nbpage - 1);
			
			var _btnleft:InterfaceSprite = getISprite("btn_detail_pagination_prev");
			var _btnright:InterfaceSprite = getISprite("btn_detail_pagination_next");
			
			_btnleft.alpha = (_lockleft) ? 0.4 : 1.0;
			_btnright.alpha = (_lockright) ? 0.4 : 1.0;
			_btnleft.touchable = !_lockleft;
			_btnright.touchable = !_lockright;
		}
		
		
		
		
		static public function gotoDetailPrev():void 
		{
			_indexpage--;
			animChangeDetail();
		}
		
		static public function gotoDetailNext():void 
		{
			_indexpage++;
			animChangeDetail();
		}
		
		static public function bumpBtnLike():void 
		{
			Animation.bump(getSprite("btn_like"));
		}
		
		static public function enableBtn(_id:String, _value:Boolean):void 
		{
			getISprite(_id).touchable = _value;
		}
		
		static public function enableBtnVisual(_id:String, _value:Boolean):void 
		{
			getISprite(_id).alpha = (_value) ? 1.0 : 0.4;
		}
		
		
		
		static public function setDataScrollItem(_index:int, _data:Object):void 
		{
			var _item:Component_item_scroll = _listItems[_index];
			
			var _url:String = _data["img_thumb"];
			
			if (DataGlobal.DEBUG_MODE) _url = _url.replace("http://lebeaujardin.alsace", "http://otkochersberg.izhak2.client.openagilex.net");
			
			if (DataGlobal.DEBUG_PERFS) {
				_url = "";
				//_item.visible = _index < 12;
				
			}
			
			
			if (_url != "" && _url != "http://otkochersberg.izhak2.client.openagilex.net/" && _url != "http://lebeaujardin.alsace/") {
				_item.urlimg = _url;
				_item.updateComponent();
				_item.setMaskVisible(true);
			}
			else {
				_item.setMaskVisible(false);
			}
			
			
			
		}
		
		
		static public function layoutTitles():void 
		{
			var _texttitle:Text = getText("text_title");
			var _textsub:Text = getText("text_subtitle");
			
			//_textsub.y = _texttitle.getTextBounds().height + 10;
			trace("_texttitle.height : " + _texttitle.height);
			_texttitle.y = 0 - _texttitle.height + 40;
			
			
		}
		
		static public function layoutDetail():void
		{
			var _texttitledetail:Text = getText("text_detail_title");
			var _scrollbar:Scrollbar = getScrollbar("scroll_detail");
			var _titleheight:Number = _texttitledetail.getTextBounds().height;
			
			_scrollbar.y = _texttitledetail.y + _titleheight + 10;
			_scrollbar.height = 320 - _titleheight;
			_scrollbar.update();
		}
		
		
		
		static public function initActu(_nb:int, _listactu:Array):void 
		{
			trace("ViewMainScreen.initActu");
			
			var _filters:Array = [];
			_containerActu = getISprite("zone_list_actu");
			
			var _tftitle:TextFormat = new TextFormat("Museo Sans 700", 13, 0xFFFFFF);
			var _tfdesc:TextFormat = new TextFormat("Museo Sans 300", 13, 0xFFFFFF);
			var _tfdate:TextFormat = new TextFormat("Museo Sans 700", 15, 0xFFFFFF);
			
			
			for (var i:int = 0; i < _nb; i++) 
			{
				var _objdata:Object = _listactu[i];
				
				var _item:Asset_component_actu = new Asset_component_actu();
				_item._index = i;
				_item.tfttitle = _tftitle;
				_item.tftdesc = _tfdesc;
				_item.tftdate = _tfdate;
				_item.initComponent();
				
				
				var _id:String;
				
				_id = "text_actu_title" + i;
				//Translation.addDynamic(_id, "list_actu.item", "title", _id, "MS700_11_FFFFFF");
				Translation.addDynamic(_id, "list_actu.item", "title", _id, "");
				Translation.setDynamicIndex(_id, i);
				_filters.push(_id);
				
				_id = "text_actu_desc" + i;
				//Translation.addDynamic(_id, "list_actu.item", "content", _id, "MS300_11_FFFFFF");
				Translation.addDynamic(_id, "list_actu.item", "content", _id, "");
				Translation.setDynamicIndex(_id, i);
				_filters.push(_id);
				
				_containerActu.addChild(_item);
				_item.y = i * 100;
				
				var _ts:int = int(_objdata["date"]);
				_item.setDate(_ts);
				//trace("_ts : " + _ts);
				
				_listActus.push(_item);
				
			}
			
			Translation.translate("", _filters);
			InterfaceSprite(_containerActu).updateBehaviours();
			_lenActu = _listActus.length;
			
			
			
			getScrollbar("scroll_zone_list_actu").contentheight = _containerActu.height;
			getScrollbar("scroll_zone_list_actu").update();
			
			
		}
		
		
		
		static public function resetListing():void 
		{
			
			var _container:Sprite = getSprite("scroll_main_content");
			
			while (_container.numChildren) {
				/*
				var _dobj:DisplayObject = _container.getChildAt(0);
				if (_dobj is Component_item_scroll) {
					trace("yes reset");
					Component_item_scroll(_dobj).resetComponent();
				}
				*/
				_container.removeChildAt(0);
			}
		}
		
		static public function setInputFilterFocus():void 
		{
			getSprite("text_help_filter").visible = false;
		}
		
		static public function resetInputFilter():void 
		{
			getSprite("text_help_filter").visible = true;
			_inputFilter.text = "";
		}
		
		static public function getFilterInput():String 
		{
			return _inputFilter.text;
		}
		
		static public function setNoResultVisible(boolean:Boolean):void 
		{
			getSprite("screen_main_zone_noresult").visible = boolean;
		}
		static public function setNoResultY(_value:Number):void
		{
			getSprite("screen_main_zone_noresult").y = _value;
		}
		
		
		
		static private function animChangeDetail():void 
		{
			var _sp:Sprite = getSprite("subscreen_detail_sub");
			var _len:Number = 1100;
			_twm.tween(_sp, "x", 0, _len, 0.3, 0.0, Strong.easeIn);
			_twm.tween(_sp, "x", _len, 0, 0.5, 0.45, Strong.easeOut);
			
		}
		
		static public function get listItems():Vector.<Component_item_scroll> {return _listItems;}
		
		
		static public function get listBGItems():Vector.<Sprite> { return _listBGItems; }	
		
		static public function set handlerKeyboardInput(value:Function):void { _handlerKeyboardInput = value; }	
		
		static public function set handlerSearch(value:Function):void { _handlerSearch = value; }	
		
		
		
		
		
	}

}