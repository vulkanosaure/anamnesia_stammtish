package data2.effects 
{
	/**
	 * ...
	 * @author 
	 */
	public class SlideFadeEffect extends MEffect
	{
		var _slideEffect:SlideEffect;
		var _fadeEffect:FadeEffect;
		
		public function SlideFadeEffect() 
		{
			_slideEffect = new SlideEffect();
			_fadeEffect = new FadeEffect();
			
			this.add(_slideEffect);
			this.add(_fadeEffect);
		}
		
		
		
		override public function set direction(value:*):void 
		{
			_slideEffect.direction = value;
		}
		
		
		override public function set amountpx_start(value:Number):void 
		{
			_slideEffect.amountpx_start = value;
		}
		override public function set amountpx_end(value:Number):void 
		{
			_slideEffect.amountpx_end = value;
		}
	}

}