package view 
{
	import flash.net.NetworkInfo
	import com.greensock.TweenMax;
	import control.MainCommand;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	import logic.PlayingLogic;
	import model.chooseChannelData.ChooseChannelData;
	import model.GameDataTLMN;
	import model.MainData;
	import model.MyDataTLMN;
	import request.HTTPRequest;
	import request.MainRequest;
	import sound.SoundManager;
	import view.itemContainer.ItemContainerYun;
	import view.itemContainer.PanelScrollYun;
	import view.userInfo.avatar.Avatar;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.GiftCodeWindow;
	import view.window.news.NewsWindow;
	
	import view.window.shop.Shop_Coffer_Item_Window_New;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class SelectGameWindowNew extends BaseWindow 
	{
		public static const SELECT_GAME:String = "selectGame";
		public static const RE_LOGIN_CLICK:String = "reLoginClick";
		public static const MOVE_TO_PLAYING_SCREEN:String = "moveToPlayingScreen";
		public static const MOVE_TO_LOBBY_SCREEN:String = "moveToLobbyScreen";
		public static const LOG_OUT_CLICK:String = "logOutClick";
		
		private var tlmnIcon:MovieClip;
		private var phomIcon:MovieClip;
		private var maubinhIcon:MovieClip;
		private var xitoIcon:MovieClip;
		private var samIcon:MovieClip;
		private var pokerIcon:MovieClip;
		private var luckyCardIcon:MovieClip;
		private var gameList:Array;
		private var mainData:MainData = MainData.getInstance();
		private var eventDispatcher:EventDispatcher;
		private var gameId:int;
		
		private var selectGameTabEnable:SimpleButton;
		private var rankTabEnable:SimpleButton;
		private var addMoneyTabEnable:SimpleButton;
		private var shopTabEnable:SimpleButton;
		private var inventoryTabEnable:SimpleButton;
		private var eventTabEnable:SimpleButton;
		
		private var selectGameTabDisable:MovieClip;
		private var rankTabDisable:MovieClip;
		private var addMoneyTabDisable:MovieClip;
		private var shopTabDisable:MovieClip;
		private var inventoryTabDisable:MovieClip;
		private var eventTabDisable:MovieClip;
		
		
		
		private var shopLayer:Sprite;
		//private var _shopWindow:Shop_Coffer_Item_Window;
		//private var _shopWindow:Shop_Coffer_Item_Window_New;
		private var _shopWindow:Shop_Coffer_Item_Window_New;
		private var _newsWindow:NewsWindow;
		private var testNew:Boolean = true;//true la test voi design moi
		private var windowLayer:WindowLayer = WindowLayer.getInstance();
		
		private var avatar:Avatar;
		private var giftCodeButton:SimpleButton;
		private var exitButton:SimpleButton;
		private var nextButton:SimpleButton;
		private var backButton:SimpleButton;
		
		private var displayNameTxt:TextField;
		private var levelTxt:TextField;
		private var money1Txt:TextField;
		private var money2Txt:TextField;
		private var gameContainer:ItemContainerYun;
		private var gameContainer2:PanelScrollYun;
		private var giftCodeWindow:GiftCodeWindow;
		private var isRecentlySelectGame:Boolean;
		
		private var isFirst:Boolean = false;
		
		private var noticeText:MovieClip;
		private var arrNotice:Array;
		private var countText:int;
		
		private var noticeTimer:Timer;
		
		private var isChoseLuckyGame:Boolean = false;
		
		public function SelectGameWindowNew() 
		{
			addContent("zSelectGameWindow");
			
			content["levelIcon"].gotoAndStop(1);
			noticeText = content["showNotice"];
			
			content["activeMc"].visible = false;
			content["activeMc"].gotoAndStop(1);
			
			tlmnIcon = content["tlmnIcon"];
			phomIcon = content["phomIcon"];
			maubinhIcon = content["maubinhIcon"];
			xitoIcon = content["xitoIcon"];
			samIcon = content["samIcon"];
			pokerIcon = content["pokerIcon"];
			luckyCardIcon = content["luckyCardIcon"];
			
			tlmnIcon.x = tlmnIcon.y = 0;
			phomIcon.x = phomIcon.y = 0;
			maubinhIcon.x = maubinhIcon.y = 0;
			xitoIcon.x = xitoIcon.y = 0;
			samIcon.x = samIcon.y = 0;
			pokerIcon.x = pokerIcon.y = 0;
			luckyCardIcon.x = luckyCardIcon.y = 0;
			
			pokerIcon.gotoAndStop(2);
			
			tlmnIcon.gotoAndStop(1);
			samIcon.gotoAndStop(1);
			maubinhIcon.gotoAndStop(1);
			phomIcon.gotoAndStop(1);
			luckyCardIcon.gotoAndStop(1);
			xitoIcon.gotoAndStop(1);
			luckyCardIcon.gotoAndStop(1);
			
			gameList = new Array();
			
			gameList.push(xitoIcon);
			gameList.push(maubinhIcon);
			gameList.push(tlmnIcon);
			gameList.push(phomIcon);
			
			gameList.push(samIcon);
			gameList.push(luckyCardIcon);
			gameList.push(pokerIcon);
			
			
			///////tam bo select game, inventory, tien chip levelIcon, level
			//selectGameTabEnable = content["selectGameTabEnable"];
			rankTabEnable = content["rankTabEnable"];
			addMoneyTabEnable = content["addMoneyTabEnable"];
			shopTabEnable = content["shopTabEnable"];
			eventTabEnable = content["eventTabEnable"];
			//inventoryTabEnable = content["inventoryTabEnable"];
			
			//selectGameTabEnable.addEventListener(MouseEvent.CLICK, onTabClick);
			rankTabEnable.addEventListener(MouseEvent.CLICK, onTabClick);
			addMoneyTabEnable.addEventListener(MouseEvent.CLICK, onTabClick);
			shopTabEnable.addEventListener(MouseEvent.CLICK, onTabClick);
			eventTabEnable.addEventListener(MouseEvent.CLICK, onTabClick);
			//inventoryTabEnable.addEventListener(MouseEvent.CLICK, onTabClick);
			
			//selectGameTabDisable = content["selectGameTabDisable"];
			rankTabDisable = content["rankTabDisable"];
			addMoneyTabDisable = content["addMoneyTabDisable"];
			shopTabDisable = content["shopTabDisable"];
			eventTabDisable = content["eventTabDisable"];
			rankTabDisable.mouseEnabled = false;
			addMoneyTabDisable.mouseEnabled = false;
			shopTabDisable.mouseEnabled = false;
			eventTabDisable.mouseEnabled = false;
			
			//inventoryTabDisable = content["inventoryTabDisable"];
			
			rankTabEnable.visible = true;
			addMoneyTabEnable.visible = true;
			shopTabEnable.visible = true;
			eventTabEnable.visible = true;
			
			rankTabDisable.visible = false;
			addMoneyTabDisable.visible = false;
			shopTabDisable.visible = false;
			eventTabDisable.visible = false;
			
			zSelectGameWindow(content).loadingLayer.visible = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			shopLayer = new Sprite();
			content.addChild(shopLayer);
			
			avatar = new Avatar();
			avatar.setForm(Avatar.MY_AVATAR);
			avatar.x = 366;
			avatar.y = 144;
			avatar.buttonMode = true;
			addChild(avatar);
			avatar.addEventListener(MouseEvent.MOUSE_UP, onShowMyItem);
			
			giftCodeButton = content["giftCodeButton"];
			exitButton = content["exitButton"];
			if (mainData.isFacebookVersion)
				exitButton.visible = false;
			nextButton = content["nextBtn"];
			backButton = content["backBtn"];
			nextButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			backButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			displayNameTxt = content["displayNameTxt"];
			//levelTxt = content["levelTxt"];
			levelTxt = content["levelIcon"]["levelTxt"];
			
			money1Txt = content["money1Txt"];
			//money2Txt = content["money2Txt"];
			
			//showTab(1);
			
			checkGameOnOff();
			checkShowBanner();
			
			exitButton.addEventListener(MouseEvent.CLICK, onExitButtonClick);
			giftCodeButton.addEventListener(MouseEvent.CLICK, onGiftCodeButtonClick);
			content["close"].addEventListener(MouseEvent.CLICK, onCloseAll);
			
			content["activeMc"].buttonMode = true;
			content["activeMc"].addEventListener(MouseEvent.CLICK, onShowMyItem);
			
		}
		
		public function checkShowBanner():void 
		{
			var method:String = "POST";
			var url:String;
			var httpRequest:HTTPRequest = new HTTPRequest();
			var obj:Object;
			var basePath:String;
			if (mainData.isTest) 
			{
				basePath= "http://wss.test.azgame.us/";
			}
			else 
			{
				basePath= "http://wss.azgame.us/";
			}
			
			url = basePath + "service02/OnplayConfigExt.asmx/GetConfigValueByKey?config_key=IS_AUTO_POPUP_BANNER_NEWS";
			obj = new Object();
			obj.it_group_id = String(1);
			obj.it_type = String(2);
			httpRequest.sendRequest(method, url, obj, checkBannerSuccess, true);
		}
		
		private function checkBannerSuccess(obj:Object):void 
		{
			if (obj.Data == "TRUE" && mainData.isFirstJoinLobby) 
			{
				showTab(1);
			}
			else 
			{
				if (_shopWindow) 
				{
					_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_SHOP, onChangeShop);
					_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_TAB, onChangeTab);
					_shopWindow.removeAllEvent();
					content["containerShopItem"].removeChild(_shopWindow);
					_shopWindow = null;
				}
				
				
				if (_newsWindow) 
				{
					_newsWindow.removeAllEvent();
					content["containerShopItem"].removeChild(_newsWindow);
					_newsWindow = null;
				}
			}
		}
		
		public function checkGameOnOff():void 
		{
			
			var method:String = "POST";
			var url:String;
			var httpRequest:HTTPRequest = new HTTPRequest();
			var obj:Object;
			var basePath:String;
			if (mainData.isTest) 
			{
				basePath= "http://wss.test.azgame.us/";
			}
			else 
			{
				basePath= "http://wss.azgame.us/";
			}
			
			url = basePath + "service02/OnplayConfigExt.asmx/GetListConfigs?sq_twcf002_ref_id=2&row_start=0&row_end=1000";
			obj = new Object();
			obj.it_group_id = String(1);
			obj.it_type = String(2);
			if (mainData.isOnIos) 
			{
				obj.source_id = 'IOS';
			}
			else if (mainData.isOnAndroid) 
			{
				obj.source_id = 'Android';
			}
			else if (mainData.isWebVersion) 
			{
				obj.source_id = 'Web';
			}
			else if (mainData.isFacebookVersion) 
			{
				obj.source_id = 'Facebook';
			}
			
			httpRequest.sendRequest(method, url, obj, loadMyGameSuccess, true);
		}
		
		private function loadMyGameSuccess(obj:Object):void 
		{
			
			if (obj.TypeMsg == 1) 
			{
				
				tlmnIcon.buttonMode = true;
				samIcon.buttonMode = true;
				phomIcon.buttonMode = true;
				maubinhIcon.buttonMode = true;
				luckyCardIcon.buttonMode = true;
				xitoIcon.buttonMode = false;
				
				tlmnIcon.gotoAndStop(1);
				samIcon.gotoAndStop(1);
				maubinhIcon.gotoAndStop(1);
				phomIcon.gotoAndStop(1);
				luckyCardIcon.gotoAndStop(1);
				xitoIcon.gotoAndStop(2);
				
				xitoIcon.removeEventListener(MouseEvent.MOUSE_UP, onSelectGame);
				tlmnIcon.removeEventListener(MouseEvent.MOUSE_UP, onSelectGame);
				samIcon.removeEventListener(MouseEvent.MOUSE_UP, onSelectGame);
				phomIcon.removeEventListener(MouseEvent.MOUSE_UP, onSelectGame);
				maubinhIcon.removeEventListener(MouseEvent.MOUSE_UP, onSelectGame);
				luckyCardIcon.removeEventListener(MouseEvent.MOUSE_UP, onSelectGame);
				luckyCardIcon.addEventListener(MouseEvent.MOUSE_UP, onSelectGame);
				
				for (var i:int = 0; i < obj.Data.length; i++) 
				{
					var objGame:Object = obj.Data[i];
					showGame(obj.Data[i].key, obj.Data[i].value);
				}
			}
		}
		
		private function showGame(gameName:String, isShow:String):void 
		{
			//windowLayer.openAlertWindow(gameName + isShow.toString());
			switch (gameName) 
			{
				case "AZGB_BINH":
					if (isShow == "TRUE") 
					{
						maubinhIcon.gotoAndStop(1);
						maubinhIcon.buttonMode = true;
						maubinhIcon.addEventListener(MouseEvent.MOUSE_UP, onSelectGame);
					}
					else 
					{
						maubinhIcon.gotoAndStop(2);
						maubinhIcon.buttonMode = false;
						maubinhIcon.removeEventListener(MouseEvent.MOUSE_UP, onSelectGame);
					}
				break;
				case "AZGB_TLMN":
					if (isShow == "TRUE") 
					{
						tlmnIcon.gotoAndStop(1);
						tlmnIcon.buttonMode = true;
						tlmnIcon.addEventListener(MouseEvent.MOUSE_UP, onSelectGame);
					}
					else 
					{
						tlmnIcon.gotoAndStop(2);
						tlmnIcon.buttonMode = false;
						tlmnIcon.removeEventListener(MouseEvent.MOUSE_UP, onSelectGame);
					}
				break;
				case "AZGB_PHOM":
					if (isShow == "TRUE") 
					{
						phomIcon.gotoAndStop(1);
						phomIcon.buttonMode = true;
						phomIcon.addEventListener(MouseEvent.MOUSE_UP, onSelectGame);
					}
					else 
					{
						phomIcon.gotoAndStop(2);
						phomIcon.buttonMode = false;
						phomIcon.removeEventListener(MouseEvent.MOUSE_UP, onSelectGame);
					}
				break;
				case "AZGB_SAM":
					if (isShow == "TRUE") 
					{
						samIcon.gotoAndStop(1);
						samIcon.buttonMode = true;
						samIcon.addEventListener(MouseEvent.MOUSE_UP, onSelectGame);
					}
					else 
					{
						samIcon.gotoAndStop(2);
						samIcon.buttonMode = false;
						samIcon.removeEventListener(MouseEvent.MOUSE_UP, onSelectGame);
					}
				break;
				case "AZGB_XITO":
					if (isShow == "TRUE") 
					{
						xitoIcon.gotoAndStop(1);
						xitoIcon.buttonMode = true;
						xitoIcon.addEventListener(MouseEvent.MOUSE_UP, onSelectGame);
					}
					else 
					{
						xitoIcon.gotoAndStop(2);
						xitoIcon.buttonMode = false;
						xitoIcon.removeEventListener(MouseEvent.MOUSE_UP, onSelectGame);
					}
					
				break;
				case "AZGB_POKER":
					if (isShow == "TRUE") 
					{
						pokerIcon.gotoAndStop(1);
						pokerIcon.buttonMode = true;
						pokerIcon.addEventListener(MouseEvent.MOUSE_UP, onSelectGame);
					}
					else 
					{
						pokerIcon.gotoAndStop(2);
						pokerIcon.buttonMode = false;
						pokerIcon.removeEventListener(MouseEvent.MOUSE_UP, onSelectGame);
					}
					if (mainData.isTest)
					{
						pokerIcon.gotoAndStop(1);
						pokerIcon.buttonMode = true;
						pokerIcon.addEventListener(MouseEvent.MOUSE_UP, onSelectGame);
					}
				break;
				case "AZGB_LBMM":
					if (isShow == "TRUE") 
					{
						luckyCardIcon.gotoAndStop(1);
						luckyCardIcon.buttonMode = true;
						luckyCardIcon.addEventListener(MouseEvent.MOUSE_UP, onSelectGame);
					}
					else 
					{
						luckyCardIcon.gotoAndStop(2);
						luckyCardIcon.buttonMode = false;
						luckyCardIcon.removeEventListener(MouseEvent.MOUSE_UP, onSelectGame);
					}
					
				break;
				default:
			}
		}
		
		private function onCloseAll(e:MouseEvent):void 
		{
			closeAll();
		}
		
		public function closeAll():void 
		{
			rankTabEnable.visible = true;
			addMoneyTabEnable.visible = true;
			shopTabEnable.visible = true;
			eventTabEnable.visible = true;
			
			rankTabDisable.visible = false;
			addMoneyTabDisable.visible = false;
			shopTabDisable.visible = false;
			eventTabDisable.visible = false;
			
			isFirst = false;
			
			if (_shopWindow) 
			{
				_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_SHOP, onChangeShop);
				_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_TAB, onChangeTab);
				_shopWindow.removeAllEvent();
				content["containerShopItem"].removeChild(_shopWindow);
				_shopWindow = null;
			}
			
			if (_newsWindow) 
			{
				_newsWindow.removeAllEvent();
				content["containerShopItem"].removeChild(_newsWindow);
				_newsWindow = null;
			}
		}
		
		private function onClickLucky(e:MouseEvent):void 
		{
			checkEventExist();
		}
		
		private function onShowMyItem(e:MouseEvent):void 
		{
			showTab(5);
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case nextButton:
					gameContainer2.moveToNext();
				break;
				case backButton:
					gameContainer2.moveToPrevivous();
				break;
				
				default:
			}
		}
		
		private function onGiftCodeButtonClick(e:MouseEvent):void 
		{
			if (!giftCodeWindow)
				giftCodeWindow = new GiftCodeWindow();
			
			if (!giftCodeWindow.parent)
			{
				giftCodeWindow.type = GiftCodeWindow.INPUT_CODE_FORM;
				giftCodeWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onCloseGiftCodeWindow);
				windowLayer.openWindow(giftCodeWindow, null, "noEffect", true);
			}
		}
		
		private function onCloseGiftCodeWindow(e:Event):void 
		{
			giftCodeWindow = null;
		}
		
		private function onExitButtonClick(e:MouseEvent):void 
		{
			mainData.isLogOut = true;
			mainData.joinedGame = false;
		}
		
		private function onTabClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case eventTabEnable:
					showTab(1);
				break;
				case rankTabEnable:
					showTab(2);
				break;
				case addMoneyTabEnable:
					/*if (mainData.isFacebookVersion || mainData.isWebVersion) 
					{
						showTab(3);
					}
					else if (mainData.country == "VN") 
					{
						showTab(3);
					}*/
					showTab(3);
				break;
				case shopTabEnable:
					showTab(4);
				break;
				case inventoryTabEnable:
					showTab(5);
				break;
				default:
			}
		}
		
		public function showTab(index:int):void 
		{
			if (gameContainer2)
				//gameContainer2.visible = false;
			//selectGameTabEnable.visible = true;
			rankTabEnable.visible = true;
			addMoneyTabEnable.visible = true;
			shopTabEnable.visible = true;
			eventTabEnable.visible = true;
			//inventoryTabEnable.visible = true;
			
			//selectGameTabDisable.visible = false;
			rankTabDisable.visible = false;
			addMoneyTabDisable.visible = false;
			shopTabDisable.visible = false;
			eventTabDisable.visible = false;
			//inventoryTabDisable.visible = false;
			
			if (_shopWindow) 
			{
				_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_SHOP, onChangeShop);
				_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_TAB, onChangeTab);
				_shopWindow.removeAllEvent();
				content["containerShopItem"].removeChild(_shopWindow);
				_shopWindow = null;
			}
			
			
			if (_newsWindow) 
			{
				_newsWindow.removeAllEvent();
				content["containerShopItem"].removeChild(_newsWindow);
				_newsWindow = null;
			}
			
			switch (index) 
			{
				case 1:
					eventTabEnable.visible = false;
					eventTabDisable.visible = true;
					nextButton.visible = true;
					backButton.visible = true;
					
					_newsWindow = new NewsWindow();
					content["containerShopItem"].addChild(_newsWindow);
					_newsWindow.x = 350;
					_newsWindow.y = -300;
					
					_newsWindow.onClickHotNew(null);
					
				break;
				case 2:
					rankTabEnable.visible = false;
					rankTabDisable.visible = true;
					nextButton.visible = false;
					backButton.visible = false;
					
					if (_shopWindow) 
					{
						_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_SHOP, onChangeShop);
						_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_TAB, onChangeTab);
						
						_shopWindow.removeAllEvent();
						content["containerShopItem"].removeChild(_shopWindow);
						_shopWindow = null;
					}
					_shopWindow = new Shop_Coffer_Item_Window_New();
					content["containerShopItem"].addChild(_shopWindow);
					_shopWindow.x = 350;
					_shopWindow.y = -300;
					_shopWindow.showRank();
					
				break;
				case 3:
					addMoneyTabEnable.visible = false;
					addMoneyTabDisable.visible = true;
					nextButton.visible = false;
					backButton.visible = false;
					
					if (_shopWindow) 
					{
						_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_SHOP, onChangeShop);
						_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_TAB, onChangeTab);
						_shopWindow.removeAllEvent();
						content["containerShopItem"].removeChild(_shopWindow);
						_shopWindow = null;
					}
					_shopWindow = new Shop_Coffer_Item_Window_New();
					content["containerShopItem"].addChild(_shopWindow);
					_shopWindow.x = 350;
					_shopWindow.y = -300;
					_shopWindow.chooseAddMoney();
					
				break;
				case 4:
					shopTabEnable.visible = false;
					shopTabDisable.visible = true;
					nextButton.visible = false;
					backButton.visible = false;
					
					if (_shopWindow) 
					{
						_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_SHOP, onChangeShop);
						_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_TAB, onChangeTab);
						_shopWindow.removeAllEvent();
						content["containerShopItem"].removeChild(_shopWindow);
						_shopWindow = null;
					}
					_shopWindow = new Shop_Coffer_Item_Window_New();
					content["containerShopItem"].addChild(_shopWindow);
					_shopWindow.x = 350;
					_shopWindow.y = -300;
					_shopWindow.onClickShowGold(null);
				break;
				case 5:
					//inventoryTabEnable.visible = false;
					//inventoryTabDisable.visible = true;
					nextButton.visible = false;
					backButton.visible = false;
					
					if (_shopWindow) 
					{
						_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_SHOP, onChangeShop);
						_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_TAB, onChangeTab);
						_shopWindow.removeAllEvent();
						content["containerShopItem"].removeChild(_shopWindow);
						_shopWindow = null;
					}
					_shopWindow = new Shop_Coffer_Item_Window_New();
					content["containerShopItem"].addChild(_shopWindow);
					_shopWindow.x = 300;
					_shopWindow.y = 50;
					_shopWindow.onClickShowMyInfo(null);
					//_shopWindow.onClickShowMyAvatar(null);
					
				break;
				default:
			}
			
			if (_shopWindow) 
			{
				if (!isFirst) 
				{
					TweenMax.to(_shopWindow, .5, { x: -480, y:-300 } );
					isFirst = true;
				}
				else 
				{
					_shopWindow.x = -480;
					_shopWindow.y = -300;
				}
				
				_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_SHOP, onChangeShop);
				_shopWindow.addEventListener(Shop_Coffer_Item_Window_New.CHANGE_SHOP, onChangeShop);
				_shopWindow.removeEventListener(Shop_Coffer_Item_Window_New.CHANGE_TAB, onChangeTab);
				_shopWindow.addEventListener(Shop_Coffer_Item_Window_New.CHANGE_TAB, onChangeTab);
				
			}
			if (_newsWindow) 
			{
				if (!isFirst) 
				{
					TweenMax.to(_newsWindow, .5, { x: -480, y:-300 } );
					isFirst = true;
				}
				else 
				{
					_newsWindow.x = -480;
				}
			}
		}
		
		private function onChangeShop(e:Event):void 
		{
			rankTabEnable.visible = true;
			addMoneyTabEnable.visible = true;
			shopTabEnable.visible = true;
			eventTabEnable.visible = true;
			//inventoryTabEnable.visible = true;
			
			//selectGameTabDisable.visible = false;
			rankTabDisable.visible = false;
			addMoneyTabDisable.visible = false;
			shopTabDisable.visible = false;
			eventTabDisable.visible = false;
		}
		
		private function onChangeTab(e:Event):void 
		{
			showTab(_shopWindow._type + 1);
		}
		
		public function checkReconnect():void
		{
			if (mainData.isReconnectVersion)
			{
				if (mainData.isReconnectPhom)
				{
					gameId = 2;
					mainData.gameName = 'PHỎM';
					mainData.game_id = 'AZGB_PHOM';
					mainData.portNumber = 5301;
					mainData.minBetRate = 10;
					mainData.resetMatchTime = 6.5;
					if (mainData.isTest)
						mainData.portNumber = 3301;
					if (!SoundManager.getInstance().isLoadSoundPhom)
						SoundManager.getInstance().loadSoundPhom();
					mainData.gameType = MainData.PHOM;
					
					MainCommand.getInstance().initVar();
					mainData.lobbyRoomData.invitePlayData = new Object();
					dispatchEvent(new Event(SELECT_GAME));
					SoundManager.getInstance().playBackgroundMusicMauBinh();
					isRecentlySelectGame = false;
				}
				else if (mainData.isReconnectTlmn)
				{
					
				}
			}
		}
		
		private function onAddedToStage(e:Event):void 
		{
			SoundManager.getInstance().stopBackgroundMusicMauBinh();
			mainData.isOnSelectGameWindow = true;
			
			if (mainData.chooseChannelData.myInfo)
			{
				displayNameTxt.text = mainData.chooseChannelData.myInfo.name;
				levelTxt.text = mainData.chooseChannelData.myInfo.level;
				content["levelIcon"].gotoAndStop(Math.ceil(int(mainData.chooseChannelData.myInfo.level) / 10));
				money1Txt.text = PlayingLogic.format(mainData.chooseChannelData.myInfo.money, 1);
				//money2Txt.text = PlayingLogic.format(mainData.chooseChannelData.myInfo.cash, 1);
				avatar.addImg(mainData.chooseChannelData.myInfo.avatar);
			}
			
			mainData.chooseChannelData.addEventListener(ChooseChannelData.UPDATE_MY_INFO, onUpdateMyInfo);
			
			if (!gameContainer)
			{
				/*gameContainer = new ItemContainerYun();
				gameContainer.x = content["container"].x;
				gameContainer.y = content["container"].y;
				addChild(gameContainer);
				gameContainer.setData(content["container"], 8);
				gameContainer.numberForRow = 6;
				gameContainer.numberForColumn = 1;
				gameContainer.itemList = gameList;*/
				
				gameContainer2 = new PanelScrollYun();
				//gameContainer2.horizontalNumber = 20;
				gameContainer2.addScrollRectDistance = 125;
				gameContainer2.headDistance = 0;
				gameContainer2.tailDistance = 1.5;
				gameContainer2.addEventListener(PanelScrollYun.PANEL_SCROLL_MOUSE_UP, onPanelScrollMouseUp);
				gameContainer2.x = content["container"].x;
				gameContainer2.y = content["container"].y;
				gameContainer2.view = content["container"];
				gameContainer2.columnNumber = 6;
				gameContainer2.viewList = gameList;
				content.addChild(gameContainer2);
				var spMask:Sprite = new Sprite();
				spMask.graphics.beginFill(0x123456, 1);
				spMask.graphics.drawRect(0, 0, 819, 121);
				spMask.graphics.endFill();
				addChild(spMask);
				spMask.x = gameContainer2.x;
				spMask.y = gameContainer2.y;
				gameContainer2.mask = spMask;
			}
			content.setChildIndex(content["levelIcon"], content.numChildren - 1);
			if (noticeTimer) 
			{
				noticeTimer.stop();
				noticeTimer.removeEventListener(TimerEvent.TIMER, onTimerGetNotice);
			}
			
			
			mainData.addEventListener(MainData.UPDATE_SYSTEM_NOTICE, onUpdateSystemNotice);
			mainData.addEventListener(MainData.LOGIN_SUCCESS, onLoginSuccess);
			/*noticeTimer = new Timer(30000);
			noticeTimer.addEventListener(TimerEvent.TIMER, onTimerGetNotice);
			noticeTimer.start();*/
			onUpdateSystemNotice(null);
		}
		
		private function onUpdateSystemNotice(e:Event):void 
		{
			noticeText.txt.x = 10;
			noticeText.txt.text = "";
			noticeText.txt.mouseEnabled = false;
			arrNotice = mainData.systemNoticeList;
			countText = 0;
			showText();
		}
		
		private function showText():void 
		{
			noticeText.txt.x = 500;
			if (arrNotice[countText]) 
			{
				noticeText.txt.text = arrNotice[countText].message;
				noticeText.txt.width = noticeText.txt.textWidth + 10;
				
			}
			else 
			{
				countText--;
				if (countText < 0) 
				{
					countText = 0;
					return;
				}
				noticeText.txt.text = arrNotice[countText].message;
				noticeText.txt.width = noticeText.txt.textWidth + 10;
			}
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (stage) 
			{
				noticeText.txt.x-= 2;
				
				
				if (noticeText.txt.x < -noticeText.txt.width) 
				{
					stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					countText++;
					showText();
				}
			}
			
		}
		
		public function onTimerGetNotice(e:TimerEvent):void 
		{
			if (mainData.chooseChannelData.myInfo) 
			{
				var mainCommand:MainCommand = MainCommand.getInstance();
				mainCommand.getInfoCommand.getSystemNoticeInfo();
			}
			
		}
		
		private function onPanelScrollMouseUp(e:Event):void 
		{
			if (Math.abs(gameContainer2.endX - gameContainer2.startX) < 10 && isRecentlySelectGame)
			{
				if (isChoseLuckyGame) 
				{
					isChoseLuckyGame = false;
					isRecentlySelectGame = false;
					
					onClickLucky(null);
					
					return;
				}
				MainCommand.getInstance().initVar();
				mainData.lobbyRoomData.invitePlayData = new Object();
				closeAll();
				dispatchEvent(new Event(SELECT_GAME));
				
				SoundManager.getInstance().playBackgroundMusicMauBinh();
			}
			isRecentlySelectGame = false;
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			if (noticeTimer) 
			{
				noticeTimer.stop();
				noticeTimer.removeEventListener(TimerEvent.TIMER, onTimerGetNotice);
			}
			mainData.removeEventListener(MainData.UPDATE_SYSTEM_NOTICE, onUpdateSystemNotice);
			mainData.removeEventListener(MainData.LOGIN_SUCCESS, onLoginSuccess);
			mainData.isOnSelectGameWindow = false;
			mainData.chooseChannelData.removeEventListener(ChooseChannelData.UPDATE_MY_INFO, onUpdateMyInfo);

			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			noticeText.txt.x = -noticeText.txt.width

		}
		
		private function onLoginSuccess(e:Event):void 
		{
			checkReconnect();
		}
		
		private function onUpdateMyInfo(e:Event):void 
		{
			displayNameTxt.text = mainData.chooseChannelData.myInfo.name;
			levelTxt.text = mainData.chooseChannelData.myInfo.level;
			content["levelIcon"].gotoAndStop(Math.ceil(int(mainData.chooseChannelData.myInfo.level) / 10));
			money1Txt.text = PlayingLogic.format(mainData.chooseChannelData.myInfo.money, 1);
			//money2Txt.text = PlayingLogic.format(mainData.chooseChannelData.myInfo.cash, 1);
			avatar.addImg(mainData.chooseChannelData.myInfo.avatar);
			if (mainData.chooseChannelData.myInfo.is_email_active == 0 || mainData.chooseChannelData.myInfo.is_phone_number_active == 0)
			{
				content["activeMc"].visible = true;
				content["activeMc"].play();
			}
			else
			{
				content["activeMc"].visible = false;
				content["activeMc"].gotoAndStop(1);
			}
		}
		
		private function onSelectGame(e:MouseEvent):void 
		{
			isRecentlySelectGame = true;
			mainData.isFirstJoinLobby = true;
			mainData.maxPlayer = 4;
			switch (e.currentTarget) 
			{
				case luckyCardIcon:
					isChoseLuckyGame = true;
					return;
				break;
				case tlmnIcon:
					gameId = 3;
					mainData.minBetRate = 10;
					mainData.game_id = 'AZGB_TLMN';
					
					mainData.portNumber = 5101;
					
					mainData.gameName = 'Tiến lên';
					mainData.gameType = 'TLMN';
				
					
					GameDataTLMN.getInstance().gameName = "TienLenMN";
					GameDataTLMN.getInstance().gameType = "TienLenMNPlugin";
					GameDataTLMN.getInstance().lobbyName = "TienLenMN";
					GameDataTLMN.getInstance().lobbyPluginName = "LobbyTLMNPlugin";
					GameDataTLMN.getInstance().gameZone = "tlmnZone";
				
					MyDataTLMN.getInstance().isGame = 1;
					if (mainData.isTest)
						mainData.portNumber = 3101;
					if (!SoundManager.getInstance().isLoadSoundTlmn)
						SoundManager.getInstance().addSound();
					mainData.gameType = MainData.TLMN;
				break;
				case samIcon:
					gameId = 4;
					mainData.minBetRate = 10;
					mainData.game_id = 'AZGB_SAM';
					
					mainData.portNumber = 5401;
					
					mainData.gameName = 'Sâm';
					mainData.gameType = 'SAM';
					
					mainData.game_id = 'AZGB_SAM';
					
					GameDataTLMN.getInstance().gameName = "Sam";
					GameDataTLMN.getInstance().gameType = "SamPlugin";
					GameDataTLMN.getInstance().lobbyName = "Sam";
					GameDataTLMN.getInstance().lobbyPluginName = "LobbyPlugin";
					GameDataTLMN.getInstance().gameZone = "SAM";
					
					MyDataTLMN.getInstance().isGame = 2;
					if (mainData.isTest)
						mainData.portNumber = 3401;
					if (!SoundManager.getInstance().isLoadSoundTlmn)
						SoundManager.getInstance().addSound();
					mainData.gameType = MainData.SAM;
				break;
				case phomIcon:
					gameId = 2;
					mainData.gameName = 'PHỎM';
					mainData.game_id = 'AZGB_PHOM';
					mainData.portNumber = 5301;
					mainData.minBetRate = 10;
					mainData.resetMatchTime = 6.5;
					if (mainData.isTest)
						mainData.portNumber = 3301;
					if (!SoundManager.getInstance().isLoadSoundPhom)
						SoundManager.getInstance().loadSoundPhom();
					mainData.gameType = MainData.PHOM;
				break;
				case maubinhIcon:
					gameId = 6;
					mainData.gameName = 'BINH';
					mainData.game_id = 'AZGB_BINH';
					mainData.portNumber = 5201;
					mainData.minBetRate = 10;
					mainData.resetMatchTime = 8;
					if (mainData.isTest)
						mainData.portNumber = 3201;
					if (!SoundManager.getInstance().isLoadSoundMauBinh)
						SoundManager.getInstance().loadSoundMauBinh();
					mainData.gameType = MainData.MAUBINH;
				break;
				case xitoIcon:
					gameId = 5;
					mainData.maxPlayer = 5;
					mainData.gameName = 'Xì tố';
					mainData.game_id = 'AZGB_XITO';
					mainData.portNumber = 5501;
					mainData.minBetRate = 10;
					mainData.resetMatchTime = 6.5;
					if (mainData.isTest)
						mainData.portNumber = 3501;
					if (!SoundManager.getInstance().isLoadSoundXito)
						SoundManager.getInstance().loadSoundXito();
					mainData.gameType = MainData.XITO;
				break;
				case luckyCardIcon:
					return;
				break;
				default:
			}
		}
		
		
		private function checkEventExist():void 
		{
			
			var httpReq:HTTPRequest = new HTTPRequest();
			var method:String = "POST";
			var str:String; 
			if (mainData.isTest) 
			{
				str= "http://wss.test.azgame.us/Service02/OnplayGameEvent.asmx/Azgamebai_GetEventInfo";
			}
			else 
			{
				str= "http://wss.azgame.us/Service02/OnplayGameEvent.asmx/Azgamebai_GetEventInfo";
			}
			
			var obj:Object = new Object();
			obj.sq_id  = 1;
			
			httpReq.sendRequest(method, str, obj, getInfoEvent, true);
		}
				
		private function getInfoEvent(obj:Object):void 
		{
			//if (!mainData.isNotLobby) 
			{
				if (obj.Data) 
				{
					
					mainData.typeOfEvent = obj.Data.status;
					
					if (mainData.typeOfEvent > 0) 
					{
						mainData.isShowMiniGame = true;
					}
					else if (mainData.typeOfEvent == 0) 
					{
						var alertWindow:AlertWindow = new AlertWindow();
						alertWindow.setNotice("Sự kiện đang bảo trì, xin vui lòng quay lại sau!");	
						windowLayer.openWindow(alertWindow);
					}
					
				}
			}
			
			
			
		}
	}

}