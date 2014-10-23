package view.window 
{
	
	import control.ConstTlmn;
	import event.DataField;
	import flash.display.MovieClip;
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
	import model.GameDataTLMN;
	import model.MyDataTLMN;
	
	import sound.SoundManager;
	import view.card.CardTlmn;
	
	import view.Base;
	/**
	 * ...
	 * @author Yun
	 */
	public class ResultWindowTlmn extends Base 
	{
		
		private var mainData:GameDataTLMN = GameDataTLMN.getInstance();
		
		private var timerToClose:Timer;
		private var timerToCounDown:Timer;
		
		private var arrUserResult:Array;
		private var showUser:int;
		private var _win:Boolean = false;
		private var _top:int;
		
		
		public function ResultWindowTlmn() 
		{
			//createShadow();
			content = new ResultEndGame();
			addChild(content);
			content.close.visible = false;
			content.x = (1024 - content.width) / 2;
			content.y = (768 - content.height) / 2;
			//addButton();
			//resetInfo();
			arrUserResult = [];
			for (var i:int = 0; i < 4; i++) 
			{
				var obj:Object = new Object();
				obj["user"] = content.getChildByName("user" + String(i + 1));
				obj["cards"] = new Array();
				arrUserResult.push(obj);
			}
			content.close.visible = false;
			content.outGame.visible = false;
		}
		
		private function addEvent():void 
		{
			
		}
		
		public function open(checkShow:Boolean):void
		{
			
			timerToClose = new Timer(5000, 1);
			timerToClose.addEventListener(TimerEvent.TIMER_COMPLETE, onClose);
			timerToClose.start();
			
			timerToCounDown = new Timer(1000);
			timerToCounDown.addEventListener(TimerEvent.TIMER, onCoundDownToClose);
			timerToCounDown.start();
			content.timeRemain.text = '5';
			
			content.close.addEventListener(MouseEvent.CLICK, onCloseButtonClick);
			
			content.outGame.addEventListener(MouseEvent.CLICK, onOutGameClick);
			
			trace("check show winlose", checkShow)
			if (checkShow) 
			{
				
				//hideBg();
				
			}
			else 
			{
				
			}
			
			
			
		}
		
		private function hideBg():void 
		{
			var i:int;
			
			content.timeRemain.visible = false;
			for (i = 0; i < arrUserResult.length; i++) 
			{
				arrUserResult[i]["user"].visible = false;
			}
			content.close.visible = false;
			content.outGame.visible = false;
			
		}
		private function showBg():void 
		{
			var i:int;
			
			content.bg.visible = true;
			content.timeRemain.visible = true;
			
			//content.close.visible = true;
			content.outGame.visible = true;
			for (i = 0; i < showUser; i++) 
			{
				arrUserResult[i]["user"].visible = true;
			}
			for (i = showUser; i < arrUserResult.length; i++) 
			{
				arrUserResult[i]["user"].visible = false;
			}
		}
		
		private function onOutGameClick(e:MouseEvent):void 
		{
			dispatchEvent(new Event("out game"));
			onClose(null);
		}
		
		private function onCoundDownToClose(e:TimerEvent):void 
		{
			if (!stage)
			{
				Timer(e.currentTarget).removeEventListener(TimerEvent.TIMER, onCoundDownToClose);
				Timer(e.currentTarget).stop();
			}
			var tempNumber:int = int(content.timeRemain.text);
			tempNumber--;
			content.timeRemain.text = String(tempNumber);
		}
		
		private function onClose(e:TimerEvent):void 
		{
			if (!stage)
			{
				if (timerToClose)
				{
					timerToClose.removeEventListener(TimerEvent.TIMER_COMPLETE, onClose);
					timerToClose.stop();
					timerToCounDown.removeEventListener(TimerEvent.TIMER_COMPLETE, onCoundDownToClose);
					timerToCounDown.stop();
				}
			}
			if (timerToClose)
			{
				timerToClose.removeEventListener(TimerEvent.TIMER_COMPLETE, onClose);
				timerToClose.stop();
				timerToCounDown.removeEventListener(TimerEvent.TIMER_COMPLETE, onCoundDownToClose);
				timerToCounDown.stop();
			}
			for (var i:int = 0; i < arrUserResult.length; i++) 
			{
				for (var j:int = 0; j < arrUserResult[i]["cards"].length; j++) 
				{
					arrUserResult[i]["user"].removeChild(arrUserResult[i]["cards"][j]);
					arrUserResult[i]["cards"][j] = null;
				}
				
				arrUserResult[i]["cards"] = [];
			}
			
			content.outGame.removeEventListener(MouseEvent.CLICK, onOutGameClick);
			content.close.removeEventListener(MouseEvent.CLICK, onCloseButtonClick);
			dispatchEvent(new Event("close"));
			//close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function resetInfo():void 
		{
			
			//content.close.addEventListener(MouseEvent.CLICK, onCloseButtonClick);
			//content.close.visible = false;
			//timeCountDownToClose = content["timeCountDownToClose"];
			/*playerName = new Array();
			money = new Array();
			note = new Array();
			group = new Array();
			groupNumber = new Array();
			for (var i:int = 0; i < 4; i++) 
			{
				playerName.push(content["playerName_" + String(i + 1)]);
				money.push(content["money_" + String(i + 1)]);
				note.push(content["note_" + String(i + 1)]);
				groupNumber.push(content["groupNumber_" + String(i + 1)]);
				/*group[i] = new Array();
				for (var j:int = 0; j < 3; j++) 
				{
					group[i][j] = content["group" + String(i + 1) + "_" + String(j + 1)];
				}
			}
			for (i = 0; i < 4; i++)
			{
				TextField(playerName[i]).text = "";
				TextField(money[i]).text = "";
				TextField(note[i]).text = "";
				/*for (j = 0; j < 3; j++) 
				{
					group[i][j].text = "";
				}
			}*/
		}
		
		private function onCloseButtonClick(e:MouseEvent):void 
		{
			onClose(null);
		}
		
		private function addButton():void 
		{
			// tạo nút đóng cửa sổ
			//createButton("closeButton", 90, 18, onCloseWindow);
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			
		}
		
		public function setInfoWhiteWin(obj:Object):void
		{
			var i:int;
			var arrResult:Array = obj[ConstTlmn.PLAYER_LIST];
			arrResult.sortOn(ConstTlmn.MONEY, Array.NUMERIC);
			var count:int = 0;
			
			for (i = 0; i < arrUserResult.length; i++) 
			{
				trace("setinfowhitewin")
				trace(i, arrUserResult[i]["user"].myResult.visible)
				arrUserResult[i]["user"].myResult.visible = false;
				trace(i, arrUserResult[i]["user"].myResult.visible)
				
			}
			
			for (i = arrResult.length - 1; i > -1; i--) 
			//for (i = 0; i < arrResult.length; i++) 
			{
				trace("den thang nao duoc ghi ten: ", arrResult[i][ConstTlmn.DISPLAY_NAME])
				trace("tien: ", int(arrResult[i][ConstTlmn.MONEY]))
				if (arrResult[i][ConstTlmn.PLAYER_NAME] == MyDataTLMN.getInstance().myId) 
				{
					TextField(arrUserResult[count]["user"].userNameTxt).defaultTextFormat = _textformatUser;
					TextField(arrUserResult[count]["user"].betResultTxt).defaultTextFormat = _textformatMoney;
					arrUserResult[count]["user"].myResult.visible = true;
				}
				else 
				{
					TextField(arrUserResult[count]["user"].userNameTxt).defaultTextFormat = _textformatNormal;
					TextField(arrUserResult[count]["user"].betResultTxt).defaultTextFormat = _textformatNormalMoney;
					arrUserResult[count]["user"].myResult.visible = false;
				}
				TextField(arrUserResult[count]["user"].noticeTxt).defaultTextFormat = _textformatNormal;
				
				arrUserResult[count]["user"].userNameTxt.text = "  " + String(count + 1) + "  " + 
																arrResult[i][ConstTlmn.DISPLAY_NAME];
				
				if (int(arrResult[i][ConstTlmn.MONEY]) > 0) 
				{
					arrUserResult[count]["user"].betResultTxt.text = "+" + format(Number(arrResult[i][ConstTlmn.MONEY])) ;
					//TextField(arrUserResult[i]["user"].betResultTxt).defaultTextFormat = _textformatWin;
					trace("chi thang thang moi ddc add : ", obj["whiteWinType"])
					arrUserResult[count]["user"].noticeTxt.text = whiteWin(obj["whiteWinType"]) ;
					var str:String = arrUserResult[count]["user"].noticeTxt.text;
					if (str.length > 30) 
					{
						str = str.slice(0, 30);
						str += "...";
						arrUserResult[count]["user"].noticeTxt.text = str;
					}
					if (arrUserResult[count]["user"].userNameTxt.text != MyDataTLMN.getInstance().myName) 
					{
						//arrUserResult[i].user.win.visible = true;
						//arrUserResult[i].user.lose.visible = false;
					}
					else 
					{
						_win = true;
						
					}
				}
				else 
				{
					trace("thang thua ko add wintype")
					arrUserResult[count]["user"].betResultTxt.text = "-" + format(Number(arrResult[i][ConstTlmn.MONEY]) * -1) ;
					arrUserResult[count]["user"].noticeTxt.text = "";
				}
				
				count++;
				//addImageCard(arrResult[i]["cards"], arrUserResult[i]);
			}
		}
		
		private function whiteWin(type:String):String 
		{
			var result:String = "";
			
			switch (type) 
			{
				case "0":
					result = "Tứ quí 3";
				break;
				case "1":
					result = "3 đôi thông có 3 bích";
				break;
				case "2":
					result = "Tứ quí heo";
				break;
				case "3":
					result = "6 đôi";
				break;
				case "4":
					result = "5 đôi thông";
				break;
				case "5":
					result = "Sảnh rồng";
				break;
				case "6":
					result = "4 đôi thông có 3 bích";
				break;
				case "8":
					result = "4 sám";
				break;
				case "7":
					result = "2 tứ quí";
				break;
				default:
			}
			
			return result;
		}
		
		public function setInfo(obj:Object):void
		{
			
			var i:int;
			var arrResult:Array = obj["resultArr"];
			trace(arrResult)
			var objU:Object = arrResult[0];
			var count:int = 0;
			/*for (i = 0; i < arrResult.length; i++) 
			{
				if (arrResult[i][Const.MONEY]) 
				{
					if (int(arrResult[i][Const.MONEY]) > 0) 
					{
						
						arrResult[0] = arrResult[i];
						arrResult[i] = objU;
						break;
					}
				}
			}*/
			
			/*for (i = 0; i < arrUserResult.length; i++) 
			{
				arrUserResult[i].visible = false;
			}*/
			/**
			 * arrresult chua nhieu object
			 * moi obj chua:
				 * gameOverObject["userName"] : ten user
				 * gameOverObject["cards"] : mang chua cac id quan bai
				 * gameOverObject["money"] = data.getString("money"); tien dang co
					gameOverObject["subMoney"] = data.getString("subMoney"); :so tien bi tru
					gameOverObject["description"] = data.getString("description"); : thong bao thoi nhung cai j`
			 */
					
			for (i = 0; i < arrUserResult.length; i++) 
			{
				arrUserResult[i]["user"].myResult.visible = false;
				arrUserResult[i]["user"].visible = true;
			}
			if (obj["resultArr"]) 
			{
				for (i = 0; i < arrUserResult.length; i++) 
				{
					trace("setinfothuong")
					trace(i, arrUserResult[i]["user"].myResult.visible)
					arrUserResult[i]["user"].myResult.visible = false;
					trace(i, arrUserResult[i]["user"].myResult.visible)
				}
				arrResult.sortOn(ConstTlmn.SUB_MONEY, Array.NUMERIC);
				for (i = arrResult.length - 1; i > -1; i--) 
				{
					trace("den thang nao duoc ghi ten: ", arrResult[i][ConstTlmn.DISPLAY_NAME])
					if (arrResult[i][ConstTlmn.PLAYER_NAME] == MyDataTLMN.getInstance().myId) 
					{
						TextField(arrUserResult[count]["user"].userNameTxt).defaultTextFormat = _textformatUser;
						TextField(arrUserResult[count]["user"].betResultTxt).defaultTextFormat = _textformatMoney;
						arrUserResult[count]["user"].myResult.visible = true;
					}
					else 
					{
						TextField(arrUserResult[count]["user"].userNameTxt).defaultTextFormat = _textformatNormal;
						TextField(arrUserResult[count]["user"].betResultTxt).defaultTextFormat = _textformatNormalMoney;
						arrUserResult[count]["user"].myResult.visible = false;
					}
					TextField(arrUserResult[count]["user"].noticeTxt).defaultTextFormat = _textformatNormal;
					
					arrUserResult[count]["user"].userNameTxt.text = "  " + String(count + 1) + "  " + 
																	arrResult[i][ConstTlmn.DISPLAY_NAME];
					
					if (int(arrResult[i][ConstTlmn.SUB_MONEY]) > 0) 
					{
						arrUserResult[count]["user"].betResultTxt.text = "+" + format(Number(arrResult[i][ConstTlmn.SUB_MONEY])) ;
						//TextField(arrUserResult[i]["user"].betResultTxt).defaultTextFormat = _textformatWin;
						if (arrUserResult[count]["user"].userNameTxt.text != MyDataTLMN.getInstance().myName) 
						{
							//arrUserResult[i].user.win.visible = true;
							//arrUserResult[i].user.lose.visible = false;
						}
						else 
						{
							_win = true;
							
						}
					}
					else 
					{
						//TextField(arrUserResult[i]["user"].betResultTxt).defaultTextFormat = _textformatLose;
						arrUserResult[count]["user"].betResultTxt.text = "-" + format(Number(arrResult[i][ConstTlmn.SUB_MONEY]) * -1) ;
						
					}
					
					if (arrResult[i]["description"] != "Winner") 
					{
						trace("den thang nao duoc ghi thoi: ", arrResult[i]["description"])
						arrUserResult[count]["user"].noticeTxt.text = typeOfReamain(arrResult[i]["description"]);
						
						var str:String = arrUserResult[count]["user"].noticeTxt.text;
						if (str.length > 25) 
						{
							str = str.slice(0, 25);
							str += "...";
							arrUserResult[count]["user"].noticeTxt.text = str;
						}
					}
					else 
					{
						arrUserResult[count]["user"].noticeTxt.text = "";
					}
					count++;
					//addImageCard(arrResult[i]["cards"], arrUserResult[i]);
				}
			}
			
			/*
			for (i = 0; i < arrResult.length; i++) 
			{
				arrUserResult[i]["user"].visible = true;
				if (arrUserResult[i]["user"].userNameTxt.text == MyDataTLMN.getInstance().myName) 
				{
					_top = i;
				}
			}*/
			showUser = arrResult.length;
			for (i = arrResult.length; i < arrUserResult.length; i++) 
			{
				arrUserResult[i]["user"].visible = false;
			}
			
		}
		
		private function typeOfReamain(string:String):String 
		{
			var i:int;
			var str:String = "Thối ";
			var arrSpecial:Array = [];
			var checkcayle:Boolean = false;
			var checkThoitrang:Boolean = false;
			var count:int;
			
			string = string.split(",").join("");
			for (i = 0; i < string.length; i++) 
			{
				if (string.charAt(i) != ";") 
				{
					arrSpecial.push(string.charAt(i));
					if (string.charAt(i) == "8") 
					{
						checkThoitrang = true;
					}
				}
				else 
				{
					checkcayle = true;
					count = i;
					break;
				}
				
			}
			
			if (arrSpecial.length > 0) 
			{
				for (i = 0; i < arrSpecial.length; i++) 
				{
					switch (int(arrSpecial[i])) 
					{
						case 0:
						str += "ba bích, ";
						break;
						case 1:
						str += "hai đen, ";
						break;
						case 2:
						str += "hai đỏ, ";
						break;
						case 3:
						str += "đôi hai, ";
						break;
						case 4:
						str += "ba quân hai, ";
						break;
						case 5:
						str += "3 đôi thông, ";
						break;
						case 6:
						str += "tứ quý, ";
						break;
						case 7:
						str += "4 đôi thông, ";
						break;
						case 8:
						str += "trắng, ";
						break;
						default:
						str += "";
						break;
					}
				}
			}
			else 
			{
				str = "Thối ";
			}
			
			if (checkcayle) 
			{
				if (checkThoitrang) 
				{
					str = str.slice(0, str.length - 2);
					
				}
				else
				{
					var str1:String = "";
					if (arrSpecial.length > 0) 
					{
						
						for (i = count + 1; i < string.length; i++) 
						{
							str1 += string.charAt(i);
						}
						
						str += str1 + " cây";
					}
					else 
					{
						str1 = string.split(";").join("");
						str += str1 + " cây";
					}
				}
				
				
			}
			else 
			{
				
				var string1:String = "";
				var pos:int = str.indexOf(",");
				for(i = 0; i < pos; i++)
				{
					string1 += str.charAt(i);
				}
				str = string1;

			}
			//trace(str)
			return str;
		}
		
		private function addImageCard(array:Array, parentCard:Object):void 
		{
			if (array) 
			{
				var arr:Array = [];
				for (var i:int = 0; i < array.length; i++) 
				{
					var card:CardTlmn = new CardTlmn(array[i]);
					card.x = 100 + 14 * i;
					card.y = 60;
					card.scaleX = card.scaleY = 0.5;
					parentCard["user"].addChild(card);
					arr.push(card);
				}
				parentCard["cards"] = arr;
			}
			
		}
		
	}

}