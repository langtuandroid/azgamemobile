package view.screen.play 
{
	import com.greensock.TweenMax;
	import control.ConstTlmn;
	import event.DataField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import logic.CardsTlmn;
	import model.GameDataTLMN;
	import view.Base;
	import view.card.CardTlmn;
	
	import model.MyDataTLMN;
	import sound.SoundManager;
	
	import view.card.CardDeck;
	import view.clock.Clock;
	
	import view.screen.PlayGameScreenTlmn;
	
	/**
	 * ...
	 * @author Bim kute
	 */
	public class MyInfoTLMN extends Base 
	{
		
		private var _avatar:Avatar;
		private var _arrcardDeck:Array = [];
		private var _countCard:int = 0;
		public var _arrCardInt:Array = [];
		private var _arrCardImage:Array = [];
		public var _arrCardFirst:Array = [];//dung cho van danh dau tien khi vua vao
		
		public var _arrCardChoose:Array =[];
		
		//private var _posCardY:Number;
		private var _posCardX:Number = 0;
		
		private var _posLastMouseX:Number = 0;
		private var _posNewMouseX:Number = 0;
		
		private var _indexOfCard:int;//index trong mang image
		private var _indexLastOfCard:int;
		
		private var _indexCardChoose:int;//index trong content
		
		private var _distance:int = 50;//khoang cach cac quan bai
		
		private var isMove:Boolean = false;
		private var isHit:Boolean = false;
		private var _parent:PlayGameScreenTlmn;
		
		public var _isMyTurn:Boolean = false;
		private var _sortToIdCard:Boolean = true; // mặc định khi ấn xếp bài lần đầu thì xếp theo các bộ bài, đôi, 3
		public var _userName:String = "";
		private var _checkSort:Boolean = false;
		private var _moneyEffect:MoneyEffect;
		public var _isPassTurn:Boolean = false;
		private var _clock:Clock;
		private var _glowFilter:TextFormat = new TextFormat(); 
		
		private var _distanceConstan:int = 0;
		private var _distanceConstanY:int = 0;
		private var _arrStar:Array = [];
		
		public var _isPlaying:Boolean = false;
		public var _cheater:Boolean = false;
		public var _ready:Boolean;
		
		private var _linkAvatar:String = "";
		private var _linkBg:String = "";
		
		private var card:CardTlmn;
		
		private var _timerShowChatde:Timer;
		
		private var _win:Boolean = false;
		private var _timerVoiceLose:Timer;
		public var _displayName:String = "";
		public var myIp:String = "";
		
		public function MyInfoTLMN(playgame:PlayGameScreenTlmn) 
		{
			_glowFilter.color = 0x663311;
			
		
			_parent = playgame;
			
			content = new MyInfoTlmnMc();
			addChild(content);
			
			if (!_clock) 
			{
				_clock = new Clock();
				content.addChild(_clock);
				_clock.x = 23;
				_clock.y = 13;
				_clock.addEventListener(Clock.COUNT_TIME_FINISH, onOverTimer);
				
				_clock.visible = false;
			}
			if (!_avatar) 
			{
				_avatar = new Avatar();
				content.specialAvatar.addChild(_avatar);
				//_avatar.x = -10;
				//content.setChildIndex(_avatar, 0);
			}
			_posCardX = 80;
			//_posCardY = content.numCard.y + 25;
			content.iconMobile.visible = false;
			content.effectMoney.visible = false;
			content.effectMoneySpecial.visible = false;
			content.effectMoneySpecial.y = 100;
			content.nextturn.visible = false;
			content.chatde.visible = false;
			content.readyBtn.visible = false;
			content.confirmReady.visible = false;
			content.resultGame.visible = false;
			
			content.nextturn.x = 535;
			content.nextturn.y = -84;
			
			content.autoReadyBtn.gotoAndStop(1);
			content.autoReadyBtn.addEventListener(MouseEvent.CLICK, onClickAutoReady);
			
			buttonForMe();
			//addMoneyEffect();
		}
		
		public function chatde(win:Boolean):void 
		{
			if (_timerShowChatde) 
			{
				_timerShowChatde.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowChatde);
				_timerShowChatde.stop();
			}
			
			if (win) 
			{
				content.chatde.gotoAndStop(1);
			}
			else 
			{
				content.chatde.gotoAndStop(2);
			}
			
			content.chatde.visible = true;
			
			_timerShowChatde = new Timer(1000, 3);
			_timerShowChatde.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowChatde);
			_timerShowChatde.start();
		}
		
		private function onCompleteShowChatde(e:TimerEvent):void 
		{
			content.chatde.visible = false;
		}
		
		public function completeChatde():void 
		{
			content.chatde.visible = false;
		}
		
		public function myReady():void 
		{
			content.readyBtn.visible = false;
			content.confirmReady.visible = true;
		}
		
		public function waitNewGame():void 
		{
			if (GameDataTLMN.getInstance().autoReady) 
			{
				content.readyBtn.visible = false;
			}
			else 
			{
				content.readyBtn.visible = true;
			}
			
			content.confirmReady.visible = false;
		}
		
		private function onClickAutoReady(e:MouseEvent):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_CLICK);
			}
			
			if (GameDataTLMN.getInstance().autoReady) 
			{
				content.autoReadyBtn.gotoAndStop(1);
				GameDataTLMN.getInstance().autoReady = false;
			}
			else 
			{
				content.autoReadyBtn.gotoAndStop(2);
				GameDataTLMN.getInstance().autoReady = true;
			}
		}
		
		public function showEffectGameOver(obj:Object, outGame:Boolean):void 
		{
			var rd:int;
			if (int(obj[ConstTlmn.MONEY]) > 0) 
			{
				content.resultGame.gotoAndStop(1);
				TextField(content.effectMoneySpecial).defaultTextFormat = _textformatWin;
				
				
				_win = true;
				/*if (SoundManager.getInstance().isSoundOn) 
				{
					rd = int(Math.random() * 5);
					if (MyDataTLMN.getInstance().sex) 
					{
						SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_WIN_ + String(rd + 1) );
					}
					else 
					{
						SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_WIN_ + String(rd + 1) );
					}
				}*/
			}
			else 
			{
				_win = false;
				if (_timerVoiceLose) 
				{
					_timerVoiceLose.stop();
					_timerVoiceLose.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowVoiceLose);
				}
				
				if (!outGame) 
				{
					_timerVoiceLose = new Timer(500, 3);
					_timerVoiceLose.addEventListener(TimerEvent.TIMER_COMPLETE, onShowVoiceLose);
					_timerVoiceLose.start();
				}
				
				
				content.resultGame.gotoAndStop(2);
				TextField(content.effectMoneySpecial).defaultTextFormat = _textformatLose;
			}
			
			_isPlaying = false;
			content.resultGame.visible = true;
			//content.effectMoneySpecial.visible = true;
			content.effectMoneySpecial.visible = false;
			content.effectMoneySpecial.text = format(int(obj[ConstTlmn.MONEY]));
			trace("xem lai tien cua minh: ", MyDataTLMN.getInstance().myMoney[0], obj[ConstTlmn.MONEY])
			//MyDataTLMN.getInstance().myMoney[0] = int(MyDataTLMN.getInstance().myMoney[0]) + int(obj[ConstTlmn.MONEY]);
			TweenMax.to(content.effectMoneySpecial, 3, { y:content.effectMoneySpecial.y - 130, onComplete:onCompleteShowMoney } );
		}
		
		private function onShowVoiceLose(e:TimerEvent):void 
		{
			if (int(MyDataTLMN.getInstance().myMoney[0]) < int(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]) * ConstTlmn.xBet)
			{
				if (SoundManager.getInstance().isSoundOn) 
				{
					var rd:int = int(Math.random() * 5);
					if (MyDataTLMN.getInstance().sex) 
					{
						SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_LOSE_ + String(rd + 1) );
					}
					else 
					{
						SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_LOSE_ + String(rd + 1) );
					}
				}
			}
			
		}
		
		public function visibleResultGame():void 
		{
			content.resultGame.visible = false;
		}
		
		private function onCompleteShowMoney():void 
		{
			if (_win) 
			{
				if (SoundManager.getInstance().isSoundOn) 
				{
					SoundManager.getInstance().playSound(ConstTlmn.SOUND_WIN);
				}
			}
			else 
			{
				if (SoundManager.getInstance().isSoundOn) 
				{
					SoundManager.getInstance().playSound(ConstTlmn.SOUND_LOSE);
				}
			}
			content.effectMoneySpecial.visible = false;
			content.effectMoneySpecial.y += 130;
			content.userMoney.text = format(int(MyDataTLMN.getInstance().myMoney[0]));
			if (SoundManager.getInstance().isSoundOn && int(MyDataTLMN.getInstance().myMoney[0]) < 10000) 
			{
				var rd:int = int(Math.random() * 5);
				if (MyDataTLMN.getInstance().sex) 
				{
					SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_OVERMONEY_ + String(rd + 1) );
				}
				else 
				{
					SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_OVERMONEY_ + String(rd + 1) );
				}
			}
		}
		
		public function stopTimer():void 
		{
			_clock.visible = false;
			_clock.removeTween();
		}
		
		private function onOverTimer(e:Event):void 
		{
			_clock.visible = false;
			_parent.onCountTimeFinish();
		}
		
		public function checkPosClock():void 
		{
			trace("day co phai luot danh dau tien ko: ", GameDataTLMN.getInstance().firstPlayer , MyDataTLMN.getInstance().myId)
			if (GameDataTLMN.getInstance().firstPlayer == MyDataTLMN.getInstance().myId) 
			{
				_clock.countTime(10);
				showPassTurn();
			}
			else 
			{
				_clock.countTime(15);
				hidePassTurn();
			}
			
			_clock.visible = true;
			
			if (_arrCardChoose.length > 0) 
			{
				hideChooseAgainCard();
				if (checkCanHit()) 
				{
					
					if (_isMyTurn) 
					{
						hideHitCard();
					}
					else 
					{
						showHitCard();
					}
				}
				else 
				{
					showHitCard();
				}
				
			}
			else
			{
				
				showChooseAgainCard();
			}
		}
		
		private function addMoneyEffect():void 
		{
			if (!_moneyEffect) 
			{
				_moneyEffect = new MoneyEffect();
				_moneyEffect.x = 60;
				_moneyEffect.y = -30;
				content.addChild(_moneyEffect);
			}
		}
		
		public function addMyMoney():void 
		{
			content.userMoney.text = format(int(MyDataTLMN.getInstance().myMoney[0]));
		}
		
		public function addMoneySpecial(money:String):void 
		{
			content.effectMoney.visible = true;
			content.setChildIndex(content.effectMoneySpecial, content.numChildren - 1);
			
			if (int(money) < 0) 
			{
				TextField(content.effectMoney).defaultTextFormat = _textformatLose;
				//money = "-" + money;
			}
			else 
			{
				TextField(content.effectMoney).defaultTextFormat = _textformatWin;
			}
			trace("money bi chat: ", content.userMoney.text, content.userMoney.text.length)
			var str:String = "";
			for (var i:int = 0; i < content.userMoney.text.length; i++) 
			{
				if (String(content.userMoney.text).charAt(i) != ",")
				{
					str += String(content.userMoney.text).charAt(i);
				}
			}
			
			trace("money bi chat: ", str, money)
			var myMoney:int = int(str) + int(money);
			content.userMoney.text = format(myMoney);
			
			content.effectMoney.text = format(int(money));
			MyDataTLMN.getInstance().myMoney[0] = int(MyDataTLMN.getInstance().myMoney[0]) + int(money);
			TweenMax.to(content.effectMoney, 1, { y: content.effectMoney.y - 50, onComplete:onCompleteMoneySpecial } );
			//_moneyEffect.showEffect(money);
		}
		
		public function addMoney(money:String):void 
		{
			content.effectMoneySpecial.visible = true;
			content.setChildIndex(content.effectMoneySpecial, content.numChildren - 1);
			
			if (int(money) < 0) 
			{
				TextField(content.effectMoneySpecial).defaultTextFormat = _textformatLose;
				//money = "-" + money;
			}
			else 
			{
				TextField(content.effectMoneySpecial).defaultTextFormat = _textformatWin;
			}
			trace("money bi chat: ", content.userMoney.text, content.userMoney.text.length)
			var str:String = "";
			for (var i:int = 0; i < content.userMoney.text.length; i++) 
			{
				if (String(content.userMoney.text).charAt(i) != ",")
				{
					str += String(content.userMoney.text).charAt(i);
				}
			}
			
			trace("money bi chat: ", str, money)
			var myMoney:int = int(str) + int(money);
			content.userMoney.text = format(myMoney);
			
			content.effectMoneySpecial.text = format(int(money));
			//MyDataTLMN.getInstance().myMoney[0] = int(MyDataTLMN.getInstance().myMoney[0]) + int(money);
			TweenMax.to(content.effectMoneySpecial, 1, { y: content.effectMoneySpecial.y - 130, onComplete:onCompleteMoneySpecial } );
			//_moneyEffect.showEffect(money);
		}
		
		private function onCompleteMoneySpecial():void 
		{
			content.effectMoneySpecial.visible = false;
			content.effectMoneySpecial.y += 130;
			content.userMoney.text = format(int(MyDataTLMN.getInstance().myMoney[0]));
		}
		
		public function removeAllEvent():void 
		{
			content.autoReadyBtn.removeEventListener(MouseEvent.CLICK, onClickAutoReady);
			content.sortBtn.removeEventListener(MouseEvent.CLICK, onClickSort);
			content.chooseAgain.removeEventListener(MouseEvent.CLICK, onClickChooseAgain);
			content.hitBtn.removeEventListener(MouseEvent.CLICK, onClickHit);
			content.passTurnBtn.removeEventListener(MouseEvent.CLICK, onClickPassTurn);
			content.readyBtn.removeEventListener(MouseEvent.CLICK, onClickready);
			
			_clock.removeEventListener(Clock.COUNT_TIME_FINISH, onOverTimer);
			
			if (_timerShowChatde) 
			{
				_timerShowChatde.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowChatde);
				_timerShowChatde.stop();
			}
			
			if (_timerVoiceLose) 
			{
				_timerVoiceLose.stop();
				_timerVoiceLose.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowVoiceLose);
			}
				
		}
		
		private function buttonForMe():void 
		{
			
			hideButton();
			showSortCard();
			showChooseAgainCard();
			
			content.sortBtn.addEventListener(MouseEvent.CLICK, onClickSort);
			content.chooseAgain.addEventListener(MouseEvent.CLICK, onClickChooseAgain);
			content.hitBtn.addEventListener(MouseEvent.CLICK, onClickHit);
			content.passTurnBtn.addEventListener(MouseEvent.CLICK, onClickPassTurn);
			
			content.readyBtn.addEventListener(MouseEvent.CLICK, onClickready);
		}
		
		private function onClickready(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ConstTlmn.READY));
		}
		
		public function allButtonVisible():void 
		{
			trace("da de dc nut bo luot khi tata ca cac nut ko an dc")
			content.visibleSortCard.visible = true;
			content.visiblePassturn.visible = true;
			content.visibleChooseAgain.visible = true;
			content.visibleHit.visible = true;
			
		}
		
		private function hideButton():void 
		{
			trace("da de dc nut bo luot khi chi co 2 nut ko an dc")
			content.visiblePassturn.visible = true;
			
			content.visibleHit.visible = true;
		}
		
		private function hideSortCard():void 
		{
			content.visibleSortCard.visible = false;
		}
		
		private function showSortCard():void 
		{
			content.visibleSortCard.visible = true;
		}
		
		private function showPassTurn():void 
		{
			trace("ko ther click nut bo luot")
			content.visiblePassturn.visible = true;
		}
		private function hidePassTurn():void 
		{
			trace("da de dc nut bo luot")
			content.visiblePassturn.visible = false;
		}
		
		private function hideChooseAgainCard():void 
		{
			content.visibleChooseAgain.visible = false;
		}
		
		private function showChooseAgainCard():void 
		{
			content.visibleChooseAgain.visible = true;
		}
		
		private function showHitCard():void 
		{
			content.visibleHit.visible = true;
		}
		private function hideHitCard():void 
		{
			content.visibleHit.visible = false;
		}
		
		private function onClickPassTurn(e:MouseEvent):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_CLICK);
			}
			
			trace(_isMyTurn, GameDataTLMN.getInstance().finishRound, "check bo luot khi danh luot dau tien")
			if (_isMyTurn && _checkSort) 
			{
				trace("mat turn khi an bo luot")
				_isMyTurn = false;
				
				dispatchEvent(new Event("next turn"));
			}
			
		}
		
		public function nextturn():void 
		{
			var myDate:Date = new Date();
			trace("minh click bo luot: ", myDate.minutes, myDate.seconds);
			_isPassTurn = true;
			content.nextturn.visible = true;
			hideButton();
			var rd:int = int(Math.random() * 5);
			if (SoundManager.getInstance().isSoundOn) 
			{
				if (MyDataTLMN.getInstance().sex) 
				{
					SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_PASSTURN_ + String(rd + 1) );
					
				}
				else 
				{
					SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_PASSTURN_ + String(rd + 1) );
					
				}
			}
			
		}
		
		public function onCompleteNextturn():void 
		{
			content.nextturn.visible = false;
			
		}
		
		private function onClickSort(e:MouseEvent):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_SORTCARD);
			}
			
			var cardTlmn:CardsTlmn = new CardsTlmn();
			if (_checkSort) 
			{
				var i:int;
				var j:int;
				if (_sortToIdCard) 
				{
					_sortToIdCard = false;
					
					_arrCardInt = _arrCardInt.sort(Array.NUMERIC);
					
					var arrAgain:Array = [];
					var arrNew:Array = [];
					var arrCardNew:Array = [];
					var count:int = 0;
					
					for (i = 0; i < _arrCardInt.length; i++) 
					{
						arrAgain.push(_arrCardInt[i]);
					}
					
					
					for (i = 0; i < _arrCardInt.length; i++) 
					{
						
						for (j = 0; j < arrAgain.length; j++) 
						{
							if (arrAgain[j] == _arrCardInt[i]) 
							{
								arrNew.push(_arrCardInt[i]);
								break;
							}
						}
						trace(arrNew)
						
						if (arrNew.length > 0) 
						{
							for (j = 0; j < arrAgain.length; j++) 
							{
								
								if (int(arrAgain[j] / 4) == int(arrNew[arrNew.length - 1] / 4) + 1 && arrAgain[j] < 48) 
								{
									var find:int = arrAgain[j];
									arrAgain.splice(j, 1);
									arrNew.push(find);
									j--;
									
								}
							}
							
							if (arrNew.length < 3) 
							{
								
								arrNew.shift();
								arrAgain = arrAgain.concat(arrNew);
								arrAgain.sort(Array.NUMERIC);
								
								arrNew = [];
							}
							else 
							{
								for (j = 0; j < arrNew.length; j++) 
								{
									arrCardNew.push(arrNew[j]);
								}
								for (j = 0; j < arrAgain.length; j++) 
								{
									if (arrAgain[j] == arrNew[0]) 
									{
										arrAgain.splice(j, 1);
									}
									
								}
								
								arrAgain.sort(Array.NUMERIC);
								
								arrNew = [];
							}
							
							
						}
						
					}
					
					_arrCardInt = [];
					_arrCardInt = arrCardNew.concat(arrAgain);
				}
				else 
				{
					_sortToIdCard = true;
					
					_arrCardInt = _arrCardInt.sort(Array.NUMERIC);
					
				}
				
				for (i = 0; i < _arrCardInt.length; i++) 
				{
					for (j = 0; j < _arrCardImage.length; j++) 
					{
						if (_arrCardImage[j].id == _arrCardInt[i]) 
						{
							
							TweenMax.to(_arrCardImage[j], .1, { x:_distanceConstan + _distance * i } );
							_arrCardImage[j].pos = i;
							content.cardContainer.setChildIndex(_arrCardImage[j], i);
							break;
						}
						
					}
				}
				trace("=====")
				for (i = 0; i < _arrCardImage.length; i++) 
				{
					//trace(_arrCardImage[i].id)
				}
				var arrCardImageCopy:Array = [];
				for (i = 0; i < _arrCardImage.length; i++) 
				{
					arrCardImageCopy.push(_arrCardImage[i]);
				}
				
				for (i = 0; i < _arrCardInt.length; i++) 
				{
					for (j = 0; j < arrCardImageCopy.length; j++) 
					{
						if (arrCardImageCopy[j].id == _arrCardInt[i]) 
						{
							//trace("thang card dc di len: ", _arrCardImage[j].id, j, i)
							
							_arrCardImage[i] = arrCardImageCopy[j];
							
							break;
						}
						
					}
				}
				
			}
			
		}
		
		private function onClickChooseAgain(e:MouseEvent):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_CLICK);
			}
			
			if (_checkSort) 
			{
				for (var i:int = 0; i < _arrCardImage.length; i++) 
				{
					var card:CardTlmn = _arrCardImage[i];
					if (card.isChoose) 
					{
						TweenMax.to(card, .3, { y:card._posCardY } );
						card.isChoose = false;
					}
				}
				
				_arrCardChoose = [];
				//checkHitOrPassTurn();
			}
			
		}
		
		private function onClickHit(e:MouseEvent):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_DEAL_DISCARD);
			}
			//e.currentTarget.txtDown.visible = false;
			//e.currentTarget.txt.visible = true;
			var checkHit:Boolean;
			if (_checkSort) 
			{
				for (var i:int = 0; i < _arrCardChoose.length; i++) 
				{
					for (var j:int = 0; j < _arrCardImage.length; j++) 
					{
						if (_arrCardChoose[i] == _arrCardImage[j].id) 
						{
							if (_arrCardImage[j].y == _arrCardImage[j]._posCardY) 
							{
								_arrCardImage[j].isChoose = false;
								_arrCardChoose.splice(i, 1);
							}
						}
					}
				}
				
				if (_isMyTurn) 
				{
					
					dispatchEvent(new Event("hit card"));
					
				}
				
				
			}
			
		}
		
		public function changeMaster(isMaster:Boolean):void 
		{
			
			if (isMaster) 
			{
				content.iconMaster.visible = true;
				content.autoReadyBtn.visible = false;
				content.readyBtn.visible = false;
				content.confirmReady.visible = false;
			}
			else 
			{
				content.iconMaster.visible = false;
				content.autoReadyBtn.visible = true;
				content.readyBtn.visible = false;
				content.confirmReady.visible = false;
			}
		}
		
		/**
		 * link avatar
		 * tien
		 * ten
		 * so bai con lai
		 */
		public function addInfoForMe(userName:String, money:String, linkAvatar:String, remainingCard:int, level:String,
										isMaster:Boolean, isPlaying:Boolean, displayName:String, ready:Boolean, ip:String):void 
		{
			_userName = userName;
			myIp = ip;
			
			_clock.setParent(MyDataTLMN.getInstance().sex);
			_ready = ready;
			_isPlaying = isPlaying;
			if (isPlaying) 
			{
				
				if (GameDataTLMN.getInstance().master == userName) 
				{
					content.iconMaster.visible = true;
					content.autoReadyBtn.visible = false;
					content.readyBtn.visible = false;
					content.confirmReady.visible = false;
					
				}
				else 
				{
					content.iconMaster.visible = false;
					content.autoReadyBtn.visible = true;
					content.readyBtn.visible = false;
					content.confirmReady.visible = false;
					
				}
				
			}
			else 
			{
				
				if (GameDataTLMN.getInstance().master == userName) 
				{
					content.iconMaster.visible = true;
					content.autoReadyBtn.visible = false;
					content.readyBtn.visible = false;
					content.confirmReady.visible = false;
				}
				else 
				{
					if (ready) 
					{
						content.readyBtn.visible = false;
						content.confirmReady.visible = true;
					}
					else 
					{
						content.readyBtn.visible = true;
						content.confirmReady.visible = false;
						
					}
					
					content.iconMaster.visible = false;
					content.autoReadyBtn.visible = true;
				}
				
			}
			
			
			
			content.userName.visible = true;
			content.userMoney.visible = true;
			content.avatarNormal.visible = true;
			content.specialAvatar.visible = true;
			_avatar.visible = true;
			
			
			if (_linkAvatar != linkAvatar && linkAvatar != null) 
			{
				_avatar.addImg(linkAvatar);
				_linkAvatar = linkAvatar;
			}
			
			/*var urlRequest:URLRequest = new URLRequest(linkAvatar);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImgComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(urlRequest);
			content.addChild(loader);*/
			
			content.userName.text = displayName;
			_displayName = displayName;
			content.userMoney.text = format(int(money));
			
			content.level.txt.text = level;
			
			content.setChildIndex(content.iconMaster, content.numChildren - 1);
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			trace("AAAAAAAAAAAAA")
		}
		
		private function onLoadImgComplete(e:Event):void 
		{
			trace("BBBBBBBBBBBB")
		}
		
		private function loadBg(str:String):void 
		{
			var loader:Loader = new Loader();
			var urlReq:URLRequest = new URLRequest(str);
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoadBgNormal);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorLoadBg);
			loader.load(urlReq);
		}
		
		private function onCompleteLoadBgMonter(e:Event):void 
		{
			var loader:Loader = e.target.loader as Loader;
			while (content.specialAvatar.numChildren > 0){ content.specialAvatar.removeChildAt(0); }
			content.specialAvatar.addChild(loader);
		}
		
		private function onCompleteLoadBgNormal(e:Event):void 
		{
			var loader:Loader = e.target.loader as Loader;
			while (content.avatarNormal.numChildren > 0){ content.avatarNormal.removeChildAt(0); }
			content.avatarNormal.addChild(loader);
		}
		
		private function errorLoadBg(e:IOErrorEvent):void 
		{
			trace("ko load dc bg")
		}
		
		public function dealCard(arr:Array):void 
		{
			_isPlaying = true;
			_checkSort = false;
			_arrCardInt = [];
			_arrCardInt = arr;
			_arrCardFirst = [];
			for (var i:int = 0; i < arr.length; i++) 
			{
				_arrCardFirst.push(arr[i]);
			}
			_arrCardFirst.sort(Array.NUMERIC);
			_arrcardDeck = [];
			_arrCardImage = [];
			_countCard = 0;
			
			content.confirmReady.visible = false;
			
			effectDealCard(_countCard);
		}
		
		private function effectDealCard(type:int):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_DEAL_DISCARD);
			}
			
			
			var card:CardTlmn = new CardTlmn(_arrCardInt[_countCard]);
			card.x = _posCardX;
			card.y = -90;
			//card.scaleX = card.scaleY = .80;
			content.cardContainer.addChild(card);
			_arrCardImage.push(card);
			card.buttonMode = true;
			card._posCardY = _distanceConstanY;
			card.pos = _countCard;
			TweenMax.to(card, .1, { x:_distanceConstan + _distance * _countCard, y:_distanceConstanY, onComplete:onComplete } );
		}
		
		private function onComplete():void 
		{
			
			_countCard++;
			if (_countCard < _arrCardInt.length) 
			{
				effectDealCard(_countCard);
			}
			else 
			{
				hideSortCard();
				
				addClickCard();
				_parent.canExitGame = true;
			}
			
		}
		
		public function killAllTween():void 
		{
			TweenMax.killChildTweensOf(this);
			_clock.removeTween();
			removeAllCard();
			/*if (_arrcardDeck && _arrcardDeck.length > 0) 
			{
				var lengthArr:int = _arrcardDeck.length;
				for (var i:int = 0; i < lengthArr; i++) 
				{
					content.removeChild(_arrcardDeck[i]);
					_arrcardDeck[i] = null;
				}
				_arrcardDeck = [];
			}*/
		}
		
		private function addClickCard():void 
		{
			_checkSort = true;
			var i:int;
			for (i = 0; i < _arrCardImage.length; i++) 
			{
				_arrCardImage[i].addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				
			}
			
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			var i:int;
			card.stopDrag();
			card.doubleClickEnabled = false;
			card.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			//removeEventListener(Event.ENTER_FRAME, onMove);
			//trace("is move ========================= ", isMove, card.id, _arrCardInt );
			if (!isMove) 
			{
				//trace("card mousedown ========================= ", card.isMouseDown, _arrCardInt );
				if (card.isMouseDown) 
				{
					//trace("card ischoose ========================= ", card.isChoose );
					//trace("card ischoose ========================= ", card._posCardY );	
						if (GameDataTLMN.getInstance().playSound) 
						{
							SoundManager.getInstance().playSound("Click");
						}
						
						upAndDown();
						//checkHitOrPassTurn();
						
				}
				else 
				{
					//_indexOfCard = getPosCard(card.x);
					/*for (i= 0; i < content.numChildren; i++) 
					{
						//trace("thang nay co bao nhieu child: ", content.getChildAt(i) );
					}
					*/
					//content.setChildIndex(card, (15 + _indexOfCard));
					//changePosCard(_indexOfCard, card);
				}
				
			}
			else 
			{
				trace("ko move")
				/*for (i= 0; i < content.numChildren; i++) 
				{
					//trace("thang nay co bao nhieu child: ", content.getChildAt(i) );
				}*/
				_indexOfCard = getPosCard(card.x);
				
				if (_indexOfCard < _indexLastOfCard) 
				{
					_indexOfCard++;
				}
				else 
				{
					
				}
				
				if (_indexOfCard != _indexLastOfCard) 
				{
					changePosCard(_indexOfCard, card);
				}
				else 
				{
					upAndDown();
				}
				
				for (i = 0; i < _arrCardImage.length; i++) 
				{
					TweenMax.to(_arrCardImage[i], .2, { x:_distanceConstan + _distance * i } );
				}
				//content.setChildIndex(card, (15 + _indexOfCard));
				
			}
			
			
			//trace("child cua content: ", content.numChildren)
			/*for (var i:int = 0; i < content.numChildren; i++) 
			{
				//trace("id cua no: ", content.getChildAt(i))
				
			}*/
			//TweenMax.to(e.currentTarget, .3, { x:_distance * _indexOfCard } );
			isMove = false;
			card.isMouseDown = false;
			
			trace("nhac 1 quan bai len: ", _isMyTurn)
			
			if (_arrCardChoose.length > 0) 
			{
				hideChooseAgainCard();
				if (checkCanHit()) 
				{
					
					if (_isMyTurn) 
					{
						hideHitCard();
					}
					else 
					{
						showHitCard();
					}
				}
				else 
				{
					showHitCard();
				}
				
			}
			else
			{
				
				showChooseAgainCard();
			}
			
		}
		
		private function upAndDown():void 
		{
			var i:int;
			if (card.isChoose) 
			{
				trace("bo chon")
				TweenMax.to(card, .3, { y:card._posCardY} );
				
				for (i = 0; i < _arrCardChoose.length; i++) 
				{
					if (card.id == _arrCardChoose[i])
					{
						_arrCardChoose.splice(i, 1);
						break;
					}
				}
				
				card.isChoose = false;
				
			}
			else 
			{
				trace("duoc  chon")
				TweenMax.to(card, .3, { y:card._posCardY - 20} );
				
				_arrCardChoose.push(card.id);
				
				card.isChoose = true;
				
			}
			content.cardContainer.setChildIndex(card, _indexCardChoose);
			
		}
		
		
		private function checkCanHit():Boolean 
		{
			var hit:Boolean;
			var cardTlmn:CardsTlmn = new CardsTlmn();
			trace(_isPassTurn, "turn cua thang nao =============")
			//trace(_isPassTurn, "turn cua thang nao =============")
			trace(_arrCardChoose, "cac quan bai dang doi danh ra =============")
			var check:Boolean = false;
			var arrCard:Array = [];
			var arrCardChoose:Array = [];
			var j:int;
			for (j = 0; j < _arrCardChoose.length; j++) 
			{
				arrCardChoose.push(_arrCardChoose[j]);
			}
			for (j = 0; j < _parent._arrLastCard.length; j++) 
			{
				arrCard.push(_parent._arrLastCard[j]);
			}
			arrCardChoose = arrCardChoose.sort(Array.NUMERIC);
			arrCard = arrCard.sort(Array.NUMERIC);
			
			trace(arrCardChoose, "cac quan bai dang doi danh ra sap xep lai=============")
			
			if (!_isPassTurn) 
			{
				if (GameDataTLMN.getInstance().firstPlayer == _userName) 
				{
					hit = true;
				}
				else if (GameDataTLMN.getInstance().finishRound) 
				{
					hit = true;
				}
				else if (!arrCard || arrCard.length == 0) 
				{
					hit = true;
				}
				
				//neu truoc do chi co 1 quan bai danh ra, va ko phai quan 2
				else if (arrCard.length == 1 && !cardTlmn.isHai(arrCard[0])) 
				{
					if (arrCardChoose.length == arrCard.length && arrCardChoose[0] > arrCard[0]) 
					{
						hit = true;
					}
					else 
					{
						hit = false;
					}
					
				}
				//neu truoc do danh 1 quan bai va la quan 2
				else if (arrCard.length == 1 && cardTlmn.isHai(arrCard[0])) 
				{
					if (arrCardChoose.length == 1) 
					{
						if (arrCardChoose[0] > arrCard[0]) 
						{
							hit = true;
						}
						else 
						{
							hit = false;
						}
					}
					else if (arrCardChoose.length == 4)
					{
						if (cardTlmn.isTuQuy(arrCardChoose)) 
						{
							hit = true;
						}
						else 
						{
							hit = false;
						}
					}
					else if (arrCardChoose.length == 6)
					{
						if (cardTlmn.isBaDoiThong(arrCardChoose)) 
						{
							hit = true;
						}
						else 
						{
							hit = false;
						}
					}
					else if (arrCardChoose.length == 8)
					{
						if (cardTlmn.isBonDoiThong(arrCardChoose)) 
						{
							hit = true;
						}
						else 
						{
							hit = false;
						}
					}
					else 
					{
						hit = false;
					}
				}
				//neu truoc do danh ra 2 cay bt
				else if (arrCard.length == 2 && !cardTlmn.isHai(arrCard[0])) 
				{
					if (arrCardChoose.length == arrCard.length && 
							arrCardChoose[1] > arrCard[1] && cardTlmn.isDoiThong(arrCardChoose)) 
					{
						hit = true;
					}
					else 
					{
						hit = false;
					}
				}
				//neu danh ra doi 2
				else if (arrCard.length == 2 && cardTlmn.isHai(arrCard[0]))
				{
					if (arrCardChoose.length == 2) 
					{
						if (arrCardChoose[1] > arrCard[1]) 
						{
							hit = true;
						}
						else 
						{
							hit = false;
						}
					}
					else if (arrCardChoose.length == 4)
					{
						if (cardTlmn.isTuQuy(arrCardChoose)) 
						{
							hit = true;
						}
						else 
						{
							hit = false;
						}
					}
					else if (arrCardChoose.length == 8)
					{
						if (cardTlmn.isBonDoiThong(arrCardChoose)) 
						{
							hit = true;
						}
						else 
						{
							hit = false;
						}
					}
					else 
					{
						hit = false;
					}
				}
				//neu danh ra 3 cay bt
				else if (arrCard.length == 3 && !cardTlmn.isHai(arrCard[0]))
				{
					//neu 3 cay nay la sanh 3
					if (arrCardChoose.length == arrCard.length &&
							arrCardChoose[2] > arrCard[2] && cardTlmn.isDay(arrCardChoose)) 
					{
						hit = true;
					}
					//neu 3 cay nay la xam
					else if (arrCardChoose.length == arrCard.length &&
							arrCardChoose[2] > arrCard[2] && cardTlmn.isBaLa(arrCardChoose)) 
					{
						hit = true;
					}
					else 
					{
						hit = false;
					}
				}
				//neu danh ra 3 cay 2
				else if (arrCard.length == 3 && cardTlmn.isHai(arrCard[0]))
				{
					hit = false;
				}
				//neu truoc do danh ra sanh 4
				else if (arrCard.length == 4) 
				{
					//neu la sanh 4
					if (arrCardChoose.length == 4 && arrCardChoose[3] > arrCard[3] && cardTlmn.isDay(arrCardChoose)) 
					{
						hit = true;
					}
					//neu la danh ra tu qui
					else if (arrCardChoose.length == 4 && arrCardChoose[3] > arrCard[3] && cardTlmn.isTuQuy(arrCardChoose)) 
					{
						hit = true;
					}
					else if (arrCardChoose.length == 8)
					{
						if (cardTlmn.isBonDoiThong(arrCardChoose)) 
						{
							hit = true;
						}
						else 
						{
							hit = false;
						}
					}
					else 
					{
						hit = false;
					}
				}
				//neu truoc do danh ra sanh 5
				else if (arrCard.length == 5) 
				{
					if (arrCardChoose.length == 5 && arrCardChoose[4] > arrCard[4] && cardTlmn.isDay(arrCardChoose)) 
					{
						hit = true;
					}
					else 
					{
						hit = false;
					}
				}
				//neu truoc do danh ra sanh 6
				else if (arrCard.length == 6 && !cardTlmn.isBaDoiThong(arrCard)) 
				{
					if (arrCardChoose.length == 6 && arrCardChoose[5] > arrCard[5] && cardTlmn.isDay(arrCardChoose)) 
					{
						hit = true;
					}
					else 
					{
						hit = false;
					}
				}
				//neu truoc do danh ra 3 doi thong
				else if (arrCard.length == 6 && cardTlmn.isBaDoiThong(arrCard)) 
				{
					if (arrCardChoose.length == 6 && arrCardChoose[5] > arrCard[5] && cardTlmn.isBaDoiThong(arrCardChoose)) 
					{
						hit = true;
					}
					else if (arrCardChoose.length == 4 && cardTlmn.isTuQuy(arrCardChoose)) 
					{
						hit = true;
					}
					else if (arrCardChoose.length == 8 && cardTlmn.isBonDoiThong(arrCardChoose)) 
					{
						hit = true;
					}
					else 
					{
						hit = false;
					}
				}
				//neu truoc do danh ra sanh 7
				else if (arrCard.length == 7) 
				{
					if (arrCardChoose.length == 7 && arrCardChoose[6] > arrCard[6] && cardTlmn.isDay(arrCardChoose)) 
					{
						hit = true;
					}
					else 
					{
						hit = false;
					}
				}
				//neu truoc do danh ra sanh 8
				else if (arrCard.length == 8 && !cardTlmn.isBonDoiThong(arrCard)) 
				{
					if (arrCardChoose.length == 8 && arrCardChoose[7] > arrCard[7] && cardTlmn.isDay(arrCardChoose)) 
					{
						hit = true;
					}
					else 
					{
						hit = false;
					}
				}
				//neu truoc do danh ra 4 doi thong
				else if (arrCard.length == 8 && cardTlmn.isBonDoiThong(arrCard)) 
				{
					if (arrCardChoose.length == 8 && arrCardChoose[7] > arrCard[7] && cardTlmn.isBonDoiThong(arrCardChoose)) 
					{
						hit = true;
					}
					else 
					{
						hit = false;
					}
				}
				//neu truoc do danh ra sanh 9, 10, 11, 12
				else if (arrCard.length > 8) 
				{
					if (arrCardChoose.length > 8 &&
							arrCardChoose[arrCardChoose.length - 1] > arrCard[arrCard.length - 1] && 
								cardTlmn.isDay(arrCardChoose)) 
					{
						hit = true;
					}
					else 
					{
						hit = false;
					}
				}
				else 
				{
					hit = false;
				}
			}
			else if (cardTlmn.isBonDoiThong(arrCardChoose) && arrCard &&
						(arrCard.length < 3) && cardTlmn.isHai(arrCard[0])) 
			{
				hit = true;
			}
			else 
			{
				hit = false;
			}
			
			return hit;
		}
		
		
		private function getPosCard(cardX:Number):int 
		{
			var pos:int;
			
			if (cardX >= _distanceConstan && cardX < _distanceConstan + _distance) 
			{
				pos = 0;
			}
			else if (cardX >= _distanceConstan + _distance && cardX < _distanceConstan + 2 * _distance) 
			{
				pos = 1;
			}
			else if (cardX >= _distanceConstan + 2 * _distance && cardX < _distanceConstan + 3 * _distance) 
			{
				pos = 2;
			}
			else if (cardX >= _distanceConstan + 3 * _distance && cardX < _distanceConstan + 4 * _distance) 
			{
				pos = 3;
			}
			else if (cardX >= _distanceConstan + 4 * _distance && cardX < _distanceConstan + 5 * _distance) 
			{
				pos = 4;
			}
			else if (cardX >= _distanceConstan + 5 * _distance && cardX < _distanceConstan + 6 * _distance) 
			{
				pos = 5;
			}
			else if (cardX >= _distanceConstan + 6 * _distance && cardX < _distanceConstan + 7 * _distance) 
			{
				pos = 6;
			}
			else if (cardX >= _distanceConstan + 7 * _distance && cardX < _distanceConstan + 8 * _distance) 
			{
				pos = 7;
			}
			else if (cardX >= _distanceConstan + 8 * _distance && cardX < _distanceConstan + 9 * _distance) 
			{
				pos = 8;
			}
			else if (cardX >= _distanceConstan + 9 * _distance && cardX < _distanceConstan + 10 * _distance) 
			{
				pos = 9;
			}
			else if (cardX >= _distanceConstan + 10 * _distance && cardX < _distanceConstan + 11 * _distance) 
			{
				pos = 10;
			}
			else if (cardX >= _distanceConstan + 11 * _distance && cardX < _distanceConstan + 12 * _distance) 
			{
				pos = 11;
			}
			else if (cardX >= _distanceConstan + 12 * _distance && cardX < 800) 
			{
				pos = 12;
			}
			
			if (pos >= _arrCardInt.length) 
			{
				pos = _arrCardInt.length - 1;
			}
			return pos;
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			//if (!_hack) 
			{
				card = CardTlmn(e.currentTarget);
				//trace("card dc down: ", card.id, _arrCardInt)
				card.isMouseDown = true;
				_posLastMouseX = mouseX;
				for (var i:int = 0; i < _arrCardImage.length; i++) 
				{
					if (card.id == _arrCardImage[i].id) 
					{
						_indexLastOfCard = i;
						break;
					}
					else 
					{
						_indexLastOfCard = -1;
					}
				}
				//trace("card dc down co vi tri: ", card.id, _indexLastOfCard)
				
				if (_indexLastOfCard == -1) 
				{
					trace("index bang -1")
				}
				_indexCardChoose = content.cardContainer.getChildIndex(card);
				//e.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				
				//content.setChildIndex(card, content.numChildren - 1);
				addEventListener(MouseEvent.MOUSE_MOVE, onMove);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			
		}
		private function onMove(e:MouseEvent):void 
		{
			
			if (card.isMouseDown) 
			{
				//trace("card dc move: ", e.currentTarget.id, _arrCardInt)
				//_hack = true;
				isMove= true;
				_posNewMouseX = mouseX;
				if (card.isChoose) 
				{
					card.startDrag(false, new Rectangle(_posCardX, card._posCardY - 20, 500, 0));
				}
				else 
				{
					card.startDrag(false, new Rectangle(_posCardX, card._posCardY, 500, 0));
				}
				content.cardContainer.setChildIndex(card, content.cardContainer.numChildren - 1);
				
			}
			else 
			{
				
				//trace("card dc down sau khi thay move ma ko thay down: ", card.id, _arrCardInt)
				card.isMouseDown = true;
				_posLastMouseX = mouseX;
				_indexLastOfCard = _arrCardImage.indexOf(card);
				if (_indexLastOfCard == -1) 
				{
					trace("index bang -1")
				}
				_indexCardChoose = content.getChildIndex(card);
				//e.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				
				content.cardContainer.setChildIndex(card, content.cardContainer.numChildren - 1);
				addEventListener(MouseEvent.MOUSE_MOVE, onMove);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			
		}
		
		
		private function changePosCard(pos:int, card:CardTlmn):void 
		{
			var i:int;
			_arrCardImage = changeIndex(pos, _arrCardImage, card);
			
			
			if (pos != _indexLastOfCard) 
			{
				for (i = 0; i < _arrCardImage.length; i++) 
				{
					TweenMax.to(_arrCardImage[i], .1, { x:_distanceConstan + _distance * i } );
					content.cardContainer.setChildIndex(_arrCardImage[i], i);
				}
				//_hack = false;
			}
			else 
			{
				card.x = _distanceConstan + _distance * pos;
				card.y = _distanceConstanY;
				content.cardContainer.setChildIndex(card, pos);
				//_hack = false;
			}
			
			
		}
		
		private function changeIndex(pos:int, arr:Array, card:CardTlmn):Array 
		{
			var arrChange:Array = [];
			var arrCardIntChange:Array = [];
			var i:int;
			//trace("______________________________pos", pos)
			trace(_arrCardInt)
			//trace("______________________________last", _indexLastOfCard)
			for (i = 0; i < _arrCardImage.length; i++) 
			{
				if (card.id == _arrCardImage[i].id) 
				{
					_indexLastOfCard = i;
					break;
				}
				else 
				{
					_indexLastOfCard = -1;
				}
			}
			if (pos != _indexLastOfCard) 
			{
				if (pos < _indexLastOfCard) 
				{
					for (i = 0; i < pos; i++) 
					{
						arrChange[i] = arr[i];
						arrCardIntChange[i] = arr[i].id
					}
					
					arrChange[pos] = card;
					arrCardIntChange[pos] = card.id;
					
					for (i = pos + 1; i < _indexLastOfCard; i++) 
					{
						arrChange[i] = arr[i - 1];
						arrCardIntChange[i] = arr[i - 1].id
					}
					
					arrChange[_indexLastOfCard] = arr[_indexLastOfCard - 1];
					arrCardIntChange[_indexLastOfCard] = arr[_indexLastOfCard - 1].id;
					
					for (i = _indexLastOfCard + 1; i < arr.length; i++) 
					{
						if (i < arr.length) 
						{
							arrChange[i] = arr[i];
							arrCardIntChange[i] = arr[i].id
						}
						else 
						{
							break;
						}
						
					}
					//trace(arrChange)
					//trace(arrCardIntChange)
					//trace("===========================================")
				}
				else 
				{
					for (i = 0; i < _indexLastOfCard; i++) 
					{
						arrChange[i] = arr[i];
						arrCardIntChange[i] = arr[i].id
					}
					
					for (i = _indexLastOfCard; i < pos; i++) 
					{
						arrChange[i] = arr[i + 1];
						arrCardIntChange[i] = arr[i + 1].id
					}
					
					arrChange[pos - 1] = arr[pos];
					arrCardIntChange[pos - 1] = arr[pos].id;
					
					arrChange[pos] = arr[_indexLastOfCard];
					arrCardIntChange[pos] = arr[_indexLastOfCard].id;
					
					for (i = pos + 1; i < arr.length; i++) 
					{
						if (i < arr.length) 
						{
							arrChange[i] = arr[i];
							arrCardIntChange[i] = arr[i].id
						}
						else 
						{
							break;
						}
						
						/*arrChange[i] = arr[i];
						arrCardIntChange[i] = arr[i].id;*/
					}
					//trace(arrCardIntChange)
					//trace("+++++++++++++++++++++++++++++++")
				}
				
				for (i = 0; i < _arrCardInt.length; i++) 
				{
					_arrCardInt.shift();
				}
				_arrCardInt = [];
				_arrCardInt = arrCardIntChange;
				
			}
			else 
			{
				return arr;
			}
			
			return arrChange
		}
		
		public function removeCardDisCard(idCard:int):void 
		{
			var i:int;
			if (_arrCardImage && _arrCardImage.length > 0) 
			{
				for (i = 0; i < _arrCardImage.length; i++) 
				{
					trace("cac quan danh ra: ", _arrCardImage[i].id, idCard)
					if (_arrCardImage[i].id == idCard) 
					{
						removeEventCard(_arrCardImage[i]);
						content.cardContainer.removeChild(_arrCardImage[i]);
						_arrCardImage[i] = null
						_arrCardImage.splice(i, 1);
						_arrCardInt.splice(i, 1);
						
						
						trace("minh danh bai ra")
						_isMyTurn = false;
						showHitCard();
						showPassTurn();
					}
				}
				for (i = 0; i < _arrCardImage.length; i++) 
				{
					_arrCardImage[i].pos = i;
					TweenMax.to(_arrCardImage[i], .2, { x:_distanceConstan + _distance * i } );
				}
			}
			if (_arrCardChoose && _arrCardChoose.length > 0) 
			{
				for (i = 0; i < _arrCardChoose.length; i++) 
				{
					if (_arrCardChoose[i] == idCard) 
					{
						_arrCardChoose.splice(i, 1);
					}
				}
			}
			
			if (_arrCardFirst && _arrCardFirst.length > 0) 
			{
				for (i = 0; i < _arrCardFirst.length; i++) 
				{
					if (_arrCardFirst[i] == idCard) 
					{
						_arrCardFirst.splice(i, 1);
					}
				}
			}
			
			
		}
		
		private function removeEventCard(card:CardTlmn):void 
		{
			card.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function removeAllCard():void 
		{
			var i:int;
			var lengthRemove:int
			if (_arrCardImage) 
			{
				lengthRemove = _arrCardImage.length;
			}
			
			
			if (_arrCardImage && lengthRemove > 0) 
			{
				for (i = 0; i < _arrCardImage.length; i++) 
				{
					if (_arrCardImage[i]) 
					{
						removeEventCard(_arrCardImage[i]);
						//_arrCardImage[i].dedestroy();
						content.cardContainer.removeChild(_arrCardImage[i]);
						_arrCardImage[i] = null
					}
					
				}
				
			}
			
			_clock.removeTween();
			_arrCardImage = [];
			_arrCardInt = [];
			_arrCardChoose = [];
			_arrCardFirst = [];
			_isPassTurn = false;
			
			_checkSort = false;
		}
		
	}
	
}