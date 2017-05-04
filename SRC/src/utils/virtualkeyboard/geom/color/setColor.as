package utils.virtualkeyboard.geom.color
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	/**
	 * Apply a progressive tint on the passed-in color object
	 * @param	dispObj		display object to colorize
	 * @param	color		tint to be applied  (-1 for color reset)
	 * @param	ratio		ratio of tint application (value taken within range [0, 1])
	 */
	public function setColor(dispObj:DisplayObject, color:int = -1, ratio:Number = 1):void
	{
		var clrt:ColorTransform;
		var oldClrt:ColorTransform;
		var clrtRatio:Number;
		var redOff:Number;
		var greenOff:Number;
		var blueOff:Number;
		
		if (!dispObj)
			return;
		if (color >= 0) {
			oldClrt = dispObj.transform.colorTransform;
			clrtRatio = 1 - ratio,
			redOff = Math.round(ratio * ((color >> 16) & 0xFF)),
			greenOff = Math.round(ratio * ((color >> 8) & 0xFF )),
			blueOff = Math.round(ratio * (color & 0xFF));
			clrt = new ColorTransform(1 - ratio, 1 - ratio, 1 - ratio, oldClrt.alphaMultiplier, redOff, greenOff, blueOff, oldClrt.alphaOffset);
		}
		else if (color == -1){
			clrt = new ColorTransform();
		}
		dispObj.transform.colorTransform = clrt;
	}
	
	
}
