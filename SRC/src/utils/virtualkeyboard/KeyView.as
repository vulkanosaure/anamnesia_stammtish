package utils.virtualkeyboard {
	
	import com.greensock.easing.Circzer;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	import virgile.patterns.core.IDisposable;
	
	public class KeyView extends Sprite implements IKeyView {
		
		private var _charCode:int;
		private var _asLetter:Boolean;
		private var _asNumber:Boolean;
		private var _asEmail:Boolean;
		private var _customLabel:String;
		private var _enabled:Boolean;
		private var _skin:IKeyView;
		private var _label:String;
		
		/** Constructor */
		public function KeyView() {
			
			// ---	check implementation
			_skin = this as IKeyView;
			if (_skin == null)
				throw new Error('[KeyView] KeyView subclasses must implement IKeyView interface.');
				
			mouseChildren = false;
			useHandCursor = true;
			buttonMode = true;
		}
		
		
		
		
		public function setMouseDown():void
		{
		}
		
		public function setMouseUp():void
		{
		}
		
		
		/** whether or not user input is enabled */
		public function get enabled():Boolean {
			return mouseEnabled;
		}
		public function set enabled(enabled:Boolean):void {
			mouseEnabled = enabled;
			_skin.dispEnabled();
		}
		
		/** Returns a string representation of the instance */
		override public function toString():String {
			return '[KeyView] label: "' + (_skin ? _skin.label : '') + '", charCode: ' + charCode;
		}
		
		//	##################################################################################################################
		//	INTERFACE virgile.modules.virtualkeyboard.IKeyView
		
		/** linked key charcode */
		public function get charCode():int{
			return _charCode;
		}
		
		/** @inheritDoc */
		public function renderStatus(e:VirtualKeyboardEvent):void{
			var virtKb:VirtualKeyboard
			
			virtKb = e.currentTarget as VirtualKeyboard;
			
			// uppercase display
			if (_asLetter && !_customLabel)
				_skin.label = virtKb.uppercase ? String.fromCharCode(_charCode).toUpperCase() : String.fromCharCode(_charCode).toLowerCase();
			
			
			// enabled status
			if (_asLetter)
				enabled = virtKb.showLetters;
			if (_asNumber)
				enabled = virtKb.showNumbers;
		}
		
		/** @inheritDoc */
		public function reset(charCode:int = -1, asLetter:Boolean = true, asNumber:Boolean = true, asEmail:Boolean = true, customLabel:String = null):void {
			_asLetter = asLetter;
			_asNumber = asNumber;
			_asEmail = asEmail;
			_customLabel = customLabel;
			
			_charCode = charCode;
			if(_customLabel)
				label = _customLabel;
			else if (_charCode > 0)
				label = String.fromCharCode(_charCode);
			else
				label = '';
			
			enabled = _charCode >= 0;
		}
		
		/** @inheritDoc */
		public function get label():String {
			return _label;
		}
		public function set label(label:String):void {
			_skin.label = label;
			_label = label;
		}
		
		/** @inheritDoc */
		public function dispEnabled():void {
			_skin.dispEnabled();
		}
		
		/** @inheritDoc */
		public function dispPress():void {
			_skin.dispPress();
		}
		
		/** @inheritDoc */
		public function dispose(e:Event = null):void {
			_skin.dispose();
		}
	}
}
