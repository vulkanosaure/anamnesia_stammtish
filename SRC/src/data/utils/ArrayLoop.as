package data.utils 
{
	/**
	 * ...
	 * @author Vincent
	 */
	public dynamic class ArrayLoop extends Array
	{
		//_______________________________________________________________________________
		// properties
		
		public function ArrayLoop() 
		{
			
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function get(i:int):*
		{
			while (i < 0) i += this.length;
			while (i >= this.length) i -= this.length;
			return this[i];
		}
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}