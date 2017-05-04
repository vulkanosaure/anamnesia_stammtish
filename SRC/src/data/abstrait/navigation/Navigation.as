/*
TODO :

- test si id rubric existe deja (soit multilevel, soit unilevel, dépent de point précédent)										OK
- tester links sans idlink (pas pris en compte j'crois)																			OK
- tester multilevel																												OK
- fausse addresse																												OK
- initialisation (contact?)																										OK
- ajouter links footer																											OK
- actualisation link : interface ou héritage (NavigationLink) pour method updateSelection(id:int):void							OK
- renommer _object en navigationLink et _idobject en _idlink (NavigationEvent, NavigationLinkDef)								OK
- voir si NavigationRubric peut fonctionner en composition plutot qu'en héritage (propriété sprite), moins contraignant			OK
- sprite.dispatchEvent(...), du coup _sprite n'est pas obligé d'heriter ou d'implémenter qqchose..., pareil pour NavigationLink	OK
- mode d'emploi																													OK 
- se débarasser de NavigationEvent._navigationLink ?																			OK
- problématique : un _idrubDefault par NavigationRubric (si conteneur) ?														OK
- Navigation.setRubRoot(_sprite:Sprite) (guide)																					OK
- tester sous rubs "votre activite"																								OK
- gestion erreur si pas de flagdefaut dans une rubrique (non finale)															OK
- doc à jour																													OK
- PROBLEME : peut plus naviguer avec precedent/suivant																			OK
- ajouter last ss rub votre activite																							OK
- ajouter pagination ? (optique de test a donf)																					todo


title html (gestion couplage, de précis à global avec séparateur (ex : " - "))													OK
idunique pour pouvoir donner le meme idnavigation à différents level
unselect menu qui n'ont pas donné accès a l'élement courant ?




WARNINGS :
2 rubriques ne peuvent pas avoir le mm identifiant (actuellement du moins), meme sur != levels




DOC : 


IMPLEMENTATION :

Navigation.addLink("savoir-faire", "root", menuTop, 1);
Navigation.addLink("votre-activite", "root", menuTop, 2);
Navigation.addLink("qui-sommes-nous", "root", menuTop, 3);

Navigation.addLink("savoir-faire", "root", footer, 1);
Navigation.addLink("votre-activite", "root", footer, 2);
Navigation.addLink("qui-sommes-nous", "root", footer, 3);

Navigation.setRoot("root", "title", this);
Navigation.addRub("savoir-faire", 2, "root", "title", true);
Navigation.addRubContainer("votre-activite", 3, page_activite, "root", "title");
Navigation.addRub("qui-sommes-nous", 4, "root", "title");


SPRITES DE RUBRIQUES :

peuvent contenir d'autre rubrique
il en existe toujours une "root"
rubrique.addEventListener(NavigationEvent.NAVIGATE, onNavigate);
//NavigationEvent.idrubric


SPRITES DE NAVIGATION :

elmts cliquables permettant de changer de rub
peuvent contenir plusieurs Liens, identifiés par un int (ex : menu, footer)

au click :
	var evt:NavigationEvent = new NavigationEvent(NavigationEvent.LINK, idlink);
	spritenavigation.dispatchEvent(evt);
	 
spritenavigation.addEventListener(NavigationEvent.UPDATE_LINK, onUpdateLink);
//NavigationEvent.idlink







WARNINGS :
	il faut définir les link avant les rubs (si init appelé en interne)

*/




