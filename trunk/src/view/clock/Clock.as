package view.clock 
{
	import com.electrotank.electroserver5.thrift.ThriftDHInitiateKeyExchangeRequest;
	import com.greensock.TweenMax;
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.GTween;
	import control.ConstTlmn;
	import model.MyDataTLMN;
	import sound.SoundManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	
	/**
	 * ...
	 * @author bimkute
	 */
	
	
	public class Clock extends Sprite 
	{
		
		public static const COUNT_TIME_FINISH:String = "countTimeFinish";
		public static const HAS_ONE_SECOND:String = "hasOneSecond";
		private var content:MovieClip;
		
		public var _timeNumber:int;
		private var timerCount:Timer;
		private var _posSeek:Number;
		private var _parentSex:Boolean;
		public function Clock() 
		{
			
			content = new MyClock();
			addChild(content);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
		}
		
		public function setParent(parentSex:Boolean):void 
		{
			_parentSex = parentSex;
		}
		
		public function countTime(timeNumber:int):void
		{
			content.seek.x = 0;
			TweenMax.to(content.seek, timeNumber, { x: -77, repeat:-1, onComplete:onCompleteCountTimer } );
			if (timerCount) 
			{
				timerCount.removeEventListener(TimerEvent.TIMER_COMPLETE, onWaitOverTimer);
				timerCount.stop();
			}
			timerCount = new Timer(1000, timeNumber - 5);
			timerCount.addEventListener(TimerEvent.TIMER_COMPLETE, onWaitOverTimer);
			timerCount.start();
		}
		
		private function onWaitOverTimer(e:TimerEvent):void 
		{
			
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_OVERTIME);
				
			}
			
			/*var rd:int = int(Math.random() * 5);
			if (_parentSex) 
			{
				if (SoundManager.getInstance().isSoundOn) 
				{
					SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_OVERTIME_ + String(rd + 1) );
					
				}
			}
			else 
			{
				if (SoundManager.getInstance().isSoundOn) 
				{
					SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_OVERTIME_ + String(rd + 1) );
					
				}
			}*/
		}
		
		private function onCompleteCountTimer():void 
		{
			if (timerCount) 
			{
				timerCount.removeEventListener(TimerEvent.TIMER_COMPLETE, onWaitOverTimer);
				timerCount.stop();
			}
			dispatchEvent(new Event(COUNT_TIME_FINISH));
		}
		
		public function removeTween():void
		{
			if (timerCount) 
			{
				timerCount.removeEventListener(TimerEvent.TIMER_COMPLETE, onWaitOverTimer);
				timerCount.stop();
			}
			
			TweenMax.killChildTweensOf(this);
		}
		
	}

}