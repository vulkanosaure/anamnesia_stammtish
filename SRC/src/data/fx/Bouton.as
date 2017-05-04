package data.fx {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	* @author Pierre-Antoine Gervais
	* @version 1.0 (24/06/2009)
	*/
	
	public class Bouton extends MovieClip {
		
		/**
		* La classe Bouton décrit le comportement d'un bouton générique.
		* - 
		* L'utilisation de la classe se fait par la bibliothèque, en faisant clic droit > liaison > exporter pour ActionScript > Classe de base : data.fx.Bouton
		* ou
		* extends normal
		* <div class="code">import data.fx.Bouton
		* var monBouton:Bouton = new Bouton();
		* monBouton.addChild(monBouton);
		* </div>
		* Par défaut, le bouton n'a pas d'apparence. Il faut donc utiliser l'une des deux méthodes.
		*/
		public function Bouton() {
			if(!this.useHandCursor) this.useHandCursor = true;
			if(!this.buttonMode) this.buttonMode = true;
		}
	}
}