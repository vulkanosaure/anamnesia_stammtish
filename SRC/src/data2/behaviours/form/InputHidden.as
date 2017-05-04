package data2.behaviours.form 
{
	/**
	 * ...
	 * @author 
	 */
	public class InputHidden extends Input
	{
		private var _value:String;
		
		public function InputHidden() 
		{
			
		}
		
		public function get value():String 
		{
			return _value;
		}
		
		public function set value(value:String):void 
		{
			_value = value;
		}
		
	}

}