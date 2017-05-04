package data2.behaviours.form 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 
	 */
	public class InputCheckbox extends Input
	{
		public static const LABEL_ON:String = "on";
		public static const LABEL_OFF:String = "off";
		
		private var _index:int;
		private var _groupname:String;
		private var _mc:MovieClip;
		private var _required:Boolean;
		private var _autoCheckOnClick:Boolean;
		private var _checked:Boolean;
		private var _value:String;
		
		
		public function InputCheckbox()
		{
			_required = true;
			_autoCheckOnClick = true;
			
			/*
			_bg = new FilledRectangle(0xff0000);
			_bg.alpha = 0.0;
			*/
			
		}
		
		override public function reset():void 
		{
			this.checked = false;
		}
		
		
		public function setZone(_mleft:Number, _mtop:Number=3, _mright:Number=2, _mbottom:Number=3):void
		{
			/*
			bg.x = -_mleft;
			bg.y = -_mtop;
			bg.width = _mleft + _mright + this.width;
			bg.height = _mtop + _mbottom + this.height;
			addChild(bg);
			*/
			//todo avec ClickableSprite
		}
		
		
		//pour RadioGroup
		public function dispatchState():void
		{
			var _type:String = (this.checked) ? CheckboxEvent.CHECK : CheckboxEvent.UNCHECK;
			dispatchEvent(new CheckboxEvent(_type));
		}
		
		
		
		
		
		//______________________________________________________
		//set / get
		
		
		public function get mc():MovieClip {return _mc;}
		
		public function set mc(value:MovieClip):void 
		{
			_mc = value;
			
			var frame_on:Number = getFrameByName(LABEL_ON);
			var frame_off:Number = getFrameByName(LABEL_OFF);
			if (frame_on == -1 || frame_off == -1) throw new Error("MovieClipRollOver must contain \"" + LABEL_ON + "\" and \"" + LABEL_OFF + "\" labels");
			
			_mc.mouseChildren = false;
			_mc.buttonMode = true;
			_mc.addEventListener(MouseEvent.CLICK, onClick);
			_mc.gotoAndStop(LABEL_OFF);
			
			this.checked = false;
		}
		
		public function get required():Boolean {return _required;}
		
		public function set required(value:Boolean):void {_required = value;}
		
		public function get autoCheckOnClick():Boolean {return _autoCheckOnClick;}
		
		public function set autoCheckOnClick(value:Boolean):void {_autoCheckOnClick = value;}
		
		public function get checked():Boolean {return _checked;}
		
		public function set checked(value:Boolean):void 
		{
			_checked = value;
			_mc.gotoAndStop((_checked) ? LABEL_ON : LABEL_OFF);
			
			if(!value) dispatchEvent(new CheckboxEvent(CheckboxEvent.UNCHECK));
			else dispatchEvent(new CheckboxEvent(CheckboxEvent.CHECK));
		}
		
		public function get index():int {return _index;}
		
		public function set index(value:int):void {_index = value;}
		
		public function get groupname():String {return _groupname;}
		
		public function set groupname(value:String):void {_groupname = value;}
		
		public function get value():String {return _value;}
		
		public function set value(value:String):void {_value = value;}
		
		
		
		
		
		//______________________________________________________
		//private function
		
		private function getFrameByName(_name:String):Number
		{
			var labels:Array = _mc.currentLabels;
			var len:int = labels.length;
			for(var i:int=0;i<len;i++){
				if(labels[i].name==_name) return labels[i].frame;
			}
			return -1
		}
		
		
		
		
		//______________________________________________________
		//events
		
		private function onClick(e:MouseEvent):void 
		{
			//trace("Checkbox.onClick "+this.checked);
			if (this.checked) {
				if (_autoCheckOnClick) this.checked = false;
				
			}
			else {
				if (_autoCheckOnClick) this.checked = true;
				
			}
		}
	}

}