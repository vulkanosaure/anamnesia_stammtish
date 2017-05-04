package data.utils  {
	
	/**
	* @author Pierre-Antoine Gervais
	* @version 1.0 (23/02/2009)
	*/	
	public class NumberManipulation {
		
		/**
		* La classe NumberManipulation est un ensemble de fonction qui fait des opérations sur les nombres
		* Pour l'utiliser, il faut créer une instance de NumberManipulation et utiliser ses méthodes
		* - 
		* Constructeur sans paramètre
		*/	
		public function NumberManipulation() {
		}
		
		/**
		* fonction qui retourne le nombre de minute qu'on peut compter dans un certain nombre de seconde
		* Exemple : 
		* <div class="code">var NM:NumberManipulation = new NumberManipulation();
		* trace(NM.minFromSec(340)); <span class="commentaire">// 5</span>
		* </div>
		* @param nbSec Nombre de secondes dans lesquelles il faut compter le nombre de minute entière
		* @return Nombre de minutes entières contenues dans le nombre de secondes donné.
		*/
		public static function minFromSec(nbSec:Number):Number {
			var nbMin:Number = Math.floor(nbSec/60);
			return nbMin;
		}
		
		/**
		* fonction  qui retourne le nombre de seconde qui reste quand on a enlevé les minutes entières
		* Exemple :
		* <div class="code">var NM:NumberManipulation = new NumberManipulation();
		* trace(NM.secReste(340)); <span class="commentaire">// 40</span>
		* </div>
		* @param nbSec Nombre de secondes total duquel il faut enlever les minutes entières
		* @return Une fois les minutes entières enlevées, nombre de secondes qui reste.
		*/
		public static function secReste(nbSec:Number):Number {
			var nbMin:Number = Math.floor(nbSec/60);
			var secRestante:Number = nbSec-nbMin*60;
			return secRestante;
		}
		
	}
}