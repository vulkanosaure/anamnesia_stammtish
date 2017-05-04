/*
QUESTIONS :

_prop, param dans le constructeur :
	philosophie ready-to-use (classe automonome sans fonction init a appeler, que des setter, voir Loader2
	
il faut un moyen pour faire réference a un objet depuis le asxml
	
bug
	si pas de noeud racine, runtime error sur method .name(), étudiers
	permettre qu'un fichier soit vide
	dataprovider.itemClass nécéssite le path complet vers la classe (voir registerClass)

A REFLECHIR :



___________________________
DOC :

pas besoin de noeud racine (apparement)
need to register classes (ASXML.registerClass)
in asxml, use import "..." to import another asxml file
use {holder.prop} in property value for data binding
use [instance id] in property value for referencing instance

*/

package data2.asxml 
{
	import data2.behaviours.BehaviourChild;
	import data2.display.Image;
	import data2.display.parallax.ParallaxContainer;
	import data2.display.timeline.Timeline;
	import data2.layoutengine.LayoutEngine;
	import data2.layoutengine.LayoutSprite;
	import data2.behaviours.Behaviour;
	import data2.display.scrollbar.Scrollbar;
	import data2.dynamiclist.DynamicList;
	import data2.InterfaceSprite;
	import data2.net.imageloader.ImageLoader;
	import data2.net.imageloader.ImageLoaderEvent;
	import data2.net.URLLoaderManager;
	import data2.display.skins.Skin;
	import data2.parser.StyleSheet2;
	import data2.text.Text;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Vincent
	 */
	public class ASXML
	{
		//_______________________________________________________________________________
		// properties
		
		private static const ADDCHILD_DEF:String = "modeAddChild";
		private static const BEHAVIOUR_DEF:String = "behaviours";
		private static const DYNAMICLIST_DEF:String = "dynamiclist";
		private static const CONDITION_DEF:String = "if";
		
		private static const DYNAMIC_VALUES_PREFIX:Array = ["flashvars", "xmlnode", "session", "search", "file", "constante"];
		
		
		
		
		private static var _baseContainer:DisplayObjectContainer;
		private static var _constructor:ASXMLRecursiveConstructor;
		private static var _evtDispatcher:EventDispatcher;
		private static var _stage:Stage;
		private static var _objects:Array;
		private static var _checkIDdoublons:Boolean;
		private static var _modeReset:Boolean;
		private static var _objectToReset:Object;
		private static var _idReset:String;
		
		private static var _ascodes:Array;
		private static var _item2inits:Array;
		private static var _item2initsAppInit:Array;
		private static var _item2initsResetObject:Array;
		
		
		private static var DEBUG_MODE:Boolean;
		
		
		public function ASXML() 
		{
			throw new Error("ASXML is static");
			
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		public static function reset():void
		{
			ObjectSearch.resetID();
			
		}
		
		
		public static function init(_data:String, __baseContainer:DisplayObjectContainer, __stage:Stage, __DEBUG_MODE:Boolean):void
		{
			//trace("ASXML.init(" + __baseContainer + ")");
			
			_baseContainer = __baseContainer;
			_stage = __stage;
			DEBUG_MODE = __DEBUG_MODE;
			
			_ascodes = new Array();
			_item2initsAppInit = new Array();
			_item2inits = _item2initsAppInit;
			_objects = new Array();
			_modeReset = false;
			
			if (_constructor == null) _constructor = new ASXMLRecursiveConstructor();
			_constructor.addEventListener(Event.COMPLETE, onConstructorComplete);
			_constructor.init(_data);
			
		}
		
		
		public static function registerClass(_class:Class):void
		{
			ClassManager.registerClass(_class);
		}
		
		
		public static function ascodeInit():void
		{
			var _len:int = _ascodes.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _ascode:ASCode = ASCode(_ascodes[i]);
				_ascode.init();
			}
		}
		
		public static function ascodeExec():void
		{
			var _len:int = _ascodes.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _ascode:ASCode = ASCode(_ascodes[i]);
				_ascode.exec();
			}
		}
		
		
		public static function finalInitItem():void
		{
			var _len:int = _item2inits.length;
			//trace("finalInitItem (" + _len + ") : " + _item2inits);
			for (var i:int = 0; i < _len; i++) 
			{
				if(_item2inits[i][0] is InterfaceSprite){
					var _item:InterfaceSprite = InterfaceSprite(_item2inits[i][0]);
					_item.initBehaviours();
					_item.updateBehaviours();
					_item.initOnClick(_item2inits[i][1]);
				}
				else if(_item2inits[i][0] is Scrollbar){
					var _sb:Scrollbar = Scrollbar(_item2inits[i][0]);
					_sb.init(_baseContainer, _stage);
					
				}
				
				
			}
		}
		public static function initItemBtnEffect():void
		{
			var _len:int = _item2inits.length;
			//trace("finalInitItem (" + _len + ") : " + _item2inits);
			for (var i:int = 0; i < _len; i++) 
			{
				if (_item2inits[i][0] is InterfaceSprite) {
					var _item:InterfaceSprite = InterfaceSprite(_item2inits[i][0]);
					_item.initBtnEffect();
				}
				
			}
		}
		
		
		
		
		
		public static function resetObject(_dobjc:DisplayObjectContainer, _id:String = ""):void
		{
			var _obj:Object = null;
			var _len:int = _objects.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _o:Object = _objects[i];
				if (_o.object == _dobjc) {
					_obj = _o;
				}
			}
			if (_obj == null) throw new Error("Object " + ObjectSearch.formatObject(_dobjc) + " wasn't found");
			_objectToReset = _obj;
			_idReset = _id;
			
			while (_dobjc.numChildren) _dobjc.removeChildAt(0);
			
			trace("resetObject (" + _dobjc + ") ______________________________");
			//trace("xml : " + String(_objectToReset.xml));
			
			//preprocessing for preloading {file}
			var _eventAdded:Boolean = preprocessingPreloading(String(_objectToReset.xml));
			if (!_eventAdded) onPreprocessingResetComplete(new Event(Event.COMPLETE));
			else URLLoaderManager.addEventListener(Event.COMPLETE, onPreprocessingResetComplete);
			
			
		}
		
		private static function onPreprocessingResetComplete(e:Event):void
		{
			trace("onPreprocessingResetComplete");
			URLLoaderManager.resetEventListeners();
			var _dobjc:DisplayObjectContainer = DisplayObjectContainer(_objectToReset.object);
			
			_checkIDdoublons = false;
			_modeReset = true;
			
			var _groupimg:String = (_idReset == "") ? ImageLoader.GROUP_RESET : _idReset;
			trace("_groupimg : " + _groupimg);
			if (ImageLoader.groupExists(_groupimg)) ImageLoader.resetGroup(_groupimg);
			
			_item2initsResetObject = new Array();
			_item2inits = _item2initsResetObject;
			
			
			var _xmllist:XMLList = XMLList(_objectToReset.xml);
			
			//trace("scan_recursive " + _dobjc + "\n" + _xmllist);
			scan_recursive(_dobjc, _dobjc, _xmllist, ADDCHILD_DEF, null, 0, null);
			
			ImageLoader.addEventListener(ImageLoaderEvent.COMPLETE, onImageLoaderResetComplete);
			ImageLoader.loadGroup(_groupimg);
			
		}
		
		static private function onImageLoaderResetComplete(e:ImageLoaderEvent):void 
		{
			ImageLoader.removeEventListener(ImageLoaderEvent.COMPLETE, onImageLoaderResetComplete);
			var _dobjc:DisplayObjectContainer = DisplayObjectContainer(_objectToReset.object);
			LayoutEngine.applyCSS(_dobjc);
			ASXML.finalInitItem();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		public static function removeEventListener(_evt:String, _handler:Function):void
		{
			if (_evtDispatcher == null) _evtDispatcher = new EventDispatcher();
			_evtDispatcher.removeEventListener(_evt, _handler);
		}
		
		
		public static function addEventListener(_evt:String, _handler:Function):void
		{
			if (_evtDispatcher == null) _evtDispatcher = new EventDispatcher();
			_evtDispatcher.addEventListener(_evt, _handler);
		}
		
		public static function dispatchEvent(_evt:Event):void
		{
			if (_evtDispatcher == null) _evtDispatcher = new EventDispatcher();
			_evtDispatcher.dispatchEvent(_evt);
		}
		
		public static function get importedFiles():Array
		{
			if (_constructor.tabfiles == null) return new Array();
			else return _constructor.tabfiles;
		}
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		private static function construct(_data:String):void
		{
			_checkIDdoublons = true;
			
			
			var xmlList:XMLList = new XMLList((_data));
			_objects.push( { "object" : _baseContainer, "xml" : xmlList } );
			scan_recursive(_baseContainer, _baseContainer, xmlList, ADDCHILD_DEF, null, 0, null);
			
		}
		
		
		
		
		private static function scan_recursive(_container:*, _dobjc:DisplayObjectContainer, _xmllist:Object, _mode:String, _dynamicList:Object, _dynamicListIndex:int, _behaviour:Behaviour, _level:int=0):void
		{
			//TRAITEMENT DE L'ELMT
			
			
			var _childInstance:*;
			
			if (_level > 0) {
				//new : instanciateElement return {mode : "", child : ""}
				var _childInstance = instanciateElement(_container, _dobjc, _xmllist, _mode, _dynamicList, _dynamicListIndex, _behaviour, _level);
				if (!_modeReset) _objects.push( { "object" : _childInstance, "xml" : _xmllist } );
				/*
				if(_modeReset) tracelvl("SR " + ObjectSearch.formatObject(_container)+", "+ObjectSearch.formatObject(_childInstance)+", "+_dynamicListIndex, _level);
				if(_modeReset) tracelvl("childinstance : " + _childInstance, _level);
				*/
				//imbrication classique (addchild)
				if (_childInstance is DisplayObject) {
					_mode = ADDCHILD_DEF;
				}
				
				//dynamic list
				else if (_childInstance is DynamicList) {
					//trace("childInstance is DynamicList");
					_mode = DYNAMICLIST_DEF;
					_dynamicList = DynamicList(_childInstance);
				}
				//multi loop dynamic list
				else if (_childInstance is Array && _childInstance[0] is DynamicList) {
					_mode = DYNAMICLIST_DEF;
					_dynamicList = _childInstance;
				}
				//after dynamic list
				else if (_childInstance is Array) {
					//trace("childInstance is Array");
					_mode = ADDCHILD_DEF;
				}
				//condition
				else if (_childInstance is ASXMLCondition) {
					_mode = CONDITION_DEF;
					var _asxmlcondition:ASXMLCondition = ASXMLCondition(_childInstance);
				}
				//imbrication spécifique spécifique (ex : behaviour)
				else if (_childInstance is String) {
					_mode = _childInstance;
				}
				else if (_childInstance is Behaviour) {
					_behaviour = _childInstance;
				}
				
			}
			else _childInstance = _dobjc;
			
			if (_childInstance is DisplayObjectContainer) _dobjc = _childInstance;
			
			
			
			
			//RAPPEL RÉCURSIF SUR LES SOUS OBJETS
			
			var _listDobj:Array = (_childInstance is Array) ? _childInstance : [_dobjc];
			
			//trace("_childInstance : " + _childInstance);
			var _children:XMLList;
			
			var _childInstanceClassName:String = ObjectSearch.getOfficialClassName(_childInstance);
			var _childAsProp:String = ClassManager.getChildAsProp(_childInstanceClassName);
			//trace("_childAsProp : " + _childAsProp);
			
			if(_childAsProp == "") _children = _xmllist.children();			//here
			else _children = new XMLList();
			
			
			//tracelvl("childInstance : " + _childInstance, _level);
			
			//tracelvl("_listDobj : " + _listDobj + ", len : " + _listDobj.length, _level);
			
			var _len:int = _listDobj.length;
			_len = (_mode == DYNAMICLIST_DEF) ? DynamicList(_dynamicList).length : 1;
			
			
			if (_mode != CONDITION_DEF || _asxmlcondition.getResult()){
				
				for (var i:int = 0; i < _len; i++) 
				{
					
					var _dobjcontainer:DisplayObjectContainer;
					if (_childInstance is DisplayObjectContainer) _dobjcontainer = DisplayObjectContainer(_childInstance);
					else _dobjcontainer = _dobjc;
					
					//tracelvl("dobjcontainer [" + i + "] : " + _dobjcontainer, _level);
					if (_mode == DYNAMICLIST_DEF) _dynamicListIndex = i;
					
					//surement pour ne pas écraser l'index de sous objet
					//en fait il faut l'écraser des qu'on rencontre un nouveau dynamiclist
					
					for each(var _xml:XML in _children)
					{	
						if (!(_dobjc is DisplayObjectContainer)) throw new Error("you can't add children in " + ObjectSearch.formatObject(_childInstance) + ". It's not a DisplayObjectContainer");
						scan_recursive(_childInstance, _dobjcontainer, _xml, _mode, _dynamicList, _dynamicListIndex, _behaviour, _level + 1);
					}
					
					
					
					//SEPARATORS
					
					if (_mode == DYNAMICLIST_DEF) {
						var _dl:DynamicList = DynamicList(_dynamicList);
						if (_dl.classSeparator != null && i < _len - 1) {
							
							var _classTest:Class = _dl.classSeparator;
							var _separatorInstance:* = new _classTest();
							//trace("_separatorInstance : " + _separatorInstance);
							if (!(_separatorInstance is DisplayObject)) throw new Error("Class separator " + _dl.classSeparator + " must be a DisplayObject");
							DisplayObject(_separatorInstance).name = "separatorInstance";
							
							var _is:InterfaceSprite = new InterfaceSprite();
							_is.addChild(_separatorInstance);
							_is.classname = ObjectSearch.getClassName(_separatorInstance);
							_dobjcontainer.addChild(_is);
						}
					}
					
					
					//POST TRAITEMENT
					
					var _endingItem:*;
					if (_childInstance is Array && (_childInstance[0] is DisplayObject)) _endingItem = _dobjcontainer;
					else _endingItem = _childInstance;
					
					//tracelvl("-end " + _endingItem, _level);
					
					
					//register class
					ObjectSearch.registerClass(_endingItem);
					
					
					if (_endingItem is InterfaceSprite) {
						var _is:InterfaceSprite = InterfaceSprite(_endingItem);
						
						
						//templates
						
						if (_is.template != "" && _is.template != null) {
							_is.initTemplate();
						}
						
						
						_item2inits.push([_is, _dynamicListIndex]);
						
					}
					else if (_endingItem is Scrollbar) {
						//Scrollbar(_endingItem).init(_stage);	//todo : interface for init and post_init (Skin too)
						_item2inits.push([_endingItem, NaN]);
					}
					
					if (_endingItem is ParallaxContainer) {
						ParallaxContainer(_endingItem).initParallax(_stage);
					}
					
					if (_endingItem is Image) {
						if (_modeReset) {
							var _groupimg:String = (_idReset == "") ? ImageLoader.GROUP_RESET : _idReset;
							Image(_endingItem).group = _groupimg;
						}
						Image(_endingItem).init();
					}
					
					if (_endingItem is Text) {
						Text(_endingItem).updateText();
					}
					if (_endingItem is Timeline) {
						Timeline(_endingItem).initTimeline();
					}
					
				}
			}
			
		}
		
		
		
		
		
		private static function instanciateElement(_container:*, _dobjc:DisplayObjectContainer, _xmllist:Object, _mode:String, _dynamicList:Object, _dynamicListIndex:int, _behaviour:Behaviour, _level:int=0):*
		{
			var _childClassname:String = _xmllist.name();
			//tracelvl("instanciateElement(" + _container + ", " + _dobjc.name + ", " + _mode + ", " + _childClassname +", " + _dynamicList + ", " + _dynamicListIndex + ")", _level);
			
			var _childAsProp:String = ClassManager.getChildAsProp(_childClassname);
			//trace("instanciate, _childClassName : " + _childClassname + ", _childasprop : " + _childAsProp);
			
			
			//uniq instanciation for warning prevention
			var _tab:Array;
			
			
			//attributes extraction
			
			var _attributes:Object = new Object();
			var _attributesxmllist:XMLList = _xmllist.attributes();
			for (var _k:* in _attributesxmllist) {
				var _att:String = _attributesxmllist[_k].name();
				_attributes[_att] = _attributesxmllist[_k];
				//trace("_att : " + _att + ", " + _k + ", " + _attributes[_att]);
			}
			
			if (_childAsProp != "") {
				_attributes[_childAsProp] = XMLList(_xmllist).toString();
			}
			
			var _modelattributes:Object = new Object;
			for (var _key:String in _attributes) _modelattributes[_key] = _attributes[_key];
			
			
			//dynamic definitions {} (preprocessing)
			var _sessionList:Array = new Array();
			
			
			for (var _key:String in _modelattributes)
			{
				var _nbmatch:int;
				var _datakey:String;
				var _value:String;
				var _dynamicvalue:Object;
				
				
				do{
					
					_value = _attributes[_key];
					if (_value == null) break;
					
					_tab = _value.match(/{([\w\d:\/\.\*\#\-@]+?)}/g);
					_dynamicvalue;
					var _sessionKey:String = "";
					
					_nbmatch = _tab.length;
					
					for (var i:int = 0; i < _nbmatch; i++) {
						
						
						var _str:String = _tab[i];
						var _isSession:Boolean = false;
						
						var _objdynvalues:Object = getDynamicValueComponent(_str, "xmlnode");
						_datakey = _objdynvalues.datakey;
						var _prefix:String = _objdynvalues.prefix;
						var _subdatakey:String = _objdynvalues.subdatakey;
						
						/*
						_datakey = _str.substr(1, _str.length - 2);	//remove {}
						
						
						var _indexofPoint:int = _datakey.indexOf(":");
						
						var _prefix:String;
						var _subdatakey:String;
						
						if (_indexofPoint != -1) {
							_prefix = _datakey.substr(0, _indexofPoint);
							_subdatakey = _datakey.substr(_indexofPoint + 1, _datakey.length - (_indexofPoint + 1));
							//trace("_prefix : "+_prefix+", _subdatakey : " + _subdatakey);
						}
						else {
							_prefix = "xmlnode";			//default value
							_subdatakey = _datakey;
						}
						*/
						//trace("  --dynamicvalue prefix : " + _prefix + ", _subdatakey : " + _subdatakey);
						
						
						//dynindex
						if (_datakey.substr(0, String("dynindex").length)  == "dynindex") {
							
							var _numdynvalue:Number = _dynamicListIndex;
							
							var _tabdynindex:Array = _datakey.match(/^dynindex(([+|-|*|\/|%])(\d+))?$/);
							var _addsigne:String = _tabdynindex[2];
							var _addvalue:String = _tabdynindex[3];
							//trace("_addsigne : " + _addsigne + ", _addvalue : " + _addvalue);
							
							
							if (_addsigne != null && _addvalue != null) {
								if (_addsigne == "+") _numdynvalue += Number(_addvalue);
								else if (_addsigne == "-") _numdynvalue -= Number(_addvalue);
								else if (_addsigne == "*") _numdynvalue *= Number(_addvalue);
								else if (_addsigne == "/") _numdynvalue /= Number(_addvalue);
								else if (_addsigne == "%") _numdynvalue %= Number(_addvalue);
							}
							
							_dynamicvalue = String(_numdynvalue);
						}
						//flashvars
						else if(_prefix=="flashvars"){
							_dynamicvalue = ObjectSearch.flashvars(_subdatakey);
						}
						//search
						else if (_prefix == "search") {
							_dynamicvalue = ObjectSearch.search(_dobjc, _subdatakey);
						}
						//xmlnode
						else if (_prefix == "xmlnode") {
							var _dynlist:DynamicList = (_dynamicList is Array) ? DynamicList(_dynamicList[_dynamicListIndex]) : DynamicList(_dynamicList);
							_dynamicvalue = _dynlist.getDataByKey(_subdatakey, _dynamicListIndex);
							if (_dynamicvalue == null) _dynamicvalue = "";
							//trace("getdatabykey : " + _subdatakey + ", " + _dynamicListIndex + " : " + _dynamicvalue);
						}
						//session
						else if (_prefix == "session") {
							//to nothing : session are treated later cause they use data-binding
							if (true) {		//temp : desactive les session
								_dynamicvalue = Sessions.get(_subdatakey);
							}
							else{
								_isSession = true;
								_sessionKey = _subdatakey;
							}
						}
						//constantes
						else if (_prefix == "constante") {
							_dynamicvalue = Constantes.get(_subdatakey);
						}
						//file
						else if (_prefix == "file") {
							_dynamicvalue = URLLoaderManager.getData(_subdatakey);
						}
						
						else throw new Error("ASXML : prefix " + _prefix + " doesn't exist for dynamic definitions \n" + DYNAMIC_VALUES_PREFIX);
						
						if(!_isSession){
							if (_dynamicvalue is String) {
								_value = _value.replace("{" + _datakey + "}", _dynamicvalue);
								_attributes[_key] = _value;
							}
							else {
								_attributes[_key] = _dynamicvalue;
							}
						}
						
					}
					
					
					
					//register session definition
					//(set later because we need the object which is not instanciated yet)
					if (_sessionKey != "") {
						
						var _newvalue:String = _attributes[_key];
						_tab = _newvalue.match(/^(.*){session:.+?}(.*)$/);
						var _strbefore:String = _tab[1];
						var _strafter:String = _tab[2];
						
						_sessionList.push([_sessionKey, _key, _strbefore, _strafter]);
						//trace("sessionKey : " + _sessionKey+", delete attribute "+_key);
						delete _attributes[_key];
					}
					
				}
				while (_nbmatch > 0);
			}
			
			
			
			
			if (_childClassname == BEHAVIOUR_DEF) {
				_instanceChild = BEHAVIOUR_DEF;
			}
			else if (_childClassname == DYNAMICLIST_DEF) {
				var _instdynlist:DynamicList = new DynamicList();
				setProperties(_attributes, _instdynlist);
				_instanceChild = _instdynlist;
			}
			else if (_childClassname == CONDITION_DEF) {
				var _asxmlCondition:ASXMLCondition = new ASXMLCondition();
				setProperties(_attributes, _asxmlCondition);
				_instanceChild = _asxmlCondition;
			}
			else {
				
				//instanciation / property def
				
				//elmt to instanciate
				
				if (_childClassname != "$") {
					var _class:Class = ClassManager.getClassByName(_childClassname);
					if (_class == null) throw new Error("class \"" + _childClassname + "\" is not registered");
					
					
					
					//instanciation simple
					
					var _inst:* = new _class();
					//if (_inst is Text) setCSS(Text(_inst));			//stylesheet
					setProperties(_attributes, _inst);
					
					if (_inst is Skin) Skin(_inst).init();
					
					if (_inst is ASCode) {
						var _xmlnode:Object = (_dynamicList!=null) ? _dynamicList.getData(_dynamicListIndex) : null;
						var _ascodeinst:ASCode = ASCode(_inst);
						_ascodeinst.c = _dobjc;
						_ascodeinst.stage = _stage;
						_ascodeinst.xmlnode = _xmlnode;
						_ascodeinst.dynamicIndex = _dynamicListIndex;
						if (_dobjc is InterfaceSprite) InterfaceSprite(_dobjc).ascodeInstance = _ascodeinst;
						_ascodes.push(_ascodeinst);
					}
					
					if (_inst is InterfaceSprite) {
						var _is:InterfaceSprite = InterfaceSprite(_inst);
						if (_is.template != "" && _is.template != null) _is.instanciateTemplate();
					}
					
					var _instanceChild:* = _inst;
					
					
					//trace("_dobjc : " + _dobjc + ", _container : " + _container + ", _instanceChild : " + _instanceChild + ", _behaviour : " + _behaviour);
					
					
					
					/*
					//add to stage (simple)
					if (_instanceChild is DisplayObject) {
						_dobjc.addChild(_instanceChild);
						
					}
					//add behaviour
					else if (_mode == BEHAVIOUR_DEF) {
						
						if (_container == BEHAVIOUR_DEF) {
							if (!(_dobjc is InterfaceSprite)) throw new Error("Object " + ObjectSearch.formatObject(_dobjc) + " must be InterfaceSprite if you set behaviours inside");
							InterfaceSprite(_dobjc).addBehaviour(Behaviour(_instanceChild));
						}
						else if (_container is Behaviour) {
							Behaviour(_container).addItem(_instanceChild);
						}
						else throw new Error("this case is out of my expectation");
					}
					*/
					
					//add behaviour
					if (_container == BEHAVIOUR_DEF) {
						if (!(_dobjc is InterfaceSprite)) throw new Error("Object " + ObjectSearch.formatObject(_dobjc) + " must be InterfaceSprite if you set behaviours inside");
						if (!(_instanceChild is Behaviour)) throw new Error("you must set a Behaviour in <behaviour> node (" + _instanceChild + ")");
						InterfaceSprite(_dobjc).addBehaviour(Behaviour(_instanceChild));
					}
					
					else if (_behaviour != null) {
						_behaviour.addItem(_instanceChild);
					}
					//dynamicstatedef
					else if (_instanceChild is DynamicStateDef) {
						if (!(_dobjc is InterfaceSprite)) throw new Error("Object " + ObjectSearch.formatObject(_dobjc) + " must be InterfaceSprite if you set DynamicStateDef inside");
						DynamicStateDef(_instanceChild).index = _dynamicListIndex;
						InterfaceSprite(_dobjc).addDynamicStateDef(DynamicStateDef(_instanceChild));
					}
					
					 //add to stage (simple)
					else if (_instanceChild is DisplayObject) {
						_dobjc.addChild(_instanceChild);
						
					}
				}
				
				
				//elmt to get ($)
				else {
					
					//simple
					
					var _searchstr:String = _attributes["search"];
					if (_searchstr == null) throw new Error("you must set \"search\" attribute with elmt <$>");
					delete _attributes["search"];
					
					var _dobjparent:DisplayObjectContainer;
					if (_dobjc is InterfaceSprite && InterfaceSprite(_dobjc).objtpl != null) _dobjparent = InterfaceSprite(_dobjc).objtpl;
					else _dobjparent = _dobjc;
					
					//trace("$ _dobjparent : " + _dobjparent + " _dobjc : " + _dobjc+", index : "+_dobjc.parent.getChildIndex(_dobjc));
					
					var _instanceChild:* = ObjectSearch.search(_dobjparent, _searchstr);
					setProperties(_attributes, _instanceChild);
					
				}
			}
			
			
			//add sessions bindings
			var _nbsessions:int = _sessionList.length;
			for (var j:int = 0; j < _nbsessions; j++) 
			{
				var _sessiondef:Array = _sessionList[j];
				//trace("_sessiondef : " + _sessiondef+", _instancechild : "+_instanceChild);
				Sessions.addBinding(_sessiondef[0], _instanceChild, _sessiondef[1], _sessiondef[2], _sessiondef[3]);
			}
			
			
			
			
			
			//trace("________________________________");
			
			return _instanceChild;
		}
		
		
		
		
		
		
		static public function getDynamicValueComponent(_str:String, _defaulprefix:String):Object 
		{
			var _datakey:String = _str.substr(1, _str.length - 2);	//remove {}
			
			var _indexofPoint:int = _datakey.indexOf(":");
			
			var _prefix:String;
			var _subdatakey:String;
			
			if (_indexofPoint != -1) {
				_prefix = _datakey.substr(0, _indexofPoint);
				_subdatakey = _datakey.substr(_indexofPoint + 1, _datakey.length - (_indexofPoint + 1));
				//trace("_prefix : "+_prefix+", _subdatakey : " + _subdatakey);
			}
			else {
				_prefix = _defaulprefix;			//default value
				_subdatakey = _datakey;
			}
			var _output:Object = new Object();
			_output.prefix = _prefix;
			_output.datakey = _datakey;
			_output.subdatakey = _subdatakey;
			return _output;
		}
		
		
		
		
		
		
		
		
		private static function setProperties(_attributes:Object, _instanceChild:*):void
		{
			//properties definition
			for (var _key in _attributes)
			{
				var _value:Object = _attributes[_key];
				//var _tab:Array = (_value is String) ? _value.match(/^{(.+)\.(.+)}$/) : null;
				
				
				
				//trace if begins with "@trace"
				if (_value is String) {
					var _lenmentiontrace:int = 6;
					var _str:String = String(_value);
					if (_str.substr(0, _lenmentiontrace) == "@trace") {
						_value = _str.substr(_lenmentiontrace, _str.length - _lenmentiontrace);
						trace("@trace "+ObjectSearch.formatObject(_instanceChild)+"."+_key+" : "+_value);
					}
				}
				
				
				//id
				if (_key == "id") {
					ObjectSearch.registerID(_instanceChild, String(_value), _checkIDdoublons);
					if (_instanceChild is LayoutSprite) ClassManager.setProperty(_instanceChild, "id", _value);
				}
				
				//class
				else if (_key == "class" || _key == "classname") {
					if (!(_instanceChild is LayoutSprite)) throw new Error("property \"class\" is only available for LayoutSprite Object");
					ClassManager.setProperty(_instanceChild, "classname", _value);
				}
				
				//class def
				else if (String(_key).substr(0, 5) == "class") {
					//convert string to class
					var _class:Class = ClassManager.getClassByName(String(_value));
					if (_class == null) throw new Error("param " + _key + " : class " + _value + " is not registered");
					//_instanceChild[_key] = _class;
					ClassManager.setProperty(_instanceChild, _key, _class);
				}
				
				else {
					
					
					
					if (_value == "true") ClassManager.setProperty(_instanceChild, _key, true);
					else if (_value == "false") ClassManager.setProperty(_instanceChild, _key, false);
					else ClassManager.setProperty(_instanceChild, _key, _value);
				}
				
			}
			
		}
		
		
		
		
		
		/*
		static private function setCSS(_item:Text):void 
		{
			//trace("set css on " + _item);
			var _stylesheet:StyleSheet2 = URLLoaderManager.getStylesheet("stylesheet_text");
			_item.styleSheet = _stylesheet;
		}
		*/
		
		
		
		
		
		static private function preprocessingPreloading(_data:String):Boolean 
		{
			//trace("ASXML.preprocessingPreloading");
			
			
			//replace flashvars
			var _tab:Array = _data.match(/{(flashvars|session):(.+?)}/g);
			var _len:int = (_tab == null) ? 0 : _tab.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _dynvalue:String = _tab[i];
				_dynvalue = _dynvalue.substr(1, _dynvalue.length - 2);	//remove {}
				var _tab2:Array = _dynvalue.split(":");
				if (_tab2.length == 2) {
					var _key:String = _tab2[0];
					var _value:String = _tab2[1];
					if (_key == "flashvars") {
						var _repl:String = ObjectSearch.flashvars(_value);
						_data = _data.replace("{" + _dynvalue + "}", _repl);
						//trace("-- flashvars " + _value + " : " + _repl + ", _dynvalue : " + _dynvalue);
					}
					else if (_key == "session") {
						var _repl:String = Sessions.get(_value);
						_data = _data.replace("{" + _dynvalue + "}", _repl);
						//trace("-- session " + _value + " : " + _repl + ", _dynvalue : " + _dynvalue);
						
					}
					
					
				}
			}
			
			//detect file
			var _tab:Array = _data.match(/{(.+?)}/g);
			var SERVER_ENVIRONMENT:Boolean = (_baseContainer.loaderInfo.url.search("http://") != -1);
			
			var _len:int = (_tab == null) ? 0 : _tab.length;
			var _eventAdded:Boolean = false;
			
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _dynvalue:String = _tab[i];
				_dynvalue = _dynvalue.substr(1, _dynvalue.length - 2);	//remove {}
				
				var _tab2:Array = _dynvalue.split(":");
				if (_tab2.length == 2) {
					var _key:String = _tab2[0];
					var _value:String = _tab2[1];
					if (_key == "file") {
						//trace("file : " + _value);
						_eventAdded = true;
						var _nocache:Boolean = (DEBUG_MODE && SERVER_ENVIRONMENT);
						URLLoaderManager.load(_value, _value, _nocache);
					}
					
				}
			}
			return _eventAdded;
			
		}
		
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		private static function onConstructorComplete(e:Event):void 
		{
			trace("ASXML.onConstructorComplete");
			
			//preprocessing dynamic file
			var _eventAdded:Boolean = preprocessingPreloading(_constructor.data);
			if (!_eventAdded) onPreprocessingPreloadingComplete(new Event(Event.COMPLETE));
			else URLLoaderManager.addEventListener(Event.COMPLETE, onPreprocessingPreloadingComplete);
			
		}
		
		
		private static function onPreprocessingPreloadingComplete(e:Event):void
		{
			trace("ASXML.onPreprocessingPreloadingComplete");
			
			URLLoaderManager.resetEventListeners();
			construct(_constructor.data);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		
		private static function tracelvl(_msg:String, _lvl:int):void
		{
			var _space:String = "";
			for (var i:int = 0; i < _lvl; i++) _space += "   ";
			trace(_space + _msg);
		}
		
	}

}