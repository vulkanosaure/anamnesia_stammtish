package color 
{
	import assets.Component_item_scroll;
	import data.utils.ColorTransformation;
	import data2.asxml.ObjectSearch;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Vinc
	 */
	public class InterfaceColor 
	{
		
		public function InterfaceColor() 
		{
			
		}
		
		//public static function applyColor(_color:uint, __colorlight:uint = 0):void
		public static function applyColor(_tabcolors:Array):void
		{
			var _color:uint = _tabcolors[0];
			
			var _colorlight:uint;
			if (_tabcolors.length > 1) _colorlight = _tabcolors[1];
			else _colorlight = ColorTransformation.setTransformColor(_color, [1.0875, 1.1492, 1.0937]);
			
			
			//global
			applyColor_single("asset_overlay_bg_color", _color);
			applyColor_single("asset_overlay_bg_color_permanent", _color);
			
			//menu
			applyColor_single("asset_overlay_btn_menu_escapade", _colorlight);
			applyColor_single("asset_overlay_btn_submenu0", _colorlight);
			applyColor_single("asset_overlay_btn_submenu1", _colorlight);
			applyColor_single("asset_overlay_btn_submenu2", _colorlight);
			applyColor_single("asset_overlay_btn_menu_small1", _colorlight);
			applyColor_single("asset_overlay_btn_menu_small2", _colorlight);
			applyColor_single("asset_overlay_btn_menu_emb", _colorlight);
			
			applyColor_single("asset_menu_bottom", _color);
			applyColor_single("asset_btn_territoire", _colorlight);
			applyColor_single("asset_btn_incontournables", _color);
			applyColor_single("asset_btn_checkout", _colorlight);
			applyColor_single("asset_btn_checkout_0", _colorlight);
			//applyColor_single("asset_btn_checkout_1", _colorlight);
			applyColor_single("asset_btn_checkout_2", _colorlight);
			//applyColor_single("asset_btn_checkout_3", _colorlight);
			applyColor_single("asset_btn_actualites", _color);
			
			//screen main
			//applyColor_multiple("scroll_main_content", "bg", _colorlight);
			applyColor_single("asset_bg_alpha_right", _colorlight);
			applyColor_single("asset_bg_footer", _color);
			applyColor_multiple("scroll_main", "track", _colorlight);
			applyColor_multiple("scroll_zone_list_actu", "track", _color);
			applyColor_single("asset_overlay_scrollbar", _color);
			
			//screen main detail
			applyColor_multiple("scroll_detail", "track", _color);
			applyColor_single("asset_detail_bg", _colorlight);
			applyColor_single("asset_bg_detail_side", _color);
			applyColor_single("asset_bg_btn_close_detail", _colorlight);
			applyColor_single("asset_detail_shadow", _color);
			
			//screen enter mail
			applyColor_single("asset_bg_keyboard", _colorlight);
			applyColor_single("asset_bg_keyboard_filter", _colorlight);
			
			
		}
		
		
		static public function applyColor_tab(_tabcolors:Array, _list:Vector.<Sprite>):void 
		{
			var _color:uint = _tabcolors[0];
			
			var _colorlight:uint;
			if (_tabcolors.length > 1) _colorlight = _tabcolors[1];
			else _colorlight = ColorTransformation.setTransformColor(_color, [1.0875, 1.1492, 1.0937]);
			
			var _len:int = _list.length;
			for (var i:int = 0; i < _len; i++) 
			{
				applyColor_object(_list[i], _colorlight);
			}
		}
		
		static private function applyColor_multiple(_idcontainer:String, _name:String, _color:uint):void 
		{
			var _container:Sprite = Sprite(ObjectSearch.getID(_idcontainer));
			var _list:Array = ObjectSearch.getName(_container, _name);
			
			for (var name:String in _list) 
			{
				var _item:DisplayObject = DisplayObject(_list[name]);
				applyColor_object(_item, _color);
			}
			
		}
		
		static private function applyColor_single(_iditem:String, _color:uint):void 
		{
			var _sp:Sprite = Sprite(ObjectSearch.getID(_iditem));
			applyColor_object(_sp, _color);
			
		}
		
		static public function applyColor_object(_object:DisplayObject, _color:uint):void
		{
			var myColorTransform = new ColorTransform();
			myColorTransform.color = _color;
			_object.transform.colorTransform = myColorTransform;
		}
		
	}

}