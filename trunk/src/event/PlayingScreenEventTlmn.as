package event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class PlayingScreenEventTlmn extends Event 
	{
		public var data:Object;
		
		public function PlayingScreenEventTlmn(type:String, _data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			data = _data;
		} 
		
		public override function clone():Event 
		{ 
			return new PlayingScreenEventTlmn(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PlayingScreenEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}