package view.window 
{
	import control.MainCommand;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import logic.PlayingLogic;
	import model.lobbyRoomData.LobbyRoomData;
	import model.MainData;
	import view.userInfo.avatar.Avatar;
	/**
	 * ...
	 * @author Yun
	 */
	public class AddFriendWindow extends BaseWindow 
	{
		private var displayNameTxt:TextField;
		private var goldTxt:TextField;
		private var levelTxt:TextField;
		private var winTxt:TextField;
		private var loseTxt:TextField;
		private var gameTxt:TextField;
		private var roomTxt:TextField;
		
		public var userName:String;
		private var _displayName:String;
		private var _avatarString:String;
		private var _gold:Number;
		private var _level:int;
		private var _isFriend:Boolean;
		
		private var addFriendButton:SimpleButton;
		private var removeFriendButton:SimpleButton;
		private var closeButton:SimpleButton;
		private var avatar:Avatar;
		private var _data:UserDataULC;
		
		private var mainData:MainData = MainData.getInstance();
		private var electroServerCommand:* = MainCommand.getInstance().electroServerCommand;
		
		public function AddFriendWindow() 
		{
			super();
			
			addContent("zAddFriendWindow");
			
			displayNameTxt = content["displayNameTxt"];
			goldTxt = content["goldTxt"];
			levelTxt = content["levelTxt"];
			winTxt = content["winTxt"];
			loseTxt = content["loseTxt"];
			gameTxt = content["gameTxt"];
			roomTxt = content["roomTxt"];
			addFriendButton = content["addFriendButton"];
			removeFriendButton = content["removeFriendButton"];
			closeButton = content["closeButton"];
			
			addFriendButton.visible = removeFriendButton.visible = false;
			
			addFriendButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			removeFriendButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			closeButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			avatar = new Avatar();
			avatar.setForm(Avatar.MY_AVATAR);
			avatar.x = content["avatarPosition"].x;
			avatar.y = content["avatarPosition"].y;
			avatar.width = avatar.height = content["avatarPosition"].width;
			content["avatarPosition"].visible = false;
			addChild(avatar);
			
			addChild(content["levelIcon"]);
			addChild(levelTxt);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			mainData.lobbyRoomData.addEventListener(LobbyRoomData.UPDATE_FRIEND_LIST, onUpdateFriendList);
			electroServerCommand.getFriendList();
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			mainData.lobbyRoomData.removeEventListener(LobbyRoomData.UPDATE_FRIEND_LIST, onUpdateFriendList);
		}
		
		private function onUpdateFriendList(e:Event):void 
		{
			for (var i:int = 0; i < mainData.lobbyRoomData.friendList.length; i++) 
			{
				if (UserDataULC(mainData.lobbyRoomData.friendList[i]).userName == userName)
				{
					if (UserDataULC(mainData.lobbyRoomData.friendList[i]).isOnline)
					{
						content["statusIcon"].visible = true;
						removeFriendButton.visible = true;
						switch (UserDataULC(mainData.lobbyRoomData.friendList[i]).gameId) 
						{
							case MainData.MAUBINH_ID:
								gameTxt.text = "BINH";
							break;
							case MainData.PHOM_ID:
								gameTxt.text = "PHỎM";
							break;
							default:
						}
						if (UserDataULC(mainData.lobbyRoomData.friendList[i]).roomID == mainData.lobbyRoomId)
							roomTxt.text = "Phòng chờ";
						else
							roomTxt.text = "Bàn số " + String(UserDataULC(mainData.lobbyRoomData.friendList[i]).roomID);
					}
					break;
				}
			}
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case addFriendButton:
					electroServerCommand.addFriend(userName, "inLobby");
					electroServerCommand.getFriendList();
					addFriendButton.visible = false;
					content["statusIcon"].visible = true;
				break;
				case removeFriendButton:
					electroServerCommand.removeFriend(userName, "inLobby");
					electroServerCommand.getFriendList();
					removeFriendButton.visible = false;
					addFriendButton.visible = true;
					gameTxt.text = '';
					roomTxt.text = '';
					content["statusIcon"].visible = false;
				break;
				case closeButton:
					close();
				break;
				default:
			}
		}
		
		public function get level():int 
		{
			return _level;
		}
		
		public function set level(value:int):void 
		{
			_level = value;
			levelTxt.text = String(value);
		}
		
		public function get gold():Number 
		{
			return _gold;
		}
		
		public function set gold(value:Number):void 
		{
			_gold = value;
			goldTxt.text = PlayingLogic.format(value,1);
		}
		
		public function get displayName():String 
		{
			return _displayName;
		}
		
		public function set displayName(value:String):void 
		{
			_displayName = value;
			displayNameTxt.text = value;
		}
		
		public function get avatarString():String 
		{
			return _avatarString;
		}
		
		public function set avatarString(value:String):void 
		{
			_avatarString = value;
			avatar.addImg(avatarString);
		}
		
		public function get isFriend():Boolean 
		{
			return _isFriend;
		}
		
		public function set isFriend(value:Boolean):void 
		{
			_isFriend = value;
			removeFriendButton.visible = value;
			addFriendButton.visible = !value;	
		}
		
		public function get data():UserDataULC 
		{
			return _data;
		}
		
		public function set data(value:UserDataULC):void 
		{
			_data = value;
			level = int(data.levelName);
			gold = Number(data.money);
			displayName = data.displayName;
			avatarString = data.avatar;
			isFriend = data.isFriend;
			userName = data.userName;
			winTxt.text = "+" + PlayingLogic.format(data.win, 1) + " thắng";
			loseTxt.text = "+" + PlayingLogic.format(data.lose, 1) + " thua";
			
			if (isFriend)
			{
				content["statusIcon"].visible = true;
				if (data.isOnline)
				{
					switch (data.gameId) 
					{
						case MainData.MAUBINH_ID:
							gameTxt.text = "BINH";
						break;
						case MainData.PHOM_ID:
							gameTxt.text = "PHỎM";
						break;
						default:
					}
					if (data.roomID == mainData.lobbyRoomId)
						roomTxt.text = "Phòng chờ";
					else
						roomTxt.text = "Bàn số " + String(data.roomID);
				}
			}
			else
			{
				content["statusIcon"].visible = false;
			}
		}
		
	}

}