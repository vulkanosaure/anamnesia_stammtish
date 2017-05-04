/*
classe qui prend en entrée un tableau de chemins vers des images
elle les affiche les une a la suite des autres

paramètres : 
speed_display:int = 2000;
speed_fadein:Number = 1;
speed_fadeout:Number = 1;
alpha_in:Number = 1;
alpha_out:Number = 0;
play_loop:Boolean = true;
percent_left:Number = 50;
percent_top:Number = 50;

évenements :
FIRST_IMG_LOADED après que la 1ere img ait été chargée
END_LOOP à la fin d'une boucle (ou à la fin tout court si play_loop=false)

*/

package data.diaporama
{

	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.events.IOErrorEvent;
	import flash.utils.Timer;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.geom.Point;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import data.layout.Container;
	import data.diaporama.DiapoEvent;

	public dynamic class Diaporama extends MovieClip
	{

		//params
		public var speed_display:int = 3000;
		public var speed_fadein:Number = 1.3;
		public var speed_fadeout:Number = 0.7;
		public var alpha_in:Number = 1;
		public var alpha_out:Number = 0;
		public var play_loop:Boolean = true;
		public var percent_left:Number = 50;
		public var percent_top:Number = 50;
		public var center:Boolean = true;

		private var stage_width:Number;
		private var stage_height:Number;
		private var force_stage_dims:Boolean = false;

		//private vars
		var paths:Array;
		var positions:Array;
		var texts:Array;
		var times:Array;
		var moves:Array;
		var currID:int = 0;
		var prevID:int = -1;
		var offsetID:int = 0;
		var _nbImg:int;
		var loader:Loader;
		var countLoop:int = 0;
		var containers:Array;
		var timer:Timer;
		var _resize:String;
		var _mask:Sprite;
		var loaders:Array;
		
		var tw1,tw2:Tween;
		var twx, twy:Tween;
		
		
		
		public static const RESIZE_NONE:String = "none";
		public static const RESIZE_FIT:String = "fit";
		public static const RESIZE_BORDER:String = "border";
		
		
		
		
		//_______________________________________________________________________________
		//public functions
		
		public function Diaporama()
		{
			reset();
			_resize = RESIZE_NONE;
			
		}

		public function setStageSize(_width:Number, _height:Number)
		{
			stage_width = _width;
			stage_height = _height;
			force_stage_dims = true;
			
			if (_mask == null) {
				_mask = new Sprite();
				addChild(_mask);
				this.mask = _mask;
				_mask.alpha = 0;
			}
			
			for (var i:int=0; i<_nbImg; i++) {
				containers[i].setStageSize(_width, _height);
			}
			
			var g:Graphics = _mask.graphics;
			g.clear();
			g.beginFill(0x000000);
			g.drawRect(0, 0, _width, _height);
			
		}
		
		public function setImages(a:Array):void
		{
			throw new Error("method setImages is no longer available");
		}
		
		public function setImage(src:String, left:Number=0, top:Number=0, time:Number=0, movex:Number=0, movey:Number=0, _text:String=""):void
		{
			paths.push(src);
			positions.push(new Point(left, top));
			texts.push(_text);
			times.push(time);
			moves.push(new Point(movex, movey));
			//trace("times.push("+time+")");
			_nbImg++;
			loaders.push(null);
		}
		
		public function init():void
		{
			for (var i:int=0; i<_nbImg; i++) {
				containers.push(new Container(stage, false, 0, 0, true));
				addChild(containers[i]);
				if (force_stage_dims) {
					containers[i].setStageSize(stage_width, stage_height);
				}
				
				
				if (center) {
					containers[i].setHorizontalPosition("PERCENT", "LEFT", percent_left);
					containers[i].setVerticalPosition("PERCENT", "TOP", percent_top);
				}
				else {
					containers[i].setHorizontalPosition("PIXEL", "LEFT", 0);
					containers[i].setVerticalPosition("PIXEL", "TOP", 0);
				}
				containers[i].alpha = 0;
				containers[i].shiftX = positions[i].x;
				containers[i].shiftY = positions[i].y;
			}
			
			timerHandler(new TimerEvent(""));
		}
		
		

		public function set offset(i:int)
		{
			currID = i;
			prevID = i - 1;
			offsetID = i;
		}

		public function set resize(v:String)
		{
			if (v != RESIZE_NONE && v != RESIZE_FIT && v != RESIZE_BORDER) {
				throw new Error("Wrong value for param resize (" + v + ")");
			}
			_resize = v;
		}

		public function get nbImg():int
		{
			return _nbImg;
		}



		public override function stop():void
		{
			timer.stop();
		}

		public override function play():void
		{
			timer.start();
		}
		
		public function gotoFrame(i:int):void
		{
			//trace("Diaporama :: gotoFrame("+i+")");
			if (i < 0 || i >= _nbImg) {
				throw new Error("gotoFrame : param must be set between [0, " + (_nbImg - 1) + "]");
			}
			var _o:Number = (i-1 >= 0) ? (i-1) : _nbImg-1;
			//trace("gotoFrame, currID : "+currID);
			/*
			currID = _o;
			offsetID = _o;
			*/
			currID = i;
			offsetID = i;
			//trace("currID : "+currID+", offsetID : "+offsetID);
			timerHandler(new TimerEvent(""));
			//stop();
		}

		public override function nextFrame():void
		{
			var i:int = currID + 1;
			if (i == _nbImg) {
				i = 0;
			}
			gotoFrame(i);
		}

		public override function prevFrame():void
		{
			var i:int = currID - 1;
			if (i == -1) {
				i = _nbImg - 1;
			}
			gotoFrame(i);
		}

		public function reset():void
		{
			containers = new Array();
			loaders = new Array();

			paths = new Array();
			positions = new Array();
			texts = new Array();
			times = new Array();
			moves = new Array();
			
			while (this.numChildren) this.removeChildAt(0);
			_nbImg = 0;
		}





		//_______________________________________________________________________________
		//private functions


		private function timerHandler(e:TimerEvent)
		{
			trace("timerHandler");
			
			if (timer != null) {
				timer.stop();
				timer.removeEventListener("timer", timerHandler);
			}
			trace("times["+currID+"] : "+times[currID]+", speed_display : "+speed_display);
			var time_next:Number = (times[currID]!=0) ? times[currID] : speed_display;
			timer = new Timer(time_next);
			timer.addEventListener("timer", timerHandler);
			if (_nbImg > 1) {
				timer.start();
			}
			
			
			//if (loader == null) loader = new Loader();
			if (loaders[currID] == null) {
				loaders[currID] = new Loader();
			}
			loader = loaders[currID];
			
			loader.load(new URLRequest(paths[currID]));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
		}
		
		private function onIoError(e:IOErrorEvent):void 
		{
			trace("IoError : couldn't load file "+e.target.url)
		}

		private function onImgLoaded(e:Event):void
		{
			trace("Diaporama.onImgLoaded");
			
			var dobj:Bitmap = loader.content as Bitmap;
			//trace("dobj : " + dobj + ", typeof dobj : " + typeof dobj);
			
			if (!dobj is Bitmap && !dobj is MovieClip) return;
			if(dobj is Bitmap) dobj.smoothing = true;
			
			
			
			
			if (_resize != RESIZE_NONE) {
				if (force_stage_dims) {
					dobj.width = stage_width;
					dobj.height = stage_height;
				}
				else {
					dobj.width = stage.stageWidth;
					dobj.height = stage.stageHeight;
				}

				if ((dobj.scaleX > dobj.scaleY) == (_resize==RESIZE_FIT)) {
					dobj.scaleY = dobj.scaleX;
				}
				else {
					dobj.scaleX = dobj.scaleY;
					
				}


			}
			if (currID == offsetID && countLoop == 0) {
				dispatchEvent(new DiapoEvent(DiapoEvent.FIRST_IMG_LOADED));
			}
			if (currID == 0 && countLoop > 0) {
				dispatchEvent(new DiapoEvent(DiapoEvent.END_LOOP));
			}
			if (countLoop > 0 && ! play_loop) {
				timer.stop();
			}
			if (play_loop || countLoop == 0) {
				//trace("containers["+currID+"].numChildren : "+containers[currID].numChildren);


				if (containers[currID].numChildren == 0) {
					containers[currID].addChild(loader);
				}

				//trace("fadeIn prevID : "+prevID+", currID : "+currID);
				fadeIn(currID);
				if (prevID != -1) {
					fadeOut(prevID);
				}

				//dispatch event
				var de:DiapoEvent = new DiapoEvent(DiapoEvent.DISPLAY_IMG);
				de.id_image = currID;
				de.text = texts[currID];
				dispatchEvent(de);

				//containers[currID].disable();
				moveX(currID);
				moveY(currID);
				prevID = currID;
				currID++;
				if (currID == _nbImg) {
					currID = 0;
					countLoop++;
				}
			}
		}
		
		private function fadeIn(id:int)
		{
			if (tw1 != null && tw1.isPlaying) tw1.stop();
			tw1 = new Tween(containers[id],"alpha",Regular.easeInOut,containers[id].alpha,alpha_in,speed_fadein,true);
		}
		
		private function fadeOut(id:int)
		{
			if (tw2 != null && tw2.isPlaying) tw2.stop();
			tw2 = new Tween(containers[id],"alpha",Regular.easeInOut,containers[id].alpha,alpha_out,speed_fadeout,true);
		}
		
		
		private function moveX(id:int)
		{
			var time:Number = times[id] / 1000 + speed_fadeout;
			if (moves[id].x != 0) {
				twx = new Tween(containers[id],"shiftX",None.easeIn,positions[id].x,positions[id].x + moves[id].x,time,true);
			}
		}
		private function moveY(id:int)
		{
			var time:Number = times[id] / 1000 + speed_fadeout;
			if (moves[id].y != 0) {
				twy = new Tween(containers[id],"shiftY",None.easeIn,positions[id].y,positions[id].y + moves[id].y,time,true);
			}
		}








		//_______________________________________________________________________________
		//events handler
	}

}