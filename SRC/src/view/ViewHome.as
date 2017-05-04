package view 
{
	import assets.diapo.Component_diapo_big;
	import data2.display.ClickableSprite;
	import data2.InterfaceSprite;
	import data2.mvc.ViewBase;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import utils.VideoBox;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ViewHome extends ViewBase
	{
		static private var _video:VideoBox;
		static private var _diapo:Component_diapo_big;
		static private var _playDiapo:Boolean = true;
		
		public function ViewHome() 
		{
			
		}
		
		public static function selectLang(_lang:String):void
		{
			for (var i:int = 0; i < DataGlobal.LIST_LANG.length; i++) 
			{
				var _l:String = DataGlobal.LIST_LANG[i];
				getSprite("btn_home_" + _l).alpha = 0.4;
			}
			if (_lang != "") getSprite("btn_home_" + _lang).alpha = 1.0;
			
		}
		
		
		
		
		
		
		
		
		static public function initBackground():void
		{
			_diapo = new Component_diapo_big();
			_diapo.iddiapo = "";
			_diapo.listurl = ["images/bg/bg0.jpg", "images/bg/bg1.jpg", "images/bg/bg2.jpg"];
			_diapo.initComponent(false, NaN, false);
			
			var _container:Sprite = getSprite("bg_home_diapo");
			_container.addChild(_diapo);
			
			if (DataGlobal.DEBUG_MODE) {
				var _timer:Timer = new Timer(2000);
				_timer.addEventListener(TimerEvent.TIMER, onTimerDebug);
				_timer.start();
			}
			
		}
		
		static private function onTimerDebug(e:TimerEvent):void 
		{
			runDiapo();
		}
		
		
		static public function playDiapo(_value:Boolean):void
		{
			_playDiapo = _value;
		}
		
		
		
		
		public static function setOverlayBG(_transparent:Boolean):void
		{
			getSprite("asset_overlay_bg_transparent").visible = _transparent;
			getSprite("asset_overlay_bg_color").visible = !_transparent;
		}
		
		
		public static function setBackgroundIndex(_id:String):void
		{
			var _index:int = (_id == "a") ? 0 : 1;
			_diapo.initDiapo(_index);
		}
		
		static public function runDiapo():void 
		{
			if (_playDiapo) {
				_diapo.next();
			}
			
		}
		
		static public function setItemVisible(_id:String, _value:Boolean):void 
		{
			getSprite(_id).visible = _value;
		}
		
		static public function setItemPosition(_id:String, _x:Number, _y:Number):void 
		{
			var _sprite:Sprite = getSprite(_id);
			_sprite.x = _x;
			_sprite.y = _y;
		}
		
		static public function setZoneClickable(_id:String, _cm:Number):void 
		{
			var _is:InterfaceSprite = getISprite(_id);
			_is.clickableMargin = _cm;
			_is.cm_vert = NaN;
			_is.cm_left = NaN;
			_is.cm_right = NaN;
			ClickableSprite.updateClickable(_is);
		}
		
		
		
	}

}