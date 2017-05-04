package 
{
	import data.form.autocompletion.AutoCompletionEvent;
	import data.form.autocompletion.AutoCompletionField;
	import flash.display.Sprite;
	import data.abstrait.Document;
	
	
	/**
	 * ...
	 * @author Vincent
	 */
	public class AutoCompletionFieldDocument extends Document 
	{
		
		//_______________________________________________________________________________
		// properties
		
		
		public function AutoCompletionFieldDocument() {}
		
		override protected function init():void
		{
			trace("AutoCompletionFieldExample.init");
			checkFlashvars([]);
			
			var _autoCompletionField:AutoCompletionField = new AutoCompletionFieldExample();
			_autoCompletionField.serverfile = "../wp-content/plugins/autocompletion-data/utils/tags.php";
			_autoCompletionField.listItemClass = AutoCompletionListItemExample;
			this.addChild(_autoCompletionField);
			_autoCompletionField.addEventListener(AutoCompletionEvent.SELECT_ENTRY, onSelectEntry);
			_autoCompletionField.minCharsActive = 3;
			_autoCompletionField.maxResults = 4;
			_autoCompletionField.shifty = 1;
		}
		
		private function onSelectEntry(e:AutoCompletionEvent):void 
		{
			trace("Main.onSelectEntry " + e.identry);
		}
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
		
	}
	
}