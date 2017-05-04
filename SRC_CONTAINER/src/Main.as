package 
{
	import data.display.FilledRectangle;
	import data.fx.transitions.DelayManager;
	import data.math.Math2;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Vinc
	 */
	public class Main extends Sprite 
	{
		private const SCREEN_SIZE:Point = new Point(1920, 1080);
		private const SWF_SIZE:Point = new Point(1265, 883);
		//private const ANGLE_BASE:Number = 59.5;
		private const ANGLE_BASE:Number = 59;
		private var _loaderA:Loader;
		private var _loaderB:Loader;
		
		
		public const LIST_COLORS:Array = [
			[0x0094b6],						//blue
			[0x3b8e7b],						//turquoise
			[0xffc200, 0xf8b700],			//jaune
			[0x8ab11e],						//vert
			[0x504380],						//violet
		
		];
		
		public var data_a:Object = null;
		public var data_b:Object = null;
		
		
		public function Main():void 
		{
			XMLLoader.init(onXMLFinished);
			
			
		}
		
		private function onXMLFinished():void 
		{
			
			setData("a");
			setData("b");
			displayData();
			
			
			//stage.quality = StageQuality.LOW;
			
			
			_loaderA = loadSWF( -ANGLE_BASE, new Point(SCREEN_SIZE.x - SWF_SIZE.x + 24 - 36, SCREEN_SIZE.y - 3 + 0), "a");
			
			_loaderB = loadSWF(180 - ANGLE_BASE, new Point(SWF_SIZE.x - 24 + 45, +3 - 3), "b");
			
			
			/*
			var _rect:FilledRectangle = new FilledRectangle(0xFF0000);
			_rect.width = 2;
			_rect.height = 1200;
			this.addChild(_rect);
			_rect.x = 1280;
			*/
			
			
			var _timerDiapo:Timer = new Timer(5000);
			_timerDiapo.addEventListener(TimerEvent.TIMER, onTimerDiapo);
			_timerDiapo.start();
			
		}
		
		
		
		
		private function onTimerDiapo(e:TimerEvent):void 
		{
			trace("Main.onTimerDiapo");
			_loaderA.content["runDiapo"]();
			_loaderB.content["runDiapo"]();
			
		}
		
		
		
		
		public function onBackToHome(_id:String):void
		{
			trace("onBackToHome " + _id);
			setData(_id);
			displayData();
			
			var _loader:Loader = (_id == "a") ? _loaderA : _loaderB;
			_loader.content["updateData"]();
		}
		
		private function displayData():void 
		{
			trace("color a : " + data_a.colors);
			trace("color b : " + data_b.colors);
		}
		
		
		
		private function setData(_id:String):void 
		{
			var _nbcolor:int = LIST_COLORS.length;
			var _tabcolor:Array;
			var _id2:String = (_id == "a") ? "b" : "a";
			var _data2:Object = this["data_" + _id2];
			
			while (true) {
				var _rand:int = Math2.random(0, _nbcolor - 1);
				_tabcolor = LIST_COLORS[_rand];
				
				if (_data2 == null) break;
				var _color2:uint = _data2.colors[0];
				if (_color2 != _tabcolor[0]) break;
				
			}
			
			
			var _bghometransparent:Boolean = false;
			if (_data2 == null) _bghometransparent = (Math2.random(0, 1, 1) == 0);
			else {
				var _transparent2:Boolean = _data2.bghometransparent;
				_bghometransparent = !_transparent2;
			}
			
			var _obj:Object = new Object();
			_obj.colors = _tabcolor;
			_obj.bghometransparent = _bghometransparent;
			this["data_" + _id] = _obj;
			
		}
		
		
		private function loadSWF(_angle:Number, _position:Point, _param:String):Loader 
		{
			
			var _loader:Loader = new Loader();
			this.addChild(_loader);
			_loader.rotation = _angle;
			_loader.x = _position.x;
			_loader.y = _position.y;
			
			var context:LoaderContext = new LoaderContext();
			context.parameters = {'param': String(_param)};
			_loader.load(new URLRequest("BORNESTAMMTISCH.swf"), context);
			return _loader;
		}
		
		
		
		
		
	}
	
}