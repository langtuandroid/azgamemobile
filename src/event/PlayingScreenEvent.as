package event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class PlayingScreenEvent extends Event 
	{
		public var data:Object;
		
		public function PlayingScreenEvent(type:String, _data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			data = _data;
		} 
		
		public override function clone():Event 
		{ 
			return new PlayingScreenEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PlayingScreenEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}