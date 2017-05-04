package data.net {
	
	
	import flash.events.Event;
	public class SWFLoaderEvent extends Event{
		
		//params
		public static const SEND_VARS:String = "SWFLoaderEvent_sendVars";
		public static const COMPLETE:String = "SWFLoaderEvent_complete";
		
		//private vars
		public var vars:Object;
		
		
		//_______________________________________________________________
		//public functions
		
		public function SWFLoaderEvent(type:String, _vars:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			vars = _vars;
		}
		
		
		public override function toString():String
		{
			var str:String = super.toString();
			str += "\n[";
			for(var i:* in vars) str += i+":"+vars[i]+", ";
			str += "]";
			return str;
		}
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
		
	}
	
}