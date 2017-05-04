package view 
{
	import data2.mvc.ViewBase;
	import data2.text.Text;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ViewCredits extends ViewBase
	{
		
		public function ViewCredits() 
		{
			
		}
		
		static public function onTextCreditsChange(_text:Text):void 
		{
			var _btnclose:Sprite = getSprite("btn_close_credits");
			_btnclose.y = _text.y + _text.getTextBounds().height + 193;
			
			
		}
		
	}

}