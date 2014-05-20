package view.window 
{
	import control.MainCommand;
	import event.DataFieldMauBinh;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import logic.PlayingLogic;
	import model.MainData;
	import view.userInfo.avatar.Avatar;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author 
	 */
	public class UserProfileWindow extends BaseWindow 
	{
		private var displayNameTxt:TextField;
		private var goldTxt:TextField;
		private var levelTxt:TextField;
		
		public var userName:String;
		private var _displayName:String;
		private var _avatarString:String;
		private var _gold:Number;
		private var _level:int;
		private var _isShowKickOut:Boolean;
		private var _isFriend:Boolean;
		
		private var addFriendButton:SimpleButton;
		private var removeFriendButton:SimpleButton;
		private var kickoutButton:SimpleButton;
		private var closeButton:SimpleButton;
		private var avatar:Avatar;
		
		private var mainData:MainData = MainData.getInstance();
		private var electroServerCommand:* = MainCommand.getInstance().electroServerCommand;
		
		public function UserProfileWindow() 
		{
			super();
			
			addContent("zUserProfileWindow");
			
			displayNameTxt = content["displayNameTxt"];
			goldTxt = content["goldTxt"];
			levelTxt = content["levelTxt"];
			addFriendButton = content["addFriendButton"];
			removeFriendButton = content["removeFriendButton"];
			kickoutButton = content["kickoutButton"];
			closeButton = content["closeButton"];
			
			addFriendButton.visible = removeFriendButton.visible = false;
			
			addFriendButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			removeFriendButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			kickoutButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			closeButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			avatar = new Avatar();
			avatar.setForm(Avatar.MY_AVATAR);
			avatar.x = content["avatarPosition"].x;
			avatar.y = content["avatarPosition"].y;
			content["avatarPosition"].visible = false;
			avatar.width = avatar.height = content["avatarPosition"].width;
			addChild(avatar);
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case addFriendButton:
					electroServerCommand.addFriend(userName, DataFieldMauBinh.IN_GAME_ROOM);
					close();
					electroServerCommand.getFriendList();
				break;
				case removeFriendButton:
					electroServerCommand.removeFriend(userName, DataFieldMauBinh.IN_GAME_ROOM);
					close();
					electroServerCommand.getFriendList();
				break;
				case kickoutButton:
					var confirmKickOutWindow:ConfirmWindow = new ConfirmWindow();
					confirmKickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.confirmKickOut + " " + displayName);
					confirmKickOutWindow.addEventListener(ConfirmWindow.CONFIRM, onConfirmKickOut);
					WindowLayer.getInstance().openWindow(confirmKickOutWindow);
					close();
				break;
				case closeButton:
					close();
				break;
				default:
			}
		}
		
		private function onConfirmKickOut(e:Event):void 
		{
			electroServerCommand.kickUser(userName);
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
		
		public function set isShowKickOut(value:Boolean):void 
		{
			_isShowKickOut = value;
			kickoutButton.visible = value;
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
		
	}

}