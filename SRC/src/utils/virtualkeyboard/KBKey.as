package utils.virtualkeyboard {
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	public class KBKey extends KeyView implements IKeyView, IDisposable {
		
		private const SIZE:Number = 72;
		private const ROUND:Number = 5;
		
		private var _bg:Shape;
		private var _tf:AppTextField;
		private var _width:Number = SIZE;
		private var _height:Number = 100;
		private var _fontsize:int = -1;
		
		private var _color:uint = 0xffffff;
		private var _bgalpha:Number = 0.65;
		private var _colorover:uint = 0xe3e3e3;
		private var _container:Sprite;
		private var _spriteImg:DisplayObject;
		private var _glowFilter:GlowFilter;
		
		public function KBKey(_sp:DisplayObject = null) {
			
			// ---	display list & appearance
			
			_container = new Sprite();
			addChild(_container);
			
			
			_bg = new Shape();
			draw(_color, false);
			_container.addChild(_bg);
			
			if (_sp != null) {
				_container.addChild(_sp);
				_spriteImg = _sp;
			}
			else {
				_tf = new AppTextField();
				_container.addChild(_tf);
			}
			
			
			_glowFilter = new GlowFilter(0x000000, 0.5, 18, 18);
			
			//filters = [new DropShadowFilter(4, 45, 0x0, .3, 4, 4)];
			
			// ---	aprent constructor
			super();
		}
		
		
		private function draw(_col:uint, _hover:Boolean):void
		{
			_bg.graphics.clear();
			
			var _alpha:Number = (_hover) ? 1 : _bgalpha;
			_bg.graphics.beginFill(_col, _alpha);
			
			var _h:Number = _height;
			if (_hover) _h += 35;
			_bg.graphics.drawRoundRect(0, 0, _width, _h, ROUND, ROUND);
			_bg.graphics.endFill();
			
		}
		
		
		override public function setMouseDown():void
		{
			draw(_colorover, true);
			//_container.scaleX = 1.3;
			_container.width = _width + 30;
			_container.scaleY = 1.35;
			//_container.height = _height + 50;
			
			_container.x = -Math.round((_width * _container.scaleX - _width) / 2);
			_container.y = -84;
			
			_container.filters = [_glowFilter];
			
		}
		
		override public function setMouseUp():void
		{
			draw(_color, false);
			_container.scaleX = _container.scaleY = 1.0;
			_container.x = _container.y = 0;
			_container.filters = [];
		}
		
		
		//	##################################################################################################################
		//	INTERFACE virgile.patterns.core.IDisposable
		
		/** @inheritDoc */
		override public function dispose(e:Event = null):void {
			enabled = false;
			
			_tf.dispose();
			
			_bg = null;
			_tf = null;
			
		}
		
		
		//	##################################################################################################################
		//	INTERFACE virgile.modules.virtualkeyboard.IKeyView
		
		/** @inheritDoc */
		override public function set label(label:String):void {
			//trace("_tf.text : " + label);
			if (_tf != null) _tf.text = label;
			
		}
		
		/** @inheritDoc */
		override public function dispEnabled():void{
			if (_tf != null) _tf.alpha = enabled ? 1 : .3;
		}
		
		/** @inheritDoc */
		/*
		override public function dispPress():void {
			TweenMax.to(_bg, 1.2, {
				ease: Circ.easeOut, immediateRender: true,
				alpha: 1,
				startAt: { alpha: .35 }
				});
		}
		*/
		
		//	########################################################################################################
		//	DIMENSION MANAGEMENT
		
		/** @inheritDoc */
		override public function get width():Number {
			return _width == _width ? _width : SIZE;
		}
		override public function set width(width:Number):void {
			_width = width;
			
			//trace("set width " + _width);
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(_color, _bgalpha);
			_bg.graphics.drawRoundRect(0, 0, _width, height, ROUND, ROUND);
			_bg.graphics.endFill();
			
			if (_tf != null) _tf.width = _width;
			else if (_spriteImg != null) {
				_spriteImg.x = .5 * (_width - _spriteImg.width);
			}
			
		}
		
		/** @inheritDoc */
		override public function get height():Number {
			return _height == _height ? _height : SIZE;
		}
		override public function set height(height:Number):void {
			_height = height;
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(_color, _bgalpha);
			_bg.graphics.drawRoundRect(0, 0, width, _height, ROUND, ROUND);
			_bg.graphics.endFill();
			
			if (_tf != null) _tf.y = .5 * (_height - _tf.textHeight) - 2.5;
			else if (_spriteImg != null) {
				_spriteImg.y = .5 * (_height - _spriteImg.height) - 2.5;
			}
			//_tf.y = height / 2 - _tf.textHeight / 2;
		}
		
		
		public function set fontsize(value:int):void 
		{
			_fontsize = value;
			_tf.fontsize = value;
		}
		
		
	}
}
