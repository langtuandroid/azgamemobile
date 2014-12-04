package miniGame
{
	import com.greensock.TweenMax;
	//import control.ConstTlmn;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.ShaderPrecision;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	import miniGame.request.HTTPRequestMiniGame;
	import model.MainData;
	import sound.SoundManager;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class PlayGameScreenMiniGame extends MovieClip 
	{
		private var content:MovieClip;
		private var arrCard:Array = [];
		private var arrPosCard:Array = [];
		
		private var myTurn:int = 10;
		
		private var arrCardDeck:Array = [];
		
		private var timerHidCard:Timer;
		private var countCard:int;
		private var timerShowCardDeck:Timer;
		private var timerDealCardDeck:Timer;
		
		private var timerShowAllCard:Timer;
		private var timerShowAwardPopup:Timer;
		private var timerShowNoticePopup:Timer;
		
		private var startX:Number = 480;
		private var startY:Number = 70;
		
		private var awardPopup:AwardInGamePopup;
		private var _main:MainMiniGame;
		private var historyBoard:HistoryBoard;
		private var goldGift:Boolean = false;
		
		private var gameLayer:Sprite;
		private var popupLayer:Sprite;
		public var receivingGift:Boolean = false;
		/**
		 * dung de biet vua chon card o vi tri nao
		 */
		private var pos:int;
		
		private var male:Boolean = false;
		
		public var on:Boolean = false;
		
		public function PlayGameScreenMiniGame(main:MainMiniGame) 
		{
			super();
			
			_main = main;
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
		}
		
		private function onAddToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			
			gameLayer = new Sprite();
			addChild(gameLayer);
			popupLayer = new Sprite();
			addChild(popupLayer);
			
			content = new PlayGameMc();
			gameLayer.addChild(content);
			
			//content.resultTxt.text = "v1.1"
			
			arrCard = [content.card1, content.card2, content.card3, content.card4, content.card5,
						content.card6, content.card7, content.card8, content.card9, content.card10
					];
			arrPosCard = [[content.card1.x, content.card1.y], [content.card2.x, content.card2.y], 
							[content.card3.x, content.card3.y], [content.card4.x, content.card4.y],
							[content.card5.x, content.card5.y], [content.card6.x, content.card6.y],
							[content.card7.x, content.card7.y], [content.card8.x, content.card8.y],
							[content.card9.x, content.card9.y], [content.card10.x, content.card10.y]
					];
			var rd:int = Math.ceil(Math.random() * 2);
			content.userDealCard.gotoAndStop(rd);
			if (rd == 1) 
			{
				male = false;
			}
			else 
			{
				male = true;
			}
			
			myTurn = GameDataMiniGame.getInstance().myTurn;
			
			setupContent();
			
			addAllEvent();
			
			addPopup();
		}
		
		private function addPopup():void 
		{
			if (!awardPopup) 
			{
				awardPopup = new AwardInGamePopup();
				popupLayer.addChild(awardPopup);
				awardPopup.visible = false;
				awardPopup.addEventListener(ConstMiniGame.BUY_TURN_ERROR, onBuyError);
				awardPopup.addEventListener(ConstMiniGame.BUY_TURN_SUCCESS, onBuySuccess);
				awardPopup.addEventListener(ConstMiniGame.ENOUGH_MONEY, onNotEnoughMoney);
				awardPopup.addEventListener(ConstMiniGame.BUY_TURN, onNotBuyTurn);
				awardPopup.addEventListener(ConstMiniGame.RECEIVE_GIFT_ERROR, onReceiveGiftError);
				awardPopup.addEventListener(ConstMiniGame.RECEIVE_GIFT_SUCCESS, onReceiveGiftSuccess);
				awardPopup.addEventListener(ConstMiniGame.CLOSE_POPUP, onCloseBuyTurn);
				
				//awardPopup.showBoard(3);
			}
			if (!historyBoard) 
			{
				historyBoard = new HistoryBoard();
				popupLayer.addChild(historyBoard);
				historyBoard.visible = false;
				historyBoard.x = 515;
				historyBoard.y = 271.5;
				historyBoard.addEventListener(ConstMiniGame.CLOSE_POPUP, onCloseHistory);
				historyBoard.addEventListener(ConstMiniGame.SHOW_AWARD_AGAIN, onShowWard);
			}
		}
		
		private function onNotBuyTurn(e:Event):void 
		{
			if (_main) 
			{
				_main.noticeGame(ConstMiniGame.BUY_TURN_TEXT);
				
			}
		}
		
		private function onCloseBuyTurn(e:Event):void 
		{
			if (awardPopup) 
			{
				awardPopup.visible = false;
				
			}
		}
		
		private function onShowWard(e:Event):void 
		{
			GameDataMiniGame.getInstance().goldGift = [];
			GameDataMiniGame.getInstance().cardGift = [historyBoard.objGift.name, historyBoard.objGift.code];
			
			if (timerShowAwardPopup) 
			{
				timerShowAwardPopup.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowAwardPopup);
				timerShowAwardPopup.stop();
			}
			
			if (historyBoard) 
			{
				historyBoard.visible = false;
			}
			
			showAward();
			
			/*if (awardPopup) 
			{
				awardPopup.visible = true;
				awardPopup.showChoseReceiveGift();
			}*/
		}
		
		private function onCloseHistory(e:Event):void 
		{
			if (historyBoard) 
			{
				historyBoard.visible = false;
			}
		}
		
		private function onReceiveGiftSuccess(e:Event):void 
		{
			receivingGift = false;
			
			setupContent();
		}
		
		private function onReceiveGiftError(e:Event):void 
		{
			setupContent();
		}
		
		private function onNotEnoughMoney(e:Event):void 
		{
			if (_main) 
			{
				_main.noticeGame(ConstMiniGame.ENOUGH_MONEY_TEXT);
				if (GameDataMiniGame.getInstance().myMoney < 10) 
				{
					awardPopup.visible = false;
				}
				
			}
		}
		
		private function onBuySuccess(e:Event):void 
		{
			if (_main) 
			{
				_main.noticeGame(ConstMiniGame.BUY_TURN_SUCCESS_TEXT);
				
			}
			myTurn = GameDataMiniGame.getInstance().myTurn;
			if (myTurn > 9) 
			{
				content.countTimePlayTxt.text = "Lượt rút: " + String(myTurn);
			}
			else 
			{
				content.countTimePlayTxt.text = "Lượt rút: 0" + String(myTurn);
			}
			awardPopup.visible = false;
		}
		
		private function onBuyError(e:Event):void 
		{
			if (_main) 
			{
				_main.noticeGame(ConstMiniGame.BUY_TURN_ERROR_TEXT);
				
			}
			
			awardPopup.visible = false;
		}
		
		private function onRemoveStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			
			removeAllEvent();
			gameLayer.removeChild(content);
			content = null;
		}
		
		private function onShowGift(e:MouseEvent):void 
		{
			var cardDeck:MovieClip = e.currentTarget as MovieClip;
			pos = arrCardDeck.indexOf(cardDeck);
			
			for (var i:int = 0; i < arrCardDeck.length; i++) 
			{
				arrCardDeck[i].buttonMode = false;
				arrCardDeck[i].removeEventListener(MouseEvent.CLICK, onShowGift);
			}
			
			var httpReq:HTTPRequestMiniGame = new HTTPRequestMiniGame();
			var method:String = "POST";
			var str:String = GameDataMiniGame.getInstance().linkReq + "Service02/OnplayGameEvent.asmx/Azgamebai_Turn";
			var obj:Object = new Object();
			
			obj["access_token"] = GameDataMiniGame.getInstance().token;
			
			httpReq.sendRequest(method, str, obj, showResultGame, true);
			
		}
		
		private function showResultGame(obj:Object):void 
		{
			
			if (obj.TypeMsg == 1) 
			{
				SoundManager.getInstance().playSound(ConstMiniGame.SOUND_WIN);	
				
				
						
				myTurn--;
				TweenMax.to(arrCardDeck[pos], .5, { scaleX:0} );
			
				arrCard[pos].x = arrPosCard[pos][0];
				arrCard[pos].y = arrPosCard[pos][1];
				arrCard[pos].scaleY = 1;
				TweenMax.to(arrCard[pos], .5, { scaleX:1 } );
				arrCard[pos].borderCard.visible = true;
				arrCard[pos].visible = true;
				
				receivingGift = true;
				
				if (obj.Data.Gold > 0) 
				{
					GameDataMiniGame.getInstance().goldGift = [obj.Data.Gold, obj.Data.Name];
					GameDataMiniGame.getInstance().cardGift = [];
					
					goldGift = true;
					
				}
				else if (obj.Data.Card_Value > 0) 
				{
					GameDataMiniGame.getInstance().goldGift = [];
					GameDataMiniGame.getInstance().cardGift = [obj.Data.Card_Value, obj.Data.Code, obj.Data.Name];
					goldGift = false;
				}
				
				//content.resultTxt.text = obj.Data.Card_Value + "-" + obj.Data.Code + "-" + obj.Data.Name + "-" + obj.Data.Gold;
				
				var arr:Array = [];
				var arr1:Array = [];
				var i:int;
				var loader:Loader;
				
				for (i = 0; i < GameDataMiniGame.getInstance().arrGift.length; i++) 
				{
					arr1.push(GameDataMiniGame.getInstance().arrGift[i][0]);
					arr.push(GameDataMiniGame.getInstance().arrGift[i][1]);
				}
				
				for (i = 0; i < arrCard.length; i++) 
				{
					if (arr1[i] == obj.Data.Name) 
					{
						if (arrCard[pos].containerGiftImage.numChildren > 0) 
						{
							arrCard[pos].containerGiftImage.removeChild(arrCard[pos].containerGiftImage.getChildAt(0));
						}
						
						
						loader = arr[i];
						
						arrCard[pos].containerGiftImage.addChild(loader);
						TextField(arrCard[pos].txt).text = "";// arr[i];
						
						arr1.splice(i, 1);
						arr.splice(i, 1);
						break;
					}
				}
				
				for (i = 0; i < arrCard.length; i++) 
				{
					if (i != pos) 
					{
						var rd:int = int(Math.random() * arr1.length);
						
						if (arrCard[i].containerGiftImage.numChildren > 0) 
						{
							arrCard[i].containerGiftImage.removeChild(arrCard[i].containerGiftImage.getChildAt(0));
						}
						
						loader = arr[rd];
						
						arr.splice(rd, 1);
						arr1.splice(rd, 1);
						
						arrCard[i].containerGiftImage.addChild(loader);
						
						
						arrCard[i].txt.text = "";// arr.splice(rd, 1);
						arrCard[i].scaleX = arrCard[i].scaleY = 0;
					}
				}
				
				if (timerShowAllCard) 
				{
					timerShowAllCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowAllCard);
					timerShowAllCard.stop();
				}
				if (timerShowAwardPopup) 
				{
					timerShowAwardPopup.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowAwardPopup);
					timerShowAwardPopup.stop();
				}
				if (timerShowNoticePopup) 
				{
					timerShowNoticePopup.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowNoticePopup);
					timerShowNoticePopup.stop();
				}
				
				timerShowAllCard = new Timer(1000, 2);
				timerShowAllCard.addEventListener(TimerEvent.TIMER_COMPLETE, onShowAllCard);
				timerShowAllCard.start();
				
				if (obj.Data.Card_Value > 0)
				{
					timerShowAwardPopup = new Timer(1000, 5);
					timerShowAwardPopup.addEventListener(TimerEvent.TIMER_COMPLETE, onShowAwardPopup);
					timerShowAwardPopup.start();
				}
				else if (obj.Data.Gold > 0)
				{
					timerShowNoticePopup = new Timer(1000, 4);
					timerShowNoticePopup.addEventListener(TimerEvent.TIMER_COMPLETE, onShowNoticePopup);
					timerShowNoticePopup.start();
				}
				
				
			}
			else 
			{
				_main.noticeGame(ConstMiniGame.PLAY_GAME_ERROR_TEXT);
				//setupContent();
			}
			
		}
		
		private function onShowNoticePopup(e:TimerEvent):void 
		{
			if (timerShowNoticePopup) 
			{
				timerShowNoticePopup.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowNoticePopup);
				timerShowNoticePopup.stop();
			}
			if (goldGift) 
			{
				var rd:int = int(Math.random() * 3);
				if (male) 
				{
					SoundManager.getInstance().playSound(ConstMiniGame.M_WIN_ + String(rd + 1) );	
				}
				else 
				{
					SoundManager.getInstance().playSound(ConstMiniGame.FE_WIN_ + String(rd + 1) );	
				}
				
				MainData.getInstance().chooseChannelData.myInfo.money = MainData.getInstance().chooseChannelData.myInfo.money + Number(GameDataMiniGame.getInstance().goldGift[0]);
				MainData.getInstance().chooseChannelData.myInfo = MainData.getInstance().chooseChannelData.myInfo;
				_main.noticeGame(GameDataMiniGame.getInstance().goldGift[1], true);
				setupContent();
				goldGift = false;
			}
			receivingGift = false;
		}
		
		private function onShowAwardPopup(e:TimerEvent):void 
		{
			if (timerShowAwardPopup) 
			{
				timerShowAwardPopup.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowAwardPopup);
				timerShowAwardPopup.stop();
			}
			
			
			var rd:int = int(Math.random() * 3);
			if (male) 
			{
				SoundManager.getInstance().playSound(ConstMiniGame.M_WIN_ + String(rd + 1) );	
			}
			else 
			{
				SoundManager.getInstance().playSound(ConstMiniGame.FE_WIN_ + String(rd + 1) );	
			}
				
			_main.noticeGame(GameDataMiniGame.getInstance().cardGift[2], true);
			
			/*if (awardPopup) 
			{
				awardPopup.visible = true;
				awardPopup.showChoseReceiveGift();
			}*/
		}
		
		public function showAward():void 
		{
			if (awardPopup) 
			{
				awardPopup.visible = true;
				awardPopup.showBoard(3);
			}
		}
		
		private function onShowAllCard(e:TimerEvent):void 
		{
			if (timerShowAllCard) 
			{
				timerShowAllCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowAllCard);
				timerShowAllCard.stop();
			}
			
			for (var i:int = 0; i < arrCard.length; i++) 
			{
				if (i != pos) 
				{
					TweenMax.to(arrCardDeck[i], .5, { scaleX:0} );
					arrCard[i].x = arrPosCard[i][0];
					arrCard[i].y = arrPosCard[i][1];
					arrCard[i].scaleY = 1;
					TweenMax.to(arrCard[i], .5, { scaleX:1 } );
					arrCard[i].borderCard.visible = false;
					arrCard[i].visible = true;
				}
			}
			
			
		}
		
		private function addAllEvent():void 
		{
			content.closeGameBtn.buttonMode = true;
			content.startGameMc.addEventListener(MouseEvent.CLICK, onStartGame);
			content.historyBtn.addEventListener(MouseEvent.CLICK, onShowHistoryGame);
			content.buyTurnMc.addEventListener(MouseEvent.CLICK, onBuyTurnGame);
			content.closeGameBtn.addEventListener(MouseEvent.CLICK, onCloseGame);
		}
		
		private function onCloseGame(e:MouseEvent):void 
		{
			removeAllEvent();
			dispatchEvent(new Event(ConstMiniGame.CLOSE_POPUP));
		}
		
		public function removeAllEvent():void 
		{
			removeAllCardDeck();
			
			if (timerShowAllCard) 
			{
				timerShowAllCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowAllCard);
				timerShowAllCard.stop();
			}
			if (timerShowAwardPopup) 
			{
				timerShowAwardPopup.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowAwardPopup);
				timerShowAwardPopup.stop();
			}
			if (timerShowNoticePopup) 
			{
				timerShowNoticePopup.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowNoticePopup);
				timerShowNoticePopup.stop();
			}
				
			if (timerHidCard) 
			{
				timerHidCard.removeEventListener(TimerEvent.TIMER, onHideCard);
				timerHidCard.removeEventListener(TimerEvent.TIMER, onHideCardDeck);
				timerHidCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onHideCardComplete);
				timerHidCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onHideCardDeckComplete);
				timerHidCard.stop();
			}
			
			if (timerShowCardDeck) 
			{
				timerShowCardDeck.removeEventListener(TimerEvent.TIMER, onShowCardDeck);
				timerShowCardDeck.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowCardDeckComplete);
				timerShowCardDeck.stop();
			}
			
			if (timerDealCardDeck) 
			{
				
				timerDealCardDeck.removeEventListener(TimerEvent.TIMER_COMPLETE, onDealCardDeckComplete);
				timerDealCardDeck.stop();
			}
			
			if (awardPopup) 
			{
				awardPopup.removeEventListener(ConstMiniGame.BUY_TURN_ERROR, onBuyError);
				awardPopup.removeEventListener(ConstMiniGame.BUY_TURN_SUCCESS, onBuySuccess);
				awardPopup.removeEventListener(ConstMiniGame.ENOUGH_MONEY, onNotEnoughMoney);
				awardPopup.removeEventListener(ConstMiniGame.BUY_TURN, onNotBuyTurn);
				awardPopup.removeEventListener(ConstMiniGame.RECEIVE_GIFT_ERROR, onReceiveGiftError);
				awardPopup.removeEventListener(ConstMiniGame.RECEIVE_GIFT_SUCCESS, onReceiveGiftSuccess);
			}
			if (historyBoard) 
			{
				
				historyBoard.removeEventListener(ConstMiniGame.CLOSE_POPUP, onCloseHistory);
				historyBoard.removeEventListener(ConstMiniGame.SHOW_AWARD_AGAIN, onShowWard);
			}
			
			
			content.startGameMc.removeEventListener(MouseEvent.CLICK, onStartGame);
			content.historyBtn.removeEventListener(MouseEvent.CLICK, onShowHistoryGame);
			content.buyTurnMc.removeEventListener(MouseEvent.CLICK, onBuyTurnGame);
			
			TweenMax.killChildTweensOf(this);
		}
		
		private function removeAllCardDeck():void 
		{
			
			
			for (var i:int = 0; i < arrCardDeck.length; i++) 
			{
				arrCardDeck[i].removeEventListener(MouseEvent.CLICK, onShowGift);
				content.removeChild(arrCardDeck[i]);
				arrCardDeck[i] = null;
			}
			arrCardDeck = [];
		}
		
		private function onHideCard(e:TimerEvent):void 
		{
			countCard++;
			
			TweenMax.to(arrCard[countCard], .5, { scaleX:0} );
			var cardDeck:MovieClip = new CardDeckMiniGame();
			content.addChild(cardDeck);
			cardDeck.x = arrCard[countCard].x;
			cardDeck.y = arrCard[countCard].y;
			cardDeck.scaleX = 0;
			arrCardDeck.push(cardDeck);
			TweenMax.to(cardDeck, .5, { scaleX:1} );
		}
		
		private function onHideCardComplete(e:TimerEvent):void 
		{
			
			if (timerHidCard) 
			{
				timerHidCard.removeEventListener(TimerEvent.TIMER, onHideCard);
				timerHidCard.removeEventListener(TimerEvent.TIMER, onHideCardDeck);
				timerHidCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onHideCardComplete);
				timerHidCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onHideCardDeckComplete);
				timerHidCard.stop();
			}
			
			if (timerShowCardDeck) 
			{
				timerShowCardDeck.removeEventListener(TimerEvent.TIMER, onShowCardDeck);
				timerShowCardDeck.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowCardDeckComplete);
				timerShowCardDeck.stop();
			}
			
			if (timerDealCardDeck) 
			{
				
				timerDealCardDeck.removeEventListener(TimerEvent.TIMER_COMPLETE, onDealCardDeckComplete);
				timerDealCardDeck.stop();
			}
			
			SoundManager.getInstance().playSound(ConstMiniGame.SOUND_DEAL_DISCARD);
			countCard = 0;
			TweenMax.to(arrCardDeck[countCard], .5, { x:startX, y:startY, scaleX:0, scaleY:0} );
			timerHidCard = new Timer(100, 9);
			timerHidCard.addEventListener(TimerEvent.TIMER, onHideCardDeck);
			timerHidCard.addEventListener(TimerEvent.TIMER_COMPLETE, onHideCardDeckComplete);
			timerHidCard.start();
			
			
		}
		
		private function onHideCardDeckComplete(e:TimerEvent):void 
		{
			if (timerHidCard) 
			{
				timerHidCard.removeEventListener(TimerEvent.TIMER, onHideCard);
				timerHidCard.removeEventListener(TimerEvent.TIMER, onHideCardDeck);
				timerHidCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onHideCardComplete);
				timerHidCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onHideCardDeckComplete);
				timerHidCard.stop();
			}
			
			if (timerShowCardDeck) 
			{
				timerShowCardDeck.removeEventListener(TimerEvent.TIMER, onShowCardDeck);
				timerShowCardDeck.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowCardDeckComplete);
				timerShowCardDeck.stop();
			}
			
			if (timerDealCardDeck) 
			{
				
				timerDealCardDeck.removeEventListener(TimerEvent.TIMER_COMPLETE, onDealCardDeckComplete);
				timerDealCardDeck.stop();
			}
			
			if (countCard == 9) 
			{
				countCard = 0;
				
				
				timerDealCardDeck = new Timer(500, 1);
				timerDealCardDeck.addEventListener(TimerEvent.TIMER_COMPLETE, onDealCardDeckComplete);
				timerDealCardDeck.start();
				
				
			}
		}
		
		private function onHideCardDeck(e:TimerEvent):void 
		{
			SoundManager.getInstance().playSound(ConstMiniGame.SOUND_DEAL_DISCARD);
			countCard++;
			TweenMax.to(arrCardDeck[countCard], .5, { x:startX, y:startY, scaleX:0, scaleY:0} );
		}
		
		private function onDealCardDeckComplete(e:TimerEvent):void 
		{
			if (timerDealCardDeck) 
			{
				
				timerDealCardDeck.removeEventListener(TimerEvent.TIMER_COMPLETE, onDealCardDeckComplete);
				timerDealCardDeck.stop();
			}
			
			removeAllCardDeck();
			
			SoundManager.getInstance().playSound(ConstMiniGame.SOUND_DEAL_DISCARD);
			var cardDeck:MovieClip = new CardDeckMiniGame();
			content.addChild(cardDeck);
			cardDeck.x = startX;
			cardDeck.y = startY;
			cardDeck.scaleX = cardDeck.scaleY = 0;
			arrCardDeck.push(cardDeck);
			TweenMax.to(arrCardDeck[countCard], .5, { x:arrPosCard[countCard][0], y:arrPosCard[countCard][1], 
													scaleX:1, scaleY:1} );
			
			timerShowCardDeck = new Timer(100, 14);
			timerShowCardDeck.addEventListener(TimerEvent.TIMER, onShowCardDeck);
			timerShowCardDeck.addEventListener(TimerEvent.TIMER_COMPLETE, onShowCardDeckComplete);
			timerShowCardDeck.start();
		}
		
		private function onShowCardDeck(e:TimerEvent):void 
		{
			countCard++;
			if (countCard < 10) 
			{
				SoundManager.getInstance().playSound(ConstMiniGame.SOUND_DEAL_DISCARD);
				var cardDeck:MovieClip = new CardDeckMiniGame();
				content.addChild(cardDeck);
				cardDeck.x = startX;
				cardDeck.y = startY;
				cardDeck.scaleX = cardDeck.scaleY = 0;
				arrCardDeck.push(cardDeck);
				TweenMax.to(arrCardDeck[countCard], .5, { x:arrPosCard[countCard][0], y:arrPosCard[countCard][1], 
														scaleX:1, scaleY:1 } );
			}
			
														
		}
		
		private function onShowCardDeckComplete(e:TimerEvent):void 
		{
			if (timerHidCard) 
			{
				timerHidCard.removeEventListener(TimerEvent.TIMER, onHideCard);
				timerHidCard.removeEventListener(TimerEvent.TIMER, onHideCardDeck);
				timerHidCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onHideCardComplete);
				timerHidCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onHideCardDeckComplete);
				timerHidCard.stop();
			}
			
			if (timerShowCardDeck) 
			{
				timerShowCardDeck.removeEventListener(TimerEvent.TIMER, onShowCardDeck);
				timerShowCardDeck.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowCardDeckComplete);
				timerShowCardDeck.stop();
			}
			
			content.noticeTxt.visible = true;
			
			for (var i:int = 0; i < arrCardDeck.length; i++) 
			{
				arrCardDeck[i].buttonMode = true;
				arrCardDeck[i].addEventListener(MouseEvent.CLICK, onShowGift);
			}
		}
		
		private function onStartGame(e:MouseEvent):void 
		{
			if (myTurn > 0) 
			{
				content.startGameMc.visible = false;
				
				countCard = 0;
				
				if (timerHidCard) 
				{
					timerHidCard.removeEventListener(TimerEvent.TIMER, onHideCard);
					timerHidCard.removeEventListener(TimerEvent.TIMER, onHideCardDeck);
					timerHidCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onHideCardComplete);
					timerHidCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onHideCardDeckComplete);
					timerHidCard.stop();
				}
				
				TweenMax.to(arrCard[countCard], .5, { scaleX:0} );
				var cardDeck:MovieClip = new CardDeckMiniGame();
				content.addChild(cardDeck);
				cardDeck.x = arrCard[countCard].x;
				cardDeck.y = arrCard[countCard].y;
				cardDeck.scaleX = 0;
				arrCardDeck.push(cardDeck);
				TweenMax.to(cardDeck, .5, { scaleX:1} );
				
				timerHidCard = new Timer(100, 9);
				timerHidCard.addEventListener(TimerEvent.TIMER, onHideCard);
				timerHidCard.addEventListener(TimerEvent.TIMER_COMPLETE, onHideCardComplete);
				timerHidCard.start();
			}
			else 
			{
				_main.noticeGame(ConstMiniGame.ENOUGH_TURN_TEXT);
			}
			
			
		}
		
		private function onShowHistoryGame(e:MouseEvent):void 
		{
			//lịch sử chơi
			if (historyBoard) 
			{
				historyBoard.visible = true;
				historyBoard.addInfo();
			}
		}
		
		private function onBuyTurnGame(e:MouseEvent):void 
		{
			if (GameDataMiniGame.getInstance().myMoney < 10) 
			{
				if (_main) 
				{
					_main.noticeGame(ConstMiniGame.ENOUGH_MONEY_TEXT);
					
				}
			}
			else 
			{
				showBuyTurn();
			}
		}
		
		public function showBuyTurn():void 
		{
			if (awardPopup) 
			{
				awardPopup.showBuyTurn();
				awardPopup.visible = true;
			}
		}
		
		public function setupContent():void 
		{
			var arr:Array = [];
			var i:int;
			for (i = 0; i < GameDataMiniGame.getInstance().arrGift.length; i++) 
			{
				arr.push(GameDataMiniGame.getInstance().arrGift[i][1]);
			}
			
			if (!on) 
			{
				for (i = 0; i < arrCard.length; i++) 
				{
					var rd:int = int(Math.random() * arr.length);
					
					var loader:Loader = arr[rd];
					arr.splice(rd, 1);
					
					if (arrCard[i].containerGiftImage.numChildren > 0) 
					{
						arrCard[i].containerGiftImage.removeChild(arrCard[i].containerGiftImage.getChildAt(0));
					}
					arrCard[i].containerGiftImage.addChild(loader);
					
					arrCard[i].visible = true;
					arrCard[i].scaleX = arrCard[i].scaleY = 1;
					arrCard[i].x = arrPosCard[i][0];
					arrCard[i].y = arrPosCard[i][1];
					
					arrCard[i].txt.text = "";// arr.splice(rd, 1);
					arrCard[i].txt.mouseEnabled = false;
					arrCard[i].borderCard.visible = false;
				}
				on = true;
			}
			else 
			{
				for (i = 0; i < arrCard.length; i++) 
				{
					arrCard[i].txt.mouseEnabled = false;
					arrCard[i].borderCard.visible = false;
				}
			}
			
			
			removeAllCardDeck();
			
			//content.noticeTxt.mouseEnabled = false;
			content.noticeTxt.visible = false;
			content.startGameMc.visible = true;
			
			content.countTimePlayTxt.mouseEnabled = false;
			if (myTurn > 9) 
			{
				content.countTimePlayTxt.text = "Lượt rút: " + String(myTurn);
			}
			else 
			{
				content.countTimePlayTxt.text = "Lượt rút: 0" + String(myTurn);
			}
			
			if (awardPopup) 
			{
				awardPopup.visible = false;
			}
			
		}
		
		protected function format(number:int):String 
		{
			
			var numString:String = number.toString()
			var result:String = ''
			
			while (numString.length > 3)
			{
					var chunk:String = numString.substr(-3)
					numString = numString.substr(0, numString.length - 3)
					result = ',' + chunk + result
			}
			
			if (numString.length > 0)
			{
					result = numString + result
			}

			return result
		}
		
	}

}