package miniGame
{
	import com.greensock.TweenMax;
	import com.gsolo.encryption.MD5;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import miniGame.request.HTTPRequestMiniGame;
	import model.MainData;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class AwardInGamePopup extends MovieClip 
	{
		private var content:MovieClip;
		/**
		 * 1:mess, 2:mail
		 */
		public var typeOfReceive:int = 1; 
		private var _mask:MovieClip;
		/**
		 * 0:viettel, 1:mobi, 2:vina, 3: mega, 4:fpt
		 */
		public var typeCard:int;
		private var _typOfNetwork:String = "VTT"; // dang chon nap the bang nha mang nao
		private var arrBtn:Array = [];
		private var qualtityTurn:int;
		public function AwardInGamePopup() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			content = new AwardPopupMc();
			addChild(content);
			
			setupContent();
			
			config();
			
			
			addAllEvent();
		}
		
		private function config():void 
		{
			content.chooseCard.boardChooseCard.mask = content.chooseCard.boardChooseCard.maskMc;
			_mask = content.chooseCard.boardChooseCard.maskMc;
			content.chooseCard.typeOfCardTxt.mouseEnabled = false;
			content.chooseCard.typeOfCardTxt.text = "Viettel";
			
			for (var i:int = 0; i < GameDataMiniGame.getInstance().arrTypeOfCard.length; i++) 
			{
				var btn:MovieClip = new ChooseCardBoardBtn();
				btn["typeOfCardTxt"].mouseEnabled = false;
				btn["typeOfCardTxt"].text = GameDataMiniGame.getInstance().arrTypeOfCard[i];
				content.chooseCard.boardChooseCard.containerCard.addChild(btn);
				btn.buttonMode = true;
				btn.gotoAndStop(1);
				btn.y = 30 * i;
				arrBtn.push(btn);
				btn.addEventListener(MouseEvent.CLICK, onChoseCard);
				btn.addEventListener(MouseEvent.MOUSE_OVER, onOverCard);
				btn.addEventListener(MouseEvent.MOUSE_OUT, onOutCard);
			}
			
			
		}
		
		private function onOutCard(e:MouseEvent):void 
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.gotoAndStop(1);
		}
		
		private function onOverCard(e:MouseEvent):void 
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.gotoAndStop(2);
		}
		
		private function onChoseCard(e:MouseEvent):void 
		{
			var btn:MovieClip = e.currentTarget as MovieClip;
			typeCard = arrBtn.indexOf(btn);
			switch (typeCard) 
			{
				case 0:
					_typOfNetwork = "VTT";
				break;
				case 1:
					_typOfNetwork = "VMS";
				break;
				case 2:
					_typOfNetwork = "VNP";
				break;
				case 3:
					_typOfNetwork = "MGC";
				break;
				case 4:
					_typOfNetwork = "FPT";
				break;
				default:
			}
			content.chooseCard.typeOfCardTxt.text = btn["typeOfCardTxt"].text;
			
			TweenMax.to(_mask, .1, { y:-150 } );
		}
		
		private function addAllEvent():void 
		{
			//cho nut chon loai
			content.chooseTakeGift.phoneBtn.addEventListener(MouseEvent.CLICK, onChosePhone);
			content.chooseTakeGift.emailBtn.addEventListener(MouseEvent.CLICK, onChoseMail);
			
			//cho chon phone
			content.chosePhone.chooseAgainBtn.addEventListener(MouseEvent.CLICK, onChoseAgain);
			content.chosePhone.agreeBtn.addEventListener(MouseEvent.CLICK, onChoseReceiveGift);
			
			//cho chon mail
			content.choseMail.chooseAgainBtn.addEventListener(MouseEvent.CLICK, onChoseAgain);
			content.choseMail.agreeBtn.addEventListener(MouseEvent.CLICK, onChoseReceiveGift);
			
			//cho chon loai card
			content.chooseCard.chooseCardBtn.addEventListener(MouseEvent.CLICK, onChoseTypeOfCard);
			content.chooseCard.receiveGiftBtn.addEventListener(MouseEvent.CLICK, onAgreeReceiveGift);
			
			//đã chọn loại thẻ nhận
			content.showTime.closeBtn.addEventListener(MouseEvent.CLICK, onGettedGift);
			
			content.receiveSeri.closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			
			//mua them luot
			
			content.buyMoney.agreeBtn.addEventListener(MouseEvent.CLICK, onAgreeBuyTurn);
			content.buyMoney.closeBtn.addEventListener(MouseEvent.CLICK, onCloseBuyTurn);
		}
		
		private function onGettedGift(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ConstMiniGame.GET_GIFT_SUCCESS));
		}
		
		private function onClose(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ConstMiniGame.CLOSE_POPUP));
		}
		
		public function removeAllEvent():void 
		{
			//cho nut chon loai
			content.chooseTakeGift.phoneBtn.removeEventListener(MouseEvent.CLICK, onChosePhone);
			content.chooseTakeGift.emailBtn.removeEventListener(MouseEvent.CLICK, onChoseMail);
			
			//cho chon phone
			content.chosePhone.chooseAgainBtn.removeEventListener(MouseEvent.CLICK, onChoseAgain);
			content.chosePhone.agreeBtn.removeEventListener(MouseEvent.CLICK, onChoseReceiveGift);
			
			//cho chon mail
			content.choseMail.chooseAgainBtn.removeEventListener(MouseEvent.CLICK, onChoseAgain);
			content.choseMail.agreeBtn.removeEventListener(MouseEvent.CLICK, onChoseReceiveGift);
			
			//cho chon loai card
			content.chooseCard.chooseCardBtn.removeEventListener(MouseEvent.CLICK, onChoseTypeOfCard);
			content.chooseCard.receiveGiftBtn.removeEventListener(MouseEvent.CLICK, onAgreeReceiveGift);
			
			//đã chọn loại thẻ nhận
			content.showTime.closeBtn.removeEventListener(MouseEvent.CLICK, onClose);
			
			//mua them luot
			
			content.buyMoney.agreeBtn.removeEventListener(MouseEvent.CLICK, onAgreeBuyTurn);
			content.buyMoney.closeBtn.removeEventListener(MouseEvent.CLICK, onCloseBuyTurn);
		}
		
		private function onCloseBuyTurn(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ConstMiniGame.CLOSE_POPUP));
		}
		
		private function onChoseReceiveGift(e:MouseEvent):void 
		{
			sendLinkReceive();
		}
		
		private function onChoseMail(e:MouseEvent):void 
		{
			typeOfReceive = 2;
			setupContent();
			showBoard(2);
		}
		
		private function onChosePhone(e:MouseEvent):void 
		{
			typeOfReceive = 1;
			setupContent();
			showBoard(1);
		}
		
		private function onChoseAgain(e:MouseEvent):void 
		{
			setupContent();
			showBoard(0);
		}
		
		private function onAgreeBuyTurn(e:MouseEvent):void 
		{
			qualtityTurn = content.buyMoney.quanltityTxt.text;
			if (qualtityTurn * 10 > GameDataMiniGame.getInstance().myMoney) 
			{
				dispatchEvent(new Event(ConstMiniGame.ENOUGH_MONEY));
			}
			else 
			{
				var httpReq:HTTPRequestMiniGame = new HTTPRequestMiniGame();
				var method:String = "POST";
				var str:String = GameDataMiniGame.getInstance().linkReq + "Service02/OnplayShopExt.asmx/BuyEventTurnsFromClientSide";
				var obj:Object = new Object();
				
				obj["access_token"] = GameDataMiniGame.getInstance().token;
				obj["game_code"] = "10";
				obj["payment_type"] = "1";
				obj["nk_nm_receiver"] = GameDataMiniGame.getInstance().myId;
				obj["item_id"] = "1";
				obj["item_quantity"] = content.buyMoney.quanltityTxt.text;
				obj["client_hash"] = MD5.encrypt(obj["access_token"] + GameDataMiniGame.getInstance().client_secret + 
												obj["game_code"] + obj["payment_type"] + obj["nk_nm_receiver"] + 
												obj["item_id"] + obj["item_quantity"]);
				
				httpReq.sendRequest(method, str, obj, buyMyTurnComplete, true);
			}
			
		}
		
		private function buyMyTurnComplete(obj:Object):void 
		{
			if (obj.TypeMsg == 1) 
			{
				GameDataMiniGame.getInstance().myTurn = obj.Data.User_Turns;
				GameDataMiniGame.getInstance().myMoney = GameDataMiniGame.getInstance().myMoney - (qualtityTurn * 10);
				MainData.getInstance().chooseChannelData.myInfo.cash = GameDataMiniGame.getInstance().myMoney;
				MainData.getInstance().chooseChannelData.myInfo = MainData.getInstance().chooseChannelData.myInfo;
				dispatchEvent(new Event(ConstMiniGame.BUY_TURN_SUCCESS));
			}
			else 
			{
				dispatchEvent(new Event(ConstMiniGame.BUY_TURN_ERROR));
			}
			
			content.buyMoney.quanltityTxt.text = "10";
		}
		
		public function showChoseReceiveGift():void 
		{
			setupContent();
			showBoard(0);
		}
		
		public function showBuyTurn():void 
		{
			setupContent();
			showBoard(4);
		}
		
		private function onChoseTypeOfCard(e:MouseEvent):void 
		{
			TweenMax.to(_mask, .1, { y:0, onComplete:onShowChoseTypeOfCard } );
			
		}
		
		private function onShowChoseTypeOfCard():void 
		{
			stage.addEventListener(MouseEvent.CLICK, onCloseChoseTypeOfCard);
		}
		
		private function onCloseChoseTypeOfCard(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.CLICK, onCloseChoseTypeOfCard);
			
			TweenMax.to(_mask, .1, { y:-150} );
		}
		
		private function onAgreeReceiveGift(e:MouseEvent):void 
		{
			setupContent();
			
			//lay thong tin the cao
			var httpReq:HTTPRequestMiniGame = new HTTPRequestMiniGame();
			var method:String = "POST";
			var str:String = GameDataMiniGame.getInstance().linkReq + "Service02/OnplayGameEvent.asmx/Azgamebai_Take_Award";
			var obj:Object = new Object();
			
			obj["access_token"] = GameDataMiniGame.getInstance().token;
			obj["code"] = GameDataMiniGame.getInstance().cardGift[1];
			
			httpReq.sendRequest(method, str, obj, getGiftSuccess, true);
			
			
			
			
		}
		
		private function getGiftSuccess(obj:Object):void 
		{
			if (obj.TypeMsg == 1) 
			{
				showBoard(6);
			}
		}
		
		private function sendLinkReceive():void 
		{
			//gửi đi link nhận thưởng
			var httpReq:HTTPRequestMiniGame = new HTTPRequestMiniGame();
			var method:String = "POST";
			var str:String = GameDataMiniGame.getInstance().linkReq + "Service02/OnplayGameEvent.asmx/Azgamebai_Take_Award";
			var obj:Object = new Object();
			
			obj["access_token"] = GameDataMiniGame.getInstance().token;
			obj["code"] = GameDataMiniGame.getInstance().cardGift[1];
			obj["telco"] = _typOfNetwork;
			obj["type_id"] = typeOfReceive;
			
			httpReq.sendRequest(method, str, obj, receiveGiftSuccess, true);
		}
		
		private function receiveGiftSuccess(obj:Object):void 
		{
			
			if (obj.TypeMsg == 1) 
			{
				setupContent();
				dispatchEvent(new Event(ConstMiniGame.RECEIVE_GIFT_SUCCESS));
			}
			else 
			{
				dispatchEvent(new Event(ConstMiniGame.RECEIVE_GIFT_ERROR));
			}
		}
		
		private function setupContent():void 
		{
			content.chooseTakeGift.visible = false; // chon cach nhan qua
			content.chosePhone.visible = false; // nhan qua phone
			content.choseMail.visible = false; // nhan qua mail
			content.chooseCard.visible = false; //chon loai the neu trung duoc the dien thoai
			content.buyMoney.visible = false; // mua them luot choi
			
			content.chooseCard.boardChooseCard.mask = content.chooseCard.boardChooseCard.maskMc;
			content.chooseCard.boardChooseCard.maskMc.y = -150;
			content.chooseCard.typeOfCardTxt.text = "Viettel";
			
			if (GameDataMiniGame.getInstance().cardGift.length > 0) 
			{
				TextField(content.chosePhone._noticeText).text = GameDataMiniGame.getInstance().cardGift[1];
				TextField(content.choseMail._noticeText).text = GameDataMiniGame.getInstance().cardGift[1];
			
			}
			
			content.buyMoney.quanltityTxt.text = "10";
		}
		
		/**
		 * 0:chon loai, 1:chon phone, 2:chon mail, 3:chon loai card, 4:mua them luot
		 * @param	type
		 */
		public function showBoard(type:int, showText:String = ""):void 
		{
			content.chooseTakeGift.visible = false;
			content.chosePhone.visible = false;
			content.choseMail.visible = false;
			content.chooseCard.visible = false;
			content.buyMoney.visible = false;
			content.receiveSeri.visible = false;
			content.showTime.visible = false;
			
			switch (type) 
			{
				case 0:
					content.chooseTakeGift.visible = true;
				break;
				case 1:
					content.chosePhone.visible = true;
				break;
				case 2:
					content.choseMail.visible = true;
				break;
				case 3:
					content.chooseCard.visible = true;
				break;
				case 4:
					content.buyMoney.visible = true;
				break;
				case 5:
					content.receiveSeri.visible = true;
					content.receiveSeri.codeText.htmlText = showText;
				break;
				case 6:
					content.showTime.visible = true;
				break;
				default:
			}
		}
		
	}

}