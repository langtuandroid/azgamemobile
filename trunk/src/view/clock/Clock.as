package view.clock 
{
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.GTween;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import model.MainData;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class Clock extends Sprite 
	{
		public static const COUNT_TIME_FINISH:String = "countTimeFinish";
		public static const HAS_ONE_SECOND:String = "hasOneSecond";
		private var content:Sprite;
		private var minute:Sprite;
		private var minuteNumber_1:TextField;
		private var minuteNumber_2:TextField;
		private var second_1:Sprite;
		private var secondNumber_1_1:TextField;
		private var secondNumber_1_2:TextField;
		private var second_2:Sprite;
		private var secondNumber_2_1:TextField;
		private var secondNumber_2_2:TextField;
		private var minuteNumber:int;
		private var second1Number:int;
		private var second2Number:int;
		public var timeNumber:Number;
		private var timerCount:Timer;
		private var mainData:MainData = MainData.getInstance();
		private var timeMoving:Number = 0.5;
		
		public function Clock() 
		{
			var className:String = "zClock";
			addContent(className);
			minute = content["minute"];
			second_1 = content["second_1"];
			second_2 = content["second_2"];
			minuteNumber_1 = minute["electricNumberSmall"]["textNumber1"];
			minuteNumber_2 = minute["electricNumberSmall"]["textNumber2"];
			secondNumber_1_1 = second_1["electricNumberSmall"]["textNumber1"];
			secondNumber_1_2 = second_1["electricNumberSmall"]["textNumber2"];
			secondNumber_2_1 = second_2["electricNumberSmall"]["textNumber1"];
			secondNumber_2_2 = second_2["electricNumberSmall"]["textNumber2"];
			minuteNumber_1.text = '0';
			minuteNumber_2.text = '0';
			secondNumber_1_1.text = '0';
			secondNumber_1_2.text = '0';
			secondNumber_2_1.text = '0';
			secondNumber_2_2.text = '0';
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			if (timerCount)
			{
				timerCount.stop();
				timerCount.removeEventListener(TimerEvent.TIMER, onCountTime);
			}
		}
		
		
		private function addContent(className:String):void
		{
			var tempClass:Class;
			tempClass = Class(getDefinitionByName(className));
			content = Sprite(new tempClass());
			addChild(content);
		}
		
		public function countTime(_timeNumber:Number):void
		{
			if (timerCount)
			{
				timerCount.stop();
				timerCount.removeEventListener(TimerEvent.TIMER, onCountTime);
			}
			timeNumber = _timeNumber;
			minuteNumber_1.y = secondNumber_1_1.y = secondNumber_2_1.y = -5;
			minuteNumber_2.y = secondNumber_1_2.y = secondNumber_2_2.y = -25;
			minuteNumber_1.text = String(Math.floor(timeNumber / 60));
			secondNumber_1_1.text = String(Math.floor((timeNumber - Number(minuteNumber_1.text) * 60 ) / 10));
			secondNumber_2_1.text = String(timeNumber - Number(minuteNumber_1.text) * 60 - Number(secondNumber_1_1.text) * 10);
			minuteNumber = int(minuteNumber_1.text);
			second1Number = int(secondNumber_1_1.text);
			second2Number = int(secondNumber_2_1.text);
			timerCount = new Timer(1000);
			timerCount.addEventListener(TimerEvent.TIMER, onCountTime);
			timerCount.start();
		}
		
		public function stopCountTime():void
		{
			minuteNumber_1.text = '0';
			minuteNumber_2.text = '0';
			secondNumber_1_1.text = '0';
			secondNumber_1_2.text = '0';
			secondNumber_2_1.text = '0';
			secondNumber_2_2.text = '0';
			if (timerCount)
			{
				timerCount.stop();
				timerCount.removeEventListener(TimerEvent.TIMER, onCountTime);
			}
		}
		
		private function onCountTime(e:Event):void 
		{
			var tempTween:GTween;
			if (!stage)
				return;
			if (second2Number != 0)
			{
				second2Number--;
				if (secondNumber_2_1.y == -5)
				{
					secondNumber_2_2.y = -25;
					secondNumber_2_2.text = String(second2Number);
				}
				else
				{
					secondNumber_2_1.y = -25;
					secondNumber_2_1.text = String(second2Number);
				}
				
				tempTween = new GTween(secondNumber_2_1, timeMoving, { y:secondNumber_2_1.y + 20 }, { ease:Back.easeInOut });
				tempTween = new GTween(secondNumber_2_2, timeMoving, { y:secondNumber_2_2.y + 20 }, { ease:Back.easeInOut });
				
				if (minuteNumber == 0 && second1Number == 0 && second2Number == 1)
					dispatchEvent(new Event(HAS_ONE_SECOND));
				if (minuteNumber == 0 && second1Number == 0 && second2Number == 0)
				{
					if (timerCount)
					{
						timerCount.stop();
						timerCount.removeEventListener(TimerEvent.TIMER, onCountTime);
						dispatchEvent(new Event(COUNT_TIME_FINISH));
						return;
					}
				}
			}
			else
			{
				if (second1Number != 0)
				{
					second1Number--;
					if (secondNumber_1_1.y == -5)
					{
						secondNumber_1_2.y = -25;
						secondNumber_1_2.text = String(second1Number);
					}
					else
					{
						secondNumber_1_1.y = -25;
						secondNumber_1_1.text = String(second1Number);
					}
					
					tempTween = new GTween(secondNumber_1_1, timeMoving, { y:secondNumber_1_1.y + 20 }, { ease:Back.easeInOut });
					tempTween = new GTween(secondNumber_1_2, timeMoving, { y:secondNumber_1_2.y + 20 }, { ease:Back.easeInOut });
				}
				else
				{
					if (minuteNumber != 0)
					{
						minuteNumber--;
						second1Number = 5;
						
						if (secondNumber_1_1.y == -5)
						{
							secondNumber_1_2.y = -25;
							secondNumber_1_2.text = '5';
						}
						else
						{
							secondNumber_1_1.y = -25;
							secondNumber_1_1.text = '5';
						}
						
						tempTween = new GTween(secondNumber_1_1, timeMoving, { y:secondNumber_1_1.y + 20 }, { ease:Back.easeInOut });
						tempTween = new GTween(secondNumber_1_2, timeMoving, { y:secondNumber_1_2.y + 20 }, { ease:Back.easeInOut });
						
						if (minuteNumber_1.y == -5)
						{
							minuteNumber_2.y = -25;
							minuteNumber_2.text = String(minuteNumber);
						}
						else
						{
							minuteNumber_1.y = -25;
							minuteNumber_1.text = String(minuteNumber);
						}
						
						tempTween = new GTween(minuteNumber_1, timeMoving, { y:minuteNumber_1.y + 20 }, { ease:Back.easeInOut });
						tempTween = new GTween(minuteNumber_2, timeMoving, { y:minuteNumber_2.y + 20 }, { ease:Back.easeInOut });
					}
					else
					{
						
					}
				}
				
				second2Number = 9;
				if (secondNumber_2_1.y == -5)
				{
					secondNumber_2_2.y = -25;
					secondNumber_2_2.text = '9';
				}
				else
				{
					secondNumber_2_1.y = -25;
					secondNumber_2_1.text = '9';
				}
				
				tempTween = new GTween(secondNumber_2_1, timeMoving, { y:secondNumber_2_1.y + 20 }, { ease:Back.easeInOut });
				tempTween = new GTween(secondNumber_2_2, timeMoving, { y:secondNumber_2_2.y + 20 }, { ease:Back.easeInOut });
			}
		}
	}

}