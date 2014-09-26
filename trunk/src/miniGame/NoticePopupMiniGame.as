package miniGame
{
	
	import flash.display.MovieClip;
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author bimkute
	 */
	public class NoticePopupMiniGame extends MovieClip 
	{
		
		private var noticePopup:MovieClip;
		private var onGift:Boolean;
		
		public function NoticePopupMiniGame() 
		{
			noticePopup = new PopupMiniGame();
			addChild(noticePopup);
			
			noticePopup._noticeText.mouseEnabled = false;
			
			noticePopup.agreeBtn.addEventListener(MouseEvent.CLICK, onClickAgree);
			noticePopup.closeBtn.addEventListener(MouseEvent.CLICK, onClickCancel);
			noticePopup.buyChipBtn.addEventListener(MouseEvent.CLICK, onClickBuyChip);
			noticePopup.receiveGiftBtn.addEventListener(MouseEvent.CLICK, onAgreeReceive);
			noticePopup.buyTurnNowBtn.addEventListener(MouseEvent.CLICK, onClickBuyTurn);
		}
		
		private function onClickBuyTurn(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ConstMiniGame.BUY_TURN_NOW));
		}
		
		private function onAgreeReceive(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ConstMiniGame.RECEIVE_GIFT));
		}
		
		private function onClickBuyChip(e:MouseEvent):void 
		{
			navigateToURL(new URLRequest("http://sanhbai.com/nap-the.html"), "blank");
			dispatchEvent(new Event(ConstMiniGame.CLOSE_POPUP));
		}
		
		private function onClickAgree(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ConstMiniGame.CLOSE_POPUP));
		}
		
		private function onClickCancel(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ConstMiniGame.CLOSE_POPUP));
		}
		
		/**
			 * 1: nut dong y hien
			 * 2: nut thoat hien
			 * 3 ca 2 nut cung hien
			 * 4 dành cho nạp chip ko đủ tiền
			 */
		private function showButton(type:int):void 
		{
			
			switch (type) 
			{
				case 1:
					noticePopup.agreeBtn.visible = true;
					noticePopup.closeBtn.visible = false;
					noticePopup.buyChipBtn.visible = false;
					noticePopup.buyTurnNowBtn.visible = false;
					
				break;
				case 2:
					
					noticePopup.agreeBtn.visible = false;
					noticePopup.closeBtn.visible = true;
					noticePopup.buyTurnNowBtn.visible = false;
					noticePopup.buyChipBtn.visible = false;
				break;
				case 3:
					
					noticePopup.agreeBtn.visible = true;
					noticePopup.closeBtn.visible = true;
					noticePopup.buyTurnNowBtn.visible = false;
					noticePopup.buyChipBtn.visible = false;
				break;
				
				case 4:
					
					noticePopup.agreeBtn.visible = false;
					noticePopup.closeBtn.visible = true;
					noticePopup.buyTurnNowBtn.visible = false;
					noticePopup.buyChipBtn.visible = true;
				break;
				
				case 5:
					noticePopup.agreeBtn.visible = false;
					noticePopup.closeBtn.visible = true;
					noticePopup.buyTurnNowBtn.visible = true;
					noticePopup.buyChipBtn.visible = false;
				break;
				
				default:
					noticePopup.agreeBtn.visible = true;
					noticePopup.closeBtn.visible = true;
					noticePopup.buyChipBtn.visible = false;
			}
			
			if (onGift) 
			{
				if (GameDataMiniGame.getInstance().cardGift.length > 0) 
				{
					noticePopup.receiveGiftBtn.visible = true;
				}
				else 
				{
					noticePopup.receiveGiftBtn.visible = false;
				}
			}
			else 
			{
				noticePopup.receiveGiftBtn.visible = false;
			}
		}
		
		public function addText(str:String, type:Boolean = false):void 
		{
			if (type) 
			{
				noticePopup.noticeGiftTxt1.text = "Bạn đã rút được lá bài may mắn";
				noticePopup.noticeGiftTxt2.text = str;
				noticePopup._noticeText.text = "";
				noticePopup.titleTxt.text = "CHÚC MỪNG";
			}
			else 
			{
				noticePopup.titleTxt.text = "THÔNG BÁO";
				noticePopup._noticeText.text = str;
				noticePopup.noticeGiftTxt1.text = "";
				noticePopup.noticeGiftTxt2.text = "";
			
				
			}
			
			onGift = type;
			
			var typeBtn:int = setTypeShowButton(str);
				
			showButton(typeBtn);
			
		}
		
		private function setTypeShowButton(str:String):int 
		{
			var type:int;
			
			switch (str) 
			{
				
				case ConstMiniGame.ENOUGH_MONEY_TEXT:
					type = 4;
				break;
				case ConstMiniGame.ENOUGH_TURN_TEXT:
					type = 5;
				break;
				
				default:
					type = 2;
			}
			
			return type;
		}
	}

}