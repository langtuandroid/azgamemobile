package view.window 
{
	import com.hallopatidu.utils.StringFormatUtils;
	import event.DataFieldPhom;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import logic.PlayingLogic;
	import model.MainData;
	import sound.SoundLibChung;
	import sound.SoundLibPhom;
	import sound.SoundManager;
	import view.button.MyButton;
	import view.userInfo.playerInfo.PlayerInfoPhom;
	/**
	 * ...
	 * @author Yun
	 */
	public class ResultWindowPhom extends BaseWindow 
	{
		private var closeButton:MyButton;
		private var mainData:MainData = MainData.getInstance();
		private var playerName:Array;
		private var money:Array;
		private var index:Array;
		private var note:Array;
		private var timerToClose:Timer;
		private var closeButton2:SimpleButton;
		private var exitButton:SimpleButton;
		private var timeCountDownToClose:TextField;
		
		public function ResultWindowPhom() 
		{
			addContent("zResultWindowPhom");
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
				TextField(index[i]).text = "";
			}
		}
		
		private function onExitButtonClick(e:MouseEvent):void 
		{
			dispatchEvent(new Event(PlayerInfoPhom.EXIT));
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
			var arrangeFinish:Boolean;
			while (!arrangeFinish) 
			{
				arrangeFinish = true;
				for (i = 0; i < playerList.length - 1; i++) 
				{
					if (playerList[i][DataFieldPhom.RESULT_POSITION] > playerList[i + 1][DataFieldPhom.RESULT_POSITION])
					{
						var tempObject:*;
						tempObject = playerList[i];
						playerList[i] = playerList[i + 1];
						playerList[i + 1] = tempObject;
						arrangeFinish = false;
					}
				}
			}
			
			var myIndex:int;
			for (i = 0; i < playerList.length; i++)
			{
				if (playerList[i][DataFieldPhom.USER_NAME] == mainData.chooseChannelData.myInfo.uId)
				{
					if (i == 0)
					{
						SoundManager.getInstance().playSound(SoundLibChung.WIN_SOUND);
					}
					else
					{
						SoundManager.getInstance().playSound(SoundLibChung.LOSE_SOUND);
						if (playerList[i][DataFieldPhom.POINT] != -2)
						{
							var timerToAlertLose:Timer = new Timer(10000, 1);
							timerToAlertLose.addEventListener(TimerEvent.TIMER_COMPLETE, onAlertLose);
							timerToAlertLose.start();
						}
					}
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
						default:
					}
					break;
				}
			}
			
			for (i = 0; i < playerList.length; i++) 
			{
				var nameString:String;
				nameString = StringFormatUtils.shortenedString(playerList[i][DataFieldPhom.DISPLAY_NAME], 14);
				TextField(playerName[i]).text = nameString;
				TextField(index[i]).text = String(i + 1);
				
				if (playerList[i][DataFieldPhom.MONEY] == 0)
					var tempMoney:String = '0';
				else
					tempMoney = PlayingLogic.format(playerList[i][DataFieldPhom.MONEY], 1);
				if (playerList[i][DataFieldPhom.RESULT_POSITION] == 0)
				{
					TextField(money[i]).text = "+" + tempMoney;
				}
				else
				{
					TextField(money[i]).text = '-' + tempMoney;
				}
					
				TextField(note[i]).text = playerList[i][DataFieldPhom.POINT] + " điểm";
				
				if (playerList[i][DataFieldPhom.RESULT_POSITION] == 0) // Về nhất
				{
					if(playerList[i][DataFieldPhom.POINT] == 0)
					{
						// Ù
						if (mainData.isPhomGa)
							TextField(note[i]).text = "Ù + ăn gà";
						else
							TextField(note[i]).text = "Ù";
					}
					else if(playerList[i][DataFieldPhom.POINT] == -5) // Ù khan
						TextField(note[i]).text = "Ù khan";
					else if(playerList[i][DataFieldPhom.POINT] == -1) // Móm nhưng thắng
						TextField(note[i]).text = "Móm hạ trước";
					else if(playerList[i][DataFieldPhom.POINT] == -4) // Thắng
						TextField(note[i]).text = "Thắng";
						
				}
				else // Không về nhất
				{
					if(playerList[i][DataFieldPhom.POINT] == -1) // Móm
						TextField(note[i]).text = "Móm";
					else if(playerList[i][DataFieldPhom.POINT] == -2) // Đền
						TextField(note[i]).text = "Đền";
					else if(playerList[i][DataFieldPhom.POINT] == -3) // Thua
						TextField(note[i]).text = "Thua";	
				}
			}
		}
		
		private function onAlertLose(e:TimerEvent):void 
		{
			SoundManager.getInstance().soundManagerPhom.playLosePlayerSound(mainData.chooseChannelData.myInfo.sex);
		}
	}

}