package view.window 
{
	import com.hallopatidu.utils.StringFormatUtils;
	import event.DataFieldMauBinh;
	import event.DataFieldXito;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import logic.PlayingLogic;
	import model.MainData;
	import sound.SoundManager;
	import view.button.MyButton;
	import view.userInfo.playerInfo.PlayerInfoXito;
	/**
	 * ...
	 * @author Yun
	 */
	public class ResultWindowXito extends BaseWindow 
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
		
		public function ResultWindowXito() 
		{
			addContent("zResultWindowXito");
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
			exitButton.visible = false;
			exitButton.addEventListener(MouseEvent.CLICK, onExitButtonClick);
			closeButton2 = content["closeButton"];
			closeButton2.visible = false;
			closeButton2.addEventListener(MouseEvent.CLICK, onCloseButtonClick);
			timeCountDownToClose = content["timeCountDownToClose"];
			playerName = new Array();
			money = new Array();
			note = new Array();
			group = new Array();
			index = new Array();
			for (var i:int = 0; i < 5; i++) 
			{
				playerName.push(content["playerName_" + String(i + 1)]);
				money.push(content["money_" + String(i + 1)]);
				note.push(content["note_" + String(i + 1)]);
				index.push(content["index_" + String(i + 1)]);
			}
			for (i = 0; i < 5; i++)
			{
				TextField(playerName[i]).text = "";
				TextField(money[i]).text = "";
				TextField(note[i]).text = "";
				TextField(index[i]).text = "";
			}
		}
		
		private function onExitButtonClick(e:MouseEvent):void 
		{
			dispatchEvent(new Event(PlayerInfoXito.EXIT));
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
			
			playerList.sortOn(DataFieldMauBinh.MONEY, Array.NUMERIC);
			playerList.reverse();
			var myIndex:int;
			for (i = 0; i < playerList.length; i++)
			{
				if (playerList[i][DataFieldMauBinh.USER_NAME] == mainData.chooseChannelData.myInfo.uId)
				{
					switch (i) 
					{
						case 0:
							content["lineBackground"].y = -89;
						break;
						case 1:
							content["lineBackground"].y = -48;
						break;
						case 2:
							content["lineBackground"].y = -5;
						break;
						case 3:
							content["lineBackground"].y = 34;
						break;
						case 4:
							content["lineBackground"].y = 73;
						break;
						default:
					}
					break;
				}
			}
			
			for (i = 0; i < playerList.length; i++) 
			{
				//TextField(note[i]).wordWrap = true;
				//TextField(note[i]).autoSize = TextFieldAutoSize.LEFT;
				//TextField(note[i]).text = "";
				var nameString:String;
				nameString = StringFormatUtils.shortenedString(playerList[i][DataFieldMauBinh.DISPLAY_NAME], 13);
					
				TextField(index[i]).text = String(i + 1);
					
				TextField(playerName[i]).text = nameString;
				
				if (Number(playerList[i][DataFieldMauBinh.MONEY]) >= 0)
				{
					if (Number(playerList[i][DataFieldMauBinh.MONEY]) == 0)
						TextField(money[i]).text = '+' + playerList[i][DataFieldMauBinh.MONEY];
					else
						TextField(money[i]).text = '+' + PlayingLogic.format(playerList[i][DataFieldMauBinh.MONEY], 1);
				}
				else
				{
					if (playerList[i][DataFieldMauBinh.USER_NAME] == mainData.chooseChannelData.myInfo.uId)
					{
						if (mainData.chooseChannelData.myInfo.money < Number(mainData.playingData.gameRoomData.roomBet) * mainData.minBetRate)
							SoundManager.getInstance().soundManagerXito.playLosePlayerSound(mainData.chooseChannelData.myInfo.sex);
						else
							SoundManager.getInstance().soundManagerXito.playLosePlayerSound(mainData.chooseChannelData.myInfo.sex);
					}
					//TextField(money[i]).textColor = 0xFF0000;
					if (Number(playerList[i][DataFieldMauBinh.MONEY]) < -999)
						TextField(money[i]).text = '-' + PlayingLogic.format(Number(playerList[i][DataFieldMauBinh.MONEY]) * -1, 1);
					else
						TextField(money[i]).text = playerList[i][DataFieldMauBinh.MONEY];
				}
				
				//if (playerList[i][DataField.USER_NAME] == mainData.chooseChannelData.myInfo.uId)
					//TextField(note[i]).defaultTextFormat = new TextFormat("Tahoma", 11, 0xCC0000, true);
				//else
					//TextField(note[i]).defaultTextFormat = new TextFormat("Tahoma", 11, 0xCCCCCC, false);
						
				var number:int = playerList[i][DataFieldMauBinh.TOTAL];
				if (number > 0)
					TextField(note[i]).text = "Thắng " + String(number) + " chi";
				else if (number < 0)
					TextField(note[i]).text = "Thua " + String(number * -1) + " chi";
				
				if (playerList[i][DataFieldMauBinh.IS_BINH_LUNG])
				{
					TextField(note[i]).appendText(' (' + "Binh lủng" + ')');
				}
				else
				{
					if (playerList[i][DataFieldMauBinh.NUMBER_SAP] > 0)
						TextField(note[i]).appendText(' (' + "Sập " + String(playerList[i][DataFieldMauBinh.NUMBER_SAP]) + " nhà." + ')');
				}
				
				//if (playerList[i][DataFieldMauBinh.OTHER_USER_QUIT])
					//TextField(note[i]).appendText(' (' + "Người chơi khác thoát." + ')');
					
				if (playerList[i][DataFieldXito.IS_FOLD])
					TextField(note[i]).appendText(' (' + "Úp bỏ" + ')');
				else if (playerList[i][DataFieldXito.QUITERS])
					TextField(note[i]).appendText(' (' + "Bỏ cuộc" + ')');
					
				switch (String(playerList[i][DataFieldMauBinh.WIN_TYPE])) 
				{
					case '39':
						TextField(note[i]).appendText(' (' + "Sảnh rồng cuốn." + ')');
					break;
					case '38':
						TextField(note[i]).appendText(' (' + "Sảnh rồng." + ')');
					break;
					case '37':
						TextField(note[i]).appendText(' (' + "Rồng màu." + ')');
					break;
					case '36':
						TextField(note[i]).appendText(' (' + "Rồng màu." + ')');
					break;
					case '35':
						TextField(note[i]).appendText(' (' + "Rồng 1 mắt." + ')');
					break;
					case '34':
						TextField(note[i]).appendText(' (' + "Rồng 1 mắt." + ')');
					break;
					case '33':
						TextField(note[i]).appendText(' (' + "5 đôi 1 sám." + ')');
					break;
					case '32':
						TextField(note[i]).appendText(' (' + "Lục phé bôn." + ')');
					break;
					case '31':
						TextField(note[i]).appendText(' (' + "3 thùng." + ')');
					break;
					case '30':
						TextField(note[i]).appendText(' (' + "3 sảnh." + ')');
					break;
					default:
				}
			}
		}
	}

}