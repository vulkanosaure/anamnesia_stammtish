package utils.virtualkeyboard {
	
	import flash.display.BitmapData;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import virgile.patterns.core.IDisposable;
	
	public class AppTextField extends TextField implements IDisposable{
		
		var _tft:TextFormat;
		
		/**
		 * Constructor
		 *
		 * @param	area			viewport area
		 * @param	style			format defined through a specific CSS style and applied to inserted text
		 * @param	multiline		indicates whether field is a multiline text field
		 * @param	wordWrap		boolean value that indicates whether the text field has word wrap
		 * @param	autoSize		controls automatic sizing and alignment of text fields
		 */
		public function AppTextField() {
			
			//trace("AppTextField const");
			_tft = new TextFormat("Museo Sans 500", 50, 0x807E7D, false);
			_tft.align = "center";
			/*
			this.border = true;
			this.borderColor = 0xAA0000;
			*/
			this.width = 59;
			this.embedFonts = true;
			
			
		}
		
		public function set fontsize(_value:int):void
		{
			_tft.size = _value;
		}
		
		
		override public function set text(value:String):void 
		{
			super.text = value;
			super.setTextFormat(_tft);
		}
		
		public function dispose(e:Event = null):void
		{
			
		}
		
	}
}
