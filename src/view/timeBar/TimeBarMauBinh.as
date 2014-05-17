package view.timeBar 
{
	import com.urbansquall.metronome.Ticker;
	import com.urbansquall.metronome.TickerEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import model.MainData;
	import sound.SoundLibChung;
	import sound.SoundLibMauBinh;
	import sound.SoundManager;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class TimeBarMauBinh extends Sprite 
	{
		public static const COUNT_TIME_FINISH:String = "countTimeFinish";
		public static const HAS_ONE_SECOND:String = "hasOneSecond";
		private var content:Sprite;
		private var timeBar:MovieClip;
		private var mainData:MainData = MainData.getInstance();
		public var timeNumber:Number;
		private var startNumber:Number;
		private var countNumber:int;
		private var startTime:Number;
		private var type:int;
		private var filterNumber:Number = 0;
		private var isFilterDown:Boolean;
		private var standardWidth:Number;
		private var ticker:Ticker;
		private var isPrepareTimeOut:Boolean;
		
		public function TimeBarMauBinh() 
		{
			var className:String = "zTimeBarMauBinh";
			addContent(className);
			standardWidth = 251;
			timeBar = content["timeBar"]["child"];
			timeBar.stop();
			setPercent(0);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			SoundManager.getInstance().stopSound(SoundLibChung.PREPARE_TIME_OUT_SOUND);
			if (ticker)
			{
				ticker.removeEventListener(TickerEvent.TICK, onCountTime);
				ticker.stop();
			}
		}
		
		public function setPercent(percent:Number):void
		{
			timeBar.x = standardWidth * percent / 100 - standardWidth;
		}
		
		public function countTime(_timeNumber:Number):void
		{
			SoundManager.getInstance().stopSound(SoundLibChung.PREPARE_TIME_OUT_SOUND);
			isPrepareTimeOut = false;
			if(type == 3)
				filters = null;
			timeNumber = _timeNumber;
			startNumber = _timeNumber;
			countNumber = 0;
			setPercent(100);
			startTime = getTimer();
			//addEventListener(Event.ENTER_FRAME, onCountTime);
			if (ticker)
			{
				ticker.removeEventListener(TickerEvent.TICK, onCountTime);
				ticker.stop();
			}
			ticker = new Ticker(1000 / stage.frameRate);
			ticker.addEventListener(TickerEvent.TICK, onCountTime);
			ticker.start();
			timeBar.play();
		}
		
		public function stopCountTime():void
		{
			setPercent(0);
			if(type == 3)
				filters = null;
			//removeEventListener(Event.ENTER_FRAME, onCountTime);
			if (ticker)
			{
				ticker.removeEventListener(TickerEvent.TICK, onCountTime);
				ticker.stop();
			}
			timeBar.stop();
			
			SoundManager.getInstance().stopSound(SoundLibChung.PREPARE_TIME_OUT_SOUND);
		}
		
		private function onCountTime(e:Event):void 
		{
			if (!stage)
				return;
			countNumber++;
			if (countNumber % stage.frameRate == 0)
				timeNumber--;
			timeBar.x = standardWidth * ((startNumber * stage.frameRate - countNumber) / (startNumber * stage.frameRate)) - standardWidth;
			
			if (countNumber > startNumber * stage.frameRate * 2 / 3)
			{
				if (!isPrepareTimeOut)
				{
					isPrepareTimeOut = true;
					
					SoundManager.getInstance().playSound(SoundLibChung.PREPARE_TIME_OUT_SOUND, 1000);
					//SoundManager.getInstance().soundManagerMauBinh.playTimeOutPlayerSound(mainData.chooseChannelData.myInfo.sex);
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
			}
			
			if (timeNumber == 1)
				dispatchEvent(new Event(HAS_ONE_SECOND));
			if (timeNumber <= 0)
			{
				filters = null;
				setPercent(0);
				//removeEventListener(Event.ENTER_FRAME, onCountTime);
				if (ticker)
				{
					ticker.removeEventListener(TickerEvent.TICK, onCountTime);
					ticker.stop();
				}
				timeBar.stop();
				
				SoundManager.getInstance().stopSound(SoundLibChung.PREPARE_TIME_OUT_SOUND);
				dispatchEvent(new Event(COUNT_TIME_FINISH));
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