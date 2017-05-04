package data2.states.navigation 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vincent
	 */
	public class NavigationEvent extends Event 
	{
		public static const LINK:String = "link";
		public static const UPDATE_LINK:String = "updateLink";
		public static const NAVIGATE:String = "navigate";
		public static const AFTER_ADDRESS_CHANGE:String = "afterAddressChange";
		
		private var _idlink:int;
		public var idrubric:int;
		
		public function NavigationEvent(type:String, __idlink:int) 
		{ 
			super(type, bubbles, cancelable);
			_idlink = __idlink;
		} 
		
		public override function clone():Event 
		{ 
			return new NavigationEvent(type, _idlink);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("NavigationEvent", "type", "idlink"); 
		}
		
		
		public function get idlink():int { return _idlink; }
		
	}
	
}