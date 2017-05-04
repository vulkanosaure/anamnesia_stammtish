package data.dataplayer {
		
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class Option extends MovieClip{
		
		
		var mc1:MovieClip;
		var mc2:MovieClip;	//optionel, ex fullscreen
		var currentmc:MovieClip;
		var doublestate:Boolean;
		var _state:Boolean;
		public var available:Boolean;
		
		var rollover:Boolean = false;
		var rollout:Boolean = false;
		var _allowRollover:Boolean = true;
		
		
		public function Option(_doublestate:Boolean, ...args:Array) 
		{ 
			doublestate = _doublestate;
			mc1 = args[0];
			currentmc = mc1;
			initMC(mc1);
			if(doublestate){
				mc2 = args[1];
				initMC(mc2);
				state = true;
			}
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			//this.addEventListener(Event.ENTER_FRAME, onEnterframe);
		}
		
		private function initMC(mc:MovieClip)
		{
			addChild(mc);
			mc.gotoAndStop("out");
			mc.buttonMode = true;
		}
		
		
		public function get state():Boolean
		{
			return _state;
		}
		public function set state(b:Boolean)
		{
			mc1.visible = !b;
			mc2.visible = b;
			if(b){
				currentmc = mc2;
				currentmc.gotoAndStop(mc1.currentFrame);
			}
			else{
				currentmc = mc1;
				currentmc.gotoAndStop(mc2.currentFrame);
			}
			
			_state = b;
		}
		
		public function set allowRollover(b:Boolean)
		{
			_allowRollover = b;
			if(!b) currentmc.gotoAndStop("out");
		}
		
		public function roll_out()
		{
			rollover = false;
			rollout = true;
		}
		
		
		override public function gotoAndStop(frame:Object, scene:String=null):void
		{
			currentmc.gotoAndStop(frame);
		}
		
		
		
		
		
		//events handler
		private function onClick(e:MouseEvent):void
		{
			if(doublestate) state = (state)?false:true;
		}
		
		private function onRollOver(e:MouseEvent):void
		{
			//currentmc.gotoAndStop(2);	//todo : anim
			rollover = _allowRollover;
			rollout = false;
			currentmc.playTo("over");
		}
		
		private function onRollOut(e:MouseEvent):void
		{
			//currentmc.gotoAndStop(1);
			roll_out();
			currentmc.playbackTo(1);
		}
		/*
		private function onEnterframe(e:Event):void
		{
			if(rollover){
				if(currentmc.currentLabel!="over") currentmc.nextFrame();
				else rollover = false;
			}
			else if(rollout){
				if(currentmc.currentLabel!="out") currentmc.prevFrame();
				else rollout = false;
			}
		}
		*/
		private function changeState():void
		{
			_state = !_state;
			
		}
		
		
		
	}
	
}