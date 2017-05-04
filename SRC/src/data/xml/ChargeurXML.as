package data.xml{
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	// Import du package flash qui va nous permettre de gérer le système de cache Xml du navigateur
	import flash.net.URLRequestHeader;
	
	/**
	* @author HUGO
	* @version 1
	* @copyright Data Projekt
	* @see V:\STUDIO_WEB\AS3-EXEMPLES\ChargementXml : exemple-utilisation-chargeur-xml.fla pour l'utilisation de cette classe
	* @todo 
	* @event redirigeEvenement
	*/
	public class ChargeurXML extends EventDispatcher{
		
		// Déclaration des propriétées
		
		// L'objet de chargement
		private var chargeur:URLLoader;
		// L'objet XML
		private var fluxXML:XML;
		private var _dataStr:String;
		// la variable qui va préciser si on veux ou pas que le Xml soit mis en cache
		private var antiCache:Boolean;
		var url:String;
		
		/**
		* Constructeur qui prend en paramêtre la valeur boolean si chache ou pas 
		*
		* @param pAntiCache:Boolean=false . Détermine si le xml est gardé ou pas en cache par le flash
		* @return 
		* @see 
		* @todo 
		*/
		public function ChargeurXML( pAntiCache:Boolean = true ){
			
			// Déclaration de notre variable anti cache
			antiCache = pAntiCache;
			
			// Déclaration de l'objet de chargement
			chargeur = new URLLoader();
			
			// Précise le type de donnée qu'on veux résupérer après chargement
			chargeur.dataFormat = URLLoaderDataFormat.TEXT;
			
			// Ecoute de l'evenement lorsque le téléchargement commence suite à un appel de la méthode URLLoader.load()
			chargeur.addEventListener( Event.OPEN, redirigeEvenement );
			
			// Ecoute de l'evenement "en cours de chargement"
			chargeur.addEventListener( ProgressEvent.PROGRESS, redirigeEvenement );
			
			// Ecoute de l'evenement "chargement terminé"
			chargeur.addEventListener( Event.COMPLETE, chargementTermine );
			
			// Ecoute de l'evenement su statut HTTP de chargement
			chargeur.addEventListener( HTTPStatusEvent.HTTP_STATUS, redirigeEvenement );
			
			// Ecoute de l'evenement des éventuelles erreurs de chargement
			chargeur.addEventListener( IOErrorEvent.IO_ERROR, redirigeEvenement );
			chargeur.addEventListener( IOErrorEvent.IO_ERROR, handleIOError );
			
			// Ecoute de l'evenement des erreurs de sécurité de chargement ( Distribué si un appel de la méthode URLLoader.load() 
			// tente de charger des données d'un serveur en dehors d'un sandbox de sécurité. )
			chargeur.addEventListener ( SecurityErrorEvent.SECURITY_ERROR, redirigeEvenement );
			
		};
		
		/**
		* Méthode de Redirection / Diffusion d'evenement. Sera récupéré par les objets utilisant cette classe
		*
		* @param pEvt:Event.
		* @return  void
		* @see 
		* @todo 
		*/
		private function redirigeEvenement( pEvt:Event ):void{
			
			
			// Diffusion de l'evenement qui à lancé cette méthode
			dispatchEvent( pEvt );
			
		};
		
		private function handleIOError(e:IOErrorEvent):void
		{
			throw new Error("The file \""+url+"\" has not been found");
		}
		
		
		/**
		* La méthode de chargement du fichier. Prend en paramêtre l'objet de type URLRequest qui va appeler le fichier à charger
		*
		* @param pRequete:URLRequest
		* @return  void
		* @see 
		* @todo 
		*/
		public function charge( pRequete:URLRequest ):void{
						
			if( antiCache ){
				
				pRequete.requestHeaders.push( new URLRequestHeader("pragma", "no-cache") );
				
			}
			
			chargeur.load( pRequete );			
			
		};
		
		public function load(_url:String):void
		{
			url = _url;
			this.charge(new URLRequest(url));
		}
		
		/**
		* La méthode Lancée lorsque le chargement du fichier est fini. 
		*
		* @param pEvt:Event
		* @return  void
		* @see 
		* @todo 
		*/
		private function chargementTermine( pEvt:Event ):void{
			
			try{
			
				// récupération des données xml chargée
				_dataStr = pEvt.target.data;
				fluxXML = new XML( pEvt.target.data );
			
			}catch( pErreur:Error ){
				
				trace( pErreur );
				
			}
			
			// Et diffusion de l'evenement qui à lancé cette méthode ( donc Event.COMPLETE )
			dispatchEvent( pEvt );
						
		};
		
		/**
		* Methode publique qui servira à retourner les données fluxXml récupérée
		*
		* @param rien
		* @return  un objet XML
		* @see 
		* @todo 
		*/
		public function get donnees():XML{
			
			return fluxXML;
			
		};
		
		public function get xmlList():XMLList
		{
			return new XMLList(donnees);
		}
		
		public function get dataStr():String
		{
			return _dataStr;
		}
		
		
		
		//compte le nombre de balise _elmt dans le noeud _path
		//ex count("FR.CHAPITRES", "ITEM");
		public function count(_path:String, _elmt:String):uint
		{
			var _xmlList:XMLList = new XMLList(donnees);
			var _count:uint = 0;
			var _list:XMLList = getXmlListByString(_path, _xmlList);
			for (var i in _list[_elmt]) _count++;
			return _count;
		}
		
		
		public function getNode(_path:String, _elmt:String, _ind:int = 0):XML
		{
			var _xmlList:XMLList = new XMLList(donnees);
			var _list:XMLList = getXmlListByString(_path, _xmlList);
			return _list[_elmt][_ind];
		}
		
		private function getXmlListByString(_path:String, _xmllist:XMLList):XMLList
		{
			var _tabpath:Array = _path.split(".");
			var _lenpath:uint = (_path!="") ? _tabpath.length : 0;
			var _list:XMLList = _xmllist;
			for (var j:int = 0; j < _lenpath; j++) _list = _list[_tabpath[j]];
			return _list;
		}
		
		
	}
	
}




