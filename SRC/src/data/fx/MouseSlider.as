/*
import data.fx.MouseSlider;
var mouseslider:MouseSlider = new MouseSlider(stage, scrollX:Boolean, scrollY:Boolean);	
mouseslider.addChild(mc);		//pour inscrire les displayObject au scrolling
								//on peut mettre un true en 2eme param pour indiquer que ce displayObject
								//sera utilisé pour contraindre les scroll a la taille de la scene

mouseslider.relativeSpeed = true;	//indique si la vitesse de scrolling sera relative ou constante (defaut:true)
mouseslider.freezoneY = 50;		//détermine une taille de zone pour laquelle il n'y aura pas de scrolling (centrée sur la scene)
mouseslider.speedmaxY = 10;		//speed max (qd la souris est à l'extrémité)

*/

package data.fx {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	
	public class MouseSlider {
		
		
		var list_dobj:Array;
		var len_array:int = 0;
		public var scrollX:Boolean;
		public var scrollY:Boolean;
		var st:Stage;
		
		var stageWidth:Number;
		var stageHeight:Number;
		var dobj_block:DisplayObject = null;
		var block:Boolean = false;
		var rect_shift:Rectangle;
		var rect_block:Rectangle;
		var mouseOver:Boolean;
		var _useWheel = false;
		var deltaWheel = 0;
		var speedWheel:Number;
		var bWheelUsed:Boolean;
		
		//propriétés par defaut
		public var speedmaxX:Number = 1;
		public var speedmaxY:Number = 4;
		
		public var freezoneX:Number = 0;
		public var freezoneY:Number = 0;
		public var relativeSpeed:Boolean = true;
		
		
		
		
		
		
		
		
		public function MouseSlider(_stage:Stage, _scrollX:Boolean, _scrollY:Boolean, _stageOver:Boolean=true) 
		{ 
			//trace("constructeur mouseslider");
			_stage.addEventListener(Event.ENTER_FRAME, onEnterframe);
			st = _stage;
			if(_stageOver){
				_stage.addEventListener(Event.MOUSE_LEAVE, onMouseOut);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
				mouseOver = false;
			}
			else mouseOver = true;
			
			list_dobj = new Array();
			rect_shift = new Rectangle();
			rect_block = new Rectangle();
			scrollX = _scrollX;
			scrollY = _scrollY;
			stageWidth = _stage.stageWidth;
			stageHeight = _stage.stageHeight;
			bWheelUsed = false;
			
			//trace("stage dim : "+stageWidth+", "+stageHeight);
		}
		
		public function addChild(_dobj:DisplayObject, _block:Boolean=true):void
		{
			list_dobj.push(_dobj);
			len_array++;
			block = _block;
			if(_block) dobj_block = _dobj;
		}
		
		public function setRectDelta(left:Number, top:Number, right:Number, bottom:Number):void
		{
			rect_shift.left = left;
			rect_shift.top = top;
			rect_shift.right = right;
			rect_shift.bottom = bottom;
		}
		
		public function setRectBlock(left:Number, top:Number, right:Number, bottom:Number):void
		{
			rect_block.left = left;
			rect_block.top = top;
			rect_block.right = right;
			rect_block.bottom = bottom;
		}
		
		public function useWheel(speed:Number=5):void
		{
			speedWheel = speed;
			_useWheel = true;
			st.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		
		
		
		
		private function onEnterframe(e:Event):void
		{
			var mousex:Number = e.currentTarget.mouseX;
			var mousey:Number = e.currentTarget.mouseY;
			
			var blockwidth:Number = rect_block.right - rect_block.left;
			var blockheight:Number = rect_block.bottom - rect_block.top;
			
			
			var x_overflow:Boolean = (list_dobj[i].width+rect_shift.left+rect_shift.right > blockwidth);
			var y_overflow:Boolean = (list_dobj[i].height + rect_shift.top + rect_shift.bottom > blockheight);
			
			
			//gestion déplacement
			if(mouseOver){
				for(var i:int=0;i<len_array;i++){
					if (!bWheelUsed) {
						if(scrollX && x_overflow){
							list_dobj[i].x -= getDelta(stageWidth, freezoneX, mousex, speedmaxX, "x");
						}
						if(scrollY && y_overflow){
							list_dobj[i].y -= getDelta(stageHeight, freezoneY, mousey, speedmaxY, "y");
						}
					}
					else{
						list_dobj[i].y += deltaWheel * speedWheel;
						deltaWheel = 0;
					}
				}
			}
			
			//gestion du blockage
			if(block){
				var _x:Number = dobj_block.x;
				var _y:Number = dobj_block.y;
				var _width:Number = dobj_block.width + rect_shift.right;
				var _height:Number = dobj_block.height + rect_shift.bottom;
				
				var startx:Number = rect_block.left;
				var starty:Number = rect_block.top;
				var endx:Number = rect_block.right;
				var endy:Number = rect_block.bottom;
				
				
				if(scrollX){
					if(x_overflow){
						if(_x>startx) dobj_block.x = startx;
						if(_x+_width<endx) dobj_block.x = endx-_width;
					}
					else{	//si on est pas en overflow, on colle l'item a l'offset
						dobj_block.x = startx;
					}
				}
				
				if(scrollY){
					if(y_overflow){
						if(_y>starty) dobj_block.y = starty;
						if(_y+_height<endy){
							//trace("_height : "+_height+", dobj_block.height : "+dobj_block.height+", _y : "+_y+", endy : "+endy);
							dobj_block.y = endy-_height;
						}
					}
					else{	//si on est pas en overflow, on colle l'item a l'offset
						dobj_block.y = starty;
					}
				}
			}
		}
		
		private function getDelta(stagedim:Number, freezone:Number, mousepos:Number, speedmax:Number, coord:String):Number
		{
			var eccart:Number;
			var delta:Number;
			var etendue:Number;
			
			etendue = stagedim/2 - freezone/2;
			eccart = mousepos - etendue;
			if(eccart>0) eccart -= freezone;
			if(mousepos>etendue && mousepos<stagedim-etendue) eccart = 0;
			if(relativeSpeed) delta = eccart * (speedmax/etendue);
			else{
				if(eccart<0) delta = -speedmax;
				else if(eccart>0) delta = speedmax;
				else if(eccart==0) delta = 0;
			}
			return delta;
		}
		
		private function onMouseOut(e:Event)
		{
			mouseOver = false;
			bWheelUsed = false;
		}
		private function onMouseOver(e:MouseEvent)
		{
			mouseOver = true;
		}
		
		private function onMouseWheel(e:MouseEvent)
		{
			//trace("onMouseWheel "+e.delta);
			deltaWheel = e.delta;
			bWheelUsed = true;
		}
	}
	
}