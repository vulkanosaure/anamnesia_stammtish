/*
TODO :



WARNINGS :
	2 rubriques ne peuvent pas avoir le mm identifiant (actuellement du moins), meme sur != levels
	il faut définir les link avant les rubs (si init appelé en interne)



DOC : 



*/




package data2.states.navigation 
{
	import data.javascript.SWFAddress;
	import data.javascript.SWFAddressEvent;
	import data2.behaviours.menu.Menu;
	import data2.states.StateEngine;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
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
		private static var _tabArianne:Array;
		private static var _evtDispatcher:EventDispatcher;
		private static var _menuAssociations:Array;
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		
		public static function init():void
		{
			
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onSWFAddressChange);
		}
		
		
		public static function setRoot(_id:String, _title:String, _sprite:Sprite):void
		{
			if (rubRoot != null) throw new Error("you have to call setRoot only once");
			addRubContainer(_id, 0, _sprite, "", _title, true);
			
			
		}
		
		
		static public function reset():void 
		{
			rubRoot = null;
			rubs = new Array();
		}
		
		
		public static function addRub(_id:String, _idint:int, _idparent:String, _title:String, _flagdefault:Boolean=false, _navigable:Boolean=true):void
		{
			//trace("addRub(" + _id + ", " + _idint + ", " + _idparent + ", " + _title + ", " + _flagdefault + ", " + _navigable + ")");
			addRubContainer(_id, _idint, null, _idparent, _title, _flagdefault, _navigable);
		}
		
		
		
		public static function addRubContainer(_id:String, _idint:int, _sprite:Sprite, _idparent:String, _title:String, _flagdefault:Boolean=false, _navigable:Boolean=true):void
		{
			//trace("addRubContainer(" + _id + ", " + _idint + ", " + _sprite + ", " + _idparent + ", " + _title + ", " + _flagdefault + ", " + _navigable + ")");
			
			
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
		
		public static function dispatchEvent(_evt:Event):void
		{
			if ( _evtDispatcher == null) _evtDispatcher = new EventDispatcher();
			_evtDispatcher.dispatchEvent(_evt);
		}
		
		public static function addEventListener(_type:String, _handler:Function):void
		{
			if ( _evtDispatcher == null) _evtDispatcher = new EventDispatcher();
			_evtDispatcher.addEventListener(_type, _handler);
		}
		
		public static function setTitleOrder(_order:String):void
		{
			if (_order != ORDER_BACKWARD && _order != ORDER_FORWARD) throw new Error("wrong value for arg _order, possible values are " + ORDER_BACKWARD + ", " + ORDER_FORWARD);
			titleOrder = _order;
		}
		
		
		
		
		static public function goto_(_idparent:String, _idrub:String):void
		{
			//trace("Navigation.goto(" + _idparent + ", " + _idrub + ")");
			var _rubTarget:NavigationRubric = getRubric(_idrub, _idparent);
			
			//warning : tabArianne commence par la fin (root en dernier)
			var _tabArianne:Array = new Array();
			var _rub:NavigationRubric = _rubTarget;
			var _rubparent:NavigationRubric;
			
			var countsecu:int = 0;
			while (countsecu < 99) {
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
		
		
		
		
		public static function addMenuAssociation(_menu:Menu, _index:int, _stateparent:String, _state:String):void
		{
			//trace("Navigation.addMenuAssociation(" + _menu + ", " + _index + "," + _stateparent + ", " + _state + ")");
			
			if (_menuAssociations == null) _menuAssociations = new Array();
			var _menuAssoc:MenuAssociation = new MenuAssociation(_menu, _index, _stateparent, _state);
			_menuAssociations.push(_menuAssoc);
			
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
		
		
		
		
		private static function getMenuAssociation(_stateparent:String, _state:String):MenuAssociation
		{
			if (_menuAssociations == null) return null;
			
			var _len:int = _menuAssociations.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _menuAssoc:MenuAssociation = MenuAssociation(_menuAssociations[i]);
				if (_menuAssoc.stateparent == _stateparent && _menuAssoc.state == _state) return _menuAssoc;
			}
			return null;
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
			trace("update(" + _swfadress + ")");
			
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
			else if (firstChange) {
				//trace("Navigation.Init sans value");
			}
			firstChange = false;
			
			
			_tabArianne = _swfadress.split(ADDRESS_SEPARATOR);
			
			_tabArianne = removeInvalidID(_tabArianne);
			_tabArianne = addDefaultMissingID(_tabArianne);
			//trace("_tabArianne corrected : " + _tabArianne);
			
			
			//warning : tabArianne est mnt ds l'ordre
			var _rub:NavigationRubric;
			var _rubparent:NavigationRubric = rubRoot;
			//trace("_rubparent : " + _rubparent);
			
			var _tabTitle:Array = new Array();
			_tabTitle.push(rubRoot.title);
			
			
			_len = _tabArianne.length;
			var _syncStateEngine:Boolean = true;
			
			for (var i:int = 0; i < _len; i++) {
				_rub = getRubric(_tabArianne[i], _rubparent.idnavigation);
				
				//trace("SWFAddress.update, _rub : " + _rub);
				
				if (_rub.navigable || !_rub.firstDisplay) {
					_rub.firstDisplay = true;
					
					if (_rub.title != "") _tabTitle.push(_rub.title);
					
					//trace("getRubric("+_tabArianne[i]+", "+_rubparent.idnavigation+") : "+_rub);
					if (_rubparent.sprite == null) throw new Error("rubric \"" + _rubparent.idnavigation + "\" is not defined as a container rubric");
					
					
					StateEngine.goto_(_rubparent.idnavigation, _rub.idnavigation, _syncStateEngine);
					_syncStateEngine = false;
					
					//menu association (update_link)
					var _menuAssoc:MenuAssociation = getMenuAssociation(_rubparent.idnavigation, _rub.idnavigation);
					if (_menuAssoc != null) {
						_menuAssoc.menu.selectedIndex = _menuAssoc.index;
					}
					
					
					_rubparent = _rub;
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
		
		
		
		static private function onSWFAddressChange(e:SWFAddressEvent):void 
		{
			//trace("Navigation.onSWFAddressChange " + e.value + ", firstChange : " + firstChange);
			update(e.value);
			dispatchEvent(new NavigationEvent(NavigationEvent.AFTER_ADDRESS_CHANGE, -1));
		}	
		
		static public function get tabArianne():Array 
		{
			return _tabArianne;
		}
	}
}

