package data2.behaviours.layout 
{
	import data2.behaviours.Behaviour;
	import data2.layoutengine.LayoutEngine;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class HLayout extends Behaviour
	{
		private var _interline:Number;
		private var _dx:Number;
		private var _width:Number;
		private var _align:String;
		private var _itemwidth:Number;
		private var _childrens2use:Array;
		
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const CENTER:String = "center";		//todo
		public static const JUSTIFY:String = "justify";		//todo
		
		
		
		public function HLayout() 
		{
			//reset();
			_interline = 0;
			align = LEFT;
		}
		
		
		
		
		
		override public function update():void
		{
			var _cumulX:int = 0;
			var _cumulY:int = 0;
			var _space:int;
			var cur_width:int;
			var prev_width:int;
			var total_width:Number;
			var delta:Number;
			var space:Number;
			var cumul:Number;
			
			if (childrens == null) return;
			
			
			//définit les espaces avec les spacers
			_childrens2use = new Array();
			
			var _spacervalues:Array = new Array();
			var _len:int = childrens.length;
			
			for (var j:int = 0; j < _len; j++) _spacervalues.push(0);
			
			for (var j:int = 0; j < _len; j++) 
			{
				if (!(childrens[j] is Spacer)) {
					_childrens2use.push(childrens[j]);
				}
				else {
					var _spacer:Spacer = Spacer(childrens[j]);
					var _index:int = _childrens2use.length - 1;
					if (_index < 0) throw new Error("you can't set a Spacer a the first index of HLayout");
					_spacervalues[_index] = _spacer.value;
				}
			}
			
			
			
			var num_dobj:int = _childrens2use.length;
			
			var list_width:Array = new Array();
			for (var i:int = 0; i < num_dobj; i++) {
				
				
				var w:Number;
				if (!isNaN(_itemwidth)) w = _itemwidth;
				else {
					
					var _dims:Point = LayoutEngine.getObjectDimensions(_childrens2use[i]);
					w = _dims.x;
					//w = _childrens2use[i].width;
					w += _spacervalues[i];
				}
				
				list_width.push(w);
			}
			
			
			//justify
			
			if (_align == JUSTIFY) {
				//todo : a refaire, doit surement bugger
				
				if (isNaN(_width)) throw new Error("you need to set width if using justify align");
				total_width = 0;
				for(var i:int=0;i<num_dobj;i++){
					total_width += _childrens2use[i];
				}
				delta = _width - total_width;
				space = delta / (num_dobj-1);
				cumul = 0;
				for (i = 0; i < num_dobj; i++) {
					setItemX(_childrens2use[i], cumul);
					cumul += list_width[i] + space;
				}
			}
			
			//left/right
			else if (_align == RIGHT || _align == LEFT || _align == CENTER) {
				
				var _indexNewlines:Array = new Array();
				_indexNewlines.push(0);
				
				for(i=0;i<num_dobj;i++){
					
					if(i==0) _space = 0;
					else _space = _dx;
					
					cur_width = list_width[i];
					prev_width = (i>0) ? list_width[i-1] : 0;
					
					_cumulX += _space;
					if(i>0) _cumulX += prev_width;
					
					//new line
					if(!(isNaN(_width))){
						if(_cumulX + cur_width > _width){
							_space = 0;
							_cumulX = _space;
							_cumulY = getLowestItem(i) + _interline;
							_indexNewlines.push(i);
						}
					}
					
					if (_align == LEFT || _align == CENTER) {
						setItemX(_childrens2use[i], _cumulX);
						setItemY(_childrens2use[i], _cumulY);
					}
					else if (_align == RIGHT) {
						if (isNaN(_width)) throw new Error("you need to set width if using right align");
						
						setItemX(_childrens2use[i], -_cumulX + _width - list_width[i]);
						setItemY(_childrens2use[i], _cumulY);
					}
				}
				
				//choppe la derniere ligne et la centre
				if (_align == CENTER) {
					if (isNaN(_width)) throw new Error("you need to set width if using center align");
					
					_indexNewlines.push(num_dobj);
					//trace("_indexNewlines : " + _indexNewlines);
					
					for (var k:int = 0; k < _indexNewlines.length; k++) 
					{
						if (k > 0) {
							
							var _indstartline:int = _indexNewlines[k-1];
							var _indendline:int = _indexNewlines[k]-1;
							var _widthline:Number = 0;
							//trace("-- " + _indstartline + " - " + _indendline);
							
							for (var j:int = _indstartline; j <= _indendline; j++) 
							{
								var _dims:Point = LayoutEngine.getObjectDimensions(_childrens2use[j]);
								_widthline += (isNaN(_itemwidth)) ? _dims.x : _itemwidth;
								//_widthline += (isNaN(_itemwidth)) ? _childrens2use[j].width : _itemwidth;
								if (j < _indendline) _widthline += _space;
							}
							for (var j:int = _indstartline; j <= _indendline; j++) 
							{
								setItemX(_childrens2use[j], getItemX(_childrens2use[j]) + _width / 2 - _widthline / 2);
							}
						}
					}
					
					
				}
			}
			/*
			//center
			else if (_align == CENTER) {
				
				if (isNaN(_width)) throw new Error("you need to set width if using center align");
				//trace("dev align = center");
				total_width = 0;
				for(i=0;i<num_dobj;i++){
					total_width += list_width[i];
				}
				delta = _width - total_width;
				space = delta / (num_dobj + 1);
				cumul = space;
				for(i=0;i<num_dobj;i++){
					_childrens2use[i].x = cumul;
					cumul += list_width[i] + space;
				}
			}
			*/
		}
		
		
		public function set width(v:Number):void
		{
			_width = v;
		}
		
		public function get width():Number
		{
			if (!(isNaN(_width))) return _width;
			if (isNaN(_itemwidth)) return this.width;
			else {
				return _childrens2use.length * _itemwidth + (_childrens2use.length - 1) * _dx;
			}
		}
		
		
		public function set interline(i:Number)
		{
			_interline = i;
		}
		public function set space(v:Number)
		{
			_dx = v;
		}
		public function set align(_str:String):void
		{
			if(_str!=LEFT && _str!=RIGHT && _str!=CENTER && _str!=JUSTIFY)
				throw new Error("Wrong value for property align");
			_align = _str;
		}
		
		public function set itemwidth(value:Number):void 
		{
			_itemwidth = value;
		}
		
		
		
		
		
		
		
		//______________________________________________________________________
		//private
		
		
		
		
		
		private function getItemX(_item:DisplayObject):Number
		{
			return _item.x;
		}
		
		private function setItemX(_item:DisplayObject, _x:Number):void
		{
			_item.x = _x;
		}
		
		
		private function getItemY(_item:DisplayObject):Number
		{
			return _item.y;
		}
		
		private function setItemY(_item:DisplayObject, _y:Number):void
		{
			_item.y = _y;
		}
		
		
		
		private function getLowestItem(_ind:int):int
		{
			var _max = 0;
			var _mesure;
			var ind_lowest;
			for(var i:int=0;i<_ind;i++){
				_mesure = getItemY(_childrens2use[i]) + _childrens2use[i].height;
				if(_mesure > _max){
					ind_lowest = i;
					_max = _mesure;
				}
			}
			return _max;
		}
		
		
	}

}