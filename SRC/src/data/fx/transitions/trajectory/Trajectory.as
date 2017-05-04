/*
 * A REFLECHIR :
 * 
 * design patern : il y'a 2 coordonnes qui s'appliquent
 * se mettre en situtation par rapport a ce qu'on veut pour le jeu (ou n'importe quoi) en terme d'objet et d'interface
 * 
 * 
 * SOLUTIONS :
 * 
 * Trajectory hérite de MovieClip, this devient this
 * Trajectory.getPoint(_progress:Number):TrajectoryPoint
 * MovieClipTrajectory
 * 		. contient une Trajectory (passé en param)
 * 		. public function set/get progress
 * 
 * 
 * TODO :
 * 
 * ajouter points entre les points (facultatif)
 * public function addCustomMethod(_label:String, _func:Function):void
 * 
 * 
 * 
 * */



package data.fx.transitions.trajectory
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Vincent
	 */
	public class Trajectory extends MovieClip
	{
		var mcCursor:MovieClip;
		var points:Array;
		
		
		public function Trajectory() 
		{
			this.init();
		}
		
		public function getPoint(_progress:Number):TrajectoryPoint
		{
			if (_progress < 0 || _progress > 1) throw new Error("arg _progress must be between 0 and 1");
			var _len:int = points.length - 1;
			var _ind:Number = _len * _progress;
			var pt_return:TrajectoryPoint;
			
			var ind_bottom:int = Math.floor(_ind);
			
			if (_ind == ind_bottom) {
				pt_return = points[_ind];
			}
			else{
				var ind_top:int = ind_bottom + 1;
				var decimal:Number = _ind - ind_bottom;
				
				var _x1, _y1, _x2, _y2:Number;
				_x1 = points[ind_bottom].x;
				_y1 = points[ind_bottom].y;
				_x2 = points[ind_top].x;
				_y2 = points[ind_top].y;
				
				var _x, _y:Number;
				_x = _x1 + (_x2 - _x1) * decimal;
				_y = _y1 + (_y2 - _y1) * decimal;
				pt_return = new TrajectoryPoint(_x, _y);
			}
			
			//trace(pt_return);
			return pt_return;
		}
		
		private function init():void
		{
			var _dobj:DisplayObject;
			for (var i:int = 0; i < this.numChildren; i++) {
				_dobj = this.getChildAt(i);
				if (_dobj is MovieClip) mcCursor = MovieClip(_dobj);
			}
			if (mcCursor == null) throw new Error("no MovieClip was found in obj " + this);
			
			points = new Array();
			this.getNextFrame();
			
		}
		
		private function getNextFrame():void
		{
			//trace("coords : " + mcCursor.x + ", " + mcCursor.y);
			points.push(new TrajectoryPoint(mcCursor.x, mcCursor.y));
			
			if (this.currentFrame < this.totalFrames) {
				this.nextFrame();
				this.getNextFrame();
			}
			
		}
		
		
		
	}

}