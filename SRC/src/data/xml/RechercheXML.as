package data.xml {
	
	/**
	* @author : HUGO
	* @version 1
	* @copyright Data Projekt
	* @see 
	*
	* contient des méthodes de recherche classique sur des xml. La strucutre de ces xml est basée sur ceux des xml générés par le bo
	*
	* import data.xml.RechercheXML;
	* var rechercheXML = new RechercheXML();
	* rechercheXML.recupNumNodesIdentifiant( pFluXml, pNumIdentifiant, pLangue ( FR par defaut si pas rempli ) ) 
	* rechercheXML.recupNumIdentifiantNodes( pFluXml, pNumNodes, pLangue ( FR par defaut si pas rempli ) ) 
	*
	* @todo 
	* @event
	*/
	public class RechercheXML {
		
		// Initialization:
		public function RechercheXML(){ 
		
		}
		
		/**
		* Méthode qui retourne le numéro du nodes par rapport à un identifiant
		*
		* @param  
		* pFluXml:XML le flux Xml
		* pNumIdentifiant:Number le numéro d'identifiant pour lequel on veux récupérer le nodes
		* pLangue:String : la valeur du nodes des langues
		* @return Number
		*/
		public function recupNumNodesIdentifiant( pFluXml:XML, pNumIdentifiant:Number, pLangue:String = "FR" ):Number{
			
			var cptr:Number     = 0;
			var numNodes:Number = 0;
			
			for each( var noeud:XML in pFluXml[ pLangue ].* ){
							
				if( pNumIdentifiant == noeud.ID ){
					
					numNodes = cptr;
					
				}
				
				cptr++;
				
			}
			
			return numNodes;
			
		}
		
		/**
		* Méthode qui retourne la valeur du nodes d'identifiant du fichier Xml par rapport à son numéro de Nodes
		*
		* @param  
		* pFluXml:XML le flux Xml
		* pNumNodes:Number le numéro du nodes
		* pLangue:String : la valeur du nodes des langues
		* @return Number
		*/
		public function recupNumIdentifiantNodes( pFluXml:XML, pNumNodes:Number, pLangue:String = "FR" ):Number{
			
			var numIdentifiant:Number = 0;
			
			// Cible le nodes pour choper son identifiant
			numIdentifiant = pFluXml[pLangue ].ITEM[ pNumNodes ].ID 
			
			return numIdentifiant;
			
		}
	
		// Public Methods:
		// Protected Methods:
		
		
		
		
		
	}
	
}