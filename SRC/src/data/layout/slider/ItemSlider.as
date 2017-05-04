/*
CONTRAINTES : 
- les items doivent tous avoir la meme dimensions (largeur si mode HORIZONTAL, hauteur si mode VERTICAL)
- joue sur la propriété alpha des elements, il faut donc ne pas y toucher afin d'éviter les conflits


EXAMPLE : 
voir examples/ItemSlider.fla



//PROPRIETES :
align      			(ItemSlider.START, ItemSlider.CENTER, ItemSlider.END) (defaut : CENTER)
effect				tween utilisée (defaut : Regular.easeOut)
timeslide			temps (en seconde) pour un slide
alphaout			valeur d'alpha d'un element hors du champ de vision


//METHODES :
prev();
next();


*/


package data.layout.slider{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;
	
	import data.layout.slider.ItemSliderEvent;
	
	
	public class ItemSlider extends Sprite{
		
		//params
		
		
		//private vars
		var items:Array;
		var nbitem:int;
		var mode:String;
		var _width:Number;
		var _height:Number;
		var delta:Number;
		var _mask:Sprite;
		var _fade:Boolean = true;
		
		var cur_index:int;
		var old_index:int;
		var tw:Tween;
		var tw_alpha_in, tw_alpha_out:Tween;
		var container:Sprite;
		var _positionProperty:String;
		var block_prev, block_next:Boolean;
		var itemsize:Number;
		var dimension:Number;
		
		//params
		var nbdisplay:int;
		var _timeslide:Number;
		var _effect:Function;
		var _alphaout:Number;
		var _align:String;
		
		var _btnprev:InteractiveObject;
		var _btnnext:InteractiveObject;
		var _step:int;
		
		
		
		
		//constantes
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		
		public static const START:String = "start";
		public static const CENTER:String = "center";
		public static const END:String = "end";
		
		
		
		
		//_______________________________________________________________
		//public functions
		
		public function ItemSlider(_nbdisplay:int, __width:Number, __height:Number, _itemsize:Number, _mode:String = "horizontal") 
		{ 
			nbdisplay = _nbdisplay;
			_timeslide = 0.5;
			_effect = Regular.easeOut;
			_align = CENTER;
			_alphaout = 0;
			itemsize = _itemsize;
			
			
			if(_mode!=HORIZONTAL && _mode!=VERTICAL) throw new Error("mode param must be "+HORIZONTAL+" or "+VERTICAL);
			mode = _mode;
			_width = __width;
			_height = __height;
			_step = 1;
			
			_positionProperty = (_mode=="horizontal") ? "x" : "y";
			dimension = (_mode=="horizontal") ? _width : _height;
			delta = dimension / nbdisplay;
			if (nbdisplay > 1) delta += (delta - _itemsize) / (nbdisplay - 1);
			
			//trace("delta : " + delta);
			
			_mask = new Sprite();
			var g:Graphics = _mask.graphics;
			g.clear();
			g.beginFill(0xaa0000, 0.0);
			g.drawRect(0, 0, _width, _height);
			
			
			container = new Sprite();
			super.addChild(container);
			container.mask = _mask;
			
			cur_index = 0;
			block_prev = false;
			block_next = false;
			
			reset();
			
		}
		
		public function reset():void
		{
			items = new Array();
			nbitem = 0;
			while(container.numChildren) container.removeChildAt(0);
		}
		
		
		public override function addChild(d:DisplayObject):DisplayObject
		{
			items.push(d);
			d[_positionProperty] = nbitem * delta;
			nbitem++;
			return container.addChild(d);
		}
		
		public function get length():uint
		{
			return items.length;
		}
		
		public function next():void
		{
			old_index = cur_index;
			cur_index -= _step;
			goto_(cur_index);
			//trace("   "+cur_index+", "+block_next);
			handleBlock();
			
		}
		
		public function prev():void
		{
			old_index = cur_index;
			cur_index += _step;
			goto_(cur_index);
			handleBlock();
		}
		
		public function init():void
		{
			super.addChild(_mask);
			handleBlock();
			if(nbitem <= nbdisplay){
				block_next = true;
				dispatchEvent(new ItemSliderEvent(ItemSliderEvent.NEXT_DISABLE));
				block_prev = true;
				dispatchEvent(new ItemSliderEvent(ItemSliderEvent.PREV_DISABLE));
				
				
				if(nbitem < nbdisplay && nbitem>0){
					
					var size_total:Number = itemsize + (nbitem-1)*delta;
					
					var _offset:Number;
					if(_align==START) _offset = 0;
					else if(_align==CENTER) _offset = dimension/2 - size_total / 2;	//center moins moitié de la taille totale
					else if(_align==END) _offset = dimension - itemsize;
					var _sens:int = (_align==END) ? -1 : 1;
					
					for(var i:int=0;i<nbitem;i++){
						items[i][_positionProperty] = i * delta * _sens + _offset;
					}
				}
				
			}
			updateVisibleItem();
		}
		
		
		public function setBtnNavigation(__btnprev:InteractiveObject, __btnnext:InteractiveObject):void
		{
			_btnprev = __btnprev;
			_btnnext = __btnnext;
			
			this.addEventListener(ItemSliderEvent.PREV_DISABLE, onPrevDisabled);
			this.addEventListener(ItemSliderEvent.PREV_ENABLE, onPrevEnabled);
			this.addEventListener(ItemSliderEvent.NEXT_DISABLE, onNextDisabled);
			this.addEventListener(ItemSliderEvent.NEXT_ENABLE, onNextEnabled);
			
			_btnprev.addEventListener(MouseEvent.CLICK, onClickPrev);
			__btnnext.addEventListener(MouseEvent.CLICK, onClickNext);
		}
		
		
		
		
		
		//_______________________________________________________________
		//setters
		
		
		
		public function set timeslide(v:Number):void
		{
			_timeslide = v;
		}
		
		public function set effect(v:Function):void
		{
			_effect = v;
		}
		
		public function set align(v:String):void
		{
			if(v!=START && v!=CENTER && v!=END) throw new Error("possible values for property ItemSlider.align are "+START+", "+CENTER+" and "+END);
			_align = v;
		}
		
		public function set alphaout(v:Number):void
		{
			_alphaout = v;
		}
		
		public function get index():int
		{
			return cur_index;
		}
		
		public function set step(value:int):void 
		{
			_step = value;
		}
		
		public function set fade(value:Boolean):void 
		{
			_fade = value;
		}
		
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		public function goto_(i:int):void
		{
			for (var j:int = 0; j < nbitem; j++) items[j].visible = true;
			//trace("goto_(" + i + ")");
			//trace("if(" + i + ">0 || " + i + "< " + ( -nbitem + nbdisplay) + ")");
			
			
			//if(i>0 || i< -nbitem + nbdisplay) throw new Error("index "+i+" is out of bounds ["+(-nbitem + nbdisplay)+", 0]");
			//trace("    goto : "+i);
			var _dest:Number = i * delta;
			tw = new Tween(container, _positionProperty, _effect, container[_positionProperty], _dest, _timeslide, true);
			tw.addEventListener(TweenEvent.MOTION_FINISH, onTweenFinish);
			
			for(j=0;j<nbitem;j++){
				if(_fade && isGoingOut(j)) fadeout(j);
				if(_fade && isGoingIn(j)) fadein(j);
			}
			
		}
		
		
		private function handleBlock():void
		{
			trace("cur_index : "+cur_index+", nbdisplay : "+nbdisplay);
			if(!block_next && cur_index <= -nbitem+nbdisplay){
				block_next = true;
				dispatchEvent(new ItemSliderEvent(ItemSliderEvent.NEXT_DISABLE));
			}
			else if(block_next && cur_index >= -nbitem+nbdisplay+1){
				block_next = false;
				dispatchEvent(new ItemSliderEvent(ItemSliderEvent.NEXT_ENABLE));
			}
			
			if(!block_prev && cur_index >= 0){
				block_prev = true;
				dispatchEvent(new ItemSliderEvent(ItemSliderEvent.PREV_DISABLE));
			}
			else if(block_prev && cur_index <= -1){
				block_prev = false;
				dispatchEvent(new ItemSliderEvent(ItemSliderEvent.PREV_ENABLE));
			}
		}
		
		
		private function isVisible(i:int, _curind:int):Boolean
		{
			var j:int = i + _curind;
			if(j>=0 && j<nbdisplay) return true;
			else return false;
		}
		
		private function isGoingOut(i):Boolean
		{
			if(isVisible(i, old_index) && !isVisible(i, cur_index)) return true;
			return false;
		}
		
		private function isGoingIn(i):Boolean
		{
			if(!isVisible(i, old_index) && isVisible(i, cur_index)) return true;
			return false;
		}
		
		
		private function updateVisibleItem():void
		{
			for(var i:int=0;i<nbitem;i++){
				if (isVisible(i, cur_index)) {
					items[i].visible = true;
					if (!_fade) items[i].alpha = 1.0;
					
				}
				else {
					/*
					items[i].visible = false;
					items[i].alpha = 0;
					*/
					if (true) {
						if (items[i].x < 0) items[i].x += nbitem * dimension;
					}
				}
			}
		}
		
		private function fadein(i:int):void
		{
			tw_alpha_in = new Tween(items[i], "alpha", _effect, _alphaout, 1, _timeslide, true);
		}
		
		private function fadeout(i:int):void
		{
			tw_alpha_out = new Tween(items[i], "alpha", _effect, 1, _alphaout, _timeslide, true);
		}
		
		
		
		
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
		private function onTweenFinish(e:TweenEvent):void
		{
			updateVisibleItem();
			
			
			
		}
		
		
		private function onPrevDisabled(e:ItemSliderEvent):void 
		{
			if (_btnprev != null) {
				_btnprev.mouseEnabled = false;
				if(_btnprev is DisplayObjectContainer) DisplayObjectContainer(_btnprev).mouseChildren = false;
			}
		}
		
		private function onPrevEnabled(e:ItemSliderEvent):void 
		{
			if (_btnprev != null) _btnprev.mouseEnabled = true;
			if(_btnprev is DisplayObjectContainer) DisplayObjectContainer(_btnprev).mouseChildren = true;
		}
		
		private function onNextDisabled(e:ItemSliderEvent):void 
		{
			if (_btnnext != null) _btnnext.mouseEnabled = false;
			if(_btnnext is DisplayObjectContainer) DisplayObjectContainer(_btnnext).mouseChildren = false;
		}
		
		private function onNextEnabled(e:ItemSliderEvent):void 
		{
			if (_btnnext != null) _btnnext.mouseEnabled = true;
			if(_btnnext is DisplayObjectContainer) DisplayObjectContainer(_btnnext).mouseChildren = true;
		}
		
		
		private function onClickPrev(e:MouseEvent):void 
		{
			this.prev();
		}
		
		private function onClickNext(e:MouseEvent):void 
		{
			this.next();
		}
		
	}
	
}