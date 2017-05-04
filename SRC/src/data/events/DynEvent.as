/*
var e:DynEvent = new DynEvent("CLICK_IMG");
//Contrairement à Event, DynEvent est "dynamic", on peut donc lui ajouter des propriétés à la volée
e.toto = "salut";
dispatchEvent(e);
________________________________
addEventListener("CLICK_IMG", onClick);
function onClick(e:DynEvent)
{
	trace(e);
}

*/

package data.events {
	
	
	import flash.events.Event;
	public dynamic class DynEvent extends Event{
		
		//params
		
		
		//private vars
		
		
		
		
		//_______________________________________________________________
		//public functions
		
		public function DynEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
		
		public override function toString():String
		{
			var str:String = super.toString();
			str += "\n[";
			var str2:String = "";
			for(var i:* in this){
				if(str2!="") str2 += ", ";
				str2 += i+" : "+this[i];
			}
			str2 += "]";
			return str+str2;
		}
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
		
	}
	
}