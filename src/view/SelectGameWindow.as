package view 
{
	import control.MainCommand;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import model.MainData;
	import request.MainRequest;
	import view.window.BaseWindow;
	import view.window.shop.Shop_Coffer_Item_Window;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class SelectGameWindow extends BaseWindow 
	{
		public static const SELECT_GAME:String = "selectGame";
		public static const RE_LOGIN_CLICK:String = "reLoginClick";
		public static const MOVE_TO_PLAYING_SCREEN:String = "moveToPlayingScreen";
		public static const MOVE_TO_LOBBY_SCREEN:String = "moveToLobbyScreen";
		public static const LOG_OUT_CLICK:String = "logOutClick";
		
		private var tlmnIcon:Sprite;
		private var phomIcon:Sprite;
		private var maubinhIcon:Sprite;
		private var mainData:MainData = MainData.getInstance();
		private var eventDispatcher:EventDispatcher;
		private var gameId:int;
		
		private var selectGameTabEnable:SimpleButton;
		private var rankTabEnable:SimpleButton;
		private var addMoneyTabEnable:SimpleButton;
		private var shopTabEnable:SimpleButton;
		private var inventoryTabEnable:SimpleButton;
		
		private var selectGameTabDisable:MovieClip;
		private var rankTabDisable:MovieClip;
		private var addMoneyTabDisable:MovieClip;
		private var shopTabDisable:MovieClip;
		private var inventoryTabDisable:MovieClip;
		
		private var shopLayer:Sprite;
		private var _shopWindow:Shop_Coffer_Item_Window;
		
		public function SelectGameWindow() 
		{
			addContent("zSelectGameWindow");
			
			tlmnIcon = content["tlmnIcon"];
			phomIcon = content["phomIcon"];
			maubinhIcon = content["maubinhIcon"];
			
			tlmnIcon.addEventListener(MouseEvent.CLICK, onSelectGame);
			phomIcon.addEventListener(MouseEvent.CLICK, onSelectGame);
			maubinhIcon.addEventListener(MouseEvent.CLICK, onSelectGame);
			
			selectGameTabEnable = content["selectGameTabEnable"];
			rankTabEnable = content["rankTabEnable"];
			addMoneyTabEnable = content["addMoneyTabEnable"];
			shopTabEnable = content["shopTabEnable"];
			inventoryTabEnable = content["inventoryTabEnable"];
			
			selectGameTabEnable.addEventListener(MouseEvent.CLICK, onTabClick);
			rankTabEnable.addEventListener(MouseEvent.CLICK, onTabClick);
			addMoneyTabEnable.addEventListener(MouseEvent.CLICK, onTabClick);
			shopTabEnable.addEventListener(MouseEvent.CLICK, onTabClick);
			inventoryTabEnable.addEventListener(MouseEvent.CLICK, onTabClick);
			
			selectGameTabDisable = content["selectGameTabDisable"];
			rankTabDisable = content["rankTabDisable"];
			addMoneyTabDisable = content["addMoneyTabDisable"];
			shopTabDisable = content["shopTabDisable"];
			inventoryTabDisable = content["inventoryTabDisable"];
			
			showTab(1);
			
			zSelectGameWindow(content).loadingLayer.visible = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			shopLayer = new Sprite();
			content.addChild(shopLayer);
			_shopWindow = new Shop_Coffer_Item_Window();
			shopLayer.addChild(_shopWindow);
			//shopLayer.visible = false;
		}
		
		private function onTabClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case selectGameTabEnable:
					showTab(1);
				break;
				case rankTabEnable:
					showTab(2);
				break;
				case addMoneyTabEnable:
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
		
		private function showTab(index:int):void 
		{
			selectGameTabEnable.visible = true;
			rankTabEnable.visible = true;
			addMoneyTabEnable.visible = true;
			shopTabEnable.visible = true;
			inventoryTabEnable.visible = true;
			
			selectGameTabDisable.visible = false;
			rankTabDisable.visible = false;
			addMoneyTabDisable.visible = false;
			shopTabDisable.visible = false;
			inventoryTabDisable.visible = false;
			
			switch (index) 
			{
				case 1:
					selectGameTabEnable.visible = false;
					selectGameTabDisable.visible = true;
				break;
				case 2:
					rankTabEnable.visible = false;
					rankTabDisable.visible = true;
				break;
				case 3:
					addMoneyTabEnable.visible = false;
					addMoneyTabDisable.visible = true;
				break;
				case 4:
					shopTabEnable.visible = false;
					shopTabDisable.visible = true;
					
					shopLayer.visible = true;
				break;
				case 5:
					inventoryTabEnable.visible = false;
					inventoryTabDisable.visible = true;
				break;
				default:
			}
		}
		
		private function onAddedToStage(e:Event):void 
		{
			mainData.isOnSelectGameWindow = true;
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			mainData.isOnSelectGameWindow = false;
		}
		
		private function onSelectGame(e:MouseEvent):void 
		{
			//WindowLayer.getInstance().openLoadingWindow();
			
			mainData.maxPlayer = 4;
			switch (e.currentTarget) 
			{
				case tlmnIcon:
					gameId = 3;
				break;
				case phomIcon:
					gameId = 2;
				break;
				case maubinhIcon:
					gameId = 6;
					mainData.gameName = 'BINH';
					mainData.portNumber = 5201;
				break;
				default:
			}
			
			mainData.electroInfo = new Object();
			mainData.electroInfo.ip = "123.30.210.55";
			switch (gameId) 
			{
				case 3:
					
				break;
				case 2:
					mainData.gameType = MainData.PHOM;
					mainData.minBetRate = 1;
					mainData.electroInfo.port = 8501;
				break;
				case 6:
					mainData.gameType = MainData.MAUBINH;
					mainData.minBetRate = 10;
					mainData.electroInfo.port = 8101;
				break;
				case 5:
					mainData.gameType = MainData.XITO;
					mainData.minBetRate = 20;
					mainData.electroInfo.port = 8601;
				break;
				default:
			}
			MainCommand.getInstance().initVar();
			dispatchEvent(new Event(SELECT_GAME));
		}
	}

}