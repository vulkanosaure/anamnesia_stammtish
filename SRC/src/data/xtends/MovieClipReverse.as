package data.xtends {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public dynamic class MovieClipReverse extends MovieClip{
		
		//params
		
		
		//private vars
		private var destFrame:int;
		private var startFrame:int;
		private var _progress:Number = 0;
		private var _loop:Boolean;
		private var _speed:Number;
		private var _counter:int;
		
		private var _widthref:Number;
		private var _heightref:Number;
		private var _nameref:String;
		private var _spref:Sprite;
		
		//_______________________________________________________________
		//public functions
		
		public function MovieClipReverse() 
		{ 
			_speed = 1;
			super();
			this.stop();
			_loop = false;
		}
		
		public function playTo(_dest:*, __speed:Number=1):void
		{
			_speed = __speed;
			_counter = 0;
			
			_loop = false;
			if(typeof _dest=='string') destFrame = getFrameByName(_dest);
			else destFrame = _dest;
			if (typeof _dest == 'string' && destFrame == -1) setErrorLabel(_dest);
			startFrame = this.currentFrame;
			
			this.removeEventListener(Event.ENTER_FRAME, playbackManager);
			this.addEventListener(Event.ENTER_FRAME, playManager);
		}
		
		public function playbackTo(_dest:*, __speed:Number=1):void
		{
			_speed = __speed;
			_counter = 0;
			
			_loop = false;
			if(typeof _dest=='string') destFrame = getFrameByName(_dest);
			else destFrame = _dest;
			if (typeof _dest == 'string' && destFrame == -1) setErrorLabel(_dest);
			startFrame = this.currentFrame;
			
			this.removeEventListener(Event.ENTER_FRAME, playManager);
			this.addEventListener(Event.ENTER_FRAME, playbackManager);
		}
		
		public function playLoop():void
		{
			_speed = 1;
			_loop = true;
			this.removeEventListener(Event.ENTER_FRAME, playbackManager);
			this.addEventListener(Event.ENTER_FRAME, playManager);
		}
		
		public function playbackLoop():void
		{
			_speed = 1;
			_loop = true;
			this.removeEventListener(Event.ENTER_FRAME, playManager);
			this.addEventListener(Event.ENTER_FRAME, playbackManager);
		}
		
		public function stopLoop():void
		{
			_loop = false;
		}
		
		
		
		
		
		
		
		
		
		//_______________________________________________________________
		//override
		
		override public function gotoAndStop(frame:Object, scene:String = null):void 
		{
			super.gotoAndStop(frame, scene);
			this.removeEventListener(Event.ENTER_FRAME, playManager);
			this.removeEventListener(Event.ENTER_FRAME, playbackManager);
		}

		override public function nextFrame():void 
		{
			if (this.currentFrame == this.totalFrames) super.gotoAndStop(1);
			else super.nextFrame();
		}
		
		override public function prevFrame():void 
		{
			if (this.currentFrame == 1) super.gotoAndStop(this.totalFrames);
			else super.prevFrame();
		}
		
		public function getFrameByName(_name:String):Number
		{
			var labels:Array = this.currentLabels;
			var len:int = labels.length;
			for(var i:int=0;i<len;i++){
				if(labels[i].name==_name) return labels[i].frame;
			}
			return -1
		}
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		
		private function setErrorLabel(_label:String):void
		{
			throw new Error("MovieClipReverse:: no label \""+_label+"\" was found in "+this);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
		
		private function playManager(e:Event):void
		{
			_counter++;
			var _currentFrame:int = this.currentFrame;
			if(_currentFrame == destFrame && !_loop){
				this.removeEventListener(Event.ENTER_FRAME, playManager);
				dispatchEvent(new Event("PLAY_COMPLETE"));
				
			}
			else {
				var _addFrame:int = _counter * _speed;
				var _newFrame:int = startFrame + Math.round(_addFrame);
				//trace("startFrame : " + startFrame + ", _addFrame : " + _addFrame + ", _newFrame : " + _newFrame + ", destFrame : " + destFrame+", _speed : " + _speed);
				if (_newFrame > destFrame) _newFrame = destFrame;
				super.gotoAndStop(_newFrame);
			}
			dispatchEvent(new Event(Event.RENDER));
			
		}
		
		private function playbackManager(e:Event):void
		{
			_counter++;
			var _currentFrame:int = this.currentFrame;
			if(_currentFrame == destFrame && !_loop){
				this.removeEventListener(Event.ENTER_FRAME, playbackManager);
				dispatchEvent(new Event("PLAY_COMPLETE"));
			}
			else {
				var _addFrame:int = _counter * _speed;
				var _newFrame:int = startFrame - Math.round(_addFrame);
				//trace("startFrame : " + startFrame + ", _addFrame : " + _addFrame + ", _newFrame : " + _newFrame + ", destFrame : " + destFrame+", _speed : " + _speed);
				if (_newFrame < destFrame) _newFrame = destFrame;
				super.gotoAndStop(_newFrame);
			}
			dispatchEvent(new Event(Event.RENDER));
		}
		
		public function get progress():Number
		{ 
			return _progress; 
		}
		
		public function set progress(value:Number):void 
		{
			trace("MovieClipReverse.set progress(" + value + ")");
			_progress = value;
			var _len:Number = this.totalFrames - 1;
			var _img:int = Math.round(_len * value + 1);
			trace("_img : " + _img);
			this.gotoAndStop(_img);
		}
		
		
		
		
		
		
		public function get heightref():Number 
		{
			if (_spref == null) throw new Error("you must specify property nameref before calling heightref");
			return _spref.height;
		}
		
		public function set heightref(value:Number):void 
		{
			if (_spref == null) throw new Error("you must specify property nameref before setting heightref");
			_heightref = value;
			var _prop:String = "height";
			var _dimref:Number = _spref[_prop] * this.scaleY;
			var _dimglobal:Number = this[_prop];
			var _dimneeded:Number = _dimglobal * _heightref / _dimref;
			this[_prop] = _dimneeded;
		}
		
		
		
		public function get widthref():Number 
		{
			if (_spref == null) throw new Error("you must specify property nameref before calling widthref");
			return _spref.width;
		}
		
		public function set widthref(value:Number):void 
		{
			if (_spref == null) throw new Error("you must specify property nameref before setting widthref");
			_widthref = value;
			var _prop:String = "width";
			var _dimref:Number = _spref[_prop] * this.scaleX;
			var _dimglobal:Number = this[_prop];
			var _dimneeded:Number = _dimglobal * _widthref / _dimref;
			this[_prop] = _dimneeded;
		}
		
		public function set nameref(value:String):void 
		{
			_nameref = value;
			_spref = Sprite(this.getChildByName(_nameref));
			if (_spref == null) throw new Error("nameref " + _nameref + " doesn't exist in mc " + this);
		}
		
		
		
		
		
	}
	
}