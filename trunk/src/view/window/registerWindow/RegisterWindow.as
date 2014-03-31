package view.window.registerWindow 
{
	import fl.controls.TextInput;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import model.MainData;
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
			
			zRegisterWindow(content).password.width = 233;
			zRegisterWindow(content).password.height = 23;
			
			zRegisterWindow(content).userName.width = 233;
			zRegisterWindow(content).userName.height = 23;
			
			zRegisterWindow(content).email.width = 233;
			zRegisterWindow(content).email.height = 23;
			
			var textFormat:TextFormat = new TextFormat("Arial", 18, 0x000000);
			zRegisterWindow(content).password.setStyle("textFormat", textFormat);
			zRegisterWindow(content).userName.setStyle("textFormat", textFormat);
			zRegisterWindow(content).email.setStyle("textFormat", textFormat);
			
			zRegisterWindow(content).showPassword.addEventListener(MouseEvent.CLICK, onShowPasswordClick);
			zRegisterWindow(content).showPassword.check.visible = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onSoftKeyboardActive(e:SoftKeyboardEvent):void 
		{
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
					userName = zRegisterWindow(content).userName.text;
					pass = zRegisterWindow(content).password.text;
					zRegisterWindow(content).alertPassword.visible = false;
					var mainRequest:MainRequest = new MainRequest();
					var data:Object = new Object();
					data.username = zRegisterWindow(content).userName.text;
					data.password = zRegisterWindow(content).password.text;
					data.email = zRegisterWindow(content).email.text;
					zRegisterWindow(content).loadingLayer.visible = true;
					mainRequest.sendRequest_Post("http://" + MainData.getInstance().gameIp + "/user/register_mobile", data, onRegisterRespond, true);
				break;
				case zRegisterWindow(content).cancelButton:
					close(BaseWindow.MIDDLE_EFFECT);
				break;
			}
		}
		
		private function onRegisterRespond(value:Object):void 
		{
			zRegisterWindow(content).loadingLayer.visible = false;
			if (value["status"] == "IO_ERROR")
			{
				WindowLayer.getInstance().openAlertWindow("Quá trình gửi đến server bị lỗi, bạn vui lòng thử lại !!");
				return;
			}
			if (value["error"] == 0)
			{
				//WindowLayer.getInstance().openAlertWindow("Chúc mừng bạn đã đăng ký thành công.");
				dispatchEvent(new Event(REGISTER_SUCCESS));
				close(BaseWindow.MIDDLE_EFFECT);
			}
			else
			{
				switch (value["error"]) 
				{
					case '1':
						stage.focus = zRegisterWindow(content).email.textField;
					break;
					case '2':
						stage.focus = zRegisterWindow(content).password.textField;
					break;
					case '3':
						stage.focus = zRegisterWindow(content).userName.textField;
					break;
					case '4':
						stage.focus = zRegisterWindow(content).userName.textField;
					break;
					case '5':
						stage.focus = zRegisterWindow(content).email.textField;
					break;
					default:
				}
			}
			WindowLayer.getInstance().openAlertWindow(value["message"]);
		}
		
	}

}