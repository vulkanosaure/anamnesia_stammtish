package utils.virtualkeyboard.geom.color
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	public function getColor(dispObj:DisplayObject, includeAlpha:Boolean = false):Number {
		if(includeAlpha)
			return parseInt('0x' + (dispObj.alpha * 0xff).toString(16) + dispObj.transform.colorTransform.color.toString(16));
		return parseInt('0x' + dispObj.transform.colorTransform.color.toString(16));
	}
}
