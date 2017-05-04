package data2.behaviours.layout 
{
	import data2.behaviours.Behaviour;
	import data2.layoutengine.LayoutEngine;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 
	 */
	public class VLayout extends Behaviour
	{
		private var list_space:Array;
		private var space_end:Number = 0;
		private var _interline:Number;
		private var _childrens2use:Array;
		
		public function VLayout() 
		{
			_interline = 0;
		}
		
		
		
		
		override public function update():void
		{
			
			if (childrens == null) return;
			
			//définit les espaces avec les spacers
			_childrens2use = new Array();
			var _len:int = childrens.length;
			for (var j:int = 0; j < _len; j++) 
			{
				if (!(childrens[j] is Spacer)) {
					_childrens2use.push(childrens[j]);
				}
				else {
					var _spacer:Spacer = Spacer(childrens[j]);
					var _index:int = _childrens2use.length;
					moveYByInd(_index, _spacer.value);
				}
			}
			
			checkListSpace();
			
			if (_childrens2use[0] != null) setItemY(_childrens2use[0], 0);
			
			var _len:int = _childrens2use.length;
			var _cumulheight:Number = 0;
			
			for (var i:int = 0; i < _len; i++) {
				var _y:Number = getY(i);
				var _child:DisplayObject = DisplayObject(_childrens2use[i]);
				setItemY(_child, _y);
				
				_cumulheight = _y + _child.height;
				//trace("-- setItemY(" + _child + ", " + _y + ") : height : "+_child.height);
			}
			
			
			_interfaceSprite.layoutHeight = _cumulheight;
		}
		
		
		
		public function set interline(i:Number)
		{
			_interline = i;
		}
		
		
		
		
		
		
		
		
		//______________________________________________________________________
		//private functions
		
		
		
		private function moveYByInd(indice:int, inc:int):void
		{
			checkListSpace();
			
			if(indice==-1){
				space_end = inc;
			}
			else list_space[indice] = inc;
		}
		
		private function insertInArray(_arr:Array, _value:Object, _index:int):Array
		{
			var _len:int = _arr.length;
			for(var i:int=_len-1; i>=_index; i--) _arr[i+1] = _arr[i];
			_arr[_index] = _value;
			return _arr;
		}
		
		
		//assure que list_space existe et possède le bon nb d'elmt
		private function checkListSpace():void
		{
			if (list_space == null) list_space = new Array();
			if (list_space.length < _childrens2use.length) {
				var _len:int = _childrens2use.length - list_space.length;
				for (var i:int = 0; i < _len; i++) list_space.push(undefined);
			}
		}
		
		
		private function getItemY(_item:DisplayObject):Number
		{
			return _item.y;
		}
		
		private function setItemY(_item:DisplayObject, _y:Number):void
		{
			_item.y = _y;
		}
		
		
		
		private function getY(indice:int):Number
		{
			var pos:Number;
			if(indice==0 && list_space[indice]==undefined){
				return 0;
			}
			if(indice==0){
				pos = 0;
			}
			else {
				var _lasty:Number = getItemY(_childrens2use[indice-1]);
				//var _lastheight:Number = _childrens2use[indice-1].height;
				var _lastdims:Point = LayoutEngine.getObjectDimensions(_childrens2use[indice-1]);
				var _lastheight:Number = _lastdims.y;
				
				pos = _lasty + _lastheight;
			}
			var space:Number = (list_space[indice]!=undefined) ? _interline+list_space[indice] : _interline;
			return pos + space;
		}
	}

}