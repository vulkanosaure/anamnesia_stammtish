package data.fx {
	
	public interface IBackground extends IScreenOutput {
		
		function loadImage(pImageUrl:String = ""):void;
		
		function get loadingInfo():Object;
	}
	
}