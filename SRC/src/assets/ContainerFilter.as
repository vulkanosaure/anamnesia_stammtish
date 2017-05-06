package assets 
{
	import data2.InterfaceSprite;
	import flash.filters.DropShadowFilter;
	/**
	 * ...
	 * @author Vincent Huss
	 */
	public class ContainerFilter extends InterfaceSprite
	{
		
		public function ContainerFilter() 
		{
			this.filters = [new DropShadowFilter(2.1, 90, 0x000000, 0.25, 15.5, 15.5, 1)];
		}
		
	}

}