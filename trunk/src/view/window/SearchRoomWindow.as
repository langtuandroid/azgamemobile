package view.window 
{
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import control.MainCommand;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import logic.PlayingLogic;
	import model.MainData;
	import view.button.MyButton;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author ...
	 */
	public class SearchRoomWindow extends BaseWindow 
	{
		private var joinRoomButton:MyButton;
		private var closeButton:MyButton;
		
		private var roomIdInputText:TextField;
		private var passInputText:TextField;
		
		private var mainData:MainData = MainData.getInstance();
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:* = mainCommand.electroServerCommand;
		private var windowLayer:WindowLayer = WindowLayer.getInstance();
		
		public function SearchRoomWindow() 
		{
			addContent("zSearchRoomWindow");
			addButton();
			createInputText();
		}
		
		private function createInputText():void 
		{
			roomIdInputText = content["roomIdInputText"];
			passInputText = content["passInputText"];
			roomIdInputText.maxChars = mainData.init.maxCharsInputText;
			passInputText.maxChars = mainData.init.maxCharsInputText;
			passInputText.displayAsPassword = true;
		}
		
		private function addButton():void 
		{
			// tạo nút vào phòng chơi
			createButton("joinRoomButton", 90, 18, onJoinRoom);
			
			// tạo nút đóng cửa sổ
			createButton("closeButton", 90, 18, onCloseWindow);
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
		
		private function onJoinRoom(e:MouseEvent):void 
		{
			var roomList:Array = mainData.lobbyRoomData.roomList;
			for (var i:int = 0; i < roomList.length; i++) 
			{
				if (RoomDataRLC(roomList[i]).id == int(roomIdInputText.text))
				{
					if (RoomDataRLC(roomList[i]).userNumbers >= RoomDataRLC(roomList[i]).maxPlayer)
					{
						windowLayer.closeAllWindow();
						var fullPlayerWindow:AlertWindow = new AlertWindow();
						fullPlayerWindow.setNotice(mainData.init.gameDescription.lobbyRoomScreen.fullPlayer);
						windowLayer.openWindow(fullPlayerWindow);
						return;
					}
					else
					{
						if (Number(RoomDataRLC(roomList[i]).betting) * mainData.minBetRate > mainData.chooseChannelData.myInfo.money)
						{
							var notEnoughMoneyWindow:AlertWindow = new AlertWindow();
							var string1:String = mainData.init.gameDescription.lobbyRoomScreen.notEnoughMoneyToCreate1;
							var string2:String = mainData.init.gameDescription.lobbyRoomScreen.notEnoughMoneyToCreate2;
							var string3:String = string1 + " " + String(mainData.minBetRate) + " " + string2;
							notEnoughMoneyWindow.setNotice(string3 + " " + PlayingLogic.format(Number(RoomDataRLC(roomList[i]).betting), 1));
							windowLayer.openWindow(notEnoughMoneyWindow);
							close(BaseWindow.MIDDLE_EFFECT);
							return;
						}
						
						i = roomList.length + 1;
					}
				}
			}
					
			electroServerCommand.findGameRoom(int(roomIdInputText.text), passInputText.text);
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
	}

}