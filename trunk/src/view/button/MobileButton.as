package view.button 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class MobileButton extends MovieClip 
	{
		private var _enable:Boolean;
		
		public function MobileButton() 
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			gotoAndStop(1);
			
			//buttonMode = true;
			mouseChildren = false;
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			gotoAndStop(1);
			if (stage)
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			if (!enable)
				return;
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			gotoAndStop("over");
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			gotoAndStop(1);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if (!enable)
				return;
			if (stage)
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			if (currentFrameLabel != "disable")
				gotoAndStop(1);
		}
		
		public function get enable():Boolean 
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void 
		{
			_enable = value;
			if (!value)
				gotoAndStop("disable");
			else
				gotoAndStop(1);
			mouseEnabled = value;
		}
		
	}

}