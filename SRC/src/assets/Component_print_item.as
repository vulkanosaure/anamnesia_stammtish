package assets 
{
	import data2.asxml.ObjectSearch;
	import data2.mvc.Component;
	import data2.text.Text;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import model.translation.Translation;
	/**
	 * ...
	 * @author ...
	 */
	public class Component_print_item extends Component
	{
		private var _mask:Sprite;
		
		private var _text0:Text;
		private var _text2:Text;
		
		private var _index:int;
		private var _qrcode:Bitmap;
		private var _qrcodeparent:Sprite;
		
		public function Component_print_item() 
		{
			
		}
		
		override public function initComponent():void 
		{
			super.initComponent();
			
			var _bg:Sprite = new print_item_bg();
			addChild(_bg);
			
			
			
			var _is4:Sprite = new Sprite();
			this.addChild(_is4);
			_is4.x = 33; _is4.y = 35; 
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
			
			_is4.scaleX = _is4.scaleY = 2.1;
			
			_text0 = new Text();
			this.addChild(_text0);
			_text0.x = 201;
			_text0.width = 847;
			_text0.embedFonts = true;
			_text0.multiline = true;
			_text0.debugBorder = false;
			/*
			ObjectSearch.registerID(_text0, "text_itemscroll_title" + _index, false);
			Translation.addCallback("text_itemscroll_title" + _index, onTextTitleChange);
			*/
			
			_text2 = new Text();
			this.addChild(_text2);
			_text2.x = 201;
			_text2.width = 847;
			_text2.embedFonts = true;
			_text2.multiline = true;
			_text2.debugBorder = false;
			/*
			ObjectSearch.registerID(_text2, "text_itemscroll_desc" + _index, false);
			*/
			
			
		}
		
		public function setTitle(_str:String):void
		{
			_text0.value = "<span class='print_item_title'>" + _str + "</span>";
			_text0.updateText();
			
			var _textheight:Number = _text0.getTextBounds().height;
			_text0.y = Math.round(_textheight * -0.5 + 74);
			_text2.y = Math.round(_text0.y + _textheight + 8);
		}
		public function setDesc(_str:String):void
		{
			_text2.value = "<span class='print_item_desc'>" + _str + "</span>";
			_text2.updateText();
			
		}
		
		public function setQRCode(_bmp:Bitmap):void 
		{
			_qrcode = new Bitmap(_bmp.bitmapData);
			_qrcode.cacheAsBitmap = true;
			
			_qrcode.x = 1083;
			_qrcode.y = 19;
			_qrcode.width = 158;
			_qrcode.height = 158;
			
			_qrcodeparent = new Sprite();
			addChild(_qrcodeparent);
			_qrcodeparent.addChild(_qrcode);
			_qrcodeparent.cacheAsBitmap = true;
			_qrcodeparent.blendMode = BlendMode.ADD;
		}
		
		public function reset():void 
		{
			if (_qrcode != null) this.removeChild(_qrcode);
			
		}
		
		
		override protected function updateImg():void 
		{
			super.updateImg();
			var _bmpd:BitmapData = _bmp.bitmapData;
			_bmp.width = _bmp.height = 62;
		}
		
	}

}