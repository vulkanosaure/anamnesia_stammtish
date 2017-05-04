package utils.virtualkeyboard
{
	import flash.events.Event;
	
	public class VirtualKeyboardEvent extends Event
	{
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		//	CLASS MEMBERS
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		/** defines a type value for an input event */
		public static const INPUT:String = 'input';
		
		/** defines a type value for a status events */
		public static const STATUS:String = 'status';
		
		
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		//	INSTANCE MEMBERS
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		private var _charCode:int;
		
		/**
		 *	Constructor
		 * @param	type			event type
		 * @param	charCode		linked keyboard charcode
		 */
		public function VirtualKeyboardEvent(type:String, charCode:int = -1){
			super(type);
			_charCode = charCode;
		}
		
		/** linked keyboard charcode */
		public function get charCode():int {
			return _charCode;
		}
	}
}
