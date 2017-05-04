package data2.effects 
{
	import fl.transitions.easing.Regular;
	/**
	 * ...
	 * @author 
	 */
	public class SlideEffect extends Effect
	{
		//props
		
		//direction
		//amountpx
		
		
		
		
		public function SlideEffect() 
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
			
			if (_direction == null) _direction = "right";
			if (isNaN(_amountpx_start)) _amountpx_start = -200;
			if (isNaN(_amountpx_end)) _amountpx_end = 0;
			
			var _angle:Number;
			if (_direction == "left") _angle = Math.PI;
			else if (_direction == "right") _angle = 0;
			else if (_direction == "top") _angle = -Math.PI/2;
			else if (_direction == "bottom") _angle = Math.PI/2;
			else if (_direction == "topleft") _angle = -Math.PI/2 -Math.PI/4;
			else if (_direction == "topright") _angle = -Math.PI / 4;
			else if (_direction == "bottomleft") _angle = Math.PI / 2 + Math.PI / 4;
			else if (_direction == "bottomright") _angle = Math.PI / 4;
			else _angle = Number(_direction * Math.PI / 180);
			
			
			var _startx:Number = Math.cos(_angle) * _amountpx_start;
			var _starty:Number = Math.sin(_angle) * _amountpx_start;
			var _endx:Number = Math.cos(_angle) * _amountpx_end;
			var _endy:Number = Math.sin(_angle) * _amountpx_end;
			
			//trace("_startx : " + _startx + ", _starty : " + _starty + ", _realtargetcoords : " + _realtarget.x + "," + _realtarget.y);
			
			addDef("x", _realtarget.x + _startx, _realtarget.x + _endx, __time, __delay, __effect);
			addDef("y", _realtarget.y + _starty, _realtarget.y + _endy, __time, __delay, __effect);
		}
	}

}