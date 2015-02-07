package view.timeBar 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import model.MainData;
	import sound.SoundLibChung;
	import sound.SoundLibPhom;
	import sound.SoundManager;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class TimeBarXito extends Sprite 
	{
		public static const COUNT_TIME_FINISH:String = "countTimeFinish";
		private var content:Sprite;
		private var timeBar:MovieClip;
		private var mainData:MainData = MainData.getInstance();
		private var timeNumber:Number;
		private var countNumber:int;
		private var startTime:Number;
		private var type:int;
		private var filterNumber:Number = 0;
		private var isFilterDown:Boolean;
		private var standardWidth:Number;
		private var isPrepareTimeOut:Boolean;
		
		public function TimeBarXito(_type:int = 1) 
		{
			type = _type;
			var className:String = "zTimeBar_1_Phom";
			addContent(className);
			standardWidth = 76;
			timeBar = content["timeBar"]["child"];
			timeBar.stop();
			setPercent(0);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			SoundManager.getInstance().stopSound(SoundLibChung.PREPARE_TIME_OUT_SOUND);
		}
		
		public function setPercent(percent:Number):void
		{
			timeBar.x = standardWidth * percent / 100 - standardWidth;
		}
		
		public function countTime(_timeNumber:Number):void
		{
			SoundManager.getInstance().stopSound(SoundLibChung.PREPARE_TIME_OUT_SOUND);
			visible = true;
			isPrepareTimeOut = false;
			if(type == 3)
				filters = null;
			timeNumber = _timeNumber;
			countNumber = 0;
			setPercent(100);
			startTime = getTimer();
			addEventListener(Event.ENTER_FRAME, onCountTime);
			timeBar.play();
		}
		
		public function stopCountTime():void
		{
			visible = false;
			setPercent(0);
			if(type == 3)
				filters = null;
			removeEventListener(Event.ENTER_FRAME, onCountTime);
			timeBar.stop();
			SoundManager.getInstance().stopSound(SoundLibChung.PREPARE_TIME_OUT_SOUND);
		}
		
		private function onCountTime(e:Event):void 
		{
			if (!stage)
				return;
			countNumber++;
			timeBar.x = standardWidth * ((timeNumber * stage.frameRate - countNumber) / (timeNumber * stage.frameRate)) - standardWidth;
			
			if (type == 3)
			{
				if (countNumber > timeNumber * stage.frameRate * 2 / 3)
				{
					if (!isPrepareTimeOut)
					{
						isPrepareTimeOut = true;
						
						SoundManager.getInstance().playSound(SoundLibChung.PREPARE_TIME_OUT_SOUND, 1000);
						//SoundManager.getInstance().soundManagerPhom.playTimeOutPlayerSound(mainData.chooseChannelData.myInfo.sex);
					}
					
					if (isFilterDown)
					{
						if(filterNumber >= 1)
							filterNumber -= 1.2;
						else
							isFilterDown = false;
					}
					else
					{
						if(filterNumber <= 7)
							filterNumber += 1.2;
						else
							isFilterDown = true;
					}
					
					var filterTemp:GlowFilter = new GlowFilter(0xFF0000, 1, filterNumber, filterNumber, 5, 1);
					filters = [filterTemp];
					/*if (content["timeBar"].transform.colorTransform.greenMultiplier > 0.5)
					{
						var tempColorTransform:ColorTransform = new ColorTransform();
						tempColorTransform.redMultiplier = 1;
						tempColorTransform.greenMultiplier = content["timeBar"].transform.colorTransform.greenMultiplier - 0.02;
						tempColorTransform.blueMultiplier = 1;
						content["timeBar"].transform.colorTransform = new ColorTransform();
						content["timeBar"].transform.colorTransform = tempColorTransform;
					}*/
				}
			}
			
			if (countNumber >= timeNumber * stage.frameRate)
			{
				if(type == 3)
					filters = null;
				setPercent(0);
				removeEventListener(Event.ENTER_FRAME, onCountTime);
				timeBar.stop();
				dispatchEvent(new Event(COUNT_TIME_FINISH));
				SoundManager.getInstance().stopSound(SoundLibChung.PREPARE_TIME_OUT_SOUND);
			}
			if (getTimer() - startTime > timeNumber * 1000)
			{
				dispatchEvent(new Event(COUNT_TIME_FINISH));
				setPercent(0);
				removeEventListener(Event.ENTER_FRAME, onCountTime);
				timeBar.stop();
			}
		}
		
		private function addContent(className:String):void
		{
			var tempClass:Class;
			tempClass = Class(getDefinitionByName(className));
			content = Sprite(new tempClass());
			addChild(content);
		}
	}

}