package control.getInfoCommand 
{
	import com.adobe.serialization.json.JSON;
	import com.gsolo.encryption.MD5;
	import event.DataField;
	import event.DataFieldMauBinh;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import model.chooseChannelData.MyInfo;
	import model.MainData;
	//import view.window.AddMoneyWindow;
	import view.window.AddMoneyWindow2;
	import view.window.windowLayer.WindowLayer;
	//import org.bytearray.decoder.JPEGDecoder;
	import request.MainRequest;
	/**
	 * ...
	 * @author Yun
	 */
	public class GetInfoCommand 
	{
		private var mainData:MainData = MainData.getInstance();
		public function GetInfoCommand() 
		{
			
		}
		
		// Lấy thông tin user của mình trong khung user
		public function getMyInfo():void
		{
			
		}
		
		private function getMyInfoFn(value:Object):void 
		{
			var myInfo:MyInfo = new MyInfo();
			if (value == "")
			{
				mainData.chooseChannelData.myInfo = null;
				return;
			}
			
			myInfo.avatar = value["avatar"];
			myInfo.money = value["money"];
			myInfo.level = value["level"];
			myInfo.name = value["name"];
			myInfo.hash = value["hash"];
			myInfo.uId = value["uid"];
			myInfo.logo = value["logo"];
			myInfo.siteId = value["siteid"];
			myInfo.vipPoint = value["point"];
			myInfo.sex = value["sex"];
			mainData.chooseChannelData.myInfo = myInfo;
		}
		
		// Lấy thông tin của các kênh trong phòng chọn kênh
		public function getChannelInfo():void
		{
			var tempRequest:MainRequest = new MainRequest();
			var url:String;
			var object:Object;
			switch (mainData.gameType) 
			{
				case MainData.TLMN:
					url = /*mainData.basepath + */mainData.init.requestLink.getChannelLink.@url;
					object = new Object();
					object.game_id = 'AZGB_TLMN';
				break;
				case MainData.SAM:
					url = /*mainData.basepath + */mainData.init.requestLink.getChannelLink.@url;
					object = new Object();
					object.game_id = 'AZGB_SAM';
				break;
				case MainData.PHOM:
					url = /*mainData.basepath + */mainData.init.requestLink.getChannelLink.@url;
					object = new Object();
					object.game_id = 'AZGB_PHOM';
				break;
				case MainData.MAUBINH:
					url = /*mainData.basepath + */mainData.init.requestLink.getChannelLink.@url;
					object = new Object();
					object.game_id = 'AZGB_BINH';
				break;
				case MainData.XITO:
					url = "http://" + mainData.gameIp + "/javajson/Getgamegroup2/5";
				break;
				default:
			}
			
			tempRequest.sendRequest_Post(url, object, getChannelInfoFn, true);
		}
		
		private function getChannelInfoFn(value:Object):void 
		{
			//mainData.chooseChannelData.channelInfoArray = value as Array;
			
			if (value["TypeMsg"])
			{
				mainData.chooseChannelData.channelInfoArray = value["Data"];
			}
			else
			{
				//WindowLayer.getInstance().openAlertWindow("Lấy thông tin sảnh thất bại!!");
			}
			
			//getMyInfo();
		}
		
		// Lấy thông tin các tin nhắn gửi cho mình
		public function getMessageInfo():void
		{
			var tokenTime:Number = mainData.tokenTime;
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
			else
			{
				tempRequest = new MainRequest();
				url = mainData.init.requestLink.getMessageInfoLink.@url;
				object = new Object();
				object.access_token = mainData.token;
				tempRequest.sendRequest_Post(url, object, getMessageInfoFn, true);
			}
		}
		
		private function getAccessTokenFn(value:Object):void 
		{
			if (value.TypeMsg == '1')
			{
				mainData.token = value.Data.access_token;
				mainData.tokenTime = (new Date()).getTime();
				var tempRequest:MainRequest = new MainRequest();
				var url:String = mainData.init.requestLink.getMessageInfoLink.@url;
				var object:Object = new Object();
				object.access_token = mainData.token;
				tempRequest.sendRequest_Post(url, object, getMessageInfoFn, true);
			}
			else if (value.status == "IO_ERROR")
			{
				
			}
			else
			{
				WindowLayer.getInstance().openAlertWindow("get access token from get message list fail !!");
			}
		}
		
		private function getMessageInfoFn(value:Object):void 
		{
			//mainData.chooseChannelData.channelInfoArray = value as Array;
			
			if (value.TypeMsg == '1')
			{
				var dataList:Array = value.Data.List_Message;
				dataList.reverse();
				var unreadMess:int = value.Data.New_Message_Count;
				var messageList:Array = new Array();
				var messageObject:Object = new Object();
				for (var i:int = 0; i < dataList.length; i++) 
				{
					var messObject:Object = new Object();
					messObject[DataField.SENDER] = dataList[i].nick_sender;
					messObject[DataField.MESSAGE] = dataList[i].message;
					messObject[DataField.TIME] = dataList[i].rgt_dtm;
					var h:String = String(messObject[DataField.TIME]).substr(8,2) + 'h';
					var m:String = String(messObject[DataField.TIME]).substr(10,2);
					var d:String = String(messObject[DataField.TIME]).substr(0,2);
					var month:String = String(messObject[DataField.TIME]).substr(2,2);
					var y:String = String(messObject[DataField.TIME]).substr(4,4);
					messObject[DataField.CHAT_CONTENT] = messObject[DataField.MESSAGE] + " (gửi lúc " + h + m + " ngày " + d + "/" + month + "/" + y + ")";
					messageList.push(messObject);
				}
				messageObject[DataFieldMauBinh.MESSAGE_LIST] = messageList;
				messageObject[DataFieldMauBinh.UNREAD_MESSAGE] = unreadMess;
				mainData.messageObject = messageObject;
			}
			else if (value.status == "IO_ERROR")
			{
				
			}
			else
			{
				if (value.TypeMsg == '-1000')
				{
					var tempRequest:MainRequest = new MainRequest();
					var url:String = mainData.init.requestLink.reNewAccessTokenLink.@url;
					var object:Object = new Object();
					object.client_id = mainData.client_id
					object.client_secret = mainData.client_secret
					object.access_token = mainData.token;
					object.client_hash = MD5.encrypt(object.client_id + object.client_secret + object.access_token);
					tempRequest.sendRequest_Post(url, object, getAccessTokenFn, true);
				}
				else
				{
					//WindowLayer.getInstance().openAlertWindow("Lấy thông tin tin nhắn thất bại!! " + value.TypeMsg);
				}
			}
		}
		
		// Nạp tiền miễn phí trong ngày
		public function addMoney():void
		{
			var tokenTime:Number = mainData.chooseChannelData.myInfo.tokenTime;
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
				tempRequest.sendRequest_Post(url, object, getAccessTokenToAddMoneyFn, true);
			}
			else
			{
				tempRequest = new MainRequest();
				url = mainData.init.requestLink.addMoneyLink.@url;
				object = new Object();
				object.access_token = mainData.token;
				tempRequest.sendRequest_Post(url, object, addMoneyFn, true);
			}
		}
		
		private function getAccessTokenToAddMoneyFn(value:Object):void 
		{
			if (value.TypeMsg == '1')
			{
				mainData.token = value.Data.access_token;
				mainData.tokenTime = (new Date()).getTime();
				var tempRequest:MainRequest = new MainRequest();
				var url:String = mainData.init.requestLink.addMoneyLink.@url;
				var object:Object = new Object();
				object.access_token = mainData.token;
				tempRequest.sendRequest_Post(url, object, addMoneyFn, true);
			}
			else if (value.status == "IO_ERROR")
			{
				
			}
			else
			{
				WindowLayer.getInstance().openAlertWindow("get access token from add money fail !!");
			}
		}
		
		private function addMoneyFn(value:Object):void 
		{
			if (value.TypeMsg == '1')
			{
				mainData.chooseChannelData.myInfo.money = value.Data.Money;
				mainData.chooseChannelData.myInfo = mainData.chooseChannelData.myInfo;
				var addMoneyWindow:AddMoneyWindow2 = new AddMoneyWindow2();
				addMoneyWindow.freeGold = value.Data.FreeGoldValue;
				addMoneyWindow.freeNumber = value.Data.FreeGoldNumRemaining;
				WindowLayer.getInstance().openWindow(addMoneyWindow);
			}
			else if (value.status == "IO_ERROR")
			{
				
			}
			else
			{
				if (value.TypeMsg == '-1000')
				{
					var tempRequest:MainRequest = new MainRequest();
					var url:String = mainData.init.requestLink.reNewAccessTokenLink.@url;
					var object:Object = new Object();
					object.client_id = mainData.client_id
					object.client_secret = mainData.client_secret
					object.access_token = mainData.token;
					object.client_hash = MD5.encrypt(object.client_id + object.client_secret + object.access_token);
					tempRequest.sendRequest_Post(url, object, getAccessTokenToAddMoneyFn, true);
				}
				else
				{
					if (int(value.TypeMsg) == -102)
						return;
					if (int(value.TypeMsg) == -100)
					{
						addMoneyWindow = new AddMoneyWindow2();
						addMoneyWindow.freeNumber = -1;
						WindowLayer.getInstance().openWindow(addMoneyWindow);
						return;
					}
					WindowLayer.getInstance().openAlertWindow(value.Msg);
				}
			}
		}
		
		// Lấy thông tin thông báo hệ thống
		public function getSystemNoticeInfo():void
		{
			var tokenTime:Number = mainData.tokenTime;
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
				tempRequest.sendRequest_Post(url, object, getAccessTokenFromSystemNoticeFn, true);
			}
			else
			{
				tempRequest = new MainRequest();
				url = mainData.init.requestLink.getMessageInfoLink.@url;
				object = new Object();
				object.access_token = mainData.token;
				object.nick_receiver = "system_notify_top";
				tempRequest.sendRequest_Post(url, object, getSystemNoticeInfoFn, true);
			}
		}
		
		private function getAccessTokenFromSystemNoticeFn(value:Object):void 
		{
			if (value.TypeMsg == '1')
			{
				mainData.token = value.Data.access_token;
				mainData.tokenTime = (new Date()).getTime();
				var tempRequest:MainRequest = new MainRequest();
				var url:String = mainData.init.requestLink.getMessageInfoLink.@url;
				var object:Object = new Object();
				object.access_token = mainData.token;
				object.nick_receiver = "system_notify_top";
				tempRequest.sendRequest_Post(url, object, getSystemNoticeInfoFn, true);
			}
			else
			{
				//WindowLayer.getInstance().openAlertWindow("get access token from get message list fail !!");
			}
		}
		
		private function getSystemNoticeInfoFn(value:Object):void 
		{
			//mainData.chooseChannelData.channelInfoArray = value as Array;
			
			if (value.TypeMsg == '1')
			{
				var dataList:Array = value.Data.List_Message;
				dataList.reverse();
				var unreadMess:int = value.Data.New_Message_Count;
				var messageList:Array = new Array();
				var messageObject:Object = new Object();
				var noticeList:Array = new Array();
				for (var i:int = 0; i < dataList.length; i++) 
				{
					var tempObject:Object = new Object();
					tempObject[DataField.MESSAGE] = dataList[i].message;
					tempObject[DataField.INDEX] = dataList[i].rgt_dtm;
					noticeList.push(tempObject);
				}
				if (noticeList[0] && mainData.systemNoticeList[0])
				{
					if (noticeList[0][DataField.INDEX] == mainData.systemNoticeList[0][DataField.INDEX])
						return;
				}
				mainData.systemNoticeList = noticeList;
			}
			else
			{
				if (value.TypeMsg == '-1000')
				{
					var tempRequest:MainRequest = new MainRequest();
					var url:String = mainData.init.requestLink.reNewAccessTokenLink.@url;
					var object:Object = new Object();
					object.client_id = mainData.client_id
					object.client_secret = mainData.client_secret
					object.access_token = mainData.token;
					object.client_hash = MD5.encrypt(object.client_id + object.client_secret + object.access_token);
					tempRequest.sendRequest_Post(url, object, getAccessTokenFromSystemNoticeFn, true);
				}
				else
				{
					//WindowLayer.getInstance().openAlertWindow("Lấy thông báo hệ thống thất bại: " + value.Msg);
				}
			}
		}
		
		// Lấy thông tin của các room ảo trong phòng chọn kênh
		public function getVirtualRoomInfo():void
		{
			var tempRequest:MainRequest = new MainRequest();
			var url:String = mainData.init.requestLink.getRoomLink.@url;
			var object:Object = new Object();
			object.game_id = mainData.game_id;
			object.row_start = 0;
			object.row_end = 10;
			tempRequest.sendRequest_Post(url, object, getVirtualRoomInfoFn, true);
		}
		
		private function getVirtualRoomInfoFn(value:Object):void 
		{
			//mainData.chooseChannelData.channelInfoArray = value as Array;
			
			if (value["TypeMsg"] == '1')
			{
				mainData.virtualRooms = value.Data;
			}
			else
			{
				//WindowLayer.getInstance().openAlertWindow("Lấy thông tin phòng thất bại");
			}
		}
	}

}