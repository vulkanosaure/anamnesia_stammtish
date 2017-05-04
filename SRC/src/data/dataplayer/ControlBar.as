package data.dataplayer {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import data.dataplayer.Option;
	import data.dataplayer.Timeline;
	import data.dataplayer.VolumeEvent;
	import data.dataplayer.TimelineEvent;
	import data.dataplayer.ControlEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	
	
	public class ControlBar extends MovieClip{
		
		var st:Stage;
		var _width:Number;
		var _height:Number;
		
		public var autoplay:Boolean;
		var list_options:Array;
		var btnSlideVolume:MovieClip;
		var bg:MovieClip;
		var vslider:VolumeSlider;
		var opt_playpause:Option;
		var opt_rewind:Option;
		var timeline:Timeline;
		var vslider_mask:MovieClip;
		
		var tf_timer:TextField;
		var tf_format:TextFormat;		
		
		var timer_ptop:Number;
		var timer_pright:Number;
		var timer_pleft:Number;
		
		var space_options:Number;
		var space_rewindplay:Number;
		
		var list_legend:Array;
		
		var optWidth:Number;
		var optHeight:Number;
		
		var _sliderVisible:Boolean= false;
		
		
		
		
		public function ControlBar(stage:Stage) 
		{ 
			st = stage;
			//trace("Constructor ControlBar");
			tf_timer = new TextField();
			timeline = new Timeline();
			vslider = new VolumeSlider(st);
			
			//vslider.addEventListener(VolumeEvent.VOLUME_CHANGE, onVolumeChange);
			vslider.addEventListener("VOLUME_CHANGE", onVolumeChange);
			
			timeline.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownTimeline);
			timeline.addEventListener(MouseEvent.MOUSE_UP, onMouseUpTimeline);
			
			st.addEventListener(MouseEvent.MOUSE_UP, onMouseUpTimeline);
			st.addEventListener(Event.MOUSE_LEAVE, onMouseUpTimeline);
			
			trace("ControlBar::st = "+st);
			st.addEventListener(MouseEvent.MOUSE_WHEEL, onVolumeWheel);
		}
		
		public function setDimensions(__width:Number, __height:Number)
		{
			_width = __width;
			_height = __height;
		}
		
		/*
		list_options.push(new Option(false, embarquer));
			list_options.push(new Option(false, partager));
			list_options.push(new Option(false, envoyer));
			list_options.push(new Option(false, credit));
			list_options.push(new Option(false, volume));
			list_options.push(new Option(true, fson, fsoff));
		*/
		
		public function lock():void
		{
			trace("ControlBar::lock");
			var arr:Array = new Array();
			arr = [timeline, list_options[4], list_options[5], opt_playpause, opt_rewind];
			for(var i in arr){
				arr[i].mouseEnabled = false;
				arr[i].buttonMode = false;
				arr[i].mouseChildren = false;
			}
			
		}
		public function unlock():void
		{
			trace("ControlBar::unlock");
			var arr:Array = new Array();
			arr = [timeline, list_options[4], list_options[5], opt_playpause, opt_rewind];
			for(var i in arr){
				arr[i].mouseEnabled = true;
				arr[i].buttonMode = true;
				arr[i].mouseChildren = true;
			}
			
		}
		
		public function clear()
		{
			while(numChildren) removeChildAt(0);
			timeline.clear();
			vslider.clear();
		}
		
		
		public function setOptionsMC(embarquer:MovieClip, partager:MovieClip, envoyer:MovieClip, credit:MovieClip,
								   volume:MovieClip, fson:MovieClip, fsoff:MovieClip, slidevolume:MovieClip,
								   sv_track:MovieClip, sv_handle:MovieClip, sv_mask)
		{
			list_options = new Array();
			list_options.push(new Option(false, embarquer));
			list_options.push(new Option(false, partager));
			list_options.push(new Option(false, envoyer));
			list_options.push(new Option(false, credit));
			list_options.push(new Option(false, volume));
			list_options.push(new Option(true, fson, fsoff));
			vslider.setMC(slidevolume, sv_track, sv_handle);
			
			list_options[0].addEventListener(MouseEvent.CLICK, onClickEmbarquer);
			list_options[1].addEventListener(MouseEvent.CLICK, onClickPartager);
			list_options[2].addEventListener(MouseEvent.CLICK, onClickEnvoyer);
			list_options[3].addEventListener(MouseEvent.CLICK, onClickCredit);
			
			list_options[4].addEventListener(MouseEvent.CLICK, onClickSound);
			list_options[5].addEventListener(MouseEvent.CLICK, onClickFullscreen);
			list_options[5].state = false;
			vslider_mask = sv_mask;
		}
		
		
		public function setControlsMC(play:MovieClip, pause:MovieClip, rewind:MovieClip)
		{
			opt_playpause = new Option(true, play, pause);
			opt_rewind = new Option(false, rewind);
			
			opt_playpause.addEventListener(MouseEvent.CLICK, onClickControl);
			opt_rewind.addEventListener(MouseEvent.CLICK, onClickControl);
		}
		
		public function setOtherMC(cbfond:MovieClip)
		{
			bg = cbfond;
		}
		
		
		
		
		public function setTimelineMC(tlfond:MovieClip, tldownload:MovieClip, tlprogress:MovieClip)
		{
			timeline.setMC(tlfond, tldownload, tlprogress);
		}
		
		
		
		
		public function setTimerFormat(size:int, font:String, color:int)
		{
			tf_format = new TextFormat();
			tf_format.size = size;
			tf_format.font = font;
			tf_format.color = color;
		}
		
		public function setTimerPadding(ptop:Number, pleft:Number, pright:Number)
		{
			timer_ptop = ptop;
			timer_pleft = pleft;
			timer_pright = pright;
		}
		
		public function setBtnPaddings(_spaceoptions:Number, _spacerewplay:Number)
		{
			space_options = _spaceoptions;
			space_rewindplay = _spacerewplay;
		}
		
		
		public function setOptionsAvailability(embarquer:Boolean, partager:Boolean, envoyer:Boolean, 
											   credit:Boolean, vol:Boolean, fs:Boolean)
		{
			
			list_options[0].available = embarquer;
			list_options[1].available = partager;
			list_options[2].available = envoyer;
			list_options[3].available = credit;
			list_options[4].available = vol;
			list_options[5].available = fs;
		}
		
		public function setDimsBtn(opt_width:Number, opt_height:Number):void
		{
			optWidth = opt_width;
			optHeight = opt_height;
		}
		
		
		
		
		public function setElements()
		{
			
			addChild(bg);
			//options (droite)
			//on part sur le principe que les btn ont tous la mm taille
			var width_btn:Number = optWidth;
			var height_btn:Number = optHeight;
			var offset_options:Number = _width - width_btn;
			var nbitem:int = 0;
			
			for(var i:int=0;i<6;i++){
				if(list_options[i].available){
					list_options[i].x = offset_options - nbitem * (width_btn + space_options);
					list_options[i].y = 0;
					nbitem++;
				}
			}
			
			vslider.setElements();
			if(list_options[4].available){
				vslider.x = list_options[4].x + optWidth/2 - vslider.width/2;
				vslider.y = list_options[4].y - vslider.height;
				addChild(vslider);
				sliderVisible = false;
				vslider_mask.x = vslider.x;
				vslider_mask.y = vslider.y;
				addChild(vslider_mask);
				vslider.mask = vslider_mask;
			}
			
			
			for(i=0;i<6;i++){
				if(list_options[i].available) addChild(list_options[i]);
			}
			
			//rewind
			opt_rewind.x = 0;
			opt_rewind.y = 0;
			addChild(opt_rewind);
			//play/pause
			opt_playpause.x = opt_rewind.width + space_rewindplay;
			opt_playpause.y = 0;
			opt_playpause.state = autoplay;
			addChild(opt_playpause);
			
			//fond
			bg.x = 0;
			bg.y = 0;
			bg.width = _width - nbitem * (width_btn + space_options);
			
			//timer
			tf_timer.autoSize = TextFieldAutoSize.CENTER;
			tf_timer.text = "00:00";
			tf_timer.defaultTextFormat = tf_format;
			tf_timer.x = bg.width - tf_timer.width - 0 - timer_pright;
			tf_timer.y = bg.height/2 - tf_timer.height/2 + timer_ptop;
			tf_timer.selectable = false;
			addChild(tf_timer);
			
			//timeline
			var timelinex:Number = opt_playpause.x + opt_playpause.width;
			addChild(timeline);
			timeline.setDimensions(tf_timer.x - timelinex - timer_pleft);
			timeline.setElements();
			timeline.x = timelinex;
			timeline.y = bg.height/2 - timeline.height/2;
			
			
		}
		
		
		
		
		public function setProgress(v:Number)
		{
			timeline.setProgress(v);
		}
		
		public function setDownload(v:Number)
		{
			timeline.setDownload(v);
		}
		
		
		public function get volume():Number
		{
			return vslider.volume;
		}
		
		public function set volume(v:Number)
		{
			vslider.volumeInit = v;
		}
		
		public function set currentTime(t:int)
		{
			tf_timer.text = formatTime(t);
		}
		
		public function set fullscreen(b:Boolean)
		{
			list_options[5].state = b;
		}
		
		public function set status(str:String)
		{
			if(str!="play" && str!="pause") throw Error("ControlBar::set status() value should be play or pause only");
			if(str=="play") opt_playpause.state = true;
			else if(str=="pause") opt_playpause.state = false;
		}
		
		public function set sliderVisible(b:Boolean)
		{
			if(b) vslider_mask.play();
			else vslider_mask.gotoAndStop(1);
			_sliderVisible = b;
		}
		
		public function get sliderVisible():Boolean
		{
			return _sliderVisible;
		}
		
		
		
		
		
		
		//___________________________________________________________________________________
		//private functions
		
		private function formatTime(t:int):String
		{
			var s:int = Math.round(t);
			var m:int = 0;
			if (s > 0) {
				while (s > 59) {
					m++;
					s -= 60;
				}
				return String((m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s);
			} else {
				return "00:00";
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		//___________________________________________________________________________________
		//events handler
		
		
		private function onVolumeChange(e:Event)
		{
			this.dispatchEvent(e);
		}
		
		private function onMouseDownTimeline(e:MouseEvent)
		{
			onUpdateTimeline(e);
			//st.addEventListener(MouseEvent.MOUSE_MOVE, onUpdateTimeline);
			
		}
		private function onMouseUpTimeline(e:Event)
		{
			//st.removeEventListener(MouseEvent.MOUSE_MOVE, onUpdateTimeline);
		}
		

		
		
		private function onUpdateTimeline(e:MouseEvent)
		{
			var x:Number = mouseX - timeline.x;
			var percent:Number = x / timeline.width * 100;
			var te:TimelineEvent = new TimelineEvent(TimelineEvent.CHANGE_PLAYHEAD);
			te.percent = percent;
			dispatchEvent(te);
		}
		
		
		private function onClickControl(e:MouseEvent)
		{
			if(e.currentTarget==opt_playpause){
				if(opt_playpause.state){
					this.dispatchEvent(new ControlEvent(ControlEvent.PLAY));
				}
				else{
					this.dispatchEvent(new ControlEvent(ControlEvent.PAUSE));
				}
			}
			else if(e.currentTarget==opt_rewind){
				this.dispatchEvent(new ControlEvent(ControlEvent.REWIND));
			}
		}
		
		private function onClickSound(e:MouseEvent)
		{
			trace("onClickSound...");
			list_options[4].allowRollover = sliderVisible;
			sliderVisible = !sliderVisible;
			
		}
		
		private function onClickFullscreen(e:MouseEvent)
		{
			this.dispatchEvent(new Event("CLICK_FULLSCREEN"));
			list_options[5].roll_out();
		}
		
		private function onVolumeWheel(e:MouseEvent)
		{
			//trace("onVolumeWheel");
			if(sliderVisible){
				vslider.volume += e.delta*3;
				if(vslider.volume>100) vslider.volume = 100;
				if(vslider.volume<0) vslider.volume = 0;
				this.dispatchEvent(new Event("VOLUME_CHANGE"));
			}
		}
		
		//options
		private function onClickEmbarquer(e:MouseEvent)
		{
			this.dispatchEvent(new Event("CLICK_EMBARQUER"));
		}
		private function onClickPartager(e:MouseEvent)
		{
			this.dispatchEvent(new Event("CLICK_PARTAGER"));
		}
		private function onClickEnvoyer(e:MouseEvent)
		{
			this.dispatchEvent(new Event("CLICK_ENVOYER"));
		}
		private function onClickCredit(e:MouseEvent)
		{
			this.dispatchEvent(new Event("CLICK_CREDIT"));
		}
	}
	
}