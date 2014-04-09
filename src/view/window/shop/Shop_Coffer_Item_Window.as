package view.window.shop 
{
	import com.adobe.crypto.MD5;
	import control.ConstTlmn;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
		private var _arrBtnInTab:Array;
		
		private var _arrHeaderTab:Array;
		
		private var _arrBoard:Array;
		
		private var _type:int; // dang chon xem cai j`
		
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
			
			
			
		}
		
		/**
		 * type(0: avatar, 1:gold, 2:item)
		 */
		public function loadMyItem(type:int):void 
		{
			var method:String = "POST";
			var url:String;
			var httpRequest:HTTPRequest = new HTTPRequest();
			var obj:Object = new Object();
			
			switch (type) 
			{
				case 0:
					url = "http://wss.test.azgame.us/Service02/OnplayUserExt.asmx/GetListAvatarOfBuyer";
					obj.mb_id = MainData.getInstance().chooseChannelData.myInfo.id + "&rowStart=0&rowEnd=10";
					httpRequest.sendRequest(method, url, obj, loadMyAvatarSuccess, true);
				break;
				case 1:
					url = "http://wss.test.azgame.us/Service02/OnplayUserExt.asmx/GetListTwit00" + String(1) + 
									"?rowStart=0&rowEnd=10";
					obj.it_group_id = String(1);
					obj.it_type = String(1);
					httpRequest.sendRequest(method, url, obj, loadMyItemSuccess, true);
				break;
				default:
			}
		}
		
		private function loadMyItemSuccess(obj:Object):void 
		{
			
		}
		
		private function loadMyAvatarSuccess(obj:Object):void 
		{
			trace(obj)
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
			var method:String = "POST";
			var url:String;
			var httpRequest:HTTPRequest = new HTTPRequest();
			var obj:Object = new Object();
			
			switch (type) 
			{
				case 0:
					url = "http://wss.test.azgame.us/Service02/OnplayUserExt.asmx/GetListTwav00" + String(1)
									+ "?rowStart=0&rowEnd=10";
					obj.avt_group_id = String(1);
					httpRequest.sendRequest(method, url, obj, loadAvatarSuccess, true);
				break;
				case 1:
					url = "http://wss.test.azgame.us/Service02/OnplayUserExt.asmx/GetListTwit00" + String(1) + 
									"?rowStart=0&rowEnd=10";
					obj.it_group_id = String(1);
					obj.it_type = String(1);
					httpRequest.sendRequest(method, url, obj, loadItemSuccess, true);
				break;
				default:
			}
			
			
			
			
			
			
		}
		
		private function loadItemSuccess(obj:Object):void 
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
				
				
				contentAvatar.addInfo(idAvt, nameAvatar, chipAvatar, payGold, linkAvatar, expireAvatar);
				scrollView.addRow(contentAvatar);
				//_arrBoard[3].addChild(contentAvatar);
				
				contentAvatar.addEventListener(ConstTlmn.BUY_ITEM, onBuyItemGold);
			}
		}
		
		private function onBuyItemGold(e:Event):void 
		{
			var avatar:ContentItemGold = e.currentTarget as ContentItemGold;
			var myInfo:MyInfo = new MyInfo();
			var url:String = "http://wss.test.azgame.us/Service02/OnplayShopExt.asmx/BuyItemFromClientSide";
			var obj:Object = new Object();
			var mainData:MainData = MainData.getInstance();
			obj["access_token"] = mainData.loginData["AccessToken"];
			obj["game_code"] = avatar._goldAvt;
			obj["payment_type"] = "1";
			obj["nk_nm_receiver"] = mainData.loginData["Id"];
			obj["item_id"] = avatar._idAvt;
			obj["item_quantity"] = "1";
			obj["client_hash"] = MD5.hash(obj["access_token"] + obj["game_code"]
			 + obj["payment_type"] + obj["nk_nm_receiver"] + obj["item_id"] +
			 obj["item_quantity"]);
			
			trace("link mua item: ", obj["access_token"])
			var httpReq:HTTPRequest = new HTTPRequest();
			httpReq.sendRequest("POST", url, obj, buyItemRespone, true);
		}
		
		private function buyItemRespone(obj:Object):void 
		{
			trace(obj)
			if (obj["Msg"] = "Cập nhật thành công") 
			{
				var buyAvatarWindow:ConfirmWindow = new ConfirmWindow();
				buyAvatarWindow.setNotice("Bạn đã mua thành công vật phẩm này!");
				
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
				
				
				contentAvatar.addInfo(idAvt, nameAvatar, chipAvatar, goldAvatar, linkAvatar, expireAvatar);
				scrollView.addRow(contentAvatar);
				//_arrBoard[3].addChild(contentAvatar);
				
				contentAvatar.addEventListener(ConstTlmn.BUY_AVATAR, onBuyAvatar);
			}
		}
		
		private function onBuyAvatar(e:Event):void 
		{
			var avatar:ContentAvatar = e.currentTarget as ContentAvatar;
			var myInfo:MyInfo = new MyInfo();
			var url:String = "http://wss.test.azgame.us/Service02/OnplayShopExt.asmx/BuyAvatarFromClientSide";
			var obj:Object = new Object();
			var mainData:MainData = MainData.getInstance();
			obj["access_token"] = mainData.loginData["AccessToken"];
			obj["game_code"] = avatar._goldAvt;
			obj["payment_type"] = "1";
			obj["nk_nm_receiver"] = mainData.loginData["Id"];
			obj["item_id"] = avatar._idAvt;
			obj["item_quantity"] = "1";
			obj["client_hash"] = MD5.hash(obj["access_token"] + obj["game_code"]
			 + obj["payment_type"] + obj["nk_nm_receiver"] + obj["item_id"] +
			 obj["item_quantity"]);
			
			trace("link mua avatar: ", obj["access_token"])
			var httpReq:HTTPRequest = new HTTPRequest();
			httpReq.sendRequest("POST", url, obj, buyAvatarRespone, true);
		}
		
		private function buyAvatarRespone(obj:Object):void 
		{
			trace(obj)
			if (obj["Msg"] = "Cập nhật thành công") 
			{
				var buyAvatarWindow:ConfirmWindow = new ConfirmWindow();
				buyAvatarWindow.setNotice("Bạn đã mua thành công vật phẩm này!");
				
				windowLayer.openWindow(buyAvatarWindow);
			}
		}
		
	}
	
	

}