package data.fx.transitions.trajectory
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Vincent
	 */
	public dynamic class MovieClipTrajectory extends MovieClip
	{
		private var _progress:Number = 0;
		private var _trajectory:Trajectory;
		
		public function MovieClipTrajectory(_trajectory:Trajectory=null) 
		{
			this.trajectory = _trajectory;
		}
		
		
		
		public function get progress():Number 
		{ 
			return _progress; 
		}
		
		public function set progress(value:Number):void 
		{
			check();
			_progress = value;
			var pt:TrajectoryPoint = _trajectory.getPoint(value);
			this.x = pt.x;
			this.y = pt.y;
			
		}
		
		
		public function set trajectory(value:Trajectory):void 
		{
			_trajectory = value;
		}
		
		
		
		
		private function check():void
		{
			if (_trajectory == null) throw new Error("Trajectory has not been defined");
		}
	}

}