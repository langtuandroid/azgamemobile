package view.window.loginWindow 
{
	import com.adobe.serialization.json.JSON;
	import com.gsolo.encryption.MD5;
	import com.gsolo.encryption.SHA1;
	import com.ingenstudios.utils.AndroidUtilsController;
	import fl.controls.TextInput;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import getFacebookInfo.GetFacebookInfo;
	import model.chooseChannelData.ChooseChannelData;
	import model.chooseChannelData.MyInfo;
	import model.MainData;
	import model.MyDataTLMN;
	import request.MainRequest;
	import sound.SoundManager;
	import view.window.BaseWindow;
	import view.window.ConfirmWindow;
	import view.window.FillNameWindow;
	import view.window.ForgetPassWindow;
	import view.window.registerWindow.RegisterWindow;
	import view.window.SpecialGroupWindow;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class LoginWindow extends BaseWindow 
	{
		private var mainData:MainData = MainData.getInstance();
		private var sharedObject:SharedObject;
		private var registerWindow:RegisterWindow;
		private var loginFacebookBtn:SimpleButton;
		private var loginMobileBtn:SimpleButton;
		private var loginYahooBtn:SimpleButton;
		private var loginGmailBtn:SimpleButton;
		private var timerToCloseLoadingLayer:Timer;
		private var deviceId:String;
		
		public function LoginWindow() 
		{
			addContent("zLoginWindow");
			
			loginFacebookBtn = zLoginWindow(content).fastLogin["loginFacebookBtn"];
			loginMobileBtn = zLoginWindow(content).fastLogin["loginMobileBtn"];
			loginYahooBtn = zLoginWindow(content).fastLogin["loginYahooBtn"];
			loginGmailBtn = zLoginWindow(content).fastLogin["loginGmailBtn"];
			//loginFacebookBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			loginMobileBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			loginYahooBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			loginGmailBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			loginGmailBtn.visible = false;
			loginYahooBtn.visible = false;
			
			zLoginWindow(content).loginButton.addEventListener(MouseEvent.CLICK, onLoginButtonClick);
			zLoginWindow(content).registerButton.addEventListener(MouseEvent.CLICK, onRegisterButtonClick);
			zLoginWindow(content).forgetPass.addEventListener(MouseEvent.CLICK, onForgetPassClick);
			zLoginWindow(content).savePassword.addEventListener(MouseEvent.CLICK, onSavePasswordClick);
			zLoginWindow(content).forgetPass.visible = false;
			zLoginWindow(content).savePassword.visible = false;
			zLoginWindow(content).fastLogin.visible = false;
			
			sharedObject = SharedObject.getLocal("userInfo");
			if (sharedObject.data.hasOwnProperty("userName"))
				zLoginWindow(content).userName.text = sharedObject.data.userName;
				
			if (sharedObject.data.hasOwnProperty("isSavePass"))
			{
				if(sharedObject.data.isSavePass == 1)
					zLoginWindow(content).savePassword.check.visible = true;
				else
					zLoginWindow(content).savePassword.check.visible = false;
			}
			
			if (zLoginWindow(content).savePassword["check"].visible)
			{
				if (sharedObject.data.hasOwnProperty("password"))
				zLoginWindow(content).pass.text = sharedObject.data.password;
			}
			
			var mainRequest:MainRequest = new MainRequest();
			var data:Object = new Object();
			data.gameId = 2;
			zLoginWindow(content).loadingLayer.visible = false;
			
			zLoginWindow(content).pass.width = 261;
			zLoginWindow(content).pass.height = 29;
			
			zLoginWindow(content).userName.width = 261;
			zLoginWindow(content).userName.height = 29;
			
			var textFormat:TextFormat = new TextFormat("Arial", 20, 0x000000);
			zLoginWindow(content).pass.setStyle("textFormat", textFormat);
			zLoginWindow(content).userName.setStyle("textFormat", textFormat);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			deviceId = '1';
			/*if (mainData.isOnIos)
			{
				var ingenNativeExtension:IngenNativeExtension = new IngenNativeExtension();
				deviceId = ingenNativeExtension.getDeviceID();
			}
			else if (mainData.isOnAndroid)
			{
				var androidUtilsExtension:AndroidUtilsController = AndroidUtilsController.getInstance();
				deviceId = androidUtilsExtension.generateDeviceId();
			}*/
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case loginFacebookBtn:
					zLoginWindow(content).loadingLayer.visible = true;
					
					try 
					{
						GetFacebookInfo.getInstance().init();
					}
					catch (err:Error)
					{
						
					}
					
					/*if (mainData.isOnAndroid)
					{
						try 
						{
							AndroidSocialManager.getInstance().init();
						}
						catch (err:Error)
						{
							
						}
					}
					else if (mainData.isOnIos)
					{
						try 
						{
							SocialManager.getInstance().init();
						}
						catch (err:Error)
						{
							
						}
					}*/
					
					if (timerToCloseLoadingLayer)
					{
						timerToCloseLoadingLayer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCloseLoadingLayer);
						timerToCloseLoadingLayer.stop();
					}
					timerToCloseLoadingLayer = new Timer(30000, 1);
					timerToCloseLoadingLayer.addEventListener(TimerEvent.TIMER_COMPLETE, onCloseLoadingLayer);
					timerToCloseLoadingLayer.start();
				break;
				case loginMobileBtn:
					if (!sharedObject.data.hasOwnProperty("isNotFirstLoginMobile"))
					{
						var fillNameWindow:FillNameWindow = new FillNameWindow();
						fillNameWindow.addEventListener(ConfirmWindow.CONFIRM, onFillNameFinish);
						WindowLayer.getInstance().openWindow(fillNameWindow);
						return;
					}
					
					var mainRequest:MainRequest = new MainRequest();
					var data:Object = new Object();
					data.udid = deviceId;
					data.username = (new Date()).getTime();
					data.token = MD5.encrypt(SHA1.encrypt(data.username) + SHA1.encrypt(data.username) + "ciao88UDID");
					zLoginWindow(content).loadingLayer.visible = true;
					mainRequest.sendRequest_Post("http://" + mainData.gameIp + "/user/login_mobile_udid", data, onLoginMobileRespond, true);
				break;
				default:
			}
		}
		
		private function onFillNameFinish(e:Event):void 
		{
			var deviceId:String = '1';
			if (mainData.isOnIos)
			{
				var ingenNativeExtension:IngenNativeExtension = new IngenNativeExtension();
				deviceId = ingenNativeExtension.getDeviceID();
			}
			else if (mainData.isOnAndroid)
			{
				var androidUtilsExtension:AndroidUtilsController = AndroidUtilsController.getInstance();
				deviceId = androidUtilsExtension.generateDeviceId();
			}
			
			var mainRequest:MainRequest = new MainRequest();
			var data:Object = new Object();
			data.udid = deviceId;
			data.username = FillNameWindow(e.currentTarget).userName;
			data.token = MD5.encrypt(SHA1.encrypt(data.username) + SHA1.encrypt(data.username) + "ciao88UDID");
			zLoginWindow(content).loadingLayer.visible = true;
			mainRequest.sendRequest_Post("http://" + mainData.gameIp + "/user/login_mobile_udid", data, onLoginMobileRespond, true);
		}
		
		private function onLoginMobileRespond(value:Object):void 
		{
			if (value["status"] == "IO_ERROR")
			{
				zLoginWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow("Đăng nhập thất bại, link truy cập bị lỗi !!");
				return;
			}
			if (value["login_status"] == "0")
			{
				zLoginWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow(value["msg"]);
				return;
			}
			
			sharedObject.setProperty("isNotFirstLoginMobile", 1);
			mainData.loginData = value;
			
			zLoginWindow(content).loadingLayer.visible = false;
			
			excuteUserInfo(value);
			
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			mainData.removeEventListener(MainData.UPDATE_FACEBOOK_DATA, onUpdateFacebookData);
			mainData.removeEventListener(MainData.LOGIN_FACEBOOK_FAIL, onLoginFacebookFail);
			mainData.chooseChannelData.removeEventListener(ChooseChannelData.UPDATE_MY_INFO, onUpdateMyInfo);
			mainData.isOnLoginWindow = false;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			mainData.addEventListener(MainData.UPDATE_FACEBOOK_DATA, onUpdateFacebookData);
			mainData.addEventListener(MainData.LOGIN_FACEBOOK_FAIL, onLoginFacebookFail);
			mainData.chooseChannelData.addEventListener(ChooseChannelData.UPDATE_MY_INFO, onUpdateMyInfo);
			mainData.isOnLoginWindow = true;
			
			if (mainData.isFacebookVersion)
			{
				zLoginWindow(content).loadingLayer.visible = true;
				var tempRequest:MainRequest = new MainRequest();
				if (mainData.isTest)
					var url:String = "http://test.sanhbai.com/Handler/Game/azgame.ashx?op=azgame_bai_user_info";
				else
					url = "http://sanhbai.com/Handler/Game/azgame.ashx?op=azgame_bai_user_info";
				tempRequest.sendRequest_Post(url, null, getMyInfoFn, true);
			}
		}
		
		private function getMyInfoFn(value:Object):void 
		{
			var myInfo:MyInfo = new MyInfo();
			if (value == "")
			{
				zLoginWindow(content).loadingLayer.visible = false;
				mainData.chooseChannelData.myInfo = null;
				return;
			}
			if (value.TypeMsg == -1)
			{
				zLoginWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow(value.Msg);
				return;
			}
			zLoginWindow(content).loadingLayer.visible = false;
			excuteUserInfo(value);
		}
		
		private function onUpdateMyInfo(e:Event):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function onCloseLoadingLayer(e:TimerEvent):void 
		{
			zLoginWindow(content).loadingLayer.visible = false;
		}
		
		private function onLoginFacebookFail(e:Event):void 
		{
			if (timerToCloseLoadingLayer)
			{
				timerToCloseLoadingLayer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCloseLoadingLayer);
				timerToCloseLoadingLayer.stop();
			}
			zLoginWindow(content).loadingLayer.visible = false;
		}
		
		private function onUpdateFacebookData(e:Event):void 
		{
			if (timerToCloseLoadingLayer)
			{
				timerToCloseLoadingLayer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCloseLoadingLayer);
				timerToCloseLoadingLayer.stop();
			}
			var mainRequest:MainRequest = new MainRequest();
			var data:Object = new Object();
			data.fbid = mainData.facebookData.uid;
			data.udid = deviceId;
			data.token = mainData.facebookData.accessToken;
			zLoginWindow(content).loadingLayer.visible = true;
			mainRequest.sendRequest_Post("http://" + mainData.gameIp + "/user/login_mobile_facebook", data, onLoginFacebookRespond, true);
		}
		
		private function onLoginFacebookRespond(value:Object):void 
		{
			if (value["status"] == "IO_ERROR")
			{
				zLoginWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow("Đăng nhập thất bại, link truy cập bị lỗi !!");
				return;
			}
			if (value["login_status"] == "0")
			{
				zLoginWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow(value["msg"]);
				return;
			}
			
			mainData.loginData = value;
			
			zLoginWindow(content).loadingLayer.visible = false;
			
			excuteUserInfo(value);
			
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function onForgetPassClick(e:MouseEvent):void 
		{
			var forgetPassWindow:ForgetPassWindow = new ForgetPassWindow();
			WindowLayer.getInstance().openWindow(forgetPassWindow);
		}
		
		private function onSavePasswordClick(e:MouseEvent):void 
		{
			zLoginWindow(content).savePassword.check.visible = !zLoginWindow(content).savePassword.check.visible;
			if (zLoginWindow(content).savePassword.check.visible)
				sharedObject.setProperty("isSavePass", 1);
			else
				sharedObject.setProperty("isSavePass", 0);
		}
		
		private function onPassWordChange(e:Event):void 
		{
			//zLoginWindow(content).passOverLayer.text = '';
			for (var i:int = 0; i < zLoginWindow(content).pass.text.length; i++) 
			{
				//zLoginWindow(content).passOverLayer.appendText("*");
			}
		}
		
		private function onRegisterButtonClick(e:MouseEvent):void 
		{
			registerWindow = new RegisterWindow();
			registerWindow.addEventListener(RegisterWindow.REGISTER_SUCCESS, onRegisterSuccess);
			WindowLayer.getInstance().openWindow(registerWindow);
		}
		
		private function onRegisterSuccess(e:Event):void 
		{
			zLoginWindow(content).userName.text = registerWindow.userName;
			zLoginWindow(content).pass.text = registerWindow.pass;
		}
		
		private function onLoginButtonClick(e:MouseEvent):void 
		{
			var mainRequest:MainRequest = new MainRequest();
			var data:Object = new Object();
			data.user_name = zLoginWindow(content).userName.text;
			data.password = zLoginWindow(content).pass.text;
			data.client_id = mainData.client_id;
			zLoginWindow(content).loadingLayer.visible = true;
			if (mainData.isTest)
				mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileLogin", data, onLoginValidateRespond, true);
				//mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayUserExt.asmx/Azgamebai_AppMobileLogin", data, onLoginValidateRespond, true);
				//mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayUserExt.asmx/GetListTwav001", data, onLoginValidateRespond, true);
			else
				mainRequest.sendRequest_Post("http://wss.sanhbai.com/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileLogin", data, onLoginValidateRespond, true);
			
			if (zLoginWindow(content).savePassword["check"].visible)
			{
				sharedObject.setProperty("userName", zLoginWindow(content).userName.text);
				sharedObject.setProperty("password", zLoginWindow(content).pass.text);
			}
		}
		
		private function onLoginValidateRespond(value:Object):void 
		{
			if (value["status"] == "IO_ERROR")
			{
				zLoginWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow("Đăng nhập thất bại, link truy cập bị lỗi !!");
				return;
			}
			if (value.TypeMsg < 1)
			{
				zLoginWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow(value.Msg);
				return;
			}
			
			var mainRequest:MainRequest = new MainRequest();
			var data:Object = new Object();
			data.client_id = mainData.client_id;
            data.client_hash = MD5.encrypt(mainData.client_id + mainData.client_secret + value.Data.Code);
            data.code = value.Data.Code;
			if (mainData.isTest)
				mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileGetUserInfo", data, onLoginRespond, true);
			else
				mainRequest.sendRequest_Post("http://wss.azgame.vn/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileGetUserInfo", data, onLoginRespond, true);
		}
		
		private function onLoginRespond(value:Object):void 
		{
			if (value["status"] == "IO_ERROR")
			{
				zLoginWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow("Đăng nhập thất bại, link truy cập bị lỗi !!");
				return;
			}
			if (value.TypeMsg < 1)
			{
				zLoginWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow(value.Msg);
				return;
			}
			
			mainData.loginData = value.Data;
			
			zLoginWindow(content).loadingLayer.visible = false;
			
			excuteUserInfo(value);
			
			close(BaseWindow.MIDDLE_EFFECT);
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
			//myInfo.uId = value.Data["UserName"];
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
			
			/*myInfo.avatar = '';
			myInfo.money = 100000;
			myInfo.cash = 0;
			myInfo.level = '1';
			myInfo.name = 'tuandung';
			myInfo.hash = '';
			myInfo.token = '';
			myInfo.uId = '25';
			myInfo.id = '25';
			myInfo.logo = '';
			myInfo.sex = '';*/
			
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