package data.utils 
{
	/**
	 * ...
	 * @author Vincent
	 */
	public dynamic class Array2 extends Array
	{
		
		public function Array2() 
		{
			super();
		}
		
		public function removeItems(_inds:Array):void
		{
			_inds.sort(Array.NUMERIC);
			_inds.reverse();
			
			var _len:int = _inds.length;
			for (var i:int = 0; i < _len; i++) {
				this.splice(_inds[i], 1);
			}
		}
		
	}

}