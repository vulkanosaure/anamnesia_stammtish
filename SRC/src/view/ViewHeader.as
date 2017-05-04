package view 
{
	import assets.Component_zone_meteo;
	import data2.asxml.ObjectSearch;
	import data2.mvc.ViewBase;
	import data2.text.Text;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import utils.Animation;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ViewHeader extends ViewBase
	{
		static private var _componentWeather:Component_zone_meteo;
		
		public function ViewHeader() 
		{
			
		}
		
		static public function selectLang(_lang:String):void 
		{
			for (var i:int = 0; i < DataGlobal.LIST_LANG.length; i++) 
			{
				var _l:String = DataGlobal.LIST_LANG[i];
				getSprite("btn_lang_" + _l).alpha = 0.4;
			}
			if (_lang != "") getSprite("btn_lang_" + _lang).alpha = 1.0;
		}
		
		
		
		public static function initIconWeather():void
		{
			_componentWeather = Component_zone_meteo(getID("component_zone_meteo"));
			_componentWeather.initComponent();
			
		}
		
		public static function setIconWeather(_id:String):void
		{
			_componentWeather.setIcon(_id);
		}
		
		static public function updateTime(currentTime:String):void 
		{
			getText("text_header_time").value = "<span class='MS500_15_FFFFFF'>" + currentTime + "</span>";
			getText("text_header_time").updateText();
		}
		
		static public function updateWeatherInfo(_data:Object):void 
		{
			var _textTemp:Text = getText("text_header_temp");
			_textTemp.value = "<span class='MS900_15_FFFFFF'><span style='text-align:right;'>" + _data.temp + "°c" + "</span></span>";
			_textTemp.updateText();
			
			_componentWeather.setIcon(_data.icon);
			
		}
		
		static public function bumpBtnLike():void 
		{
			Animation.bump(getSprite("btn_like_recap"));
		}
		
		
		
		static public function setBtnLikeNumber(_value:int):void
		{
			var _sp:Sprite = getSprite("btn_like_recap");
			var _iconlike:Icon_like_recap = Icon_like_recap(_sp.getChildAt(0));
			var _tf:TextField = _iconlike.getChildByName("_tf") as TextField;
			_tf.text = String(_value);
		}
		
		static public function setBtnLikeVisible(_value:Boolean):void 
		{
			getSprite("container_like_recap").visible = _value;
		}
		
		
		
	}

}