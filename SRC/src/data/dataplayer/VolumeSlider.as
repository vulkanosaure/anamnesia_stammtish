package data.dataplayer {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import data.dataplayer.VolumeEvent;
	
	
	
	
	public class VolumeSlider extends MovieClip{
		
		
		var st:Stage;
		var mcBg:MovieClip;
		var mcTrack:MovieClip;
		var mcHandle:MovieClip;
		
		var mouse_down:Boolean;
		var shift_pos:Number;
		
		var top:Number;
		var bottom:Number;
		
		var volumeInit:Number;
		
		
		
		
		public function VolumeSlider(stage:Stage)
		{ 
			st = stage;
			
		}
		
		public function clear()
		{
			//trace("VolumeSlider.clear()");
			while(numChildren) removeChildAt(0);
		}
		
		public function setMC(bg:MovieClip, track:MovieClip, handle:MovieClip)
		{
			//trace("VolumeSlider.setMC()");
			mcBg = bg;
			mcTrack = track;
			mcHandle = handle;
			
		}
		
		public function setElements()
		{
			addChild(mcBg);
			addChild(mcTrack);
			addChild(mcHandle);
			mcHandle.buttonMode = true;
			mouse_down = false;
			
			mcHandle.addEventListener(MouseEvent.MOUSE_DOWN, onmousedown);
			mcHandle.addEventListener(MouseEvent.MOUSE_UP, onmouseup);
			st.addEventListener(MouseEvent.MOUSE_UP, onmouseup);
			
			mcBg.x = 0;
			mcBg.y = 0;
			
			mcTrack.x = mcBg.width/2 - mcTrack.width/2;
			mcTrack.y = 2;	//todo : param ?
			
			top = mcTrack.y;
			bottom = mcTrack.y + mcTrack.height - mcHandle.height;
			
			mcHandle.x = mcTrack.x + mcTrack.width/2 - mcHandle.width/2;
			volume = volumeInit;
		}
		
		
		
		public function set volume(v:Number)
		{
			mcHandle.y = bottom + v * (top-bottom) / 100;
		}
		
		public function get volume():Number
		{
			return (mcHandle.y - bottom) / ((top-bottom) / 100);
		}
		
		
		
		
		
		
		
		
		
		
		//______________________________________________________________________________________
		//events handler
		
		private function onmousedown(e:MouseEvent)
		{
			mouse_down = true;
			shift_pos = mouseY - mcHandle.y;
			this.addEventListener(Event.ENTER_FRAME, onenterframe);
		}
		
		private function onmouseup(e:MouseEvent)
		{
			mouse_down = false;
			this.removeEventListener(Event.ENTER_FRAME, onenterframe);
		}
		
		private function onenterframe(e:Event)
		{
			if(mouse_down){
				var pos:Number = mouseY - shift_pos;
				if(pos<top) pos = top;
				if(pos>bottom) pos = bottom;
				mcHandle.y = pos;
				dispatchEvent(new Event("VOLUME_CHANGE"));
			}
		}
		
		
	}
	
}