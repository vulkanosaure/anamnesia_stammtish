package data2.debug 
{
	import fl.controls.UIScrollBar;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Vinc
	 */
	public class InterfaceTrace 
	{
		static private const DIMENSIONS:Point = new Point(500, 560);
		static private const MARGIN:Number = 20;
		private var _tf:TextField;
		
		static private var _this:InterfaceTrace;
		private var _tft:TextFormat;
		
		
		public function InterfaceTrace() 
		{
			
			
		}
		
		public function init(_container:Sprite):void
		{
			_this = this;
			
			var _sp:Sprite = new Sprite();
			_container.addChild(_sp);
			_sp.name = "interfaceTracer";
			_sp.x = 270;
			
			var _bg:Sprite = new Sprite();
			var _g:Graphics = _bg.graphics;
			_g.beginFill(0x888888);
			_g.drawRect(0, 0, DIMENSIONS.x, DIMENSIONS.y);
			_sp.addChild(_bg);
			
			_tf = new TextField();
			_tf.width = DIMENSIONS.x - MARGIN * 2;
			_tf.height = DIMENSIONS.y - MARGIN * 2;
			_tf.x = MARGIN;
			_tf.y = MARGIN;
			_tf.border = true;
			_tf.borderColor = 0x000000;
			_tf.wordWrap = true;
			_tf.embedFonts = true;
			_sp.addChild(_tf);
			
			_tft = new TextFormat();
			_tft.font = "Museo Sans 300";
			_tft.size = 14;
			
			
			/*
			var _scrollbar:UIScrollBar = new MyUIScrollBar();
			//_scrollbar.setScrollProperties(
			_scrollbar.setSize(_tf.width, _tf.height);
			
			_sp.addChild(_scrollbar);
			_scrollbar.scrollTarget = _tf;
			_tf.x = 0; _tf.y = 0;
			_scrollbar.x = MARGIN; _scrollbar.y = MARGIN;
			_scrollbar.move(_tf.x, _tf.height + _tf.y); 
			*/
			
			
		}
		
		public function trace_(_str:String):void
		{
			_tf.text += _str + "\n";
			_tf.setTextFormat(_tft);
			_tf.scrollV = _tf.maxScrollV;
		}
		
		public static function trace2(_str:*):void
		{
			if (_this == null) return;
			_this.trace_(String(_str));
		}
		
	}

}