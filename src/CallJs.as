package 
{
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author bimkute
	 */
	public class CallJs 
	{
		
		public function CallJs() 
		{
			
		}
		private static var _instance:CallJs;
		public static function getInstance():CallJs
		{
			if (!_instance)
				_instance = new CallJs();
			return _instance;
		}
		
		public function hideLoading():void
		{
			ExternalInterface.call('closeLoadingGame');
		}
		
		public function updateMoney():void 
		{
			ExternalInterface.call('updateMoney');
		}
		
		public function FlashCallWeb():void 
		{
			ExternalInterface.call('FlashCallWeb');
		}
	}

}