package assets
{
	import data2.asxml.ObjectSearch;
	import data2.InterfaceSprite
	import data2.text.Text
	import flash.display.DisplayObject;
	import flash.display.Sprite
	import flash.utils.getDefinitionByName;
	
	public class Component_zone_meteo extends InterfaceSprite
	{
		private var _containerIcon:Sprite;
		public function Component_zone_meteo()
		{
			
		}
		
		public function initComponent():void
		{
			var _text0:Text = new Text();
			this.addChild(_text0);
			_text0.x = -17; _text0.y = 25;
			_text0.width = 150;
			_text0.embedFonts = true;
			_text0.value = "";
			ObjectSearch.registerID(_text0, "text_header_day", false);
			
			
			var _textTemp:Text = new Text();
			this.addChild(_textTemp);
			_textTemp.x = -17; _textTemp.y = 43; 
			_textTemp.width = 150;
			_textTemp.embedFonts = true;
			_textTemp.value = "";
			ObjectSearch.registerID(_textTemp, "text_header_temp", false);
			
			//500,900
			
			var _text1:Text = new Text();
			this.addChild(_text1);
			_text1.x = 219; _text1.y = 26; 
			_text1.width = 150;
			_text1.embedFonts = true;
			_text1.value = "";
			ObjectSearch.registerID(_text1, "text_header_time", false);
			
			
			
			
			//_________________________________
			
			_containerIcon = new Sprite();
			this.addChild(_containerIcon);
			_containerIcon.x = 175; _containerIcon.y = 40;
			
			
			for (var name:String in DataGlobal.LIST_ICON_WEATHER) 
			{
				var _code:String = DataGlobal.LIST_ICON_WEATHER[name];
				var _libname:String = "asset_weather_" + _code;
				var _class:Class = getDefinitionByName(_libname) as Class;
				var _sp:Sprite = new _class() as Sprite;
				_containerIcon.addChild(_sp);
				_sp.name = _code;
				
			}
			
			
			
		}
		
		
		public function setIcon(_code:String):void
		{
			var _nbchild:int = _containerIcon.numChildren;
			for (var i:int = 0; i < _nbchild; i++) 
			{
				var _child:DisplayObject = _containerIcon.getChildAt(i);
				_child.visible = false;
			}
			_containerIcon.getChildByName(_code).visible = true;
		}
		
	}
	
}