package data.abstrait.navigation 
{
	import data.javascript.SWFAddress;
	import data.javascript.SWFAddressEvent;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Vincent
	 */
	public class Navigation
	{
		public function Navigation() 
		{
			throw new Error("Class Navigation is static, it can't be instanciated");
		}
		
		
		//_______________________________________________________________________________
		// properties
		
		
		private static const ADDRESS_SEPARATOR:String = "/";
		private static const TITLE_SEPARATOR:String = " - ";
		
		public static const ORDER_FORWARD:String = "orderForward";
		public static const ORDER_BACKWARD:String = "orderBackward";
		
		
		private static var titleOrder:String = ORDER_BACKWARD;
		private static var links:Array;
		private static var rubs:Array;
		private static var rubRoot:NavigationRubric;
		private static var swfaddressInit:String;
		private static var firstChange:Boolean = true;
		private static var firstMatch:Boolean = true;
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		
		public static function setRoot(_id:String, _title:String, _sprite:Sprite):void
		{
			if (rubRoot != null) throw new Error("you have to call setRoot only once");
			addRubContainer(_id, 0, _sprite, "", _title, true);
			
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onSWFAddressChange);
		}
		
		
		public static function addRub(_id:String, _idint:int, _idparent:String, _title:String, _flagdefault:Boolean=false, _navigable:Boolean=true):void
		{
			addRubContainer(_id, _idint, null, _idparent, _title, _flagdefault, _navigable);
		}
		
		
		
		public static function addRubContainer(_id:String, _idint:int, _sprite:Sprite, _idparent:String, _title:String, _flagdefault:Boolean=false, _navigable:Boolean=true):void
		{
			if (rubs == null) rubs = new Array();
			
			checkId(_id);
			if (_id == "") throw new Error("arg id must have a value");
			if (idExist(_id)) throw new Error("_id " + _id + " allready exists (must be unique)");
			
			var _rub:NavigationRubric = new NavigationRubric();
			_rub.setNavigationParams(_id, _idint, _sprite, _idparent, _title, _flagdefault, _navigable);
			rubs.push(_rub);
			//on garde une reference vers le root
			if (_idparent == "") rubRoot = _rub;
			
			//trace("addRub " + _id);
			if (!firstMatch) {
				if (addressMatch(swfaddressInit)) {
					update(swfaddressInit);
					firstMatch = true;
				}
			}
		}
		
		public static function setTitleOrder(_order:String):void
		{
			if (_order != ORDER_BACKWARD && _order != ORDER_FORWARD) throw new Error("wrong value for arg _order, possible values are " + ORDER_BACKWARD + ", " + ORDER_FORWARD);
			titleOrder = _order;
		}
		
		
		public static function addLink(_idrub:String, _idparent:String, _navigationLink:Sprite, _idlink:int):void
		{
			if (links == null) links = new Array();
			
			checkId(_idrub);
			var _linkdef:NavigationLinkDef = new NavigationLinkDef();
			
			_linkdef._idrub = _idrub;
			_linkdef._idparent = _idparent;
			_linkdef._navigationLink = _navigationLink;
			_linkdef._idlink = _idlink;
			links.push(_linkdef);
			
			_navigationLink.addEventListener(NavigationEvent.LINK, onLink);
			
			//trace("addLink " + _idrub);
		}
		
		
		public static function getSprite(_idint:int, _idparent:String):Sprite
		{
			var _len:int = rubs.length;
			var _rub:NavigationRubric;
			for (var i:int = 0; i < _len; i++) 
			{
				_rub = NavigationRubric(rubs[i]);
				if (_rub.idint == _idint && _rub.idparent == _idparent) return _rub.sprite;
			}
			return null;
		}
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		private static function idExist(_id:String):Boolean
		{
			var _len:uint = rubs.length;
			var _rub:NavigationRubric;
			for (var i:int = 0; i < _len; i++) {
				_rub = NavigationRubric(rubs[i]);
				if (_rub.idnavigation == _id ) return true;
			}
			return false;
		}
		
		private static function getInfoLink(_navigationLink:Sprite, _idlink:int):Object
		{
			var _len:uint = links.length;
			var _linkdef:NavigationLinkDef;
			for (var i:int = 0; i < _len; i++) {
				_linkdef = NavigationLinkDef(links[i]);
				if (_navigationLink == _linkdef._navigationLink && _idlink == _linkdef._idlink) 
					return {"idrub" : _linkdef._idrub, "idparent" : _linkdef._idparent};
			}
			throw new Error("no idrub found for _navigationLink " + _navigationLink + " and _idlink " + _idlink);
		}
		
		private static function getRubric(_id:String, _idparent:String):NavigationRubric
		{
			var _len:uint = rubs.length;
			var _rub:NavigationRubric;
			for (var i:int = 0; i < _len; i++) {
				_rub = NavigationRubric(rubs[i]);
				if (_rub.idnavigation == _id && _rub.idparent==_idparent) return _rub;
			}
			return null;
		}
		
		
		private static function checkId(id:String):void
		{
			//trace("checkId(" + id + ")");
			if (id.charAt(0) == "/") throw new Error("id rubric can't start with char '/'");
			if (id.search(ADDRESS_SEPARATOR) != -1) throw new Error("id rubric cannot contain char '" + ADDRESS_SEPARATOR + "' (separator char)");
			
		}
		
		
		private static function getChildrub(_str:String, _rubparent:NavigationRubric):NavigationRubric
		{
			var _len:uint = rubs.length;
			var r:NavigationRubric;
			for (var i:int = 0; i < _len; i++) {
				r = NavigationRubric(rubs[i]);
				if (r.idnavigation == _str && r.idparent == _rubparent.idnavigation) return r;
			}
			return null;
		}
		
		private static function getDefaultRub(_rubparent:NavigationRubric):NavigationRubric
		{
			var _len:uint = rubs.length;
			var r:NavigationRubric;
			for (var i:int = 0; i < _len; i++) {
				r = NavigationRubric(rubs[i]);
				if (r.flagdefault && r.idparent == _rubparent.idnavigation) return r;
			}
			return null;
		}
		
		
		private static function getRubParent(_rub:NavigationRubric):NavigationRubric
		{
			var _len:uint = rubs.length;
			var r:NavigationRubric;
			for (var i:int = 0; i < _len; i++) {
				r = NavigationRubric(rubs[i]);
				if (r.idnavigation == _rub.idparent && getChildrub(_rub.idnavigation, r)!=null) return r;
			}
			return null;
		}
		
		private static function getNbSubRub(_rub:NavigationRubric):uint
		{
			var count:uint = 0;
			var _len:uint = rubs.length;
			var r:NavigationRubric;
			for (var i:int = 0; i < _len; i++) {
				r = NavigationRubric(rubs[i]);
				if (r.idparent == _rub.idnavigation) count++;
			}
			return count;
		}
		
		
		
		private static function addressMatch(_str:String):Boolean
		{
			var _tab:Array = _str.split(ADDRESS_SEPARATOR);
			var _len:int = _tab.length;
			var _rub:NavigationRubric = rubRoot;
			
			for (var i:int = 0; i < _len; i++) {
				_rub = getChildrub(_tab[i], _rub);
				if (_rub == null) return false;
			}
			return true;
		}
		
		
		
		//supprime les elmts de arriane a partir d'un élemt invalide
		
		static private function removeInvalidID(_tab:Array):Array
		{
			var _len:int = _tab.length;
			var _id:String;
			var _rubparent:NavigationRubric = rubRoot;
			var _rub:NavigationRubric;
			var _newtab:Array = new Array();
			
			for (var i:int = 0; i < _len; i++) {
				_id = _tab[i];
				_rub = getChildrub(_id, _rubparent);
				//si _id n'existe pas dans _rubparent
				
				if (_rub == null) {
					break;
				}
				
				_rubparent = _rub;
				_newtab.push(_id);
			}
			return _newtab;
		}
		
		static private function isLinkInArianne(_sprite:Sprite, _arrianne:Array):Boolean
		{
			var _len:int = links.length;
			var _link:NavigationLinkDef;
			for (var i:int = 0; i < _len; i++) {
				_link = NavigationLinkDef(links[i]);
				if (_link._navigationLink == _sprite) {
					if (_arrianne.indexOf(_link._idrub) != -1) return true;
				}
			}
			return false;
		}
		
		
		
		
		static private function addDefaultMissingID(_tab:Array):Array
		{
			//on cherche la rub la plus pointue de _tabArianne
			var startRub:NavigationRubric = rubRoot;
			var _len:int = _tab.length;
			var _id:String;
			for (var i:int = 0; i < _len; i++) {
				_id = _tab[i];
				startRub = getChildrub(_id, startRub);
			}
			//trace("startRub : " + startRub.sprite);
			var r:NavigationRubric;
			
			var secu:int = 0;
			while (secu < 20) {
				//si elle est container
				if (getNbSubRub(startRub) > 0) {
					r = getDefaultRub(startRub);
					//si defaut existe
					if (r != null) {
						//on ajoute a _tabArianne l'id de la rub defaut
						_tab.push(r.idnavigation);
					}
					else throw new Error("no rubric default found in rubric "+startRub.sprite);
				}
				//si elle est finale casse boucle
				else break;
				//recommence avec la rubrique enfant
				startRub = getChildrub(r.idnavigation, startRub);
				secu++;
			}
			//trace("secu : " + secu);
			return _tab;
		}
		
		
		
		
		static private function getAddressByTab(_tab:Array):String
		{
			var _swfadress:String = "";
			var _len:uint = _tab.length;
			for (var i:int = 0; i < _len;i++){
				_swfadress += _tab[i] + ADDRESS_SEPARATOR;
			}
			return _swfadress;
		}
		
		
		static public function update(_swfadress:String):void
		{
			//trace("update(" + _swfadress + ")");
			var _len:uint;
			//remove first and last char (/)
			_len = _swfadress.length;
			if(_swfadress.charAt(0)=="/") _swfadress = _swfadress.substr(1, _len - 1);
			_len = _swfadress.length;
			if (_swfadress.charAt(_len - 1) == "/") _swfadress = _swfadress.substr(0, _len - 1);
			
			
			//si 1ere arrivée avec une url définie
			if (firstChange && _swfadress!="") {
				//trace("Init with value!___");
				firstMatch = (addressMatch(_swfadress));
				swfaddressInit = _swfadress;
			}
			else if (firstChange) trace("Init sans value");
			firstChange = false;
			
			
			var _tabArianne:Array = _swfadress.split(ADDRESS_SEPARATOR);
			
			_tabArianne = removeInvalidID(_tabArianne);
			_tabArianne = addDefaultMissingID(_tabArianne);
			//trace("_tabArianne corrected : " + _tabArianne);
			
			
			//warning : tabArianne est mnt ds l'ordre
			var _rub:NavigationRubric;
			var _rubparent:NavigationRubric = rubRoot;
			//trace("_rubparent : " + _rubparent);
			
			var _tabTitle:Array = new Array();
			_tabTitle.push(rubRoot.title);
			var _linkdef:NavigationLinkDef;
			var _nLnk:Sprite;
			
			
			_len = _tabArianne.length;
			for (var i:int = 0; i < _len; i++) {
				_rub = getRubric(_tabArianne[i], _rubparent.idnavigation);
				
				//trace("SWFAddress.update, _rub : " + _rub);
				
				if (_rub.navigable || !_rub.firstDisplay) {
					_rub.firstDisplay = true;
					
					if (_rub.title != "") _tabTitle.push(_rub.title);
					
					//trace("getRubric("+_tabArianne[i]+", "+_rubparent.idnavigation+") : "+_rub);
					if (_rubparent.sprite == null) throw new Error("rubric \"" + _rubparent.idnavigation + "\" is not defined as a container rubric");
					
					var _evt:NavigationEvent = new NavigationEvent(NavigationEvent.NAVIGATE, -1);
					_evt.idrubric = _rub.idint;
					_rubparent.sprite.dispatchEvent(_evt);
					
					
					//boucle qui parcours les links de cette rubrique
					for (var k:int = 0; k < links.length; k++) {
						_linkdef = NavigationLinkDef(links[k]);
						
						if (_linkdef._idrub == _tabArianne[i]) {						
							_nLnk = _linkdef._navigationLink;
							_nLnk.dispatchEvent(new NavigationEvent(NavigationEvent.UPDATE_LINK, _linkdef._idlink));
						}
					}
					_rubparent = _rub;
				}
			}
			
			
			//parcours tous les links (sprite unique)
			var _tabSaveLinks:Array = new Array();
			
			for (var j:int = 0; j < links.length; j++) {
				_linkdef = NavigationLinkDef(links[j]);
				if (_tabSaveLinks.indexOf(_linkdef._navigationLink) != -1) continue;
				_tabSaveLinks.push(_linkdef._navigationLink);
				//si le link ne contient pas d'id d'arianne : on lui dispatch -1
				if (!isLinkInArianne(_linkdef._navigationLink, _tabArianne)) {
					_nLnk = _linkdef._navigationLink;
					_nLnk.dispatchEvent(new NavigationEvent(NavigationEvent.UPDATE_LINK, -1));
				}
			}
			
			
			
			//reconstitution du title
			if (titleOrder == ORDER_BACKWARD) _tabTitle = _tabTitle.reverse();
			
			_len = _tabTitle.length;
			var _strTitle:String = "";
			for (i = 0; i < _len; i++) {
				if (i > 0) _strTitle += TITLE_SEPARATOR;
				_strTitle += _tabTitle[i];
			}
			
			
			SWFAddress.setTitle(_strTitle);
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		static private function onLink(e:NavigationEvent):void 
		{
			
			var _infoLink:Object = getInfoLink(Sprite(e.target), e.idlink);
			var _idrub:String = _infoLink.idrub;
			var _idparent:String = _infoLink.idparent;
			//trace("onLink " + e.idlink + ", " + e.target+", info : "+_idrub+", "+_idparent);
			
			var _rubTarget:NavigationRubric = getRubric(_idrub, _idparent);
			
			//warning : tabArianne commence par la fin (root en dernier)
			var _tabArianne:Array = new Array();
			var _rub:NavigationRubric = _rubTarget;
			var _rubparent:NavigationRubric;
			
			var countsecu:int = 0;
			while (countsecu<99) {
				_rubparent = getRubParent(_rub);
				if (_rubparent == null) break;
				
				_tabArianne.push(_rub.idnavigation);
				_rub = _rubparent;
				countsecu++;
			}
			
			_tabArianne = _tabArianne.reverse();
			_tabArianne = addDefaultMissingID(_tabArianne);
			
			//reconstitue la value du swfaddress
			var _swfadress:String = getAddressByTab(_tabArianne);
			//trace("_swfadress : " + _swfadress);
			SWFAddress.setValue(_swfadress);
			
			
			
		}
		
		
		
		
		
		
		static private function onSWFAddressChange(e:SWFAddressEvent):void 
		{
			//trace("Navigation.onSWFAddressChange " + e.value + ", firstChange : " + firstChange);
			update(e.value);
		}	
	}
}

