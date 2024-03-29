package view.window 
{
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import model.MainData;
	import request.MainRequest;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author ...
	 */
	public class ReconnectWindow extends BaseWindow 
	{
		public static const RECONNECT:String = "reconnect";
		private var closeButton:SimpleButton;
		private var countDownTimeTxt:TextField;
		private var countNumber:int;
		private var timerToCountDown:Timer;
		private var timerToCheckInternet:Timer;
		private var gameBackground:zGameBackground;
		
		public function ReconnectWindow() 
		{
			gameBackground = new zGameBackground();
			addChild(gameBackground);
			gameBackground.x = -gameBackground.width / 2;
			gameBackground.y = -gameBackground.height / 2;
			
			addContent("zReconnectWindow");
			
			countDownTimeTxt = content["countDownTimeTxt"];
			countDownTimeTxt.text = '';
			closeButton = content["closeButton"];
			closeButton.addEventListener(MouseEvent.CLICK, onCloseWindow);
			closeButton.visible = false;
			
			countNumber = 30;
			countDownTimeTxt.text = String(countNumber);
			timerToCountDown = new Timer(1000);
			timerToCountDown.addEventListener(TimerEvent.TIMER, onTimerToCountDown);
			timerToCountDown.start();
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			timerToCheckInternet = new Timer(1000, 1);
			timerToCheckInternet.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteToCheckInternet);
			timerToCheckInternet.start();
		}
		
		private function onTimerCompleteToCheckInternet(e:TimerEvent):void 
		{
			var tempRequest:MainRequest = new MainRequest();
			var url:String;
			var object:Object;
			url = MainData.getInstance().init.requestLink.getMessageInfoLink.@url;
			object = new Object();
			object.nick_receiver = "system_notify_top";
			tempRequest.sendRequest_Post(url, object, getSystemNoticeInfoFn, true);
		}
		
		private function getSystemNoticeInfoFn(value:Object):void 
		{
			if (!stage)
				return;
			if (value["status"] == "IO_ERROR")
			{
				timerToCheckInternet = new Timer(1000, 1);
				timerToCheckInternet.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteToCheckInternet);
				timerToCheckInternet.start();
			}
			else
			{
				//close();
				dispatchEvent(new Event(RECONNECT));
			}
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close();
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			timerToCountDown.removeEventListener(TimerEvent.TIMER, onTimerToCountDown);
			timerToCountDown.stop();
		}
		
		private function onTimerToCountDown(e:TimerEvent):void 
		{
			if (countNumber > 0)
			{
				countNumber--;
				countDownTimeTxt.text = String(countNumber);
			}
			else
			{
				timerToCountDown.removeEventListener(TimerEvent.TIMER, onTimerToCountDown);
				timerToCountDown.stop();
				close();
				MainData.getInstance().isReconnectPhom = false;
				WindowLayer.getInstance().openAlertWindow("Kết nối bị gián đoạn. \n Vui lòng thử lại...");
			}
		}
		
	}

}