package view 
{
	import assets.menu2.Component_menu2;
	import data2.mvc.ViewBase;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ViewMenu2 extends ViewBase
	{
		static private var _component:Component_menu2;
		static private var _tabtexts:Array;
		static private var _tabindex:Array;
		
		public function ViewMenu2() 
		{
			
		}
		
		
		public static function init():void
		{
			
			_component = new Component_menu2();
			_component.initComponent();
			
			var _container:Sprite = getSprite("component_menu2_container");
			_container.addChild(_component);
			
			
			
		}
		
		
		
		public static function updateContent(_tab:Array):void
		{
			if (_tabtexts == null) _tabtexts = new Array();
			if (_tabindex == null) _tabindex = new Array();
			_tabtexts.splice(0);
			_tabindex.splice(0);
			
			var _len:int = _tab.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _obj:Object = _tab[i];
				_tabtexts.push(_obj["text"]);
				_tabindex.push(_obj["indexxml"]);
			}
			trace("_tabtexts : " + _tabtexts);
			trace("_tabindex : " + _tabindex);
			
			_component.updateComponent(_tabtexts, _tabindex);
		}
		
		
		
		public static function getTitle(_index:int):String
		{
			var _str:String = _component.getTitle(_index);
			_str = removeBR(_str);
			return _str;
		}
		static public function getTitleMain():String 
		{
			var _str:String = _component.getTitleMain();
			_str = removeBR(_str);
			return _str;
		}
		
		static private function removeBR(str:String):String 
		{
			return str.replace(/<br \/>/g, " ");
		}
		
		
		public static function hideAll():void 
		{
			_component.hideAll();
		}
		
		
		public static function playDiapo(_value:Boolean):void
		{
			trace("ViewMenu2.playDiapo(" + _value + ")");
			if (_value) _component.play();
			else _component.stop();
			
		}
		
		static public function getRealIndex(_index:int):int 
		{
			return _component.getRealIndex(_index);
		}
		
		
		
	}

}