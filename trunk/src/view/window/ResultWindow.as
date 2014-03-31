package view.window 
{
	import com.hallopatidu.utils.StringFormatUtils;
	import event.DataField;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import logic.PlayingLogic;
	import model.MainData;
	import view.button.MyButton;
	import view.userInfo.playerInfo.PlayerInfo;
	/**
	 * ...
	 * @author Yun
	 */
	public class ResultWindow extends BaseWindow 
	{
		private var closeButton:MyButton;
		private var mainData:MainData = MainData.getInstance();
		private var playerName:Array;
		private var money:Array;
		private var index:Array;
		private var note:Array;
		private var group:Array;
		private var timerToClose:Timer;
		private var closeButton2:SimpleButton;
		private var exitButton:SimpleButton;
		private var timeCountDownToClose:TextField;
		
		public function ResultWindow() 
		{
			addContent("zResultWindow");
			addButton();
			resetInfo();
		}
		
		public override function open(openType:String):void
		{
			super.open(openType);
			timerToClose = new Timer(5000, 1);
			timerToClose.addEventListener(TimerEvent.TIMER_COMPLETE, onClose);
			timerToClose.start();
			
			var timerToCounDown:Timer = new Timer(1000);
			timerToCounDown.addEventListener(TimerEvent.TIMER, onCoundDownToClose);
			timerToCounDown.start();
			timeCountDownToClose.text = '5';
		}
		
		private function onCoundDownToClose(e:TimerEvent):void 
		{
			if (!stage)
			{
				Timer(e.currentTarget).removeEventListener(TimerEvent.TIMER, onCoundDownToClose);
				Timer(e.currentTarget).stop();
			}
			var tempNumber:int = int(timeCountDownToClose.text);
			tempNumber--;
			timeCountDownToClose.text = String(tempNumber);
		}
		
		private function onClose(e:TimerEvent):void 
		{
			if (!stage)
			{
				if (timerToClose)
				{
					timerToClose.removeEventListener(TimerEvent.TIMER_COMPLETE, onClose);
					timerToClose.stop();
				}
			}
			if (timerToClose)
			{
				timerToClose.removeEventListener(TimerEvent.TIMER_COMPLETE, onClose);
				timerToClose.stop();
			}
			closeButton2.removeEventListener(MouseEvent.CLICK, onCloseButtonClick);
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function resetInfo():void 
		{
			exitButton = content["exitButton"];
			exitButton.addEventListener(MouseEvent.CLICK, onExitButtonClick);
			closeButton2 = content["closeButton"];
			closeButton2.addEventListener(MouseEvent.CLICK, onCloseButtonClick);
			timeCountDownToClose = content["timeCountDownToClose"];
			playerName = new Array();
			money = new Array();
			note = new Array();
			group = new Array();
			index = new Array();
			for (var i:int = 0; i < 4; i++) 
			{
				playerName.push(content["playerName_" + String(i + 1)]);
				money.push(content["money_" + String(i + 1)]);
				note.push(content["note_" + String(i + 1)]);
				index.push(content["index_" + String(i + 1)]);
			}
			for (i = 0; i < 4; i++)
			{
				TextField(playerName[i]).text = "";
				TextField(money[i]).text = "";
				TextField(note[i]).text = "";
			}
		}
		
		private function onExitButtonClick(e:MouseEvent):void 
		{
			dispatchEvent(new Event(PlayerInfo.EXIT));
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function onCloseButtonClick(e:MouseEvent):void 
		{
			closeButton2.removeEventListener(MouseEvent.CLICK, onCloseButtonClick);
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function addButton():void 
		{
			// tạo nút đóng cửa sổ
			//createButton("closeButton", 90, 18, onCloseWindow);
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
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		public function setInfo(playerList:Array):void
		{
			var i:int;
			
			var myIndex:int;
			for (i = 0; i < playerList.length; i++)
			{
				if (playerList[i][DataField.USER_NAME] == mainData.chooseChannelData.myInfo.uId)
				{
					var tempObject:Object = playerList[i];
					playerList[i] = playerList[0];
					playerList[0] = tempObject;
					break;
				}
			}
			
			for (i = 0; i < playerList.length; i++) 
			{
				//TextField(note[i]).wordWrap = true;
				//TextField(note[i]).autoSize = TextFieldAutoSize.LEFT;
				//TextField(note[i]).text = "";
				var nameString:String;
				nameString = StringFormatUtils.shortenedString(playerList[i][DataField.DISPLAY_NAME], 13);
					
				TextField(index[i]).text = String(i + 1);
					
				TextField(playerName[i]).text = nameString;
				
				if (Number(playerList[i][DataField.MONEY]) >= 0)
				{
					if (Number(playerList[i][DataField.MONEY]) == 0)
						TextField(money[i]).text = '+' + playerList[i][DataField.MONEY];
					else
						TextField(money[i]).text = '+' + PlayingLogic.format(playerList[i][DataField.MONEY], 1);
				}
				else
				{
					TextField(money[i]).textColor = 0xFF0000;
					if (Number(playerList[i][DataField.MONEY]) < -999)
						TextField(money[i]).text = '-' + PlayingLogic.format(Number(playerList[i][DataField.MONEY]) * -1, 1);
					else
						TextField(money[i]).text = playerList[i][DataField.MONEY];
				}
				
				//if (playerList[i][DataField.USER_NAME] == mainData.chooseChannelData.myInfo.uId)
					//TextField(note[i]).defaultTextFormat = new TextFormat("Tahoma", 11, 0xCC0000, true);
				//else
					//TextField(note[i]).defaultTextFormat = new TextFormat("Tahoma", 11, 0xCCCCCC, false);
						
				var number:int = 0;
				if (playerList[i][DataField.COMPARE_LIST])
				{
					for (var j:int = 0; j < playerList[i][DataField.COMPARE_LIST].length; j++) 
					{
						for (var k:int = 0; k < playerList[i][DataField.COMPARE_LIST][j][DataField.COMPARE_ARRAYS].length; k++) 
						{
							number += playerList[i][DataField.COMPARE_LIST][j][DataField.COMPARE_ARRAYS][k];
						}
					}
					if (playerList[i][DataField.BONUS_CHI])
						number += playerList[i][DataField.BONUS_CHI];
					if (number > 0)
						TextField(note[i]).text = "Thắng " + String(number) + " chi";
					else if (number < 0)
						TextField(note[i]).text = "Thua " + String(number * -1) + " chi";
				}
				
				if (playerList[i][DataField.IS_BINH_LUNG])
				{
					TextField(note[i]).appendText(' (' + "Binh lủng" + ')');
				}
				else
				{
					if (playerList[i][DataField.NUMBER_SAP] > 0)
						TextField(note[i]).appendText(' (' + "Sập " + String(playerList[i][DataField.NUMBER_SAP]) + " nhà." + ')');
				}
				
				if (playerList[i][DataField.OTHER_USER_QUIT])
					TextField(note[i]).appendText(' (' + "Người chơi khác thoát." + ')');
			}
		}
	}

}