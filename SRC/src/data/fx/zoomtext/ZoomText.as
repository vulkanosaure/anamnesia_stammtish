package data.fx.zoomtext 
{
	import data.fx.transitions.TweenManager;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Vincent
	 */
	public class ZoomText extends Sprite
	{
		//_______________________________________________________________________________
		// properties
		
		private var twm:TweenManager = new TweenManager();
		
		private var tft_small:TextFormat;
		private var tft_big:TextFormat;
		
		private var tf_small:TextField;
		private var tf_big:TextField;
		
		
		private var _scaleStart:Number;
		private var _scaleEnd:Number;
		private var _time:Number = 0.2;
		
		private var _centerX:Number = 0.5;
		private var _centerY:Number = 0.5;
		
		private var _spbig:Sprite;
		private var _spsmall:Sprite;
		
		
		public function ZoomText() 
		{
			tft_small = new TextFormat();
			tft_big = new TextFormat();
			
			tf_small = new TextField();
			tf_big = new TextField();
			
			tf_small.selectable = false;
			tf_big.selectable = false;
			tf_small.autoSize = TextFieldAutoSize.LEFT;
			tf_big.autoSize = TextFieldAutoSize.LEFT;
			tf_small.multiline = false;
			tf_small.wordWrap = false;
			tf_big.multiline = false;
			tf_big.wordWrap = false;
			
			
			_spsmall = new Sprite();
			_spbig = new Sprite();
			
			addChild(_spsmall);
			addChild(_spbig);
			
			_spsmall.addChild(tf_small);
			_spbig.addChild(tf_big);
			
			
			
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function setFormatProperty(_which:int, _key:String, _value:*):void
		{
			if (_which == -1 || - _which == 0) tft_small[_key] = _value;
			if (_which == 1 || - _which == 0) tft_big[_key] = _value;
		}
		
		public function setContent(_value:String):void
		{
			tf_small.text = _value;
			tf_big.text = _value;
			
			tf_small.setTextFormat(tft_small);
			tf_big.setTextFormat(tft_big);
			
			tf_small.x = -tf_small.width * _centerX;
			//tf_small.y = -tf_small.height * _centerY;
			_spsmall.x = tf_small.width * _centerX;
			//_spsmall.y = tf_small.height * _centerY;
			
			tf_big.x = -tf_big.width * _centerX;
			//tf_big.y = -tf_big.height * _centerY;
			_spbig.x = tf_big.width * _centerX;
			//_spbig.y = tf_big.height * _centerY;
			
		}
		
		
		public function set time(value:Number):void 
		{
			_time = value;
		}
		
		public function set centerY(value:Number):void 
		{
			_centerY = value;
		}
		
		public function set centerX(value:Number):void 
		{
			_centerX = value;
		}
		
		
		public function zoomIn():void
		{
			var _scaleBig:Number = Number(tft_big.size) / Number(tft_small.size);
			var _scaleSmall:Number = Number(tft_small.size) / Number(tft_big.size);
			
			twm.tween(_spsmall, "scaleX", 1, _scaleBig, _time);
			twm.tween(_spsmall, "scaleY", 1, _scaleBig, _time);
			//twm.tween(_spsmall, "alpha", 1, 0, _time);
			
			twm.tween(_spbig, "scaleX", _scaleSmall, 1, _time);
			twm.tween(_spbig, "scaleY", _scaleSmall, 1, _time);
			//twm.tween(_spbig, "alpha", 0, 1, _time);
			
		}
		
		public function zoomOut():void
		{
			var _scaleBig:Number = Number(tft_big.size) / Number(tft_small.size);
			var _scaleSmall:Number = Number(tft_small.size) / Number(tft_big.size);
			
			twm.tween(_spsmall, "scaleX", _scaleBig, 1, _time);
			twm.tween(_spsmall, "scaleY", _scaleBig, 1, _time);
			//twm.tween(_spsmall, "alpha", 0, 1, _time);
			
			twm.tween(_spbig, "scaleX", 1, _scaleSmall, _time);
			twm.tween(_spbig, "scaleY", 1, _scaleSmall, _time);
			//twm.tween(_spbig, "alpha", 1, 0, _time);
			
		}
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}