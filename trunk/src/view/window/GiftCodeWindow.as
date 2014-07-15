package view.window 
{
	import com.gsolo.encryption.MD5;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import model.MainData;
	import request.MainRequest;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	public class GiftCodeWindow extends BaseWindow 
	{
		public static const INPUT_CODE_FORM:String = "inputCodeForm";
		public static const GIVE_CODE_FORM:String = "giveCodeForm";
		public static const SUCCESS_FORM:String = "successForm";
		public static const FAIL_FORM:String = "failForm";
		
		private var inputTxt:TextField;
		private var alertTxt:TextField;
		private var giftCodeTxt:TextField;
		private var cancelButton:SimpleButton;
		private var confirmButton:SimpleButton;
		private var closeButton:SimpleButton;
		private var inputCodeButton:SimpleButton;
		private var giveCodeButton:SimpleButton;
		
		public function GiftCodeWindow() 
		{
			addContent("zGiftCodeWindow");
			zGiftCodeWindow(content).loadingLayer.visible = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
		}
		
		private function onMouseUpStage(e:MouseEvent):void 
		{
			if (type != GIVE_CODE_FORM)
				return;
			if (stage.focus != inputTxt)
			{
				if (inputTxt.text == '')
					inputTxt.text = "Nhập email để tặng Code";
			}
			else
			{
				if (inputTxt.text == "Nhập email để tặng Code")
					inputTxt.text = '';
			}
		}
		
		private var _type:String;
		private var mainData:MainData = MainData.getInstance();
		private var giveCodeNumberTxt:TextField;
		
		public function set type(value:String):void 
		{
			_type = value;
			MovieClip(content).gotoAndStop(_type);
			
			switch (_type) 
			{
				case INPUT_CODE_FORM:
					inputTxt = content["inputTxt"];
					giveCodeButton = content["giveCodeButton"];
					cancelButton = content["cancelButton"];
					confirmButton = content["confirmButton"];
					confirmButton.addEventListener(MouseEvent.CLICK, onButtonClick);
					cancelButton.addEventListener(MouseEvent.CLICK, onButtonClick);
					giveCodeButton.addEventListener(MouseEvent.CLICK, onButtonClick);
				break;
				case GIVE_CODE_FORM:
					inputTxt = content["inputTxt"];
					inputCodeButton = content["inputCodeButton"];
					cancelButton = content["cancelButton"];
					confirmButton = content["confirmButton"];
					giveCodeNumberTxt = content["giveCodeNumberTxt"];
					confirmButton.addEventListener(MouseEvent.CLICK, onButtonClick);
					cancelButton.addEventListener(MouseEvent.CLICK, onButtonClick);
					inputCodeButton.addEventListener(MouseEvent.CLICK, onButtonClick);
					inputTxt.text = "Nhập email để tặng Code";
					giveCodeNumberTxt.text = '';
					
					var tokenTime:Number = mainData.chooseChannelData.myInfo.tokenTime;
					var mainRequest:MainRequest;
					if (tokenTime == 0)
					{
						mainRequest = new MainRequest();
						var url:String = mainData.init.requestLink.getAccessTokenLink.@url;
						var object:Object = new Object();
						object.client_id = mainData.client_id
						object.client_secret = mainData.client_secret
						object.client_timestamp = (new Date()).getTime();
						object.nick_name = mainData.chooseChannelData.myInfo.name;
						object.client_hash = MD5.encrypt(object.client_id + object.client_timestamp + object.client_secret + object.nick_name);
						mainRequest.sendRequest_Post(url, object, getAccessTokenToGetGiveCodeNumberFn, true);
					}
					else
					{
						mainRequest = new MainRequest();
						var data:Object = new Object();
						data.type_gift_id = '1';
						data.access_token = mainData.token;
						if (mainData.isTest)
							mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_GetGiftcodeLeftNumber", data, onGetGiveCodeNumberRespond, true);
						else
							mainRequest.sendRequest_Post("http://wss.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_GetGiftcodeLeftNumber", data, onGetGiveCodeNumberRespond, true);
					}
				break;
				case SUCCESS_FORM:
					giftCodeTxt = content["giftCodeTxt"];
					closeButton = content["closeButton"];
					closeButton.addEventListener(MouseEvent.CLICK, onButtonClick);
				break;
				case FAIL_FORM:
					alertTxt = content["alertTxt"];
					closeButton = content["closeButton"];
					closeButton.addEventListener(MouseEvent.CLICK, onButtonClick);
				break;
				default:
			}
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case closeButton:
					close(BaseWindow.NO_EFFECT);
				break;
				case cancelButton:
					close(BaseWindow.NO_EFFECT);
				break;
				case confirmButton:
					zGiftCodeWindow(content).loadingLayer.visible = true;
					var tokenTime:Number = mainData.chooseChannelData.myInfo.tokenTime;
					var mainRequest:MainRequest;
					if (type == INPUT_CODE_FORM)
					{
						if (tokenTime == 0)
						{
							mainRequest = new MainRequest();
							var url:String = mainData.init.requestLink.getAccessTokenLink.@url;
							var object:Object = new Object();
							object.client_id = mainData.client_id
							object.client_secret = mainData.client_secret
							object.client_timestamp = (new Date()).getTime();
							object.nick_name = mainData.chooseChannelData.myInfo.name;
							object.client_hash = MD5.encrypt(object.client_id + object.client_timestamp + object.client_secret + object.nick_name);
							mainRequest.sendRequest_Post(url, object, getAccessTokenToInputCodeFn, true);
						}
						else
						{
							mainRequest = new MainRequest();
							var data:Object = new Object();
							data.giftcode = inputTxt.text;
							data.access_token = mainData.token;
							if (mainData.isTest)
								mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_ActiveGiftcode", data, onInputCodeRespond, true);
							else
								mainRequest.sendRequest_Post("http://wss.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_ActiveGiftcode", data, onInputCodeRespond, true);
						}
						
					}
					else if (type == GIVE_CODE_FORM)
					{
						if (tokenTime == 0)
						{
							mainRequest = new MainRequest();
							url = mainData.init.requestLink.getAccessTokenLink.@url;
							object = new Object();
							object.client_id = mainData.client_id
							object.client_secret = mainData.client_secret
							object.client_timestamp = (new Date()).getTime();
							object.nick_name = mainData.chooseChannelData.myInfo.name;
							object.client_hash = MD5.encrypt(object.client_id + object.client_timestamp + object.client_secret + object.nick_name);
							mainRequest.sendRequest_Post(url, object, getAccessTokenToGiveCodeFn, true);
						}
						else
						{
							mainRequest = new MainRequest();
							data = new Object();
							data.giftcode = inputTxt.text;
							data.access_token = mainData.token;
							if (mainData.isTest)
								mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_SendGiftcode", data, onGiveCodeRespond, true);
							else
								mainRequest.sendRequest_Post("http://wss.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_SendGiftcode", data, onGiveCodeRespond, true);
						}
					}
				break;
				case inputCodeButton:
					type = INPUT_CODE_FORM
				break;
				case giveCodeButton:
					type = GIVE_CODE_FORM
				break;
				default:
			}
		}
		
		private function getAccessTokenToInputCodeFn(value:Object):void 
		{
			if (value.TypeMsg == '1')
			{
				mainData.token = value.Data.access_token;
				mainData.tokenTime = (new Date()).getTime();
				var mainRequest:MainRequest = new MainRequest();
				var data:Object = new Object();
				data.giftcode = inputTxt.text;
				data.access_token = mainData.token;
				if (mainData.isTest)
					mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_ActiveGiftcode", data, onInputCodeRespond, true);
				else
					mainRequest.sendRequest_Post("http://wss.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_ActiveGiftcode", data, onInputCodeRespond, true);
			}
			else if (value.status == "IO_ERROR")
			{
				
			}
		}
		
		private function getAccessTokenToGetGiveCodeNumberFn(value:Object):void 
		{
			if (value.TypeMsg == '1')
			{
				mainData.token = value.Data.access_token;
				mainData.tokenTime = (new Date()).getTime();
				var mainRequest:MainRequest = new MainRequest();
				var data:Object = new Object();
				data.type_gift_id = '1';
				data.access_token = mainData.token;
				if (mainData.isTest)
					mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_GetGiftcodeLeftNumber", data, onGetGiveCodeNumberRespond, true);
				else
					mainRequest.sendRequest_Post("http://wss.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_GetGiftcodeLeftNumber", data, onGetGiveCodeNumberRespond, true);
			}
			else if (value.status == "IO_ERROR")
			{
				
			}
		}
		
		private function onGetGiveCodeNumberRespond(value:Object):void 
		{
			giveCodeNumberTxt.text = value.Data.GiftcodeLeftNumber + " lần";
		}
		
		private function getAccessTokenToGiveCodeFn(value:Object):void 
		{
			if (value.TypeMsg == '1')
			{
				mainData.token = value.Data.access_token;
				mainData.tokenTime = (new Date()).getTime();
				var mainRequest:MainRequest = new MainRequest();
				var data:Object = new Object();
				data.email = inputTxt.text;
				data.access_token = mainData.token;
				if (mainData.isTest)
					mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_SendGiftcode", data, onGiveCodeRespond, true);
				else
					mainRequest.sendRequest_Post("http://wss.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_SendGiftcode", data, onGiveCodeRespond, true);
			}
			else if (value.status == "IO_ERROR")
			{
				
			}
		}
		
		private function onInputCodeRespond(value:Object):void
		{
			zGiftCodeWindow(content).loadingLayer.visible = false;
			if (value["status"] == "IO_ERROR")
			{
				type = FAIL_FORM;
				alertTxt.text = "Link truy cập không tồn tại !!";
				return;
			}
			if (value.TypeMsg == 1)
			{
				type = SUCCESS_FORM;
				giftCodeTxt.text = value.Data.GiftcodeMessage;
				mainData.chooseChannelData.myInfo.money = value.Data.UserGold;
				mainData.chooseChannelData.myInfo = mainData.chooseChannelData.myInfo;
				return;
			}
			type = FAIL_FORM;
			alertTxt.text = value.Msg;
			return;
		}
		
		private function onGiveCodeRespond(value:Object):void
		{
			zGiftCodeWindow(content).loadingLayer.visible = false;
			type = FAIL_FORM;
			if (value["status"] == "IO_ERROR")
			{
				alertTxt.text = "Link truy cập không tồn tại !!";
				return;
			}
			alertTxt.text = value.Msg;
			return;
		}
	}

}