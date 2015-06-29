package view.window 
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import model.MainData;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author computer
	 */
	public class LoadingWindow extends BaseWindow 
	{
		private var timerToCloseWindow:Timer;
		
		public function LoadingWindow() 
		{
			addContent("zLoadingWindow");
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		public function startCloseTimer():void
		{
			if (timerToCloseWindow)
			{
				timerToCloseWindow.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteTimerCloseWindow);
				timerToCloseWindow.stop();
			}
			timerToCloseWindow = new Timer(5000, 1);
			timerToCloseWindow.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteTimerCloseWindow);
			timerToCloseWindow.start();
		}
		
		private function onCompleteTimerCloseWindow(e:TimerEvent):void 
		{
			trace("doi ket noi qua lau")
			close(BaseWindow.MIDDLE_EFFECT);
			WindowLayer.getInstance().openAlertWindow("Kết nối bị gián đoạn. \n Vui lòng thử lại...");
		}
		
		override public function close(closeType:String=BaseWindow.MIDDLE_EFFECT):void
		{
			super.close(closeType);
			if (timerToCloseWindow)
			{
				timerToCloseWindow.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteTimerCloseWindow);
				timerToCloseWindow.stop();
			}
		}
	}

}