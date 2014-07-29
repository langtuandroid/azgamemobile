package view.window 
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author ...
	 */
	public class CloseConnectionWindow extends BaseWindow 
	{
		private var closeButton:SimpleButton;
		private var reConnectButton:SimpleButton;
		private var notice:TextField;
		
		public function CloseConnectionWindow() 
		{
			addContent("zCloseConnectionWindow");
			notice = content["notice"];
			notice.autoSize = TextFieldAutoSize.CENTER;
			notice.wordWrap = true;
			
			closeButton = content["closeButton"];
			closeButton.addEventListener(MouseEvent.CLICK, onCloseWindow);
			reConnectButton = content["reConnectButton"];
			reConnectButton.addEventListener(MouseEvent.CLICK, onCloseWindow);
		}
		
		public function setNotice(content:String):void
		{
			notice.text = content;
			notice.y = - notice.height / 2;
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
	}

}