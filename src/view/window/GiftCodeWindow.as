package view.window 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Yun
	 */
	public class GiftCodeWindow extends BaseWindow 
	{
		public static const INPUT_FORM:String = "inputForm";
		public static const SUCCESS_FORM:String = "successForm";
		public static const FAIL_FORM:String = "failForm";
		
		private var inputTxt:TextField;
		private var giftCodeTxt:TextField;
		private var cancelButton:SimpleButton;
		private var confirmButton:SimpleButton;
		private var closeButton:SimpleButton;
		
		public function GiftCodeWindow() 
		{
			addContent("zGiftCodeWindow");
		}
		
		private var _type:String;
		
		public function set type(value:String):void 
		{
			_type = value;
			MovieClip(content).gotoAndStop(_type);
			
			switch (_type) 
			{
				case INPUT_FORM:
					inputTxt = content["inputTxt"];
					cancelButton = content["cancelButton"];
					confirmButton = content["confirmButton"];
					confirmButton.addEventListener(MouseEvent.CLICK, onButtonClick);
					cancelButton.addEventListener(MouseEvent.CLICK, onButtonClick);
				break;
				case SUCCESS_FORM:
					giftCodeTxt = content["giftCodeTxt"];
					closeButton = content["closeButton"];
					closeButton.addEventListener(MouseEvent.CLICK, onButtonClick);
				break;
				case FAIL_FORM:
					closeButton = content["closeButton"];
					closeButton.addEventListener(MouseEvent.CLICK, onButtonClick);
				break;
				default:
			}
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case closeButton:
					close(BaseWindow.MIDDLE_EFFECT);
				break;
				case cancelButton:
					close(BaseWindow.MIDDLE_EFFECT);
				break;
				case confirmButton:
					
				break;
				default:
			}
		}
		
	}

}