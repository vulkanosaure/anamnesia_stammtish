package data2.states 
{
	import flash.display.Stage;
	/**
	 * ...
	 * @author 
	 */
	public class CustomTransition 
	{
		public var _stage:Stage;
		
		public function CustomTransition() 
		{
			
		}
		
		public function transition(_idsm:String, _idstateprev:String, _idstate:String, _dobjhide:Array, _dobjshow:Array):void
		{
			throw new Error("Method CustomTransitioner.transition must be overriden");
		}
		
	}

}