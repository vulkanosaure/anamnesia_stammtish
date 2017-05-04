package data2.behaviours.form 
{
	/**
	 * ...
	 * @author 
	 */
	public class OutputDef 
	{
		public static const TYPE_TEXT:String = "text";
		public static const TYPE_CHECKBOX:String = "checkbox";
		public static const TYPE_UPLOAD:String = "upload";
		public static const TYPE_SERVER:String = "server";
		
		public static const STATUS_REQUIRED:String = "required";
		public static const STATUS_FORMAT:String = "format";
		public static const STATUS_UPLOADING:String = "uploading";
		public static const STATUS_INIT:String = "init";
		
		
		
		
		private var _msg:String;
		private var _type:String;
		private var _status:String;
		private var _name:String;
		
		
		
		public function OutputDef() 
		{
			
		}
		
		
		public function toString():String
		{
			var _str:String = "";
			_str += "OutputDef ";
			_str += "type : " + _type + ", ";
			_str += "status : " + _status + ", ";
			if (_name != null) _str += "name : " + _name + ", ";
			if (_msg != null) _str += "msg : " + _msg + ", ";
			return _str;
		}
		
		
		
		
		
		
		
		
		
		//______________________________________________________________
		//inputs
		
		public function get msg():String {return _msg;}
		
		public function set msg(value:String):void {_msg = value;}
		
		public function get type():String {return _type;}
		
		public function set type(value:String):void {_type = value;}
		
		public function get status():String {return _status;}
		
		public function set status(value:String):void {_status = value;}
		
		public function get name():String {return _name;}
		
		public function set name(value:String):void {_name = value;}
		
	}

}