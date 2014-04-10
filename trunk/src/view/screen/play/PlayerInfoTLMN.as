package view.screen.play 
{
	import Base64
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import control.ConstTlmn;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	import sound.SoundManager;
	import view.Base;
	import view.card.CardTlmn;
	
	import view.card.CardDeck;
	import view.card.CardManager;
	import view.clock.Clock;
	
	/**
	 * ...
	 * @author Bim kute
	 */
	public class PlayerInfoTLMN extends Base 
	{
		
		public var unLeaveCards:Array; // Mảng chứa các lá bài chưa đánh
		private var _avatar:Avatar;
		public var _pos:int;
		public var _remainingCard:int;
		private var _cardDeck:CardDeck;
		private var _arrCardDeck:Array = [];
		public var _userName:String = "";
		private var _contextMenu:ContextMenu;
		private var _moneyEffect:MoneyEffect;
		private var _clock:Clock;
		public var _isPlaying:Boolean = false;
		private var _arrStar:Array = [];
		
		private var _count:int = -1;
		private var _arrCardList:Array = [];
		
		private var _linkAvatar:String = "";
		private var _linkBg:String = "";
		private var _money:int;
		public var ready:Boolean = false;
		
		private var _timerShowChatde:Timer;
		
		public var _sex:Boolean = true;
		
		private var distance:int = 20;
		
		public function PlayerInfoTLMN(pos:int) 
		{
			
			content = new PlayerInfoTlmnMc();
			addChild(content);
			
			_pos = pos;
			if (!_clock) 
			{
				_clock = new Clock();
				addChild(_clock);
				_clock.x = 23;
				_clock.y = 13;
				_clock.addEventListener(Clock.COUNT_TIME_FINISH, onOverTimer);
			}
			if (!_avatar) 
			{
				_avatar = new Avatar();
				content.specialAvatar.addChild(_avatar);
				
				//content.setChildIndex(_avatar, 0);
				
			}
			
			if (_pos == 2) 
			{
				
				content.nextturn.x = 127;
				content.nextturn.y = 30;
				content.chatde.x = 135;
				content.chatde.y = 50;
				content.effectMoney.y = 170;
				content.level.x = 105;
				content.iconMaster.x = 0;
				content.effectMoneySpecial.y = 100;
				content.numCardRemainTxt.x = 168;
				content.numCardRemainTxt.y = 177;
				distance = 19.5;
			}
			else if (_pos == 1) 
			{
				
				content.nextturn.x = -125;
				content.nextturn.y = -1;
				content.chatde.x = -115;
				content.chatde.y = 17;
				content.effectMoney.y = 170;
				content.level.x = 105;
				content.iconMaster.x = 0;
				content.effectMoneySpecial.y = 100;
				content.numCardRemainTxt.x = -37;
				content.numCardRemainTxt.y = 52;
			}
			else
			{
				content.nextturn.x = -81;
				content.nextturn.y = 30;
				content.chatde.x = -81;
				content.chatde.y = 50;
				content.effectMoney.y = 170;
				content.level.x = 1;
				content.iconMaster.x = 90;
				content.effectMoneySpecial.y = 100;
				content.numCardRemainTxt.x = -37;
				content.numCardRemainTxt.y = 177;
				distance = 19.5;
			}
			
			content.iconMobile.visible = false;
			content.chatde.visible = false;
			content.nextturn.visible = false;
			content.effectMoneySpecial.visible = false;
			//_avatar.addEventListener("onClick", onClickShowContex);
			//addMoneyEffect();
			
			content.effectMoney.visible = false;
			content.effectMoney.visible = false;
			content.numCardRemainTxt.visible = false;
			content.level.txt.mouseEnabled = false;
			content.numCardRemainTxt.mouseEnabled = false;
			
			content.inviteBtn.addEventListener(MouseEvent.CLICK, onClickInvite);
			content.showDetailUser.addEventListener(MouseEvent.CLICK, onClickShowContex);
			nothing();
		}
		
		private function onShowInfoUser(e:MouseEvent):void 
		{
			if (_contextMenu) 
			{
				_contextMenu.visible = true;
			}
		}
		
		private function onOverTimer(e:Event):void 
		{
			if (_clock) 
			{
				_clock.visible = false;
			}
		}
		
		public function nothing():void 
		{
			content.inviteBtn.visible = true;
			
			_userName = "";
			_linkAvatar = "";
			_remainingCard = 0;
			
			content.level.visible = false;
			content.iconMaster.visible = false;
			
			content.effectMoneySpecial.visible = false;
			content.effectMoney.visible = false;
			content.nextturn.visible = false;
			content.chatde.visible = false;
			content.numCardRemainTxt.visible = false;
			content.confirmReady.visible = false;
			content.outRoom.visible = false;
			content.specialAvatar.visible = false;
			content.showDetailUser.visible = false;
			_clock.visible = false;
			
			
			content.txtName.visible = false;
			content.txtMoney.visible = false;
			content.iconMobile.visible = false;
			
			content.resultGame.visible = false;
			
			
			_avatar.visible = false;
		}
		
		private function resetPosChat():void 
		{
			if (_pos == 2) 
			{
				
				
				content.chatde.x = 115;
				content.chatde.y = 15;
				
			}
			else if (_pos == 1) 
			{
				
				
				content.chatde.x = -111;
				content.chatde.y = 25;
				
			}
			else
			{
				
				content.chatde.x = -90;
				content.chatde.y = 15;
				
			}
		}
		
		private function onClickInvite(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ConstTlmn.INVITE));
		}
		
		public function myReady():void 
		{
			content.confirmReady.visible = true;
			ready = true;
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
			
			if (_remainingCard < 6) 
			{
				if (_pos == 1) 
				{
					content.chatde.x += (6 - _remainingCard) * 10;
				}
				else 
				{
					content.chatde.y += (6 - _remainingCard) * 10;
				}
			}
			content.chatde.visible = true;
			content.setChildIndex(content.chatde, content.numChildren - 1);
			
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
		
		public function startGame():void 
		{
			content.confirmReady.visible = false;
		}
		
		public function showEffectGameOver(obj:Object):void 
		{
			
			if (int(obj[ConstTlmn.MONEY]) > 0) 
			{
				content.resultGame.gotoAndStop(1);
				TextField(content.effectMoneySpecial).defaultTextFormat = _textformatWin;
				
				if (SoundManager.getInstance().isSoundOn) 
				{
					var rd:int = int(Math.random() * 5);
					if (_sex) 
					{
						SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_WIN_ + String(rd + 1) );
					}
					else 
					{
						SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_WIN_ + String(rd + 1) );
					}
				}
			}
			else 
			{
				content.resultGame.gotoAndStop(2);
				TextField(content.effectMoneySpecial).defaultTextFormat = _textformatLose;
			}
			
			content.resultGame.visible = true;
			
			ready = false;
			
			//content.effectMoneySpecial.visible = true;
			content.effectMoneySpecial.visible = false;
			
			trace("xem lai tien cua nguoi choi: ", _money, obj[ConstTlmn.MONEY])
			_money = _money + int(obj[ConstTlmn.MONEY]);
			content.effectMoneySpecial.text = format(int(obj[ConstTlmn.MONEY]));
			TweenMax.to(content.effectMoneySpecial, 3, { y:content.effectMoneySpecial.y - 130, onComplete:onCompleteShowMoney } );
			
			//addCardImage(obj[ConstTlmn.CARDS]);
		}
		
		private function addCardImage(arr:Array):void 
		{
			for (var i:int = 0; i < arr.length; i++) 
			{
				var card:CardTlmn = new CardTlmn(arr[i]);
				content.addChild(card);
				card.scaleX = card.scaleY = .75;
				_arrCardDeck.push(card);
				
				if (_pos == 0) 
				{
					card.rotation = 90;
					card.x = -96;
					card.y = 13 + 27 * i;
				}
				else if (_pos == 2)
				{
					card.rotation = 90;
					card.x = 118;
					card.y = 13 + 27 * i;
				}
				else 
				{
					card.x = 165 + 30 * i;
					card.y = 130;
				}
			}
		}
		
		public function visibleResultGame():void 
		{
			content.resultGame.visible = false;
		}
		
		private function onCompleteShowMoney():void 
		{
			content.effectMoneySpecial.visible = false;
			content.effectMoneySpecial.y += 130;
			content.txtMoney.text = format(_money);
			
		}
		
		public function nextturn():void 
		{
			var myDate:Date = new Date();
			trace("thang user nao do bo luot: ", myDate.minutes, myDate.seconds);
			content.nextturn.visible = true;
			content.setChildIndex(content.nextturn, content.numChildren - 1);
			var rd:int = int(Math.random() * 5);
			if (SoundManager.getInstance().isSoundOn) 
			{
				if (_sex) 
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
		
		
		public function stopTimer():void 
		{
			_clock.visible = false;
			_clock.removeTween();
		}
		
		public function checkPosClock():void 
		{
			_clock.visible = true;
			_clock.countTime(20);
		}
		
		private function addMoneyEffect():void 
		{
			if (!_moneyEffect) 
			{
				_moneyEffect = new MoneyEffect();
				if (_pos == 2) 
				{
					
					
					_moneyEffect.x = 35;
					_moneyEffect.y = 170;
					
				}
				else if (_pos == 1) 
				{
					
					_moneyEffect.x = -95;
					_moneyEffect.y = 85;
				}
				else
				{
					
					_moneyEffect.x = 200;
					_moneyEffect.y = 85;
					
				}
					
				content.addChild(_moneyEffect);
			}
		}
		
		public function addMyMoney(money:int):void 
		{
			content.userMoney.text = format(money);
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
			
			var str:String = "";
			trace("money bi chat info: ", content.txtMoney.text, content.txtMoney.text.length)
			for (var i:int = 0; i < content.txtMoney.text.length; i++) 
			{
				if (String(content.txtMoney.text).charAt(i) != ",")
				{
					str += String(content.txtMoney.text).charAt(i);
				}
			}
			trace("money bi chat info: ", str, money)
			var myMoney:int = int(str) + int(money);
			content.txtMoney.text = format(myMoney);
			
			//var myMoney:int = int(content.txtMoney.text) + int(money);
			//content.txtMoney.text = format(myMoney);
			
			_money = _money + int(money);
			content.effectMoneySpecial.text = format(int(money));
			TweenMax.to(content.effectMoneySpecial, 3, { y: content.effectMoneySpecial.y - 130, onComplete:onCompleteMoneySpecial } );
			//_moneyEffect.showEffect(money);
		}
		
		private function onCompleteMoneySpecial():void 
		{
			content.effectMoneySpecial.visible = false;
			content.effectMoneySpecial.y += 130;
			content.txtMoney.text = format(_money);
		}
		
		private function onClickShowContex(e:Event):void 
		{
			if (!_contextMenu) 
			{
				_contextMenu = new ContextMenu();
				addChild(_contextMenu);
				
				_contextMenu.setInfo(content.txtName.text, String(_money), "10", _linkAvatar, false);
				_contextMenu.addEventListener("kick", onClickKick);
				_contextMenu.addEventListener("close", onClose);
				_contextMenu.addEventListener("add friend", onClickAddFriend);
				_contextMenu.addEventListener("remove friend", onRemoveFriend);
			}
			else 
			{
				if (_contextMenu.visible == true) 
				{
					_contextMenu.visible = false;
				}
				else 
				{
					_contextMenu.visible = true;
				}
				
			}
			
			//_contextMenu.setInfo(content.txtName.text, content.txtMoney.text, content.level.txt.text, _linkAvatar, false);
			setPosContext();
		}
		
		private function onRemoveFriend():void 
		{
			dispatchEvent(new Event("remove friend"));
		}
		
		private function onClose(e:Event):void 
		{
			if (_contextMenu) 
			{
				_contextMenu.visible = false;
			}
		}
		
		private function onClickKick(e:Event):void 
		{
			dispatchEvent(new Event("kick"));
		}
		
		private function onClickAddFriend(e:Event):void 
		{
			dispatchEvent(new Event("add friend"));
		}
		
		private function onClickViewInfo(e:Event):void 
		{
			
		}
		
		private function setPosContext():void 
		{
			switch (_pos) 
			{
				case 0:
					_contextMenu.x = -154;
					_contextMenu.y = -168;
				break;
				case 1:
					_contextMenu.x = -271;
					_contextMenu.y = 11;
				break;
				case 2:
					_contextMenu.x = 4;
					_contextMenu.y = -167;
				break;
				default:
			}
		}
		
		/**
		 * link avatar
		 * tien
		 * ten
		 * so bia con lai
		 */
		public function getInfoPlayer(pos:int, userName:String, money:String, linkAvatar:String, remainingCard:int,
										userPlaying:Boolean, gamePlaying:Boolean, isMaster:Boolean, displayName:String,
										sex:Boolean):void 
		{
			//_pos = pos;
			_sex = sex;
			content.inviteBtn.visible = false;
			_isPlaying = userPlaying;
			ready = userPlaying;
			trace("thang nao la chu phong: ", isMaster, _isPlaying)
			
			content.level.visible = true;
			
			_money = int(money);
			
			content.txtName.visible = true;
			content.txtMoney.visible = true;
			
			if (isMaster) 
			{
				content.iconMaster.visible = true;
			}
			else 
			{
				content.iconMaster.visible = false;
			}
			
			/*var str:String = userName.substr(userName.length - 3, 3);
			if (str == "|fb") 
			{
				userName = userName.replace("|fb", "");
				userName = com.giantflyingsaucer.Base64.decode(userName);
			}*/
			_userName = userName;
			_clock.setParent(sex);
			
			content.txtName.text = displayName;
			content.txtMoney.text = format(int(money));
			
			
			trace("===============", pos, userName, "++++++++++++++++++")
			if (!userPlaying) 
			{
				stopTimer();
			}
			
			//var typeUser:Boolean = false;//true la monters, false:normal
			//var bgAvatar:String;
			
			if (_linkAvatar != linkAvatar && linkAvatar != null) 
			{
				_avatar.addImg(linkAvatar);
				_linkAvatar = linkAvatar;
			}
			
			_avatar.visible = true;
			content.specialAvatar.visible = true;
			content.showDetailUser.visible = true;
			
			if (gamePlaying) 
			{
				
				content.confirmReady.visible = false;
				
				if (remainingCard > 0 && userPlaying) 
				{
					content.numCardRemainTxt.visible = true;
					content.numCardRemainTxt.text = String(remainingCard);
					addCardDeck(remainingCard);
					content.numCardRemainTxt.visible = true;
				}
				else 
				{
					content.numCardRemainTxt.visible = false;
				}
			}
			else 
			{
				if (userPlaying) 
				{
					content.confirmReady.visible = true;
				}
				else 
				{
					content.confirmReady.visible = false;
				}
			}
			
			_remainingCard = remainingCard;
			
			
		}
		
		private function loadBgMonters(str:String, type:Boolean):void 
		{
			var loader:Loader = new Loader();
			var urlReq:URLRequest = new URLRequest(str);
			if (type) 
			{
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoadBgMonter);
			}
			else 
			{
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoadBgNormal);
			}
			
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorLoadBg);
			loader.load(urlReq);
		}
		
		private function onCompleteLoadBgMonter(e:Event):void 
		{
			trace("co bao nhieu thang trogn avatar dac biet: ", content.specialAvatar.numChildren)
			for (var i:int = 0; i < content.specialAvatar.numChildren; i++) 
			{
				content.specialAvatar.removeChild(content.specialAvatar.getChildAt(i));
			}
			var loader:Loader = e.target.loader as Loader;
			content.specialAvatar.addChild(loader);
		}
		
		private function onCompleteLoadBgNormal(e:Event):void 
		{
			trace("co bao nhieu thang trogn avatar thuong: ", content.avatarNormal.numChildren)
			for (var i:int = 0; i < content.avatarNormal.numChildren; i++) 
			{
				content.avatarNormal.removeChild(content.avatarNormal.getChildAt(i));
			}
			var loader:Loader = e.target.loader as Loader;
			content.avatarNormal.addChild(loader);
			trace("load xog avatar: ============================")
		}
		
		private function errorLoadBg(e:IOErrorEvent):void 
		{
			trace("ko load dc bg user con lai", _pos)
		}
		
		private function addCardDeck(remainingCard:int):void 
		{
			var i:int
			removeAllCards();
			
			_arrCardDeck = [];
			
			
			for (i = 0; i < remainingCard; i++) 
			{
				_cardDeck = new CardDeck();
				_cardDeck.scaleX = _cardDeck.scaleY = .35;
				
				if (_pos == 2) 
				{
					_cardDeck.x = 200;
					_cardDeck.y = -96 + distance * i;
					_cardDeck.rotation = 90;
				}
				else 
				{
					
					if (_pos == 1) 
					{
						
						_cardDeck.x = -305 + distance * i;
						_cardDeck.y = 15;
					}
					else 
					{
						_cardDeck.rotation = 90;
						_cardDeck.x = -5;
						_cardDeck.y = -96 + distance * i;
					}
					
					
				}
				content.addChild(_cardDeck);
				_arrCardDeck.push(_cardDeck);
			}
			
			content.setChildIndex(content.numCard, content.numChildren - 1);
			if (remainingCard > 0) 
			{
				content.numCardRemainTxt.visible = true;
				_remainingCard = remainingCard;
				content.numCardRemainTxt.text = String(remainingCard);
			}
			
		}
		
		public function removeCardImage(arr:Array):void 
		{
			for (var i:int = 0; i < arr.length; i++) 
			{
				for (var j:int = 0; j < _arrCardDeck.length; j++) 
				{
					trace(arr[i], "=============== so sanh =============", _arrCardDeck[j].id, "length: ", _arrCardDeck.length)
					if (arr[i] == _arrCardDeck[j].id) 
					{
						
						var card:CardTlmn = _arrCardDeck[j];
						
						content.removeChild(card);
						card = null;
						_arrCardDeck.splice(j, 1);
						break;
					}
				}
			}
			
			if (_arrCardDeck.length > 0) 
			{
				for (i = 0; i < _arrCardDeck.length; i++) 
				{
					if (_pos == 2) 
					{
						TweenMax.to(_arrCardDeck[i], .2, { x:-30 - 20 * i } );
					}
					else if (_pos == 1) 
					{
						TweenMax.to(_arrCardDeck[i], .2, { x:65 - 20 * i } );
					}
					else 
					{
						TweenMax.to(_arrCardDeck[i], .2, { x:325 - 20 * i } );
					}
				}
			}
			
		}
		
		public function waitNewGame():void 
		{
			content.outRoom.visible = false;
		}
		
		public function outRoom():void 
		{
			nothing();
			
			ready = false;
			
			if (_isPlaying) 
			{
				content.outRoom.visible = true;
			}
			else 
			{
				content.outRoom.visible = false;
			}
			
			_isPlaying = false;
			
			if (_contextMenu) 
			{
				_contextMenu.visible = false;
			}
			
			
		}
		
		public function removeAllEvent():void 
		{
			if (_contextMenu) 
			{
				_contextMenu.removeEventListener("kick", onClickKick);
			}
			
			_clock.removeEventListener(Clock.COUNT_TIME_FINISH, onOverTimer);
			content.showDetailUser.removeEventListener("onClick", onClickShowContex);
			content.inviteBtn.removeEventListener(MouseEvent.CLICK, onClickInvite);
		}
		
		public function removeCardDeck(num:int):void 
		{
			if (_arrCardDeck && _arrCardDeck.length > 0) 
			{
				for (var i:int = 0; i < num; i++) 
				{
					var cardDeck:CardDeck = _arrCardDeck.shift();
					content.removeChild(cardDeck);
					cardDeck = null;
				}
			}
			
			_remainingCard -= num;
			content.numCardRemainTxt.text = String(_remainingCard);
		}
		
		public function resultGame():void 
		{
			_remainingCard = 0;
			content.numCardRemainTxt.text = "";
			content.numCardRemainTxt.visible = false;
			content.outRoom.visible = false;
		}
		
		public function dealCard(arrCardList:Array):void 
		{
			_remainingCard = 0;
			_arrCardList = arrCardList;
			_arrCardList = _arrCardList.sort(Array.NUMERIC);
			//allVisible();
			if (!_arrCardDeck) 
			{
				_arrCardDeck = [];
			}
			_isPlaying = true;
			if (arrCardList.length > 0) 
			{
				_count++;
				trace("cac quan bai dc chia: ", _arrCardList[_count])
				startDeal(arrCardList[_count]);
			}
			else 
			{
				trace("chia bai xem co cheater hay ko : ", _count)
				startDeal(_count);
			}
			
			content.confirmReady.visible = false;
			////trace("chia bai cho cac info, ", type)
			
			
		}
		
		private function startDeal(numCard:int):void 
		{
			
			if (numCard < 0) 
			{
				var cardDeck:CardDeck = new CardDeck();
				cardDeck.scaleX = cardDeck.scaleY = .35;
				_remainingCard++;
				
				if (_pos == 2) 
				{
					//trace("chia bai cho cac info, vị trí là: 2  ", _pos)
					cardDeck.x = 537
					cardDeck.y = 107;
					cardDeck.rotation = 90;
					/*cardDeck.x = 0;
						cardDeck.y = 0;*/
					
				}
				else 
				{
					
					if (_pos == 1) 
					{
						//trace("chia bai cho cac info, vị trí là: 1 ", _pos)
						cardDeck.x = -112;
						cardDeck.y = 216;
						/*cardDeck.x = 0;
						cardDeck.y = 0;*/
					}
					else
					{
						cardDeck.rotation = 90;
						//trace("chia bai cho cac info, vị trí là:3  ", _pos)
						cardDeck.x = -303;
						cardDeck.y = 108;
						/*cardDeck.x = 0;
						cardDeck.y = 0;*/
					}
					
					
				}
				content.addChild(cardDeck);
				//trace("check carddeck: ", cardDeck)
				_arrCardDeck.push(cardDeck);
				
				//setChildIndex(
				effectDealCard(cardDeck);
			}
			else 
			{
				trace("cac quan bai: ", numCard, "pos: ", _pos)
				var card:CardTlmn = new CardTlmn(numCard);
				card.scaleX = card.scaleY = .8;
				if (_pos == 2) 
				{
					//trace("chia bai cho cac info, vị trí là: 2  ", _pos)
					card.x = -40;
					card.y = 150;
					card.rotation = 0;
					/*cardDeck.x = 0;
						cardDeck.y = 0;*/
					
				}
				else 
				{
					//card.rotation = 90;
					if (_pos == 1) 
					{
						//trace("chia bai cho cac info, vị trí là: 1 ", _pos)
						card.x = -300;
						card.y = 0;
						/*cardDeck.x = 0;
						cardDeck.y = 0;*/
					}
					else
					{
						//trace("chia bai cho cac info, vị trí là:3  ", _pos)
						card.x = 500;
						card.y = 300;
						/*cardDeck.x = 0;
						cardDeck.y = 0;*/
					}
					
					
				}
				content.addChildAt(card, 0);
				//trace("check carddeck: ", cardDeck)
				_arrCardDeck.push(card);
				
				//setChildIndex(
				effectDealCardImage(card);
			}
			
		}
		
		private function effectDealCardImage(card:CardTlmn):void 
		{
			if (card) 
			{
				trace("check carddeck khi bat dau tween: ", _pos)
				if (_pos == 2) 
				{
					
					TweenMax.to(card, .1, { bezierThrough:[ { x: -30 - distance * _count, y:content.numCard.y - 3} ], 
								ease:Back.easeOut, onComplete:onComleteDealCard } ); 
					//TweenMax.to(_arrCardDeck[type], 1, { x:0 * type, y:0} ); 
					////trace("di chuyen den con , vị trí là:  ", _pos)
				}
				else 
				{
					if (_pos == 1) 
					{
						TweenMax.to(card, .1, { bezierThrough:[ { x: 65 - distance * _count, y: -80 } ], 
								ease:Back.easeOut, onComplete:onComleteDealCard } ); 
						
					}
					else 
					{
						TweenMax.to(card, .1, { bezierThrough:[ { x: 325 - distance * _count, y: 220 } ], 
								ease:Back.easeOut, onComplete:onComleteDealCard } ); 
						trace("toa do thang nay: ", card.x, card.y)
					}
					////trace("di chuyen den con , vị trí là:  ", _pos)
					
					//TweenMax.to(_arrCardDeck[type], 1, { x:0 * type, y:0} ); 
				}
				_count++;
				
			}
		}
		
		private function effectDealCard(cardDeck:CardDeck):void 
		{
			
			if (cardDeck) 
			{
				//trace("check carddeck khi bat dau tween: ", cardDeck)
				if (_pos == 2) 
				{
					
					TweenMax.to(cardDeck, .1, { bezierThrough:[ { x: 200, y:-96 + distance * _remainingCard} ], 
								ease:Back.easeOut, onComplete:onComleteDeal } ); 
					//TweenMax.to(_arrCardDeck[type], 1, { x:0 * type, y:0} ); 
					////trace("di chuyen den con , vị trí là:  ", _pos)
				}
				else 
				{
					if (_pos == 1) 
					{
						TweenMax.to(cardDeck, .1, { bezierThrough:[ { x: -305 + distance * _remainingCard, y:15} ], 
								ease:Back.easeOut, onComplete:onComleteDeal } ); 
						
					}
					else 
					{
						TweenMax.to(cardDeck, .1, { bezierThrough:[ { x: -5, y: -96 + distance * _remainingCard} ], 
								ease:Back.easeOut, onComplete:onComleteDeal} ); 
						
					}
					////trace("di chuyen den con , vị trí là:  ", _pos)
					
					//TweenMax.to(_arrCardDeck[type], 1, { x:0 * type, y:0} ); 
				}
				
			}
			/*if (_pos == 2) 
				{
					_cardDeck.x = content.numCard.x + 25 + 10 * i;
					_cardDeck.y = content.numCard.y - 6;
					
				}
				else 
				{
					
					_cardDeck.x = content.numCard.x + 25;
					_cardDeck.y = content.numCard.y - 6 - 10 * i;
					
				}*/
			////trace("xem effect chia bai: ", type,"==", _arrCardDeck)
			
		}
		
		private function onComleteDealCard():void 
		{
			trace("chia bai complete: ", _count)
			if (_count < 13 && _isPlaying) 
			{
				startDeal(_arrCardList[_count]);
			}
			else 
			{
				if (_userName == "") 
				{
					_isPlaying = false;
				}
				
			}
		}
		
		private function onComleteDeal():void 
		{
			if (_remainingCard < 13 && _isPlaying) 
			{
				startDeal(_count);
			}
			else 
			{
				if (_userName == "") 
				{
					_isPlaying = false;
				}
				content.numCardRemainTxt.visible = true;
				content.setChildIndex(content.numCardRemainTxt, content.numChildren - 1);
				content.numCardRemainTxt.text = String(_remainingCard);
			}
		}
		
		public function killAllTween():void 
		{
			TweenMax.killAll();
			_clock.removeTween();
		}
		
		public function reset():void 
		{
			_remainingCard = 0;
			ready = false;
			
			content.effectMoneySpecial.visible = false;
			content.effectMoney.visible = false;
			content.nextturn.visible = false;
			content.numCardRemainTxt.visible = false;
			content.confirmReady.visible = false;
			
			
			_clock.visible = false;
			_isPlaying = false;
			
			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onVisibleOutRoom);
			timer.start();
		}
		
		private function onVisibleOutRoom(e:TimerEvent):void 
		{
			var timer:Timer = e.currentTarget as Timer;
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onVisibleOutRoom);
			timer.stop();
			
			content.outRoom.visible = false;
		}
		
		public function removeAllCards():void 
		{
			trace("remove di luc nao: ", _arrCardDeck, "============")
			if (_arrCardDeck && _arrCardDeck.length > 0) 
			{
				for (var i:int = 0; i < _arrCardDeck.length; i++) 
				{
					content.removeChild(_arrCardDeck[i]);
					_arrCardDeck[i] = null;
				}
				
			}
			
			_arrCardDeck = [];
			resultGame();
			_count = -1;
			
		}
		
		//dung khi co 1 user thoat ra, van giu lai bai, nhung xoa avatar
		public function removeAvatar():void 
		{
			//trace(_userName)
			//allUnVisible();
			_userName = "";
			
			content.txtName.text = "";
			content.txtMoney.text = "";
		}
		
		private function allVisible():void 
		{
			_avatar.visible = content.txtName.visible = content.txtMoney.visible = true;// = content.numCard.visiblecontent.iconMobile.visible = 
			content.iconFriend.visible = true;// = content.iconMaster.visible
		}
		
		private function allUnVisible():void 
		{
			//_avatar.visible = false;
			//content.iconFriend.visible = content.iconMobile.visible = content.iconMaster.visible = false;
			//content.txtName.visible = content.txtMoney.visible = content.numCard.visible 
		}
		
		// push new card vào mảng các lá bài chưa đánh
		public function pushNewUnLeaveCard(card:CardTlmn):void
		{
			/*if (!unLeaveCards)
				unLeaveCards = new Array();
			unLeaveCards.push(card);
			card.isMouseInteractive = isCardInteractive;
			
			if (isCardInteractive)
			{
				card.addEventListener(MouseEvent.CLICK, onClickCard);
			}
			else
			{
				card.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownCard);
				card.removeEventListener(MouseEvent.CLICK, onClickCard);
				if (stage)
					stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
				card.removeEventListener(Card.IS_SELECTED, onCardIsSelected);
				card.removeEventListener(Card.IS_DE_SELECTED, onCardIsDeSelected);
			}
			
			if (formName == BELOW_USER && unLeaveCards.length == 13)
			{
				//deckName_1.visible = deckName_2.visible = deckName_3.visible = deckNameTotal.visible = true;
				//deckNumber_1.visible = deckNumber_2.visible = deckNumber_3.visible = true;
				var index:int;
				index = maubinhLogic.checkGroup(1, unLeaveCards);
				deckRank[1] = index;
				deckName_1.text = maubinhLogic.groupName[index];
				index = maubinhLogic.checkGroup(2, unLeaveCards);
				deckRank[2] = index;
				deckName_2.text = maubinhLogic.groupName[index];
				index = maubinhLogic.checkGroup(3, unLeaveCards);
				deckRank[3] = index;
				deckName_3.text = maubinhLogic.groupName[index];
				
				checkTotalDeck();
				
				var tempTimer:Timer = new Timer(500, 1);
				tempTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onArrangeGroup);
				//tempTimer.start();
				
				dispatchEvent(new Event(UPDATE_THREE_GROUP));
			}*/
		}
		
		public function getUnUsePosition(positionType:String):Object
		{
			var tempPositionArray:Array;
			/*switch (positionType) 
			{
				case Card.UN_LEAVE_CARD:
					tempPositionArray = unLeaveCardPosition;
				break;
			}
			var i:int;
			for (i = 0; i < tempPositionArray.length; i++) 
			{
				if (!tempPositionArray[i].hasOwnProperty("isUsed"))
					return tempPositionArray[i];
				if (tempPositionArray[i]["isUsed"] == false)
					return tempPositionArray[i];
			}*/
			return tempPositionArray[0];
		}
	}
}