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
	public class ResultWindowXito extends BaseWindow 
	{
		private var closeButton:SimpleButton;
		private var mainData:MainData = MainData.getInstance();
		private var playerName:Array;
		private var money:Array;
		private var note:Array;
		private var timerToClose:Timer;
		
		public function ResultWindowXito() 
		{
			addContent("zResultWindowXito");
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
			for (var i:int = 0; i < 5; i++) 
			{
				playerName.push(content["playerName_" + String(i + 1)]);
				money.push(content["money_" + String(i + 1)]);
				note.push(content["note_" + String(i + 1)]);
			}
			for (i = 0; i < 5; i++)
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
			playerList.sortOn(DataField.MONEY, Array.NUMERIC | Array.DESCENDING);
			
			for (i = 0; i < playerList.length; i++) 
			{
				var nameString:String;
				nameString = StringFormatUtils.shortenedString(playerList[i][DataField.DISPLAY_NAME], 14);
				TextField(playerName[i]).text = nameString;
				
				if (playerList[i][DataField.MONEY] == 0)
				{
					var tempMoney:String = '-' + PlayingLogic.format(playerList[i][DataField.MONEY_BET], 1);
					TextField(note[i]).text = '0';
				}
				else
				{
					var winMoney:Number = Number(playerList[i][DataField.MONEY]) - Number(playerList[i][DataField.MONEY_BET]);
					//winMoney = Math.floor(winMoney * 0.95);
					if (winMoney < 0)
						tempMoney = '-' + PlayingLogic.format(winMoney * -1, 1);
					else
						tempMoney = '+' + PlayingLogic.format(winMoney, 1);
					TextField(note[i]).text = PlayingLogic.format(Number(playerList[i][DataField.MONEY]), 1);
				}
					
				TextField(money[i]).text = tempMoney;
				/*if (playerList[i][DataField.RESULT_POSITION] == 0)
				{
					TextField(money[i]).text = "+" + tempMoney;
				}
				else
				{
					TextField(money[i]).textColor = 0xFF0000;
					TextField(money[i]).text = '-' + tempMoney;
				}*/
			}
		}
	}

}