package utils.virtualkeyboard {
	
	import data2.asxml.MouseEventConvertor;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	

	[Event(name = "input", type = "virgile.modules.virtualkeyboard.VirtualKeyboardEvent")]
	[Event(name = "status", type = "virgile.modules.virtualkeyboard.VirtualKeyboardEvent")]
	
	public class VirtualKeyboard extends Sprite implements IDisposable{
		
		
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		//	CLASS MEMBERS
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		private static var _Instance:VirtualKeyboard;
		
		/** Returns VirtualKeyboard singleton */
		public static function get $():VirtualKeyboard {
			if(!_Instance)
				_Instance = new VirtualKeyboard();
			return _Instance;
		}
		
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		//	INSTANCE MEMBERS
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		private const BG_MARGIN:Number = 15;
		
		private var _view:Sprite;
		private var _bg:Sprite;
		private var _keyboardType:IKeyboardType;
		private var _keys:Object;
		
		private var _showLetters:Boolean;
		private var _showNumbers:Boolean;
		private var _onlyEmail:Boolean;
		private var _uppercase:Boolean;
		private var _timer:Timer;
		private var _line:Sprite;
		public var _stage:Stage;
		
		/** Constructor */
		public function VirtualKeyboard(_colorbg:uint= 0x0000FF, _alphabg:Number = 0) {
			
			// ---	display list
			
			_bg = new Sprite();
			_bg.graphics.beginFill(_colorbg, _alphabg);
			_bg.graphics.drawRect(0, 0, 10, 10);
			addChild(_bg);
			
			_view = new Sprite();
			addChild(_view);
			
			_showLetters = true;
			_showNumbers = true;
			_onlyEmail = false;
			_uppercase = true;
			
			_line = new Sprite();
			addChild(_line);
			_line.x = 983;
			_line.y = 0;
			_line.graphics.lineStyle(0.5, 0xFFFFFF, 0.25);
			_line.graphics.moveTo(0, 0);
			_line.graphics.lineTo(0, 441);
			
			
		}
		
		
		//	##################################################################################################################
		//	KEYBOARD EVENTS HANDLERS
		
		private function _onVirtualKeyHandler(e:MouseEvent):void {
			var key:IKeyView;
			
			key = e.target as IKeyView;
			//key.dispPress();
			dispatchEvent(new VirtualKeyboardEvent(VirtualKeyboardEvent.INPUT, key.charCode));
		}
		
		private function _onRealKeyHandler(e:KeyboardEvent):void {
			var key:KeyView;
			
			// do not use SHIFT, ALT or CONTROL alone
			if (e.keyCode == 16 || e.keyCode == 17 || e.keyCode == 18) {
				return;
			}
			
			key = keyFromCharcode(e.charCode);
			trace('[VirtualKeyboard._onRealKeyHandler] charCode: ' + e.charCode + ' / key: ' + key);
			
			if(!key)
				key = keyFromCharcode(e.keyCode);
			if (key){
				key.dispPress();
				dispatchEvent(new VirtualKeyboardEvent(VirtualKeyboardEvent.INPUT, key.charCode));
			}
		}
		
		private function _onVirtualInput(e:VirtualKeyboardEvent):void {
			var key:KeyView;
			
			key = keyFromCharcode(e.charCode) as KeyView;
			if(key)
				key.dispPress();
			else
				trace('[VirtualKeyboard._onVirtualInput] Unable to find key for: ' + e.charCode);
		}
		
		//	##################################################################################################################
		//	KEYS ACCESS
		
		/** Registers a key for a specific charCode */
		public function registerKey(key:IKeyView, charCode:int):void {
			if(key && charCode > 0)
				_keys['key_' + String(charCode)] = key;
		}
		
		/** Returns the virtual key corresponding to the passed-in charcode */
		public function keyFromCharcode(charCode:int):KeyView {
			return _keys ? _keys['key_' + String(charCode)] as KeyView : null;
		}
		
		/** Returns a log string containing all virtual keys registrations */
		public function logRegisteredKeys():String {
			var log:String;
			
			log = 'logRegisteredKeys: ';
			for each(var keyView:KeyView in _keys)
				log += '\n\t' + String.fromCharCode(keyView.charCode);
			return log;
		}
		
		
		//	########################################################################################################
		//	DISPLAY UTILS
		
		/** keyboard configuration */
		public function get keyboardType():IKeyboardType {
			return _keyboardType;
		}
		public function set keyboardType(keyboardType:IKeyboardType):void {
			var keys:Vector.<IKeyView>;
			var key:IKeyView;
			
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			MouseEventConvertor.addMouseListener(_stage, MouseEvent.MOUSE_UP, onMouseUp);
			
			
			_keyboardType = keyboardType;
			
			// remove former settings
			_keys = { };
			_clearKeys();
			
			// rebuild keyboard
			if (_keyboardType) {
				//Global.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onRealKeyHandler);
			
				keys = _keyboardType.keysDeclaration();
				for each(key in keys) {
					(key as EventDispatcher).addEventListener(MouseEvent.CLICK, _onVirtualKeyHandler);
					
					MouseEventConvertor.addMouseListener(DisplayObject(key), MouseEvent.MOUSE_DOWN, _onVirtualKeyMouseDown);
					
					addEventListener(VirtualKeyboardEvent.STATUS, key.renderStatus);
					registerKey(key, key.charCode);
					_view.addChild(key as DisplayObject);
				}
				dispatchEvent(new VirtualKeyboardEvent(VirtualKeyboardEvent.STATUS));
			}
			
			_bg.x = _view.x - BG_MARGIN;
			_bg.y = _view.y - BG_MARGIN;
			_bg.width = _view.width + 2 * BG_MARGIN;
			_bg.height = _view.height + 2 * BG_MARGIN;
		}
		
		
		
		var _keymousedown:IKeyView;
		
		private function _onVirtualKeyMouseDown(e:Event):void 
		{
			
			var _key:IKeyView = IKeyView(e.currentTarget);
			trace("_onVirtualKeyMouseDown " + _key);
			_key.setMouseDown();
			
			//secu
			if (_keymousedown != null) _keymousedown.setMouseUp();
			_keymousedown = _key;
		}
		
		private function onMouseUp(e:Event):void 
		{
			//error
			if (_keymousedown != null) {
				trace("_onVirtualKeyMouseDown " + _keymousedown);
				if (_timer == null) {
					_timer = new Timer(200, 1);
					_timer.addEventListener(TimerEvent.TIMER, onTimerMouseUp);
				}
				_timer.reset();
				_timer.start();
				
			}
			
		}
		
		private function onTimerMouseUp(e:TimerEvent):void 
		{
			trace("onTimerMouseUp");
			_keymousedown.setMouseUp();
			_keymousedown = null;
		}
		
		
		
		
		/** letter status */
		public function get showLetters():Boolean {
			return _showLetters;
		}
		public function set showLetters(showLetters:Boolean):void {
			_showLetters = showLetters;
			dispatchEvent(new VirtualKeyboardEvent(VirtualKeyboardEvent.STATUS));
		}
		
		/** numbers status */
		public function get showNumbers():Boolean {
			return _showNumbers;
		}
		public function set showNumbers(showNumbers:Boolean):void {
			_showNumbers = showNumbers;
			dispatchEvent(new VirtualKeyboardEvent(VirtualKeyboardEvent.STATUS));
		}
		
		/** uppercase status */
		public function get uppercase():Boolean {
			return _uppercase;
		}
		public function set uppercase(uppercase:Boolean):void {
			_uppercase = uppercase;
			dispatchEvent(new VirtualKeyboardEvent(VirtualKeyboardEvent.STATUS));
		}
		
		/** Removes all virtual keys from display list */
		private function _clearKeys():void {
			var key:KeyView;
			
			while(_view.numChildren > 0) {
				key = _view.getChildAt(0) as KeyView;
				key.removeEventListener(MouseEvent.CLICK, _onVirtualKeyHandler);
				_view.removeChild(key);
			}
		}
		
		
		//	##################################################################################################################
		//	virgile.patterns.core.IDisposable
		
		/** @inheritDoc */
		public function dispose(e:Event = null ):void {
			//Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onRealKeyHandler);
		}
	}
}
