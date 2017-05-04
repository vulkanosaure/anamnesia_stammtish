package utils.virtualkeyboard {
	
	
	public interface IKeyView extends IDisposable {
		
		/** Handles keyboard status events */
		function renderStatus(e:VirtualKeyboardEvent):void;
		
		function reset(charCode:int = -1, asLetter:Boolean = true, asNumber:Boolean = true, asEmail:Boolean = true, customLabel:String = null):void;
		
		/** linked key charcode */
		function get charCode():int;
		
		function set label(label:String):void;
		function get label():String;
		
		function dispEnabled():void;
		
		function dispPress():void;
		
		function setMouseDown():void;
		
		function setMouseUp():void;
	}
	
}
