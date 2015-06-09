package view.window.news 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import model.applicationDomainData.ApplicationDomainData;
	import model.MainData;
	import model.MyDataTLMN;
	import request.HTTPRequest;
	import view.ScrollView.ScrollViewYun;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class NewsWindow extends MovieClip 
	{
		private var content:MovieClip;
		private var basePath:String = "";
		private var scrollViewForNews:ScrollViewYun;
		private var windowLayer:WindowLayer = WindowLayer.getInstance();
		private var mainData:MainData = MainData.getInstance();
		
		private var isLoad:Boolean = false;
		
		private var _arrGiftDay:Array = [];
		
		private var newsDetail:ShowNewsDetail;
		
		private var currentPage:int;
		private var totalPage:int;
		private var onFocusCurP:Boolean = false;
		private var countGiftCode:int;
		
		public function NewsWindow() 
		{
			super();
			
			if (mainData.isTest) 
			{
				basePath = "http://wss.test.azgame.us/";
			}
			else 
			{
				basePath = "http://wss.azgame.us/";
			}
			
			content = new ChoseEventShopMc();
			addChild(content);
			
			scrollViewForNews = new ScrollViewYun();
			scrollViewForNews.isForMobile = !mainData.isShowScroll;
			scrollViewForNews.setData(content.containerNew, 0);
			
			scrollViewForNews.columnNumber = 1;
			scrollViewForNews.isScrollVertical = true;
			content.addChild(scrollViewForNews);
			
			closeLoading();
			
			allVisible();
			
			content.pageView.visible = false;
			content.contentGiftCode.visible = false;
			_arrGiftDay = [new MoneyFreeDayMc(), new Play60Mc(), new PlayMoreGameMc(), new InviteFriendMc(), new ShareFbMc()];
			
			
			_arrGiftDay[0].containerImg.gotoAndStop(1);
			_arrGiftDay[1].containerImg.gotoAndStop(3);
			_arrGiftDay[2].containerImg.gotoAndStop(2);
			_arrGiftDay[3].containerImg.gotoAndStop(4);
			_arrGiftDay[4].containerImg.gotoAndStop(5);
			
			
			getInfoGiftDay(5);
			
			content.contentGiftCode.emailTxt.text = "Nhập email tặng quà";
			content.contentGiftCode.giftCodeTxt.text = "Nhập mã quà tặng";
			
			addEvent();
		}
		
		private function onClickReceiveInvite(e:MouseEvent):void 
		{
			chargeGold(3);
		}
		
		private function onClickReceiveShare(e:MouseEvent):void 
		{
			chargeGold(4);
		}
		
		private function closeLoading():void 
		{
			content.loadingMc.visible = false;
		}
		
		private function openLoading():void 
		{
			content.loadingMc.visible = true;
		}
		
		private function giftCodeFocusOutHandler(e:FocusEvent):void 
		{
			if (content.contentGiftCode.giftCodeTxt.text == "") 
			{
				content.contentGiftCode.giftCodeTxt.text = "Nhập mã quà tặng";
			}
		}
		
		private function giftCodeFocusHandler(e:FocusEvent):void 
		{
			if (content.contentGiftCode.giftCodeTxt.text == "Nhập mã quà tặng") 
			{
				content.contentGiftCode.giftCodeTxt.text = "";
			}
		}
		
		private function emailTxtFocusHandler(e:FocusEvent):void 
		{
			if (content.contentGiftCode.emailTxt.text == "Nhập email tặng quà") 
			{
				content.contentGiftCode.emailTxt.text = "";
			}
		}
		
		private function emailTxtFocusOutHandler(e:FocusEvent):void 
		{
			if (content.contentGiftCode.emailTxt.text == "") 
			{
				content.contentGiftCode.emailTxt.text = "Nhập email tặng quà";
			}
		}
		
		private function onClickReceive10(e:MouseEvent):void 
		{
			chargeGold(1);
		}
		
		private function onClickReceive60(e:MouseEvent):void 
		{
			chargeGold(2);
		}
		
		/**
		 * 0: 5 lan free, 1:Chơi 10 ván, 2: Chơi 60 phút, 3: Mời bạn, 4: Chia sẻ
		 */
		private function chargeGold(type:int):void 
		{
			if (!isLoad) 
			{
				openLoading();
				isLoad = true;
				var method:String = "POST";
				var url:String;
				var httpRequest:HTTPRequest = new HTTPRequest();
				var obj:Object;
				
				switch (type) 
				{
					case 0:
						url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_ViewGoldFree";
						obj = new Object();
						obj.access_token = mainData.token;
						obj.type_crg_id = 0;
						//httpRequest.sendRequest(method, url, obj, chargeFreeGoldSuccess, true);
					break;
					case 1:
						url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_ChargeGold";
						obj = new Object();
						obj.access_token = mainData.token;
						obj.type_crg_id = 2;
						httpRequest.sendRequest(method, url, obj, charge10Success, true);
					break;
					case 2:
						url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_ChargeGold";
						obj = new Object();
						obj.access_token = mainData.token;
						obj.type_crg_id = 3;
						httpRequest.sendRequest(method, url, obj, charge60Success, true);
					break;
					case 3:
						url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_ChargeGold";
						obj = new Object();
						obj.access_token = mainData.token;
						obj.type_crg_id = 4;
						httpRequest.sendRequest(method, url, obj, chargeInviteSuccess, true);
					break;
					case 4:
						url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_ChargeGold";
						obj = new Object();
						obj.access_token = mainData.token;
						obj.type_crg_id = 5;
						httpRequest.sendRequest(method, url, obj, chargeShareSuccess, true);
					break;
					default:
				}
			}
		}
		
		private function chargeInviteSuccess(obj:Object):void 
		{
			isLoad = false;
			closeLoading();
			if (obj["TypeMsg"] == 1) 
			{
				
				
				_arrGiftDay[3].content2Txt.text = "Số quà đã nhận: " + format(obj.Data.Gold_Value);
				_arrGiftDay[3].content3Txt.text = "Số quà chưa nhận: " + "0 Gold";
				_arrGiftDay[3].content4Txt.text = "";
				
				_arrGiftDay[3].receiveBtn.visible = false;
				
				mainData.chooseChannelData.myInfo.money += obj.Data.Gold_Value;
				mainData.chooseChannelData.myInfo = mainData.chooseChannelData.myInfo;
			}
			else if (obj["TypeMsg"] == -300) 
			{
				
			}
		}
		
		private function chargeShareSuccess(obj:Object):void 
		{
			isLoad = false;
			closeLoading();
			if (obj["TypeMsg"] == 1) 
			{
				
				
				_arrGiftDay[4].content2Txt.text = "Số quà đã nhận: " + format(obj.Data.Gold_Value);
				_arrGiftDay[4].content3Txt.text = "Số quà chưa nhận: " + "0 Gold";
				_arrGiftDay[4].content4Txt.text = "";
				
				_arrGiftDay[4].receiveBtn.visible = false;
				
				mainData.chooseChannelData.myInfo.money += obj.Data.Gold_Value;
				mainData.chooseChannelData.myInfo = mainData.chooseChannelData.myInfo;
			}
			else if (obj["TypeMsg"] == -300) 
			{
				
			}
		}
		
		private function charge60Success(obj:Object):void 
		{
			
			isLoad = false;
			closeLoading();
			if (obj["TypeMsg"] == 1) 
			{
				
				_arrGiftDay[1].content1Txt.text = "Số thời gian đã chơi hôm nay: " + "0/60";
				_arrGiftDay[1].content2Txt.text = "Số quà đã nhận: " + format(obj.Data.Gold_Value);
				_arrGiftDay[1].content4Txt.text = "";
				
				_arrGiftDay[1].receiveBtn.visible = false;
				
				mainData.chooseChannelData.myInfo.money += obj.Data.Gold_Value;
				mainData.chooseChannelData.myInfo = mainData.chooseChannelData.myInfo;
			}
			else if (obj["TypeMsg"] == -300) 
			{
				
			}
		}
		
		private function charge10Success(obj:Object):void 
		{
			
			isLoad = false;
			closeLoading();
			if (obj["TypeMsg"] == 1) 
			{
				
				_arrGiftDay[2].content1Txt.text = "Số ván chơi hôm nay: " + "0/10";
				_arrGiftDay[2].content2Txt.text = "Số quà đã nhận: " + format(obj.Data.Gold_Value);
				_arrGiftDay[2].content4Txt.text = "";
				
				_arrGiftDay[2].receiveBtn.visible = false;
				
				mainData.chooseChannelData.myInfo.money += obj.Data.Gold_Value;
				mainData.chooseChannelData.myInfo = mainData.chooseChannelData.myInfo;
			}
			else if (obj["TypeMsg"] == -200) 
			{
				
			}
		}
		
		private function allVisible():void 
		{
			content.hotNew.gotoAndStop(2);
			content.normalNew.gotoAndStop(2);
			content.giftCode.gotoAndStop(2);
			content.giftDay.gotoAndStop(2);
		}
		
		private function showBtt(type:int):void 
		{
			switch (type) 
			{
				case 0:
					content.hotNew.gotoAndStop(1);
				break;
				case 1:
					content.normalNew.gotoAndStop(1);
				break;
				case 2:
					if (mainData.country == "VN") 
					{
						content.giftCode.gotoAndStop(1);
					}
					else 
					{
						content.giftCode.gotoAndStop(2);
					}
					
				break;
				case 3:
					content.giftDay.gotoAndStop(1);
				break;
				default:
			}
		}
		
		private function addEvent():void 
		{
			content.hotNew.buttonMode = true;
			content.normalNew.buttonMode = true;
			content.giftCode.buttonMode = true;
			content.giftDay.buttonMode = true;
			
			content.hotNew.addEventListener(MouseEvent.MOUSE_UP, onClickHotNew);
			content.normalNew.addEventListener(MouseEvent.MOUSE_UP, onClickNormalNew);
			
			if (mainData.country == "VN") 
			{
				content.giftCode.addEventListener(MouseEvent.MOUSE_UP, onClickGiftCode);
			}
			else 
			{
				content.giftCode.gotoAndStop(2);
			}
			
			content.giftDay.addEventListener(MouseEvent.MOUSE_UP, onClickGiftDay);
			
			content.contentGiftCode.agreeBtn.addEventListener(MouseEvent.MOUSE_UP, onReceiveGiftCode);
			content.contentGiftCode.sendBtn.addEventListener(MouseEvent.MOUSE_UP, onSendGiftCode);
			
			_arrGiftDay[1].receiveBtn.addEventListener(MouseEvent.MOUSE_UP, onClickReceive60);
			_arrGiftDay[2].receiveBtn.addEventListener(MouseEvent.MOUSE_UP, onClickReceive10);
			_arrGiftDay[3].receiveBtn.addEventListener(MouseEvent.MOUSE_UP, onClickReceiveInvite);
			_arrGiftDay[4].receiveBtn.addEventListener(MouseEvent.MOUSE_UP, onClickReceiveShare);
			
			content.contentGiftCode.giftCodeTxt.addEventListener(FocusEvent.FOCUS_IN, giftCodeFocusHandler);
			content.contentGiftCode.giftCodeTxt.addEventListener(FocusEvent.FOCUS_OUT, giftCodeFocusOutHandler);
			
			content.contentGiftCode.emailTxt.addEventListener(FocusEvent.FOCUS_IN, emailTxtFocusHandler);
			content.contentGiftCode.emailTxt.addEventListener(FocusEvent.FOCUS_OUT, emailTxtFocusOutHandler);
		}
		
		private function onSendGiftCode(e:MouseEvent):void 
		{
			if (countGiftCode > 0 && 
				(content.contentGiftCode.emailTxt.text != "" && content.contentGiftCode.emailTxt.text != "Nhập email tặng quà")) 
			{
				if (!isLoad) 
				{
					openLoading();
					isLoad = true;
					var method:String = "POST";
					var url:String ;
					var httpRequest:HTTPRequest = new HTTPRequest();
					var obj:Object;
					
					url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_SendGiftcode";
					obj = new Object();
					obj.access_token = mainData.token;
					obj.email = content.contentGiftCode.emailTxt.text;
					httpRequest.sendRequest(method, url, obj, sendGiftCodeSuccess, true);
				}
			}
		}
		
		private function sendGiftCodeSuccess(obj:Object):void 
		{
			isLoad = false;
			closeLoading();
			if (obj.TypeMsg == 1) 
			{
				//windowLayer.openAlertWindow("Chúc mừng bạn đã tặng giftcode thành công");
				windowLayer.openAlertWindow(obj.Msg);
				countGiftCode--;
				content.contentGiftCode.countGiftCodeTxt.text = String(countGiftCode) + " lần";
			}
			else 
			{
				windowLayer.openAlertWindow(obj.Msg);
			}
		}
		
		private function onReceiveGiftCode(e:MouseEvent):void 
		{
			if (content.contentGiftCode.giftCodeTxt.text != "" && content.contentGiftCode.giftCodeTxt.text != "Nhập mã quà tặng") 
			{
				if (!isLoad) 
				{
					openLoading();
					isLoad = true;
					var method:String = "POST";
					var url:String ;
					var httpRequest:HTTPRequest = new HTTPRequest();
					var obj:Object;
					
					url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_ActiveGiftcode";
					obj = new Object();
					obj.access_token = mainData.token;
					obj.giftcode = content.contentGiftCode.giftCodeTxt.text;
					httpRequest.sendRequest(method, url, obj, activeGiftCodeSuccess, true);
				}
			}
		}
		
		private function activeGiftCodeSuccess(obj:Object):void 
		{
			isLoad = false;
			closeLoading();
			if (obj.TypeMsg == 1) 
			{
				//windowLayer.openAlertWindow("Chúc mừng bạn đã dùng giftcode thành công");
				windowLayer.openAlertWindow(obj.Msg);
				content.contentGiftCode.giftCodeTxt.text = "Nhập mã quà tặng";
				updateUserInfo();
			}
			else 
			{
				windowLayer.openAlertWindow(obj.Msg);
			}
		}
		
		
		private function updateUserInfo():void 
		{
			var method:String = "POST";
			var url:String;
			var httpRequest:HTTPRequest = new HTTPRequest();
			var obj:Object;
			
			url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_GetUserInfo";
			
			obj = new Object();
			obj.nick_name = mainData.chooseChannelData.myInfo.name;
			
			httpRequest.sendRequest(method, url, obj, onUpdateUserInfo, true);
		}
		
		private function onUpdateUserInfo(obj:Object):void 
		{
			trace(obj)
			mainData.chooseChannelData.myInfo.avatar = obj.Data["Avatar"];
			mainData.chooseChannelData.myInfo.money = obj.Data["Money"];
			mainData.chooseChannelData.myInfo.cash = obj.Data["Cash"];
			mainData.chooseChannelData.myInfo.level = obj.Data["Level"];
			
			mainData.chooseChannelData.myInfo = mainData.chooseChannelData.myInfo;
			MyDataTLMN.getInstance().myMoney[0] = obj.Data["Money"];
			MyDataTLMN.getInstance().myMoney[1] = obj.Data["Cash"];
			MyDataTLMN.getInstance().myAvatar = obj.Data["Avatar"];
			
		}
		
		
		
		public function onClickHotNew(e:MouseEvent):void 
		{
			content.contentGiftCode.visible = false;
			//content.bgNews.height = 304;
			content.bgNews.alpha = 0;
			hidePageView();
			currentPage = 0;
			allVisible();
			showBtt(0);
			getInfo(0);
		}
		
		public function onClickNormalNew(e:MouseEvent):void 
		{
			content.contentGiftCode.visible = false;
			
			//content.bgNews.height = 265;
			content.bgNews.alpha = 0;
			hidePageView();
			currentPage = 0;
			allVisible();
			showBtt(1);
			getInfo(1);
		}
		
		public function onClickGiftCode(e:MouseEvent):void 
		{
			
			if (mainData.country == "VN") 
			{
				scrollViewForNews.visible = false;
				if (newsDetail) 
				{
					newsDetail.removeEventListener("close", onCloseNewDetail);
					content.removeChild(newsDetail);
					newsDetail = null;
				}
				//content.bgNews.height = 304;
				content.bgNews.alpha = 1;
				hidePageView();
				currentPage = 0;
				allVisible();
				showBtt(2);
				content.contentGiftCode.visible = true;
				scrollViewForNews.visible = false;
			}
			
			
			//getInfo(2);
		}
		
		public function onClickGiftDay(e:MouseEvent):void 
		{
			content.contentGiftCode.visible = false;
			if (newsDetail) 
			{
				newsDetail.removeEventListener("close", onCloseNewDetail);
				content.removeChild(newsDetail);
				newsDetail = null;
			}
			//content.bgNews.height = 304;
			content.bgNews.alpha = 0;
			hidePageView();
			currentPage = 0;
			allVisible();
			showBtt(3);
			scrollViewForNews.removeAll();
			scrollViewForNews.visible = true;
			
			for (var i:int = 0; i < _arrGiftDay.length; i++) 
			{
				if (i > 0) 
				{
					_arrGiftDay[i].titleTxt.text = "";
					_arrGiftDay[i].titleTxt.mouseEnabled = false;
					_arrGiftDay[i].content1Txt.mouseEnabled = false;
					_arrGiftDay[i].content2Txt.mouseEnabled = false;
					_arrGiftDay[i].content3Txt.mouseEnabled = false;
					_arrGiftDay[i].content4Txt.mouseEnabled = false;
				}
				else 
				{
					_arrGiftDay[i].titleTxt.mouseEnabled = false;
					_arrGiftDay[i].contentTxt.mouseEnabled = false;
				}
				scrollViewForNews.addRow(_arrGiftDay[i]);
			}
			
			getInfoGiftDay(0);
		}
		
		/**
		 * 0: 5 lan free, 1:Chơi 10 ván, 2: Chơi 60 phút, 3: Mời bạn, 4: Chia sẻ, , 5: lay so du giftcode
		 */
		private function getInfoGiftDay(type:int):void 
		{
			if (!isLoad) 
			{
				if (type != 5) 
				{
					openLoading();
					isLoad = true;
				}
				
				
				var method:String = "POST";
				var url:String;
				var httpRequest:HTTPRequest = new HTTPRequest();
				var obj:Object;
				
				switch (type) 
				{
					case 0:
						url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_ViewGoldFree";
						obj = new Object();
						obj.access_token = mainData.token;
						obj.type_crg_id = 0;
						httpRequest.sendRequest(method, url, obj, loadInfoFreeGoldSuccess, true);
					break;
					case 1:
						url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_ViewGiftBySomeReason";
						obj = new Object();
						obj.access_token = mainData.token;
						obj.type_crg_id = 2;
						httpRequest.sendRequest(method, url, obj, loadInfo10Success, true);
					break;
					case 2:
						url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_ViewGiftBySomeReason";
						obj = new Object();
						obj.access_token = mainData.token;
						obj.type_crg_id = 3;
						httpRequest.sendRequest(method, url, obj, loadInfo60Success, true);
					break;
					case 3:
						url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_ViewGiftBySomeReason";
						obj = new Object();
						obj.access_token = mainData.token;
						obj.type_crg_id = 4;
						httpRequest.sendRequest(method, url, obj, loadInfoInviteSuccess, true);
					break;
					case 4:
						url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_ViewGiftBySomeReason";
						obj = new Object();
						obj.access_token = mainData.token;
						obj.type_crg_id = 5;
						httpRequest.sendRequest(method, url, obj, loadInfoShareSuccess, true);
					break;
					case 5:
						url = basePath + "Service02/OnplayGamePartnerExt.asmx/Azgamebai_GetGiftcodeLeftNumber";
						obj = new Object();
						obj.access_token = mainData.token;
						obj.type_gift_id = 1;
						httpRequest.sendRequest(method, url, obj, loadInfoSendGiftCodeSuccess, true);
					break;
					default:
				}
			}
			
		}
		
		private function loadInfoInviteSuccess(obj:Object):void 
		{
			if (obj["TypeMsg"] == 1) 
			{
				
				isLoad = false;
				closeLoading();
				
				_arrGiftDay[3].content1Txt.text = "Số bạn đã mời chơi hôm nay: " + String(obj.Data.FacebookInviteFriends) + "/5";
				_arrGiftDay[3].content2Txt.text = "Số quà đã nhận: " + format(obj.Data.GoldReceived) + " Gold";
				_arrGiftDay[3].content3Txt.text = "Số quà chưa nhận: " + format(obj.Data.GoldReceive) + " Gold";
				
				
				if (obj.Data.FacebookInviteFriends >= 5 && obj.Data.GoldReceived == 0) 
				{
					_arrGiftDay[3].receiveBtn.visible = true;
					_arrGiftDay[3].content4Txt.text = "";
				}
				else 
				{
					_arrGiftDay[3].receiveBtn.visible = false;
					_arrGiftDay[3].content4Txt.text = "Rất tiếc, bạn chưa thể nhận quà tặng!";
				}
				
				
			}
			getInfoGiftDay(4);
		}
		
		private function loadInfoShareSuccess(obj:Object):void 
		{
			if (obj["TypeMsg"] == 1) 
			{
				
				isLoad = false;
				closeLoading();
				
				_arrGiftDay[4].content1Txt.text = "Số lần share hôm nay: " + String(obj.Data.FacebookShares);
				_arrGiftDay[4].content2Txt.text = "Số quà đã nhận: " + format(obj.Data.GoldReceived) + " Gold";
				_arrGiftDay[4].content3Txt.text = "Số quà chưa nhận: " + format(obj.Data.GoldReceive) + " Gold";
				
				
				if (obj.Data.FacebookShares >= 1 && obj.Data.GoldReceived == 0) 
				{
					_arrGiftDay[4].receiveBtn.visible = true;
					_arrGiftDay[4].content4Txt.text = "";
				}
				else 
				{
					_arrGiftDay[4].receiveBtn.visible = false;
					_arrGiftDay[4].content4Txt.text = "Rất tiếc, bạn chưa thể nhận quà tặng!";
				}
				
				
			}
		}
		
		private function loadInfoSendGiftCodeSuccess(obj:Object):void 
		{
			if (obj["TypeMsg"] == 1) 
			{
				
				isLoad = false;
				closeLoading();
				
				countGiftCode = obj.Data.GiftcodeLeftNumber;
				content.contentGiftCode.countGiftCodeTxt.text = String(countGiftCode) + " lần";
			}
		}
		
		private function loadInfo60Success(obj:Object):void 
		{
			if (obj["TypeMsg"] == 1) 
			{
				
				isLoad = false;
				closeLoading();
				
				_arrGiftDay[1].content1Txt.text = "Số thời gian đã chơi hôm nay: " + String(obj.Data.TimeMinuteToday) + "/60";
				_arrGiftDay[1].content2Txt.text = "Số quà đã nhận: " + format(obj.Data.GoldReceived) + " Gold";
				_arrGiftDay[1].content3Txt.text = "Số quà chưa nhận: " + format(obj.Data.GoldReceive) + " Gold";
				
				
				if (obj.Data.GameCountToday >= 60 && obj.Data.GoldReceived == 0) 
				{
					_arrGiftDay[1].receiveBtn.visible = true;
					_arrGiftDay[1].content4Txt.text = "";
				}
				else 
				{
					_arrGiftDay[1].receiveBtn.visible = false;
					_arrGiftDay[1].content4Txt.text = "Rất tiếc, bạn chưa thể nhận quà tặng!";
				}
				
				
			}
			
			getInfoGiftDay(3);
		}
		
		private function loadInfoFreeGoldSuccess(obj:Object):void 
		{
			if (obj["TypeMsg"] == 1) 
			{
				isLoad = false;
				closeLoading();
				//
				if (obj.Data > 0) 
				{
					_arrGiftDay[0].contentTxt.htmlText = "Bạn còn " + "<font color='#FFCC33'>" + "0" + obj.Data + "</font>" + " lần nạp miễn phí trong ngày";
					_arrGiftDay[0].receiveBtn.visible = false;
				}
				else 
				{
					_arrGiftDay[0].contentTxt.htmlText = "Bạn đã hết số lần nạp miễn phí trong ngày.";
					_arrGiftDay[0].receiveBtn.visible = false;
				}
				
			}
			else if (obj["TypeMsg"] == -102) 
			{
				isLoad = false;
				closeLoading();
				scrollViewForNews.removeAll();
				
				_arrGiftDay[0].contentTxt.htmlText = obj["Msg"];
				_arrGiftDay[0].receiveBtn.visible = false;
			}
			
			getInfoGiftDay(1);
			
		}
		
		private function loadInfo10Success(obj:Object):void 
		{
			trace(obj.Data.GameCountToday)
			if (obj["TypeMsg"] == 1) 
			{
				
				isLoad = false;
				closeLoading();
				
				_arrGiftDay[2].content1Txt.text = "Số ván chơi hôm nay: " + String(obj.Data.GameCountToday) + "/10";
				_arrGiftDay[2].content2Txt.text = "Số quà đã nhận: " + format(obj.Data.GoldReceived) + " Gold";
				_arrGiftDay[2].content3Txt.text = "Số quà chưa nhận: " + format(obj.Data.GoldReceive) + " Gold";
				
				
				if (obj.Data.GameCountToday >= 10 && obj.Data.GoldReceived == 0) 
				{
					_arrGiftDay[2].receiveBtn.visible = true;
					_arrGiftDay[2].content4Txt.text = "";
				}
				else 
				{
					_arrGiftDay[2].receiveBtn.visible = false;
					_arrGiftDay[2].content4Txt.text = "Rất tiếc, bạn chưa thể nhận quà tặng!";
				}
				
				
			}
			
			getInfoGiftDay(2);
		}
		
		/**
		 * 0:hot news, 1: normal news, 2: gift code, 3: gift day 
		 */
		private function getInfo(type:int):void 
		{
			if (!isLoad) 
			{
				if (newsDetail) 
				{
					newsDetail.removeEventListener("close", onCloseNewDetail);
					content.removeChild(newsDetail);
					newsDetail = null;
				}
				openLoading();
				isLoad = true;
				var method:String = "POST";
				var url:String;
				var httpRequest:HTTPRequest = new HTTPRequest();
				var obj:Object;
				
				switch (type) 
				{
					case 0:
						url = basePath + "Service02/OnplayConfigExt.asmx/GetListConfigs?sq_twcf002_ref_id=3&row_start=0&row_end=1000";
						obj = new Object();
						httpRequest.sendRequest(method, url, obj, loadBannerSuccess, true);
					break;
					case 1:
						url = basePath + "Service02/SanhbaiCms.asmx/GetListArticleByCategoryId?categories=141&row_start=" + 
							(currentPage * 4 + 1) + "&row_end=" + (currentPage + 1) * 4 + "&post_excerpt_length=0";
						obj = new Object();
						httpRequest.sendRequest(method, url, obj, loadNewsSuccess, true);
					break;
					default:
				}
			}
			
		}
		
		private function loadNewsSuccess(obj:Object):void 
		{
			if (obj["TypeMsg"] == 1) 
			{
				
				isLoad = false;
				closeLoading();
				scrollViewForNews.removeAll();
				scrollViewForNews.visible = true;
				var arr:Array = obj.Data;
				if (arr.length > 0) 
				{
					totalPage = Math.ceil(obj.RowCount / 4);
					showPageView(currentPage, totalPage);
					
					for (var i:int = 0; i < arr.length; i++) 
					{
						
						var bannerInfo:ContentNews = new ContentNews();
						bannerInfo.addInfo(arr[i]["article_id"], arr[i]["post_title"], arr[i]["post_date"], arr[i]["post_title_seo"]);
						scrollViewForNews.addRow(bannerInfo);
						bannerInfo.addEventListener(MouseEvent.CLICK, showDetailNews);
					}
				}
				
			}
		}
		
		private function showDetailNews(e:MouseEvent):void 
		{
			var contentNews:ContentNews = e.currentTarget as ContentNews;
			if (!isLoad) 
			{
				
				openLoading();
				isLoad = true;
				var method:String = "POST";
				var url:String;
				var httpRequest:HTTPRequest = new HTTPRequest();
				var obj:Object;
				
				url = basePath + "Service02/SanhbaiCms.asmx/GetArticle?post_title_seo=" 
									+ contentNews.articleSeo + "&post_excerpt_length=10000";
				obj = new Object();
				httpRequest.sendRequest(method, url, obj, loadNewsDetailSuccess, true);
			}
		}
		
		private function loadNewsDetailSuccess(obj:Object):void 
		{
			if (obj["TypeMsg"] == 1) 
			{
				isLoad = false;
				closeLoading();
				
				if (newsDetail) 
				{
					newsDetail.removeEventListener("close", onCloseNewDetail);
					content.removeChild(newsDetail);
					newsDetail = null;
				}
				
				newsDetail = new ShowNewsDetail();
				content.addChild(newsDetail);
				newsDetail.x = 152;
				newsDetail.y = 71;
				newsDetail.addEventListener("close", onCloseNewDetail);
				newsDetail.addInfo(obj.Data.post_title, obj.Data.post_date, obj.Data.post_content);
			}
			
		}
		
		private function onCloseNewDetail(e:Event):void 
		{
			if (newsDetail) 
			{
				newsDetail.removeEventListener("close", onCloseNewDetail);
				content.removeChild(newsDetail);
				newsDetail = null;
			}
		}
		
		private function hidePageView():void 
		{
			content.pageView.visible = false;
			content.pageView.backBtn.removeEventListener(MouseEvent.MOUSE_UP, onBackPage);
			content.pageView.nextBtn.removeEventListener(MouseEvent.MOUSE_UP, onNextPage);
			content.pageView.currentPage.removeEventListener(FocusEvent.FOCUS_IN, onFocusInCurP);
			content.pageView.currentPage.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOutCurP);
		}
		
		private function showPageView(curPage:int, toPage:int):void 
		{
			onFocusCurP = false;
			currentPage = curPage;
			content.pageView.totalPage.mouseEnabled = false;
			content.pageView.visible = true;
			content.pageView.currentPage.text = String(curPage + 1);
			content.pageView.totalPage.text = "/" + String(toPage);
			
			content.pageView.backBtn.addEventListener(MouseEvent.MOUSE_UP, onBackPage);
			content.pageView.nextBtn.addEventListener(MouseEvent.MOUSE_UP, onNextPage);
			content.pageView.currentPage.addEventListener(FocusEvent.FOCUS_IN, onFocusInCurP);
			content.pageView.currentPage.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutCurP);
			
		}
		
		private function onFocusOutCurP(e:FocusEvent):void 
		{
			if (onFocusCurP) 
			{
				onFocusCurP = false;
				if (int(content.pageView.currentPage.text) > totalPage) 
				{
					content.pageView.currentPage.text = String(currentPage);
				}
				else 
				{
					currentPage = int(content.pageView.currentPage.text) - 1;
				}
				
				getInfo(1);
			}
		}
		
		private function onFocusInCurP(e:FocusEvent):void 
		{
			onFocusCurP = true;
		}
		
		private function onNextPage(e:MouseEvent):void 
		{
			if (currentPage < totalPage) 
			{
				currentPage++;
				getInfo(1);
			}
		}
		
		private function onBackPage(e:MouseEvent):void 
		{
			if (currentPage > 0) 
			{
				currentPage--;
				getInfo(1);
			}
		}
		
		private function loadBannerSuccess(obj:Object):void 
		{
			if (obj["TypeMsg"] == 1) 
			{
				isLoad = false;
				closeLoading();
				scrollViewForNews.removeAll();
				
				var arr:Array = obj.Data;
				arr = arr.sortOn("ordinal", Array.CASEINSENSITIVE);
				for (var i:int = 0; i < arr.length; i++) 
				{
					if (arr[i]["value"] == "TRUE") 
					{
						var bannerInfo:ContentBannerEvent = new ContentBannerEvent();
						bannerInfo.addInfo(arr[i]["image_url"], arr[i]["popup_url"]);
						scrollViewForNews.addRow(bannerInfo);
					}
				}
			}
		}
		
		public function removeAllEvent():void 
		{
			scrollViewForNews.removeAll();
		}
		
		
		protected function format(number:Number):String 
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