package request 
{
	import flash.events.Event;
	import flash.net.URLRequestMethod;
	/**
	 * ...
	 * @author Yun
	 */
	public class MainRequest 
	{
		private var httpRequest:HTTPRequest;
		
		public function MainRequest() 
		{
			
		}
		
		/**
		 * - Hàm để gửi request lên server thương phương thức post
		 * @param	url - link request
		 * @param	value - object gửi kèm theo
		 * @param	completeFuction - hàm được gọi sau khi server trả về
		 */
		public function sendRequest_Post(url:String, value:Object, completeFuction:Function, isDecode:Boolean = false):void
		{
			httpRequest = new HTTPRequest();
			httpRequest.sendRequest(URLRequestMethod.POST, url, value, completeFuction,isDecode);
			httpRequest.addEventListener(HTTPRequest.LOAD_COMPLETE, onLoadComplete);
		}
		
		public function sendRequest_Get(url:String, value:Object, completeFuction:Function, isDecode:Boolean = false):void
		{
			httpRequest = new HTTPRequest();
			httpRequest.sendRequest(URLRequestMethod.GET, url, value, completeFuction,isDecode);
			httpRequest.addEventListener(HTTPRequest.LOAD_COMPLETE, onLoadComplete);
		}
		
		private function onLoadComplete(e:Event):void 
		{
			httpRequest = null;
		}
		
	}

}