package data2.debug 
{
	/**
	 * ...
	 * @author 
	 */
	public class ASXMLTracer 
	{
		private var _value:String;
		
		
		public function ASXMLTracer() 
		{
			
		}
		
		public function get value():String 
		{
			return _value;
		}
		
		public function set value(value:String):void 
		{
			_value = value;
			trace("@trace " + value);
		}
		
	}

}