package data2.asxml 
{
	/**
	 * ...
	 * @author 
	 */
	public class ConstantesProvider 
	{
		
		public function ConstantesProvider() 
		{
			
		}
		
		public function set xmlList(_xmlList:Object):void
		{
			trace("ConstantesProvider.xmlList = ");
			Constantes.addXML(_xmlList);
			
		}
		
	}

}