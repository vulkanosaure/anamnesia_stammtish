package assets 
{
	import data2.mvc.Component;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Vinc
	 */
	public class Component_detail_img extends Component
	{
		
		public function Component_detail_img() 
		{
			initComponent();
		}
		
		override public function initComponent():void 
		{
			super.initComponent();
			
			_bmp = new Bitmap();
			_bmp.smoothing = true;
			addChild(_bmp);
			
			
		}
		
	}

}