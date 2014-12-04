package view.window 
{
	import com.gsolo.encryption.MD5;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import model.chooseChannelData.MyInfo;
	import model.MainData;
	import model.MyDataTLMN;
	import request.MainRequest;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	public class RegisterFacebookWindow extends BaseWindow 
	{
		public var userName:String;
		private var mainData:MainData = MainData.getInstance();
		public var email:String;
		
		public function RegisterFacebookWindow() 
		{
			addContent("zRegisterFacebookWindow");
			zRegisterFacebookWindow(content).registerButton.addEventListener(MouseEvent.CLICK, onConfirm);
			zRegisterFacebookWindow(content).helpButton.addEventListener(MouseEvent.CLICK, onHelpButtonClick);
			
			zRegisterFacebookWindow(content).registerButton.addEventListener(MouseEvent.CLICK, onConfirm);
			zRegisterFacebookWindow(content).cancelButton.addEventListener(MouseEvent.CLICK, onCanCel);
			zRegisterFacebookWindow(content).loadingLayer.visible = false;
			
			zRegisterFacebookWindow(content).userName.width = 261;
			zRegisterFacebookWindow(content).userName.height = 33;
			
			var textFormat:TextFormat = new TextFormat("Arial", 20, 0x000000);
			zRegisterFacebookWindow(content).userName.setStyle("textFormat", textFormat);
			
			zRegisterFacebookWindow(content).maleSelectBox.gotoAndStop("selected");
			zRegisterFacebookWindow(content).femaleSelectBox.gotoAndStop(1);
			
			zRegisterFacebookWindow(content).maleSelectBox.addEventListener(MouseEvent.CLICK, onSelectBoxClick);
			zRegisterFacebookWindow(content).femaleSelectBox.addEventListener(MouseEvent.CLICK, onSelectBoxClick);
		}
		
		private function onCanCel(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function onHelpButtonClick(e:MouseEvent):void 
		{
			navigateToURL(new URLRequest("http://sanhbai.com/ho-tro.html"));
		}
		
		private function onSelectBoxClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case zRegisterFacebookWindow(content).maleSelectBox:
					zRegisterFacebookWindow(content).maleSelectBox.gotoAndStop("selected");
					zRegisterFacebookWindow(content).femaleSelectBox.gotoAndStop(1);
				break;
				case zRegisterFacebookWindow(content).femaleSelectBox:
					zRegisterFacebookWindow(content).femaleSelectBox.gotoAndStop("selected");
					zRegisterFacebookWindow(content).maleSelectBox.gotoAndStop(1);
				break;
				default:
			}
		}
		
		private function onConfirm(e:MouseEvent):void 
		{
			var mainRequest:MainRequest = new MainRequest();
			var object:Object = new Object();
			object.client_id = mainData.client_id
			object.client_secret = mainData.client_secret
			object.client_timestamp = (new Date()).getTime();
			object.nick_name = zRegisterFacebookWindow(content).userName.text;
			object.user_name = email;
			object.password = '';
			if (zRegisterFacebookWindow(content).maleSelectBox.currentLabel == "selected")
				object.gender_code = 'M';
			else
				object.gender_code = 'F';
			object.client_hash = MD5.encrypt(object.client_id + object.client_timestamp + object.client_secret + object.user_name + object.nick_name + object.gender_code + object.password);
			zRegisterFacebookWindow(content).loadingLayer.visible = true;
			if (mainData.isTest)
				mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileRegister", object, onRegisterRespond, true);
			else
				mainRequest.sendRequest_Post("http://wss.azgame.vn/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileRegister", object, onRegisterRespond, true);
		}
		
		private function onLoginFacebookRespond(value:Object):void 
		{
			if (value["status"] == "IO_ERROR")
			{
				zLoginWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow("Đăng nhập Facebook thất bại");
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
		
		private function onRegisterRespond(value:Object):void 
		{
			if (value.TypeMsg == '1')
			{
				var mainRequest:MainRequest = new MainRequest();
				var data:Object = new Object();
				data.client_id = mainData.client_id;
				data.code = value.Data.Code;
				data.client_hash = MD5.encrypt(mainData.client_id + mainData.client_secret + value.Data.Code);
				if (mainData.isTest)
					mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileGetUserInfo", data, onLoginRespond, true);
				else
					mainRequest.sendRequest_Post("http://wss.azgame.vn/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileGetUserInfo", data, onLoginRespond, true);
			}
			else if (value.status == "IO_ERROR")
			{
				zRegisterFacebookWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow("Đăng nhập thất bại");
			}
			else
			{
				zRegisterFacebookWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow(value.Msg);
			}
		}
		
		private function onLoginRespond(value:Object):void 
		{
			if (value["status"] == "IO_ERROR")
			{
				zRegisterFacebookWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow("Đăng nhập thất bại");
				return;
			}
			if (value.TypeMsg < 1)
			{
				zRegisterFacebookWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow(value.Msg);
				return;
			}
			
			mainData.loginData = value.Data;
			
			zRegisterFacebookWindow(content).loadingLayer.visible = false;
			
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
		}
	}

}