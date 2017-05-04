package data.layout.menu.menumac 
{
	import data.fx.transitions.TweenManager;
	import data.layout.menu.IMenuItem;
	import fl.transitions.TweenEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Vincent
	 */
	public class MenuMacItem extends Sprite
	{
		//_______________________________________________________________________________
		// properties
		
		private var _scaleMax:Number;
		private var _scaleMin:Number;
		private var _timeScale:Number;
		
		
		private var _isSelected:Boolean;
		private var twm:TweenManager = new TweenManager();
		
		
		
		
		//_______________________________________________________________________________
		// constructor
		
		public function MenuMacItem() 
		{
			
		}
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function select(_type:String):void 
		{
			_isSelected = true;
			
			twm.tween(this, "scaleX", NaN, _scaleMax, _timeScale);
			twm.tween(this, "scaleY", NaN, _scaleMax, _timeScale);
			twm.addTweenListener(onTweenEnterFrame, TweenEvent.MOTION_CHANGE);
			twm.addTweenListener(onTweenFinish, TweenEvent.MOTION_FINISH);
			this.dispatchEvent(new MenuMacEvent(MenuMacEvent.START_TWEEN));
			
		}
		
		
		
		public function unselect():void 
		{
			_isSelected = false;
			
			twm.tween(this, "scaleX", NaN, _scaleMin, _timeScale);
			twm.tween(this, "scaleY", NaN, _scaleMin, _timeScale);
			twm.addTweenListener(onTweenEnterFrame, TweenEvent.MOTION_CHANGE);
			twm.addTweenListener(onTweenFinish, TweenEvent.MOTION_FINISH);
			this.dispatchEvent(new MenuMacEvent(MenuMacEvent.START_TWEEN));
		}
		
		public function isSelected():Boolean
		{
			return _isSelected;
			
		}
		
		
		
		
		//_______________________________________________________________________________
		// getter / setter
		
		
		
		public function get timeScale():Number { return _timeScale; }
		
		public function set timeScale(value:Number):void 
		{
			_timeScale = value;
		}
		
		public function get scaleMin():Number { return _scaleMin; }
		
		public function set scaleMin(value:Number):void 
		{
			_scaleMin = value;
		}
		
		public function get scaleMax():Number { return _scaleMax; }
		
		public function set scaleMax(value:Number):void 
		{
			_scaleMax = value;
		}
		
		
		
		//_________________________________________________________
		
		
		
		
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		private function onTweenEnterFrame(e:TweenEvent):void
		{
			//trace("MenuMacItem.onTweenEnterFrame");
			this.dispatchEvent(new MenuMacEvent(MenuMacEvent.ENTER_TWEEN));
		}
		
		private function onTweenFinish(e:TweenEvent):void
		{
			//trace("MenuMacItem.onTweenFinish");
			this.dispatchEvent(new MenuMacEvent(MenuMacEvent.END_TWEEN));
		}
		
		
	}

}