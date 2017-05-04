package data2.effects 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 */
	public class BGinEffect extends MEffect
	{
		
		public function BGinEffect() 
		{
			var _eff1:Effect = new FadeEffect();
			_eff1.amountpercent_start = 0.0;
			_eff1.amountpercent_end = 1.0;
			_eff1.time = 0.1;
			_eff1.subpath = "*bg";
			this.add(_eff1);
			
			_subtargets.push("bg");
			
		}
		
		
	}

}