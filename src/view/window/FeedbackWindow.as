package view.window 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import model.MainData;
	import request.MainRequest;
	import view.window.windowLayer.WindowLayer;
	import com.Component777.StarList;
	/**
	 * ...
	 * @author Yun
	 */
	public class FeedbackWindow extends BaseWindow 
	{
		private var mainData:MainData = MainData.getInstance();
		private var sendButton:SimpleButton;
		private var cancelButton:SimpleButton;
		private var guiFeedback:Sprite;
		private var feelingFeedback:Sprite;
		private var inputText:TextField;
		private var starBar:StarList;
		private var windowLayer:WindowLayer = WindowLayer.getInstance();
		
		public function FeedbackWindow() 
		{
			addContent("_FeedbackWindow");
			sendButton = content["sendButton"];
			cancelButton = content["cancelButton"];
			inputText = content["inputText"];
			inputText.type = TextFieldType.INPUT;
			inputText.maxChars = mainData.init.maxCharsFeedback;
			starBar = new StarList();
			starBar.CurrentMark = 3;
			starBar.x = content["starBarPosition"].x;
			starBar.y = content["starBarPosition"].y;
			
			addChild(starBar);
			content["starBarPosition"].visible = false;
			sendButton.addEventListener(MouseEvent.CLICK, onSendButtonClick);
			cancelButton.addEventListener(MouseEvent.CLICK, onCancelButtonClick);
			setupFeedback();
		}
		
		private function setupFeedback():void 
		{
			guiFeedback = content["selectBox_1"];
			feelingFeedback = content["selectBox_2"];
			guiFeedback.buttonMode = feelingFeedback.buttonMode = true;
			guiFeedback["circle_1"].addEventListener(MouseEvent.CLICK, onGuiFeedbackClick);
			guiFeedback["circle_2"].addEventListener(MouseEvent.CLICK, onGuiFeedbackClick);
			guiFeedback["circle_3"].addEventListener(MouseEvent.CLICK, onGuiFeedbackClick);
			guiFeedback["circle_2"]["select"].visible = guiFeedback["circle_3"]["select"].visible = false;
			guiFeedback["circle_1"].mouseChildren = guiFeedback["circle_2"].mouseChildren = guiFeedback["circle_3"].mouseChildren = false;
			TextField(guiFeedback["circle_1"]["content"]).autoSize = TextFieldAutoSize.LEFT;
			TextField(guiFeedback["circle_2"]["content"]).autoSize = TextFieldAutoSize.LEFT;
			TextField(guiFeedback["circle_3"]["content"]).autoSize = TextFieldAutoSize.LEFT;
			TextField(guiFeedback["circle_1"]["content"]).text = "Đẹp";
			TextField(guiFeedback["circle_2"]["content"]).text = "Khá";
			TextField(guiFeedback["circle_3"]["content"]).text = "Tàm tạm";
			TextField(guiFeedback["circle_1"]["content"]).selectable = false;
			TextField(guiFeedback["circle_2"]["content"]).selectable = false;
			TextField(guiFeedback["circle_3"]["content"]).selectable = false;
			feelingFeedback["circle_1"].addEventListener(MouseEvent.CLICK, onFeelingFeedbackClick);
			feelingFeedback["circle_2"].addEventListener(MouseEvent.CLICK, onFeelingFeedbackClick);
			feelingFeedback["circle_3"].addEventListener(MouseEvent.CLICK, onFeelingFeedbackClick);
			feelingFeedback["circle_2"]["select"].visible = feelingFeedback["circle_3"]["select"].visible = false;
			feelingFeedback["circle_1"].mouseChildren = feelingFeedback["circle_2"].mouseChildren = feelingFeedback["circle_3"].mouseChildren = false;
			TextField(feelingFeedback["circle_1"]["content"]).autoSize = TextFieldAutoSize.LEFT;
			TextField(feelingFeedback["circle_2"]["content"]).autoSize = TextFieldAutoSize.LEFT;
			TextField(feelingFeedback["circle_3"]["content"]).autoSize = TextFieldAutoSize.LEFT;
			TextField(feelingFeedback["circle_1"]["content"]).text = "Dễ chơi";
			TextField(feelingFeedback["circle_2"]["content"]).text = "Cũng được";
			TextField(feelingFeedback["circle_3"]["content"]).text = "Tàm tạm";
			TextField(feelingFeedback["circle_1"]["content"]).selectable = false;
			TextField(feelingFeedback["circle_2"]["content"]).selectable = false;
			TextField(feelingFeedback["circle_3"]["content"]).selectable = false;
		}
		
		private function onFeelingFeedbackClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case feelingFeedback["circle_1"]:
					feelingFeedback["circle_1"]["select"].visible = true;
					feelingFeedback["circle_2"]["select"].visible = feelingFeedback["circle_3"]["select"].visible = false;
				break;
				case feelingFeedback["circle_2"]:
					feelingFeedback["circle_2"]["select"].visible = true;
					feelingFeedback["circle_1"]["select"].visible = feelingFeedback["circle_3"]["select"].visible = false;
				break;
				case feelingFeedback["circle_3"]:
					feelingFeedback["circle_3"]["select"].visible = true;
					feelingFeedback["circle_2"]["select"].visible = feelingFeedback["circle_1"]["select"].visible = false;
				break;
			}
		}
		
		private function onGuiFeedbackClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case guiFeedback["circle_1"]:
					guiFeedback["circle_1"]["select"].visible = true;
					guiFeedback["circle_2"]["select"].visible = guiFeedback["circle_3"]["select"].visible = false;
				break;
				case guiFeedback["circle_2"]:
					guiFeedback["circle_2"]["select"].visible = true;
					guiFeedback["circle_1"]["select"].visible = guiFeedback["circle_3"]["select"].visible = false;
				break;
				case guiFeedback["circle_3"]:
					guiFeedback["circle_3"]["select"].visible = true;
					guiFeedback["circle_2"]["select"].visible = guiFeedback["circle_1"]["select"].visible = false;
				break;
			}
		}
		
		private function onSendButtonClick(e:MouseEvent):void 
		{
			var artIndex:int = 0;
			if (guiFeedback["circle_1"]["select"].visible)
				artIndex = 1;
			else if (guiFeedback["circle_2"]["select"].visible)
				artIndex = 2;
			else if (guiFeedback["circle_3"]["select"].visible)
				artIndex = 3;
				
			var uxIndex:int = 0;
			if (feelingFeedback["circle_1"]["select"].visible)
				uxIndex = 1;
			else if (feelingFeedback["circle_2"]["select"].visible)
				uxIndex = 2;
			else if (feelingFeedback["circle_3"]["select"].visible)
				uxIndex = 3;
				
			var starValue:Number = starBar.CurrentMark;
				
			var variables:Object = new Object();
			variables.starValue = starValue;
			variables.artIndex = artIndex;
			variables.uxIndex = uxIndex;
			variables.txtOtherNote = inputText.text;
			variables.userName = mainData.chooseChannelData.myInfo.name;
			
			var tempRequest:MainRequest = new MainRequest();
			var url:String = mainData.init.requestLink.feedbackLink.@url;
			tempRequest.sendRequest_Post(url, variables, sendResponseFn, false);
			close(BaseWindow.MIDDLE_EFFECT);
			
			var successWindow:AlertWindow = new AlertWindow();
			successWindow.setNotice("Phản hồi thành công");
			windowLayer.openWindow(successWindow);
		}
		
		private function sendResponseFn(value:Object):void
		{
			
		}
		
		private function onCancelButtonClick(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
	}

}