package control.getInfoCommand 
{
	import com.adobe.serialization.json.JSON;
	import com.gsolo.encryption.MD5;
	import event.DataFieldMauBinh;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import model.chooseChannelData.MyInfo;
	import model.MainData;
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
				WindowLayer.getInstance().openAlertWindow("Lấy thông tin sảnh thất bại!!");
			}
			
			//getMyInfo();
		}
		
		// Lấy thông tin các tin nhắn gửi cho mình
		public function getMessageInfo():void
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
				url = mainData.init.requestLink.getMessageInfoLink.@url;
				object = new Object();
				object.access_token = mainData.chooseChannelData.myInfo.token;
				tempRequest.sendRequest_Post(url, object, getMessageInfoFn, true);
			}
		}
		
		private function getAccessTokenFn(value:Object):void 
		{
			if (value.TypeMsg == '1')
			{
				mainData.chooseChannelData.myInfo.token = value.Data.access_token;
				var tempRequest:MainRequest = new MainRequest();
				var url:String = mainData.init.requestLink.getMessageInfoLink.@url;
				var object:Object = new Object();
				object.access_token = mainData.chooseChannelData.myInfo.token;
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
					messObject[DataFieldMauBinh.SENDER] = dataList[i].nick_sender;
					messObject[DataFieldMauBinh.MESSAGE] = dataList[i].message;
					messObject[DataFieldMauBinh.TIME] = dataList[i].rgt_dtm;
					var h:String = String(messObject[DataFieldMauBinh.TIME]).substr(8,2) + 'h';
					var m:String = String(messObject[DataFieldMauBinh.TIME]).substr(10,2);
					var d:String = String(messObject[DataFieldMauBinh.TIME]).substr(0,2);
					var month:String = String(messObject[DataFieldMauBinh.TIME]).substr(2,2);
					var y:String = String(messObject[DataFieldMauBinh.TIME]).substr(4,4);
					messObject[DataFieldMauBinh.CHAT_CONTENT] = messObject[DataFieldMauBinh.MESSAGE] + " (gửi lúc " + h + m + " ngày " + d + "/" + month + "/" + y + ")";
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
					object.access_token = mainData.chooseChannelData.myInfo.token;
					object.client_hash = MD5.encrypt(object.client_id + object.client_secret + object.access_token);
					tempRequest.sendRequest_Post(url, object, getAccessTokenFn, true);
				}
				else
				{
					WindowLayer.getInstance().openAlertWindow("Lấy thông tin tin nhắn thất bại!! " + value.TypeMsg);
				}
			}
		}
		
		// Nạp tiền miễn phí trong ngày
		public function addMoney():void
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
				tempRequest.sendRequest_Post(url, object, getAccessTokenToAddMoneyFn, true);
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
				tempRequest.sendRequest_Post(url, object, getAccessTokenToAddMoneyFn, true);
			}
			else
			{
				tempRequest = new MainRequest();
				url = mainData.init.requestLink.addMoneyLink.@url;
				object = new Object();
				object.access_token = mainData.chooseChannelData.myInfo.token;
				tempRequest.sendRequest_Post(url, object, addMoneyFn, true);
			}
		}
		
		private function getAccessTokenToAddMoneyFn(value:Object):void 
		{
			if (value.TypeMsg == '1')
			{
				mainData.chooseChannelData.myInfo.token = value.Data.access_token;
				var tempRequest:MainRequest = new MainRequest();
				var url:String = mainData.init.requestLink.addMoneyLink.@url;
				var object:Object = new Object();
				object.access_token = mainData.chooseChannelData.myInfo.token;
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
				WindowLayer.getInstance().openAlertWindow(value.Msg);
			}
		}
	}

}