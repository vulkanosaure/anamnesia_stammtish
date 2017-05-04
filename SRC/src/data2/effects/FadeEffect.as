package data2.effects
{
	import fl.transitions.easing.Regular;
	
	/**
	 * ...
	 * @author
	 */
	public class FadeEffect extends Effect
	{
		//props
		
		//
		
		public function FadeEffect()
		{
		
		}
		
		override public function init():void
		{
			//trace("ZoomEffect.init");
			reset();
			
			
			//property personalisable)
			var __zoomlvlstart:Number = (isNaN(_amountpercent_start)) ? 0.0 : _amountpercent_start;
			var __zoomlvlend:Number = (isNaN(_amountpercent_end)) ? 1.0 : _amountpercent_end;
			
			//property global (non personalisable selon extension)
			var __time:Number = 0.4;
			var __delay:Number = 0.0;
			var __effect:Function = Regular.easeOut;
			
			addDef("alpha", __zoomlvlstart, __zoomlvlend, __time, __delay);
		}
	}

}