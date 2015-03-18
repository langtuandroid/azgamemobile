package miniGame
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import miniGame.request.HTTPRequestMiniGame;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class HistoryBoard extends MovieClip 
	{
		private var content:MovieClip;
		private var page:int = 0;
		private var canClickNext:Boolean = true;
		private var arrChildBoard:Array;
		public var objGift:Object;
		private var arrButton:Array = [];
		public function HistoryBoard() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			//515, 271.5
		}
		
		private function onAddToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			content = new HistoryBoardMc();
			addChild(content);
			
			content.closeHistoryBoard.buttonMode = true;
			content.nextHistoryBtn.buttonMode = true;
			content.backHistoryBtn.buttonMode = true;
			
			content.closeHistoryBoard.addEventListener(MouseEvent.CLICK, onCloseBoard);
			content.nextHistoryBtn.addEventListener(MouseEvent.CLICK, onAddNextHis);
			content.backHistoryBtn.addEventListener(MouseEvent.CLICK, onAddBackHis);
			
		}
		
		private function onAddBackHis(e:MouseEvent):void 
		{
			if (page > 0) 
			{
				page--;
				addInfo();
				canClickNext = true;
			}
		}
		
		private function onAddNextHis(e:MouseEvent):void 
		{
			if (canClickNext) 
			{
				page++;
				addInfo();
			}
			
		}
		
		private function onCloseBoard(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ConstMiniGame.CLOSE_POPUP));
		}
		
		public function addInfo():void 
		{
			var httpReq:HTTPRequestMiniGame = new HTTPRequestMiniGame();
			var method:String = "POST";
			var str:String = GameDataMiniGame.getInstance().linkReq + "Service02/OnplayGameEvent.asmx/Azgamebai_GetListUserAwardHistories";
			var obj:Object = new Object();
			
			obj["row_start"] = page * 10 + 1;
			obj["row_end"] = (page + 1) * 10;
			obj["nick_name"] = GameDataMiniGame.getInstance().myId;
			
			httpReq.sendRequest(method, str, obj, showHistory, true);
		}
		
		private function converTime(str:String):String 
		{
			var result:String = "";
			var str1:String = str.substr(0, 8);
			var result1:String = formatDate(str1);
			var str2:String = str.substr(8, 6);
			var result2:String = formatDate(str2);
			
			result = result1 + "   " + result2;
			
			return result;
		}
		
		private function formatDate(str1:String):String 
		{
			
			var result1:String = "";
			
			var i:int;
			var count:int;
			for (i = 0; i < str1.length; i++) 
			{
				if (i < 5) 
				{
					if (count < 2) 
					{
						count++;
						result1 += str1.charAt(i);
						if (i == 3) 
						{
							result1 += ":";
						}
					}
					else 
					{
						result1 += ":";
						result1 += str1.charAt(i);
						count = 0;
					}
				}
				else 
				{
					result1 += str1.charAt(i);
				}
			}
			
			return result1;
		}
		
		
		protected function format(number:int):String 
		{
			
			var numString:String = number.toString();
			var result:String = '';
			
			while (numString.length > 3)
			{
					var chunk:String = numString.substr( -3);
					numString = numString.substr(0, numString.length - 3);
					result = ',' + chunk + result;
			}
			
			if (numString.length > 0)
			{
					result = numString + result;
			}

			return result;
		}
		
		private function showHistory(obj:Object):void 
		{
			removeAllHistory();
			
			var arr:Array = obj.Data;
			if (arr.length < 10) 
			{
				canClickNext = false;
			}
			
			arrButton = [];
			
			var tformat:TextFormat;
			
			for (var i:int = 0; i < arr.length; i++) 
			{
				var childBoard:MovieClip = new ContentHistoryMc();
				content.containerHistory.addChild(childBoard);
				arrChildBoard.push(childBoard);
				arrButton.push(childBoard.statusBtn);
				
				childBoard.timeTxt.mouseEnabled = false;
				childBoard.typeGiftTxt.mouseEnabled = false;
				childBoard.codeTxt.mouseEnabled = false;
				childBoard.typeReceiveTxt.mouseEnabled = false;
				childBoard.statusBtn.statusTxt.mouseEnabled = false;
				
				childBoard.timeTxt.text = converTime(arr[i].rgt_dtm);
				childBoard.typeGiftTxt.text = arr[i].name;
				childBoard.codeTxt.text = arr[i].code;
				childBoard.typeReceiveTxt.text = arr[i].type_id_string;
				//arr[i].status_string = "Chưa chọn";
				
				if (arr[i].status == 0) 
				{
					tformat = new TextFormat();
					tformat.underline = true;
					tformat.bold = true;
					
					TextField(childBoard.statusBtn.statusTxt).defaultTextFormat = tformat;
					
					childBoard.statusBtn.statusTxt.text = "Chưa chọn";
					childBoard.statusBtn.buttonMode = true;
					childBoard.statusBtn.addEventListener(MouseEvent.CLICK, onShowChoseGift);
				}
				else if (arr[i].status == 1) 
				{
					childBoard.statusBtn.statusTxt.text = "Đang xử lý";
					
				}
				else if (arr[i].status == 3) 
				{
					tformat = new TextFormat();
					tformat.underline = true;
					tformat.bold = true;
					tformat.color = 0xFF0000;
					TextField(childBoard.statusBtn.statusTxt).defaultTextFormat = tformat;
					TextField(childBoard.statusBtn.statusTxt).textColor = 0xFF0000;
					childBoard.statusBtn.statusTxt.text = "Chưa nhận";
					childBoard.statusBtn.buttonMode = true;
					childBoard.statusBtn.addEventListener(MouseEvent.CLICK, onShowCodeGift);
				}
				else if (arr[i].status == 2) 
				{
					
					if (arr[i].gold > 0) 
					{
						childBoard.statusBtn.statusTxt.text = "Đã nhận";
						
					}
					else 
					{
						tformat = new TextFormat();
						tformat.underline = true;
						TextField(childBoard.statusBtn.statusTxt).defaultTextFormat = tformat;
						childBoard.statusBtn.statusTxt.text = "Đã nhận";
						childBoard.statusBtn.buttonMode = true;
						childBoard.statusBtn.addEventListener(MouseEvent.CLICK, onShowCodeGift);
					}
					
				}
				
				childBoard.y = 28 * i;
			}
		}
		
		private function onShowCodeGift(e:MouseEvent):void 
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			var pos:int = arrButton.indexOf(mc);
			objGift = new Object();
			objGift.name = arrChildBoard[pos].typeGiftTxt.text;
			objGift.code = arrChildBoard[pos].codeTxt.text;
			dispatchEvent(new Event(ConstMiniGame.GET_GIFT_CODE));
		}
		
		private function onShowChoseGift(e:MouseEvent):void 
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			var pos:int = arrButton.indexOf(mc);
			objGift = new Object();
			objGift.name = arrChildBoard[pos].typeGiftTxt.text;
			objGift.code = arrChildBoard[pos].codeTxt.text;
			dispatchEvent(new Event(ConstMiniGame.SHOW_AWARD_AGAIN));
		}
		
		private function removeAllHistory():void 
		{
			if (arrChildBoard) 
			{
				for (var i:int = 0; i < arrChildBoard.length; i++) 
				{
					arrChildBoard[i].statusBtn.addEventListener(MouseEvent.CLICK, onShowChoseGift);
					content.containerHistory.removeChild(arrChildBoard[i]);
					arrChildBoard[i] = null;
				}
			}
			arrChildBoard = [];
		}
	}

}