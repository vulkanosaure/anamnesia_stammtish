package data.facebook.dialog 
{
	import data.display.ResizeableBitmap;
	import data.facebook.dialog.textformat.FacebookTitleTextFormat;
	import data.layout.scrollbar.Scrollbar;
	import data.xtends.MovieClipRollOver;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Vincent
	 */
	public class DialogFacebook extends Sprite
	{
		//_______________________________________________________________________________
		// properties
		
		private const BODY_MARGINS:Object = { "left" : 28.0, "top" : 86.0, "right" : 28.0, "bottom" : 81.0 };
		private const FOOTER_MARGINS:Object = {"left" : 28.0, "top" : 58.0, "right" : 28.0, "bottom" : 14.0};
		
		private var _bitmap:ResizeableBitmap;
		private var _tftitle:TextField;
		private var _tfttitle:TextFormat;
		private var _btnclose:MovieClipRollOver;
		
		
		private var _size:Point;
		
		private var _footer:DisplayObject;
		private var _footerPX:Number;
		private var _footerPY:Number;
		
		private var _body:DisplayObject;
		private var _bodyPX:Number;
		private var _bodyPY:Number;
		
		private var _rectBody:Rectangle;
		private var _rectFooter:Rectangle;
		
		private var _scrollbar:Scrollbar;
		private var _stage:Stage;
		
		
		
		public function DialogFacebook(__stage:Stage) 
		{
			_stage = __stage;
			
			_bitmap = new ResizeableBitmap(DialogFacebookPNG, 39, 90, 754, 336);
			addChild(_bitmap);
			
			_tftitle = new TextField();
			_tftitle.multiline = false;
			_tftitle.wordWrap = false;
			addChild(_tftitle);
			_tftitle.x = 42;
			_tftitle.y = 18;
			_tfttitle = new FacebookTitleTextFormat();
			
			_btnclose = new DialogFacebookBtnClose();
			addChild(_btnclose);
			_btnclose.y = 19;
			_btnclose.addEventListener(MouseEvent.CLICK, onClickClose);
			
			_scrollbar = new DialogFacebookScrollbar();
			_scrollbar.autoSize = true;
			_scrollbar.arrowVisible = true;
			_scrollbar.always_visible = true;
			addChild(_scrollbar);
			
			
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function init(_width:Number, _height:Number):void
		{
			_size = new Point(_width, _height);
			_bitmap.resize(_width, _height);
			_tftitle.width = _width - 40 - _tftitle.x;
			_btnclose.x = _width - 19 - _btnclose.width;
			
			_rectBody = new Rectangle(BODY_MARGINS.left, BODY_MARGINS.top, _width - BODY_MARGINS.left - BODY_MARGINS.right, _height - BODY_MARGINS.top - BODY_MARGINS.bottom);
			_rectFooter = new Rectangle(FOOTER_MARGINS.left, _height - FOOTER_MARGINS.top, _width - FOOTER_MARGINS.left - FOOTER_MARGINS.right, FOOTER_MARGINS.top - FOOTER_MARGINS.bottom);
			
			_scrollbar.x = _rectBody.x;
			_scrollbar.y = _rectBody.y;
			_scrollbar.width = _rectBody.width + 1;
			_scrollbar.height = _rectBody.height;
			_scrollbar.addChild(_body);
			_scrollbar.init(_stage);
			
			positionItem(_footer, _footer.width, _footer.height, _footerPX, _footerPY, _rectFooter);
			positionItem(_body, _body.width, _body.height, _bodyPX, _bodyPY, _rectBody);
			
			
		}
		
		public function set title(_title:String):void
		{
			_tftitle.text = _title;
			_tftitle.setTextFormat(_tfttitle);
		}
		
		
		public function setFooter(__footer:DisplayObject, _px:Number, _py:Number):void
		{
			_footer = __footer;
			_footerPX = _px;
			_footerPY = _py;
			this.addChild(_footer);
			_footer.addEventListener(DialogFacebookEvent.CLOSE, dispatchEvent);
		}
		
		
		public function setBody(__body:DisplayObject, _px:Number, _py:Number):void
		{
			_body = __body;
			_bodyPX = _px;
			_bodyPY = _py;
			
			_body.addEventListener(DialogFacebookEvent.UPDATE_BODY, onUpdateBody);
			_body.addEventListener(DialogFacebookEvent.CLOSE, dispatchEvent);
		}
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		private function positionItem(_dobj:DisplayObject, _width:Number, _height:Number, _px:Number, _py:Number, _rect:Rectangle):void
		{
			var _x:Number = _rect.width * _px - _width * _px;
			var _y:Number = _rect.height * _py - _height * _py;
			if (_dobj != _body) {
				_x += _rect.x;
				_y += _rect.y;
			}
			_dobj.x = _x;
			_dobj.y = _y;
			
		}
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		private function onUpdateBody(e:DialogFacebookEvent):void 
		{
			_scrollbar.update();
			positionItem(_body, _body.width, _body.height, _bodyPX, _bodyPY, _rectBody);
		}
		
		
		private function onClickClose(e:MouseEvent):void 
		{
			this.dispatchEvent(new DialogFacebookEvent(DialogFacebookEvent.CLOSE));
		}
		
		
	}

}