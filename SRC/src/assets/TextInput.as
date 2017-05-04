package assets 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Vinc
	 */
	public class TextInput extends TextField
	{
		var _tft:TextFormat;
		
		public function TextInput() 
		{
			_tft = new TextFormat("Museo Sans 300", 20, 0xffffff, true);
			this.embedFonts = true;
		}
		
		
		override public function set text(value:String):void 
		{
			super.text = value;
			super.setTextFormat(_tft);
		}
		
	}

}