package view.window 
{
	import control.MainCommand;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.utils.Timer;
	import model.MainData;
	import view.button.MyButton;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author ...
	 */
	public class AlertWindow extends BaseWindow 
	{
		private var closeButton:SimpleButton;
		private var feedButton:MyButton;
		private var notice:TextField;
		private var loadingCircle:Sprite;
		
		private var mainData:MainData = MainData.getInstance();
		
		public function AlertWindow() 
		{
			addContent("zAlertWindow");
			notice = content["notice"];
			
			closeButton = content["closeButton"];
			closeButton.addEventListener(MouseEvent.CLICK, onCloseWindow);
			loadingCircle = content["loadingCircle"];
			loadingCircle.visible = false;
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			if (timerToCloseWindowWhenError)
			{
				timerToCloseWindowWhenError.removeEventListener(TimerEvent.TIMER_COMPLETE, onCloseWindowWhenError);
				timerToCloseWindowWhenError.stop();
			}
		}
		
		public function addFeedButton():void
		{
			closeButton.x = - closeButton.width / 2 - 5;
			feedButton.x = closeButton.width / 2 + 5;
			feedButton.visible = true;
		}
		
		public function hideConfirmButton():void
		{
			closeButton.visible = false;
		}
		
		public function showLoadingCircle():void
		{
			loadingCircle.visible = true;
			timerToCloseWindowWhenError = new Timer(10000, 1);
			timerToCloseWindowWhenError.addEventListener(TimerEvent.TIMER_COMPLETE, onCloseWindowWhenError);
			timerToCloseWindowWhenError.start();
		}
		
		private function onCloseWindowWhenError(e:TimerEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
			WindowLayer.getInstance().openAlertWindow("Kết nối đến server lỗi, bạn vui lòng thử lại !!");
			if (mainData.isJoiningRoom)
				MainCommand.getInstance().electroServerCommand.joinLobbyRoom();
		}
		
		public function setNotice(content:String):void
		{
			notice.text = content;
		}
		
		private function createButton(buttonName:String,_width:Number,_height:Number,_function:Function):void
		{
			this[buttonName] = new MyButton();
			this[buttonName].width = _width;
			this[buttonName].height = _height;
			this[buttonName].setLabel(mainData.init.gameDescription.lobbyRoomScreen[buttonName]);
			this[buttonName].x = content[buttonName + "Position"].x;
			this[buttonName].y = content[buttonName + "Position"].y;
			this[buttonName].addEventListener(MouseEvent.CLICK, _function);
			content[buttonName + "Position"].visible = false;
			addChild(this[buttonName]);
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function onFeed(e:MouseEvent):void 
		{
			if (ExternalInterface.available)
				ExternalInterface.call(feedName, feedOption);
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private var _feedOption:Object;
		
		public function get feedName():String 
		{
			return _feedName;
		}
		
		public function set feedName(value:String):void 
		{
			_feedName = value;
		}
		
		public function get feedOption():Object 
		{
			return _feedOption;
		}
		
		public function set feedOption(value:Object):void 
		{
			_feedOption = value;
		}
		
		private var _feedName:String;
		private var timerToCloseWindowWhenError:Timer;
	}

}