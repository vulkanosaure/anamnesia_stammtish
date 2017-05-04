package data.dataplayer {
	
	import flash.display.MovieClip;
	
	public class Timeline extends MovieClip{
		
		
		var _width:Number;
		var _height:Number;
		
		var mcBg:MovieClip;
		var mcDownload:MovieClip;
		var mcProgress:MovieClip;
		
		
		public function Timeline() 
		{
			this.buttonMode = true;
			
		}
		
		public function setMC(bg, download, progress)
		{
			mcBg = bg;
			mcDownload = download;
			mcProgress = progress;
		}
		
		public function setDimensions(__width:Number)
		{
			_width = __width;
		}
		
		public function setElements()
		{
			//bg
			mcBg.x = 0;
			mcBg.y = 0;
			addChild(mcBg);
			mcBg.width = _width * 1;
			
			//download
			mcDownload.x = 0;
			mcDownload.y = this.height/2 - mcDownload.height/2;
			addChild(mcDownload);
			mcDownload.width = _width * 0.75;
			
			//progress
			mcProgress.x = 0;
			mcProgress.y = this.height/2 - mcProgress.height/2;
			addChild(mcProgress);
			mcProgress.width = _width * 0.5;
			
		}
		
		public function clear()
		{
			while(numChildren) removeChildAt(0);
		}
		
		
		
		public function setProgress(v:Number)
		{
			mcProgress.width = _width * v / 100;
		}
		
		public function setDownload(v:Number)
		{
			mcDownload.width = _width * v / 100;
		}
		
		
		
		
		
		
		
		
		
		
		//___________________________________________________________________________________
		//events handler
		
		
		
	}
	
}