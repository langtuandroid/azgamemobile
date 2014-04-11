package view.window 
{
	import event.DataField;
	import flash.display.SimpleButton;
	import model.GameDataTLMN;
	
	import control.MainCommand;
	import event.DataFieldMauBinh;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import model.lobbyRoomData.LobbyRoomData;
	import model.MainData;
	import model.playingData.PlayingData;
	import view.button.MyButton;
	/**
	 * ...
	 * @author Yun
	 */
	public class InvitePlayWindow extends BaseWindow 
	{
		private var invitePlayButton:SimpleButton;
		private var refreshButton:SimpleButton;
		private var closeButton2:SimpleButton;
		private var invitePlayBox:InvitePlayBox;
		private var mainData:MainData = MainData.getInstance();
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:* = mainCommand.electroServerCommand;
		
		public function InvitePlayWindow() 
		{
			addContent("zInvitePlayWindow");
			addButton();
			addInviteFriendList();
			closeButton2 = content["closeButton2"];
			closeButton2.addEventListener(MouseEvent.CLICK, onCloseWindow);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			mainData.playingData.addEventListener(PlayingData.UPDATE_USER_LIST_OF_LOBBY, onUpdateUserList);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			mainData.playingData.removeEventListener(PlayingData.UPDATE_USER_LIST_OF_LOBBY, onUpdateUserList);
		}
		
		private function addInviteFriendList():void 
		{
			invitePlayBox = new InvitePlayBox();
			invitePlayBox.moneyIconUrl = mainData.init.requestLink.moneyIcon.@url;
			invitePlayBox.x = content["selectBoxPosition"].x;
			invitePlayBox.y = content["selectBoxPosition"].y;
			addChild(invitePlayBox);
			
			content["selectBoxPosition"].visible = false;
			electroServerCommand.getUserInLobby();
		}
		
		private function onUpdateUserList(e:Event):void 
		{
			var userList:Object = mainData.playingData.userListOfLobby;
			var tempArray:Array = new Array();
			for (var userName:String in userList) 
			{
				var tempObject:Object = new Object();
				if (userList[userName][DataFieldMauBinh.DISPLAY_NAME])
					tempObject[DataFieldMauBinh.DISPLAY_NAME] = userList[userName][DataFieldMauBinh.DISPLAY_NAME];
				if (userList[userName][DataFieldMauBinh.AVATAR])
					tempObject[DataFieldMauBinh.AVATAR] = userList[userName][DataFieldMauBinh.AVATAR];
				if (userList[userName][DataFieldMauBinh.MONEY])
					tempObject[DataFieldMauBinh.MONEY] = userList[userName][DataFieldMauBinh.MONEY];
				tempObject[DataFieldMauBinh.USER_NAME] = userName;
				tempObject[DataFieldMauBinh.LEVEL] = userList[userName][DataFieldMauBinh.LEVEL];
				tempArray.push(tempObject);
			}
			invitePlayBox.userList = tempArray;
		}
		
		private function addButton():void 
		{
			// tạo nút mời chơi
			invitePlayButton = content["invitePlayButton"];
			invitePlayButton.addEventListener(MouseEvent.CLICK, onInvitePlay);
			
			refreshButton = content["refreshButton"];
			refreshButton.addEventListener(MouseEvent.CLICK, onRefresh);
		}
		
		private function onRefresh(e:MouseEvent):void 
		{
			invitePlayBox.userList = [];
			electroServerCommand.getUserInLobby();
		}
		
		private function onInvitePlay(e:MouseEvent):void 
		{
			var invitedNameArray:Array = invitePlayBox.choosedList;
			
			var infoObject:Object = new Object();
			infoObject[DataFieldMauBinh.DISPLAY_NAME] = mainData.chooseChannelData.myInfo.name;
			infoObject[DataFieldMauBinh.USER_NAME] = mainData.chooseChannelData.myInfo.uId;
			infoObject[DataFieldMauBinh.ROOM_PASSWORD] = GameDataTLMN.getInstance().gameRoomInfo[DataField.PASSWORD];
			infoObject[DataFieldMauBinh.AVATAR] = mainData.chooseChannelData.myInfo.avatar;
			infoObject[DataFieldMauBinh.ROOM_BET] = GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET];
			infoObject[DataFieldMauBinh.MONEY] = mainData.chooseChannelData.myInfo.money;
			infoObject[DataFieldMauBinh.SEX] = mainData.chooseChannelData.myInfo.sex;
			infoObject[DataFieldMauBinh.MESSAGE] = "";
			electroServerCommand.invitePlay(infoObject, invitedNameArray);
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function createButton(buttonName:String,_width:Number,_height:Number,_function:Function):void
		{
			this[buttonName] = new MyButton();
			this[buttonName].width = _width;
			this[buttonName].height = _height;
			this[buttonName].setLabel(mainData.init.gameDescription.playingScreen[buttonName]);
			this[buttonName].x = content[buttonName + "Position"].x;
			this[buttonName].y = content[buttonName + "Position"].y;
			this[buttonName].addEventListener(MouseEvent.CLICK, _function);
			content[buttonName + "Position"].visible = false;
			addChild(this[buttonName]);
		}
	}

}