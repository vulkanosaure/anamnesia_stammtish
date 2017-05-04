package data2.states 
{
	/**
	 * ...
	 * @author 
	 */
	public class TransitionDef 
	{
		public static const MODE_VALUES:Array = ["fifo", "lifo"];
		
		//mode inutilisé pour l'instant
		private var _mode:String;
		private var _tempo:Number;
		private var _timetransform:Number;
		private var _effecttransform:Function;
		private var _customTransition:CustomTransition;
		
		
		public function TransitionDef() 
		{
			//default values
			_mode = "";
			_tempo = NaN;
			_timetransform = NaN;
			_effecttransform = null;
		}
		
		public function get tempo():Number 
		{
			return _tempo;
		}
		
		public function set tempo(value:Number):void 
		{
			_tempo = value;
		}
		
		public function get mode():String 
		{
			return _mode;
		}
		
		public function set mode(value:String):void 
		{
			//if (MODE_VALUES.indexOf(value) == -1) throw new Error("wrong value for TransitionDef.mode ("+value+"), possible values are "+MODE_VALUES);
			_mode = value;
		}
		
		public function get effecttransform():Function 
		{
			return _effecttransform;
		}
		
		public function set effecttransform(value:Function):void 
		{
			_effecttransform = value;
		}
		
		public function get timetransform():Number 
		{
			return _timetransform;
		}
		
		public function set timetransform(value:Number):void 
		{
			_timetransform = value;
		}
		
		public function get customTransition():CustomTransition 
		{
			return _customTransition;
		}
		
		public function set customTransition(value:CustomTransition):void 
		{
			_customTransition = value;
		}
		
	}

}