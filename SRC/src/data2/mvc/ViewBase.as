package data2.mvc 
{
	import data.fx.transitions.TweenManager;
	import data2.asxml.ObjectSearch;
	import data2.display.scrollbar.Scrollbar;
	import data2.InterfaceSprite;
	import data2.text.Text;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ViewBase 
	{
		protected static var _twm:TweenManager = new TweenManager();
		
		public function ViewBase() 
		{
			
		}
		
		
		protected static function getID(_id:String):Object
		{
			return ObjectSearch.getID(_id);
		}
		
		protected static function getSprite(_id:String):Sprite
		{
			return Sprite(ObjectSearch.getID(_id));
		}
		protected static function getISprite(_id:String):InterfaceSprite
		{
			return InterfaceSprite(ObjectSearch.getID(_id));
		}
		protected static function getScrollbar(_id:String):Scrollbar
		{
			return Scrollbar(ObjectSearch.getID(_id));
		}
		protected static function getText(_id:String):Text
		{
			return Text(ObjectSearch.getID(_id));
		}
		
		
	}

}