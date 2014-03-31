package view 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class SlideBar extends Sprite 
	{
		public static const CHANGE_VALUE:String = "changeValue";
		
		private var content:zSlideBar;
		private var lengthNumber:int;
		public var chooseValue:int;
		private var distance:Number;
		
		public function SlideBar() 
		{
			content = new zSlideBar();
			addChild(content);
			
			content.slide.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			content.clickArea.addEventListener(MouseEvent.MOUSE_UP, onClickAreaClick);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onMouseUpStage(e:MouseEvent):void 
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			dispatchEvent(new Event(CHANGE_VALUE));
		}
		
		private function onClickAreaClick(e:MouseEvent):void 
		{
			updateSlide();
			dispatchEvent(new Event(CHANGE_VALUE));
		}
		
		private function updateSlide():void 
		{
			if (mouseX <= 0)
			{
				content.slide.x = 0;
				chooseValue = 0;
			}
			else if (mouseX >= content.bar.width - content.slide.width - distance / 2)
			{
				content.slide.x = content.bar.width - content.slide.width;
				chooseValue = lengthNumber - 1;
			}
			else
			{
				for (var i:int = 0; i < lengthNumber; i++) 
				{
					if (Math.abs(mouseX - (distance * i)) < distance / 2)
					{
						content.slide.x = distance * i;
						chooseValue = i;
					}
				}
			}
			dispatchEvent(new Event(CHANGE_VALUE));
		}
		
		private function onEnterFrame(e:Event):void 
		{
			updateSlide();
		}
		
		public function setLength(number:int):void
		{
			lengthNumber = number;
			distance = content.bar.width / (lengthNumber - 1);
		}
		
		public function setValue(value:int):void
		{
			if (value == lengthNumber - 1)
				content.slide.x = content.bar.width - content.slide.width;
			else
				content.slide.x = distance * value;
			chooseValue = value;
		}
		
	}

}