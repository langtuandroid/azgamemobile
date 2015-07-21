package view.window.loginWindow 
{
	import br.com.stimuli.loading.BulkLoader;
	import com.adobe.serialization.json.JSON;
	import com.gsolo.encryption.MD5;
	import com.gsolo.encryption.SHA1;
	import fl.controls.TextInput;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.media.StageWebView;
	import getFacebookInfo.GetFacebookInfo;
	import model.chooseChannelData.ChooseChannelData;
	import model.chooseChannelData.MyInfo;
	import model.MainData;
	import model.MyDataTLMN;
	import nid.ui.controls.VirtualKeyBoard;
	import request.MainRequest;
	import sound.SoundManager;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.ConfirmWindow;
	import view.window.FillNameWindow;
	import view.window.ForgetPassWindow;
	import view.window.RegisterFacebookWindow;
	import view.window.registerWindow.RegisterWindow;
	import view.window.SpecialGroupWindow;
	import view.window.windowLayer.WindowLayer;
	import Date;
	
	
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
		private var versionTxt:TextField;
		private var loader:BulkLoader;
		
		private var tFSuggest:TextFormat;
		private var tFNormal:TextFormat;
		public function LoginWindow() 
		{
			addContent("zLoginWindow");
			//mainData.loginType = '1';
			if (mainData.isFacebookVersion) 
			{
				content.visible = false;
				WindowLayer.getInstance().openLoadingWindow();
			}
			
			tFSuggest = new TextFormat("Tahoma", 20, 0x595959)
			tFNormal = new TextFormat("Arial", 20, 0x000000);
			
			loginFacebookBtn = zLoginWindow(content).fastLogin["loginFacebookBtn"];
			loginMobileBtn = zLoginWindow(content).fastLogin["loginMobileBtn"];
			loginYahooBtn = zLoginWindow(content).fastLogin["loginYahooBtn"];
			loginGmailBtn = zLoginWindow(content).fastLogin["loginGmailBtn"];
			loginFacebookBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			loginMobileBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			loginYahooBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			loginGmailBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			loginGmailBtn.visible = false;
			loginYahooBtn.visible = false;
			//loginMobileBtn.visible = false;
			mainData.isFirstJoinLobby = true;
			mainData.isAtLogin = true;
			///////////////////////////
			zLoginWindow(content).loginButton.addEventListener(MouseEvent.CLICK, onLoginButtonClick);
			zLoginWindow(content).registerButton.addEventListener(MouseEvent.CLICK, onRegisterButtonClick);
			zLoginWindow(content).forgetPass.addEventListener(MouseEvent.CLICK, onForgetPassClick);
			zLoginWindow(content).savePassword.addEventListener(MouseEvent.CLICK, onSavePasswordClick);
			//zLoginWindow(content).forgetPass.visible = false;
			zLoginWindow(content).savePassword.visible = false;
			
			
			
			sharedObject = SharedObject.getLocal("userInfo");
			
			zLoginWindow(content).pass.setStyle("textFormat", tFNormal);
			zLoginWindow(content).userName.setStyle("textFormat", tFNormal);
			/*if (sharedObject.data.hasOwnProperty("userName")) 
			{
				zLoginWindow(content).pass.setStyle("textFormat", tFNormal);
				zLoginWindow(content).userName.setStyle("textFormat", tFNormal);
			}
			else 
			{
				zLoginWindow(content).pass.setStyle("textFormat", tFSuggest);
				zLoginWindow(content).userName.setStyle("textFormat", tFSuggest);
				zLoginWindow(content).userName.text = "ai_do@vidu.com";
				zLoginWindow(content).userName.addEventListener(FocusEvent.FOCUS_IN, onFocusUserName);
				zLoginWindow(content).userName.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutUserName);
			}*/
			
			
			if (sharedObject.data.hasOwnProperty("loginType"))
				mainData.loginType = sharedObject.data.loginType;
				
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
			zLoginWindow(content).userName.maxChars = 50;
			
			zLoginWindow(content).userName.tabIndex = 0;
			zLoginWindow(content).pass.tabIndex = 1;
			zLoginWindow(content).versionTxt.text = mainData.version;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			try 
			{
				if (mainData.isOnAndroid)
				{
					deviceId = MyAirDeviceId.getInstance().getID("SanhBai");
				}
				else if (mainData.isOnIos)
				{
					if (sharedObject.data.hasOwnProperty("deviceId"))
					{
						deviceId = sharedObject.data.deviceId;
					}
					else
					{
						deviceId = String(Math.random() * 100000000000) + String(Math.random() * 100000000000);
						sharedObject.setProperty("deviceId", deviceId);
					}
				}
			}
			catch (err:Error)
			{
				
			}
			
			zLoginWindow(content).loadingSoundLayer["percentTxt"].text = '0%';
			zLoginWindow(content).loadingSoundLayer.visible = false;
			
			if (mainData.isFirstLogin && !mainData.isFacebookVersion)
			{
				if (mainData.loginType == '1')
				{
					loginMobile();
					mainData.isFirstLogin = false;
				}
				else if (mainData.loginType == '2')
				{
					loginFacebook();
					mainData.isFirstLogin = false;
				}
				else if (mainData.loginType == '3')
				{
					loginEmail();
					mainData.isFirstLogin = false;
				}
			}
		}
		
		private function onFocusUserName(e:FocusEvent):void 
		{
			if (zLoginWindow(content).userName.text == "ai_do@vidu.com" || zLoginWindow(content).userName.text == "") 
			{
				zLoginWindow(content).pass.setStyle("textFormat", tFNormal);
				zLoginWindow(content).userName.setStyle("textFormat", tFNormal);
				zLoginWindow(content).userName.text = "";
			}
		}
		
		private function onFocusOutUserName(e:FocusEvent):void 
		{
			if (zLoginWindow(content).userName.text == "ai_do@vidu.com" || zLoginWindow(content).userName.text == "") 
			{
				zLoginWindow(content).pass.setStyle("textFormat", tFSuggest);
				zLoginWindow(content).userName.setStyle("textFormat", tFSuggest);
				zLoginWindow(content).userName.text = "ai_do@vidu.com";
			}
		}
		
		private function onShowVirtualKeyBoard(e:MouseEvent):void 
		{
			VirtualKeyBoard.getInstance().target = { field:e.currentTarget, fieldName:sharedObject.data.userName };
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case loginFacebookBtn:
					loginFacebook();
				break;
				case loginMobileBtn:
					loginMobile();
				break;
				default:
			}
		}
		
		private function loginFacebook():void 
		{
			mainData.addEventListener(MainData.UPDATE_FACEBOOK_DATA, onUpdateFacebookData);
			zLoginWindow(content).loadingLayer.visible = true;
			sharedObject.setProperty("loginType", '2');	
			try 
			{
				GetFacebookInfo.getInstance().init();
			}
			catch (err:Error)
			{
				
			}
			
			if (timerToCloseLoadingLayer)
			{
				timerToCloseLoadingLayer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCloseLoadingLayer);
				timerToCloseLoadingLayer.stop();
			}
			timerToCloseLoadingLayer = new Timer(60000, 1);
			timerToCloseLoadingLayer.addEventListener(TimerEvent.TIMER_COMPLETE, onCloseLoadingLayer);
			timerToCloseLoadingLayer.start();
		}
		
		private function loginMobile():void 
		{
			sharedObject.setProperty("loginType", '1');	
			zLoginWindow(content).loadingLayer.visible = true;
			var mainRequest:MainRequest = new MainRequest();
			var data:Object = new Object();
			data.device_id = deviceId;
			data.client_id = mainData.client_id;
			if (mainData.isOnIos)
				data.device_type_id = 2;
			else
				data.device_type_id = 1;
			if (mainData.isOnAndroid)
				data.DeviceId = 4;
			else
				data.DeviceId = 5;
			data.GameVersion = mainData.version;
			zLoginWindow(content).loadingLayer.visible = true;
			if (mainData.isTest)
				mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayUserExt.asmx/Device_GetUserInfo", data, onLoginFacebookRespond, true);
			else
				mainRequest.sendRequest_Post("http://wss.azgame.us/Service02/OnplayUserExt.asmx/Device_GetUserInfo", data, onLoginFacebookRespond, true);
		}
		
		private function onFillNameFinish(e:Event):void 
		{
			var deviceId:String = '1';
			
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
				WindowLayer.getInstance().openAlertWindow("Đăng nhập thất bại");
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
			
			if (value.Data.UserStatus) 
			{
				if (value.Data.UserStatus == 2) 
				{
					zLoginWindow(content).loadingLayer.visible = false;
					WindowLayer.getInstance().openAlertWindow(value.UserMessage);
				}
				else if (value.Data.UserStatus == 3 || value.Data.UserStatus == 4) 
				{
					zLoginWindow(content).loadingLayer.visible = false;
					WindowLayer.getInstance().openAlertWindow(value.UserMessage);
					CallJs.getInstance().hideLoading();
					return;
				}
				
			}
			
			zLoginWindow(content).loadingLayer.visible = false;
			
			excuteUserInfo(value);
			
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			mainData.removeEventListener(MainData.UPDATE_FACEBOOK_DATA, onUpdateFacebookData);
			mainData.removeEventListener(MainData.LOGIN_FACEBOOK_FAIL, onLoginFacebookFail);
			mainData.removeEventListener(MainData.CLOSE_RECONNECT_WINDOW, onCloseReconnectWindow);
			mainData.chooseChannelData.removeEventListener(ChooseChannelData.UPDATE_MY_INFO, onUpdateMyInfo);
			mainData.isOnLoginWindow = false;
		}
		
		private function onCloseReconnectWindow(e:Event):void 
		{
			if (mainData.isReconnectPhom)
			{
				if (mainData.loginType == '1')
				{
					loginMobile();
					mainData.isFirstLogin = false;
				}
				else if (mainData.loginType == '2')
				{
					loginFacebook();
					mainData.isFirstLogin = false;
				}
				else if (mainData.loginType == '3')
				{
					loginEmail();
					mainData.isFirstLogin = false;
				}
			}
		}
		
		private function onAddedToStage(e:Event):void 
		{
			SoundManager.getInstance().stopBackgroundMusicMauBinh();
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			//test virtual keyboard
			VirtualKeyBoard.getInstance().init(this);
			//zLoginWindow(content).userName.textField.addEventListener(MouseEvent.CLICK, onShowVirtualKeyBoard);
			//zLoginWindow(content).pass.textField.addEventListener(MouseEvent.CLICK, onShowVirtualKeyBoard);
			var mainRequest:MainRequest;
			var data:Object;
			////
			mainData.addEventListener(MainData.CLOSE_RECONNECT_WINDOW, onCloseReconnectWindow);
			mainData.addEventListener(MainData.LOGIN_FACEBOOK_FAIL, onLoginFacebookFail);
			mainData.chooseChannelData.addEventListener(ChooseChannelData.UPDATE_MY_INFO, onUpdateMyInfo);
			mainData.isOnLoginWindow = true;
			
			if (mainData.isWebVersion)
			{
				if (mainData.isLoginFacebook)
				{
					close(BaseWindow.MIDDLE_EFFECT);
					return;
				}
				mainData.isLoginFacebook = true;
				mainRequest = new MainRequest();
				data = new Object();
				if (!mainData.facebook_access_token)
					mainData.facebook_access_token = 'b1085578f1d7741dbd239278f799b32cPDZu0UMzc2fDgkZyranTJzejwUyx1GCQUYd6YrsCyeL50fLIcL';
					
				data.access_token = mainData.facebook_access_token;
				zLoginWindow(content).loadingLayer.visible = true;
				if (mainData.isTest)
					mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayUserExt.asmx/Sanhbai_GetUserInfo", data, onLoginFacebookRespond, true);
				else
					mainRequest.sendRequest_Post("http://wss.azgame.us/Service02/OnplayUserExt.asmx/Sanhbai_GetUserInfo", data, onLoginFacebookRespond, true);
					
				
			}
			else if (mainData.isFacebookVersion)
			{
				if (mainData.isLoginFacebook)
				{
					close(BaseWindow.MIDDLE_EFFECT);
					return;
				}
				mainData.isLoginFacebook = true;
				mainRequest = new MainRequest();
				data = new Object();
				if (!mainData.facebook_access_token)
					mainData.facebook_access_token = 'ea3f4715f7d0b87ef46318f56cfa75f3yMkpXlsNon83Q8oRrcH63HSdvilvKGBe79h38cay0Gy5yS4gjQ';
				data.access_token = mainData.facebook_access_token;
				zLoginWindow(content).loadingLayer.visible = true;
				if (mainData.isTest)
					mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayUserExt.asmx/Facebook_GetUserInfo", data, onLoginFacebookRespond, true);
				else
					mainRequest.sendRequest_Post("http://wss.azgame.us/Service02/OnplayUserExt.asmx/Facebook_GetUserInfo", data, onLoginFacebookRespond, true);
					
				/*var mainRequest:MainRequest = new MainRequest();
				var data:Object = new Object();
				data.user_name = 'dung2906@gmail.com';
				data.password = 'liverpool';
				data.client_id = mainData.client_id;
				data.GameVersion = mainData.version;
				if (mainData.isOnAndroid)
					data.DeviceId = 4;
				else
					data.DeviceId = 5;
				if (mainData.isTest)
					mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileLogin", data, onLoginValidateRespond, true);
				else
					mainRequest.sendRequest_Post("http://wss.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileLogin", data, onLoginValidateRespond, true);*/
			}
			
			/*loader = new BulkLoader("main-site");
			var sound:Sound = loader.getSound("soundtrack");
			trace(sound);
			if (loader.getSound("soundtrack"))
			{
				trace("aaaaaaaaaaaaa");
			}
			else
			{
				// dispatched when ALL the items have been loaded:
				loader.addEventListener(BulkLoader.COMPLETE, onAllItemsLoaded);
				loader.add("123.mp3", { "id":"soundtrack", maxTries:1, priority:100 } );
				//loader.start();
			}*/
			
			//if (mainData.isOnIos)
				//mainData.storeKitExample.purchaseProduct("SB1");
		}
		
		private function onAllItemsLoaded(e:Event):void 
		{
			trace("ccccccccccc");
			var sound:Sound = loader.getSound("soundtrack");
			trace(sound);
		}
		
		private function onUpdateLoadSound(e:Event):void 
		{
			zLoginWindow(content).loadingSoundLayer["percentTxt"].text = String(int((mainData.loadSoundPercent / 556) * 100)) + "%";
			if (mainData.loadSoundPercent == 556)
				zLoginWindow(content).loadingSoundLayer.visible = false;
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
			mainData.removeEventListener(MainData.UPDATE_FACEBOOK_DATA, onUpdateFacebookData);
			if (timerToCloseLoadingLayer)
			{
				timerToCloseLoadingLayer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCloseLoadingLayer);
				timerToCloseLoadingLayer.stop();
			}
			var mainRequest:MainRequest = new MainRequest();
			var data:Object = new Object();
			data.access_token = mainData.facebookData.accessToken;
			data.GameVersion = mainData.version;
			if (mainData.isOnAndroid)
				data.DeviceId = 4;
			else
				data.DeviceId = 5;
			zLoginWindow(content).loadingLayer.visible = true;
			if (mainData.isTest)
				mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayUserExt.asmx/Facebook_GetUserInfo", data, onLoginFacebookRespond, true);
			else
				mainRequest.sendRequest_Post("http://wss.azgame.us/Service02/OnplayUserExt.asmx/Facebook_GetUserInfo", data, onLoginFacebookRespond, true);
		}
		
		private function onLoginFacebookRespond(value:Object):void 
		{
			//if (!mainData.isFacebookVersion)
				//WindowLayer.getInstance().openAlertWindow("onLoginFacebookRespond");
			
			if (value["status"] == "IO_ERROR")
			{
				
				WindowLayer.getInstance().closeAllWindow();
				/////////////////////////////////////
				zLoginWindow(content).loadingLayer.visible = false;
				
				WindowLayer.getInstance().openAlertWindow("Đăng nhập thất bại");
				return;
			}
			if (value.TypeMsg == 2)
			{
				zLoginWindow(content).loadingLayer.visible = false;
				if (sharedObject.data.loginType == '1')
					var registerFacebookWindow:RegisterFacebookWindow = new RegisterFacebookWindow(false);
				else
					registerFacebookWindow = new RegisterFacebookWindow();
				registerFacebookWindow.email = value.Data.email;
				WindowLayer.getInstance().openWindow(registerFacebookWindow);
				return;
			}
			if (value.TypeMsg < 1)
			{
				WindowLayer.getInstance().closeAllWindow();
				zLoginWindow(content).loadingLayer.visible = false;
				if (int(value.TypeMsg) == -10)
				{
					var alertWindow:AlertWindow = new AlertWindow();
					alertWindow.setNotice(value.Msg);
					alertWindow.url = value.Data.AppsStoreUrl;
					alertWindow.showUpdateButton();
					WindowLayer.getInstance().openWindow(alertWindow);
				}
				else
				{
					alertWindow = new AlertWindow();
					alertWindow.setNotice(value.Msg);
					alertWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onCloseAlertWindow);
					WindowLayer.getInstance().openWindow(alertWindow);
				}
				return;
			}
			if (value.TypeMsg == 1)
			{
				WindowLayer.getInstance().closeAllWindow();
				mainData.loginData = value;
				zLoginWindow(content).loadingLayer.visible = false;
				if (value.Data.UserStatus) 
				{
					if (value.Data.UserStatus == 2) 
					{
						zLoginWindow(content).loadingLayer.visible = false;
						WindowLayer.getInstance().openAlertWindow(value.UserMessage);
					}
					else if (value.Data.UserStatus == 3 || value.Data.UserStatus == 4) 
					{
						zLoginWindow(content).loadingLayer.visible = false;
						WindowLayer.getInstance().openAlertWindow(value.UserMessage);
						CallJs.getInstance().hideLoading();
						return;
					}
					
				}
				excuteUserInfo(value);
				close(BaseWindow.MIDDLE_EFFECT);
				
				return;
			}
		}
		
		private function onCloseAlertWindow(e:Event):void 
		{
			if (mainData.isWebVersion) 
			{
				//reload lai web
			}
			
			if (mainData.isFacebookVersion) 
			{
				close();
			}
			
			
		}
		
		private function onForgetPassClick(e:MouseEvent):void 
		{
			var forgetPassWindow:ForgetPassWindow = new ForgetPassWindow();
			WindowLayer.getInstance().openWindow(forgetPassWindow, null, NO_EFFECT, true);
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
			WindowLayer.getInstance().openWindow(registerWindow, null, NO_EFFECT, true);
		}
		
		private function onLoginButtonClick(e:MouseEvent):void 
		{
			loginEmail();
		}
		
		private function loginEmail():void 
		{
			sharedObject.setProperty("loginType", '3');	
			var mainRequest:MainRequest = new MainRequest();
			var data:Object = new Object();
			data.user_name = zLoginWindow(content).userName.text;
			data.password = zLoginWindow(content).pass.text;
			data.client_id = mainData.client_id;
			data.GameVersion = mainData.version;
			if (mainData.isOnAndroid)
				data.DeviceId = 4;
			else
				data.DeviceId = 5;
			zLoginWindow(content).loadingLayer.visible = true;
			if (mainData.isTest)
				mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileLogin", data, onLoginValidateRespond, true);
			else
				mainRequest.sendRequest_Post("http://wss.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileLogin", data, onLoginValidateRespond, true);
			
			if (zLoginWindow(content).savePassword["check"].visible)
			{
				sharedObject.setProperty("userName", zLoginWindow(content).userName.text);
				sharedObject.setProperty("password", zLoginWindow(content).pass.text);
			}
		}
		
		private function onLoginValidateRespond(value:Object):void 
		{
			trace("aaaaaaaaa onLoginValidateRespond");
			if (value["status"] == "IO_ERROR")
			{
				zLoginWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow("Đăng nhập thất bại");
				return;
			}
			if (value.TypeMsg < 1)
			{
				zLoginWindow(content).loadingLayer.visible = false;
				if (int(value.TypeMsg) == -10)
				{
					var alertWindow:AlertWindow = new AlertWindow();
					alertWindow.setNotice(value.Msg);
					alertWindow.url = value.Data.AppsStoreUrl;
					alertWindow.showUpdateButton();
					WindowLayer.getInstance().openWindow(alertWindow);
				}
				else
				{
					WindowLayer.getInstance().openAlertWindow(value.Msg);
				}
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
				mainRequest.sendRequest_Post("http://wss.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileGetUserInfo", data, onLoginRespond, true);
		}
		
		private function onLoginRespond(value:Object):void 
		{
			
			trace("onLoginRespond",(new Date().getTime()));
			if (value["status"] == "IO_ERROR")
			{
				zLoginWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow("Đăng nhập thất bại");
				return;
			}
			if (value.TypeMsg < 1)
			{
				zLoginWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow(value.Msg);
				return;
			}
			
			if (value.Data.UserStatus) 
			{
				if (value.Data.UserStatus == 2) 
				{
					zLoginWindow(content).loadingLayer.visible = false;
					WindowLayer.getInstance().openAlertWindow(value.UserMessage);
				}
				else if (value.Data.UserStatus == 3 || value.Data.UserStatus == 4) 
				{
					zLoginWindow(content).loadingLayer.visible = false;
					WindowLayer.getInstance().openAlertWindow(value.UserMessage);
					CallJs.getInstance().hideLoading();
					return;
				}
				
			}
			
			mainData.loginData = value.Data;
			
			if (zLoginWindow(content)) 
			{
				zLoginWindow(content).loadingLayer.visible = false;
			}
			
			
			excuteUserInfo(value);
			
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function excuteUserInfo(value:Object):void
		{
			mainData.isFirstLogin = false;
			var myInfo:MyInfo = new MyInfo();
			
			mainData.minMoney = value.Data["MinMoneyToFreeGold"];
			mainData.chl_Allow = value.Data.Chl_Allow;
			mainData.chl_Auto_Allow = value.Data.Chl_Auto_Allow;
			myInfo.avatar = value.Data["Avatar"];
			myInfo.money = value.Data["Money"];
			myInfo.cash = value.Data["Cash"];
			myInfo.level = value.Data["Level"];
			myInfo.name = value.Data["Displayname"];
			myInfo.hash = '';
			myInfo.token = '';
			mainData.token = value.Data.AccessToken;
			//myInfo.uId = value.Data["UserName"];
			myInfo.uId = value.Data["Id"];
			myInfo.id = value.Data["Id"];
			myInfo.logo = '';
			myInfo.sex = value.Data["GenderCode"];
			myInfo.is_email_active = value.Data["Is_Eml_Active"];
			myInfo.is_phone_number_active = value.Data["Is_Phone_Number_Active"];
			
			MyDataTLMN.getInstance().myId = value.Data["Id"];
			MyDataTLMN.getInstance().myDisplayName = value.Data["Displayname"];
			MyDataTLMN.getInstance().myMoney[0] = value.Data["Money"];
			MyDataTLMN.getInstance().myMoney[1] = value.Data["Cash"];
			MyDataTLMN.getInstance().myAvatar = value.Data["Avatar"];
			if (value.Data["GenderCode"] == "F") 
			{
				MyDataTLMN.getInstance().sex = false;
			}
			else 
			{
				MyDataTLMN.getInstance().sex = true;
			}
			
			mainData.isAtLogin = false;
			mainData.chooseChannelData.myInfo = myInfo;
			
			mainData.isLoginSuccess = true;
			
			if (mainData.isLoadSound)
			{
				if (!SoundManager.getInstance().isLoadSoundChung)
					SoundManager.getInstance().loadSoundChung();
				//if (!SoundManager.getInstance().isLoadSoundTlmn)
					//SoundManager.getInstance().addSound();
				//if (!SoundManager.getInstance().isLoadSoundMauBinh)
					//SoundManager.getInstance().loadSoundMauBinh();
				//if (!SoundManager.getInstance().isLoadSoundPhom)
					//SoundManager.getInstance().loadSoundPhom();
				
			}
		}
	}

}