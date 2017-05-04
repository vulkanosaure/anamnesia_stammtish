package data2.effects 
{
	import fl.transitions.easing.Back;
	import fl.transitions.easing.Regular;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 
	 */
	public class ZoomEffect extends Effect
	{
		//props
		
		//amountpercent_start
		//amountpercent_end
		
		
		
		public function ZoomEffect() 
		{
			
			
			
		}
		
		
		
		override public function init():void 
		{
			//trace("ZoomEffect.init");
			reset();
			
			//property personalisable)
			var __zoomlvlstart:Number = (isNaN(_amountpercent_start)) ? 0.5 : _amountpercent_start;
			var __zoomlvlend:Number = (isNaN(_amountpercent_end)) ? 1.0 : _amountpercent_end;
			
			//property global (non personalisable selon extension)
			var __time:Number = 0.2;
			var __delay:Number = 0.0;
			var __effect:Function = Regular.easeOut;
			
			
			
			addDef("scaleX", __zoomlvlstart, __zoomlvlend, __time, __delay, __effect);
			addDef("scaleY", __zoomlvlstart, __zoomlvlend, __time, __delay, __effect);
			
			
			
			//centrage
			
			var _centerRatio:Point = getCenterRatio(_realtarget);
			//trace("_centerRatio : " + _centerRatio);
			
			var standard_w:Number = _realtarget.width / _realtarget.scaleX;
			var standard_h:Number = _realtarget.height / _realtarget.scaleY;
			
			var old_w:Number = standard_w * __zoomlvlstart;
			var old_h:Number = standard_h * __zoomlvlstart;
			
			var new_w:Number = standard_w * __zoomlvlend;
			var new_h:Number = standard_h * __zoomlvlend;
			
			/*
			trace("old_w : " + old_w + ", new_w : " + new_w);
			trace("standard dims : " + standard_w + ", " + standard_h);
			*/
			var curX:Number = (_centerRatio.x - 0.5) * _realtarget.width;
			var curY:Number = (_centerRatio.y - 0.5) * _realtarget.height;
			//trace("curX : " + curX + ", curY : " + curY);
			
			var _startx:Number = (_centerRatio.x - 0.5) * old_w;
			var _starty:Number = (_centerRatio.y - 0.5) * old_h;
			
			var _targetx:Number = (_centerRatio.x - 0.5) * new_w;
			var _targety:Number = (_centerRatio.y - 0.5) * new_h;
			
			/*
			trace("_realtarget pos : "+_realtarget.x+", "+_realtarget.y);
			trace("_start : " + _startx + ", " + _starty + " --- target : " + _targetx + ", " + _targety);
			*/
			/*
			addDef("x", _realtarget.x + _startx - curX, _realtarget.x + _targetx - curX, __time, __delay, __effect);
			addDef("y", _realtarget.y + _starty - curY, _realtarget.y + _targety - curY, __time, __delay, __effect);
			*/
			
			
			//new
			_startx = 0;
			_starty = 0;
			_targetx = standard_w * 0.5 - standard_w * __zoomlvlend * 0.5;
			_targety = standard_h * 0.5 - standard_h * __zoomlvlend * 0.5;
			
			addDef("x", _startx, _targetx, __time, __delay, __effect);
			addDef("y", _starty, _targety, __time, __delay, __effect);
		}
		
		
		
		private function getCenterRatio(_dobj:DisplayObject):Point 
		{
			var _bounds:Rectangle = _dobj.getBounds(_dobj);
			//trace("_bounds : " + _bounds);
			var _centerX:Number = -_bounds.x / _bounds.width;
			var _centerY:Number = -_bounds.y / _bounds.height;
			return new Point(_centerX, _centerY);
		}
		
		
		
	}

}