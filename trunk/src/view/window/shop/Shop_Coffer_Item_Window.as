package view.window.shop 
{
	import com.adobe.crypto.MD5;
	import com.milkmangames.nativeextensions.GVFacebookRequestFilter;
	import control.ConstTlmn;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import model.chooseChannelData.MyInfo;
	import model.MainData;
	import request.HTTPRequest;
	import view.ScrollView.ScrollViewYun;
	import view.window.BaseWindow;
	import view.window.ConfirmWindow;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class Shop_Coffer_Item_Window extends Sprite 
	{
		private var myContent:MovieClip;
		private var choosePay:ChoosePayMoneyType;
		private var typeOfPay:int; //0:thanh toan bang gold, 1:thanh toan bang chip
		private var _arrBtnInTab:Array;
		
		private var _arrHeaderTab:Array;
		
		private var _arrBoard:Array;
		
		private var _type:int; // dang chon xem cai j`
		/**
		 * 1:vina, 2:mobi, 3:viettel, 4:Vtc, 5:megacard, 6:fptgate
		 */
		private var _typOfNetwork:String = "VNP"; // dang chon nap the bang nha mang nao
		
		private var scrollView:ScrollViewYun;
		private var windowLayer:WindowLayer = WindowLayer.getInstance();
		
		private var _arrAvatar:Array = [];
		private var _arrGold:Array = [];
		private var _arrItem:Array = [];
		private var _arrTour:Array = [];
		private var _arrGift:Array = [];
		
		private var _arrMyAvatar:Array = [];
		private var _arrMyItem:Array = [];
		private var _arrMyGold:Array = [];
		
		private var avatarChoseBuy:*;
		private var goldChoseBuy:*;
		
		public function Shop_Coffer_Item_Window() 
		{
			super();
			
			myContent = new Shop_Coffer_Item_Mc();
			addChild(myContent);
			
			
						//chon game, bang xep hang, nap tien, shop, hom do
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
		
		private function addEvent():void 
		{
			myContent.chooseInShopMc.chooseAvatar.addEventListener(MouseEvent.MOUSE_UP, onClickShowAvatar);
			myContent.chooseInShopMc.chooseGold.addEventListener(MouseEvent.MOUSE_UP, onClickShowGold);
			myContent.chooseInShopMc.chooseItem.addEventListener(MouseEvent.MOUSE_UP, onClickShowItem);
			myContent.chooseInShopMc.chooseTour.addEventListener(MouseEvent.MOUSE_UP, onClickShowTour);
			myContent.chooseInShopMc.chooseGift.addEventListener(MouseEvent.MOUSE_UP, onClickShowGift);
			
			
			
			myContent.chooseInCofferMc.chooseAvatar.addEventListener(MouseEvent.MOUSE_UP, onClickShowMyAvatar);
			myContent.chooseInCofferMc.chooseGold.addEventListener(MouseEvent.MOUSE_UP, onClickShowMyGold);
			myContent.chooseInCofferMc.chooseItem.addEventListener(MouseEvent.MOUSE_UP, onClickShowMyItem);
			
			
			myContent.chooseInAddMoneyMc.raking.addEventListener(MouseEvent.MOUSE_UP, onClickShowAddMoneyRaking);
			myContent.chooseInAddMoneyMc.sms.addEventListener(MouseEvent.MOUSE_UP, onClickShowAddMoneySms);
			
			myContent.rakingBg.choosePayVina.gotoAndStop(2);
			myContent.rakingBg.choosePayMobi.gotoAndStop(1);
			myContent.rakingBg.choosePayViettel.gotoAndStop(1);
			myContent.rakingBg.choosePayVtc.gotoAndStop(1);
			myContent.rakingBg.choosePayMega.gotoAndStop(1);
			myContent.rakingBg.choosePayFpt.gotoAndStop(1);
			
			myContent.rakingBg.userNameTxt.addEventListener(FocusEvent.FOCUS_IN, userNameFocusHandler);
			myContent.rakingBg.userNameTxt.addEventListener(FocusEvent.FOCUS_OUT, userNameFocusOutHandler);
			
			myContent.rakingBg.serinumberTxt.addEventListener(FocusEvent.FOCUS_IN, seriFocusHandler);
			myContent.rakingBg.serinumberTxt.addEventListener(FocusEvent.FOCUS_OUT, seriFocusOutHandler);
			
			myContent.rakingBg.codenumberTxt.addEventListener(FocusEvent.FOCUS_IN, codeFocusHandler);
			myContent.rakingBg.codenumberTxt.addEventListener(FocusEvent.FOCUS_OUT, codeFocusOutHandler);
			
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
			if (txt.text == "") 
			{
				txt.text = "nhập tên";
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
			if ((myContent.rakingBg.userNameTxt.text != "" || myContent.rakingBg.userNameTxt.text != "nhập tên")
				&& (myContent.rakingBg.serinumberTxt.text != "" || myContent.rakingBg.serinumberTxt.text != "nhập seri thẻ")
				&& (myContent.rakingBg.codenumberTxt.text != ""  || myContent.rakingBg.codenumberTxt.text != "nhập mã thẻ")
				
				) 
			{
				var method:String = "POST";
				var url:String;
				var httpRequest:HTTPRequest = new HTTPRequest();
				var obj:Object;
				
				url = "http://wss.azgame.us/Service01/Billings/OnplayMobile.asmx/CardCharging";
				
				obj = new Object();
				obj.nick_name = MainData.getInstance().chooseChannelData.myInfo.id;
				obj.telco_code = _typOfNetwork;
				obj.card_serial = myContent.rakingBg.serinumberTxt.text;
				obj.card_id = myContent.rakingBg.codenumberTxt.text;
				httpRequest.sendRequest(method, url, obj, onAddMoneyRespone, true);
			}
		}
		
		private function onAddMoneyRespone(obj:Object):void 
		{
			
		}
		
		private function onClickChoseSms1(e:MouseEvent):void 
		{
			
		}
		private function onClickChoseSms2(e:MouseEvent):void 
		{
			
		}
		private function onClickChoseSms3(e:MouseEvent):void 
		{
			
		}
		
		private function onClickShowAddMoneySms(e:MouseEvent):void 
		{
			headerOn(1);
			boardOn(1);
		}
		
		private function onClickShowAddMoneyRaking(e:MouseEvent):void 
		{
			headerOn(1);
			boardOn(2);
		}
		
		/**
		 * type(0: avatar, 1:gold, 2:item)
		 */
		public function loadMyItem(type:int):void 
		{
			var method:String = "POST";
			var url:String;
			var httpRequest:HTTPRequest = new HTTPRequest();
			var obj:Object;
			
			headerOn(3);
			
			switch (type) 
			{
				case 0:
					url = "http://wss.azgame.vn/Service02/OnplayUserExt.asmx/GetListAvatarOfBuyer?nick_name=" + 
						MainData.getInstance().chooseChannelData.myInfo.name + "&rowStart=0&rowEnd=10";
						
					obj = new Object();
					trace("xem avâtr cua minh: ", url);
					httpRequest.sendRequest(method, url, obj, loadMyAvatarSuccess, true);
				break;
				case 1:
					url = "http://wss.azgame.vn/Service02/OnplayUserExt.asmx/GetListTwit00" + String(1) + 
									"?rowStart=0&rowEnd=10";
					obj = new Object();
					obj.it_group_id = String(1);
					obj.it_type = String(1);
					httpRequest.sendRequest(method, url, obj, loadMyItemGoldSuccess, true);
				break;
				default:
			}
		}
		
		private function loadMyItemGoldSuccess(obj:Object):void 
		{
			
		}
		
		private function loadMyAvatarSuccess(obj:Object):void 
		{
			trace(obj)
			if (obj["Msg"] == "Cập nhật thành công") 
			{
				var i:int;
				var arrData:Array = obj.Data;
				var countX:int;
				var countY:int;

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
			var url:String = "http://wss.azgame.vn/Service02/OnplayShopExt.asmx/DressAvatarFromClientSide";
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
			if (obj["Msg"] == "Cập nhật thành công") 
			{
				var buyAvatarWindow:ConfirmWindow = new ConfirmWindow();
				buyAvatarWindow.setNotice("Bạn đã đổi thành công avatar này!");
				
				windowLayer.openWindow(buyAvatarWindow);
			}
		}
		
		private function onClickShowMyAvatar(e:MouseEvent):void 
		{
			
		}
		
		private function onClickShowMyGold(e:MouseEvent):void 
		{
			
		}
		
		private function onClickShowMyItem(e:MouseEvent):void 
		{
			
		}
		
		private function onClickShowGift(e:MouseEvent):void 
		{
			loadItem(4);
		}
		
		private function onClickShowTour(e:MouseEvent):void 
		{
			loadItem(3);
		}
		
		private function onClickShowItem(e:MouseEvent):void 
		{
			loadItem(2);
		}
		
		private function onClickShowGold(e:MouseEvent):void 
		{
			loadItem(1);
		}
		
		private function onClickShowAvatar(e:MouseEvent):void 
		{
			loadItem(0);
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
		public function loadItem(type:int):void 
		{
			headerOn(2);
			
			var method:String = "POST";
			var url:String;
			var httpRequest:HTTPRequest = new HTTPRequest();
			var obj:Object;
			
			switch (type) 
			{
				case 0:
					url = "http://wss.azgame.vn/Service02/OnplayUserExt.asmx/GetListTwav00" + String(1)
									+ "?rowStart=0&rowEnd=10";
					obj = new Object();
					obj.avt_group_id = String(0);
					httpRequest.sendRequest(method, url, obj, loadAvatarSuccess, true);
				break;
				case 1:
					url = "http://wss.azgame.vn/Service02/OnplayUserExt.asmx/GetListTwit00" + String(1) + 
									"?rowStart=0&rowEnd=10";
					obj = new Object();
					obj.it_group_id = String(1);
					obj.it_type = String(1);
					httpRequest.sendRequest(method, url, obj, loadItemGoldSuccess, true);
				break;
				case 2:
					url = "http://wss.azgame.vn/Service02/OnplayUserExt.asmx/GetListTwit00" + String(1) + 
									"?rowStart=0&rowEnd=10";
					obj = new Object();
					obj.it_group_id = String(1);
					obj.it_type = String(2);
					httpRequest.sendRequest(method, url, obj, loadItemNormalSuccess, true);
				break;
				default:
			}
			
			
			
			
			
			
		}
		
		private function loadItemNormalSuccess(obj:Object):void 
		{
			var arrData:Array = obj.Data;
			var countX:int;
			var countY:int;
			var i:int;
			
			for (i = 0; i < _arrGold.length; i++ ) 
			{
				_arrGold[i].removeEventListener(ConstTlmn.BUY_ITEM, onBuyItemGold);
				
			}
			scrollView.removeAll();
			_arrGold = [];
			
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
			var url:String = "http://wss.azgame.vn/Service02/OnplayShopExt.asmx/BuyItemFromClientSide";
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
			trace(obj)
			
			var arrData:Array = obj.Data;
			var countX:int;
			var countY:int;
			var i:int;
			
			for (i = 0; i < _arrGold.length; i++ ) 
			{
				_arrGold[i].removeEventListener(ConstTlmn.BUY_ITEM, onBuyItemGold);
				
			}
			scrollView.removeAll();
			_arrGold = [];
			
			for (i = 0; i < arrData.length; i++ ) 
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
			
			var myInfo:MyInfo = new MyInfo();
			var url:String = "http://wss.azgame.vn/Service02/OnplayShopExt.asmx/BuyItemFromClientSide";
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
		
		private function buyItemRespone(obj:Object):void 
		{
			trace(obj)
			var buyAvatarWindow:ConfirmWindow;
			if (obj["Msg"] == "Cập nhật thành công") 
			{
				buyAvatarWindow = new ConfirmWindow();
				buyAvatarWindow.setNotice("Giao dịch thành công");
				
				windowLayer.openWindow(buyAvatarWindow);
			}
			else if (obj["Msg"] == "Tài khoản không có đủ CHIP") 
			{
				buyAvatarWindow = new ConfirmWindow();
				buyAvatarWindow.setNotice("Tài khoản không có đủ CHIP");
				
				windowLayer.openWindow(buyAvatarWindow);
			}
		}
		
		private function loadAvatarSuccess(obj:Object):void 
		{
			var i:int;
			var arrData:Array = obj.Data;
			var countX:int;
			var countY:int;

			for (i = 0; i < _arrAvatar.length; i++ ) 
			{
				_arrAvatar[i].removeEventListener(ConstTlmn.BUY_AVATAR, onBuyAvatar);
				
			}
			scrollView.removeAll();
			_arrAvatar = [];
			
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
			
			var myInfo:MyInfo = new MyInfo();
			var url:String = "http://wss.azgame.vn/Service02/OnplayShopExt.asmx/BuyAvatarFromClientSide";
			var obj:Object = new Object();
			var mainData:MainData = MainData.getInstance();
			obj["access_token"] = mainData.loginData["AccessToken"];
			obj["game_code"] = avatarChoseBuy._goldAvt;
			obj["payment_type"] = "1";
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
		
		private function buyAvatarRespone(obj:Object):void 
		{
			trace(obj)
			if (obj["Msg"] == "Cập nhật thành công") 
			{
				var buyAvatarWindow:ConfirmWindow = new ConfirmWindow();
				buyAvatarWindow.setNotice("Giao dịch thành công");
				
				windowLayer.openWindow(buyAvatarWindow);
			}
		}
		
		public function chooseAddMoney():void 
		{
			headerOn(1);
			boardOn(2);
			
			
		}
	}
	
	

}