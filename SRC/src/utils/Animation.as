package utils 
{
	import data.fx.transitions.TweenManager;
	import fl.transitions.easing.Regular;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Vinc
	 */
	public class Animation 
	{
		private static var _twm:TweenManager = new TweenManager();
		
		public function Animation() 
		{
			throw new Error("is static");
		}
		
		
		public static function bump(_sp:DisplayObject):void 
		{
			
			var _end:Number = 1.2;
			
			var _time1:Number = 0.15;
			var _time2:Number = 0.15;
			
			_twm.tween(_sp, "scaleX", 1, _end, _time1, 0.0, Regular.easeOut);
			_twm.tween(_sp, "scaleY", 1, _end, _time1, 0.0, Regular.easeOut);
			
			_twm.tween(_sp, "scaleX", _end, 1, _time2, _time1, Regular.easeIn);
			_twm.tween(_sp, "scaleY", _end, 1, _time2, _time1, Regular.easeIn);
		}
		
		
	}

}