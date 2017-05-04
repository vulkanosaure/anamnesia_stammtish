/*

TODO : 
	
valid enter					OK
send to action				OK
mode debug (prefill)		OK
call server					OK

si ERROR_SUBMIT specify what's wrong (index + code error)			OK
output (global, checkbox, upload)									OK
server complete														OK

input checkbox				OK
	gestion des exclusions	OK
	gestion des required	OK
	get post values			OK
	doublons				OK
	zone clickable			TODO

upload
	extensions/filername	OK
	inputs server			OK
	errors					OK
	lock form during upload	OK
	loading mode progress	TODO
	affichage du msg ok		OK
	affichage du msg error	OK
	affichage msg too big	OK
		
Documentation				TODO (ds gdoc Framework Interface)

test 2 form pour bugs :
	enter valid				OK
	tabindex				OK

check si on peut changer le type du TextField			OK
	



Form.addItem(<OutputDef status="X" msg="Hello world" />)
		//s'écrasent dans un Object référencéess par leurs status
		//2 par défaut, Merci, Pas bon
		
Error submit va renvoyer :
	une liste de couple "type" "status" "index"
		status peut valoir (required/format)
		type représente les types supportés par Form ("text" "checkbox" "upload" pour l'instant)
		
		on peut exploiter cette liste ds une classe ascode ou on handle l'event
		mais faudrait aussi pouvoir mapper automatiquement
		
		addItem(<OutputDef [name=""] type="text" status="required" msg="XXXXX" />);
		//si type ou name sont défini, on sait que ça s'adresse pas au server
		//par contre si pas définis, on tente qd mm de faire matcher au retour submit

*/

