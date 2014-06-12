package view 
{
	import com.gskinner.motion.GTween;
	import event.DataFieldMauBinh;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import model.MainData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SystemNoticeBar extends BaseView 
	{
		private var infoTxt:TextField;
		private var noticeList:Array;
		private var currentIndex:int = 0;
		private var timerToShowNotice:Timer;
		private var background:Sprite;
		
		public function SystemNoticeBar() 
		{
			addContent("zSystemNoticeBar");
			background = content["background"];
			infoTxt = content["infoTxt"];
			infoTxt.text = '';
			infoTxt.autoSize = TextFieldAutoSize.LEFT;
			infoTxt.wordWrap = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			scrollRect = new Rectangle(0, 0, background.width, background.height);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			mainData.removeEventListener(MainData.UPDATE_SYSTEM_NOTICE, onUpdateSystemNotice);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			if (timerToShowNotice)
			{
				timerToShowNotice.removeEventListener(TimerEvent.TIMER, onShowNotice);
				timerToShowNotice.stop();
			}
		}
		
		private function onAddedToStage(e:Event):void 
		{
			mainData.addEventListener(MainData.UPDATE_SYSTEM_NOTICE, onUpdateSystemNotice);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (infoTxt.x > - infoTxt.width)
				infoTxt.x -= 1;
			else
				infoTxt.x = background.width;
		}
		
		private function onUpdateSystemNotice(e:Event):void 
		{
			noticeList = mainData.systemNoticeList;
			if (timerToShowNotice)
			{
				timerToShowNotice.removeEventListener(TimerEvent.TIMER, onShowNotice);
				timerToShowNotice.stop();
			}
			currentIndex = 0;
			timerToShowNotice = new Timer(4000);
			timerToShowNotice.addEventListener(TimerEvent.TIMER, onShowNotice);
			//timerToShowNotice.start();
			
			infoTxt.text = '';
			for (var i:int = 0; i < mainData.systemNoticeList.length; i++) 
			{
				var textfield:TextField = new TextField();
				textfield.htmlText = mainData.systemNoticeList[i][DataFieldMauBinh.MESSAGE];
				infoTxt.appendText(textfield.text);
				if (i < mainData.systemNoticeList.length - 1)
					infoTxt.appendText(" - ");
			}
			infoTxt.x = background.width;
		}
		
		private function onShowNotice(e:TimerEvent):void 
		{
			if (currentIndex + 1 >= noticeList.length)
				currentIndex = 0;
			else
				currentIndex++;
			infoTxt.x = background.width;
			infoTxt.htmlText = noticeList[currentIndex];
			var movingTween:GTween = new GTween(infoTxt, 1, { x:0});
		}
		
	}

}