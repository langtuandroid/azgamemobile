package view.window 
{
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
					var data:Object = new Object();
					data.Email = zForgetPassWindow(content).email.text;
					zForgetPassWindow(content).loadingLayer.visible = true;
					mainRequest.sendRequest_Post("http://" + MainData.getInstance().gameIp + "/user/forgot_mobile", data, onForgetRespond, false);
				break;
				case zForgetPassWindow(content).cancelButton:
					close(BaseWindow.MIDDLE_EFFECT);
				break;
			}
		}
		
		private function onForgetRespond(value:Object):void 
		{
			zForgetPassWindow(content).loadingLayer.visible = false;
			
			switch (value) 
			{
				case "SUCCESS":
					WindowLayer.getInstance().openAlertWindow("Khai báo quên mật khẩu thành công, bạn hãy vào email để nhận lại mật khẩu.");
				break;
				case "NOT_EXIT":
					WindowLayer.getInstance().openAlertWindow("Email này không tồn tại.");
				break;
				case "NOT_ACTIVATE":
					WindowLayer.getInstance().openAlertWindow("Email này chưa được kích hoạt.");
				break;
				case "NOT_ABLE_SEND_EMAIL":
					WindowLayer.getInstance().openAlertWindow("Không thể gửi đến email này.");
				break;
				default:
			}
		}
	}

}