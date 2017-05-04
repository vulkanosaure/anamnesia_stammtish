/*
classe qui prend en entrée un tableau de chemins vers des images
elle les affiche les une a la suite des autres

propriétés publiques :

speed_display:Number		(defaut:1)
play_loop:Boolean			(defaut:true)
direction:String = ["left", "right", "bottom", "top"]	(defaut:"right")


utilisation : 

var d:Diaposlider = new DiapoSlider();
d.setImages(tableau_urls);
// ou d.setImage("url"); -> pour autant d'img que nécéssaire
d.init();
d.addEventListener("FIRST_IMG_LOADED", onFirstImgLoaded);
*/

package data.diaporama {
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.geom.Point;
	import data.fx.Container;
	
	public dynamic class DiapoSlider extends MovieClip{
		
		
		
		public static var DIR_LEFT:String = "left";
		public static var DIR_RIGHT:String = "right";
		public static var DIR_BOTTOM:String = "bottom";
		public static var DIR_TOP:String = "top";
		
		
		//params
		public var speed_display:int = 1;
		public var play_loop:Boolean = true;
		public var direction:String = DIR_RIGHT;
		
		
		
		
		//private vars
		var paths:Array;
		var positions:Array;
		var currID:int = 0;
		var prevID:int = -1;
		var offsetID:int = 0;
		var _nbImg:int;
		var loader:Loader;
		var loader_prev:Loader;
		var countLoop:int = 0;
		var containers:Array;
		var bdone:Boolean;
		var bFirstImgLoaded:Boolean;
		
		
		
		
		
		//_______________________________________________________________________________
		//public functions
		
		public function DiapoSlider() 
		{ 
			containers = new Array();
			paths = new Array();
			positions = new Array();
			
		}
		
		public function setImages(a:Array):void
		{
			paths = a;
			_nbImg = paths.length;
			for(var i:int=0;i<_nbImg;i++) positions.push(new Point(0, 0));
		}
		
		public function setImage(src:String, left:Number, top:Number):void
		{
			paths.push(src);
			positions.push(new Point(left, top));
			_nbImg++;
		}
		
		public function init():void
		{
			bFirstImgLoaded = false;
			for(var i:int=0;i<_nbImg;i++){
				containers.push(new Container(stage));
				addChild(containers[i]);
				//
				if(direction==DIR_LEFT || direction==DIR_RIGHT) containers[i].setVerticalPosition("PERCENT", "TOP", 50);
				else if(direction==DIR_TOP || direction==DIR_BOTTOM) containers[i].setHorizontalPosition("PERCENT", "LEFT", 50);
				containers[i].shiftX = positions[i].x;
				containers[i].shiftY = positions[i].y;
			}
			timerHandler();
			this.addEventListener(Event.ENTER_FRAME, onEnterframe);
			
		}
		
		public function set offset(i:int)
		{
			currID = i;
			prevID = i-1;
			offsetID = i;
		}
		
		public function get nbImg():int
		{
			return _nbImg;
		}
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		//private functions
		
		
		private function timerHandler()
		{
			loader_prev = loader;
			loader = new Loader();
			loader.load(new URLRequest(paths[currID]));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgLoaded);
		}
		
		private function onImgLoaded(e:Event)
		{
			bdone = false;
			if(currID==offsetID && countLoop==0) {
				dispatchEvent(new Event("FIRST_IMG_LOADED"));
				bFirstImgLoaded = true;
			}
			if(play_loop || countLoop==0){
				containers[currID].addChild(loader);
				if(loader_prev!=null) containers[prevID].addChild(loader_prev);
				
				//
				if(direction==DIR_TOP || direction==DIR_BOTTOM){
					var _y:Number;
					if(loader_prev==null) _y = 0;
					else if(direction==DIR_TOP) _y = loader_prev.height+loader_prev.y;
					else if(direction==DIR_BOTTOM) _y = -loader.height+loader_prev.y;
					loader.y = _y;
				}
				else if(direction==DIR_LEFT || direction==DIR_RIGHT){
					var _x:Number;
					if(loader_prev==null) _x = 0;
					else if(direction==DIR_LEFT) _x = loader_prev.width+loader_prev.x;
					else if(direction==DIR_RIGHT) _x = -loader.width+loader_prev.x;
					loader.x = _x;
				}
				//
				trace("loader.y : "+loader.y);
				
				prevID = currID;
				currID++;
				if(currID==_nbImg){
					currID=0;
					countLoop++;
				}
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		//events handler
		
		private function onEnterframe(e:Event)
		{
			if(bFirstImgLoaded){
				
				var prop:String;
				var multip:Number;
				var coord:Number;
				if(direction==DIR_TOP){
					prop = "y";
					multip = -1;
					coord = 0;
				}
				else if(direction==DIR_BOTTOM){
					prop = "y";
					multip = 1;
					coord = 0;
				}
				else if(direction==DIR_LEFT){
					prop = "x";
					multip = -1;
					coord = 0;
				}
				else if(direction==DIR_RIGHT){
					prop = "x";
					multip = 1;
					coord = 0;
				}
				
				var shift:Number = speed_display * multip;
				loader[prop] += shift;
				if(loader_prev!=null) loader_prev[prop]  += shift;
				
				
				if(!bdone){
					if((direction==DIR_LEFT || direction==DIR_TOP) && loader[prop] < coord){									//
						bdone = true;
						timerHandler();
					}
					else if((direction==DIR_RIGHT || direction==DIR_BOTTOM) && loader[prop] > coord){									//
						bdone = true;
						timerHandler();
					}
				}
			}
		}
		
	}
	
}