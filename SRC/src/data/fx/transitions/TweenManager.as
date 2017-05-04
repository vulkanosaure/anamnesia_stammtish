package data.fx.transitions {
	
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import data.utils.Delay;
	
	
	public class TweenManager extends EventDispatcher
	{
		
		//params
		
		
		//private vars
		
		private var items:Array;
		private var delays:Array;
		
		
		//_______________________________________________________________
		//public functions
		
		public function TweenManager() 
		{ 
			items = new Array();
			delays = new Array();
		}
		
		
		public function reset():void
		{
			deleteTweens();
		}
		
		
		
		public function tween(_obj:Object, _prop:String, _begin:Number, _finish:Number, _duration:Number, _delay:Number=0, _effect:Function=null):void
		{
			
			if(_effect==null) _effect = Regular.easeOut;
			if(isNaN(_begin)) _begin = _obj[_prop];
			if(isNaN(_finish)) _finish = _obj[_prop];
			if(_duration<0 || _delay<0) throw new Error("TweenManager.tween() arg _duration/_delay must be > 0");
			
			//delete all tween targetting same _obj/_prop
			//ces 2 instructions ont été déplacé au debut de startTween
			//deleteTweensWithProperties(_obj, _prop);
			//if(_prop=="alpha" && _finish>0) _obj.visible = true;
			
			var _saveprop:Number = _obj[_prop];
			items.push(new Tween(_obj, _prop, _effect, _begin, _finish, _duration, true));
			var _ind:int = items.length-1;
			var _tw:Tween = items[_ind];
			_tw.addEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
			_tw.stop();
			
			
			if (_delay > 0) {
				_obj[_prop] = _saveprop;
				delays[_ind] = new Delay(_delay*1000, startTween, _tw);
			}
			else{
				startTween(_tw);
			}
		}
		
		
		//ajoute un évenement sur la derniere tween lancée
		public function addTweenListener(_func:Function, _type:String="motionFinish"):void
		{
			var _ind:int = items.length-1;
			items[_ind].addEventListener(_type, _func);
		}
		
		public function destroy():void
		{
			var _len:int;
			_len = (items == null) ? 0 : items.length;
			for (var i:int = 0; i < _len; i++) items[i] = null;
			
			_len = (delays == null) ? 0 : items.length;
			for (i = 0; i < _len; i++) {
				Delay(delays[i]).stop();
				delays[i] = null;
			}
			items = null;
			delays = null;
		}
		
		
		
		public function pause(_value:Boolean):void
		{
			var _ind:int = items.length-1;
			var tw:Tween = Tween(items[_ind]);
			if (tw == null) return;
			if (_value) {
				if(tw.isPlaying) tw.stop();
			}
			else {
				if(!tw.isPlaying) tw.resume();
			}
		}
		
		
		
		public function isPlaying():Boolean
		{
			var _len:int = items.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var tw:Tween = Tween(items[i]);
				if (tw!=null && tw.isPlaying) return true;
			}
			
			_len = delays.length;
			for (i = 0; i < _len; i++) 
			{
				var d:Delay = Delay(delays[i]);
				if (d!=null && d.waiting) return true;
			}
			
			return false;
		}
		
		
		
		//_______________________________________________________________
		//private functions
		
		private function deleteTweensWithProperties(_obj:Object, _prop:String, _tweensrc:Tween):void
		{
			var _tw:Tween;
			var _d:Delay;
			for(var i:* in items){
				_tw = items[i];
				if(_tw!=null && _tw!=_tweensrc && _tw.obj==_obj && _tw.prop==_prop){
					_tw.stop();
					_tw = null;
					_d = delays[i];
					if(_d!=null && _d.waiting){
						_d.stop();
						_d = null;
					}
					items.splice(i, 1);
					delays.splice(i, 1);
				}
			}
		}
		
		private function deleteTweens():void
		{
			var _tw:Tween;
			var _d:Delay;
			var i:int;
			//trace("items.length : " + items.length + ", delays.length : " + delays.length);
			while(items.length > 0){
				
				//trace("items[" + i + "] : " + items[i]);
				_tw = items[i];
				_tw.stop();
				_tw = null;
				items.splice(i, 1);
			}
			while(delays.length > 0){
				//trace("delays[" + i + "] : " + delays[i]);
				_d = delays[i];
				if (_d != null && _d.waiting) {
					_d.stop();
					_d = null;
				}
				delays.splice(i, 1);
			}
		}
		
		private function startTween(_tw:Tween):void
		{
			//trace("startTween("+_tw+") : "+_tw.obj+", "+_tw.prop+", "+_tw.begin+", "+_tw.finish);
			//trace("   visible ? "+_tw.obj.visible);
			if(_tw != null){
				if (_tw.prop == "alpha") {
					setProperty(_tw.obj, "visible", true);
				}
				deleteTweensWithProperties(_tw.obj, _tw.prop, _tw);
				_tw.resume();
			}
		}
		
		
		private function setProperty(_obj:*, _key:String, _value:Object):void
		{
			try {
				_obj[_key] = _value;
			}
			catch (e:Error) {
				/*
				if (!(e is ReferenceError)) throw new Error(e);
				throw new Error("Property \"" + _key + "\" doesn't exist for Object " + _obj);
				*/
			}
			
		}
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
		private function onMotionFinish(e:TweenEvent):void
		{
			var _tw:Tween = e.currentTarget as Tween;
			//trace("onMotionFinish "+_tw+", "+_tw.prop+", "+_tw.finish);
			if (_tw.prop == "alpha" && _tw.finish == 0) {
				setProperty(_tw.obj, "visible", false);
			}
			
			
			//vu un bug sur le rebond grenade frag
			// => cet event appelé alors que twm.destroy avait deja été appelé
			if (items == null) return;
			
			if(!isPlaying()) this.dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
	}
	
}


/*

PROBLEMATIQUE :

on peut vouloir :
	- soit qu'une nouvelle tween lancée efface les anciennes, meme si elles n'ont pas démarré (intéractivité souris)
	- soit qu'une tween retard n'efface pas au moment de la déclaration le reste qui peut etre en train de se dérouler (mode anim)

automatisation : 
	



UTILISATION : 

import data.fx.transitions.TweenManager;
import flash.events.Event;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.EventDispatcher;
import flash.events.EventDispatcher;
var tm = new TweenManager();
tm.tween(_mc, "x", 100, 0, 2, 2, None.easeOut);
tm.addTweenListener(_function, TweenEvent.MOTION_FINISH);



DOCUMENTATION :

METHODS : 
tween(_obj, _prop, _begin, _finish, _duration, _delay, _effect)
	begin peut valoir NaN pour signifier "position courante"
	delay = 0 par defaut
	effect = Regular.easeOut par defaut

addTweenListener(_function, TweenEvent.MOTION_CHANGE)
	arg2 = TweenEvent.MOTION_FINISH par defaut
	ajoute un evenement sur la derniere tween lancée

	


*/