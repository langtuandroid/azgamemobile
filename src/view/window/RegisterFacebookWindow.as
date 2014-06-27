package view.window 
{
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Yun
	 */
	public class RegisterFacebookWindow extends BaseWindow 
	{
		
		public function RegisterFacebookWindow() 
		{
			super();
			addEventListener(MouseEvent.CLICK, onConfirm);
		}
		
		private function onConfirm(e:MouseEvent):void 
		{
			var mainRequest:MainRequest = new MainRequest();
			var data:Object = new Object();
			data.access_token = mainData.facebookData.accessToken;
			zLoginWindow(content).loadingLayer.visible = true;
			if (mainData.isTest)
				mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayUserExt.asmx/Facebook_GetUserInfo", data, onLoginFacebookRespond, true);
			else
				mainRequest.sendRequest_Post("http://wss.azgame.us/Service02/OnplayUserExt.asmx/Facebook_GetUserInfo", data, onLoginFacebookRespond, true);
		}
		
		private function onLoginFacebookRespond(value:Object):void 
		{
			if (value["status"] == "IO_ERROR")
			{
				zLoginWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow("Đăng nhập thất bại, link truy cập bị lỗi !!");
				return;
			}
			if (value["TypeMsg"] == "1")
			{
				mainData.loginData = value;
				zLoginWindow(content).loadingLayer.visible = false;
				excuteUserInfo(value);
				close(BaseWindow.MIDDLE_EFFECT);
				return;
			}
		}
		
		private function excuteUserInfo(value:Object):void
		{
			var myInfo:MyInfo = new MyInfo();
			
			mainData.minMoney = value.Data["MinMoneyToFreeGold"];
			myInfo.avatar = value.Data["Avatar"];
			myInfo.money = value.Data["Money"];
			myInfo.cash = value.Data["Cash"];
			myInfo.level = value.Data["Level"];
			myInfo.name = value.Data["Displayname"];
			myInfo.hash = '';
			myInfo.token = '';
			myInfo.uId = value.Data["Id"];
			myInfo.id = value.Data["Id"];
			myInfo.logo = '';
			myInfo.sex = value.Data["GenderCode"];
			
			MyDataTLMN.getInstance().myId = value.Data["Id"];
			MyDataTLMN.getInstance().myDisplayName = value.Data["Displayname"];
			MyDataTLMN.getInstance().myMoney[0] = value.Data["Money"];
			MyDataTLMN.getInstance().myMoney[1] = value.Data["Cash"];
			MyDataTLMN.getInstance().myAvatar = value.Data["Avatar"];
			MyDataTLMN.getInstance().sex = value.Data["GenderCode"];
			
			mainData.chooseChannelData.myInfo = myInfo;
			
			//if (!SoundManager.getInstance().isLoadSoundChung)
				//SoundManager.getInstance().loadSoundChung();
			//if (!SoundManager.getInstance().isLoadSoundMauBinh)
				//SoundManager.getInstance().loadSoundMauBinh();
			//if (!SoundManager.getInstance().isLoadSoundPhom)
				//SoundManager.getInstance().loadSoundPhom();
			//if (!SoundManager.getInstance().isLoadSoundTlmn)
				//SoundManager.getInstance().addSound();
		}
	}

}