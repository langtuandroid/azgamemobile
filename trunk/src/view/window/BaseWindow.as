package view.window 
{
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.easing.Quadratic;
	import com.gskinner.motion.GTween;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import model.MainData;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class BaseWindow extends Sprite 
	{
		public static const NO_EFFECT:String = "noEffect";
		public static const MIDDLE_EFFECT:String = "middleEffect";
		public static const LEFT_EFFECT:String = "leftEffect";
		public static const CLOSE_COMPLETE:String = "closeComplete";
		
		public var content:Sprite;
		private var openTween:GTween;
		private var closeTween:GTween;
		private var openTime:Number = 0.5;
		private var openTime_2:Number = 0.7;
		private var closeTime:Number = 0.2;
		private var isOpenComplete:Boolean;
		private var mainData:MainData = MainData.getInstance();
		public var background:Sprite;
		
		public function BaseWindow() 
		{
			visible = false;
			//cacheAsBitmap = true;
		}
		
		public function addContent(className:String):void
		{
			var tempClass:Class;
			tempClass = Class(getDefinitionByName(className));
			content = Sprite(new tempClass());
			addChild(content);
		}
		
		public function close(closeType:String=BaseWindow.MIDDLE_EFFECT):void
		{
			GTween.defaultDispatchEvents = true;
			switch (closeType) 
			{
				case MIDDLE_EFFECT:
					closeTween = new GTween(this, closeTime, { scaleX:0, scaleY:0 }/*, {ease:Quadratic.easeInOut}*/);
					closeTween.addEventListener(Event.COMPLETE, closeComplete);
				break;
				case NO_EFFECT:
					if (background)
					{
						if (background.parent)
							background.parent.removeChild(background);
					}
					if (parent) parent.removeChild(this);
					dispatchEvent(new Event(CLOSE_COMPLETE));
				break;
			}
		}
		
		protected function closeComplete(e:Event):void 
		{
			content = null;
			openTween = null;
			closeTween = null;
			openTime = 0
			closeTime = 0;
			isOpenComplete = false;
			
			if (parent)
			{
				parent.removeChild(this);
				if (background)
				{
					if (background.parent)
						background.parent.removeChild(background);
				}				
				dispatchEvent(new Event(CLOSE_COMPLETE));
			}
		}
		
		public function open(openType:String):void
		{
			GTween.defaultDispatchEvents = true;
			switch (openType) 
			{
				case MIDDLE_EFFECT:
					x = mainData.stageWidth / 2;
					y = mainData.stageHeight / 2;
					scaleX = scaleY = 0;
					visible = true;
					openTween = new GTween(this, openTime, { scaleX:1, scaleY:1 }, {ease:Back.easeOut});
					openTween.addEventListener(Event.COMPLETE, openComplete);
				break;
				case NO_EFFECT:
					x = mainData.stageWidth / 2;
					y = mainData.stageHeight / 2;
					visible = true;
					isOpenComplete = true;
				break;
				case LEFT_EFFECT:
					x = mainData.stageWidth / 2 - mainData.stageWidth / 5;
					y = mainData.stageHeight / 2;
					alpha = 0;
					visible = true;
					openTween = new GTween(this, openTime, { alpha:1, x:mainData.stageWidth / 2 }, {ease:Back.easeOut});
					openTween.addEventListener(Event.COMPLETE, openComplete);
				break;
			}
		}
		
		private function openComplete(e:Event):void 
		{
			isOpenComplete = true;
		}
	}

}