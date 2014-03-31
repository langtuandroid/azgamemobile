package view.effectLayer 
{
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.GTween;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import model.MainData;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class BaseEffect extends Sprite 
	{
		public static const SCALE_INCREASE:String = "scaleIncrease"; // effect to dần lên
		public static const SMALL_SCALE_INCREASE:String = "smallScaleIncrease"; // effect to dần lên
		public static const MOVING_TRANSPARENT:String = "movingTransparent"; // di chuyển từ điểm nào đó và alpha đậm dần lên
		
		protected var content:Sprite;
		private var mainData:MainData = MainData.getInstance();
		private var movingTween:GTween;
		protected var movingTime:Number = 0.5;
		protected var movingDistanceX:Number = 0;
		protected var movingDistanceY:Number = 0;
		protected var effectType:String;
		private var timerToRemove:Timer;
		
		public function BaseEffect() 
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			if (movingTween)
			{
				movingTween.removeEventListener(Event.COMPLETE, removeComplete);
				movingTween.removeEventListener(Event.COMPLETE, movingComplete);
				movingTween.end();
			}
		}
		
		protected function addContent(className:String):void
		{
			var tempClass:Class;
			tempClass = Class(getDefinitionByName(className));
			content = Sprite(new tempClass());
			content.visible = false;
			addChild(content);
		}
		
		public function effectShow(removeTime:Number):void
		{
			switch (effectType) 
			{
				case SCALE_INCREASE:
					content.scaleX = content.scaleY = 0;
					content.visible = true;
					movingTween = new GTween(content, movingTime, { scaleX:1, scaleY:1 }, { ease:Back.easeOut });
					movingTween.addEventListener(Event.COMPLETE, movingComplete);
				break;
				case SMALL_SCALE_INCREASE:
					content.scaleX = content.scaleY = 0;
					content.visible = true;
					movingTween = new GTween(content, movingTime, { scaleX:0.8, scaleY:0.8 }, { ease:Back.easeOut });
					movingTween.addEventListener(Event.COMPLETE, movingComplete);
				break;
				case MOVING_TRANSPARENT:
					content.x -= movingDistanceX;
					content.y -= movingDistanceY;
					content.alpha = 0;
					content.visible = true;
					content.scaleX = content.scaleY = 0;
					movingTween = new GTween(content, movingTime, { x:content.x + movingDistanceX, y:content.y + movingDistanceY, alpha:1, scaleX:1, scaleY:1 }, { ease:Back.easeOut });
					movingTween.addEventListener(Event.COMPLETE, movingComplete);
				break;
			}
			
			if (timerToRemove)
			{
				timerToRemove.removeEventListener(TimerEvent.TIMER_COMPLETE, onRemoveEffect);
				timerToRemove.stop();
			}
			timerToRemove = new Timer(removeTime * 1000, 1);
			timerToRemove.addEventListener(TimerEvent.TIMER_COMPLETE, onRemoveEffect);
			timerToRemove.start();
		}
		
		private function onRemoveEffect(e:TimerEvent):void 
		{
			if (stage)
			{
				if (timerToRemove)
				{
					timerToRemove.removeEventListener(TimerEvent.TIMER_COMPLETE, onRemoveEffect);
					timerToRemove.stop();
				}
				
				switch (effectType) 
				{
					case SCALE_INCREASE:
						movingTween = new GTween(content, movingTime, { scaleX:0, scaleY:0 }, { ease:Back.easeIn });
						movingTween.addEventListener(Event.COMPLETE, removeComplete);
					break;
					case SMALL_SCALE_INCREASE:
						movingTween = new GTween(content, movingTime, { scaleX:0, scaleY:0 }, { ease:Back.easeIn });
						movingTween.addEventListener(Event.COMPLETE, removeComplete);
					break;
					case MOVING_TRANSPARENT:
						movingTween = new GTween(content, movingTime, { x:content.x + movingDistanceX, y:content.y + movingDistanceY, alpha:0, scaleX:0, scaleY:0 }, { ease:Back.easeIn });
						movingTween.addEventListener(Event.COMPLETE, removeComplete);
					break;
				}
			}
		}
		
		private function removeComplete(e:Event):void 
		{
			if (stage && parent)
				parent.removeChild(this);
		}
		
		private function movingComplete(e:Event):void 
		{
			
		}
		
	}

}