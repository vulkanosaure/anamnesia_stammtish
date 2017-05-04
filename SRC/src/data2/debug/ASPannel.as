package data2.debug 
{
	import data2.asxml.OnClickHandler;
	import data2.text.Text;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author 
	 */
	public class ASPannel 
	{
		private static const WIDTH:Number = 250;
		private static const HEIGHT:Number = 50;
		private static const MARGINS:Number = 10;
		private static const KEYCODE:int = 65;			//A
		
		static private var _text:Text;
		static private var _sprite:Sprite;
		static private var _stage:Stage;
		static private var _visible:Boolean;
		static private var _tft:TextFormat;
		
		
		public function ASPannel() 
		{
			throw new Error("is static");
		}
		
		
		public static function init(__stage:Stage):void
		{
			_stage = __stage;
			_visible = false;
			
			_sprite = new Sprite();
			
			var _bg:Sprite = new Sprite();
			var _g:Graphics = _bg.graphics;
			_g.clear();
			_g.lineStyle(2, 0x000000, 1);
			_g.beginFill(0xced8e9, 1);
			_g.drawRect(0, 0, WIDTH, HEIGHT);
			_sprite.addChild(_bg);
			_bg.filters = [new DropShadowFilter(4, 45, 0x000000, 0.5, 4, 4)];
			
			
			
			_text = new Text();
			_text.type = TextFieldType.INPUT;
			_sprite.addChild(_text);
			_text.x = MARGINS;
			_text.y = MARGINS;
			_text.width = WIDTH - MARGINS * 2;
			_text.multiline = false;
			
			_text.updateText();
			_text.textField.background = true;
			_text.textField.backgroundColor = 0xFFFFFF;
			
			_tft = new TextFormat("Courier New", 12);
			
			
			//todo : size + grande, font arial, font blanc marche pas
			
			_text.textField.addEventListener(KeyboardEvent.KEY_DOWN, onKeydownTF);
			_text.textField.addEventListener(Event.CHANGE, onTFChange);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeydown);
			
			_bg.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_bg.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		static private function onTFChange(e:Event):void 
		{
			_text.textField.setTextFormat(_tft);
		}
		
		static private function onMouseDown(e:MouseEvent):void 
		{
			_sprite.startDrag();
		}
		
		static private function onMouseUp(e:MouseEvent):void 
		{
			_sprite.stopDrag();
		}
		
		static private function onKeydown(e:KeyboardEvent):void 
		{
			//trace("ASPannel.onKeydown " + e.keyCode);
			if (e.keyCode == KEYCODE) {
				if (_visible) {
					if(_stage.focus != _text.textField) hide();
				}
				else show();
				
			}
		}
		static private function onKeydownTF(e:KeyboardEvent):void 
		{
			//trace("ASPannel.onKeydownTF " + e.keyCode);
			if (e.keyCode == Keyboard.ENTER && _visible) {
				exec();
			}
		}
		
		public static function show():void
		{
			_stage.addChild(_sprite);
			_visible = true;
		}
		
		public static function hide():void
		{
			_stage.removeChild(_sprite);
			_visible = false;
		}
		
		
		
		static private function exec():void 
		{
			var _instruct:String = _text.value;
			trace("exec, _instruct : " + _instruct);
			
			//todo : _instruct is surrounded by formatting trash
			OnClickHandler.execAS(_instruct, _stage);
		}
		
	}

}