package data.dataplayer.pages {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;
	
	public class Page extends MovieClip{
		
		//params
		
		
		//private vars
		
		var tw_width:Tween;
		var tw_height:Tween;
		var tw_x:Tween;
		var tw_y:Tween;
		var tw_alpha:Tween;
		
		var init_x:Number;
		var init_y:Number;
		
		//_______________________________________________________________
		//public functions
		
		public function Page() 
		{ 
			//trace("constructeur page");
			
		}
		
		
		
		public override function set visible(b:Boolean):void
		{
			super.visible = b;
			if(b) show();
			if(b) dispatchEvent(new Event("PAGE_VISIBLE"));
		}
		
		public function setX(v:Number):void
		{
			this.x = v;
			init_x = v;
		}
		public function setY(v:Number):void
		{
			this.y = v;
			init_y = v;
		}
		
		
		//_______________________________________________________________
		//private functions
		
		private function show()
		{
			var time:Number = 0.2;
			tw_x = new Tween(this, "x", Regular.easeOut, init_x + this.width/2, init_x, time, true);
			tw_y = new Tween(this, "y", Regular.easeOut, init_y + this.height/2, init_y, time, true);
			tw_alpha = new Tween(this, "alpha", Regular.easeOut, 0, 1, time, true);
			
			tw_width = new Tween(this, "scaleX", Regular.easeOut, 0, 1, time, true);
			tw_height = new Tween(this, "scaleY", Regular.easeOut, 0, 1, time, true);
			tw_height.addEventListener(TweenEvent.MOTION_FINISH, onShowFinish);
			
			
		}
		
		
		
		//_______________________________________________________________
		//events handlers
		private function onShowFinish(e:TweenEvent)
		{
			trace("onShowFinish");
		}
		
	}
	
}