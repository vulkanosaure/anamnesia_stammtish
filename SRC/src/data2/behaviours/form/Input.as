package data2.behaviours.form 
{
	import data2.behaviours.BehaviourChild;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author 
	 */
	public class Input extends BehaviourChild
	{
		private var _name:String;
		private var _tab_index:int;
		private var _defined:Boolean;
		
		
		
		public function Input() 
		{
			_defined = false;
		}
		
		public function reset():void 
		{
			
		}
		
		
		
		
		
		
		//________________________________________________________
		//set / get
		
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		
		
		public function set tab_index(value:int):void 
		{
			_tab_index = value;
		}
		
		public function get tab_index():int {return _tab_index;}
		
		public function get defined():Boolean 
		{
			return _defined;
		}
		
		public function set defined(value:Boolean):void 
		{
			_defined = value;
		}
		
	}

}