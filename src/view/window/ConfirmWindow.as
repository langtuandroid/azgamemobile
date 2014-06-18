package view.window 
{
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
	public class ConfirmWindow extends BaseWindow 
	{
		public static const CONFIRM:String = "confirm";
		public static const REJECT:String = "reject";
		private var confirmButton:SimpleButton;
		private var closeButton:SimpleButton;
		private var denyButton:SimpleButton;
		private var notice:TextField;
		
		private var mainData:MainData = MainData.getInstance();
		
		public function ConfirmWindow() 
		{
			addContent("zConfirmWindow");
			notice = content["notice"];
			
			closeButton = content["closeButton"];
			closeButton.addEventListener(MouseEvent.CLICK, onCloseWindow);
			
			confirmButton = content["confirmButton"];
			denyButton = content["denyButton"];
			confirmButton.addEventListener(MouseEvent.CLICK, onConfirm);
			denyButton.addEventListener(MouseEvent.CLICK, onCloseWindow);
		}
		
		private function createButton(buttonName:String,_width:Number,_height:Number,_function:Function):void
		{
			this[buttonName] = new MyButton();
			this[buttonName].width = _width;
			this[buttonName].height = _height;
			this[buttonName].setLabel(mainData.init.gameDescription.playingScreen[buttonName]);
			this[buttonName].x = content[buttonName + "Position"].x;
			this[buttonName].y = content[buttonName + "Position"].y;
			this[buttonName].addEventListener(MouseEvent.CLICK, _function);
			content[buttonName + "Position"].visible = false;
			addChild(this[buttonName]);
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
			denyButton.visible = deny;
			
			if (!denyButton.visible) 
			{
				confirmButton.x = -38;
			}
			else if (!confirmButton.visible) 
			{
				denyButton.x = -38;
				
			}
			else if (confirmButton.visible && closeButton.visible) 
			{
				confirmButton.x = -86;
				denyButton.x = 6;
			}
		}
	}

}