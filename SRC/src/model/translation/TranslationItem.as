package model.translation 
{
	/**
	 * ...
	 * @author Vinc
	 */
	public class TranslationItem 
	{
		public var iditem:String;
		public var keyxml:String;
		public var keyxmltab:String;
		public var keyxmlobj:String;
		public var keyparam:String;
		public var style:String;
		public var styleAdd:String = "";
		
		public var is_dynamic:Boolean;
		public var optional:Boolean = false;
		public var hasVar:Boolean = false;
		
		public function TranslationItem() 
		{
			
		}
		
	}

}