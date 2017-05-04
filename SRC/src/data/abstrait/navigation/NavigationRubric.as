package data.abstrait.navigation 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Vincent
	 */
	public class NavigationRubric extends Sprite
	{
		//_______________________________________________________________________________
		// properties
		
		private var _idnavigation:String;
		private var _idint:int;
		private var _idparent:String;
		private var _title:String;
		private var _sprite:Sprite;
		private var _flagdefault:Boolean;
		private var _navigable:Boolean;
		
		private var _firstDisplay:Boolean;
		
		
		public function NavigationRubric() 
		{
			
		}
		
		//_______________________________________________________________________________
		// public functions
		
		
		public function setNavigationParams(__idnavigation:String, __idint:int, __sprite:Sprite, __idparent:String, __title:String, __flagdefault:Boolean, __navigable:Boolean):void
		{
			_firstDisplay = false;
			
			_idnavigation = __idnavigation;
			_idint = __idint;
			_sprite = __sprite;
			_idparent = __idparent;
			_title = __title;
			_flagdefault = __flagdefault;
			_navigable = __navigable;
		}
		
		
		//_______________________________________________________________________________
		// getters
		
		public function get idnavigation():String { return _idnavigation; }
		
		public function get idint():int { return _idint; }
		
		public function get sprite():Sprite { return _sprite; }
		
		public function get idparent():String { return _idparent; }
		
		public function get title():String { return _title; }
		
		public function get flagdefault():Boolean { return _flagdefault; }
		
		public function get navigable():Boolean { return _navigable; }
		
		
		//___________________________
		public function get firstDisplay():Boolean { return _firstDisplay; }
		
		public function set firstDisplay(value:Boolean):void 
		{
			_firstDisplay = value;
		}
		
		override public function toString():String 
		{
			return "NavigationRubric, idnavigation:"+idnavigation+", idint:"+idint+", sprite:"+sprite+", idparent:"+idparent+", flagdefault:"+flagdefault+", navigable:"+navigable+", firstDisplay:"+firstDisplay;
		}
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}