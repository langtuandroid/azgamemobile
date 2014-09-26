package inapp_purchase
{
	import com.adobe.ane.productStore.Product;
	import com.adobe.ane.productStore.ProductEvent;
	import com.adobe.ane.productStore.ProductStore;
	import com.adobe.ane.productStore.Transaction;
	import com.adobe.ane.productStore.TransactionEvent;
	import control.MainCommand;
	import model.MainData;
	import com.sociodox.utils.Base64;
	import view.window.windowLayer.WindowLayer;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class IAPManager
	{
		private static var _instance:IAPManager;
		public static function getInstance():IAPManager {
			if (!_instance) _instance = new IAPManager();
			return _instance;
		}
		
		private var productStore:ProductStore;
		private var identifier:String;
		
		public function IAPManager()
		{
			if (_instance) throw new Error("IAP Singleton Exeption");
			
			productStore = new ProductStore();
			productStore.addEventListener(ProductEvent.PRODUCT_DETAILS_SUCCESS, onGetProductDetailsSucces);
			productStore.addEventListener(ProductEvent.PRODUCT_DETAILS_FAIL, onGetProductDetailsFail);
			
			productStore.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_SUCCESS, onPurchaseTransactionSuccess);			
		}
		
		public function purchaseItem(pid:String):void {
			var vec:Vector.<String> = new Vector.<String>();
			vec.push(pid);
			
			productStore.requestProductsDetails(vec);
		}
		
		protected function onGetProductDetailsSucces(e:ProductEvent):void
		{
			var p:Product;
			for each (p in e.products) {
				productStore.makePurchaseTransaction(p.identifier);
			}
		}
		
		protected function onGetProductDetailsFail(e:ProductEvent):void
		{
			
		}
		
		protected function onPurchaseTransactionSuccess(e:TransactionEvent):void
		{
			var t:Transaction;
			for each (t in e.transactions) {
				identifier = t.identifier;
				var receipt:String = Base64.encodeString(t.receipt);
				sendTransactionSuccess(receipt);
			}
		}
		
		protected function sendTransactionSuccess(receipt:String):void
		{
			if (MainData.getInstance().isOnIphone)
				var serviceLink:String = "http://apps.ingen-studios.com/SKService/SlotKingService.svc/inAppPurchaseIphone/";
			else if (MainData.getInstance().isOnIpad)
				serviceLink = "http://apps.ingen-studios.com/SKService/SlotKingService.svc/inAppPurchaseIpad/";
			serviceLink += MainData.getInstance().myInfo.uId;
			
			var vars:URLVariables = new URLVariables();
			vars['transactionReceipt'] = receipt;			
			
			var urlRequest:URLRequest = new URLRequest(serviceLink);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = vars;
			
			var urlLoader:URLLoader = new URLLoader();			
			urlLoader.addEventListener(Event.COMPLETE, onTransactionSuccessResponse);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			urlLoader.load(urlRequest);
		}
		
		protected function onIOError(e:IOErrorEvent):void
		{
			var urlLoader:URLLoader = e.target as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onTransactionSuccessResponse);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		private function onTransactionSuccessResponse(e:Event):void
		{
			var urlLoader:URLLoader = URLLoader(e.currentTarget);
			urlLoader.removeEventListener(Event.COMPLETE, onTransactionSuccessResponse);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			var responese:String = String(urlLoader.data);
			if (responese == 'success')
			{
				MainCommand.getInstance().clientToServerCommand.refreshProfile();
				productStore.finishTransaction(identifier);
				WindowLayer.getInstance().openAlertWindow("Buy chips success !!");
			}
		}
	}
}