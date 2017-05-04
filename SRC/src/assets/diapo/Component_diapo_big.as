package assets.diapo 
{
	import data.fx.transitions.SpriteTransitioner;
	import data.layout.slider.ItemSlider;
	import data2.asxml.Constantes;
	import data2.InterfaceSprite;
	import data2.net.imageloader.ImageLoader;
	import fl.transitions.easing.Regular;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Vinc
	 */
	public class Component_diapo_big extends InterfaceSprite
	{
		
		private var _listurl:Array;
		private var _timer:Timer;
		private var _slider:SpriteTransitioner;
		private var _id:String;
		
		public function Component_diapo_big() 
		{
			
		}
		public function initComponent(_autoplay:Boolean = false, _delayTimer:Number = NaN, _loadgroup:Boolean = true):void
		{
			
			_slider = new SpriteTransitioner();
			
			_slider.effect_in = Regular.easeOut;
			_slider.effect_in = Regular.easeOut;
			_slider.addTween("in", "alpha", 0, 1, 2.3);
			_slider.addTween("out", "alpha", 1, 0, 2.3);
			
			this.addChild(_slider);
			
			trace("Component_diapo_big.initComponent");
			
			var _group:String = "";
			
			for (var i:int = 0; i < _listurl.length; i++) 
			{
				var _item:Component_diapoMenuItem = new Component_diapoMenuItem();
				_item.urlimg = _listurl[i];
				_item.group = _group;
				_item.initComponent();
				_item.updateComponent();
				_slider.addChild(_item);
				
			}
			
			
			
			//_slider.init(0);
			
			
			if (_autoplay) {
				_timer = new Timer(_delayTimer * 1000);
				_timer.addEventListener(TimerEvent.TIMER, onTimer);
				_timer.start();
				onTimer(null);
			}
			
			
			
		}
		
		public function initDiapo(_index:int):void
		{
			_slider.init(_index);
		}
		
		
		public function play():void
		{
			_timer.reset();
			_timer.start();
			
		}
		public function pause():void
		{
			_timer.stop();
		}
		
		
		private function onTimer(e:TimerEvent):void 
		{
			//trace("timerslide");
			next();
		}
		
		public function next():void
		{
			_slider.next();
		}
		
		public function set listurl(value:Array):void 
		{
			_listurl = value;
		}
		
		public function set iddiapo(value:String):void 
		{
			_id = value;
		}
		
	}

}