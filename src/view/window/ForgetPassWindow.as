package view.window 
{
	import com.gsolo.encryption.MD5;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.MainData;
	import request.MainRequest;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	public class ForgetPassWindow extends BaseWindow 
	{
		private var mainData:MainData = MainData.getInstance();
		
		public function ForgetPassWindow() 
		{
			addContent("zForgetPassWindow");

			zForgetPassWindow(content).confirmButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			zForgetPassWindow(content).cancelButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			zForgetPassWindow(content).loadingLayer.visible = false;
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case zForgetPassWindow(content).confirmButton:
					var mainRequest:MainRequest = new MainRequest();
					var object:Object = new Object();
					object.client_id = mainData.client_id
					object.client_secret = mainData.client_secret
					object.client_timestamp = (new Date()).getTime();
					object.nick_name = '';
					object.user_name = zForgetPassWindow(content).email.text;
					object.email = zForgetPassWindow(content).email.text;
					object.client_hash = MD5.encrypt(object.client_id + object.client_timestamp + object.client_secret + object.email + object.nick_name);
					zForgetPassWindow(content).loadingLayer.visible = true;
					if (mainData.isTest)
						mainRequest.sendRequest_Post("http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileRecoverPassword", object, onForgetRespond, true);
					else
						mainRequest.sendRequest_Post("http://wss.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileRecoverPassword", object, onForgetRespond, true);
				break;
				case zForgetPassWindow(content).cancelButton:
					close(BaseWindow.MIDDLE_EFFECT);
				break;
			}
		}
		
		private function onForgetRespond(value:Object):void 
		{
			zForgetPassWindow(content).loadingLayer.visible = false;
			
			MovieClip(content).gotoAndStop(2);
			zForgetPassWindow(content).alertTxt.text = value.Msg;
			zForgetPassWindow(content).closeButton.addEventListener(MouseEvent.CLICK, onCloseWindow);
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
	}

}