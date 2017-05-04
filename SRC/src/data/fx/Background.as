package data.fx {
	
	import data.net.DynLoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	/**
	* @author Pierre-Antoine Gervais ; modif/ajouts hugo le 08/01/10, supression des anciens bitmap si chargement de nouveaux, ajout dispatcheEvent
	* EVENT_INIT_BM lors du chargement d'un nouveau Bitmap
	* @version 1.0 (22/06/2009)
	*/
	
	public class Background extends Sprite implements IBackground {
		
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		// 						VARIABLES						//
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		
		// ALIGNEMENT
		/**
		* centre le background verticalement et horizontalement. L'accroche est au centre du background
		*/
		public static const ALIGN_CENTER:String = "center";
		/**
		* centre le background horizontalement, et l'aligne sur le dessus de la scène.
		*/
		public static const ALIGN_TOP:String = "top";
		/**
		* centre le background horizontalement, et l'aligne sur le bas de la scène.
		*/
		public static const ALIGN_BOTTOM:String = "bottom";
		/**
		* centre le background verticalement, et l'aligne sur la gauche de la scène.
		*/
		public static const ALIGN_LEFT:String = "left";
		/**
		* centre le background verticalement, et l'aligne sur la droite de la scène.
		*/
		public static const ALIGN_RIGHT:String = "right";
		/**
		* aligne le background sur la gauche et le dessus de la scène.
		*/
		public static const ALIGN_TOP_LEFT:String = "top_left";
		/**
		* aligne le background sur la droite et le dessus de la scène.
		*/
		public static const ALIGN_TOP_RIGHT:String = "top_right";
		/**
		* aligne le background sur la gauche et le bas de la scène.
		*/
		public static const ALIGN_BOTTOM_LEFT:String = "bottom_left";
		/**
		* aligne le background sur la droit et le bas de la scène.
		*/
		public static const ALIGN_BOTTOM_RIGHT:String = "bottom_right";
		
		// EVENEMENT
		/**
		* événement diffusé lorsque la classe Background est instanciée
		*/
		public static const EVENT_INIT:String = "init";
		/**
		* événement diffusé lors de l'initialisation du chargement du BitMap
		*/
		public static const EVENT_INIT_BM:String = "init_bm";
		/**
		* événement diffusé lorsque l'image chargée est chargée complètement
		*/
		public static const EVENT_LOADED:String = "loaded";
		/**
		* événement diffusé lorsque l'image est chargée
		* @see loadingInfo
		*/
		public static const EVENT_PROGRESS:String = "progress";
		/**
		* événement diffusé lorsque la scène est redimensionnée
		*/
		public static const EVENT_RESIZE:String = "resize";
		/**
		* événement diffusé lorsque l'instance de Background est ajouté à la Display List
		*/
		public static const EVENT_SHOWN:String = "shown";
		
		private var align:String; // savoir si le bg est centré ou aligné sur un bord.
		private var bm:Bitmap; // affiche bmd
		private var bmd:BitmapData; // contient l'image
		private var imageUrl:String; // url de l'image chargée, ou à charger
		private var keepProportions:Boolean; // si false, l'image s'adapte à la taille, si true > crop
		private var loader:DynLoader; // charge l'image dont l'url est imageUrl
		private var loaderConteneur:MovieClip = new MovieClip();
		
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		// 					CONSTRUCTEUR					//
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		
		/**
		* La classe Background gère les fond d'écran bitmap en plein écran. Le bitmap est lissé. La classe Background implémente l'interface IBackground. L'ajout d'une instance de Background à la Display List modifie les propriétés d'alignement de la scène. stage.scaleMode est à StageScaleMode.NO_SCALE et stage.align est à StageAlign.TOP_LEFT
		* - 
		* <div class="code">import data.fx.Background;
		* import data.fx.IBackground;
		* <br />
		* var monBackground:IBackground;
		* monBackground = new Background("image.jpg");
		* addChild(monBackground.sprite);
		* </div>
		* Pour un exemple d'utilisation de la classe, voir AS3-EXEMPLES\Background\background.fla
		* - 
		* @param pImageUrl url de l'image à charger. Valeur par défault : "";
		* @param pAlign alignement de l'image par rapport à stage. Valeur par défaut : "". Défini l'alignement sur ALIGN_CENTER
		* @param pKeepProportions Si défini à true, l'image conserve son rapport hauteur/largeur. Si défini à false, l'image peut être étirée et déformée. Valeur par défaut : true
		*/
		public function Background(pImageUrl:String = "", pAlign:String = "", pKeepProportions:Boolean = true) {
			imageUrl = pImageUrl;
			
			if(pAlign == "") {
				align = ALIGN_CENTER;
			} else if(pAlign == ALIGN_CENTER || pAlign == ALIGN_TOP || pAlign == ALIGN_BOTTOM || pAlign == ALIGN_LEFT || pAlign == ALIGN_RIGHT || pAlign == ALIGN_TOP_LEFT || pAlign == ALIGN_TOP_RIGHT || pAlign == ALIGN_BOTTOM_LEFT || pAlign == ALIGN_BOTTOM_RIGHT) {
				align = pAlign;
			} else {
				throw new Error("Second parameter (optional) of class Background constructor must be a constant static String of Background (ALIGN_CENTER, ALIGN_TOP, ALIGN_BOTTOM, ALIGN_LEFT, ALIGN_RIGHT, ALIGN_TOP_LEFT, ALIGN_TOP_RIGHT, ALIGN_BOTTOM_LEFT, ALIGN_BOTTOM_RIGHT)");
			}
			
			keepProportions = pKeepProportions;
			loader = new DynLoader();
			loader.name = "loader";
			
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadFinished);	
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoadInitBm);	
			dispatchEvent(new Event(EVENT_INIT));
		}
		
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		// 		FONCTIONS EVENEMENTIELLES		//
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		
		protected function onStage(evt:Event) {
			dispatchEvent(new Event(EVENT_SHOWN));
			if(imageUrl != "") {
				loadImage();
			}
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
		protected function onLoadFinished(evt:Event):void {
			
			if( bm != null ){
				
				loaderConteneur.removeChild( bm );
				bm = null;
				
			}
			
			dispatchEvent(new Event(EVENT_LOADED));
			bmd = new BitmapData(loader.width, loader.height, true, 0xFF000000);
			bmd.draw(loader);
			bm = new Bitmap(bmd, "auto", true);
			bm.smoothing = true;
			loaderConteneur.addChild(bm);
			addChild(loaderConteneur);
						
			stage.addEventListener(Event.RESIZE, adaptToStage);
			adaptToStage();
		}
		
		protected function onLoadInitBm( evt:Event ):void{
			
			dispatchEvent(new Event(EVENT_INIT_BM));
			
		}
		
		protected function onLoadProgress(evt:ProgressEvent):void {
			dispatchEvent(new Event(EVENT_PROGRESS));
		}
		
		
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		// 					FONCTIONS DIE					//
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		
		// gère la position et la taille du fond en fonction de la fenêtre actuelle du player
		protected function adaptToStage(evt:* = 0):void {
			dispatchEvent(new Event(EVENT_RESIZE));
			if(stage != null) {
				var scale:Number = 1;
				var tx:Number = 0;
				var ty:Number = 0;
				
				// DIMENSIONS
				if(keepProportions) {
					var rapportStage:Number = stage.stageWidth/stage.stageHeight;
					var rapportImage:Number = loader.width/loader.height;
					if(rapportStage < rapportImage) {
						// on calque la hauteur
						scale = stage.stageHeight/loader.height;
					} else {
						// on calque la largeur
						scale = stage.stageWidth/loader.width; // version matrice
					}
					bm.width  = loader.width*scale;
					bm.height = loader.height*scale;
				} else {
					bm.width  = stage.stageWidth;
					bm.height = stage.stageHeight;
				}
				
				// POSITION
				if(keepProportions) {
					switch(align) {
						case ALIGN_CENTER:
							tx = -((loader.width*scale)-stage.stageWidth)/2;
							ty = -((loader.height*scale)-stage.stageHeight)/2;
							break;
						case ALIGN_TOP:
								tx = -((loader.width*scale)-stage.stageWidth)/2;
								ty = 0;
							break;
						case ALIGN_BOTTOM:
							tx = -((loader.width*scale)-stage.stageWidth)/2;
							ty = stage.stageHeight-bm.height;
							break;
						case ALIGN_LEFT:
							tx = 0;
							ty = -((loader.height*scale)-stage.stageHeight)/2;;
							break;
						case ALIGN_RIGHT:
							tx = stage.stageWidth-bm.width;
							ty = -((loader.height*scale)-stage.stageHeight)/2;;
							break;
						case ALIGN_TOP_LEFT:
							tx = 0;
							ty = 0;
							break;
						case ALIGN_TOP_RIGHT:
							tx = stage.stageWidth-bm.width;
							ty = 0;
							break;
						case ALIGN_BOTTOM_LEFT:
							tx = 0;
							ty = stage.stageHeight-bm.height;
							break;
						case ALIGN_BOTTOM_RIGHT:
							tx = stage.stageWidth-bm.width;
							ty = stage.stageHeight-bm.height;
							break;
					}
				} else {
					tx = 0;
					ty = 0;
				}
				
				bm.x = tx;
				bm.y = ty;
			}
		}
		
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		// 				FONCTIONS DIVERSES			//
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		
		/**
		* La méthode loadImage() lance le chargement d'une image dans le fond d'écran. Si l'url de l'image est déjà donnée dans le constructeur, il n'est pas nécessaire de la redonner dans à méthode loadImage(). Dans le cas contraire, le paramètre devient obligatoire. Si l'url n'est renseignée ni dans le constructeur, ni dans la méthode loadImage(), la méthode retourne une erreur et ne charge rien.
		* Remarque : Si l'url est donnée en paramètre au constructeur, l'image sera chargée dès que l'instance sera ajoutée à la Display List. Il n'est donc pas nécessaire d'appeler loadImage().
		* - 
		* <div class="code">import data.fx.Background;
		* import data.fx.IBackground;
		* <br />
		* var monBackground:IBackground;
		* monBackground = new Background();
		* monBackground.loadImage("image.jpg");
		* addChild(monBackground.sprite);
		* </div>
		* - 
		* <div class="code">import data.fx.Background;
		* import data.fx.IBackground;
		* <br />
		* var monBackground:IBackground;
		* monBackground = new Background("image.jpg");
		* addChild(monBackground.sprite); <span class="commentaire">// l'ajout à la Display List dispense de l'appel de loadImage();</span>
		* </div>
		* Pour un exemple d'utilisation de la classe, voir AS3-EXEMPLES\Background\background.fla
		* - 
		* @param pImageUrl url de l'image à charger. Valeur par défault : "";
		*/
		public function loadImage(pImageUrl:String = ""):void {
			
			if(pImageUrl != "") { // si on appelle loadImage avec une url en paramèrte, c'est qu'on veut celle là (et on écrase l'url passée au constructeur)
				imageUrl = pImageUrl;
			}
			
			if(imageUrl != "") {
				loader.loadUrl(imageUrl);
			} else {
				throw new Error("Using loadImage() from class Background with no URL set yet. Use new Background(url:String) or loadImage(url:String).");
			}
		}
		
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		// 						ACCESSEURS					//
		// =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*	//
		
		/**
		* Contient les informations relatives au chargement de l'image. 
		* Valeurs accèssibles : bytesLoaded, bytesTotal, ratio, elapsedTime, estimatedTime, remainingTime
		* bytesLoaded : nombre d'octets chargés
		* bytesTotal : nombre d'octets total du fichier en chargement
		* ratio : proportion chargée
		* elapsedTime : temps écoulé depuis le début du chargement du fichier
		* estimatedTime : temps prévu pour le téléchargement complet du fichier
		* remainingTime : temps restant avant la fin du chargement du fichier
		* - 
		* <div class="code">import data.fx.Background;
		* import data.fx.IBackground;
		* var monBackground:IBackground = new Background("image.jpg");
		* monBackground.sprite.addEventListener(Background.EVENT_PROGRESS, onProgress);
		* addChild(monBackground.sprite);
		* function onProgress(evt:Event):void {
		* trace("elapsed = "+monBackground.loadingInfo.elapsedTime+" estimated = "+monBackground.loadingInfo.estimatedTime+" remaining = "+monBackground.loadingInfo.remainingTime);
}</div>
		* -
		* @return objet contenant les informations de chargement
		* @see DynLoader
		*/
		public function get loadingInfo():Object {
			return loader.loadingInfo;
		}
		
		/**
		* retourne l'instance visée étendant flash.display.Sprite
		* permet l'ajout sur la scène. La manipulation graphique de l'instance de Background se fait par l'intermédiaire de sa variable sprite
		* -
		* @return instance étendant Sprite
		*/
		public function get sprite():Sprite {
			return this;
		}

	}
}