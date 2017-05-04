package data.form.autocompletion 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author Vincent
	 */
	public class AutoCompletionListItem extends MovieClip
	{
		//_______________________________________________________________________________
		// properties
		
		private var _id:String;
		private var _type:String;
		private var _label:String;
		private var _tf:TextField;
		
		public function AutoCompletionListItem() 
		{
			_tf = this.getChildByName("tf") as TextField;
			if (_tf == null) throw new Error("AutoCompletionListItem must contain 'tf' instance");
			if (_tf.type != TextFieldType.DYNAMIC) throw new Error("'tf' instance must be of type DYNAMIC");
			_tf.wordWrap = false;
			
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			this.gotoAndStop("out");
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function setContent(__id:String, __type:String, __label:String):void
		{
			_id = __id;
			_type = __type;
			_label = __label;
			_tf.text = __label;
		}
		
		public function get id():String { return _id; }
		
		public function get type():String { return _type; }
		
		public function get label():String { return _label; }
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		private function onMouseOver(e:MouseEvent):void 
		{
			this.gotoAndStop("over");
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			this.gotoAndStop("out");
		}
		
		
		
		
		
	}

}