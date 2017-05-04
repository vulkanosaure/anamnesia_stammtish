package view 
{
	import color.InterfaceColor;
	import data2.mvc.ViewBase;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ViewGlobal extends ViewBase
	{
		
		public function ViewGlobal() 
		{
			
		}
		
		static public function updateData():void 
		{
			
			var _colors:Array= [0x8ab11e];
			var _bghometransparent:Boolean = true;
			
			var _mainContainer:DisplayObjectContainer = DataGlobal.container.parent.parent;
			if (_mainContainer != null) {
				var _data:Object = _mainContainer["data_" + DataGlobal.id];
				_colors = _data.colors;
				_bghometransparent = _data.bghometransparent;
			}
			
			DataGlobal.save_colors = _colors;
			
			InterfaceColor.applyColor(_colors);
			ViewHome.setOverlayBG(_bghometransparent);
			
		}
		
		static public function setVisible(_id:String, _value:Boolean):void 
		{
			getSprite(_id).visible = _value;
		}
		
	}

}