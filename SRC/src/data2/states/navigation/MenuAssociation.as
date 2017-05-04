package data2.states.navigation
{
	import data2.behaviours.menu.Menu;
	
	/**
	 * ...
	 * @author
	 */
	public class MenuAssociation
	{
		private var _menu:Menu;
		private var _index:int;
		private var _stateparent:String;
		private var _state:String;
		
		public function MenuAssociation(__menu:Menu, __index:int, __stateparent:String, __state:String)
		{
			_menu = __menu;
			_index = __index;
			_stateparent = __stateparent;
			_state = __state;
			
		}
		
		public function get menu():Menu {return _menu;}
		
		public function get index():int {return _index;}
		
		public function get stateparent():String {return _stateparent;}
		
		public function get state():String {return _state;}
	
	}

}