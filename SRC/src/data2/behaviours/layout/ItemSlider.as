/*
   CONTRAINTES :
   - les childrens doivent tous avoir la meme dimensions (largeur si mode HORIZONTAL, hauteur si mode VERTICAL)
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



   SpriteSet
   #btn_prev
   #btn_next


 */

package data2.behaviours.layout
{
	
	import data.fx.transitions.TweenManager;
	import data2.behaviours.Behaviour;
	import data2.InterfaceSprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;
	
	import data.layout.slider.ItemSliderEvent;
	
	public class ItemSlider extends Behaviour
	{
		
		//params
		
		//private vars
		private var nbitem:int;
		private var delta:Number;
		
		private var cur_index:int;
		private var old_index:int;
		private var tw:Tween;
		private var tw_alpha_in:Tween;
		private var tw_alpha_out:Tween;
		private var _positionProperty:String;
		private var block_prev, block_next:Boolean;
		private var _width:Number;
		private var _height:Number;
		private var _position:int;
		
		
		
		private var twm:TweenManager = new TweenManager();
		
		//params
		private var _mode:String;
		private var _nbdisplay:int;
		private var _itemsize:Number;
		private var _align:String;
		private var _timeslide:Number;
		private var _effect:Function;
		private var _alphaout:Number;
		private var _step:int;
		private var _maxposition:int;
		
		private var _btnprev:InteractiveObject;
		private var _btnnext:InteractiveObject;
		private var binit:Boolean = false;
		
		private var _touchMode:Boolean;
		
		
		
		
		//constantes
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		
		public static const START:String = "start";
		public static const CENTER:String = "center";
		public static const END:String = "end";
		
		//_______________________________________________________________
		//public functions
		
		public function ItemSlider()
		{
			_mode = HORIZONTAL;
			_nbdisplay = 3;
			_align = CENTER;
			_timeslide = 0.4;
			_effect = Regular.easeOut;
			_alphaout = 0;
			_step = 1;
			_position = 0;
			_touchMode = false;
		}
		
		public function next():void
		{
			if ((cur_index - _step) > 0 || (cur_index - _step) < -nbitem + _nbdisplay) {
				return;
			}
			
			trace("next : " + old_index + ", " + cur_index + ", " + _step);
			old_index = cur_index;
			cur_index -= _step;
			goto_(cur_index);
			//trace("   "+cur_index+", "+block_next);
			handleBlock();
		
		}
		
		public function prev():void
		{
			if ((cur_index + _step) > 0 || (cur_index + _step) < -nbitem + _nbdisplay)
				return;
			
			old_index = cur_index;
			cur_index += _step;
			goto_(cur_index);
			handleBlock();
		}
		
		override public function init():void
		{
			trace("ItemSlider.init");
			binit = true;
			
			if (isNaN(_itemsize)) throw new Error("you must set \"itemsize\" property");
			if (isNaN(_nbdisplay)) throw new Error("you must set \"nbdisplay\" property");
			
			if (_mode == HORIZONTAL) {
				if (isNaN(_width)) throw new Error("you must set \"width\" property");
				if (isNaN(_height)) _height = 200;
			}
			if (_mode == VERTICAL) {
				if (isNaN(_height)) throw new Error("you must set \"height\" property");
				if (isNaN(_width)) _width = 200;
			}
			
			var _dimension:Number = (_mode == HORIZONTAL) ? _width : _height;
			
			cur_index = - _position;
			block_prev = true;
			block_next = false;
			
			_positionProperty = (_mode == HORIZONTAL) ? "x" : "y";
			
			if (_nbdisplay == 1) delta = _dimension;
			else{
				delta = _dimension / _nbdisplay;
				delta += (delta - _itemsize) / (_nbdisplay - 1);
			}
			
			this.addEventListener(ItemSliderEvent.PREV_DISABLE, onPrevDisabled);
			this.addEventListener(ItemSliderEvent.PREV_ENABLE, onPrevEnabled);
			this.addEventListener(ItemSliderEvent.NEXT_DISABLE, onNextDisabled);
			this.addEventListener(ItemSliderEvent.NEXT_ENABLE, onNextEnabled);
			
			
			//trace("_width --- " + _width + ", "+_height);
			trace("_interfaceSprite.maskDef " + _width + ", " + _height);
			_interfaceSprite.maskDef = "0,0," + _width + "," + _height;
			
			
			
			if(_touchMode){
				_interfaceSprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownTouch);
				//_interfaceSprite.addEventListener(MouseEvent.MOUSE_UP, onMouseUpTouch);
				_interfaceSprite.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpTouch);
				_interfaceSprite.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveTouch);
			}
		}
		
		
		
		
		override public function update():void
		{
			trace("ItemSlider.update");
			if (childrens == null) return;
			
			nbitem = childrens.length;
			position = _position;
			_maxposition = nbitem - _nbdisplay;
			
			if(_btnprev != null) enableBtn(_btnprev, true);
			if(_btnnext != null) enableBtn(_btnnext, true);
			init();
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
			if (v != START && v != CENTER && v != END)
				throw new Error("possible values for property ItemSlider.align are " + START + ", " + CENTER + " and " + END);
			_align = v;
		}
		
		public function set alphaout(v:Number):void{_alphaout = v;}
		
		public function get index():int{return cur_index;}
		/*
		public function set step(value:int):void{_step = value;}
		*/
		
		
		public function set nbdisplay(value:int):void {_nbdisplay = value;}
		
		public function set mode(value:String):void {_mode = value;}
		
		public function set btnprev(value:InteractiveObject):void 
		{
			_btnprev = value;
			_btnprev.addEventListener(MouseEvent.CLICK, onClickPrev);
		}
		
		public function set btnnext(value:InteractiveObject):void 
		{
			_btnnext = value;
			_btnnext.addEventListener(MouseEvent.CLICK, onClickNext);
		}
		
		public function set itemsize(value:Number):void {_itemsize = value;}
		
		public function set height(value:Number):void {_height = value;}
		
		public function set width(value:Number):void {_width = value;}
		
		
		public function get maxposition():int {return _maxposition;}
		
		public function get position():int { return _position; }
		
		public function set position(i:int):void
		{
			trace("set position(" + i + ")");
			_position = i;
			goto_(-_position);
			
		}
		
		public function get length():int
		{
			return childrens.length;
		}
		
		
		public function set touchMode(value:Boolean):void { _touchMode = value; }
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		
		public function goto_(i:int, _mulitpliertime:Number=1):void
		{
			//if (i > 0 || i < -nbitem + _nbdisplay) return;
			
			trace("ItemSlider.goto " + i);
			//old_index = cur_index;
			var _evt:ItemSliderEvent = new ItemSliderEvent(ItemSliderEvent.GOTO);
			_evt.index = -i;
			this.dispatchEvent(_evt);
			
			cur_index = i;
			if (!binit) return;
			
			for (var j:int = 0; j < nbitem; j++)
				childrens[j].visible = true;
			//trace("    goto : "+i);
			
			var _begin:Number = DisplayObject(childrens[0])[_positionProperty];
			var _dest:Number = i * delta;
			
			for (j = 0; j < nbitem; j++)
			{
				var _child:DisplayObject = DisplayObject(childrens[j]);
				var _begin2:Number = _begin + j * delta;
				var _dest2:Number = _dest + j * delta;
				//trace(" -- _child " + j + " : go from " + _begin2 + ", " + _dest2 + ", in timeslide sec");
				
				var _t:Number = _timeslide / _mulitpliertime;
				twm.tween(_child, _positionProperty, _begin2, _dest2, _t, 0, _effect);
			}
			twm.addTweenListener(onTweenFinish);
			
			
			for (j = 0; j < nbitem; j++)
			{
				if (isGoingOut(j)) {
					fadeout(j);
					disableClickable(j, false);
				}
				if (isGoingIn(j)){
					fadein(j);
					disableClickable(j, true);
				}
			}
			
		}
		
		
		public function handleBlock():void
		{
			trace("block_next : "+block_next+", block_prev : "+block_prev+", cur_index : " + cur_index + ", _nbdisplay : " + _nbdisplay);
			if (!block_next && cur_index <= -nbitem + _nbdisplay)
			{
				block_next = true;
				dispatchEvent(new ItemSliderEvent(ItemSliderEvent.NEXT_DISABLE));
			}
			else if (block_next && cur_index >= -nbitem + _nbdisplay + 1)
			{
				block_next = false;
				dispatchEvent(new ItemSliderEvent(ItemSliderEvent.NEXT_ENABLE));
			}
			
			if (!block_prev && cur_index >= 0)
			{
				block_prev = true;
				dispatchEvent(new ItemSliderEvent(ItemSliderEvent.PREV_DISABLE));
			}
			else if (block_prev && cur_index <= -1)
			{
				block_prev = false;
				dispatchEvent(new ItemSliderEvent(ItemSliderEvent.PREV_ENABLE));
			}
		}
		
		private function isVisible(i:int, _curind:int):Boolean
		{
			var j:int = i + _curind;
			if (j >= 0 && j < _nbdisplay)
				return true;
			else
				return false;
		}
		
		private function isGoingOut(i):Boolean
		{
			if (isVisible(i, old_index) && !isVisible(i, cur_index))
				return true;
			return false;
		}
		
		private function isGoingIn(i):Boolean
		{
			if (!isVisible(i, old_index) && isVisible(i, cur_index))
				return true;
			return false;
		}
		
		private function updateVisibleItem():void
		{
			for (var i:int = 0; i < nbitem; i++)
			{
				if (isVisible(i, cur_index)){
					childrens[i].visible = true;
					disableClickable(i, true);
				}
				else
				{
					if (!_touchMode) {
						childrens[i].visible = false;
						childrens[i].alpha = 0;
					}
					disableClickable(i, false);
				}
			}
		}
		
		private function disableClickable(_index:int, boolean:Boolean):void 
		{
			var _dobj:DisplayObject = DisplayObject(childrens[_index]);
			if (_dobj is InteractiveObject) InteractiveObject(_dobj).mouseEnabled = boolean;
		}
		
		private function fadein(i:int):void
		{
			tw_alpha_in = new Tween(childrens[i], "alpha", _effect, _alphaout, 1, _timeslide, true);
		}
		
		private function fadeout(i:int):void
		{
			tw_alpha_out = new Tween(childrens[i], "alpha", _effect, 1, _alphaout, _timeslide, true);
		}
		
		private function enableBtn(_btn:InteractiveObject, _value:Boolean):void
		{
			_btn.mouseEnabled = _value;
			if (_btn is DisplayObjectContainer)
				DisplayObjectContainer(_btn).mouseChildren = _value;
		}
		
		
		
		//_______________________________________________________________
		//events handlers
		
		private function onTweenFinish(e:TweenEvent):void
		{
			updateVisibleItem();
		}
		
		private function onPrevDisabled(e:ItemSliderEvent):void
		{
			if (_btnprev == null) return;
			enableBtn(_btnprev, false);
			
		}
		
		private function onPrevEnabled(e:ItemSliderEvent):void
		{
			if (_btnprev == null) return;
			enableBtn(_btnprev, true);
		}
		
		private function onNextDisabled(e:ItemSliderEvent):void
		{
			if (_btnnext == null) return;
			enableBtn(_btnnext, false);
		}
		
		private function onNextEnabled(e:ItemSliderEvent):void
		{
			if (_btnnext == null) return;
			enableBtn(_btnnext, true);
		}
		
		
		
		private function onClickPrev(e:MouseEvent):void
		{
			trace("onClickPrev");
			this.prev();
		}
		
		private function onClickNext(e:MouseEvent):void
		{
			trace("onClickNext");
			this.next();
		}
		
		
		
		
		
		
		
		
		
		//_________________________________________________________________
		//touch mode
		
		
		private var _touchPosition:Number;
		private var _touchPositionInit:Number;
		private var _touchMouseDown:Boolean = false;
		private var _savePosMouse:Number = 0;
		private var _posmouseProp:Number;
		
		private function onMouseDownTouch(e:MouseEvent):void 
		{
			trace("ItemSlider.onMouseDownTarget");
			_touchPosition = (_mode == HORIZONTAL) ? _interfaceSprite.mouseX : _interfaceSprite.mouseY;
			_touchPositionInit = DisplayObject(childrens[0])[_positionProperty];
			_touchMouseDown = true;
			
			e.stopPropagation();
		}
		
		
		private function onMouseUpTouch(e:MouseEvent):void 
		{
			if (!_touchMouseDown) return;
			trace("ItemSlider.onMouseUpTarget");
			_touchMouseDown = false;
			
			var _posmouse:Number = (_mode == HORIZONTAL) ? _interfaceSprite.mouseX : _interfaceSprite.mouseY;
			var _deltamouse:Number = _posmouse - _savePosMouse;
			//trace("_deltamouse : " + _deltamouse);
			_deltamouse *= 20;
			
			var _maxdelta:Number = delta * 0.6;
			if (Math.abs(_deltamouse) > _maxdelta) {
				if (_deltamouse < 0) _deltamouse = -_maxdelta;
				else _deltamouse = _maxdelta;
			}
			
			var _curpos:Number = DisplayObject(childrens[0])[_positionProperty] + _deltamouse;
			var _diffmin:Number = 9999;
			var _selectedIndex:int;
			for (var i:int = 0; i < nbitem; i++) 
			{
				var _pos:Number = delta * -i;
				var _diff:Number = Math.abs(_curpos - _pos);
				//trace("_pos : " + _pos);
				if (_diff < _diffmin) {
					_diffmin = _diff;
					_selectedIndex = i;
				}
				
			}
			
			var _multiplierTime:Number = 1 + Math.abs(_deltamouse) / (80 / 2);
			if (_multiplierTime > 3) _multiplierTime = 3;
			
			trace("_selectedIndex : " + _selectedIndex);
			goto_( -_selectedIndex, _multiplierTime);
			handleBlock();
		}
		
		
		private function onMouseMoveTouch(e:MouseEvent):void 
		{
			if (_touchMouseDown) {
				//trace("onMouseMoveTarget");
				
				_savePosMouse = _posmouseProp;
				_posmouseProp = (_mode == HORIZONTAL) ? _interfaceSprite.mouseX : _interfaceSprite.mouseY;
				var _deltamouse:Number = _posmouseProp - _touchPosition;
				var _newpos:Number = _touchPositionInit + _deltamouse;
				
				for (var j:int = 0; j < nbitem; j++)
				{
					var _child:DisplayObject = DisplayObject(childrens[j]);
					var _pos:Number = _newpos + j * delta;
					//trace(" -- _child " + j + " : go from " + _begin2 + ", " + _dest2 + ", in timeslide sec");
					_child[_positionProperty] = _pos;
				}
			}
		}
		
	
	}

}