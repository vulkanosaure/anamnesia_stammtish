package data2.effects 
{
	/**
	 * ...
	 * @author 
	 */
	public class ToogleEffect extends MEffect
	{
		
		public function ToogleEffect() 
		{
			var _eff1:Effect = new FadeEffect();
			_eff1.amountpercent_start = 1.0;
			_eff1.amountpercent_end = 0.0;
			_eff1.time = 0.1;
			_eff1.subpath = "*unselected";
			
			var _eff2:Effect = new FadeEffect();
			_eff2.amountpercent_start = 0.0;
			_eff2.amountpercent_end = 1.0;
			_eff2.time = 0.1;
			_eff2.subpath = "*selected";
			
			this.add(_eff1);
			this.add(_eff2);
			
			_subtargets.push("unselected");
			_subtargets.push("selected");
		}
		
	}

}