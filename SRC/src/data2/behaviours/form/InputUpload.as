package data2.behaviours.form 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public class InputUpload extends Input
	{
		private var _tf:TextField;
		private var _btn:InteractiveObject;
		private var _anim_loading:DisplayObject;
		private var _required:Boolean;
		private var _action:String;
		private var _pathfile:String;
		private var _isUploading:Boolean;
		private var _extensions:String;
		private var _filtername:String;
		
		private var _color:int = -1;
		private var _color_error:int = -1;
		private var _info_valid:String;
		private var _info_error:String;
		private var _info_filesize:String;
		
		private var _fileRef:FileReference;
		private var _enabled:Boolean;
		
		
		
		
		public function InputUpload() 
		{
			_fileRef = new FileReference();
			_fileRef.addEventListener(Event.SELECT, onFileSelected);
			_fileRef.addEventListener(Event.COMPLETE, onFileComplete);
			_fileRef.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onServerResponse);
			_fileRef.addEventListener(IOErrorEvent.IO_ERROR, onFileError);
            _fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_fileRef.addEventListener(ProgressEvent.PROGRESS, onFileProgress);
			
			//default values
			_required = true;
			reset();
		}
		
		
		override public function reset():void 
		{
			_isUploading = false;
			_pathfile = null;
			_enabled = true;
			setContent("", 0);
			hideLoading();
		}
		
		public function enable(value:Boolean):void 
		{
			_btn.mouseEnabled = value;
			_enabled = value;
		}
		
		
		
		
		
		
		
		
		//__________________________________________________________
		//set / get
		
		public function get tf():TextField {return _tf;}
		
		public function set tf(value:TextField):void 
		{
			_tf = value;
			_tf.addEventListener(MouseEvent.CLICK, onClickBrowse);
			_tf.addEventListener(MouseEvent.CLICK, onClickBrowse);
			_tf.selectable = false;
		}
		
		public function get btn():InteractiveObject {return _btn;}
		
		public function set btn(value:InteractiveObject):void
		{
			_btn = value;
			_btn.addEventListener(MouseEvent.CLICK, onClickBrowse);
		}
		
		public function set loading(value:DisplayObject):void
		{
			_anim_loading = value;
			hideLoading();
		}
		
		public function get required():Boolean {return _required;}
		
		public function set required(value:Boolean):void {_required = value;}
		
		public function get color():int {return _color;}
		
		public function set color(value:int):void {_color = value;}
		
		public function get color_error():int {return _color_error;}
		
		public function set color_error(value:int):void {_color_error = value;}
		
		public function set info_valid(value:String):void {_info_valid = value;}
		
		public function set info_error(value:String):void {_info_error = value;}
		
		public function set info_filesize(value:String):void {_info_filesize = value;}
		
		public function set action(value:String):void {_action = value;}
		
		public function get pathfile():String {return _pathfile;}
		
		public function get info_valid():String {return _info_valid;}
		
		public function get info_error():String {return _info_error;}
		
		public function get info_filesize():String {return _info_filesize;}
		
		public function get action():String {return _action;}
		
		public function get isUploading():Boolean {return _isUploading;}
		
		public function set extensions(value:String):void {_extensions = value;}
		
		public function set filtername(value:String):void {_filtername = value;}
		
		
		
		
		
		
		//____________________________________________________________
		//private functions
		
		private function setContent(_str:String, _col:int):void
		{
			if (_tf == null) return;
			_tf.text = _str;
			_tf.textColor = _col;
			//_tf.setTextFormat(tformat_msg);
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
		
		
		
		
		
		
		
		
		//_____________________________________________________________________________
		//events
		
		private function onClickBrowse(e:MouseEvent)
		{
			if (!_enabled) return;
			trace("onClickBrowse");
			
			var _fname:String = (_filtername == null) ? "" : _filtername;
			var _ext:String = (_extensions == null) ? "" : _extensions;
			
			var _fileFilter:Array = (_filtername == null && _extensions == null) ? null : [new FileFilter(_fname, _ext)];
			_fileRef.browse(_fileFilter);
		}
		
		private function onFileSelected(e:Event)
		{
			trace("onFileSelected "+_fileRef.name);
			if(_fileRef.size > 2000000){
				setContent(_info_filesize, _color_error);
			}
			else{
				setContent(_fileRef.name, _color);
				_fileRef.upload(new URLRequest(_action));
				showLoading();
				_isUploading = true;
				
				trace("_fileRef.size : "+_fileRef.size);
			}
			
		}
		
		private function onFileComplete(e:Event)
		{
			trace("InputUpload.onFileComplete");
			_isUploading = false;
		}
		
		private function onServerResponse(e:DataEvent):void
		{
			trace("InputUpload.onServerResponse");
			var _info:String = e.data;
			
			hideLoading();
			_isUploading = false;
			
			//trace("_info : " + _info);
			
			if(_info=="0") {
				setContent(_info_error, _color_error);
			}
			else {
				_pathfile = _info;
				trace("_pathfile : " + _pathfile);
				setContent(_info_valid, _color);
			}
		}
		
		
		
		private function onFileError(e:IOErrorEvent)
		{
			throw new Error(e.text);
			setContent(_info_error, _color_error);
			hideLoading();
			_isUploading = false;
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent)
		{
			trace("InputUpload.securityErrorHandler");
			setContent(_info_error, _color_error);
			hideLoading();
			_isUploading = false;
		}
		private function onFileProgress(e:ProgressEvent)
		{
			var _ratio:Number = e.bytesLoaded / e.bytesTotal;
			//todo : if anim loading progress mode
		}
		
		
		
	}

}