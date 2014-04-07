package control.getInfoCommand 
{
	import com.adobe.serialization.json.JSON;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import model.chooseChannelData.MyInfo;
	import model.MainData;
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
					var object:Object = new Object();
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
	}

}