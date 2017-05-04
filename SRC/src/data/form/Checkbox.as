package data.form 
{
	import data.display.FilledRectangle;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Vincent
	 */
	public class Checkbox extends MovieClip
	{
		public static const LABEL_ON:String = "on";
		public static const LABEL_OFF:String = "off";
		
		private var bg:FilledRectangle;
		private var _autoCheckOnClick:Boolean = true;
		private var _checked:Boolean;
		
		
		public function Checkbox() 
		{
			var frame_on:Number = getFrameByName(LABEL_ON);
			var frame_off:Number = getFrameByName(LABEL_OFF);
			//if (frame_on == -1 || frame_off == -1) throw new Error("MovieClipRollOver must contain \""+LABEL_ON+"\" and \""+LABEL_OFF+"\" labels");
			
			this.mouseChildren = false;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.gotoAndStop(LABEL_OFF);
			
			bg = new FilledRectangle(0xff0000);
			bg.alpha = 0.0;
			
			this.checked = false;
		}
		
		public function setZone(_mleft:Number, _mtop:Number=3, _mright:Number=2, _mbottom:Number=3):void
		{
			bg.x = -_mleft;
			bg.y = -_mtop;
			bg.width = _mleft + _mright + this.width;
			bg.height = _mtop + _mbottom + this.height;
			addChild(bg);
		}
		
		
		public function get checked():Boolean
		{
			return _checked;
		}
		public function set checked(v:Boolean):void
		{
			
			_checked = v;
			this.gotoAndStop((v) ? LABEL_ON : LABEL_OFF);
		}
		
		
		
		public function set autoCheckOnClick(value:Boolean):void 
		{
			_autoCheckOnClick = value;
		}
		
		
		public function dispatchState():void
		{
			var _type:String = (this.checked) ? CheckboxEvent.CHECK : CheckboxEvent.UNCHECK;
			dispatchEvent(new CheckboxEvent(_type));
		}
		
		
		
		
		
		
		
		protected function getFrameByName(_name:String):Number
		{
			var labels:Array = this.currentLabels;
			var len:int = labels.length;
			for(var i:int=0;i<len;i++){
				if(labels[i].name==_name) return labels[i].frame;
			}
			return -1
		}
		
		
		
		private function onClick(e:MouseEvent):void 
		{
			//trace("Checkbox.onClick "+this.checked);
			if (this.checked) {
				if (_autoCheckOnClick) this.checked = false;
				dispatchEvent(new CheckboxEvent(CheckboxEvent.UNCHECK));
			}
			else {
				if (_autoCheckOnClick) this.checked = true;
				dispatchEvent(new CheckboxEvent(CheckboxEvent.CHECK));
			}
		}
		
	}

}