package view 
{
	import data2.mvc.ViewBase;
	import fl.transitions.easing.None;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ViewTest extends ViewBase
	{
		
		public function ViewTest() 
		{
			
		}
		
		
		public static function test():void
		{
			var _sp:Sprite = getSprite("zone_center");
			
			_sp.alpha = 0;
			_twm.tween(_sp, "alpha", 0, 1, 0.7, 0.3, None.easeNone);
		}
		
	}

}