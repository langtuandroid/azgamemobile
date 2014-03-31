package view.timeBar 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import model.MainData;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class TimeBar extends Sprite 
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
		
		private var timeNumberText:TextField;
		private var timer:Timer;
		private var circleBorderAnim:MovieClip;
		
		public function TimeBar(_type:int = 1) 
		{
			type = _type;
			var className:String = "zTimeBarCircle";
			addContent(className);
			timeNumberText = content["timeNumberText"];
			timeNumberText.text = '0';
			circleBorderAnim = content["circleBorderAnim"];
			circleBorderAnim.visible = false;
			circleBorderAnim.stop();
			content.visible = false;
		}
		
		public function countTime(_timeNumber:Number):void
		{
			content.visible = true;
			timeNumber = _timeNumber;
			timeNumberText.text = String(timeNumber);
			if (timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onCoutTime);
			}
			timer = new Timer(1000, _timeNumber);
			timer.addEventListener(TimerEvent.TIMER, onCoutTime);
			timer.start();
			circleBorderAnim.visible = true;
			circleBorderAnim.play();
		}
		
		private function onCoutTime(e:TimerEvent):void 
		{
			timeNumber--;
			timeNumberText.text = String(timeNumber);
			if (timeNumber <= 0)
			{
				dispatchEvent(new Event(COUNT_TIME_FINISH));
				circleBorderAnim.visible = false;
				circleBorderAnim.stop();
				if (timer)
				{
					content.visible = false;
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER, onCoutTime);
				}
			}
		}
		
		public function stopCountTime():void
		{
			content.visible = false;
			timeNumberText.text = '0';
			circleBorderAnim.visible = false;
			circleBorderAnim.stop();
			if (timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onCoutTime);
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