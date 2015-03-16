package view.window 
{
	import com.gsolo.encryption.MD5;
	import control.MainCommand;
	import event.DataFieldMauBinh;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import model.MainData;
	import request.MainRequest;
	import view.userInfo.avatar.Avatar;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author ...
	 */
	public class SendMessageWindow extends BaseWindow 
	{
		private var displayNameTxt:TextField;
		private var levelIcon:MovieClip;
		private var levelTxt:TextField;
		private var messageTxt:TextField;
		
		public var userName:String;
		private var _displayName:String;
		private var _avatarString:String;
		private var _level:int;
		
		private var cancelButton:SimpleButton;
		private var sendButton:SimpleButton;
		private var closeButton:SimpleButton;
		private var avatar:Avatar;
		private var _data:UserDataULC;
		
		private var mainData:MainData = MainData.getInstance();
		private var electroServerCommand:* = MainCommand.getInstance().electroServerCommand;
		
		public function SendMessageWindow() 
		{
			super();
			
			addContent("zSendMessageWindow");
			
			displayNameTxt = content["displayNameTxt"];
			levelIcon = content["levelIcon"];
			levelTxt = levelIcon["levelTxt"];
			messageTxt = content["messageTxt"];
			closeButton = content["closeButton"];
			cancelButton = content["cancelButton"];
			sendButton = content["sendButton"];
			
			closeButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			sendButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			cancelButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			avatar = new Avatar();
			avatar.setForm(Avatar.MY_AVATAR);
			avatar.x = content["avatarPosition"].x;
			avatar.y = content["avatarPosition"].y;
			avatar.width = avatar.height = content["avatarPosition"].width;
			content["avatarPosition"].visible = false;
			addChild(avatar);
			
			addChild(levelIcon);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case closeButton:
					close();
				break;
				case cancelButton:
					close();
				break;
				case sendButton:
					sendMessage()
					close();
				break;
				default:
			}
		}
		
		// Lấy thông tin user của mình trong khung user
		public function sendMessage():void
		{
			var tokenTime:Number = mainData.chooseChannelData.myInfo.tokenTime;
			var currentTime:Number = (new Date()).getTime();
			if (tokenTime == 0)
			{
				var tempRequest:MainRequest = new MainRequest();
				var url:String = mainData.init.requestLink.getAccessTokenLink.@url;
				var object:Object = new Object();
				object.client_id = mainData.client_id
				object.client_secret = mainData.client_secret
				object.client_timestamp = (new Date()).getTime();
				object.nick_name = mainData.chooseChannelData.myInfo.name;
				object.client_hash = MD5.encrypt(object.client_id + object.client_timestamp + object.client_secret + object.nick_name);
				tempRequest.sendRequest_Post(url, object, getAccessTokenFn, true);
			}
			else if ((currentTime - tokenTime) / (1000 * 60) > 55)
			{
				tempRequest = new MainRequest();
				url = mainData.init.requestLink.reNewAccessTokenLink.@url;
				object = new Object();
				object.client_id = mainData.client_id
				object.client_secret = mainData.client_secret
				object.access_token = mainData.chooseChannelData.myInfo.token;
				object.client_hash = MD5.encrypt(object.client_id + object.client_secret + object.access_token);
				tempRequest.sendRequest_Post(url, object, getAccessTokenFn, true);
			}
			else
			{
				tempRequest = new MainRequest();
				url = mainData.init.requestLink.sendMessageLink.@url;
				object = new Object();
				object.access_token = mainData.chooseChannelData.myInfo.token;
				object.nick_receiver = data.displayName;
				object.message = messageTxt.text;
				object.client_hash = MD5.encrypt(object.access_token + mainData.client_secret + object.nick_receiver + object.message);
				tempRequest.sendRequest_Post(url, object, sendMessageFn, true);
			}
		}
		
		private function getAccessTokenFn(value:Object):void 
		{
			if (value.TypeMsg == '1')
			{
				mainData.chooseChannelData.myInfo.token = value.Data.access_token;
				var tempRequest:MainRequest = new MainRequest();
				var url:String = mainData.init.requestLink.sendMessageLink.@url;
				var object:Object = new Object();
				object.access_token = mainData.chooseChannelData.myInfo.token;
				object.nick_receiver = data.displayName;
				object.message = messageTxt.text;
				object.client_hash = MD5.encrypt(object.access_token + mainData.client_secret + object.nick_receiver + object.message);
				tempRequest.sendRequest_Post(url, object, sendMessageFn, true);
			}
			else
			{
				WindowLayer.getInstance().openAlertWindow("get access token fail !!");
			}
		}
		
		private function sendMessageFn(value:Object):void 
		{
			if (value.TypeMsg == '1')
			{
				electroServerCommand.sendPrivateMessage([data.userName], DataFieldMauBinh.SEND_MESSAGE, null);
			}
			else
			{
				WindowLayer.getInstance().openAlertWindow("Gửi tin nhắn thất bại, bạn vui lòng thử lại nhé !!");
			}
		}
		
		public function get level():int 
		{
			return _level;
		}
		
		public function set level(value:int):void 
		{
			_level = value;
			levelIcon.gotoAndStop(Math.ceil(level/ 10));
			levelTxt.text = String(value);
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
		
		public function get data():UserDataULC 
		{
			return _data;
		}
		
		public function set data(value:UserDataULC):void 
		{
			_data = value;
			level = int(data.levelName);
			displayName = data.displayName;
			avatarString = data.avatar;
			userName = data.userName;
		}
		
	}

}