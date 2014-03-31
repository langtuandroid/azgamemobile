package view.window 
{
	import com.hallopatidu.utils.StringFormatUtils;
	import event.DataField;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import logic.PlayingLogic;
	import model.MainData;
	import view.button.MyButton;
	/**
	 * ...
	 * @author Yun
	 */
	public class ResultWindowPhom extends BaseWindow 
	{
		private var closeButton:SimpleButton;
		private var mainData:MainData = MainData.getInstance();
		private var playerName:Array;
		private var money:Array;
		private var note:Array;
		private var timerToClose:Timer;
		
		public function ResultWindowPhom() 
		{
			addContent("zResultWindow");
			addButton();
			resetInfo();
		}
		
		public override function open(openType:String):void
		{
			super.open(openType);
			timerToClose = new Timer(11000, 1);
			timerToClose.addEventListener(TimerEvent.TIMER_COMPLETE, onClose);
			timerToClose.start();
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
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function resetInfo():void 
		{
			playerName = new Array();
			money = new Array();
			note = new Array();
			for (var i:int = 0; i < 4; i++) 
			{
				playerName.push(content["playerName_" + String(i + 1)]);
				money.push(content["money_" + String(i + 1)]);
				note.push(content["note_" + String(i + 1)]);
			}
			for (i = 0; i < 4; i++)
			{
				TextField(playerName[i]).text = "";
				TextField(money[i]).text = "";
				TextField(note[i]).text = "";
			}
		}
		
		private function addButton():void 
		{
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
					if (playerList[i][DataField.RESULT_POSITION] > playerList[i + 1][DataField.RESULT_POSITION])
					{
						var tempObject:*;
						tempObject = playerList[i];
						playerList[i] = playerList[i + 1];
						playerList[i + 1] = tempObject;
						arrangeFinish = false;
					}
				}
			}
			for (i = 0; i < playerList.length; i++) 
			{
				var nameString:String;
				nameString = StringFormatUtils.shortenedString(playerList[i][DataField.DISPLAY_NAME], 14);
				TextField(playerName[i]).text = nameString;
				
				if (playerList[i][DataField.MONEY] == 0)
					var tempMoney:String = '0';
				else
					tempMoney = PlayingLogic.format(playerList[i][DataField.MONEY], 1);
				if (playerList[i][DataField.RESULT_POSITION] == 0)
				{
					TextField(money[i]).text = "+" + tempMoney;
				}
				else
				{
					TextField(money[i]).textColor = 0xFF0000;
					TextField(money[i]).text = '-' + tempMoney;
				}
					
				TextField(note[i]).text = playerList[i][DataField.POINT] + " điểm";
				
				if (playerList[i][DataField.RESULT_POSITION] == 0) // Về nhất
				{
					if(playerList[i][DataField.POINT] == 0)
					{
						// Ù
						if (mainData.isPhomGa)
							TextField(note[i]).text = "Ù + ăn gà";
						else
							TextField(note[i]).text = "Ù";
					}
					else if(playerList[i][DataField.POINT] == -5) // Ù khan
						TextField(note[i]).text = "Ù khan";
					else if(playerList[i][DataField.POINT] == -1) // Móm nhưng thắng
						TextField(note[i]).text = "Móm hạ trước";
					else if(playerList[i][DataField.POINT] == -4) // Thắng
						TextField(note[i]).text = "Thắng";
						
				}
				else // Không về nhất
				{
					if(playerList[i][DataField.POINT] == -1) // Móm
						TextField(note[i]).text = "Móm";
					else if(playerList[i][DataField.POINT] == -2) // Đền
						TextField(note[i]).text = "Đền";
					else if(playerList[i][DataField.POINT] == -3) // Thua
						TextField(note[i]).text = "Thua";	
				}
			}
		}
	}

}