package data2.behaviours.form 
{
	import data2.behaviours.Behaviour;
	import data2.net.Ajax;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author 
	 */
	public class Form extends Behaviour
	{
		private const PREFIX_TEXT:String = "text_";
		private const PREFIX_CHECKBOX:String = "cb_";
		private const PREFIX_UPLOAD:String = "upload_";
		private const KEY_SUBMIT:String = "submit";
		private const KEY_LOADING:String = "loading";
		private const KEY_OUTPUT:String = "output";
		
		
		
		
		
		
		//params
		private var _info_input:String;
		private var _info_required_input:String;
		private var _btn_submit:Object;
		private var _anim_loading:DisplayObject;
		private var _action:String;
		private var _action2:String;
		private var _target:String;
		private var _output:TextField;
		private var _debug:Boolean;
		private var _hideSubmit:Boolean;
		
		private var _color_input:int;
		private var _color_info_input:int = -1;
		private var _color_error_input:int;
		private var _color_output:int;
		private var _color_error_output:int = -1;
		
		private var _info_valid_upload:String;
		private var _info_error_upload:String;
		private var _info_filesize_upload:String;
		
		
		private var _inputs:Array;
		private var _radiogroups:Object;
		private var _outputdefs:Array;
		
		private var _baseTabIndex:int;
		private var _enableSubmit:Boolean;
		private var _submitID:String;
		
		
		public function Form() 
		{
			_inputs = new Array();
			_radiogroups = new Object();
			_outputdefs = new Array();
			_enableSubmit = true;
			
			//default values
			_target = null;
			
			_color_input = 0x555555;
			_color_error_input = 0xCC0000;
			_color_output = 0x000000;
			_color_error_output = 0xCC0000;
			_debug = false;
			_hideSubmit = false;
			
			_info_input = "";
			_info_required_input = "Champ requis";
			
			_info_filesize_upload = "2Mo maximum";
			_info_error_upload = "Erreur de chargement";
			_info_valid_upload = "Chargement OK";
			
			_baseTabIndex = int(Math.round(Math.random() * 999999));
			//trace("_baseTabIndex : " + _baseTabIndex);
		}
		
		
		
		
		override public function update():void 
		{
			var _len:int = (childrens == null) ? 0 : childrens.length;
			var _listnames:Array = new Array();
			var _counterinput:int = 0;
			var _tfindexes:Array = new Array();
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _child:DisplayObject = DisplayObject(childrens[i]);
				var _childname:String = _child.name;
				var _name:String;
				
				
				//input text
				
				if (_child is TextField && _childname.substr(0, PREFIX_TEXT.length) == PREFIX_TEXT) {
					
					if (TextField(_child).type != TextFieldType.INPUT) TextField(_child).type = TextFieldType.INPUT;
					
					_name = _childname.substr(PREFIX_TEXT.length, _childname.length - PREFIX_TEXT.length);
					if (_listnames.indexOf(_name) != -1) throw new Error("Form : you can't declare 2 inputs with the same name (" + _name + ")");
					if (_radiogroups[_name] != undefined) throw new Error("Form : you can't declare 2 inputs with the same name (" + _name + ")");
					_listnames.push(_name);
					//trace("_name : " + _name);
					
					
					var _tinput:InputText = InputText(getInputByName(_name));
					if (_tinput == null) {
						_tinput = new InputText();
						_tinput.name = _name;
						addItem(_tinput);
					}
					
					_tinput.tf = TextField(_child);
					
					setParams(_tinput);
					
					if(!_tinput.tf.multiline) _child.addEventListener(KeyboardEvent.KEY_UP, onKeyboardUp);
					_tinput.tab_index = _baseTabIndex + _counterinput;
					_counterinput++;
				}
				
				
				//input checkbox
				
				else if (_childname.substr(0, PREFIX_CHECKBOX.length) == PREFIX_CHECKBOX) {
					
					_name = _childname.substr(PREFIX_CHECKBOX.length, _childname.length - PREFIX_CHECKBOX.length);
					if (_listnames.indexOf(_name) != -1) throw new Error("Form : you can't declare 2 inputs with the same name (" + _name + ")");
					trace("_name : " + _name);
					
					var _cbinput:InputCheckbox = InputCheckbox(getInputByName(_name));
					if (_cbinput == null) {
						_cbinput = new InputCheckbox();
						_cbinput.name = _name;
						addItem(_cbinput);
					}
					
					if (!(_child is MovieClip)) throw new Error("Form : child used for InputCheckbox must be a MovieClip");
					_cbinput.mc = MovieClip(_child);
					
					var _tab:Array = _name.match(/^([A-Za-z0-9_-]+)_(\d+)$/);
					var _n:String;
					var _index:int;
					if (_tab == null) {
						_n = _name;
						_index = -1;
					}
					else {
						_n = _tab[1];
						_index = Number(_tab[2]);
					}
					
					_cbinput.groupname = _n;
					_cbinput.index = _index;
					
					if (_listnames.indexOf(_n) != -1) throw new Error("Form : you can't declare 2 inputs with the same name (" + _n + ")");
					
					
					//trace("_n : " + _n + ", _index : " + _index);
					var _rg:RadioGroup;
					if (_radiogroups[_n] != null) _rg = RadioGroup(_radiogroups[_n]);
					else {
						_rg = new RadioGroup(true);
						_radiogroups[_n] = _rg;
					}
					
					
					_rg.add(_cbinput);
					_listnames.push(_name);
					
					//todo : check si y'a un elmt avc le nom _groupname
				}
				
				
				//input upload
				
				else if (_child is TextField && _childname.substr(0, PREFIX_UPLOAD.length) == PREFIX_UPLOAD) {
					//trace(" --- is upload "+_childname);
					
					if (TextField(_child).type != TextFieldType.DYNAMIC) TextField(_child).type = TextFieldType.DYNAMIC;
					
					
					_name = _childname.substr(PREFIX_UPLOAD.length, _childname.length - PREFIX_UPLOAD.length);
					if (_listnames.indexOf(_name) != -1) throw new Error("Form : you can't declare 2 inputs with the same name (" + _name + ")");
					if (_radiogroups[_name] != undefined) throw new Error("Form : you can't declare 2 inputs with the same name (" + _name + ")");
					_listnames.push(_name);
					trace("_name : " + _name);
					
					
					var _btn:DisplayObject = getChildByName("btn_" + _name);
					if (_btn == null) throw new Error("Form : you must set a btn_" + _name + " child for InputUpload");
					if (!(_btn is InteractiveObject)) throw new Error("Form : btn_" + _name + " must be a InteractiveObject");
					
					var _loading:DisplayObject = getChildByName("loading_" + _name);
					if (_loading == null) throw new Error("Form : you must set a loading_" + _name + " child for InputUpload");
					
					var _upinput:InputUpload = InputUpload(getInputByName(_name));
					if (_upinput == null) {
						_upinput = new InputUpload();
						_upinput.name = _name;
						addItem(_upinput);
					}
					
					_upinput.tf = TextField(_child);
					_upinput.btn = InteractiveObject(_btn);
					_upinput.loading = _loading;
					
					setParams(_upinput);
				}
				
				
				//btn submit
				else if (_childname.substr(0, KEY_SUBMIT.length) == KEY_SUBMIT) {
					
					var _suffix:String = _childname.substr(KEY_SUBMIT.length, _childname.length - KEY_SUBMIT.length);
					if (_suffix == "") _suffix = "default";
					this.addBtnSubmit(_child, _suffix);
				}
				
				
				//anim loading
				else if (_childname == KEY_LOADING) {
					this.anim_loading = _child;
					
				}
				
				
				//output
				else if (_childname == KEY_OUTPUT) {
					if (!(_child is TextField)) throw new Error("Form : child used for output must be a TextField");
					if (TextField(_child).type != TextFieldType.DYNAMIC) TextField(_child).type = TextFieldType.DYNAMIC;
					this.output = TextField(_child);
					
				}
				
				
			}
			
			
			
			
			_len = _inputs.length;
			for (var k:int = 0; k < _len; k++) 
			{
				var _input:Input = Input(_inputs[k]);
				if (_input is InputText) {
					if (!_input.defined) setParams(_input);
					if (InputText(_input).tf == null) throw new Error("Form : There is no matching TextField for InputText "+_input.name);
				}
				else if (_input is InputUpload) {
					if (!_input.defined) setParams(_input);
					if (InputUpload(_input).tf == null) throw new Error("Form : There is no matching TextField for InputUpload "+_input.name);
				}
			}
			
			
			reset();
			
			
			if (_debug) {
				_len = _inputs.length;
				for (var j:int = 0; j < _len; j++) 
				{
					var _i:Input = Input(_inputs[j]);
					if (_i is InputText) {
						var _ti:InputText = InputText(_i);
						var _content:String = "content" + _ti.name;
						if (_ti.regex == "email") _content = "vincent.h@data-projekt.fr";
						_ti.setContent(_content);
					}
					else if (_i is InputCheckbox) {
						var _cb:InputCheckbox = InputCheckbox(_i);
						if (_cb.required) _cb.checked = true;
					}
				}
			}
			
			
			
		}
		
		
		private function setParams(_input:Input):void
		{
			if (_input is InputText) {
				var _tinput:InputText = InputText(_input);
				if (_tinput.info == null) _tinput.info = _info_input;
				if (_tinput.info_required == null) _tinput.info_required = _info_required_input;
				if (_tinput.color == -1) _tinput.color = _color_input;
				if (_tinput.color_error == -1) _tinput.color_error = _color_error_input;
				if (_color_info_input != -1 && _tinput.color_info == -1) _tinput.color_info = _color_info_input;
			}
			
			if (_input is InputUpload) {
				var _upinput:InputUpload = InputUpload(_input);
				if (_upinput.info_valid == null) _upinput.info_valid = _info_valid_upload;
				if (_upinput.info_error == null) _upinput.info_error = _info_error_upload;
				if (_upinput.info_filesize == null) _upinput.info_filesize = _info_filesize_upload;
				if (_upinput.color == -1) _upinput.color = _color_input;
				if (_upinput.color_error == -1) _upinput.color_error = _color_error_input;
				
				if (_upinput.action == null) _upinput.action = _action;
				if (_upinput.action == null) throw new Error("Form : you must set InputUpload.action param (" + _upinput.name + ")");
			}
			_input.defined = true;
		}
		
		
		
		
		override public function addItem(_item:*):void 
		{
			if (_item is Input) {
				_inputs.push(_item);
			}
			else if (_item is OutputDef) {
				
				var _outputdef:OutputDef = OutputDef(_item);
				if (_outputdef.msg == null) throw new Error("param msg must be set in OutputDef");
				_outputdefs.push(_item);
			}
		}
		
		
		
		public function reset():void
		{
			resetFields();
			setOutputMsg("", 0);
			
			//map init
			var initOutput:OutputDef = new OutputDef();
			initOutput.status = "init";
			mapOutputDefs([initOutput]);
			if (_output != null) _output.textColor = _color_output;
			
		}
		
		
		
		
		
		
		
		//______________________________________________________________
		//set / get
		
		public function set info_input(value:String):void {_info_input = value;}
		
		public function set info_required_input(value:String):void { _info_required_input = value; }
		
		public function set info_valid_upload(value:String):void {_info_valid_upload = value;}
		
		public function set info_error_upload(value:String):void {_info_error_upload = value;}
		
		public function set info_filesize_upload(value:String):void {_info_filesize_upload = value;}
		
		public function set action(value:String):void {_action = value;}
		
		public function set output(value:TextField):void {_output = value;}
		
		public function set debug(value:Boolean):void {_debug = value;}
		
		public function set color_input(value:uint):void { _color_input = value; }
		
		public function set color_info_input(value:uint):void {_color_info_input = value;}
		
		public function set color_error_input(value:uint):void {_color_error_input = value;}
		
		public function set color_output(value:uint):void {_color_output = value;}
		
		public function set color_error_output(value:uint):void {_color_error_output = value;}
		
		public function addBtnSubmit(value:DisplayObject, _key:String):void
		{
			if (_btn_submit == null) _btn_submit = new Object();
			if (_btn_submit[_key] != undefined) throw new Error("Form : btn submit with suffix " + _key + " allready exist");
			_btn_submit[_key] = value;
			value.addEventListener(MouseEvent.CLICK, onClickSubmit);
		}
		
		
		public function set anim_loading(value:DisplayObject):void 
		{
			_anim_loading = value;
			_anim_loading.visible = false;
		}
		
		public function set target(value:String):void 
		{
			if (value != "_self" && value != "_blank") throw new Error("wrong value for Form.target (_self or _blank)");
			_target = value;
		}
		
		public function get hideSubmit():Boolean {return _hideSubmit;}
		
		public function set hideSubmit(value:Boolean):void {_hideSubmit = value;}
		
		
		
		
		
		
		
		
		
		
		//______________________________________________________________
		//private functions
		
		public function getInputByName(_name:String):Input
		{
			var _len:int = _inputs.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _input:Input = Input(_inputs[i]);
				if (_input.name == _name) {
					return _input;
				}
			}
			return null;
		}
		
		private function getChildByName(_name:String):DisplayObject
		{
			var _len:int = childrens.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _dobj:DisplayObject = DisplayObject(childrens[i]);
				if (_dobj.name == _name) return _dobj;
			}
			return null;
		}
		
		
		
		
		
		private function validForm(_listerrors:Array):Boolean
		{
			var bok:Boolean = true;
			var _len:int = _inputs.length;
			var _input:Input;
			
			//valid textinput (ptet upload?)
			for (var i:int = 0; i < _len; i++) {
				
				_input = Input(_inputs[i]);
				var _outputDef:OutputDef =  validInput(_input);
				if (_outputDef != null) {
					bok = false;
					_listerrors.push(_outputDef);
				}
			}
			
			
			
			//valid checkbox
			for (var k:* in _radiogroups) {
				var _rg:RadioGroup = RadioGroup(_radiogroups[k]);
				var _len:int = _rg.length;
				var _checked:Boolean = false;
				var _1required:Boolean = false;			//si on rencontre au moins 1 required	
				for (var j:int = 0; j < _len; j++) 
				{
					var _cb:InputCheckbox = InputCheckbox(_rg.getItem(j));
					if (_cb.required) {
						_1required = true;
						if (_cb.checked) _checked = true;
					}
				}
				
				if (!_checked && _1required) {
					bok = false;
					
					var _outputDef:OutputDef = new OutputDef();
					_outputDef.type = OutputDef.TYPE_CHECKBOX;
					_outputDef.status = OutputDef.STATUS_REQUIRED;
					_outputDef.name = k;
					_listerrors.push(_outputDef);
					//trace("checkbox group " + k + " is not valid (" + _checked + ", " + _1required + ")");
				}
				
			}
			
			
			return bok;
		}
		
		
		
		private function removeFocus():void
		{
			var _len:int = _inputs.length;
			for (var i:int = 0; i < _len; i++) {
				var _input:Input = Input(_inputs[i]);
				if (_input is InputText) {
					InputText(_input).tf.stage.focus = null;
				}
			}
		}
		
		public function enableSubmit(_value:Boolean):void
		{
			if (_btn_submit != null) {
				
				for (var j:String in _btn_submit) {
					
					//todo later, passer par ClickableSprite pour gérer ça
					InteractiveObject(_btn_submit[j]).mouseEnabled = _value;
					if (_btn_submit[j] is DisplayObjectContainer) DisplayObjectContainer(_btn_submit[j]).mouseChildren = _value;
					if (_hideSubmit) DisplayObject(_btn_submit[j]).visible = _value;
				}
			}
			_enableSubmit = _value;
			
			//enable upload btns
			var _len:int = _inputs.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _i:Input = Input(_inputs[i]);
				if (_i is InputUpload) InputUpload(_i).enable(_value);
			}
		}
		
		
		
		private function resetFields():void 
		{
			var _len:int = _inputs.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _input:Input = Input(_inputs[i]);
				_input.reset();
			}
		}
		
		
		
		
		
		private function validInput(_input:Input):OutputDef
		{
			var _outputDef:OutputDef;
			
			if (_input is InputText) {
				
				var _tinput:InputText = InputText(_input);
				
				var _filled:Boolean;
				var _required:Boolean;
				var _isregex:Boolean;
				
				_filled = _tinput.isFilled();
				_required = _tinput.required;
				_isregex = (_tinput.regexValue != null);
				//trace(" --- " + _filled + ", " + _required + ", _isregex : " + _isregex);
				
				_tinput.rewind();
				
				if(_required && !_filled){
					_tinput.setError(_tinput.info_required);
					_outputDef = new OutputDef();
					_outputDef.type = OutputDef.TYPE_TEXT;
					_outputDef.status = OutputDef.STATUS_REQUIRED;
					_outputDef.name = _tinput.name;
					
				}
				else if(!_required && !_filled){
					//_tinput.empty();	//voir a quoi ça servait ça
				}
				else if (_isregex && (_filled || _tinput.isErrorFilled)) {
					//check regex
					if(_tinput.content.search(_tinput.regexValue)==-1){
						_tinput.setError(_tinput.info_format);
						_outputDef = new OutputDef();
						_outputDef.type = OutputDef.TYPE_TEXT;
						_outputDef.status = OutputDef.STATUS_FORMAT;
						_outputDef.name = _tinput.name;
					}
				}
			}
			
			//a voir si ça se fait ici
			else if (_input is InputUpload) {
				
				//trace("validField (" + _input + ")");
				
				
				var _upinput:InputUpload = InputUpload(_input);
				
				//trace("_upinput.required : "+_upinput.required+", _upinput.isploading : " + _upinput.isUploading + ", _upinput.pathfile : " + _upinput.pathfile);
				if (_upinput.isUploading) {
					//todo : attention status particulier
					_outputDef = new OutputDef();
					_outputDef.type = OutputDef.TYPE_UPLOAD;
					_outputDef.status = OutputDef.STATUS_UPLOADING;
					_outputDef.name = _upinput.name;
				}
				else if (_upinput.required && _upinput.pathfile == null) {
					
					_outputDef = new OutputDef();
					_outputDef.type = OutputDef.TYPE_UPLOAD;
					_outputDef.status = OutputDef.STATUS_REQUIRED;
					_outputDef.name = _upinput.name;
				}
				
			}
			
			return _outputDef;
		}
		
		
		
		
		
		
		public function submit(__action2:String=null):void 
		{
			if (!_enableSubmit) return;
			
			_action2 = __action2;
			
			var _evt:FormEvent = new FormEvent(FormEvent.SUBMIT);
			_evt.submitID = _submitID;
			dispatchEvent(_evt);
			trace("submit");
			
			removeFocus();
			setOutputMsg("", 0);
			var _listSubmitErrors:Array = new Array();
			
			var _isFormValid:Boolean = validForm(_listSubmitErrors);
			if(!_isFormValid){
				
				//mapping with outputdefs
				mapOutputDefs(_listSubmitErrors);
				
				
				var _evt:FormEvent = new FormEvent(FormEvent.ERROR_SUBMIT);
				_evt.listErrors = _listSubmitErrors;
				_evt.submitID = _submitID;
				dispatchEvent(_evt);
			}
			
			else {
				//
				trace("SUBMIT OK, _action : " + _action);
				
				var _inputValues:Object = getInputValues();
				
				var _evt:FormEvent = new FormEvent(FormEvent.VALID_SUBMIT);
				_evt.submitID = _submitID;
				_evt.inputs = _inputValues;
				dispatchEvent(_evt);
				
				if (_action != null) {
					//trace("action not null");
					var _ajax:Ajax = new Ajax();
					_ajax.addEventListener(Event.COMPLETE, onAjaxComplete);
					_ajax.addEventListener(IOErrorEvent.IO_ERROR , onIOErrorEvent);
					
					
					//trace("_inputValues");
					for (var i in _inputValues) {
						//trace(" --- " + i + " : " + _inputValues[i]);
						var _value:String = (_inputValues[i] == null) ? "" : _inputValues[i];
						_ajax.varsIn[i] = _value;
					}
					_ajax.varsIn["submitID"] = _submitID;
					
					var _bopen:Boolean = (_target == null) ? false : true;
					
					var _url = (_action2 == null) ? _action : _action2;
					_ajax.call(_url, _bopen, _target);
					
					if(!_bopen){
						enableSubmit(false);
						showLoading();
						
					}
				}
				
			}
		}
		
		
		
		
		private function mapOutputDefs(_listerrors:Array):void 
		{
			var _len:int = _outputdefs.length;
			var _nberror:int = _listerrors.length;
			var _msg:String = "";
			var _curlvl:int = -1;
			//trace("_listerrors : " + _listerrors);
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _outputdef:OutputDef = OutputDef(_outputdefs[i]);
				for (var j:int = 0; j < _nberror; j++) 
				{
					var _error:OutputDef = OutputDef(_listerrors[j]);
					var _match:Boolean = true;
					
					//trace("_outputdef : " + _outputdef);
					//trace("_error : " + _error);
					
					var _lvl:int = 0;
					if (_outputdef.name != null) _lvl += 3;
					if (_outputdef.type != null) _lvl++;
					if (_outputdef.status != null) _lvl++;
					
					if (_outputdef.name != null && _outputdef.name != _error.name) _match = false;
					if (_outputdef.type != null && _outputdef.type != _error.type) _match = false;
					if (_outputdef.status != null && _outputdef.status != _error.status) _match = false;
					
					//on ne mélange pas les output types server des types submit
					if (_error.type == OutputDef.TYPE_SERVER && _outputdef.type != OutputDef.TYPE_SERVER) _match = false;
					
					//trace("_match : " + _match + ", _lvl : " + _lvl);
					
					if (_match && _lvl > _curlvl) {
						_msg = _outputdef.msg;
						_curlvl = _lvl;
					}
					
				}
			}
			
			var _c:int = (_color_error_output == -1) ? _color_output : _color_error_output;
			
			setOutputMsg(_msg, _c);
			//trace("_msg : " + _msg);
		}
		
		
		
		
		
		private function getInputValues():Object
		{
			var _len:int = _inputs.length;
			var _obj:Object = new Object();
			for (var i:int = 0; i < _len; i++) 
			{
				var _input:Input = Input(_inputs[i]);
				if (_input is InputText) {
					if(InputText(_input).isFilled()) _obj[_input.name] = InputText(_input).content;
				}
				
				else if (_input is InputCheckbox) {
					
					var _cbinput:InputCheckbox = InputCheckbox(_inputs[i]);
					var _groupname:String = _cbinput.groupname;
					
					//trace("_obj[" + _groupname + "] : " + _obj[_groupname]);
					if (_obj[_groupname] == undefined) _obj[_groupname] = "";
					
					var _rg:RadioGroup = RadioGroup(_radiogroups[_groupname]);
					if (_rg.length == 1) {
						if (_cbinput.checked) _obj[_groupname] = "1";
						else _obj[_groupname] = "0";
					}
					else{
						if (_cbinput.checked) {
							if(_cbinput.value != null) _obj[_groupname] = _cbinput.value;
							else _obj[_groupname] = _cbinput.index;
						}
					}
				}
				
				else if (_input is InputUpload) {
					_obj[_input.name] = InputUpload(_input).pathfile;
				}
				
				else if (_input is InputHidden) {
					_obj[_input.name] = InputHidden(_input).value;
				}
			}
			
			return _obj;
		}
		
		
		
		private function setOutputMsg(_str:String, _col:int):void
		{
			if (_output == null) return;
			_output.text = _str;
			_output.textColor = _col;
		}
		
		private function showLoading():void
		{
			if (_anim_loading == null) return;
			_anim_loading.visible = true;
		}
		
		private function hideLoading():void
		{
			if (_anim_loading == null) return;
			_anim_loading.visible = false;
		}
		
		private function getSubmitID(_btn:Object):String
		{
			for (var i:String in _btn_submit) {
				if (_btn_submit[i] == _btn) return i;
			}
			throw new Error("submit ID wasn't found");
		}
		
		
		
		//______________________________________________________________
		//events
		
		private function onClickSubmit(e:MouseEvent):void
		{
			_submitID = getSubmitID(e.currentTarget);
			submit();
		}
		
		private function onKeyboardUp(e:KeyboardEvent):void 
		{
			//trace("onKeyboardUp");
			_submitID = "default";
			if (e.keyCode == Keyboard.ENTER) submit();
			
		}
		
		private function onAjaxComplete(e:Event)
		{
			var varsout:Object = e.target.varsOut;
			trace("onAjaxComplete");
			for (var i in varsout) {
				//trace(" --- " + i + " : " + varsout[i]);
			}
			//todo : bizarre, a la maison il veut pas envoyer les params en post
			
			
			//map
			var serverOutput:OutputDef = new OutputDef();
			serverOutput.status = varsout.status;
			serverOutput.type = OutputDef.TYPE_SERVER;
			mapOutputDefs([serverOutput]);
			
			if (serverOutput.status == "1") {
				//correct
				if (_output != null) _output.textColor = _color_output;
				if (!_debug) resetFields();
			}
			
			
			enableSubmit(true);
			hideLoading();
			
			var _evt:FormEvent = new FormEvent(FormEvent.COMPLETE_SERVER);
			_evt.serverOutput = varsout;
			this.dispatchEvent(_evt);
			
		}
		
		
		
		private function onIOErrorEvent(e:IOErrorEvent):void 
		{
			//trace("onIOErrorEvent");
			
			enableSubmit(true);
			hideLoading();
			throw new Error(e.text);
		}
		
		
		
	}

}