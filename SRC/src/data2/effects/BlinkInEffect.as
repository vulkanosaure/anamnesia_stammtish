package data2.effects 
{
	import data2.effects.Effect;
	import fl.transitions.easing.None;
	import fl.transitions.easing.Regular;
	/**
	 * ...
	 * @author 
	 */
	public class BlinkInEffect extends Effect
	{
		//props
		
		//direction
		//amountpx
		
		private var _blink:Number;
		
		
		public function BlinkInEffect() 
		{
			_blink = 0;
		}
		
		
		
		
		override public function init():void
		{
			//trace("BlinkOutEffect.init");
			reset();
			
			//property global (non personalisable selon extension)
			var __time:Number = 3.0;
			
			addDef("blink", 19, 0, __time, 0, Regular.easeIn, true);
			addDef("alpha", 0.5, 1.0, __time, 0, None.easeNone);
		}
		
		
		
		
		public function get blink():Number 
		{
			return _blink;
		}
		
		public function set blink(value:Number):void 
		{
			_blink = value;
			var _visible:Boolean = (Math.round(value) % 2 == 0);
			_realtarget.visible = _visible;
			
		}
	}

}