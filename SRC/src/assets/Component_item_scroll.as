package assets
{
	import data2.asxml.ObjectSearch;
	import data2.InterfaceSprite
	import data2.mvc.Component;
	import data2.text.Text
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite
	import flash.text.TextFormat;
	import model.translation.Translation;
	
	public class Component_item_scroll extends Component
	{
		private var _text0:Text;
		private var _text2:Text;
		private var _index:int;
		private var _mask:Sprite;
		private var _btndelete:InterfaceSprite;
		private var _bg:Sprite;
		private var _tfttitle:TextFormat;
		private var _tftdesc:TextFormat;
		private var _ts:int;
		
		public function Component_item_scroll()
		{
			
		}
		
		override public function initComponent():void
		{
			//trace("Component_item_scroll.initComponent");
			
			super.initComponent();
			
			_bg = new asset_bg_item_scroll();
			this.addChild(_bg);
			_bg.x = 0; _bg.y = 0; 
			_bg.name = "bg";
			
			
			_text0 = new Text();
			this.addChild(_text0);
			_text0.x = 77; _text0.y = 12; 
			_text0.width = 460 - 50;
			_text0.embedFonts = true;
			_text0.textformat = _tfttitle;
			ObjectSearch.registerID(_text0, "text_itemscroll_title" + _index, false);
			Translation.addCallback("text_itemscroll_title" + _index, onTextTitleChange);
			
			
			
			_text2 = new Text();
			this.addChild(_text2);
			_text2.x = 77; _text2.y = 38; 
			_text2.width = 460;
			_text2.embedFonts = true;
			_text2.textformat = _tftdesc;
			ObjectSearch.registerID(_text2, "text_itemscroll_desc" + _index, false);
			
			
			
			
			
			var _is4:Sprite = new Sprite();
			this.addChild(_is4);
			_is4.x = 6; _is4.y = 6; 
			_bmp = new Bitmap();
			_is4.addChild(_bmp);
			//_bmp.smoothing = true;
			//_bmp.pixelSnapping = PixelSnapping.ALWAYS;
			/*
			_bmp.scaleX = 1.001;
			_bmp.rotationY = 0;
			*/
			_mask = new DetailImgMask();
			_is4.addChild(_mask);
			_bmp.mask = _mask;
			
			
			
			var _btn1:InterfaceSprite = new InterfaceSprite();
			_btn1.layoutWidth = 565;
			_btn1.layoutHeight = 72;
			this.addChild(_btn1);
			_btn1.onclick = "as:#ascodescreenmain  onClickItemListing  " + _index;
			//this.clickableMargin_horiz = 30;
			_btn1.initOnClick(0);
			
			
			
			
			_btndelete = new InterfaceSprite();
			var _sp:Sprite = new asset_btn_close_footer();
			_btndelete.addChild(_sp);
			_btndelete.scaleX = _btndelete.scaleY = 0.65;
			this.addChild(_btndelete);
			_btndelete.x = 516; _btndelete.y = 20;
			_btndelete.onclick = "as:#ascodescreenmain  onClickItemListingCross  " + _index;
			_btndelete.clickableMargin = 40;
			_btndelete.initOnClick(0);
			
		}
		
		
		public function setMaskVisible(_value:Boolean):void
		{
			_mask.visible = _value;
		}
		
		private function onTextTitleChange(_texttitle:Text):void 
		{
			var _textheight:Number = _texttitle.getTextBounds().height;
			_texttitle.y = _textheight * -0.5 + 22;
			_text2.y = _texttitle.y + _textheight + 6;
		}
		
		override protected function updateImg():void 
		{
			super.updateImg();
			var _bmpd:BitmapData = _bmp.bitmapData;
			_bmp.width = _bmp.height = 62;
		}
		
		
		
		
		/*
		public function setContent(_title:String, _subtitle:String, _address:String):void 
		{
			
			_text0.value = "<span class='MS900_15_FFFFFF'>" + _title + "</span>";
			_text0.updateText();
			
			_text1.value = "<span class='MS300I_15_FFFFFF'>" + _subtitle + "</span>";
			_text1.updateText();
			
			_text2.value = "<span class='MS500_15_FFFFFF'>" + _address + "</span>";
			_text2.updateText();
		}
		*/
		
		
		private function formatDate(_ts:int):String
		{
			var _date:Date = new Date(_ts * 1000);
			//_date.setTime((_ts) * 1000);
			
			var _strday:String = String(_date.getDate());
			if (_strday.length < 2) _strday = "0" + _strday;
			
			var _strmon:String = String(_date.getMonth() + 1);
			if (_strmon.length < 2) _strmon = "0" + _strmon;
			
			var _stryear:String = String(_date.getFullYear());
			
			var _strdate:String = _strday + "/" + _strmon + "/" + _stryear;
			
			return _strdate;
		}
		
		public function setBtnDeleteVisible(_value:Boolean):void
		{
			_btndelete.visible = _value;
		}
		
		
		public function set index(value:int):void { _index = value; }
		
		public function get bg():Sprite {return _bg;}
		
		public function set tfttitle(value:TextFormat):void { _tfttitle = value; }
		
		public function get tfttitle():TextFormat { return _tfttitle; }	
		
		public function get tftdesc():TextFormat { return _tftdesc; }	
		
		public function set tftdesc(value:TextFormat):void { _tftdesc = value; }	
		
		public function set ts(value:int):void 
		{ 
			_ts = value; 
			if (_ts != 0) {
				_text2.value = formatDate(_ts);
				_text2.updateText();
				_text2.visible = true;
			}
			else {
				_text2.visible = false;
			}
		}
		
		public function resetTS():void
		{
			_text2.visible = false;
		}
		
		
	}
	
}

