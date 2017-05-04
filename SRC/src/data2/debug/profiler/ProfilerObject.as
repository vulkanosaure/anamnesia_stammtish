package data2.debug.profiler 
{
	/**
	 * ...
	 * @author vinc
	 */
	public class ProfilerObject 
	{
		private var _group:String;
		private var _id:String;
		private var _time:Number;
		
		public function ProfilerObject(__group:String, __id:String) 
		{
			_group = __group;
			_id = __id;
			_time = 0;
		}
		
		public function get time():Number 
		{
			return _time;
		}
		
		public function set time(value:Number):void 
		{
			_time = value;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		public function get group():String 
		{
			return _group;
		}
		
		
		
		
		
	}

}