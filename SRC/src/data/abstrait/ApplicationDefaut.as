package data.abstrait{
	
	// Importation des classe Flash nécessaires
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Stage;
	
	/**
	* @author HUGO
	* @version 1
	* @copyright Data Projekt
	* @see 
	* @todo 
	* @event 
	*/
	public class ApplicationDefaut extends MovieClip{
		
		// Les propriétées de la classe
		
		// Propriété statique vers le point d'accès à l'objet Stage
		public static var GLOBAL_STAGE:Stage;
		
		// La variable de type fonction qui permettra l'éxecution de la fonction de rappel
		private var rappel:Function;
		
		/**
		* Cette classe hérite de la classe Flash MovieClip. Le but de cette classe est d'être utilisée comme une classe de document directement ou bien sous forme d'héritage. Cela permet d'étendre les capacités du Scénario principal grâce à la définition de nouvelles méthodes au sein de la classe document
		*
		* @param aucun
		* @return 
		* @see 
		* @todo 
		*/
		public function ApplicationDefaut(){
		
			// Affectation d'une reference à l'objet Stage
			ApplicationDefaut.GLOBAL_STAGE = stage;
			
		};
		
		/**
		* Méthode de déplacement de la tête de lecture personnalisée. Méthode utile pour faire appel à une occurence qui se situe à une image clé distincte (exemple, à la frame 2, appel de cette méthode applicquée à une occurence située à la frame 20 )
		*
		* @param pImage:int, l'image à laquelle se situe l'occurence. pFonction:Function, la fonction qui sera lancée quand on aura atteint l'occurence à l'image clé donnée
		* @return  void
		* @see 
		* @todo 
		*/
		public function myGotoAndStop( pImage:int, pFonction:Function ):void{
		
			// Ecoute de l'evenement render ( lorsque les objet vectoriels sont rendus definitivement )
			addEventListener( Event.RENDER, miseAJour );
			
			// Et déplacement de la tête de lecture
			gotoAndStop( pImage );
			
			// retourne un objet permetttant d'executer la fonction de reference. 
			// Cette technique permet le lancement d'une fonction à partir d'une image clé distincte
			rappel = pFonction;
			
			// Et on force la diffusion de l'evenement Event.RENDER
			stage.invalidate();
		
		};
		
		/**
		* Méthode miseAJour qui va appeler une fonction
		*
		* @param pEvt:Event
		* @return  void
		* @see 
		* @todo 
		*/
		private function miseAJour( pEvt:Event ):void{
			
			// Tentative d'appel de la fonction de rappel qui sera lancé uniquement lorsque l'objet vectoriel est rendu définitivement
			try{
				
				rappel();
				
			}catch( pErreur:Error ){
				
				// Message d'erreur si l'appel de la fonction de référence echoue
				trace("Erreur : la méthode de rappel n'a pas été définie");
				
			}finally{
				
				// Et dans tous les cas, on supprime l'ecouteur de l'evenement
				removeEventListener( Event.RENDER, miseAJour );
				
			}
			
		};
		
		
	};
	
}