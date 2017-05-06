package view 
{
	import assets.TextInput;
	import data2.mvc.ViewBase;
	import data2.text.Text;
	import events.BroadCaster;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import utils.virtualkeyboard.AzertyKeyboardType;
	import utils.virtualkeyboard.geom.XPoint;
	import utils.virtualkeyboard.KBKey;
	import utils.virtualkeyboard.VirtualKeyboard;
	import utils.virtualkeyboard.VirtualKeyboardEvent;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ViewEntermail extends ViewBase
	{
		static private var _keyboard:VirtualKeyboard;
		static private var _inputEmail:TextInput;
		
		public function ViewEntermail() 
		{
			
		}
		
		
		public static function init(_stage:Stage):void
		{
			
			_keyboard = new VirtualKeyboard("mail");
			_keyboard._stage = _stage;
			_keyboard.keyboardType = new AzertyKeyboardType(new XPoint(74, 103), 23, 17, KBKey);
			_keyboard.addEventListener(VirtualKeyboardEvent.INPUT, onKeyboardInput);
			
			var _container:Sprite = getSprite("virtual_keyboard_container");
			_container.addChild(_keyboard);
			
			
			var _containerTextEmail:Sprite = getSprite("zone_input_email_sub");
			_inputEmail = new TextInput();
			_inputEmail.x = 10; _inputEmail.y = 12;
			_inputEmail.width = 795 - _inputEmail.x * 2;
			_containerTextEmail.addChild(_inputEmail);
			
			
			
		}
		
		
		public static function updateScreen():void
		{
			displayError("help");
			_inputEmail.text = "";
			if (DataGlobal.DEBUG_MODE) _inputEmail.text = "vincent.huss@gmail.com";
		}
		
		
		
		static private function onKeyboardInput(e:VirtualKeyboardEvent):void 
		{
			//trace("onKeyboardInput " + e.charCode);
			
			var _text:String = _inputEmail.text;
			
			if (e.charCode == Keyboard.BACKSPACE) {
				
				_text = _text.substr(0, _text.length - 1);
				
			}
			else	{
				
				var _addChar:String;
				
				if (e.charCode == Keyboard.ENTER){
					validateMail();
					return;
				}
				else if (e.charCode == -2) {
					_addChar = ".fr";
				}
				else if (e.charCode == -3){
					_addChar = ".com";
				}
				else {
					_addChar = String.fromCharCode(e.charCode);
				}
				
				_addChar = _addChar.toLowerCase();
				_text += _addChar;
				
			}
			
			_inputEmail.text = _text;
		}
		
		
		
		
		
		static public function validateMail():void 
		{
			var _email:String = _inputEmail.text;
			trace("validateMail " + _email);
			
			var emailExpression:RegExp = /^[\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			
			if(_email == "") {
				displayError("empty");
			}
			else if (_email.match(emailExpression)) {
				BroadCaster.dispatchEvent(new Event("SEND_MAIL_SUCCESS"));
				
				_inputEmail.text = "";
			}
			else {
				displayError("syntax");
			}
			
		}
		
		
		public static function getEmail():String
		{
			return _inputEmail.text;
		}
		
		
		
		public static function displayError(_id:String):void
		{
			getSprite("text_error_mail").visible = (_id == "syntax");
			getSprite("text_error_mail_empty").visible = (_id == "empty");
			getSprite("text_help_mail").visible = (_id == "help");
			getSprite("text_conf_mail").visible = (_id == "valid");
		}
		
	}

}