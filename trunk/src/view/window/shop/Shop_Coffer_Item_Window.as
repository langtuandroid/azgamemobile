package view.window.shop 
{
	import flash.display.MovieClip;
	import request.HTTPRequest;
	import view.ScrollView.ScrollViewYun;
	import view.window.BaseWindow;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class Shop_Coffer_Item_Window extends BaseWindow 
	{
		private var myContent:MovieClip;
		private var _arrBtnInTab:Array;
		
		private var _arrHeaderTab:Array;
		
		private var _arrBoard:Array;
		
		private var _type:int; // dang chon xem cai j`
		
		private var scrollView:ScrollViewYun;
		
		public function Shop_Coffer_Item_Window() 
		{
			super();
			
			myContent = new Shop_Coffer_Item_Mc();
			addChild(myContent);
			
			_arrBtnInTab = [myContent.tabMc.chooseGameBtn, myContent.tabMc.standingBtn, myContent.tabMc.addMoneyBtn,
							myContent.tabMc.shopBtn, myContent.tabMc.cofferBtn];
						//chon game, bang xep hang, nap tien, shop, hom do
			_arrHeaderTab = [myContent.chooseInStandingMc, myContent.chooseInAddMoneyMc, myContent.chooseInShopMc,
							myContent.chooseInCofferMc];
							//xep hang, nap tien, shop, hom do
			_arrBoard = [myContent.standingBg, myContent.smsBg, myContent.rakingBg, myContent.containerItemMc];
						//xep hang, nap sms, nap the, chua item
			
			scrollView = new ScrollViewYun();
			scrollView.setData(myContent.containerItemMc, 10);
			scrollView.distanceInColumn = 25;
			scrollView.distanceInRow = 10;
			scrollView.columnNumber = 2;
			myContent.addChild(scrollView);
			scrollView.x = myContent.containerItemMc.x;
			scrollView.y = myContent.containerItemMc.y;
			
			tabOn(3);
			headerOn(2);
			boardOn(2);
			loadItem(0);
			
			
		}
		
		/**
		 * type(0: chon game, 1:xep hang, 2:nap the, 3:shop, 4:hom do)
		 */
		private function tabOn(type:int):void 
		{
			_type = type;
			var i:int;
			for (i = 0; i < _arrBtnInTab.length; i++) 
			{
				myContent.tabMc.setChildIndex(_arrBtnInTab[i], myContent.tabMc.numChildren - 1);
			}
			
			myContent.tabMc.setChildIndex(_arrBtnInTab[type], myContent.tabMc.numChildren - 1);
		}
		
		/**
		 * type(0:xep hang, 1:nap the, 2:shop, 3:hom do)
		 */
		private function headerOn(type:int):void 
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
		private function boardOn(type:int):void 
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
			var method:String = "post";
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
				default:
			}
			
			
			
			
			
			
		}
		
		private function loadAvatarSuccess(obj:Object):void 
		{
			var arrData:Array = obj.Data;
			for (var i:int = 0; i < arrData.length; i++ ) 
			{
				var nameAvatar:String = arrData[i]['avt_name'];
				var chipAvatar:String = arrData[i]['avt_buy_chip'];
				var goldAvatar:String = arrData[i]['avt_buy_gold'];
				var linkAvatar:String = arrData[i]['avt_dir_path'];
				var expireAvatar:String = arrData[i]['avt_sell_expire_dt'];
				var gender:String = arrData[i]['avt_gender_code'];
				var idAvt:String = arrData[i]['avt_id'];
				
				var contentAvatar:ContentAvatar = new ContentAvatar();
				contentAvatar.addInfo(idAvt, nameAvatar, chipAvatar, goldAvatar, linkAvatar, expireAvatar);
				scrollView.addChild(contentAvatar);
			}
		}
	}

}