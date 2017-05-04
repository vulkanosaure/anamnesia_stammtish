package data.utils {
	
	/**
	* @author Pierre-Antoine Gervais / Hugo Data ( rajout de la methode numberRandom et nextPrevListNumber )
	* @version 1.0 (08/07/2009) /  @version 1.1 le 07/01/10 ( modifs de Hugo )
	*/
	
	public class NumberOperation {
		
		// STATIQUE TEMPORELLES
		/**
		* Définit la valeur de la propriété type désignant les milisecondes
		*/
		public static const MILLISECOND:String = "millisecond";
		/**
		* Définit la valeur de la propriété type désignant les scondes
		*/
		public static const SECOND:String = "second";
		/**
		* Définit la valeur de la propriété type désignant les minutes
		*/
		public static const MINUTE:String = "minute";
		/**
		* Définit la valeur de la propriété type désignant les heures
		*/
		public static const HOUR:String = "hour";
		/**
		* Définit la valeur de la propriété type désignant les jours
		*/
		public static const DAY:String = "day";
		/**
		* Définit la valeur de la propriété type désignant les années
		*/
		public static const YEAR:String = "year";
		/**
		* Définit la valeur de la propriété suivant liste
		*/
		public static const SUIVANT:String = "suivant";
		/**
		* Définit la valeur de la propriété precedent liste
		*/
		public static const PRECEDENT:String = "precdent";
		
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		// 					CONSTRUCTEUR					//
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		
		/**
		* Classe qui regroupe les méthodes de calcul de nombres.
		* La classe NumberOperation est statique.
		*/
		public function NumberOperation() {
			throw new Error("Class NumberOperation can't be instanciated. This class is static.");
		}
		
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		// 			FONCTIONS CALCUL TIME			//
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		
		// FONCTIONS ASCENDANTES
		/**
		* Calcule le nombre de secondes présentes dans un nombre données de milisecondes.
		* - 
		* <div class="code">import data.utils.NumberOperation;
		* var millisecondes:int = 93846;
		* var resultatSecondes:Object = NumberOperation.timeSecFromMillisec(millisecondes);
		* var secondes:int = resultatSecondes.valeur;
		* var resteMillisecondes:int = resultatSecondes.reste;
		* trace("Il y a "+secondes+" secondes dans "+millisecondes+" millisecondes, et il reste "+resteMillisacondes+" millisecondes);
		* <span class="commentaire">// Il y a 93 secondes dans 93846 millisecondes, et il reste 846 millisecondes</span>
		* </div>
		* -
		* @param pMillisec Nombre de millisecondes desquelles on veut connaitre le nombre de secondes
		* @return objet contenant le nombre de secondes, et le nombre de mlillisecondes restantes après retranchement des secondes. object.valeur est le nombre de secondes entières, object.reste est le nombre de millisecondes restantes après retranchement des secondes.
		* @see timeMinFromSec
		* @see timeHourFromMin
		* @see timeDayFromHour
		* @see timeYearFromDay
		*/
		public static function timeSecFromMillisec(pMillisec:Number):Object {
			var retour:Object = new Object();
			retour.valeur = Math.floor(pMillisec / 1000);
			retour.reste = pMillisec - retour.valeur*1000;
			return retour;
		}
		
		public static function timeMinFromSec(pSec:Number):Object {
			var retour:Object = new Object();
			retour.valeur = Math.floor(pSec / 60);
			retour.reste = pSec - retour.valeur*60;
			return retour;
		}
		
		public static function timeHourFromMin(pMin:Number):Object {
			var retour:Object = new Object();
			retour.valeur = Math.floor(pMin / 60);
			retour.reste = pMin - retour.valeur*60;
			return retour;
		}
		
		public static function timeDayFromHour(pHour:Number):Object {
			var retour:Object = new Object();
			retour.valeur = Math.floor(pHour / 24);
			retour.reste = pHour - retour.valeur*24;
			return retour;
		}
		
		public static function timeYearFromDay(pDay:Number):Object {
			var retour:Object = new Object();
			retour.valeur = Math.floor(pDay / 365);
			retour.reste = pDay - retour.valeur*365;
			return retour;
		}
		
		// FONCTION DESCENDANTES
		
		public static function timeMillisecFromSec(pSec:Number):Object {
			var retour:Number = pSec * 1000;
			return retour;
		}
		
		// AUTRES FONCTIONS
		
		public static function timeGlobalize(pUnit:String, pValue:Number):Object {
			// initialisation of return values
			var retour:Object = new Object();
			retour.millisec = 0;
			retour.totalMilisec = 0;
			retour.sec = 0;
			retour.totalSec = 0;
			retour.min = 0;
			retour.totalMin = 0;
			retour.hour = 0;
			retour.totalHour = 0;
			retour.day = 0;
			retour.totalDay = 0;
			retour.year = 0;
			
			var tempValues:Object = new Object();
			var nbAnneeBisextile:int = 0;
			var virgule:Number = 0;
			
			switch(pUnit) {
				case MILLISECOND:
					tempValues = timeSecFromMillisec(pValue);
					retour.totalMillisec = pValue;
					retour.sec = tempValues.valeur;
					retour.totalSec = retour.sec;
					retour.millisec = tempValues.reste;
					
					tempValues = timeMinFromSec(retour.sec);
					retour.min = tempValues.valeur;
					retour.totalMin = retour.min;
					retour.sec = tempValues.reste;
					
					tempValues = timeHourFromMin(retour.min);
					retour.hour = tempValues.valeur;
					retour.totalHour = retour.hour;
					retour.min = tempValues.reste;
					
					tempValues = timeDayFromHour(retour.hour);
					retour.day = tempValues.valeur;
					retour.totalDay = retour.day;
					retour.hour = tempValues.reste;
					
					tempValues = timeYearFromDay(retour.day);
					retour.year = tempValues.valeur;
					retour.day = tempValues.reste;
					
					nbAnneeBisextile = retour.year/4;
					retour.day -= nbAnneeBisextile;
					(retour.day < 0)?(retour.day = 365+retour.day, retour.year--):null;
					
					break;
				case SECOND:
					tempValues = timeMinFromSec(pValue);
					retour.min = tempValues.valeur;
					retour.totalMin = retour.min;
					retour.sec = tempValues.reste;
					
					tempValues = timeHourFromMin(retour.min);
					retour.hour = tempValues.valeur;
					retour.totalHour = retour.hour;
					retour.min = tempValues.reste;
					
					tempValues = timeDayFromHour(retour.hour);
					retour.day = tempValues.valeur;
					retour.totalDay = retour.day;
					retour.hour = tempValues.reste;
					
					tempValues = timeYearFromDay(retour.day);
					retour.year = tempValues.valeur;
					retour.day = tempValues.reste;
					
					nbAnneeBisextile = retour.year/4;
					retour.day -= nbAnneeBisextile;
					(retour.day < 0)?(retour.day = 365+retour.day, retour.year--):null;
					
					// gère les virgule dans pValue
					virgule = (pValue*1000 - Math.floor(pValue)*1000)/1000;
					if(virgule != 0) {
						retour.millisec = timeMillisecFromSec(virgule);
						retour.sec = Math.floor(retour.sec);
						retour.totalSec = pValue - virgule;
					}
					break;
				default:
					break;
			}
			return retour;
		}
		
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		// 				FONCTIONS CALCUL				//
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		
		/**
		* calcule le nombre de combinaisons qu'il est possible de réaliser dans un ensemble (et l'ordre des combinaisons n'a pas d'importance)
		*/
		public static function numCombinaisons(pNumber:int, pIncludeZero:Boolean = false):int {
			var total:int = 0;
			for(var i:int = pNumber; i>0; i--) {
				var dessus:int = factorize(pNumber);
				var dessous:int = factorize(i)*factorize(pNumber-i);
				var combinaisons:int = dessus/dessous;   
				total += combinaisons;
			}
			if(pIncludeZero) total++;
			return total;
		}
		
		
		
		/**
		* calcule le produit des entiers allant de 1 à pNumber, soit factoriel de pNumber. (noté !pNumber en langage formel)
		* <div class="code">import data.utils.NumberOperation;
		* var resultat:Number = NumberOperation.numberRandom( pNumberMax );
		* trace(resultat);
		* <span class="commentaire"></span>
		* resultat = NumberOperation.numberRandom( 480 );
		* trace(resultat);
		* </div>
		* -
		* @param pNumber Nombre que l'on souhaite factoriser
		* @return Résultat le la factorisation.
		*/
		public static function factorize(pNumber:int):int {
			var retour:int = 1;
			for(var i:int = pNumber; i>0; i--) {
				retour*=i;
			}
			return retour;
		}
		
		
		/**
		* calcule un nbr aléatoire compris entre 0 inclus et un nbrMax inclus
		* <div class="code">import data.utils.NumberOperation;
		* var resultat:int = NumberOperation.numberRandom( pNumberMax );
		* trace(resultat);
		* <span class="commentaire"></span>
		* resultat = NumberOperation.numberRandom( 480 );
		* trace(resultat);
		* </div>
		* -
		* @param pNumberMax Nombre max de servant de "limite" pour le calcul du random
		* @return Résultat le la randomisation
		*/
		public static function numberRandom( pNumberMax:Number ):Number{
			
			var retour:Number = 0;
			
			retour = Math.round( Math.random() * ( pNumberMax ) );
			
			return retour;
		
		};
		
		/**
		* Renvoie par rapport à un nbr courant un nbr suivant ou précedent selon un chiffre init et un chiffre max avec un principe de boucle.
		* par exemple 
		* si init = 0 et max = 4 et que chiffre courant = 4 si on demande le chiffre suivant, return 0
		* si init = 0 et max = 4 et que chiffre courant = 2 si on demande le chiffre suivant, return 2
		* si init = 0 et max = 4 et que chiffre courant = 0 si on demande le chiffre precedent, return 4
		* si init = 0 et max = 4 et que chiffre courant = 3 si on demande le chiffre precedent, return 3
		* <div class="code">import data.utils.NumberOperation;
		* var resultat:Number = NumberOperation.nextPrevListNumber( 0, 4, 2, "next" );
		* trace(resultat);
		* </div>
		* -
		* @param pNumberStart : nbr init
		* 		 pNumberEnd : nbr limit
		* 		 pNumberCourant : nbr courant
		* 		 pType : si on veux retourner le nbr suivant ou precedent
		* @return Résultat suivant ou precedent de la liste
		*/
		public static function nextPrevListNumber( pNumberStart:Number, pNumberEnd:Number, pNumberCourant:Number, pType:String ):Number{
			
			var retour:Number = -1;
			
			if( pType == SUIVANT ){
				
				if( pNumberCourant < pNumberEnd ){
					
					retour = pNumberCourant + 1;
					
				}else{
					
					retour = pNumberStart;
					
				}
				
			}else if( pType == PRECEDENT ){
				
				if( pNumberCourant > pNumberStart ){
					
					retour = pNumberCourant - 1;
					
				}else{
					
					retour = pNumberEnd;
					
				}
								
			}
						
			return retour;
		
		}
		
	}
}