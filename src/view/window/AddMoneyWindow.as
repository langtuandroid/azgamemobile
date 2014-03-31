package view.window 
{
	import com.ComponentTLMNSocial.ComboBoxClass.MyComboBox;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.SoftKeyboardEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import com.isvn.extension.sms.MSGExtension;
	import com.ssd.ane.AndroidExtensions;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import model.MainData;
	import request.MainRequest;
	import view.button.MobileButton;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	public class AddMoneyWindow extends BaseWindow 
	{
		private var cardTypeComboBox:MyComboBox;
		private var addButton:MobileButton;
		private var mainData:MainData = MainData.getInstance();
		
		private var sendButton1:MobileButton;
		private var sendButton2:MobileButton;
		private var sendButton3:MobileButton;
		
		private var sms1:TextField;
		private var sms2:TextField;
		private var sms3:TextField;
		
		private var description1:TextField;
		private var description2:TextField;
		private var description3:TextField;
		
		private var viettelIcon:Sprite;
		private var vinaphoneIcon:Sprite;
		private var mobilephoneIcon:Sprite;
		private var fptIcon:Sprite;
		private var megacardIcon:Sprite;
		private var currentSelectedCardType:Sprite;
		
		public function AddMoneyWindow() 
		{
			addContent("zAddMoneyWindow");
			
			zAddMoneyWindow(content).loadingLayer.visible = false;
			zAddMoneyWindow(content).mobileCardTabDisable.visible = false;
			zAddMoneyWindow(content).smsForm.visible = false;
			zAddMoneyWindow(content).mobileCardTabDisable.addEventListener(MouseEvent.CLICK, onMobileCardTabDisableClick);
			zAddMoneyWindow(content).mobileCardForm["closeButton"].addEventListener(MouseEvent.CLICK, onCloseWindow);
			zAddMoneyWindow(content).smsForm["closeButton"].addEventListener(MouseEvent.CLICK, onCloseWindow);
			
			viettelIcon = zAddMoneyWindow(content).mobileCardForm["viettelIcon"];
			vinaphoneIcon = zAddMoneyWindow(content).mobileCardForm["vinaphoneIcon"];
			mobilephoneIcon = zAddMoneyWindow(content).mobileCardForm["mobilephoneIcon"];
			fptIcon = zAddMoneyWindow(content).mobileCardForm["fptIcon"];
			megacardIcon = zAddMoneyWindow(content).mobileCardForm["megacardIcon"];
			
			viettelIcon.addEventListener(MouseEvent.CLICK, onCardTypeClick);
			vinaphoneIcon.addEventListener(MouseEvent.CLICK, onCardTypeClick);
			mobilephoneIcon.addEventListener(MouseEvent.CLICK, onCardTypeClick);
			fptIcon.addEventListener(MouseEvent.CLICK, onCardTypeClick);
			megacardIcon.addEventListener(MouseEvent.CLICK, onCardTypeClick);
			
			var filterTemp:GlowFilter = new GlowFilter(0xFF0033, 1, 8, 8, 10, 1);
			viettelIcon.filters = [filterTemp];
			
			currentSelectedCardType = viettelIcon;
			
			zAddMoneyWindow(content).smsTabEnable.visible = false;
			zAddMoneyWindow(content).smsTabDisable.addEventListener(MouseEvent.CLICK, onSmsTabDisableClick);
			
			addButton = zAddMoneyWindow(content).mobileCardForm["addButton"];
			addButton.addEventListener(MouseEvent.CLICK, onAddButtonClick);
			
			cardTypeComboBox = new MyComboBox();
			cardTypeComboBox.visible = false;
			var cardTypeArray:Array = new Array();
			cardTypeArray.push("MobiFone");
			cardTypeArray.push("VTC Vcoin");
			cardTypeArray.push("FPT Gate");
			cardTypeArray.push("Viettel");
			cardTypeArray.push("Megacard");
			cardTypeArray.push("Oncash");
			cardTypeComboBox.init(cardTypeArray, 270, false);
			cardTypeComboBox.scaleX = cardTypeComboBox.scaleY = 1.5;
			cardTypeComboBox.x = 132;
			cardTypeComboBox.y = 2;
			zAddMoneyWindow(content).mobileCardForm.addChild(cardTypeComboBox);
			
			sendButton1 = zAddMoneyWindow(content).smsForm["smsSentence1"]["sendButton"];
			sendButton2 = zAddMoneyWindow(content).smsForm["smsSentence2"]["sendButton"];
			
			sendButton1.addEventListener(MouseEvent.CLICK, onSendSms);
			sendButton2.addEventListener(MouseEvent.CLICK, onSendSms);
			
			sms1 = zAddMoneyWindow(content).smsForm["smsSentence1"]["sms"];
			sms2 = zAddMoneyWindow(content).smsForm["smsSentence2"]["sms"];
			
			zAddMoneyWindow(content).smsForm["smsSentence2"].visible = false;
			
			description1 = zAddMoneyWindow(content).smsForm["smsSentence1"]["description"];
			description2 = zAddMoneyWindow(content).smsForm["smsSentence2"]["description"];
			
			sms1.htmlText = "Soạn <b>" + mainData.sendSmsSentence + mainData.chooseChannelData.myInfo.uId + "</b>" + " gửi " + "<b>" + mainData.phone1 + "</b>";
			sms2.htmlText = "Soạn <b>" + mainData.sendSmsSentence + mainData.chooseChannelData.myInfo.uId + "</b>" + " gửi " + "<b>" + mainData.phone2 + "</b>";
			
			description1.text = mainData.description1;
			description2.text = mainData.description2;
			
			zAddMoneyWindow(content).smsTabEnable.visible = true;
			zAddMoneyWindow(content).smsTabDisable.visible = false;
			zAddMoneyWindow(content).mobileCardTabDisable.visible = true;
			zAddMoneyWindow(content).mobileCardTabEnable.visible = false;
			zAddMoneyWindow(content).smsForm.visible = true;
			zAddMoneyWindow(content).mobileCardForm.visible = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			mainData.isNoRenderLobbyList = true;
			if (mainData.isOnAndroid)
			{
				addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, onSoftKeyboardActive ); 
				addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onSoftKeyboardDeactive );
			}
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			mainData.isNoRenderLobbyList = false;
			if (mainData.isOnAndroid)
			{
				removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, onSoftKeyboardActive ); 
				removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onSoftKeyboardDeactive );
			}
		}
		
		private function onSoftKeyboardActive(e:SoftKeyboardEvent):void 
		{
			if (stage.softKeyboardRect.height != 0)
			{
				var currentInputText:TextField;
				switch (stage.focus) 
				{
					case zAddMoneyWindow(content).mobileCardForm["numcard"]:
						currentInputText = zAddMoneyWindow(content).mobileCardForm["numcard"];
					break;
					case zAddMoneyWindow(content).mobileCardForm["numserial"]:
						currentInputText = zAddMoneyWindow(content).mobileCardForm["numserial"];
					break;
					default:
				}
				var point:Point = new Point(0, currentInputText.y);
				point = currentInputText.parent.localToGlobal(point);
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
		
		private function onCardTypeClick(e:MouseEvent):void 
		{
			currentSelectedCardType.filters = null;
			
			var filterTemp:GlowFilter = new GlowFilter(0xFF0033, 1, 8, 8, 10, 1);
			Sprite(e.currentTarget).filters = [filterTemp]
			
			currentSelectedCardType = e.currentTarget as Sprite;
		}
		
		private function onSendSms(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case sendButton1:
					if (mainData.isOnAndroid)
					{
						AndroidExtensions.sendSMS(mainData.sendSmsSentence + mainData.chooseChannelData.myInfo.uId, mainData.phone1);
					}
					else if(mainData.isOnIos)
					{
						var msgExtension:MSGExtension = new MSGExtension();
						msgExtension.sendSMS(mainData.phone1, mainData.sendSmsSentence + mainData.chooseChannelData.myInfo.uId);
					}
				break;
				case sendButton2:
					if (mainData.isOnAndroid)
					{
						AndroidExtensions.sendSMS(mainData.sendSmsSentence + mainData.chooseChannelData.myInfo.uId, mainData.phone2);
					}
					else if(mainData.isOnIos)
					{
						msgExtension = new MSGExtension();
						msgExtension.sendSMS(mainData.phone2, mainData.sendSmsSentence + mainData.chooseChannelData.myInfo.uId);
					}
				break;
				default:
			}
		}
		
		private function onAddButtonClick(e:MouseEvent):void 
		{
			zAddMoneyWindow(content).loadingLayer.visible = true;
			var mainRequest:MainRequest = new MainRequest();
			var data:Object = new Object();
			data.userId = mainData.chooseChannelData.myInfo.uId;
			data.cardCode = zAddMoneyWindow(content).mobileCardForm["numcard"].text;
			data.cardSeri = zAddMoneyWindow(content).mobileCardForm["numserial"].text;
			switch (currentSelectedCardType) 
			{
				case vinaphoneIcon:
					data.cardType = "VNP";
				break;
				case mobilephoneIcon:
					data.cardType = "VMS";
				break;
				case fptIcon:
					data.cardType = "FPT";
				break;
				case viettelIcon:
					data.cardType = "VTT";
				break;
				case megacardIcon:
					data.cardType = "MGC";
				break;
				default:
			}
			mainRequest.sendRequest_Post("http://" + mainData.gameIp + "/payment/topup_process", data, onAddMoneyRespond, true);
		}
		
		private function onAddMoneyRespond(value:Object):void 
		{
			zAddMoneyWindow(content).loadingLayer.visible = false;
			switch (value["status"]) 
			{
				case 1:
					WindowLayer.getInstance().openAlertWindow("Bạn đã nạp thẻ thành công !!");
				break;
				default:
					WindowLayer.getInstance().openAlertWindow(value["msg"]);
			}
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function onSmsTabDisableClick(e:MouseEvent):void 
		{
			zAddMoneyWindow(content).smsTabEnable.visible = true;
			zAddMoneyWindow(content).smsTabDisable.visible = false;
			zAddMoneyWindow(content).mobileCardTabDisable.visible = true;
			zAddMoneyWindow(content).mobileCardTabEnable.visible = false;
			zAddMoneyWindow(content).smsForm.visible = true;
			zAddMoneyWindow(content).mobileCardForm.visible = false;
		}
		
		private function onMobileCardTabDisableClick(e:MouseEvent):void 
		{
			zAddMoneyWindow(content).mobileCardTabDisable.visible = false;
			zAddMoneyWindow(content).mobileCardTabEnable.visible = true;
			zAddMoneyWindow(content).smsTabEnable.visible = false;
			zAddMoneyWindow(content).smsTabDisable.visible = true;
			zAddMoneyWindow(content).smsForm.visible = false;
			zAddMoneyWindow(content).mobileCardForm.visible = true;
		}
		
	}

}