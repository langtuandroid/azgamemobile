package view.window 
{
	import control.MainCommand;
	import event.DataField;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import logic.PlayingLogic;
	import model.MainData;
	import view.button.MyButton;
	import view.userInfo.avatar.Avatar;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	public class ConfirmInvitePlayWindow extends BaseWindow 
	{
		private var confirmButton:MyButton;
		private var closeButton:MyButton;
		private var mainData:MainData = MainData.getInstance();
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:* = mainCommand.electroServerCommand;
		private var inviteSentence:TextField;
		private var displayName:TextField;
		private var roomId:TextField;
		private var betting:TextField;
		private var money:TextField;
		private var rule:TextField;
		private var moneyIcon:Loader;
		private var personIcon:Sprite;
		private var windowLayer:WindowLayer = WindowLayer.getInstance();
		private var timerToAutoClose:Timer;
		private var avatarPosition:Sprite;
		private var avatar:Avatar;
		
		public function ConfirmInvitePlayWindow() 
		{
			addContent("zConfirmInvitePlayWindow");
			addButton();
			inviteSentence = content["inviteSentence"];
			displayName = content["displayName"];
			roomId = content["roomId"];
			betting = content["betting"];
			money = content["money"];
			rule = content["rule"];
			personIcon = content["personIcon"];
			personIcon.visible = false;
			avatarPosition = content["avatarPosition"];
			avatarPosition.visible = false;
			inviteSentence.selectable = false;
			displayName.selectable = false;
			roomId.selectable = false;
			betting.selectable = false;
			avatar = new Avatar();
			avatar.setForm(Avatar.OTHER_AVATAR);
			avatar.width = 55;
			avatar.height = 53;
			avatar.x = avatarPosition.x;
			avatar.y = avatarPosition.y;
			content.addChild(avatar);
			
			moneyIcon = new Loader();
			moneyIcon.visible = false;
			var urlRequest:URLRequest = new URLRequest(mainData.init.requestLink.moneyIcon.@url);
			moneyIcon.contentLoaderInfo.addEventListener(Event.COMPLETE, onMoneyIconComplete);
			moneyIcon.load(urlRequest);
			content.addChild(moneyIcon);
			
			if (mainData.gameType != MainData.PHOM)
			{
				zConfirmInvitePlayWindow(content).ruleTitle.visible = false;
				zConfirmInvitePlayWindow(content).rule.visible = false;
			}
			zConfirmInvitePlayWindow(content).inviteSentence.visible = false;
			zConfirmInvitePlayWindow(content).inviteSentenceTitle.visible = false;
		}
		
		private function onMoneyIconComplete(e:Event):void 
		{
			
		}
		
		private var _data:Object;
		
		public function set data(value:Object):void 
		{
			_data = value;
			inviteSentence.text = _data[DataField.MESSAGE];
			roomId.text = _data[DataField.ROOM_ID];
			displayName.autoSize = TextFieldAutoSize.LEFT;
			displayName.text = _data[DataField.DISPLAY_NAME];
			if (_data[DataField.IS_SEND_CARD])
				rule.text = "Tái gửi";
			else
				rule.text = "Không gửi";
			personIcon.y = displayName.y - 1;
			personIcon.x = displayName.x + displayName.width + 1;
			betting.text = _data[DataField.ROOM_BET];
			money.autoSize = TextFieldAutoSize.LEFT;
			money.text = PlayingLogic.format(Number(_data[DataField.MONEY]), 1);
			moneyIcon.y = money.y + 2;
			moneyIcon.x = money.width + money.x + 4;
			avatar.addImg(value[DataField.AVATAR], null, true, value[DataField.USER_NAME]);
			
			if (value["sex"] == "male")
				personIcon.getChildAt(1).visible = false;
			else
				personIcon.getChildAt(0).visible = false;
				
			if (timerToAutoClose)
			{
				timerToAutoClose.removeEventListener(TimerEvent.TIMER_COMPLETE, onAutoClose);
				timerToAutoClose.stop();
			}
			timerToAutoClose = new Timer(15000, 1);
			timerToAutoClose.addEventListener(TimerEvent.TIMER_COMPLETE, onAutoClose);
			timerToAutoClose.start();
		}
		
		private function onAutoClose(e:TimerEvent):void 
		{
			if (stage)
			{
				close(BaseWindow.MIDDLE_EFFECT);
			}
		}
		
		private function addButton():void 
		{
			zConfirmInvitePlayWindow(content).confirmButton.addEventListener(MouseEvent.CLICK, onConfirmInvitePlay);
			zConfirmInvitePlayWindow(content).closeButton.addEventListener(MouseEvent.CLICK, onCloseWindow);
		}
		
		private function onConfirmInvitePlay(e:MouseEvent):void 
		{
			var roomList:Array = mainData.lobbyRoomData.roomList;
			for (var i:int = 0; i < roomList.length; i++) 
			{
				if (RoomDataRLC(roomList[i]).id == _data[DataField.ROOM_ID])
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
			
			electroServerCommand.joinGameRoom(_data[DataField.GAME_ID], _data[DataField.ROOM_PASSWORD]);
			if (timerToAutoClose)
			{
				timerToAutoClose.removeEventListener(TimerEvent.TIMER_COMPLETE, onAutoClose);
				timerToAutoClose.stop();
			}
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			if (timerToAutoClose)
			{
				timerToAutoClose.removeEventListener(TimerEvent.TIMER_COMPLETE, onAutoClose);
				timerToAutoClose.stop();
			}
			close(BaseWindow.MIDDLE_EFFECT);
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
	}

}