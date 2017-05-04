package data.filters 
{
	/**
	 * ...
	 * @author Vincent
	 */
	 
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.utils.ByteArray;

	public class UtilsFilter extends ShaderFilter
	{
		//_______________________________________________________________________________
		// properties
		
		[Embed("pixelbender/UtilsFilter.pbj", mimeType="application/octet-stream")]
		private var Filter:Class;
		private var _shader:Shader;
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function UtilsFilter()
		{
			//initialize the ShaderFilter with the PixelBender filter we
			//embedded
			_shader = new Shader(new Filter() as ByteArray);
			super(_shader);
		}
		
		
		public function get luminosity():Number
		{
			return _shader.data.luminosity.value[0];
		}
		
		public function set luminosity(value:Number):void 
		{
			_shader.data.luminosity.value = [value];
		}
		
		public function get contrast():Number
		{
			return _shader.data.contrast.value[0];
		}
		
		public function set contrast(value:Number):void 
		{
			_shader.data.contrast.value = [value];
		}
		
		
		public function get saturation():Number
		{
			return _shader.data.saturation.value[0];
		}
		
		public function set saturation(value:Number):void 
		{
			_shader.data.saturation.value = [value];
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}