package assets.diapo 
{
	import data.display.FilledRectangle;
	import data2.mvc.Component;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Vinc
	 */
	public class Component_diapoMenuItem extends Component
	{
		
		public function Component_diapoMenuItem() 
		{
			
		}
		
		override public function initComponent():void 
		{
			super.initComponent();
			
			_bmp = new Bitmap();
			this.addChild(_bmp);
			/*
			var _bgtest:FilledRectangle = new FilledRectangle(0xff0000);
			_bgtest.width = 400;
			_bgtest.height = 150;
			*/
		}
		
	}

}