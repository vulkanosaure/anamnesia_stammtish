package data.utils {
	
	/**
	* @author Pierre-Antoine Gervais
	* @version 1.0 (25/02/09)
	*/
	public class StringManipulation {
		
		/**
		* Classe qui regroupe des méthodes de manipulation de chaine de caractères. Pour pouvoir utiliser les méthodes, il faut instancier la classe, puis appeler les méthodes à partir de cette instance.
		* Exemple : 
		* <div class="code">var SM:StringManipulation = new StringManipulation();
		* var chaineResultat:String = SM.methode(paramètre);
		* </div>
		* -
		* Constructeur sans paramètre
		*/
		public function StringManipulation() {
		}
		
		/** 
		* fonction qui vérifie que le mail est bien formé
		* Exemple : 
		* <div class="code">var SM:StringManipulation = new StringManipulation();
		* var email:String = "monsieurpatate&#64;photoshop.com";
		* trace(SM.checkEmailValidity(email)); 
		* <span class="commentaire">// true</span><br />
		* email = "monsieurpatate&#64;com";
		* trace(SM.checkEmailValidity(email)); 
		* <span class="commentaire">// false</span>
		* </div>
		* @param chaine chaine de caractère d'origine que l'on veut vérifier
		* @return true si l'adresse e-mail est valide, false si elle ne l'est pas
		*/
		public static function checkEmailValidity(chaine:String):Boolean {
			if(chaine.length < 4) {
				// chaine trop petite pour être une adresse email valide
				return false;
			} else {
				var caractereCherche:String = "@"; // on cherche un arobase
				var indexArobase:Number = 0;
				var indexPoint:Number = 0;
				
				for(var i:Number = 0; i<chaine.length; i++) { // on parcourt la chaine à la recherche d'un "@" et d'un "."
					if(chaine.charAt(i) == caractereCherche) { // si on trouve le caractere
						if(caractereCherche == "@") { // on a trouvé l'arobase
							indexArobase = i;
							caractereCherche = "."; // alors on cherche le point
						} else if(caractereCherche == ".") { // on a trouvé le point
							indexPoint = i;
						}
					}
				}
				
				// une fois qu'on sait où sont le "@" et le "." on vérifie que c'est confirme à la norme des adresse email.
				// si l'arobase est trouvé dans une position suppérieure au premier caractère
				// le point au moins à la position 3
				// au moins 1 caractère sépare le "@" et le "."
				// le point n'est pas le dernier caractère
				if(indexArobase >= 1 && indexPoint >= 3 && (indexPoint - indexArobase) >= 2 && (chaine.length - indexPoint) >= 2) {
					return true;
				} else {
					return false;
				}
			}
		}
		
		/**
		* fonction qui supprime les espace, les tabulations et les retour chariot dans une chaine, au début et à la fin.
		* utilisée, par exemple, pour enlever les espaces indésirables autour des nodes de type #PCDATA dans les XMLs
		* Exemple : 
		* <div class="code">var SM:StringManipulation = new StringManipulation();
		* var chaineTraitee:String = "<br /><br /> Chaine avec des blancs. <br /><br />";
		* trace(SM.deleteSpace(chaineTraitee)); 
		* <span class="commentaire">// Chaine avec des blancs.</span>
		* trace(chaineTraitee);
		* <span class="commentaire">// <br /><br /> Chaine avec des blancs. <br /><br /></span>
		* </div>
		* @param chaine chaine de caractère d'origine qui contient peut-être des espaces et des retour chariot au début ou à la fin.
		* @return chaine de caractère dont les espace, tabulation et retour chariot ont été supprimés au début et à la fin.
		*/
		public static function deleteSpace(chaine:String):String {
			if(chaine.length == 0) {
				return chaine;
			} else {
				var chaineRetour:String = new String();
				var indexPremier:int = 0;
				var indexDernier:int = chaine.length-1;
				// trouver le premier index : 
				while(chaine.charCodeAt(indexPremier) == 13 || chaine.charCodeAt(indexPremier) == 10 || chaine.charCodeAt(indexPremier) == 9) {
					indexPremier++;
				}
				// trouver le dernier index : 
				while(chaine.charCodeAt(indexDernier) == 13 || chaine.charCodeAt(indexDernier) == 10 || chaine.charCodeAt(indexDernier) == 9) {
					indexDernier--;
				}
				
				for(var i:uint = indexPremier; i<=indexDernier; i++) {
					chaineRetour += chaine.charAt(i);
				}
				return chaineRetour;
			}
		}
	
		/**
		* fonction qui ajoute autant de charactères charAjout qu'il faut pour atteindre une chaine de longueur longueurSouhaite
		* utilisée, par exemple, pour formater du texte pour une horloge.
		* Exemple : 
		* <div class="code">var SM:StringManipulation = new StringManipulation();
		* var chaineTraitee:String = "<br /><br />Coucou<br /><br />";
		* var nombrePetit:Number = 45;
		* trace(SM.fillChar(chaineTraitee, 20, "!", "derriere")); 
		* <span class="commentaire">// Coucou!!!!!!!!!!!!!!</span>
		* trace(SM.fillChar(nombrePetit.toString(), 5);
		* <span class="commentaire">// 00045</span>
		* </div>
		* Remarque : si la chaine fournie est plus petite que la longueur demandée, la chaine est retournée telle qu'elle sans message d'erreur
		* @param chaineSource chaine de caractère d'origine que l'on veut modifier
		* @param longueurChaineSouhaite nombre de caractères qui constituent la chaine résultatante
		* @param charAjout (facultatif, défini par défaut à "0") caractère que l'on souhaite ajouter
		* @param cote (facultatif, défini par défaut à "devant") on peut choisir si les caractères ajoutés sont en préfixe ou en suffixe (avant ou après la chaine source). Peut prendre les valeurs : "devant", "derriere".
		* @return chaine de caractère remplie de nouveau caractère.
		*/
		public static function fillChar(chaineSource:String, longueurChaineSouhaite:Number, charAjout:String = "0", cote:String = "devant"):String {
			// Si on met une longueur souhaitée plus petite que la chaine d'origine, la fonction retourne la chaine de base sans la changer
			if(longueurChaineSouhaite < chaineSource.length) {
				return chaineSource;
			} else {
				var chaineRetour:String = chaineSource;
				while(chaineRetour.length < longueurChaineSouhaite) {
					if(cote == "devant") chaineRetour = charAjout+chaineRetour;
					if(cote == "derriere") chaineRetour += charAjout;
				}
				return chaineRetour;
			}
		}
		
		/**
		* Fonction qui remplace toutes les occurences d'un caractère par un autre dans une chaine donnée
		* Pour remplacer des chaine de plus d'un caractère, utilisez replaceChars()
		* Exemple : 
		* <div class="code">var SM:StringManipulation = new StringManipulation();
		* var chaineTraitee:String = "Bonjour tout le monde";
		* trace(SM.replaceChar(chaineTraitee, "o", "O")); 
		* <span class="commentaire">// BOnjOur tOut le mOnde</span>
		* </div>
		* @param chaineSource chaine de caractère d'origine que l'on veut modifier
		* @param charEntree caractère que l'on souhaite transformer
		* @param charSortie caractère que l'on souhaite mettre à la place
		* @return chaine de caractère modifiée
		* @see replaceChars
		*/
		public static function replaceChar(chaineSource:String, charEntree:String, charSortie:String):String {
			var chaineRetour:String = "";
			for(var i:Number = 0; i<chaineSource.length; i++) {
				if(chaineSource.charAt(i) == charEntree) {
					chaineRetour += charSortie;
				} else {
					chaineRetour += chaineSource.charAt(i);
				}
			}
			return chaineRetour;
		}
		
		/**
		* Fonction qui remplace n'importe quelle chaine, d'un ou plusieurs caractères, incluse dans une autre par une troisième chaine
		* La longueur de la chaine à remplcer et la longueur de la chaine remplaçante peuvent être différentes.
		* La fonction est sensible à la casse.
		* Pour replacer un seul caractère, la méthode replaceChar est plus approriée.
		* <br />Exemple : 
		* <div class="code">var SM:StringManipulation = new StringManipulation();
		* var chaineTraitee:String = "Bonjour Michel, bonjour Rachelle. Merci de bien vouloir venir par ici Jean-Claude.";
		* trace(SM.replaceChars(chaineTraitee, "Michel", "Robert")); 
		* <span class="commentaire">// Bonjour Robert, bonjour Rachelle. Merci de bien vouloir venir par ici Jean-Claude.</span>
		* trace(SM.replaceChars(SM.replaceChars(chaineTraitee, "Bonjour", "Au revoir"), "venir par ici", "vous assoir");
		* <span class="commentaire">// Au revoir Michel, bonjour Rachelle. Merci de bien vouloir vous assoir Jean-Claude.</span>
		* </div>
		* @param chaineSource chaine de caractère d'origine que l'on veut modifier
		* @param chaineEntree chaine de caractère que l'on souhaite voir remplacée
		* @param chaineSortie chaine que l'on veut voir à la place de chaineEntree
		* @return chaine de caractère modifiée
		* @see replaceChar
		*/
		public static function replaceChars(chaineSource:String, chaineEntree:String, chaineSortie:String):String {
			var chaineRetour:String = "";
			var decoupe:String = "";
			for(var i:Number = 0; i<chaineSource.length; i++) {
				for(var j:Number = 0; j<chaineEntree.length; j++) {
					decoupe += chaineSource.charAt(i+j);
				}
				if(decoupe == chaineEntree) {
					chaineRetour += chaineSortie;
					i+=chaineEntree.length-1;
				} else {
					chaineRetour += chaineSource.charAt(i);
				}
				decoupe = "";
			}
			return chaineRetour;
		}
		
	}
	
}