package data.fx.transitions.trajectory
{
	/**
	 * ...
	 * @author Vincent
	 */
	public class TrajectoryPoint
	{
		var x:Number;
		var y:Number;
		var label:String;
		
		public function TrajectoryPoint(_x:Number=0, _y:Number=0, _label="") 
		{
			this.set(_x, _y, _label);
		}
		
		public function set(_x:Number, _y:Number, _label:String = "")
		{
			x = _x;
			y = _y;
			label = _label;
		}
		
		
		public function toString():String
		{
			return "[TrajectoryPoint, x : " + x + ", y : " + y + ", label : " + label + "]";
		}
	}

}