package view.window 
{
	import control.MainCommand;
	import event.DataFieldMauBinh;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import logic.PlayingLogic;
	import model.MainData;
	import view.button.MyButton;
	import view.myComboBox.MyComboBox;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	public class CreateRoomWindow extends BaseWindow 
	{
		private var createRoomButton:SimpleButton;
		private var closeButton:SimpleButton;
		private var mainData:MainData = MainData.getInstance();
		
		private var itemComboBox:MyComboBox;
		private var playerNumberComboBox:MyComboBox;
		private var betInputText:MyComboBox;
		private var passInputText:TextField;
		private var selectBox:Sprite;
		
		private var electroServerCommand:* = MainCommand.getInstance().electroServerCommand;
		private var windowLayer:WindowLayer = WindowLayer.getInstance();
		
		public function CreateRoomWindow() 
		{
			addContent("zCreateRoomWindow");
			addButton();
			addCommboBox();
			createInputText();
			createSelectBox();
			hidePosition();
			
			trace(electroServerCommand);
		}
		
		private function createSelectBox():void 
		{
			selectBox = content["selectBox"];
			selectBox.visible = false;
			selectBox.buttonMode = true;
			
			selectBox["circle_1"].addEventListener(MouseEvent.CLICK, onSelectBoxClick);
			selectBox["circle_2"].addEventListener(MouseEvent.CLICK, onSelectBoxClick);
			selectBox["circle_2"]["select"].visible = false;
			selectBox["circle_1"].mouseChildren = selectBox["circle_2"].mouseChildren = false;
			TextField(selectBox["circle_1"]["content"]).autoSize = TextFieldAutoSize.LEFT;
			TextField(selectBox["circle_2"]["content"]).autoSize = TextFieldAutoSize.LEFT;
			TextField(selectBox["circle_1"]["content"]).text = "Gửi bài";
			TextField(selectBox["circle_2"]["content"]).text = "Không gửi bài";
			TextField(selectBox["circle_1"]["content"]).selectable = false;
			TextField(selectBox["circle_2"]["content"]).selectable = false;
		}
		
		private function onSelectBoxClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case selectBox["circle_1"]:
					selectBox["circle_1"]["select"].visible = true;
					selectBox["circle_2"]["select"].visible = false;
				break;
				case selectBox["circle_2"]:
					selectBox["circle_2"]["select"].visible = true;
					selectBox["circle_1"]["select"].visible = false;
				break;
			}
		}
		
		private function hidePosition():void 
		{
			content["itemPosition"].visible = false;
			content["playerNumberPosition"].visible = false;
			content["betPosition"].visible = false;
		}
		
		private function createInputText():void 
		{
			var i:int;
			
			passInputText = content["passInputText"];
			passInputText.displayAsPassword = true;
			passInputText.maxChars = mainData.init.maxCharsInputText;
			
			betInputText = new MyComboBox();
			var betArray:Array = new Array();
			for (i = 0; i < mainData.playingData.gameRoomData.betting.length; i++) 
			{
				var tempObject:Object = new Object();
				tempObject[DataFieldMauBinh.VALUE] = mainData.playingData.gameRoomData.betting[i];
				tempObject[DataFieldMauBinh.DESCRIPTION] = PlayingLogic.format(mainData.playingData.gameRoomData.betting[i], 1);
				betArray.push(tempObject);
			}
			betInputText.valueArray = betArray;
			betInputText.currentValue = betArray[0];
			betInputText.x = content["betPosition"].x;
			betInputText.y = content["betPosition"].y;
			addChild(betInputText);
			
			itemComboBox = new MyComboBox();
			var tempTextFormat:TextFormat = new TextFormat("Tahoma", 12, null, true);
			itemComboBox.mainTextFormat = tempTextFormat;
			itemComboBox.x = content["itemPosition"].x;
			itemComboBox.y = content["itemPosition"].y;
			
			tempObject = new Object();
			tempObject[DataFieldMauBinh.VALUE] = 0;
			tempObject[DataFieldMauBinh.DESCRIPTION] = "Hiện chưa có item nào";
			itemComboBox.currentValue = tempObject;
				
			addChild(itemComboBox);
			
			playerNumberComboBox = new MyComboBox();
			var numberArray:Array = new Array();
			for (i = 1; i < mainData.maxPlayer; i++) 
			{
				tempObject = new Object();
				tempObject[DataFieldMauBinh.VALUE] = String(i + 1);
				tempObject[DataFieldMauBinh.DESCRIPTION] = String(i + 1);
				numberArray.push(tempObject);
			}
			playerNumberComboBox.valueArray = numberArray;
			playerNumberComboBox.currentValue = numberArray[numberArray.length - 1];
			playerNumberComboBox.x = content["playerNumberPosition"].x;
			playerNumberComboBox.y = content["playerNumberPosition"].y;
			addChild(playerNumberComboBox);
		}
		
		private function addCommboBox():void 
		{
			
		}
		
		private function addButton():void 
		{
			// tạo nút vào phòng chơi
			createRoomButton = content["createRoomButton"];
			createRoomButton.addEventListener(MouseEvent.CLICK, onCreateRoom);
			
			// tạo nút đóng cửa sổ
			closeButton = content["closeButton"];
			closeButton.addEventListener(MouseEvent.CLICK, onCloseWindow);
		}
		
		private function createButton(buttonName:String,_width:Number,_height:Number,_function:Function):void
		{
			this[buttonName] = new MyButton();
			this[buttonName].width = _width;
			this[buttonName].height = _height;
			this[buttonName].setLabel(mainData.init.gameDescription.lobbyRoomScreen[buttonName]);
			this[buttonName].x = content[buttonName + "Position"].x;
			this[buttonName].y = content[buttonName + "Position"].y;
			this[buttonName].addEventListener(MouseEvent.CLICK, _function);
			content[buttonName + "Position"].visible = false;
			addChild(this[buttonName]);
		}
		
		private function onCreateRoom(e:MouseEvent):void 
		{
			trace("aaaaaaaaaaaaaaaaaaa onCreateRoom");
			mainData.playingData.gameRoomData.roomPassword = passInputText.text;
			var gameOption:Object = new Object();
			gameOption[DataFieldMauBinh.ROOM_NAME] = '';
			gameOption[DataFieldMauBinh.ROOM_BET] = betInputText.currentValue[DataFieldMauBinh.VALUE];
			gameOption[DataFieldMauBinh.IS_SEND_CARD] = true;
			gameOption[DataFieldMauBinh.MAX_PLAYER] = playerNumberComboBox.currentValue[DataFieldMauBinh.VALUE];;
			
			if (int(gameOption[DataFieldMauBinh.ROOM_BET]) * mainData.minBetRate > mainData.chooseChannelData.myInfo.money)
			{
				var notEnoughMoneyWindow:AlertWindow = new AlertWindow();
				var string1:String = mainData.init.gameDescription.lobbyRoomScreen.notEnoughMoneyToCreate1;
				var string2:String = mainData.init.gameDescription.lobbyRoomScreen.notEnoughMoneyToCreate2;
				var minMoney:Number = Number(gameOption[DataFieldMauBinh.ROOM_BET]) * mainData.minBetRate;
				notEnoughMoneyWindow.setNotice(string1 + " " + PlayingLogic.format(minMoney, 1) + " " + string2);
				windowLayer.openWindow(notEnoughMoneyWindow);
			}
			else
			{
				electroServerCommand.createGameRoom(passInputText.text, gameOption);
			}
			
			close(BaseWindow.NO_EFFECT);
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.NO_EFFECT);
		}
		
	}

}