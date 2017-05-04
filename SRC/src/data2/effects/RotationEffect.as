package data2.effects 
{
	import fl.transitions.easing.Regular;
	/**
	 * ...
	 * @author 
	 */
	public class RotationEffect extends Effect
	{
		
		public function RotationEffect() 
		{
			
		}
		
		
		
		override public function init():void
		{
			//trace("ZoomEffect.init");
			reset();
			
			//property global (non personalisable selon extension)
			var __time:Number = 0.4;
			var __delay:Number = 0.0;
			var __effect:Function = Regular.easeOut;
			
			if (isNaN(_amountRotation)) _amountRotation = 20;
			if (_sensRotation == null) _sensRotation = Effect.SENS_CLOCK;
			
			var _endrotation:Number;
			if (_sensRotation == Effect.SENS_CLOCK) _endrotation = _realtarget.rotation + _amountRotation;
			else _endrotation = _realtarget.rotation - _amountRotation;
			
			addDef("rotation", _realtarget.rotation, _endrotation, __time, __delay, __effect);
		}
		
	}

}