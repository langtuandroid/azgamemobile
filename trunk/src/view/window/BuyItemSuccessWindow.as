package view.window 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import model.MainData;
	import view.button.MyButton;
	/**
	 * ...
	 * @author Yun
	 */
	public class BuyItemSuccessWindow extends BaseWindow 
	{
		public static const CONFIRM:String = "confirm";
		public static const REJECT:String = "reject";
		private var confirmButton:SimpleButton;
		private var closeButton:SimpleButton;
		private var myContent:MovieClip;
		private var notice:TextField;
		
		private var mainData:MainData = MainData.getInstance();
		
		public function BuyItemSuccessWindow() 
		{
			myContent = new BuyItemSuccessWindowMc();
			addChild(myContent);
			
			notice = myContent["notice"];
			
			closeButton = myContent["closeButton"];
			closeButton.addEventListener(MouseEvent.CLICK, onCloseWindow);
			
			confirmButton = myContent["useNowBtn"];
			
			confirmButton.addEventListener(MouseEvent.CLICK, onConfirm);
			
		}
		
		private function onConfirm(e:MouseEvent):void 
		{
			dispatchEvent(new Event(CONFIRM));
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			dispatchEvent(new Event(REJECT));
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		public function setNotice(content:String):void
		{
			notice.text = content;
		}
		
		public function buttonStatus(close:Boolean, confirm:Boolean, deny:Boolean):void 
		{
			closeButton.visible = close;
			confirmButton.visible = confirm;
			
		}
	}

}