package view.window 
{
	import event.DataField;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import model.MainData;
	import request.MainRequest;
	import view.button.MyButton;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	public class AccuseWindow extends BaseWindow 
	{
		private var mainData:MainData = MainData.getInstance();
		private var windowLayer:WindowLayer = WindowLayer.getInstance();
		private var myName:TextField;
		private var friendName:TextField;
		private var inputText:TextField;
		private var selectSentenceArray:Array;
		private var accuseButton:MyButton;
		private var closeButton:MyButton;
		private var tooltip:Sprite;
		
		public function AccuseWindow() 
		{
			addContent("zAccuseWindow");
			myName = content["myName"];
			friendName = content["friendName"];
			tooltip = content["tooltip"];
			tooltip.visible = false;
			myName.selectable = friendName.selectable = false;
			inputText = content["inputText"];
			inputText.type = TextFieldType.INPUT;
			inputText.maxChars = mainData.init.maxCharsFeedback;
			selectSentenceArray = new Array();
			addButton();
			for (var i:int = 0; i < 4; i++) 
			{
				selectSentenceArray[i] = content["sentence_" + String(i + 1)];
				selectSentenceArray[i].buttonMode = true;
				selectSentenceArray[i].mouseChildren = false;
				selectSentenceArray[i]["circleBox"]["child"].visible = false;
				selectSentenceArray[i].addEventListener(MouseEvent.CLICK, onSelectSentenceClick);
				TextField(selectSentenceArray[i].sentence).autoSize = TextFieldAutoSize.LEFT;
				TextField(selectSentenceArray[i].sentence).selectable = false;
				TextField(selectSentenceArray[i].sentence).text = mainData.init.gameDescription.playingScreen.accuseWindow["selectSentence_" + String(i + 1)];
			}
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			stage.removeEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		private function onStageClick(e:MouseEvent):void 
		{
			tooltip.visible = false;
		}
		
		private function addButton():void 
		{
			// tạo nút vào phòng chơi
			createButton("accuseButton", 90, 18, onAccuse);
			
			// tạo nút đóng cửa sổ
			createButton("closeButton", 90, 18, onCloseWindow);
		}
		
		private function onAccuse(e:MouseEvent):void
		{
			var variables:Object = new Object();
			variables.plaintiffName = mainData.chooseChannelData.myInfo.uId;
			variables.accusedName = data[DataField.USER_NAME];
			
			for (var i:int = 0; i < selectSentenceArray.length; i++) 
			{
				if (selectSentenceArray[i]["circleBox"]["child"].visible)
				{
					var str:String = "";
					if(selectSentenceArray[0]["circleBox"]["child"].visible) str += "1,";
					if(selectSentenceArray[1]["circleBox"]["child"].visible) str += "2,";
					if(selectSentenceArray[2]["circleBox"]["child"].visible) str += "3,";
					if (selectSentenceArray[3]["circleBox"]["child"].visible)
					{
						str += "4";
						if (inputText.text == "")
						{
							TextField(tooltip["description"]).text = mainData.init.gameDescription.playingScreen.accuseWindow.emptyReason;
							tooltip.visible = true;
							e.stopPropagation();
							return;
						}
					}
					variables.reasons = str;
					variables.message = inputText.text;
					variables.roomName = mainData.playingData.gameRoomData.roomId;
					variables.channelName = mainData.playingData.gameRoomData.channelName;
					variables.gameType = 2;
					
					var tempRequest:MainRequest = new MainRequest();
					var url:String = mainData.init.requestLink.accuseLink.@url;
					tempRequest.sendRequest_Post(url, variables, sendResponseFn, false);
					close(BaseWindow.MIDDLE_EFFECT);
					
					var successWindow:AlertWindow = new AlertWindow();
					successWindow.setNotice("Tố cáo thành công");
					windowLayer.openWindow(successWindow);
					return;
				}
			}
			
			TextField(tooltip["description"]).text = mainData.init.gameDescription.playingScreen.accuseWindow.noReason;
			tooltip.visible = true;
			e.stopPropagation();
		}
		
		private function sendResponseFn(value:Object):void
		{
			
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function createButton(buttonName:String,_width:Number,_height:Number,_function:Function):void
		{
			this[buttonName] = new MyButton();
			this[buttonName].width = _width;
			this[buttonName].height = _height;
			MyButton(this[buttonName]).setLabel(mainData.init.gameDescription.playingScreen.accuseWindow[buttonName]);
			this[buttonName].x = content[buttonName + "Position"].x;
			this[buttonName].y = content[buttonName + "Position"].y;
			this[buttonName].addEventListener(MouseEvent.CLICK, _function);
			content[buttonName + "Position"].visible = false;
			addChild(this[buttonName]);
		}
		
		private function onSelectSentenceClick(e:MouseEvent):void 
		{
			e.currentTarget["circleBox"]["child"].visible = !e.currentTarget["circleBox"]["child"].visible;
		}
		
		private var _data:Object
		
		public function get data():Object 
		{
			return _data;
		}
		
		public function set data(value:Object):void 
		{
			_data = value;
			friendName.text = data[DataField.DISPLAY_NAME];
			myName.text = mainData.chooseChannelData.myInfo.name;
		}
		
	}

}