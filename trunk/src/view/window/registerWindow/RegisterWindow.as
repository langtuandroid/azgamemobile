package view.window.registerWindow 
{
	import com.gsolo.encryption.MD5;
	import fl.controls.TextInput;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import model.chooseChannelData.MyInfo;
	import model.MainData;
	import model.MyDataTLMN;
	import request.MainRequest;
	import view.window.BaseWindow;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class RegisterWindow extends BaseWindow 
	{
		public static const REGISTER_SUCCESS:String = "registerSuccess";
		public var userName:String;
		public var pass:String;
		private var mainData:MainData = MainData.getInstance();
		
		public function RegisterWindow() 
		{
			addContent("zRegisterWindow");
			//zRegisterWindow(content).alertPassword.visible = false;
			
			zRegisterWindow(content).registerButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			zRegisterWindow(content).cancelButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			zRegisterWindow(content).loadingLayer.visible = false;
			
			zRegisterWindow(content).password.width = 261;
			zRegisterWindow(content).password.height = 33;
			
			zRegisterWindow(content).userName.width = 261;
			zRegisterWindow(content).userName.height = 33;
			
			zRegisterWindow(content).email.width = 261;
			zRegisterWindow(content).email.height = 33;
			
			var textFormat:TextFormat = new TextFormat("Arial", 20, 0x000000);
			zRegisterWindow(content).password.setStyle("textFormat", textFormat);
			zRegisterWindow(content).userName.setStyle("textFormat", textFormat);
			zRegisterWindow(content).email.setStyle("textFormat", textFormat);
			zRegisterWindow(content).password.displayAsPassword = false;
			
			zRegisterWindow(content).showPassword.addEventListener(MouseEvent.CLICK, onShowPasswordClick);
			zRegisterWindow(content).showPassword.check.visible = true;
			zRegisterWindow(content).showPassword.visible = false;
			
			zRegisterWindow(content).maleSelectBox.gotoAndStop("selected");
			zRegisterWindow(content).femaleSelectBox.gotoAndStop(1);
			
			zRegisterWindow(content).maleSelectBox.addEventListener(MouseEvent.CLICK, onSelectBoxClick);
			zRegisterWindow(content).femaleSelectBox.addEventListener(MouseEvent.CLICK, onSelectBoxClick);
			
			zRegisterWindow(content).alertTxt.visible = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onSelectBoxClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case zRegisterWindow(content).maleSelectBox:
					zRegisterWindow(content).maleSelectBox.gotoAndStop("selected");
					zRegisterWindow(content).femaleSelectBox.gotoAndStop(1);
				break;
				case zRegisterWindow(content).femaleSelectBox:
					zRegisterWindow(content).femaleSelectBox.gotoAndStop("selected");
					zRegisterWindow(content).maleSelectBox.gotoAndStop(1);
				break;
				default:
			}
		}
		
		private function onSoftKeyboardActive(e:SoftKeyboardEvent):void 
		{
			return;
			if (stage.softKeyboardRect.height != 0)
			{
				var currentInputText:TextInput;
				switch (stage.focus) 
				{
					case zRegisterWindow(content).userName.textField:
						currentInputText = zRegisterWindow(content).userName;
					break;
					case zRegisterWindow(content).password.textField:
						currentInputText = zRegisterWindow(content).password;
					break;
					case zRegisterWindow(content).email.textField:
						currentInputText = zRegisterWindow(content).email;
					break;
					default:
				}
				var point:Point = new Point(0, currentInputText.y);
				point = localToGlobal(point);
				var scaleNumber:Number = stage.stageHeight / Capabilities.screenResolutionY;
				if (point.y + currentInputText.height > stage.stageHeight - stage.softKeyboardRect.top * scaleNumber)
				{
					var addDistance:Number = point.y + currentInputText.height - (stage.stageHeight - stage.softKeyboardRect.top * scaleNumber);
					y = stage.stageHeight / 2 - addDistance;
				}
			}
		}
		
		private function onSoftKeyboardDeactive(e:SoftKeyboardEvent):void 
		{
			y = stage.stageHeight / 2;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			if (mainData.isOnAndroid)
			{
				addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, onSoftKeyboardActive ); 
				addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onSoftKeyboardDeactive );
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onAndroidKeyDown, false, 0, true);
			}
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			if (mainData.isOnAndroid)
			{
				removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, onSoftKeyboardActive ); 
				removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onSoftKeyboardDeactive );
				NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onAndroidKeyDown, false);
			}
		}
		
		private function onAndroidKeyDown(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case 16777238:
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
				close(BaseWindow.MIDDLE_EFFECT);
				break;
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				if (stage.focus == zRegisterWindow(content).userName.textField)
					stage.focus = zRegisterWindow(content).password;
				else if (stage.focus == zRegisterWindow(content).password.textField)
					stage.focus = zRegisterWindow(content).email;
			}
		}
		
		private function onShowPasswordClick(e:MouseEvent):void 
		{
			zRegisterWindow(content).showPassword.check.visible = !zRegisterWindow(content).showPassword.check.visible;
			zRegisterWindow(content).password.displayAsPassword = !zRegisterWindow(content).showPassword.check.visible;
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case zRegisterWindow(content).registerButton:
					var mainRequest:MainRequest = new MainRequest();
					var object:Object = new Object();
					object.client_id = mainData.client_id
					object.client_secret = mainData.client_secret
					object.client_timestamp = (new Date()).getTime();
					object.nick_name = zRegisterWindow(content).userName.text;
					object.user_name = zRegisterWindow(content).email.text;
					object.password = zRegisterWindow(content).password.text;
					if (zRegisterWindow(content).maleSelectBox.currentLabel == "selected")
						object.gender_code = 'M';
					else
						object.gender_code = 'F';
					object.client_hash = MD5.encrypt(object.client_id + object.client_timestamp + object.client_secret + object.user_name + object.nick_name + object.gender_code + object.password);
					zRegisterWindow(content).loadingLayer.visible = true;
					if (mainData.isTest)
						mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileRegister", object, onRegisterRespond, true);
					else
						mainRequest.sendRequest_Post("http://wss.azgame.vn/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileRegister", object, onRegisterRespond, true);
				break;
				case zRegisterWindow(content).cancelButton:
					close(BaseWindow.MIDDLE_EFFECT);
				break;
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
				zRegisterWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow("Đăng nhập thất bại, link truy cập bị lỗi !!");
			}
			else
			{
				zRegisterWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow(value.Msg);
			}
		}
		
		private var sharedObject:SharedObject;
		
		private function onLoginRespond(value:Object):void 
		{
			if (value["status"] == "IO_ERROR")
			{
				zRegisterWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow("Đăng nhập thất bại, link truy cập bị lỗi !!");
				return;
			}
			if (value.TypeMsg < 1)
			{
				zRegisterWindow(content).loadingLayer.visible = false;
				WindowLayer.getInstance().openAlertWindow(value.Msg);
				return;
			}
			
			sharedObject = SharedObject.getLocal("userInfo");
			sharedObject.setProperty("userName", zRegisterWindow(content).email.text);
			sharedObject.setProperty("password", zRegisterWindow(content).password.text);
			
			mainData.loginData = value.Data;
			
			zRegisterWindow(content).loadingLayer.visible = false;
			
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