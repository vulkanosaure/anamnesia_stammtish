/*
UTILISATION :
	créer un objet en librairie, le linker "data.layout.slider.ItemSliderCustom"
	créer une série de movieclip nommé "_1", "_2", ... qui représenteront le coté droit
	le coté gauche sera automatiquement doublé en symétrie
	le slider tourne toujours en boucle (pour l'instant)


EXEMPLE :
	voir examples/ItemSliderCustom.fla


BUG :
	conflits de tween (difficile à isoler)

*/

// Ajouts de Hugo le 12/07/2010
// Import et extends MovieClip
// DispatchEvent lorsque tous les items sont initialisé


package data.layout.slider{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Graphics;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;
	
	import data.fx.transitions.TweenManager;
	import data.layout.slider.ItemSliderEvent;
	
	// public class ItemSliderCustom extends Sprite{
	public class ItemSliderCustom extends MovieClip{
		
		//private vars
		var items:Array;
		var properties:Array;
		var nbitem:int;
		var list_properties:Array;
		var properties_items:Array;
		var cur_index:int;
		var old_index:int;
		var nbdisplay:int;
		var nbdisplayTheoric:int;
		var tweens:Array;
		var save_pos:Array;
		
		//params
		var _timeslide:Number;
		var _effect:Function;
		
		var bTween:Boolean;
		var tm:TweenManager;
		
		var endTween:Boolean;
		
		//_______________________________________________________________
		//public functions
		
		public function ItemSliderCustom() 
		{ 
			initProperties();
			reset();
			
			//properties defaut
			_timeslide = 0.5;
			_effect = Regular.easeOut;
			
			tm = new TweenManager();
						
		}
		
		public function reset():void
		{
			items = new Array();
			properties_items = new Array();
			save_pos = new Array();
			nbitem = 0;
			while(this.numChildren) this.removeChildAt(0);
			old_index = 0;
			cur_index = 0;
			
		}
		
		
		
		
		public override function addChild(d:DisplayObject):DisplayObject
		{
			items.push(d);
			properties_items.push(new Object);
			nbitem++;
			return super.addChild(d);

		}
		
		public function next(_tween:Boolean=true):void
		{
			old_index = cur_index;
			cur_index++;
			bTween = _tween;
			goto(cur_index);
			
			dispatchEvent(new ItemSliderEvent(ItemSliderEvent.START_SLIDE));
			
		}
		
		public function prev(_tween:Boolean=true):void
		{
			old_index = cur_index;
			cur_index--;
			bTween = _tween;
			goto(cur_index);
			
			dispatchEvent( new ItemSliderEvent(ItemSliderEvent.START_SLIDE));
			
		}
		
		public function init():void
		{
			if(nbdisplay > nbitem) nbdisplay = nbitem;
			goto(0);
			handleBlock();
			
		}
		
		public function gotoItem(v:int, _tween:Boolean=true):void
		{
			old_index = cur_index;
			cur_index = v;
			bTween = _tween;
			goto(cur_index);
		}
		
		
		
		
		
		
		
		//_______________________________________________________________
		//setters
		
		
		
		public function set timeslide(v:Number):void
		{
			_timeslide = v;
		}
		
		public function set effect(v:Function):void
		{
			_effect = v;
		}
		
		
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		private function goto(_ind:int):void
		{
			//trace("\n______________________________goto("+_ind+")");
			var _pos:int;
			var _inditem:int;
			
			endTween = false;
			
			for(var i:int=0;i<nbitem;i++) items[i].visible = false;
			for(i=0;i<nbdisplay;i++){
				//list properties
				_pos = i - Math.floor(nbdisplay/2);
				
				_inditem = _pos + _ind;
				//trace("   "+_inditem+" : "+_pos);
				//trace("_pos : "+_pos+", _inditem : "+_inditem);
				setProperties(_inditem, _pos);
				
			}
			
		}
		
		private function setProperties(_inditem:int, _indprop:int):void
		{
			var _prop:String;
			var noTween:Boolean = false;
			var bNegatif:Boolean = false;
			var _value:Number;
			var _pos:Number;
			var old_value:Number;
			if(_indprop < 0){
				_indprop *= -1;
				bNegatif = true;
			}
			while(_inditem < 0) _inditem += nbitem;
			while(_inditem >= nbitem) _inditem -= nbitem;
			items[_inditem].visible = true;
			
			if (_indprop == 0) setDisplayObjectOnTop(items[_inditem]);
			
			
			//_______________
			var cur_pos:Number = ((bNegatif) ? -_indprop : _indprop);
			if(save_pos[_inditem]!=undefined){
				var _diff:Number = Math.abs(cur_pos-save_pos[_inditem]);
				if(_diff > 1) {
					
					if(cur_pos > save_pos[_inditem]) _pos = cur_pos+1;
					else _pos = cur_pos-1;
					//trace("_pos : "+_pos+", nbdisplay : "+nbdisplay);
					if(_pos < -Math.floor(nbdisplayTheoric/2)) _pos = -Math.floor(nbdisplayTheoric/2);
					if(_pos > Math.floor(nbdisplayTheoric/2)) _pos = Math.floor(nbdisplayTheoric/2);
					setPropertiesCache(_inditem, _pos);
					noTween = true;
				}
			}
			save_pos[_inditem] = cur_pos;
			//
			
			for(var i in list_properties){
				_prop = list_properties[i];
				_value = properties[_indprop][_prop];
				if(_prop=="x" && bNegatif) _value *= -1;
				old_value = properties_items[_inditem][_prop];
				if(isNaN(old_value)) old_value = _value;
				
				if(noTween){
					if(_pos < 0){
						old_value = properties[-_pos][_prop];
						if(_prop=="x") old_value *= -1;
					}
					else old_value = properties[_pos][_prop];
				}
				
				if(bTween) {
					
					//tweens[_indprop][_prop] = new Tween(items[_inditem], _prop, _effect, old_value, _value, _timeslide, true);
					tm.tween(items[_inditem], _prop, old_value, _value, _timeslide, 0, _effect);
					tm.addTweenListener( finTween );
					
				}else
					items[_inditem][_prop] = _value;
				properties_items[_inditem][_prop] = _value;
			}
		}
		
		private function finTween( pEvt:TweenEvent ):void{
			
			if( !endTween ){
				
				var id:int = cur_index;
				while(id<0) id+= items.length;
				while(id>=items.length) id-=items.length;
				//trace("cur_index : "+id);
				
				var evt = new ItemSliderEvent( ItemSliderEvent.END_SLIDE );
				evt.item_selected = items[id];
				dispatchEvent(evt);
				
			}
			endTween = true;
			
		}
		
		private function handleBlock():void
		{
			
		}
		
		
		private function setPropertiesCache(_inditem:int, _indprop:int):void
		{
			//trace("setPropertiesCache("+_inditem+", "+_indprop);
			var _prop:String;
			var bNegatif:Boolean = false;
			var _value:Number;
			if(_indprop < 0){
				_indprop *= -1;
				bNegatif = true;
			}
			for(var i in list_properties){
				_prop = list_properties[i];
				_value = properties[_indprop][_prop];
				if(_prop=="x" && bNegatif) _value *= -1;
				items[_inditem][_prop] = _value;
			}
		}
		
		
		
		private function initProperties():void
		{
			list_properties = ["x", "y", "width", "height", "rotation", "alpha"];
			var i:int = 0;
			nbdisplay = 0;
			properties = new Array();
			tweens = new Array();
			var d:DisplayObject;
			var _prop:String;
			while(d = this.getChildByName("_"+(i+1))){
				properties.push(new Object());
				tweens.push(new Object());
				for(var j in list_properties){
					_prop = list_properties[j];
					properties[i][_prop] = d[_prop];
				}
				i++;
				nbdisplay++;
			}
			nbdisplay = nbdisplay * 2 - 1;
			nbdisplayTheoric = nbdisplay;			
			
		}
		
		private function setDisplayObjectOnTop(_d:DisplayObject):void
		{
			//trace("setDisplayObjectOnTop("+_d+")");
			this.setChildIndex(_d, this.numChildren-1);
		}
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
		
		
		
	
	}
	
}