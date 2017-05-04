package data.facebook.dialog 
{
	import data.facebook.dialog.textformat.FacebookTitleTextFormat;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Vincent
	 */
	public class BtnFacebook extends Sprite
	{
		//_______________________________________________________________________________
		// properties
		
		public static const MODE_VALID:String = "modeValid";
		public static const MODE_CANCEL:String = "modeCancel";
		
		private const MARGIN_LEFT:Number = 4;
		private const MARGIN_TOP:Number = 2;
		private const MARGIN_RIGHT:Number = 4;
		private const MARGIN_BOTTOM:Number = 2;
		
		
		private const OUTLINE_VALID:uint = 0x29447e;
		private const OUTLINE_CANCEL:uint = 0x888888;
		private const FILLING_VALID:uint = 0x5c74a9;
		private const FILLING_CANCEL:uint = 0xFFFFFF;
		private const FONT_VALID:uint = 0xFFFFFF;
		private const FONT_CANCEL:uint = 0x333333;
		private const LINE_ROLL_VALID:uint = 0x8a9cc2;
		private const LINE_ROLL_CANCEL:uint = 0xCCCCCC;
		
		private var _mode:String;
		private var _tft:TextFormat;
		private var _colorOutline:uint;
		private var _colorFilling:uint;
		private var _colorFont:uint;
		private var _colorLineroll:uint;
		
		private var _tf:TextField;
		private var _bg:Sprite;
		private var _lineroll:Sprite;
		
		
		
		public function BtnFacebook(__mode:String, __label:String) 
		{
			if (__mode != MODE_CANCEL && __mode != MODE_VALID) throw new Error("wrong value for arg mode");
			
			_mode = __mode;
			
			
			if (_mode == MODE_VALID) {
				_colorOutline = OUTLINE_VALID;
				_colorFilling = FILLING_VALID;
				_colorFont = FONT_VALID;
				_colorLineroll = LINE_ROLL_VALID;
			}
			else if (_mode == MODE_CANCEL) {
				_colorOutline = OUTLINE_CANCEL;
				_colorFilling = FILLING_CANCEL;
				_colorFont = FONT_CANCEL;
				_colorLineroll = LINE_ROLL_CANCEL;
			}
			
			
			_bg = new Sprite();
			addChild(_bg);
			
			_lineroll = new Sprite();
			addChild(_lineroll);
			
			_tft = new FacebookTitleTextFormat();
			_tft.color = _colorFont;
			_tft.size = 13;
			
			_tf = new TextField();
			_tf.multiline = false;
			_tf.wordWrap = false;
			addChild(_tf);
			_tf.x = MARGIN_LEFT;
			_tf.y = MARGIN_TOP;
			_tf.text = __label;
			_tf.mouseEnabled = false;
			_tf.setTextFormat(_tft);
			_tf.height = 20;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			
			drawBG(_tf.width + MARGIN_LEFT + MARGIN_RIGHT, _tf.height + MARGIN_TOP + MARGIN_BOTTOM);
			
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function enable():void
		{
			this.mouseChildren = true;
			this.mouseEnabled = true;
		}
		public function disable():void
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		private function drawBG(_width:Number, _height:Number):void
		{
			var g:Graphics = _bg.graphics;
			g.clear();
			g.lineStyle(1, _colorOutline);
			g.beginFill(_colorFilling);
			g.drawRect(0, 0, _width, _height);
			
			g = _lineroll.graphics;
			g.clear();
			g.lineStyle(1, _colorLineroll);
			g.moveTo( _width - 1, 1);
			g.lineTo(1, 1);
			g.lineTo(1, _height - 1);
		}
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		private function onMouseUp(e:MouseEvent):void 
		{
			_lineroll.visible = true;
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			_lineroll.visible = false;
		}
		
		
	}

}