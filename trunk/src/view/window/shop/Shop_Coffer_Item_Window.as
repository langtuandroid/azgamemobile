package view.window.shop 
{
	import com.adobe.crypto.MD5;
	import com.isvn.extension.sms.MSGExtension;
	import com.milkmangames.nativeextensions.GVFacebookRequestFilter;
	import com.ssd.ane.AndroidExtensions;
	import control.ConstTlmn;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import model.chooseChannelData.MyInfo;
	import model.MainData;
	import model.MyDataTLMN;
	import request.HTTPRequest;
	import view.ScrollView.ScrollViewYun;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.ConfirmWindow;
	import view.window.LoadingWindow;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class Shop_Coffer_Item_Window extends Sprite 
	{
		public static var CHANGE_TAB:String = "changeTab";
		private var myContent:MovieClip;
		private var choosePay:ChoosePayMoneyType;
		private var buyTour:BuyTourTicket;
		private var typeOfPay:int; //0:thanh toan bang gold, 1:thanh toan bang chip
		private var _arrBtnInTab:Array;
		
		private var _arrHeaderTab:Array;
		
		private var _arrBoard:Array;
		
		public var _type:int; // dang chon xem cai j`
		/**
		 * 1:vina, 2:mobi, 3:viettel, 4:Vtc, 5:megacard, 6:fptgate
		 */
		private var _typOfNetwork:String = "VNP"; // dang chon nap the bang nha mang nao
		
		private var scrollView:ScrollViewYun;
		private var scrollViewForRank:ScrollViewYun;
		private var windowLayer:WindowLayer = WindowLayer.getInstance();
		
		private var _arrAvatar:Array = [];
		private var _arrGold:Array = [];
		private var _arrItem:Array = [];
		private var _arrTour:Array = [];
		private var _arrGift:Array = [];
		
		private var _arrMyAvatar:Array = [];
		private var _arrMyItem:Array = [];
		private var _arrMyGold:Array = [];
		
		private var _arrTopRich:Array = [];
		private var _arrTopPlayer:Array = [];
		private var _arrTopRoyal:Array = [];
		
		private var avatarChoseBuy:*;
		private var goldChoseBuy:*;
		
		private var basePath:String = "";
		
		private var changeGift:MovieClip;
		private var tutorialAddMoney:MovieClip;
		
		private var loadAvatarShop:int;
		private var loadGoldShop:int;
		private var loadItemShop:int;
		
		private var loadAvatarCoffer:int;
		private var loadGoldCoffer:int;
		private var loadItemCoffer:int;
		
		public function Shop_Coffer_Item_Window() 
		{
			super();
			
			if (MainData.getInstance().isTest) 
			{
				basePath = "http://wss.test.azgame.us/";
			}
			else 
			{
				basePath = "http://wss.azgame.us/";
			}
			myContent = new Shop_Coffer_Item_Mc();
			addChild(myContent);
			myContent.mask = myContent.boardMask;
			//myContent.boardMask.visible = false;
			
						//bang xep hang, nap tien, shop, hom do
			_arrHeaderTab = [myContent.chooseInStandingMc, myContent.chooseInAddMoneyMc, myContent.chooseInShopMc,
							myContent.chooseInCofferMc];
							//xep hang, nap tien, shop, hom do
			_arrBoard = [myContent.standingBg, myContent.smsBg, myContent.rakingBg, myContent.containerItemMc];
						//xep hang, nap sms, nap the, chua item
			myContent.containerItemMc.x = 58;
			scrollView = new ScrollViewYun();
			scrollView.setData(myContent.containerItemMc, 10);
			scrollView.distanceInColumn = 25;
			scrollView.distanceInRow = 10;
			scrollView.columnNumber = 2;
			scrollView.isScrollVertical = true;
			myContent.addChild(scrollView);
			scrollView.y = 10;
			
			scrollViewForRank = new ScrollViewYun();
			scrollViewForRank.setData(myContent.containerTopMc, 0);
			scrollViewForRank.distanceInColumn = 55;
			scrollViewForRank.distanceInRow = 55;
			scrollViewForRank.columnNumber = 1;
			scrollViewForRank.isScrollVertical = true;
			myContent.addChild(scrollViewForRank);
			scrollViewForRank.y = 0;
			
			/*var textfield:TextField = new TextField();
			textfield.text = "31/07 - v1";
			textfield.x = 50;
			textfield.y = 420;
			myContent.addChild(textfield);*/
			//scrollView.visible = false;
			addEvent();
			
			var i:int;
			var j:int;
			for (i = 0; i < _arrHeaderTab.length; i++) 
			{
				for (j = 0; j < _arrHeaderTab[i].numChildren; j++) 
				{
					_arrHeaderTab[i].getChildAt(j).stop();
				}
			}
			
			
			
			tabOn(3);
			headerOn(2);
			boardOn(3);
			
		}
		
		public function removeAllEvent():void 
		{
			var i:int; 
			
			myContent.chooseInShopMc.chooseAvatar.removeEventListener(MouseEvent.MOUSE_UP, onClickShowAvatar);
			myContent.chooseInShopMc.chooseGold.removeEventListener(MouseEvent.MOUSE_UP, onClickShowGold);
			myContent.chooseInShopMc.chooseItem.removeEventListener(MouseEvent.MOUSE_UP, onClickShowItem);
			myContent.chooseInShopMc.chooseTour.removeEventListener(MouseEvent.MOUSE_UP, onClickShowTour);
			myContent.chooseInShopMc.chooseGift.removeEventListener(MouseEvent.MOUSE_UP, onClickShowGift);
			
			
			
			myContent.chooseInCofferMc.chooseAvatar.removeEventListener(MouseEvent.MOUSE_UP, onClickShowMyAvatar);
			myContent.chooseInCofferMc.chooseGold.removeEventListener(MouseEvent.MOUSE_UP, onClickShowMyGold);
			myContent.chooseInCofferMc.chooseItem.removeEventListener(MouseEvent.MOUSE_UP, onClickShowMyItem);
			myContent.chooseInCofferMc.chooseTour.removeEventListener(MouseEvent.MOUSE_UP, onClickShowMyTour);
			myContent.chooseInCofferMc.chooseGift.removeEventListener(MouseEvent.MOUSE_UP, onClickShowMyGift);
			
			myContent.chooseInAddMoneyMc.raking.removeEventListener(MouseEvent.MOUSE_UP, onClickShowAddMoneyRaking);
			myContent.chooseInAddMoneyMc.sms.removeEventListener(MouseEvent.MOUSE_UP, onClickShowAddMoneySms);
			
			for (i = 0; i < _arrGold.length; i++ ) 
			{
				_arrGold[i].removeEventListener(ConstTlmn.BUY_ITEM, onBuyItemGold);
				
			}
			scrollView.removeAll();
			_arrGold = [];
			
			for (i = 0; i < _arrAvatar.length; i++ ) 
			{
				_arrAvatar[i].removeEventListener(ConstTlmn.BUY_AVATAR, onBuyAvatar);
				
			}
			scrollView.removeAll();
			_arrAvatar = [];
			
		}
		
		private function allHeaderVisible():void 
		{
			myContent.chooseInStandingMc.richBtn.gotoAndStop(2);
			myContent.chooseInStandingMc.topBtn.gotoAndStop(2);
			myContent.chooseInStandingMc.royalBtn.gotoAndStop(2);
			
			myContent.chooseInCofferMc.chooseAvatar.gotoAndStop(2);
			myContent.chooseInCofferMc.chooseGold.gotoAndStop(2);
			myContent.chooseInCofferMc.chooseItem.gotoAndStop(2);
			myContent.chooseInCofferMc.chooseTour.gotoAndStop(2);
			myContent.chooseInCofferMc.chooseGift.gotoAndStop(2);
			
			myContent.chooseInAddMoneyMc.raking.gotoAndStop(2);
			myContent.chooseInAddMoneyMc.sms.gotoAndStop(2);
			myContent.chooseInAddMoneyMc.creditCard.gotoAndStop(2);
			
			myContent.chooseInShopMc.chooseAvatar.gotoAndStop(2);
			myContent.chooseInShopMc.chooseGold.gotoAndStop(2);
			myContent.chooseInShopMc.chooseTour.gotoAndStop(2);
			myContent.chooseInShopMc.chooseItem.gotoAndStop(2);
			myContent.chooseInShopMc.chooseGift.gotoAndStop(2);
		}
		
		private function addEvent():void 
		{
			myContent.rakingBg.choosePayVina.gotoAndStop(2);
			myContent.rakingBg.choosePayMobi.gotoAndStop(1);
			myContent.rakingBg.choosePayViettel.gotoAndStop(1);
			myContent.rakingBg.choosePayVtc.gotoAndStop(1);
			myContent.rakingBg.choosePayMega.gotoAndStop(1);
			myContent.rakingBg.choosePayFpt.gotoAndStop(1);
			
			myContent.standingBg.topMenu.topTlmnBtn.gotoAndStop(1);
			myContent.standingBg.topMenu.topBinhBtn.gotoAndStop(2);
			myContent.standingBg.topMenu.topPhomBtn.gotoAndStop(2);
			
			myContent.chooseInAddMoneyMc.purchase.visible = false;
			
			myContent.chooseInShopMc.chooseAvatar.addEventListener(MouseEvent.MOUSE_UP, onClickShowAvatar);
			myContent.chooseInShopMc.chooseGold.addEventListener(MouseEvent.MOUSE_UP, onClickShowGold);
			myContent.chooseInShopMc.chooseItem.addEventListener(MouseEvent.MOUSE_UP, onClickShowItem);
			myContent.chooseInShopMc.chooseTour.addEventListener(MouseEvent.MOUSE_UP, onClickShowTour);
			myContent.chooseInShopMc.chooseGift.addEventListener(MouseEvent.MOUSE_UP, onClickShowGift);
			
			
			
			myContent.chooseInCofferMc.chooseAvatar.addEventListener(MouseEvent.MOUSE_UP, onClickShowMyAvatar);
			myContent.chooseInCofferMc.chooseGold.addEventListener(MouseEvent.MOUSE_UP, onClickShowMyGold);
			myContent.chooseInCofferMc.chooseItem.addEventListener(MouseEvent.MOUSE_UP, onClickShowMyItem);
			myContent.chooseInCofferMc.chooseTour.addEventListener(MouseEvent.MOUSE_UP, onClickShowMyTour);
			myContent.chooseInCofferMc.chooseGift.addEventListener(MouseEvent.MOUSE_UP, onClickShowMyGift);
			
			
			myContent.chooseInAddMoneyMc.raking.addEventListener(MouseEvent.MOUSE_UP, onClickShowAddMoneyRaking);
			myContent.chooseInAddMoneyMc.sms.addEventListener(MouseEvent.MOUSE_UP, onClickShowAddMoneySms);
			
			
			myContent.rakingBg.userNameTxt.text = MainData.getInstance().chooseChannelData.myInfo.name;
			myContent.rakingBg.userNameTxt.addEventListener(FocusEvent.FOCUS_IN, userNameFocusHandler);
			myContent.rakingBg.userNameTxt.addEventListener(FocusEvent.FOCUS_OUT, userNameFocusOutHandler);
			
			myContent.rakingBg.serinumberTxt.addEventListener(FocusEvent.FOCUS_IN, seriFocusHandler);
			myContent.rakingBg.serinumberTxt.addEventListener(FocusEvent.FOCUS_OUT, seriFocusOutHandler);
			
			myContent.rakingBg.codenumberTxt.addEventListener(FocusEvent.FOCUS_IN, codeFocusHandler);
			myContent.rakingBg.codenumberTxt.addEventListener(FocusEvent.FOCUS_OUT, codeFocusOutHandler);
			
			myContent.rakingBg.codecheckTxt.addEventListener(FocusEvent.FOCUS_IN, codeCheckFocusHandler);
			myContent.rakingBg.codecheckTxt.addEventListener(FocusEvent.FOCUS_OUT, codeCheckFocusOutHandler);
			
			myContent.smsBg.addSmsBtn1.addEventListener(MouseEvent.MOUSE_UP, onClickChoseSms1);
			myContent.smsBg.addSmsBtn2.addEventListener(MouseEvent.MOUSE_UP, onClickChoseSms2);
			myContent.smsBg.addSmsBtn3.addEventListener(MouseEvent.MOUSE_UP, onClickChoseSms3);
			
			myContent.rakingBg.accessBtn.addEventListener(MouseEvent.MOUSE_UP, onClickChoseRaking);
			myContent.rakingBg.choosePayVina.addEventListener(MouseEvent.MOUSE_UP, onClickChosePayVina);
			myContent.rakingBg.choosePayMobi.addEventListener(MouseEvent.MOUSE_UP, onClickChosePayMobi);
			myContent.rakingBg.choosePayViettel.addEventListener(MouseEvent.MOUSE_UP, onClickChosePayViettel);
			myContent.rakingBg.choosePayVtc.addEventListener(MouseEvent.MOUSE_UP, onClickChosePayVtc);
			myContent.rakingBg.choosePayMega.addEventListener(MouseEvent.MOUSE_UP, onClickChosePayMega);
			myContent.rakingBg.choosePayFpt.addEventListener(MouseEvent.MOUSE_UP, onClickChoseRakingPayFpt);
			
			myContent.chooseInStandingMc.richBtn.addEventListener(MouseEvent.MOUSE_UP, onClickShowRichTop);
			myContent.chooseInStandingMc.topBtn.addEventListener(MouseEvent.MOUSE_UP, onClickShowTop);
			myContent.chooseInStandingMc.royalBtn.addEventListener(MouseEvent.MOUSE_UP, onClickShowRoyalTop);
			
			myContent.standingBg.topMenu.topTlmnBtn.addEventListener(MouseEvent.MOUSE_UP, onClickShowTopTlmn);
			myContent.standingBg.topMenu.topBinhBtn.addEventListener(MouseEvent.MOUSE_UP, onClickShowTopBinh);
			myContent.standingBg.topMenu.topPhomBtn.addEventListener(MouseEvent.MOUSE_UP, onClickShowTopPhom);
			
			
			
		}
		
		private function onClickShowTopTlmn(e:MouseEvent):void 
		{
			allHeaderVisible();
			showHeaderChose(0, 1);
			myContent.standingBg.topMenu.topTlmnBtn.gotoAndStop(1);
			myContent.standingBg.topMenu.topBinhBtn.gotoAndStop(2);
			myContent.standingBg.topMenu.topPhomBtn.gotoAndStop(2);
			loadTop(1, 0);
		}
		
		private function onClickShowTopBinh(e:MouseEvent):void 
		{
			allHeaderVisible();
			showHeaderChose(0, 1);
			myContent.standingBg.topMenu.topTlmnBtn.gotoAndStop(2);
			myContent.standingBg.topMenu.topBinhBtn.gotoAndStop(1);
			myContent.standingBg.topMenu.topPhomBtn.gotoAndStop(2);
			loadTop(1, 1);
		}
		
		private function onClickShowTopPhom(e:MouseEvent):void 
		{
			allHeaderVisible();
			showHeaderChose(0, 1);
			myContent.standingBg.topMenu.topTlmnBtn.gotoAndStop(2);
			myContent.standingBg.topMenu.topBinhBtn.gotoAndStop(2);
			myContent.standingBg.topMenu.topPhomBtn.gotoAndStop(1);
			loadTop(1, 2);
		}
		
		public function loadTop(type:int, typeGame:int = 0):void 
		{
			headerOn(0);
			boardOn(0);
			//http://wss.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_GetTopUserMoney?row_start=0&row_end=10
			var method:String = "POST";
			var url:String;
			var httpRequest:HTTPRequest = new HTTPRequest();
			var obj:Object;
			
			windowLayer.openLoadingWindow();
			
			switch (type) 
			{
				case 0:
					
					url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_GetTopUserMoney?row_start=0&row_end=10";
					obj = new Object();
					obj.avt_group_id = String(0);
					httpRequest.sendRequest(method, url, obj, loadRichTopSuccess, true);
				break;
				case 1:
					if (typeGame == 0) 
					{
						url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_GetTopUserWin?"
								+ "game_id=AZGB_TLMN&row_start=0&row_end=10";
					}
					else if (typeGame == 1) 
					{
						url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_GetTopUserWin?"
								+ "game_id=AZGB_BINH&row_start=0&row_end=10";
					}
					else if (typeGame == 2) 
					{
						url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_GetTopUserWin?"
								+ "game_id=AZGB_PHOM&row_start=0&row_end=10";
					}
					
					obj = new Object();
					obj.it_group_id = String(1);
					obj.it_type = String(1);
					httpRequest.sendRequest(method, url, obj, loadTopSuccess, true);
				break;
				case 2:
					
					url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_GetTopUserLevel?row_start=0&row_end=10";
					obj = new Object();
					obj.avt_group_id = String(0);
					httpRequest.sendRequest(method, url, obj, loadRoyalTopSuccess, true);
				break;
				default:
			}
		}
		
		private function loadRoyalTopSuccess(obj:Object):void 
		{
			windowLayer.closeAllWindow();
			if (scrollViewForRank) 
			{
				scrollViewForRank.removeAll();
				
			}
			var arr:Array = obj.Data;
			trace("danh sahc top: ", arr.length)
			for (var i:int = 0; i < arr.length; i++) 
			{
				var contentTop:MovieClip = new ContentUserTopList();
				
				var gold:int = arr[i].money;
				var nickname:String = arr[i].nick_name;
				var level:int = arr[i].level;
				var winNumber:int = arr[i].win;
				var loseNumber:int = arr[i].lose;
				
				
				contentTop.sttTxt.text = String(i + 1);
				contentTop.userNameTxt.text = nickname;
				contentTop.moneyTxt.text = format(gold) + " G";
				contentTop.levelTxt.text = format(level);
				contentTop.winTxt.text = format(winNumber);
				contentTop.loseTxt.text = format(loseNumber);
				
				//myContent.standingBg.addChild(contentTop);
				
				contentTop.gotoAndStop((i % 2) + 1);
				scrollViewForRank.addRow(contentTop);
				
			}
		}
		
		private function loadRichTopSuccess(obj:Object):void 
		{
			windowLayer.closeAllWindow();
			if (scrollViewForRank) 
			{
				scrollViewForRank.removeAll();
				
			}
			var arr:Array = obj.Data;
			trace("danh sahc top: ", arr.length)
			for (var i:int = 0; i < arr.length; i++) 
			{
				var contentTop:MovieClip = new ContentUserTopList();
				
				var gold:int = arr[i].money;
				var nickname:String = arr[i].nick_name;
				var level:int = arr[i].level;
				var winNumber:int = arr[i].win;
				var loseNumber:int = arr[i].lose;
				
				
				contentTop.sttTxt.text = String(i + 1);
				contentTop.userNameTxt.text = nickname;
				contentTop.moneyTxt.text = format(gold) + " G";
				contentTop.levelTxt.text = format(level);
				contentTop.winTxt.text = format(winNumber);
				contentTop.loseTxt.text = format(loseNumber);
				
				//myContent.standingBg.addChild(contentTop);
				
				contentTop.gotoAndStop((i % 2) + 1);
				scrollViewForRank.addRow(contentTop);
				
			}
			
		}
		
		private function loadTopSuccess(obj:Object):void 
		{
			windowLayer.closeAllWindow();
			if (scrollViewForRank) 
			{
				scrollViewForRank.removeAll();
				
			}
			var arr:Array = obj.Data;
			trace("danh sahc top: ", arr.length)
			var mc:MovieClip = new MovieClip();
			mc.graphics.beginFill(0x123456, 0);
			mc.graphics.drawRect(0, 0, 100, 48);
			mc.graphics.endFill();
			scrollViewForRank.addRow(mc);
			for (var i:int = 0; i < arr.length; i++) 
			{
				var contentTop:MovieClip = new ContentUserTopList();
				
				var gold:int = arr[i].money;
				var nickname:String = arr[i].nick_name;
				var level:int = arr[i].level;
				var winNumber:int = arr[i].win;
				var loseNumber:int = arr[i].lose;
				
				
				contentTop.sttTxt.text = String(i + 1);
				contentTop.userNameTxt.text = nickname;
				contentTop.moneyTxt.text = format(gold) + " G";
				contentTop.levelTxt.text = format(level);
				contentTop.winTxt.text = format(winNumber);
				contentTop.loseTxt.text = format(loseNumber);
				
				//myContent.standingBg.addChild(contentTop);
				
				contentTop.gotoAndStop((i % 2) + 1);
				scrollViewForRank.addRow(contentTop);
				
			}
			
		}
		
		private function onClickShowRichTop(e:MouseEvent):void 
		{
			scrollViewForRank.y = 0;
			
			allHeaderVisible();
			showHeaderChose(0, 0);
			loadTop(0);
		}
		
		private function onClickShowTop(e:MouseEvent):void 
		{
			//scrollViewForRank.y = 50;
			scrollViewForRank.y = 0;
			
			allHeaderVisible();
			showHeaderChose(0, 1);
			loadTop(1, 0);
		}
		
		private function onClickShowRoyalTop(e:MouseEvent):void 
		{
			scrollViewForRank.y = 0;
			
			allHeaderVisible();
			showHeaderChose(0, 2);
			loadTop(2);
		}
		
		private function onClickChosePayMobi(e:MouseEvent):void 
		{
			_typOfNetwork = "VMS";
			myContent.rakingBg.choosePayVina.gotoAndStop(1);
			myContent.rakingBg.choosePayMobi.gotoAndStop(2);
			myContent.rakingBg.choosePayViettel.gotoAndStop(1);
			myContent.rakingBg.choosePayVtc.gotoAndStop(1);
			myContent.rakingBg.choosePayMega.gotoAndStop(1);
			myContent.rakingBg.choosePayFpt.gotoAndStop(1);
		}
		
		private function onClickChosePayVina(e:MouseEvent):void 
		{
			_typOfNetwork = "VNP";
			myContent.rakingBg.choosePayVina.gotoAndStop(2);
			myContent.rakingBg.choosePayMobi.gotoAndStop(1);
			myContent.rakingBg.choosePayViettel.gotoAndStop(1);
			myContent.rakingBg.choosePayVtc.gotoAndStop(1);
			myContent.rakingBg.choosePayMega.gotoAndStop(1);
			myContent.rakingBg.choosePayFpt.gotoAndStop(1);
		}
		
		private function onClickChosePayViettel(e:MouseEvent):void 
		{
			_typOfNetwork = "VTT";
			myContent.rakingBg.choosePayVina.gotoAndStop(1);
			myContent.rakingBg.choosePayMobi.gotoAndStop(1);
			myContent.rakingBg.choosePayViettel.gotoAndStop(2);
			myContent.rakingBg.choosePayVtc.gotoAndStop(1);
			myContent.rakingBg.choosePayMega.gotoAndStop(1);
			myContent.rakingBg.choosePayFpt.gotoAndStop(1);
		}
		
		private function onClickChosePayVtc(e:MouseEvent):void 
		{
			_typOfNetwork = "VTC";
			myContent.rakingBg.choosePayVina.gotoAndStop(1);
			myContent.rakingBg.choosePayMobi.gotoAndStop(1);
			myContent.rakingBg.choosePayViettel.gotoAndStop(1);
			myContent.rakingBg.choosePayVtc.gotoAndStop(2);
			myContent.rakingBg.choosePayMega.gotoAndStop(1);
			myContent.rakingBg.choosePayFpt.gotoAndStop(1);
		}
		
		private function onClickChosePayMega(e:MouseEvent):void 
		{
			_typOfNetwork = "MGC";
			myContent.rakingBg.choosePayVina.gotoAndStop(1);
			myContent.rakingBg.choosePayMobi.gotoAndStop(1);
			myContent.rakingBg.choosePayViettel.gotoAndStop(1);
			myContent.rakingBg.choosePayVtc.gotoAndStop(1);
			myContent.rakingBg.choosePayMega.gotoAndStop(2);
			myContent.rakingBg.choosePayFpt.gotoAndStop(1);
		}
		
		private function onClickChoseRakingPayFpt(e:MouseEvent):void 
		{
			_typOfNetwork = "FPT";
			myContent.rakingBg.choosePayVina.gotoAndStop(1);
			myContent.rakingBg.choosePayMobi.gotoAndStop(1);
			myContent.rakingBg.choosePayViettel.gotoAndStop(1);
			myContent.rakingBg.choosePayVtc.gotoAndStop(1);
			myContent.rakingBg.choosePayMega.gotoAndStop(1);
			myContent.rakingBg.choosePayFpt.gotoAndStop(2);
		}
		
		private function codeFocusOutHandler(e:FocusEvent):void 
		{
			var txt:TextField = e.currentTarget as TextField;
			if (txt.text == "") 
			{
				txt.text = "nhập mã thẻ";
			}
		}
		
		private function codeFocusHandler(e:FocusEvent):void 
		{
			var txt:TextField = e.currentTarget as TextField;
			if (txt.text == "nhập mã thẻ") 
			{
				txt.text = "";
			}
		}
		
		
		private function codeCheckFocusOutHandler(e:FocusEvent):void 
		{
			var txt:TextField = e.currentTarget as TextField;
			if (txt.text == "") 
			{
				txt.text = "Mã xác nhận";
			}
		}
		
		private function codeCheckFocusHandler(e:FocusEvent):void 
		{
			var txt:TextField = e.currentTarget as TextField;
			if (txt.text == "Mã xác nhận") 
			{
				txt.text = "";
			}
		}
		
		
		private function seriFocusOutHandler(e:FocusEvent):void 
		{
			var txt:TextField = e.currentTarget as TextField;
			if (txt.text == "") 
			{
				txt.text = "nhập seri thẻ";
			}
		}
		
		private function seriFocusHandler(e:FocusEvent):void 
		{
			var txt:TextField = e.currentTarget as TextField;
			if (txt.text == "nhập seri thẻ") 
			{
				txt.text = "";
			}
		}
		
		private function userNameFocusOutHandler(e:FocusEvent):void 
		{
			var txt:TextField = e.currentTarget as TextField;
			if (txt.text == "" || txt.text == " ") 
			{
				txt.text = MainData.getInstance().chooseChannelData.myInfo.name;
			}
		}
		
		private function userNameFocusHandler(e:FocusEvent):void 
		{
			var txt:TextField = e.currentTarget as TextField;
			if (txt.text == "nhập tên") 
			{
				txt.text = "";
			}
		}
		
		private function onClickChoseRaking(e:MouseEvent):void 
		{
			var aleart:AlertWindow;
			if ((myContent.rakingBg.userNameTxt.text != "" || myContent.rakingBg.userNameTxt.text != "nhập tên")
				&& (myContent.rakingBg.serinumberTxt.text != "" || myContent.rakingBg.serinumberTxt.text != "nhập seri thẻ")
				&& (myContent.rakingBg.codenumberTxt.text != "" || myContent.rakingBg.codenumberTxt.text != "nhập mã thẻ")
				&& (myContent.rakingBg.codecheckTxt.text != "" || myContent.rakingBg.codecheckTxt.text != "Mã xác nhận")
				&& myContent.rakingBg.codecheckTxt.text == myContent.rakingBg.codeCheck.text
				) 
			{
				
				windowLayer.openLoadingWindow();
				var method:String = "POST";
				var url:String;
				var httpRequest:HTTPRequest = new HTTPRequest();
				var obj:Object;
				
				url = basePath + "Service01/Billings/OnplayMobile.asmx/CardCharging";
				
				obj = new Object();
				obj.nick_name = MainData.getInstance().chooseChannelData.myInfo.name;
				obj.telco_code = _typOfNetwork;
				obj.card_serial = myContent.rakingBg.serinumberTxt.text;
				obj.card_id = myContent.rakingBg.codenumberTxt.text;
				httpRequest.sendRequest(method, url, obj, onAddMoneyRespone, true);
			}
			else 
			{
				if (myContent.rakingBg.userNameTxt.text == "" || myContent.rakingBg.userNameTxt.text == " ") 
				{
					aleart = new AlertWindow();
					windowLayer.openAlertWindow("Chưa nhập tên");
				}
				else if (myContent.rakingBg.serinumberTxt.text == "" || myContent.rakingBg.serinumberTxt.text == " ") 
				{
					aleart = new AlertWindow();
					windowLayer.openAlertWindow("Chưa nhập số seri");
				}
				else if (myContent.rakingBg.codenumberTxt.text == "" || myContent.rakingBg.codenumberTxt.text == " ") 
				{
					aleart = new AlertWindow();
					windowLayer.openAlertWindow("Chưa nhập mã thẻ");
				}
				else if (myContent.rakingBg.codecheckTxt.text == "" || myContent.rakingBg.codecheckTxt.text == " ") 
				{
					aleart = new AlertWindow();
					windowLayer.openAlertWindow("Chưa nhập mã xác nhận");
				}
				else if (myContent.rakingBg.codecheckTxt.text != myContent.rakingBg.codeCheck.text) 
				{
					aleart = new AlertWindow();
					windowLayer.openAlertWindow("Mã xác nhận không đúng");
				}
			}
			
			createCodeCheck();
		}
		
		private function onAddMoneyRespone(obj:Object):void 
		{
			var addMoney:ShopNoticeWindow = new ShopNoticeWindow();
			var buyAvatarWindow:ConfirmWindow;
			
			windowLayer.closeAllWindow();
			if (obj.description == "link bị sai rùi") 
			{
				buyAvatarWindow = new ConfirmWindow();
				buyAvatarWindow.setNotice("Giao dịch không thành công, xin vui lòng thử lại");
				buyAvatarWindow.buttonStatus(false, true, false);
				windowLayer.openWindow(buyAvatarWindow);
			}
			else if (obj["Msg"] == "Access Token Expired") 
			{
				buyAvatarWindow = new ConfirmWindow();
				buyAvatarWindow.setNotice("Giao dịch không thành công, xin vui lòng thử lại");
				buyAvatarWindow.buttonStatus(false, true, false);
				windowLayer.openWindow(buyAvatarWindow);
			}
			else if (obj.TypeMsg == 1) 
			{
				addMoney.addWindow("AddMoneySuccessWindow", "Bạn đã nạp " + int(obj.Data.Amount / 1000) + "k thành công");
				windowLayer.openWindow(addMoney);
				updateUserInfo();
				addMoney.addEventListener(ShopNoticeWindow.CHANGE_MONEY, onShowShopGold);
			}
			else 
			{
				buyAvatarWindow = new ConfirmWindow();
				buyAvatarWindow.setNotice(obj.Msg);
				buyAvatarWindow.buttonStatus(false, true, false);
				windowLayer.openWindow(buyAvatarWindow);
			}
			
			
		}
		
		private function onShowShopGold(e:Event):void 
		{
			e.currentTarget.removeEventListener(ShopNoticeWindow.CHANGE_MONEY, onShowShopGold);
			
			onClickShowGold(null);
			dispatchEvent(new Event(CHANGE_TAB));
		}
		
		private function updateUserInfo():void 
		{
			var method:String = "POST";
			var url:String;
			var httpRequest:HTTPRequest = new HTTPRequest();
			var obj:Object;
			
			url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_GetUserInfo";
			
			obj = new Object();
			obj.nick_name = MainData.getInstance().chooseChannelData.myInfo.name;
			
			httpRequest.sendRequest(method, url, obj, onUpdateUserInfo, true);
		}
		
		private function onUpdateUserInfo(obj:Object):void 
		{
			trace(obj)
			MainData.getInstance().chooseChannelData.myInfo.avatar = obj.Data["Avatar"];
			MainData.getInstance().chooseChannelData.myInfo.money = obj.Data["Money"];
			MainData.getInstance().chooseChannelData.myInfo.cash = obj.Data["Cash"];
			MainData.getInstance().chooseChannelData.myInfo.level = obj.Data["Level"];
			
			MainData.getInstance().chooseChannelData.myInfo = MainData.getInstance().chooseChannelData.myInfo;
			MyDataTLMN.getInstance().myMoney[0] = obj.Data["Money"];
			MyDataTLMN.getInstance().myMoney[1] = obj.Data["Cash"];
			MyDataTLMN.getInstance().myAvatar = obj.Data["Avatar"];
			
		}
		
		private function onClickChoseSms1(e:MouseEvent):void 
		{
			/*tutorialAddMoney = new TutorialAddMoneyPopup();
				myContent.addChild(tutorialAddMoney);
				tutorialAddMoney.x = 47 + (865 - tutorialAddMoney.width) / 2;
				tutorialAddMoney.y = 136 + (363 - tutorialAddMoney.height) / 2;
				
				tutorialAddMoney.contentMess.text = "SB G " + MainData.getInstance().chooseChannelData.myInfo.name;
				tutorialAddMoney.numberTxt.text = MainData.getInstance().phone3;
				
				tutorialAddMoney.closeBtn.addEventListener(MouseEvent.MOUSE_UP, onCloseTutorial);*/
			if (MainData.getInstance().isFacebookVersion) 
			{
				tutorialAddMoney = new TutorialAddMoneyPopup();
				myContent.addChild(tutorialAddMoney);
				tutorialAddMoney.x = 47 + (865 - tutorialAddMoney.width) / 2;
				tutorialAddMoney.y = 136 + (363 - tutorialAddMoney.height) / 2;
				
				tutorialAddMoney.contentMess.text = "SB G " + MainData.getInstance().chooseChannelData.myInfo.name;
				tutorialAddMoney.numberTxt.text = MainData.getInstance().phone3;
				
				tutorialAddMoney.closeBtn.addEventListener(MouseEvent.MOUSE_UP, onCloseTutorial);
			}
			else 
			{
				turnOnSendSMS("SB G " + MainData.getInstance().chooseChannelData.myInfo.name, MainData.getInstance().phone3);
			}
			
		}
		
		private function turnOnSendSMS(msg:String, phone:String):void
		{
			if (MainData.getInstance().isOnAndroid)
			{
				AndroidExtensions.sendSMS(msg, phone);
			}
			else if (MainData.getInstance().isOnIos)
			{
				var msgExtension:MSGExtension = new MSGExtension();
				msgExtension.sendSMS(phone, msg);
			}
		}
		
		private function onCloseTutorial(e:MouseEvent):void 
		{
			
			tutorialAddMoney.closeBtn.removeEventListener(MouseEvent.MOUSE_UP, onCloseTutorial);
			myContent.removeChild(tutorialAddMoney);
			tutorialAddMoney = null;
			
		}
		private function onClickChoseSms2(e:MouseEvent):void 
		{
			if (!MainData.getInstance().isFacebookVersion) 
			{
				turnOnSendSMS("SB G " + MainData.getInstance().chooseChannelData.myInfo.name, MainData.getInstance().phone4);
			}
			else 
			{
				tutorialAddMoney = new TutorialAddMoneyPopup();
				myContent.addChild(tutorialAddMoney);
				tutorialAddMoney.x = 47 + (865 - tutorialAddMoney.width) / 2;
				tutorialAddMoney.y = 136 + (363 - tutorialAddMoney.height) / 2;
				
				tutorialAddMoney.contentMess.text = "SB G " + MainData.getInstance().chooseChannelData.myInfo.name;
				tutorialAddMoney.numberTxt.text = MainData.getInstance().phone4;
				
				tutorialAddMoney.closeBtn.addEventListener(MouseEvent.MOUSE_UP, onCloseTutorial);
				
			}
			
		}
		private function onClickChoseSms3(e:MouseEvent):void 
		{
			if (!MainData.getInstance().isFacebookVersion) 
			{
				turnOnSendSMS("SB G " + MainData.getInstance().chooseChannelData.myInfo.name, MainData.getInstance().phone5);
			}
			else 
			{
				tutorialAddMoney = new TutorialAddMoneyPopup();
				myContent.addChild(tutorialAddMoney);
				tutorialAddMoney.x = 47 + (865 - tutorialAddMoney.width) / 2;
				tutorialAddMoney.y = 136 + (363 - tutorialAddMoney.height) / 2;
				
				tutorialAddMoney.contentMess.text = "SB G " + MainData.getInstance().chooseChannelData.myInfo.name;
				tutorialAddMoney.numberTxt.text = MainData.getInstance().phone5;
				
				tutorialAddMoney.closeBtn.addEventListener(MouseEvent.MOUSE_UP, onCloseTutorial);
				
			}
		}
		
		private function onClickShowAddMoneySms(e:MouseEvent):void 
		{
			allHeaderVisible();
			showHeaderChose(1, 1);
			headerOn(1);
			boardOn(1);
		}
		
		private function onClickShowAddMoneyCreadit(e:MouseEvent):void 
		{
			allHeaderVisible();
			showHeaderChose(1, 2);
			headerOn(1);
			boardOn(3);
		}
		
		private function onClickShowAddMoneyRaking(e:MouseEvent):void 
		{
			allHeaderVisible();
			showHeaderChose(1, 0);
			
			headerOn(1);
			boardOn(2);
			createCodeCheck();
		}
		
		/**
		 * type(0: avatar, 1:gold, 2:item, 3: tour, 4: doi thuong)
		 */
		public function loadMyItem(type:int):void 
		{
			var method:String = "POST";
			var url:String;
			var httpRequest:HTTPRequest = new HTTPRequest();
			var obj:Object;
			
			headerOn(3);
			
			windowLayer.openLoadingWindow();
			
			switch (type) 
			{
				case 0:
					url = basePath + "Service02/OnplayUserExt.asmx/GetListAvatarOfBuyer?nick_name=" + 
						MainData.getInstance().chooseChannelData.myInfo.name + "&rowStart=0&rowEnd=50";
						
					obj = new Object();
					trace("xem avâtr cua minh: ", url);
					httpRequest.sendRequest(method, url, obj, loadMyAvatarSuccess, true);
				break;
				case 1:
					url = basePath + "Service02/OnplayUserExt.asmx/GetListTwit00" + String(1) + 
									"?rowStart=0&rowEnd=10";
					obj = new Object();
					obj.it_group_id = String(1);
					obj.it_type = String(2);
					httpRequest.sendRequest(method, url, obj, loadMyItemGoldSuccess, true);
				break;
				case 2:
					/*url = basePath + "Service02/OnplayUserExt.asmx/GetListTwit00" + String(1) + 
									"?rowStart=0&rowEnd=10";
					obj = new Object();
					obj.it_group_id = String(2);//loai 1: gold, 2 ve giai dau
					obj.it_type = String(3);
					httpRequest.sendRequest(method, url, obj, loadMyItemTourSuccess, true);*/
				break;
				case 3: // tour
					url = basePath + "/Service02/OnplayGamePartnerExt.asmx/Azgamebai_GetTransactionInfo";
					obj = new Object();
					obj.it_group_id = String(2);//loai 1: gold, 2 ve giai dau
					obj.type_item_id = String(6);
					obj.access_token = MainData.getInstance().loginData["AccessToken"];
					httpRequest.sendRequest(method, url, obj, loadMyItemTourSuccess, true);
				break;
				case 4: // doi thuong
					url = basePath + "Service02/OnplayUserExt.asmx/GetListTwit00" + String(1) + 
									"?rowStart=0&rowEnd=10";
					obj = new Object();
					obj.it_group_id = String(2);//loai 1: gold, 2 ve giai dau
					obj.it_type = String(3);
					httpRequest.sendRequest(method, url, obj, loadMyItemGiftSuccess, true);
				break;
				default:
			}
		}
		
		private function loadMyItemGiftSuccess(obj:Object):void 
		{
			windowLayer.closeAllWindow();
		}
		
		private function loadMyItemTourSuccess(obj:Object):void 
		{
			if (obj["Msg"] == "Cập nhật thành công") 
			{
				var i:int;
				var arrData:Array = obj.Data;
				var countX:int;
				var countY:int;
				windowLayer.closeAllWindow();
				for (i = 0; i < _arrTour.length; i++ ) 
				{
					_arrTour[i].removeEventListener(ConstTlmn.BUY_ITEM, onBuyItemTour);
					
				}
				for (i = 0; i < _arrGift.length; i++ ) 
				{
					_arrGift[i].removeEventListener(ConstTlmn.BUY_ITEM, onChangeGift);
					
				}
				for (i = 0; i < _arrItem.length; i++ ) 
				{
					_arrItem[i].removeEventListener(ConstTlmn.BUY_ITEM, onBuyItemNormal);
					
				}
				for (i = 0; i < _arrGold.length; i++ ) 
				{
					_arrGold[i].removeEventListener(ConstTlmn.BUY_ITEM, onBuyItemGold);
					
				}
				for (i = 0; i < _arrAvatar.length; i++ ) 
				{
					_arrAvatar[i].removeEventListener(ConstTlmn.BUY_AVATAR, onBuyAvatar);
					
				}
				for (i = 0; i < _arrMyAvatar.length; i++ ) 
				{
					_arrMyAvatar[i].removeEventListener(ConstTlmn.USE_AVATAR, onUseAvatar);
					
				}
				scrollView.removeAll();
				_arrMyItem = [];
				
				if (arrData.length < 1) 
				{
					var buyAvatarWindow:ConfirmWindow;
					buyAvatarWindow = new ConfirmWindow();
					buyAvatarWindow.setNotice("Bạn chưa có đồ nào trong hòm đồ");
					buyAvatarWindow.buttonStatus(false, true, false);
					windowLayer.openWindow(buyAvatarWindow);
				}
				
				for (i = 0; i < arrData.length; i++ ) 
				{
					var nameAvatar:String = arrData[i]['avt_name'];
					
					var linkAvatar:String = arrData[i]['avt_dir_path'];
					var expireAvatar:String = arrData[i]['avt_sell_expire_dt'];
					var sellRelease:String = arrData[i]['avt_sell_release_dt'];
					var idAvt:String = arrData[i]['avt_id'];
					var idAvtWeb:String = arrData[i]['avt_cd_wb'];
					var idListAvt:String = arrData[i]['avt_lst_id'];
					
					var contentAvatar:ContentMyAvatar = new ContentMyAvatar();
					_arrAvatar.push(contentAvatar);
					//contentAvatar.x = 10 + countX * 440;
					//contentAvatar.y = 5 + countY * 135;
					
					if (countX < 2) 
					{
						countX++;
					}
					else 
					{
						countY++;
						countX = 0;
					}
					
					
					contentAvatar.addInfo(idAvt, idListAvt, nameAvatar, sellRelease, linkAvatar, expireAvatar, idAvtWeb);
					scrollView.addRow(contentAvatar);
					//_arrBoard[3].addChild(contentAvatar);
					
					contentAvatar.addEventListener(ConstTlmn.USE_AVATAR, onUseAvatar);
				}
			}
		}
		
		private function loadMyItemGoldSuccess(obj:Object):void 
		{
			if (obj["Msg"] == "Cập nhật thành công") 
			{
				var i:int;
				var arrData:Array = obj.Data;
				var countX:int;
				var countY:int;
				windowLayer.closeAllWindow();
				for (i = 0; i < _arrTour.length; i++ ) 
				{
					_arrTour[i].removeEventListener(ConstTlmn.BUY_ITEM, onBuyItemTour);
					
				}
				for (i = 0; i < _arrGift.length; i++ ) 
				{
					_arrGift[i].removeEventListener(ConstTlmn.BUY_ITEM, onChangeGift);
					
				}
				for (i = 0; i < _arrItem.length; i++ ) 
				{
					_arrItem[i].removeEventListener(ConstTlmn.BUY_ITEM, onBuyItemNormal);
					
				}
				for (i = 0; i < _arrGold.length; i++ ) 
				{
					_arrGold[i].removeEventListener(ConstTlmn.BUY_ITEM, onBuyItemGold);
					
				}
				for (i = 0; i < _arrAvatar.length; i++ ) 
				{
					_arrAvatar[i].removeEventListener(ConstTlmn.BUY_AVATAR, onBuyAvatar);
					
				}
				for (i = 0; i < _arrMyAvatar.length; i++ ) 
				{
					_arrMyAvatar[i].removeEventListener(ConstTlmn.USE_AVATAR, onUseAvatar);
					
				}
				scrollView.removeAll();
				_arrMyGold = [];
				
				if (arrData.length < 1) 
				{
					var buyAvatarWindow:ConfirmWindow;
					buyAvatarWindow = new ConfirmWindow();
					buyAvatarWindow.setNotice("Bạn chưa có đồ nào trong hòm đồ");
					buyAvatarWindow.buttonStatus(false, true, false);
					windowLayer.openWindow(buyAvatarWindow);
				}
				
				for (i = 0; i < arrData.length; i++ ) 
				{
					var nameAvatar:String = arrData[i]['avt_name'];
					
					var linkAvatar:String = arrData[i]['avt_dir_path'];
					var expireAvatar:String = arrData[i]['avt_sell_expire_dt'];
					var sellRelease:String = arrData[i]['avt_sell_release_dt'];
					var idAvt:String = arrData[i]['avt_id'];
					var idAvtWeb:String = arrData[i]['avt_cd_wb'];
					var idListAvt:String = arrData[i]['avt_lst_id'];
					
					var contentAvatar:ContentMyItemGold = new ContentMyItemGold();
					_arrMyGold.push(contentAvatar);
					//contentAvatar.x = 10 + countX * 440;
					//contentAvatar.y = 5 + countY * 135;
					
					if (countX < 2) 
					{
						countX++;
					}
					else 
					{
						countY++;
						countX = 0;
					}
					
					
					contentAvatar.addInfo(idAvt, idListAvt, nameAvatar, sellRelease, linkAvatar, expireAvatar, idAvtWeb, true);
					scrollView.addRow(contentAvatar);
					//_arrBoard[3].addChild(contentAvatar);
					
					contentAvatar.addEventListener(ConstTlmn.USE_AVATAR, onUseMyItem);
				}
			}
		}
		
		private function onUseMyItem(e:Event):void 
		{
			
		}
		
		private function loadMyAvatarSuccess(obj:Object):void 
		{
			trace(obj)
			if (obj["Msg"] == "Cập nhật thành công") 
			{
				windowLayer.closeAllWindow();
				var i:int;
				var arrData:Array = obj.Data;
				var countX:int;
				var countY:int;

				for (i = 0; i < _arrTour.length; i++ ) 
				{
					_arrTour[i].removeEventListener(ConstTlmn.BUY_ITEM, onBuyItemTour);
					
				}
				for (i = 0; i < _arrGift.length; i++ ) 
				{
					_arrGift[i].removeEventListener(ConstTlmn.BUY_ITEM, onChangeGift);
					
				}
				for (i = 0; i < _arrItem.length; i++ ) 
				{
					_arrItem[i].removeEventListener(ConstTlmn.BUY_ITEM, onBuyItemNormal);
					
				}
				for (i = 0; i < _arrGold.length; i++ ) 
				{
					_arrGold[i].removeEventListener(ConstTlmn.BUY_ITEM, onBuyItemGold);
					
				}
				for (i = 0; i < _arrAvatar.length; i++ ) 
				{
					_arrAvatar[i].removeEventListener(ConstTlmn.BUY_AVATAR, onBuyAvatar);
					
				}
				for (i = 0; i < _arrMyAvatar.length; i++ ) 
				{
					_arrMyAvatar[i].removeEventListener(ConstTlmn.USE_AVATAR, onUseAvatar);
					
				}
				scrollView.removeAll();
				_arrMyAvatar = [];
				
				if (arrData.length < 1) 
				{
					var buyAvatarWindow:ConfirmWindow;
					buyAvatarWindow = new ConfirmWindow();
					buyAvatarWindow.setNotice("Bạn chưa có đồ nào trong hòm đồ");
					buyAvatarWindow.buttonStatus(false, true, false);
					windowLayer.openWindow(buyAvatarWindow);
				}
				
				for (i = 0; i < arrData.length; i++ ) 
				{
					var nameAvatar:String = arrData[i]['avt_name'];
					
					var linkAvatar:String = arrData[i]['avt_dir_path'];
					var expireAvatar:String = arrData[i]['avt_sell_expire_dt'];
					var sellRelease:String = arrData[i]['avt_sell_release_dt'];
					var idAvt:String = arrData[i]['avt_id'];
					var idAvtWeb:String = arrData[i]['avt_cd_wb'];
					var idListAvt:String = arrData[i]['avt_lst_id'];
					
					var contentAvatar:ContentMyAvatar = new ContentMyAvatar();
					_arrAvatar.push(contentAvatar);
					//contentAvatar.x = 10 + countX * 440;
					//contentAvatar.y = 5 + countY * 135;
					
					if (countX < 2) 
					{
						countX++;
					}
					else 
					{
						countY++;
						countX = 0;
					}
					
					
					contentAvatar.addInfo(idAvt, idListAvt, nameAvatar, sellRelease, linkAvatar, expireAvatar, idAvtWeb);
					scrollView.addRow(contentAvatar);
					//_arrBoard[3].addChild(contentAvatar);
					
					contentAvatar.addEventListener(ConstTlmn.USE_AVATAR, onUseAvatar);
				}
			}
		}
		
		private function onUseAvatar(e:Event):void 
		{
			var avatar:ContentMyAvatar = e.currentTarget as ContentMyAvatar;
			var myInfo:MyInfo = new MyInfo();
			var url:String = basePath + "Service02/OnplayShopExt.asmx/DressAvatarFromClientSide";
			var obj:Object = new Object();
			var mainData:MainData = MainData.getInstance();
			obj["access_token"] = mainData.loginData["AccessToken"];
			obj["item_id"] = avatar._idAvt;
			obj["avt_lst_id"] = avatar._idListAvt;
			obj["client_hash"] = MD5.hash(obj["access_token"] + mainData.client_secret + obj["avt_lst_id"]);
			
			trace("link mua item: ", obj["access_token"])
			var httpReq:HTTPRequest = new HTTPRequest();
			httpReq.sendRequest("POST", url, obj, useItemRespone, true);
		}
		
		private function useItemRespone(obj:Object):void 
		{
			var buyAvatarWindow:ConfirmWindow;
			if (obj["Msg"] == "Access Token Expired") 
			{
				buyAvatarWindow = new ConfirmWindow();
				buyAvatarWindow.setNotice("Giao dịch không thành công, xin vui lòng thử lại");
				buyAvatarWindow.buttonStatus(false, true, false);
				windowLayer.openWindow(buyAvatarWindow);
			}
			else if (obj["Msg"] == "Cập nhật thành công") 
			{
				buyAvatarWindow = new ConfirmWindow();
				buyAvatarWindow.setNotice("Mặc avatar thành công!");
				buyAvatarWindow.buttonStatus(false, true, false);
				windowLayer.openWindow(buyAvatarWindow);
				
				updateUserInfo();
			}
		}
		
		public function onClickShowMyAvatar(e:MouseEvent):void 
		{
			getNewAccessToken();
			scrollView.visible = true;
			scrollViewForRank.visible = false;
			allHeaderVisible();
			showHeaderChose(3, 0);
			loadMyItem(0);
		}
		
		public function onClickShowMyGold(e:MouseEvent):void 
		{
			allHeaderVisible();
			showHeaderChose(3, 1);
			loadMyItem(1);
		}
		
		public function onClickShowMyItem(e:MouseEvent):void 
		{
			allHeaderVisible();
			showHeaderChose(3, 2);
			loadMyItem(2);
		}
		
		public function onClickShowMyTour(e:MouseEvent):void 
		{
			windowLayer.openAlertWindow("Giải đấu chưa bắt đầu!");
			return;
			
			allHeaderVisible();
			showHeaderChose(3, 3);
			
			loadMyItem(3);
		}
		
		public function onClickShowMyGift(e:MouseEvent):void 
		{
			windowLayer.openAlertWindow("Giải đấu chưa bắt đầu!");
			return;
			tabOn(3);
			allHeaderVisible();
			showHeaderChose(3, 4);
			loadMyItem(4);
		}
		
		public function onClickShowGift(e:MouseEvent):void 
		{
			
			windowLayer.openAlertWindow("Giải đấu chưa bắt đầu!");
			return;
			allHeaderVisible();
			showHeaderChose(2, 4);
			tabOn(3);
			loadItem(4);
		}
		
		public function onClickShowTour(e:MouseEvent):void 
		{
			
			windowLayer.openAlertWindow("Giải đấu chưa bắt đầu!");
			return;
			tabOn(3);
			allHeaderVisible();
			showHeaderChose(2, 3);
			loadItem(3);
		}
		
		public function onClickShowItem(e:MouseEvent):void 
		{
			allHeaderVisible();
			showHeaderChose(2, 2);
			loadItem(2);
		}
		
		public function onClickShowGold(e:MouseEvent):void 
		{
			getNewAccessToken();
			scrollView.visible = true;
			scrollViewForRank.visible = false;
			tabOn(3);
			allHeaderVisible();
			showHeaderChose(2, 1);
			loadItem(1);
		}
		
		public function onClickShowAvatar(e:MouseEvent):void 
		{
			tabOn(3);
			getNewAccessToken();
			scrollView.visible = true;
			scrollViewForRank.visible = false;
			allHeaderVisible();
			showHeaderChose(2, 0);
			loadItem(0);
		}
		
		private function getNewAccessToken():void 
		{
			var date:Date = new Date();
			
			var myInfo:MyInfo = new MyInfo();
			var url:String = basePath + "Service02/OnplayUserExt.asmx/GetAccessTokenDirectly";
			var obj:Object = new Object();
			var mainData:MainData = MainData.getInstance();
			obj["client_id"] = mainData.client_id;
			obj["client_secret"] = mainData.client_secret;
			obj["client_timestamp"] = String(date.getTime());
			obj["nick_name"] = mainData.chooseChannelData.myInfo.name;
			obj["client_hash"] = MD5.hash(obj.client_id + obj.client_timestamp + 
												obj.client_secret + obj.nick_name);
			
			trace("get token: ", mainData.chooseChannelData.myInfo.token)
			var httpReq:HTTPRequest = new HTTPRequest();
			httpReq.sendRequest("POST", url, obj, getTokenRespone, true);
		}
		
		private function getTokenRespone(obj:Object):void 
		{
			if (obj.TypeMsg == '1')
			{
				var mainData:MainData = MainData.getInstance();
				mainData.chooseChannelData.myInfo.token = obj.Data.access_token;
				mainData.loginData["AccessToken"] = obj.Data.access_token;
				trace("new token: ", mainData.chooseChannelData.myInfo.token)
			}
		}
		
		private function showHeaderChose(header:int, type:int):void 
		{
			trace("da chon cai j`: ", header, type)
			if (header == 0 && type == 0) //bang xep hang: dai gia, cao thu, dang cap
			{
				myContent.chooseInStandingMc.richBtn.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 0;
				
			}
			else if (header == 0 && type == 1) 
			{
				myContent.chooseInStandingMc.topBtn.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 37;
			}
			else if (header == 0 && type == 2) 
			{
				myContent.chooseInStandingMc.royalBtn.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 0;
			}
			else if (header == 1 && type == 0) //nap tien: the cao, sms, thẻ tín dụng
			{
				myContent.chooseInAddMoneyMc.raking.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 0;
			}
			else if (header == 1 && type == 1) 
			{
				myContent.chooseInAddMoneyMc.sms.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 0;
			}
			else if (header == 1 && type == 2) 
			{
				myContent.chooseInAddMoneyMc.creditCard.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 0;
			}
			else if (header == 2 && type == 0) //shop: avatar, gold. item. tour, phan thuong
			{
				myContent.chooseInShopMc.chooseAvatar.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 0;
			}
			else if (header == 2 && type == 1) 
			{
				myContent.chooseInShopMc.chooseGold.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 0;
			}
			else if (header == 2 && type == 2) 
			{
				myContent.chooseInShopMc.chooseItem.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 0;
			}
			else if (header == 2 && type == 3) 
			{
				myContent.chooseInShopMc.chooseTour.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 0;
			}
			else if (header == 2 && type == 4) 
			{
				myContent.chooseInShopMc.chooseGift.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 0;
			}
			else if (header == 3 && type == 0) //trong hom do: avatar, gold, item, ve giai dau, giai thuong
			{
				myContent.chooseInCofferMc.chooseAvatar.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 0;
			}
			else if (header == 3 && type == 1) 
			{
				myContent.chooseInCofferMc.chooseGold.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 0;
			}
			else if (header == 3 && type == 2) 
			{
				myContent.chooseInCofferMc.chooseItem.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 0;
			}
			else if (header == 3 && type == 3) 
			{
				myContent.chooseInCofferMc.chooseTour.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 0;
			}
			else if (header == 3 && type == 4) 
			{
				myContent.chooseInCofferMc.chooseGift.gotoAndStop(1);
				myContent.standingBg.boardContent.y = 0;
			}
		}
		
		/**
		 * type(0: chon game, 1:xep hang, 2:nap the, 3:shop, 4:hom do)
		 */
		public function tabOn(type:int):void 
		{
			_type = type;
			/*var i:int;
			for (i = 0; i < _arrBtnInTab.length; i++) 
			{
				myContent.tabMc.setChildIndex(_arrBtnInTab[i], myContent.tabMc.numChildren - 1);
			}
			
			myContent.tabMc.setChildIndex(_arrBtnInTab[type], myContent.tabMc.numChildren - 1);*/
			
			
		}
		
		/**
		 * type(0:xep hang, 1:nap the, 2:shop, 3:hom do)
		 */
		public function headerOn(type:int):void 
		{
			var i:int;
			for (i = 0; i < _arrHeaderTab.length; i++) 
			{
				_arrHeaderTab[i].visible = false;
			}
			
			_arrHeaderTab[type].visible = true;
		}
		
		/**
		 * type(0: xep hang, 1: nap sms, 2: nap the, 3:chua item)
		 */
		public function boardOn(type:int):void 
		{
			var i:int;
			for (i = 0; i < _arrBoard.length; i++) 
			{
				_arrBoard[i].visible = false;
			}
			
			_arrBoard[type].visible = true;
			
		}
		
		/**
		 * type(0: avatar, 1:gold, 2:item, 3:tour, 4:gift)
		 */
		private function loadItem(type:int):void 
		{
			var i:int;
			
			for (i = 0; i < _arrTour.length; i++ ) 
			{
				_arrTour[i].removeEventListener(ConstTlmn.BUY_ITEM, onBuyItemTour);
				
			}
			for (i = 0; i < _arrGift.length; i++ ) 
			{
				_arrGift[i].removeEventListener(ConstTlmn.BUY_ITEM, onChangeGift);
				
			}
			for (i = 0; i < _arrItem.length; i++ ) 
			{
				_arrItem[i].removeEventListener(ConstTlmn.BUY_ITEM, onBuyItemNormal);
				
			}
			for (i = 0; i < _arrGold.length; i++ ) 
			{
				_arrGold[i].removeEventListener(ConstTlmn.BUY_ITEM, onBuyItemGold);
				
			}
			for (i = 0; i < _arrAvatar.length; i++ ) 
			{
				_arrAvatar[i].removeEventListener(ConstTlmn.BUY_AVATAR, onBuyAvatar);
				
			}
			for (i = 0; i < _arrMyAvatar.length; i++ ) 
			{
				_arrMyAvatar[i].removeEventListener(ConstTlmn.USE_AVATAR, onUseAvatar);
				
			}
			scrollView.removeAll();
			_arrAvatar = [];
			_arrMyAvatar = [];
			_arrGold = [];
			_arrGift = [];
			_arrItem = [];
			_arrTour = [];
			
			loadAvatarShop = 0;
			loadGoldShop = 0;
			loadItemShop = 0;
			
			loadAvatarCoffer = 0;
			loadGoldCoffer = 0;
			loadItemCoffer = 0;
			
			headerOn(2);
			windowLayer.openLoadingWindow();
			var method:String = "POST";
			var url:String;
			var httpRequest:HTTPRequest = new HTTPRequest();
			var obj:Object;
			
			switch (type) 
			{
				case 0:
					url = basePath + "Service02/OnplayUserExt.asmx/GetListTwav00" + String(1)
									+ "?rowStart=" + loadAvatarShop * 10 + 1 + "&rowEnd=" + (loadAvatarShop + 1) * 10;
					obj = new Object();
					obj.avt_group_id = String(0);
					httpRequest.sendRequest(method, url, obj, loadAvatarSuccess, true);
				break;
				case 1:
					url = basePath + "Service02/OnplayUserExt.asmx/GetListTwit00" + String(1) + 
									"?rowStart=0&rowEnd=10";
					obj = new Object();
					obj.it_group_id = String(1);
					obj.it_type = String(1);
					httpRequest.sendRequest(method, url, obj, loadItemGoldSuccess, true);
				break;
				case 2:
					url = basePath + "Service02/OnplayUserExt.asmx/GetListTwit00" + String(1) + 
									"?rowStart=0&rowEnd=10";
					obj = new Object();
					obj.it_group_id = String(1);
					obj.it_type = String(2);
					httpRequest.sendRequest(method, url, obj, loadItemNormalSuccess, true);
				break;
				case 3:
					trace("load ve giai dau")
					url = basePath + "Service02/OnplayUserExt.asmx/GetListTwit00" + String(1) + 
									"?rowStart=0&rowEnd=10";
					obj = new Object();
					obj.it_group_id = String(2);//loai 1: gold, 2 ve giai dau
					obj.it_type = String(3);
					httpRequest.sendRequest(method, url, obj, loadItemTourSuccess, true);
				break;
				case 4:
					trace("load item doi thuong")
					url = basePath + "Service02/OnplayUserExt.asmx/GetListTwit00" + String(1) + 
									"?rowStart=0&rowEnd=50";
					obj = new Object();
					obj.it_group_id = String(3);//loai 1: gold, 2 ve giai dau, 3 item doi thuong
					obj.it_type = String(4);
					httpRequest.sendRequest(method, url, obj, loadItemGiftSuccess, true);
				break;
				default:
			}
			
			
		}
		
		private function loadItemGiftSuccess(obj:Object):void 
		{
			trace("load dc qua doi thuong: ", obj.Data)
			windowLayer.closeAllWindow();
			var arrData:Array = obj.Data;
			var countX:int;
			var countY:int;
			var i:int;
			
			
			
			if (obj["Msg"] == "Access Token Expired") 
			{
				
				return;
			}
			
			for (i = 0; i < arrData.length; i++ ) 
			{
				var nameAvatar:String = arrData[i]['it_name'];
				var chipAvatar:String = "0";
				var payGold:String = arrData[i]['it_buy_gold'];//arrData[i]['it_pay_gold'];
				var linkAvatar:String = arrData[i]['it_dir_path'];
				var expireAvatar:String = arrData[i]['it_sell_expire_dt'];
				var idAvtWeb:String = arrData[i]['it_cd_wb'];
				var idAvt:String = arrData[i]['it_id'];
				
				var soldOut:Boolean = true;
				if (arrData[i]['it_buy_lmt_cnt'] == 0) 
				{
					soldOut = false;
				}
				
				var contentAvatar:ContentItemGift = new ContentItemGift();
				_arrGift.push(contentAvatar);
				//contentAvatar.x = 10 + countX * 440;
				//contentAvatar.y = 5 + countY * 135;
				
				if (countX < 2) 
				{
					countX++;
				}
				else 
				{
					countY++;
					countX = 0;
				}
				
				contentAvatar.addInfo(idAvt, nameAvatar, chipAvatar, payGold, linkAvatar, expireAvatar, idAvtWeb, soldOut);
				scrollView.addRow(contentAvatar);
				//_arrBoard[3].addChild(contentAvatar);
				
				contentAvatar.addEventListener(ConstTlmn.BUY_ITEM, onChangeGift);
			}
		}
		
		private function onChangeGift(e:Event):void 
		{
			var i:int;
			changeGift = new AgreeChangeGiftPopup();
			myContent.addChild(changeGift);
			changeGift.x = 47 + (865 - changeGift.width) / 2;
			changeGift.y = 136 + (363 - changeGift.height) / 2;
			changeGift.cancelBtn.addEventListener(MouseEvent.MOUSE_UP, onCloseChangeGift);
			changeGift.agreeBtn.addEventListener(MouseEvent.MOUSE_UP, onAgreeChangeGift);
			
			
			
			goldChoseBuy = e.currentTarget as ContentItemGift;
		}
		
		private function onAgreeChangeGift(e:MouseEvent):void 
		{
			
			changeGift.cancelBtn.removeEventListener(MouseEvent.MOUSE_UP, onCloseChangeGift);
			changeGift.agreeBtn.removeEventListener(MouseEvent.MOUSE_UP, onAgreeChangeGift);
			
			myContent.removeChild(changeGift);
			
			var check:Boolean = true;
			if (Number(goldChoseBuy._goldAvt) > MainData.getInstance().chooseChannelData.myInfo.money ) 
			{
				var buyAvatarWindow:ConfirmWindow = new ConfirmWindow();
				buyAvatarWindow.setNotice("Tài khoản không có đủ GOLD");
				buyAvatarWindow.buttonStatus(false, true, false);
				windowLayer.openWindow(buyAvatarWindow);
				check = false;
			}
			
			if (check) 
			{
				var myInfo:MyInfo = new MyInfo();
				var url:String = basePath + "Service02/OnplayShopExt.asmx/BuyItemFromClientSide";
				var obj:Object = new Object();
				var mainData:MainData = MainData.getInstance();
				obj["access_token"] = mainData.loginData["AccessToken"];
				obj["game_code"] = goldChoseBuy._goldAvt;
				obj["payment_type"] = "1";
				obj["nk_nm_receiver"] = mainData.loginData["Id"];
				obj["item_id"] = goldChoseBuy._idAvt;
				obj["item_quantity"] = "1";
				obj["client_hash"] = MD5.hash(obj["access_token"] + mainData.client_secret + obj["game_code"]
				 + obj["payment_type"] + obj["nk_nm_receiver"] + obj["item_id"] +
				 obj["item_quantity"]);
				
				trace("link mua item: ", obj["access_token"])
				var httpReq:HTTPRequest = new HTTPRequest();
				httpReq.sendRequest("POST", url, obj, buyItemRespone, true);
			}
		}
		
		private function onCloseChangeGift(e:MouseEvent):void 
		{
			
			changeGift.cancelBtn.removeEventListener(MouseEvent.MOUSE_UP, onCloseChangeGift);
			changeGift.agreeBtn.removeEventListener(MouseEvent.MOUSE_UP, onAgreeChangeGift);
			
			myContent.removeChild(changeGift);
			
			
		}
		
		private function loadItemTourSuccess(obj:Object):void 
		{
			trace("load dc ve giai dau: ", obj.Data)
			var arrData:Array = obj.Data;
			var countX:int;
			var countY:int;
			var i:int;
			windowLayer.closeAllWindow();
			
			
			for (i = 0; i < arrData.length; i++ ) 
			{
				var nameAvatar:String = arrData[i]['it_name'];
				var chipAvatar:String = arrData[i]['it_buy_chip'];
				var payGold:String = arrData[i]['it_pay_gold'];
				var linkAvatar:String = arrData[i]['it_dir_path'];
				var expireAvatar:String = arrData[i]['it_sell_expire_dt'];
				var idAvtWeb:String = arrData[i]['it_cd_wb'];
				var idAvt:String = arrData[i]['it_id'];
				
				var contentAvatar:ContentItemTour = new ContentItemTour();
				_arrTour.push(contentAvatar);
				//contentAvatar.x = 10 + countX * 440;
				//contentAvatar.y = 5 + countY * 135;
				
				if (countX < 2) 
				{
					countX++;
				}
				else 
				{
					countY++;
					countX = 0;
				}
				
				
				contentAvatar.addInfo(idAvt, nameAvatar, chipAvatar, payGold, linkAvatar, expireAvatar, idAvtWeb);
				scrollView.addRow(contentAvatar);
				//_arrBoard[3].addChild(contentAvatar);
				
				contentAvatar.addEventListener(ConstTlmn.BUY_ITEM, onBuyItemTour);
			}
		}
		
		private function onBuyItemTour(e:Event):void 
		{
			goldChoseBuy = e.currentTarget as ContentItemTour;
			buyTour = new BuyTourTicket();
			windowLayer.openWindow(buyTour);
			buyTour.questionBuy(goldChoseBuy._nameAvt);
			
			buyTour.addEventListener("agree", onClickBuyGold);
			
			
		}
		
		private function loadItemNormalSuccess(obj:Object):void 
		{
			var arrData:Array = obj.Data;
			var countX:int;
			var countY:int;
			var i:int;
			windowLayer.closeAllWindow();
			
			
			for (i = 0; i < arrData.length; i++ ) 
			{
				var nameAvatar:String = arrData[i]['it_name'];
				var chipAvatar:String = arrData[i]['it_buy_chip'];
				var payGold:String = arrData[i]['it_pay_gold'];
				var linkAvatar:String = arrData[i]['it_dir_path'];
				var expireAvatar:String = arrData[i]['it_sell_expire_dt'];
				var idAvtWeb:String = arrData[i]['it_cd_wb'];
				var idAvt:String = arrData[i]['it_id'];
				
				var contentAvatar:ContentItemNormal = new ContentItemNormal();
				_arrItem.push(contentAvatar);
				//contentAvatar.x = 10 + countX * 440;
				//contentAvatar.y = 5 + countY * 135;
				
				if (countX < 2) 
				{
					countX++;
				}
				else 
				{
					countY++;
					countX = 0;
				}
				
				
				contentAvatar.addInfo(idAvt, nameAvatar, chipAvatar, payGold, linkAvatar, expireAvatar, idAvtWeb);
				scrollView.addRow(contentAvatar);
				//_arrBoard[3].addChild(contentAvatar);
				
				contentAvatar.addEventListener(ConstTlmn.BUY_ITEM, onBuyItemNormal);
			}
		}
		
		private function onBuyItemNormal(e:Event):void 
		{
			choosePay = new ChoosePayMoneyType();
			windowLayer.openWindow(choosePay);
			choosePay.showChoose(0);
			
			choosePay.addEventListener("agree", onClickBuyItem);
			
			goldChoseBuy = e.currentTarget as ContentItemNormal;
		}
		
		private function onClickBuyItem(e:Event):void 
		{
			var myInfo:MyInfo = new MyInfo();
			var url:String = basePath + "Service02/OnplayShopExt.asmx/BuyItemFromClientSide";
			var obj:Object = new Object();
			var mainData:MainData = MainData.getInstance();
			obj["access_token"] = mainData.loginData["AccessToken"];
			obj["game_code"] = goldChoseBuy._goldAvt;
			obj["payment_type"] = "1";
			obj["nk_nm_receiver"] = mainData.loginData["Id"];
			obj["item_id"] = goldChoseBuy._idAvt;
			obj["item_quantity"] = "1";
			obj["client_hash"] = MD5.hash(obj["access_token"] + mainData.client_secret + obj["game_code"]
			 + obj["payment_type"] + obj["nk_nm_receiver"] + obj["item_id"] +
			 obj["item_quantity"]);
			
			trace("link mua item: ", obj["access_token"])
			var httpReq:HTTPRequest = new HTTPRequest();
			httpReq.sendRequest("POST", url, obj, buyItemRespone, true);
		}
		
		private function loadItemGoldSuccess(obj:Object):void 
		{
			trace("load thanh cong item gold: ", obj)
			
			var arrData:Array = obj.Data;
			var countX:int;
			var countY:int;
			var i:int;
			windowLayer.closeAllWindow();
			
			
			for (i = arrData.length - 1; i > -1; i-- ) 
			{
				var nameAvatar:String = arrData[i]['it_name'];
				var chipAvatar:String = arrData[i]['it_buy_chip'];
				var payGold:String = arrData[i]['it_pay_gold'];
				var linkAvatar:String = arrData[i]['it_dir_path'];
				var expireAvatar:String = arrData[i]['it_sell_expire_dt'];
				var idAvtWeb:String = arrData[i]['it_cd_wb'];
				var idAvt:String = arrData[i]['it_id'];
				
				var contentAvatar:ContentItemGold = new ContentItemGold();
				_arrGold.push(contentAvatar);
				//contentAvatar.x = 10 + countX * 440;
				//contentAvatar.y = 5 + countY * 135;
				
				if (countX < 2) 
				{
					countX++;
				}
				else 
				{
					countY++;
					countX = 0;
				}
				
				
				contentAvatar.addInfo(idAvt, nameAvatar, chipAvatar, payGold, linkAvatar, expireAvatar, idAvtWeb);
				scrollView.addRow(contentAvatar);
				//_arrBoard[3].addChild(contentAvatar);
				
				contentAvatar.addEventListener(ConstTlmn.BUY_ITEM, onBuyItemGold);
			}
		}
		
		private function onBuyItemGold(e:Event):void 
		{
			
			choosePay = new ChoosePayMoneyType();
			windowLayer.openWindow(choosePay);
			choosePay.showChoose(1);
			
			choosePay.addEventListener("agree", onClickBuyGold);
			
			goldChoseBuy = e.currentTarget as ContentItemGold;
			
		}
		
		private function onClickBuyGold(e:Event):void 
		{
			if (buyTour) 
			{
				buyTour.removeEventListener("agree", onClickBuyGold);
			}
			if (choosePay) 
			{
				choosePay.removeEventListener("agree", onClickBuyGold);
			}
			
			typeOfPay = choosePay.typeOfPay;
			
			var buyAvatarWindow:ConfirmWindow;
			var check:Boolean = true;
			
			if (typeOfPay == 1) 
			{
				if (Number(goldChoseBuy._chipAvt) > MainData.getInstance().chooseChannelData.myInfo.cash ) 
				{
					var notEnoughMoneyWindow:ShopNoticeWindow = new ShopNoticeWindow();
					notEnoughMoneyWindow.addWindow("BuyItemUnSuccessWindown", "Tài khoản không có đủ CHIP");
					windowLayer.openWindow(notEnoughMoneyWindow);
					notEnoughMoneyWindow.addEventListener(ShopNoticeWindow.ADD_MONEY, onShowShopAddMoney);
					
					check = false;
				}
			}
			
			if (check) 
			{
				var myInfo:MyInfo = new MyInfo();
				var url:String = basePath + "Service02/OnplayShopExt.asmx/BuyItemFromClientSide";
				var obj:Object = new Object();
				var mainData:MainData = MainData.getInstance();
				obj["access_token"] = mainData.loginData["AccessToken"];
				obj["game_code"] = goldChoseBuy._goldAvt;
				obj["payment_type"] = String(typeOfPay);
				obj["nk_nm_receiver"] = mainData.loginData["Id"];
				obj["item_id"] = goldChoseBuy._idAvt;
				obj["item_quantity"] = "1";
				obj["client_hash"] = MD5.hash(obj["access_token"] + mainData.client_secret + obj["game_code"]
				 + obj["payment_type"] + obj["nk_nm_receiver"] + obj["item_id"] +
				 obj["item_quantity"]);
				
				trace("link mua item: ", obj["access_token"])
				var httpReq:HTTPRequest = new HTTPRequest();
				httpReq.sendRequest("POST", url, obj, buyItemRespone, true);
			}
			
		}
		
		private function onShowShopAddMoney(e:Event):void 
		{
			e.currentTarget.removeEventListener(ShopNoticeWindow.ADD_MONEY, onShowShopAddMoney);
			
			chooseAddMoney();
		}
		
		private function buyItemRespone(obj:Object):void 
		{
			trace(obj)
			var buyAvatarWindow:ConfirmWindow;
			trace("mua item respone: ", obj["Msg"])
			
			if (obj["Msg"] == "Access Token Expired") 
			{
				if (goldChoseBuy is ContentItemTour) 
				{
					buyTour = new BuyTourTicket();
					buyTour.noticeChoseItem(goldChoseBuy._nameAvt, "Giao dịch không thành công, xin vui lòng thử lại");
					windowLayer.openWindow(buyTour);
				}
				else
				{
					buyAvatarWindow = new ConfirmWindow();
					buyAvatarWindow.setNotice("Giao dịch không thành công, xin vui lòng thử lại");
					buyAvatarWindow.buttonStatus(false, true, false);
					windowLayer.openWindow(buyAvatarWindow);
				}
				
			}
			else if (obj["Msg"] == "Cập nhật không thành công [SQLCODE:-12899]") 
			{
				if (goldChoseBuy is ContentItemTour) 
				{
					buyTour = new BuyTourTicket();
					buyTour.noticeChoseItem(goldChoseBuy._nameAvt, "Giao dịch không thành công, xin vui lòng thử lại");
					windowLayer.openWindow(buyTour);
				}
				else
				{
					buyAvatarWindow = new ConfirmWindow();
					buyAvatarWindow.setNotice("Giao dịch không thành công, xin vui lòng thử lại");
					buyAvatarWindow.buttonStatus(false, true, false);
					windowLayer.openWindow(buyAvatarWindow);
				}
				
			}
			else if (obj["Msg"] == "Cập nhật thành công") 
			{
				if (goldChoseBuy is ContentItemTour) 
				{
					buyTour = new BuyTourTicket();
					buyTour.noticeChoseItem(goldChoseBuy._nameAvt, "Giao dịch không thành công");
					windowLayer.openWindow(buyTour);
					
			
				}
				else
				{
					buyAvatarWindow = new ConfirmWindow();
					buyAvatarWindow.setNotice("Giao dịch thành công");
					buyAvatarWindow.buttonStatus(true, false, false);
					windowLayer.openWindow(buyAvatarWindow);
					if (typeOfPay == 1) 
					{
						MainData.getInstance().chooseChannelData.myInfo.cash = MainData.getInstance().chooseChannelData.myInfo.cash - Number(goldChoseBuy._chipAvt);
					}
					else 
					{
						MainData.getInstance().chooseChannelData.myInfo.money = MainData.getInstance().chooseChannelData.myInfo.money - Number(goldChoseBuy._goldAvt);
					}
					MainData.getInstance().chooseChannelData.myInfo = MainData.getInstance().chooseChannelData.myInfo;
					
					
				}
				updateUserInfo();
			}
			else if (obj["Msg"] == "Tài khoản không có đủ CHIP") 
			{
				if (goldChoseBuy is ContentItemTour) 
				{
					buyTour = new BuyTourTicket();
					buyTour.noticeChoseItem(goldChoseBuy._nameAvt, "Tài khoản không có đủ CHIP");
					windowLayer.openWindow(buyTour);
				}
				else 
				{
					buyAvatarWindow = new ConfirmWindow();
					buyAvatarWindow.setNotice("Tài khoản không có đủ CHIP");
					buyAvatarWindow.buttonStatus(false, true, false);
					windowLayer.openWindow(buyAvatarWindow);
				}
				
			}
		}
		
		private function loadAvatarSuccess(obj:Object):void 
		{
			var i:int;
			var arrData:Array = obj.Data;
			var countX:int;
			var countY:int;
			
			
			windowLayer.closeAllWindow();
			
			for (i = 0; i < arrData.length; i++ ) 
			{
				var nameAvatar:String = arrData[i]['avt_name'];
				var chipAvatar:String = arrData[i]['avt_buy_chip'];
				var goldAvatar:String = arrData[i]['avt_buy_gold'];
				var linkAvatar:String = arrData[i]['avt_dir_path'];
				var expireAvatar:String = arrData[i]['avt_sell_expire_dt'];
				var gender:String = arrData[i]['avt_gender_code'];
				var idAvt:String = arrData[i]['avt_id'];
				var idAvtWeb:String = arrData[i]['avt_cd_wb'];
				
				var contentAvatar:ContentAvatar = new ContentAvatar();
				_arrAvatar.push(contentAvatar);
				//contentAvatar.x = 10 + countX * 440;
				//contentAvatar.y = 5 + countY * 135;
				
				if (countX < 2) 
				{
					countX++;
				}
				else 
				{
					countY++;
					countX = 0;
				}
				
				
				contentAvatar.addInfo(idAvt, nameAvatar, chipAvatar, goldAvatar, linkAvatar, expireAvatar, idAvtWeb);
				scrollView.addRow(contentAvatar);
				//_arrBoard[3].addChild(contentAvatar);
				
				contentAvatar.addEventListener(ConstTlmn.BUY_AVATAR, onBuyAvatar);
			}
			
			var method:String = "POST";
			var url:String;
			var httpRequest:HTTPRequest = new HTTPRequest();
			var obj:Object;
			
			if (arrData.length == 10) 
			{
				loadAvatarShop++;
				url = basePath + "Service02/OnplayUserExt.asmx/GetListTwav00" + String(1)
									+ "?rowStart=" + String(loadAvatarShop * 10 + 1) + "&rowEnd=" 
									+ String((loadAvatarShop + 1) * 10);
				obj = new Object();
				obj.avt_group_id = String(0);
				httpRequest.sendRequest(method, url, obj, loadAvatarSuccess, true);
			}
		}
		
		private function onBuyAvatar(e:Event):void 
		{
			choosePay = new ChoosePayMoneyType();
			windowLayer.openWindow(choosePay);
			choosePay.showChoose(0);
			
			choosePay.addEventListener("agree", onClickBuyAvatar);
			
			
			
			avatarChoseBuy = e.currentTarget as ContentAvatar;
			
		}
		
		private function onClickBuyAvatar(e:Event):void 
		{
			trace(choosePay.typeOfPay);
			typeOfPay = choosePay.typeOfPay;
			
			var notEnoughMoneyWindow:ShopNoticeWindow;
			var check:Boolean = true;
			
			if (typeOfPay == 2) 
			{
				if (Number(avatarChoseBuy._goldAvt) > MainData.getInstance().chooseChannelData.myInfo.money ) 
				{
					notEnoughMoneyWindow = new ShopNoticeWindow();
					notEnoughMoneyWindow.addWindow("BuyItemUnSuccessWindown", "Tài khoản không có đủ GOLD");
					windowLayer.openWindow(notEnoughMoneyWindow);
					notEnoughMoneyWindow.addEventListener(ShopNoticeWindow.ADD_MONEY, onShowShopAddMoney);
					check = false;
				}
			}
			else if (typeOfPay == 1) 
			{
				if (Number(avatarChoseBuy._chipAvt) > MainData.getInstance().chooseChannelData.myInfo.cash ) 
				{
					notEnoughMoneyWindow = new ShopNoticeWindow();
					notEnoughMoneyWindow.addWindow("BuyItemUnSuccessWindown", "Tài khoản không có đủ CHIP");
					windowLayer.openWindow(notEnoughMoneyWindow);
					notEnoughMoneyWindow.addEventListener(ShopNoticeWindow.ADD_MONEY, onShowShopAddMoney);
					check = false;
				}
			}
			
			if (check) 
			{
				var mainData:MainData = MainData.getInstance();
				trace("client id khi mua avatar: ", mainData.client_id , "--", mainData.client_secret)
				var myInfo:MyInfo = new MyInfo();
				var url:String = basePath + "Service02/OnplayShopExt.asmx/BuyAvatarFromClientSide";
				var obj:Object = new Object();
				
				obj["access_token"] = mainData.loginData["AccessToken"];
				obj["game_code"] = avatarChoseBuy._goldAvt;
				obj["payment_type"] = String(typeOfPay);
				obj["nk_nm_receiver"] = mainData.loginData["Id"];
				obj["item_id"] = avatarChoseBuy._idAvt;
				obj["item_quantity"] = "1";
				obj["client_hash"] = MD5.hash(obj["access_token"] + mainData.client_secret + obj["game_code"]
				 + obj["payment_type"] + obj["nk_nm_receiver"] + obj["item_id"] +
				 obj["item_quantity"]);
				
				trace("link mua avatar: ", obj["access_token"])
				var httpReq:HTTPRequest = new HTTPRequest();
				httpReq.sendRequest("POST", url, obj, buyAvatarRespone, true);
			}
			
		}
		
		private function buyAvatarRespone(obj:Object):void 
		{
			trace(obj)
			var buyAvatarWindow:ConfirmWindow;
			trace("mua avatar respone: ", obj["Msg"])
			trace("mua avatar respone: ", obj["TypeMsg"])
			if (obj["Msg"] == "Access Token Expired") 
			{
				buyAvatarWindow = new ConfirmWindow();
				buyAvatarWindow.setNotice("Giao dịch không thành công, xin vui lòng thử lại");
				buyAvatarWindow.buttonStatus(false, true, false);
				windowLayer.openWindow(buyAvatarWindow);
			}
			else if (obj["Msg"] == "Cập nhật thành công") 
			{
				buyAvatarWindow = new ConfirmWindow();
				buyAvatarWindow.setNotice("Giao dịch thành công");
				buyAvatarWindow.buttonStatus(true, false, false);
				windowLayer.openWindow(buyAvatarWindow);
				if (typeOfPay == 1) 
				{
					MainData.getInstance().chooseChannelData.myInfo.cash = MainData.getInstance().chooseChannelData.myInfo.cash - Number(avatarChoseBuy._chipAvt);
				}
				else 
				{
					MainData.getInstance().chooseChannelData.myInfo.money = MainData.getInstance().chooseChannelData.myInfo.money - Number(avatarChoseBuy._goldAvt);
				}
				MainData.getInstance().chooseChannelData.myInfo = MainData.getInstance().chooseChannelData.myInfo;
				
				updateUserInfo();
			}
		}
		
		public function chooseAddMoney():void 
		{
			scrollView.visible = true;
			scrollViewForRank.visible = false;
			
			headerOn(1);
			boardOn(2);
			tabOn(2);
			
			createCodeCheck();
			
			allHeaderVisible();
			showHeaderChose(1, 0);
			
			dispatchEvent(new Event(CHANGE_TAB));
			
		}
		
		private function createCodeCheck():void 
		{
			var arr:Array = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", 
			"T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
			var str:String = "";
			for (var i:int = 0; i < 3; i++) 
			{
				var rd:int = int(Math.random() * arr.length);
				str = str + arr[rd];
			}
			
			myContent.rakingBg.codeCheck.text = str;
		}
		
		public function showRank():void 
		{
			scrollView.visible = false;
			scrollViewForRank.visible = true;
			headerOn(0);
			boardOn(0);
			tabOn(1);
			
			loadTop(0);
			allHeaderVisible();
			showHeaderChose(0, 0);
			
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