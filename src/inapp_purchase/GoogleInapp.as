package inapp_purchase 
{
	
	import flash.display.Sprite;
	import com.milkmangames.nativeextensions.android.*;
	import com.milkmangames.nativeextensions.android.events.*;
	import flash.text.TextField;
	import model.MainData;
	import request.HTTPRequest;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author bimkute
	 */
	public class GoogleInapp extends Sprite 
	{
		private var PUBLIC_KEY:String = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnsPMFLDs4BPTTuqWXsbW94PSCxIxrrUTXgnwFpWmhMP+JeIA13THwRgHAYg2LjOrdOfxLqCK9wv/UWVqGlEACgP8pNAojthvk2kk8mzxSYsq8HhLWNEaCdnDpfrLW4/9cKIs2E1BBAw5hLPq0QtdyWCHUoDmtXfuijWQa6ylAjZptzCBO16CxCrEzbZpoef/7cfC7HyJfA6xRdxD4nWcg47dwkgHv+1gpHBK4pBg9z1X/ziNGM9lbxV/LoiF8cN7JTk63VLubCC2HkzVCPsEtg5OBUFogYrmVkbvkoRMPzjzTYwJi1OoYeWRznpiAbZZrDNeRB7+ZxltSDEoMrBjuwIDAQAB';
		
		/** My Purchases */
		private var myPurchases:Vector.<AndroidPurchase>;
		/** Showing what you own */
		private var txtInventory:TextField;
		
		private var isCreated:Boolean = false;
	
		public function GoogleInapp() 
		{
			super();
			
		}
		
		private static var _instance:GoogleInapp;
		
		public static function getInstance():GoogleInapp
		{
			if (!_instance)
				_instance = new GoogleInapp();
			return _instance;
		}
		
		public function init():void 
		{
			
			if (!AndroidIAB.isSupported())
			{
				WindowLayer.getInstance().openAlertWindow('ko support');
				return;
			}
			
			if (!isCreated) 
			{
				isCreated = true;
				
				AndroidIAB.create();
				
				// listeners for billing service startup
				AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.SERVICE_READY,onServiceReady);
				AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.SERVICE_NOT_SUPPORTED, onServiceUnsupported);
				
				// listeners for making a purchase
				AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess);
				AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.PURCHASE_FAILED, onPurchaseFailed);
				
				// listeners for player's owned items
				AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.INVENTORY_LOADED, onInventoryLoaded);
				AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.LOAD_INVENTORY_FAILED, onInventoryFailed);
				
				// listeners for consuming an item
				AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.CONSUME_SUCCEEDED, onConsumed);
				AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.CONSUME_FAILED, onConsumeFailed);
				
				// listeners for item details
				AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.ITEM_DETAILS_LOADED, onItemDetails);
				AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.ITEM_DETAILS_FAILED, onDetailsFailed);
				
				// start the  billing service.  in onServiceReady(), we'll update everything else.
				
				AndroidIAB.androidIAB.startBillingService(PUBLIC_KEY);
			}
			
			
		}
		
		public function removeEvent():void 
		{
			if (AndroidIAB.androidIAB) 
			{
				AndroidIAB.androidIAB.removeEventListener(AndroidBillingEvent.SERVICE_READY,onServiceReady);
				AndroidIAB.androidIAB.removeEventListener(AndroidBillingEvent.SERVICE_NOT_SUPPORTED, onServiceUnsupported);
				
				// listeners for making a purchase
				AndroidIAB.androidIAB.removeEventListener(AndroidBillingEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess);
				AndroidIAB.androidIAB.removeEventListener(AndroidBillingErrorEvent.PURCHASE_FAILED, onPurchaseFailed);
				
				// listeners for player's owned items
				AndroidIAB.androidIAB.removeEventListener(AndroidBillingEvent.INVENTORY_LOADED, onInventoryLoaded);
				AndroidIAB.androidIAB.removeEventListener(AndroidBillingErrorEvent.LOAD_INVENTORY_FAILED, onInventoryFailed);
				
				// listeners for consuming an item
				AndroidIAB.androidIAB.removeEventListener(AndroidBillingEvent.CONSUME_SUCCEEDED, onConsumed);
				AndroidIAB.androidIAB.removeEventListener(AndroidBillingErrorEvent.CONSUME_FAILED, onConsumeFailed);
				
				// listeners for item details
				AndroidIAB.androidIAB.removeEventListener(AndroidBillingEvent.ITEM_DETAILS_LOADED, onItemDetails);
				AndroidIAB.androidIAB.removeEventListener(AndroidBillingErrorEvent.ITEM_DETAILS_FAILED, onDetailsFailed);
			}
			
			
			
		}
		
		/** Dispatched when the billing service is started -now you can make other calls */
		private function onServiceReady(e:AndroidBillingEvent):void
		{
			
			// as soon as it starts, we load up the player's inventory to get a list of what they own
			trace("Service ready. Loading inventory...");		
			AndroidIAB.androidIAB.loadPlayerInventory();
			
			
			
		}
		
		/** Do a test purchase.  This will work without charging you real money */
		public function testPurchase():void
		{
			trace("starting test of a successful item purchase...");
			AndroidIAB.androidIAB.testPurchaseItemSuccess();
			trace("Waiting for test purchase response...");
		}

		/** Simulate trying to buy an invalid item */
		public function testUnavailable():void
		{
			trace("Start purchase unavailable item...");
			AndroidIAB.androidIAB.testPurchaseItemUnavailable();
			trace("Waiting for unavailable response...");
		}
		
		/** Simulate buying an item that will be rejected by Google */
		public function testCancel():void
		{
			trace("Start purchase cancel item...");
			AndroidIAB.androidIAB.testPurchaseItemCancelled();
			trace("Waiting for cancel response...");		
		}
		
		/** Purchase a level pack.  Assumes you've created 'my_levelpack' in the Google Play Control Panel */
		public function purchaseLevelPack(id:String):void
		{
			// for this to work, you must have added 'my_levelpack' in the google play website
			trace("start purchase of managed item 'my_levelpack'...");
			
			// check if we already own this item.  myPurchases was previously loaded by loadPlayerInventory()
			if (myPurchases)
			{
				for each(var purchase:AndroidPurchase in myPurchases)
				{
					if (purchase.itemId == id)
					{
						AndroidIAB.androidIAB.consumeItem(id);
						return;
					}
				}
			}
			
			AndroidIAB.androidIAB.purchaseItem(id);
			trace("Waiting for purchase response...");
		}
		
		/** Purchase a subscription.  Assumes you've created 'my_subscription' in the Google Play Control panel */
		public function purchaseSub():void
		{
			trace("Start test subscription purchase my_subscription...");		
			AndroidIAB.androidIAB.purchaseSubscriptionItem("my_subscription");
			trace("Waiting for subscription purchase response...");
		}
		
		/** Purchase a spell.  Assumes you've created 'my_spell' in the Google Play Control Panel */
		public function purchaseSpell():void
		{
			// for this to work, you must have added 'my_spell' in google play website
			trace("start purchase of item 'my_spell'...");
			AndroidIAB.androidIAB.purchaseItem("my_spell");
			trace("Waiting for purchase response...");
		}

		/** Consumes a spell.  If you 'consume' an item you've owned, its removed from your inventory and you can buy it again! */
		public function consumeSpell():void
		{
			trace("Consuming spell...");
			AndroidIAB.androidIAB.consumeItem("my_spell");
			trace("Waiting for consume response...");
		}

		/** Refresh the player's inventory from the server.  */
		public function reloadInventory():void
		{
			trace("Loading inventory...");
			AndroidIAB.androidIAB.loadPlayerInventory();
			trace("Waiting for inventory...");
		}
		
		/** Get details, such as price, title, description, etc.- for the given tiems */
		public function loadItemDetails(allItems:Vector.<String>):void
		{
			
			trace("Loading item details for "+allItems.join(","));
			AndroidIAB.androidIAB.loadItemDetails(allItems);
			trace("Waiting for item details...");
		}
		
		//
		// Events
		//	

		
		/** This will be triggered if Google Play billing is not supported on the device. */
		private function onServiceUnsupported(e:AndroidBillingEvent):void
		{
			WindowLayer.getInstance().openAlertWindow('Thiết bị này không được hỗ trợ!');
			trace("billing service not supported.");
		}
		
		/** Called after a successful item purchase. */
		private function onPurchaseSuccess(e:AndroidBillingEvent):void
		{
			trace("Successful purchase of '"+e.itemId+"'="+e.purchases[0]);
			
			WindowLayer.getInstance().openAlertWindow("Successful purchase of '" + e.itemId + "'=" + e.purchases[0]);
			sendBuySuccess(e.itemId, e.purchases[0].orderId, e.purchases[0].itemType, e.purchases[0].signature,
							e.purchases[0].purchaseTime, e.purchases[0].purchaseToken)
			// every time a purchase is updated, refresh your inventory from the server.
			reloadInventory();
		}
		
		private function onUpdateUserInfo(obj:Object):void 
		{
			if (obj.TypeMsg == '1') 
			{
				WindowLayer.getInstance().openAlertWindow("Chúc mừng bạn đã mua thành công gói vàng này!");
			}
			else 
			{
				WindowLayer.getInstance().openAlertWindow("Service bị lỗi!");
			}
		}
		
		/** This is called when an error occurs trying to buy something */
		private function onPurchaseFailed(e:AndroidBillingErrorEvent):void
		{
			trace("Failure purchasing '" + e.itemId + "', reason:" + e.text);
			WindowLayer.getInstance().closeAllWindow();
			WindowLayer.getInstance().openAlertWindow("Failure purchasing '" + e.itemId + "', reason:" + e.text);
		}

		/** Callback when the player's inventory has been loaded, after calling loadPlayerInventory() */	
		private function onInventoryLoaded(e:AndroidBillingEvent):void
		{
			
			for each(var purchase:AndroidPurchase in e.purchases)
			{
				trace("You own the item:" + purchase.itemId);
				MainData.getInstance().itemArr.push(purchase.itemId);
				// this is where you'd update the state of your app to reflect ownership of the item
			}

			
			this.myPurchases = e.purchases;
			var allItemIds:Vector.<String>=new <String>["my_spell", "my_subscription", "my_levelpack"];
			
			//updateInventoryMessage();
		}
		
		/** Getting the inventory failed */
		private function onInventoryFailed(e:AndroidBillingErrorEvent):void
		{
			WindowLayer.getInstance().openAlertWindow("Failed loading inventory: "+e.errorID+"/"+e.text);
		}
		
		/** Details about the available items is loaded */
		private function onItemDetails(e:AndroidBillingEvent):void
		{
			trace("details: ["+e.itemDetails.length+"]="+e.itemDetails.join(","));
			var arr:Array = [];
			// the itemDetails property now contains the item info
			for each(var item:AndroidItemDetails in e.itemDetails)
			{
				arr.push([item.itemId, item.itemType, item.price, item.description]);
				trace("item id:"+item.itemId);
				trace("title:"+item.title);
				trace("description:"+item.description);
				trace("price:"+item.price);
			}
			
			
		}
		
		/** An error occurred loading the item details */
		private function onDetailsFailed(e:AndroidBillingErrorEvent):void
		{
			trace("Error loading details: "+e.errorID+"/"+e.text);
		}
		
		/** An Item was successfully consumed */
		private function onConsumed(e:AndroidBillingEvent):void
		{
			WindowLayer.getInstance().openAlertWindow("Did consume item:"+e.itemId + ' = ' + e.purchases[0]);
			// reload inventory now that it has changed
			
			sendBuySuccess(e.itemId, e.purchases[0].orderId, e.purchases[0].itemType, e.purchases[0].signature,
							e.purchases[0].purchaseTime, e.purchases[0].purchaseToken)
			AndroidIAB.androidIAB.loadPlayerInventory();		
		}
		
		private function sendBuySuccess(itemId:String, orderId:String, itemType:String, signature:String,
										purchaseTime:Number, token:String):void 
		{
			var method:String = "POST";
			var url:String;
			var httpRequest:HTTPRequest = new HTTPRequest();
			var obj:Object;
			var basePath:String;
			if (MainData.getInstance().isTest) 
			{
				basePath = "http://wss.test.azgame.us/";
			}
			else 
			{
				basePath = "http://wss.azgame.us/";
			}
			url = basePath + "service02/OnplayShopExt.asmx/GoogleStoreVerifyReceipt";
			
			obj = new Object();
			obj.nick_name = MainData.getInstance().chooseChannelData.myInfo.name;
			obj.access_token = MainData.getInstance().token;
			obj.item_id = itemId;
			obj.order_id = orderId;
			obj.item_type = itemType;
			obj.item_signature = signature;
			obj.item_time_buy = purchaseTime;
			obj.item_token_buy = token;
			
			httpRequest.sendRequest(method, url, obj, onUpdateUserInfo, true);
		}
		
		/** Attempt to consume item has failed */
		private function onConsumeFailed(e:AndroidBillingErrorEvent):void
		{
			WindowLayer.getInstance().openAlertWindow("Consume spell failed:"+e.errorID+"/"+e.text);
		}

		//
		// Impelementation
		// Code beyond this point sets up the ui for the example.
		//
		
		/** Update Inventory Message */
		public function updateInventoryMessage():void
		{
			var allOwnedItemIds:Vector.<String>=new Vector.<String>();
			if (myPurchases==null)
			{
				this.txtInventory.text="Inventory: (not loaded)";
				return;
			}
			
			for each(var purchase:AndroidPurchase in myPurchases)
			{
				
				allOwnedItemIds.push(purchase.itemId);
				loadItemDetails(allOwnedItemIds);
			}
			
			
			this.txtInventory.text="Inventory: {"+allOwnedItemIds.join(", ")+"}";

		}
	}

}