package data.fx.transitions.transitionbitmap 
{
	/**
	 * ...
	 * @author Vincent
	 */
	public class TransitionProperty
	{
		//_______________________________________________________________________________
		// properties
		
		
		private const ACCEPTED_PROPERTIES:Array = ["x", "y", 
													"alpha", 
													"xstagein", "ystagein", 
													"xstageout", "ystageout"];
		
		
		private var _prop:String;
		private var _valStart:*;
		private var _valEnd:*;
		private var _duration:Number;
		private var _delay:Number;
		private var _effect:Function;
		
		
		public function TransitionProperty(__prop:String, __valStart:*, __valEnd:*, __duration:Number=NaN, __delay:Number=NaN, __effect:Function=null) 
		{
			if (ACCEPTED_PROPERTIES.indexOf(__prop) == -1) throw new Error("property " + __prop + " is not accepted (" + ACCEPTED_PROPERTIES + ")");
			
			_prop = __prop;
			_valStart = __valStart;
			_valEnd = __valEnd;
			_duration = __duration;
			_delay = __delay;
			_effect = __effect;
			
		}
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function get effect():Function { return _effect; }
		
		public function get delay():Number { return _delay; }
		
		public function get duration():Number { return _duration; }
		
		public function get valEnd():*
		{ 
			return _valEnd; 
		}
		
		public function get valStart():*
		{ 
			return _valStart; 
		}
		
		public function get prop():String { return _prop; }
		
		
		
		
		public function toString():String 
		{
			return "[TransitionProperty, prop : " + _prop + ", valStart : " + _valStart + ", valEnd : " + _valEnd + ", duration : " + _duration + ", delay : " + _delay + ", effect : " + _effect + "]";
		}
		
		public function clone():TransitionProperty
		{
			var tp:TransitionProperty = new TransitionProperty(this.prop, this.valStart, this.valEnd, this.duration, this.delay, this.effect);
			return tp;
		}
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}