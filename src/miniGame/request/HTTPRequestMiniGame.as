package miniGame.request 
{
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Yun
	 */
	public class HTTPRequestMiniGame extends EventDispatcher
	{
		public static const LOAD_COMPLETE:String = "loadComplete";
		private var urlRequest:URLRequest;
		private var urlLoader:URLLoader;
		private var completeFunction:Function;
		private var timeOutTimer:Timer;
		private var value:Object;
		private var isDecode:Boolean;
		
		public function HTTPRequestMiniGame() 
		{
			
		}
		
		/**
		 * - hàm request lên server theo giao thức HTTP
		 * @param	method - phương thức gửi đi là POST hay GET
		 * @param	url - link để request lên
		 * @param	value - giá trị gửi kèm
		 * @param	completeFunction - hàm được gọi khi server trả về
		 * @param	timeOut - quá thời gian này thì sẽ ko đợi nữa
		 * @param	dataFormat - dạng dữ liệu của URLLoader
		 */
		public function sendRequest(method:String, url:String, _value:Object, _completeFunction:Function, _isDecode:Boolean = false, timeOut:int = 60, dataFormat:String = "text"):void
		{
			isDecode = _isDecode;
			
			completeFunction = _completeFunction;
			value = _value;
			
			var _postData:Object;
			if(value is String)
			{
				_postData = value;
			}else if(value is URLVariables){
				_postData = value;
			}else{
				var _uv:URLVariables = new URLVariables();
				for(var _name:String in value)
				{
					_uv[_name] = value[_name];
				}
				_postData = _uv;
			}
			
			urlRequest = new URLRequest(url);
			urlRequest.method = method;
			urlRequest.data = _postData;
			
			urlLoader = new URLLoader();
			urlLoader.dataFormat = dataFormat;
			urlLoader.addEventListener(Event.COMPLETE, onRequestComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR , onIOError);
			urlLoader.load(urlRequest);
			
			timeOutTimer = new Timer(timeOut * 1000, 1);
			timeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
			timeOutTimer.start();
		}
		
		private function onTimeOut(e:TimerEvent):void 
		{
			clearAll();
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			completeFunction( { "status":"IO_ERROR", "description":"link bị sai rùi" } );
			trace("IO_ERROR - Link này bị sai rùi");
			clearAll();
		}
		
		private function onRequestComplete(e:Event):void 
		{
			if (isDecode)
			{
				if(e.currentTarget.data != "")
					completeFunction(com.adobe.serialization.json.JSON.decode(e.currentTarget.data));
			}
			else
			{
				completeFunction(e.currentTarget.data);
			}
				
			clearAll();
			urlRequest = null;
			urlLoader = null;
			completeFunction = null;
			timeOutTimer = null;
			value = null;
			dispatchEvent(new Event(LOAD_COMPLETE));
		}
		
		private function clearAll():void
		{
			if (timeOutTimer)
			{
				timeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
				timeOutTimer.stop();
				timeOutTimer = null;
			}
			
			urlLoader.removeEventListener(Event.COMPLETE, onRequestComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR , onIOError);
			dispatchEvent(new Event(LOAD_COMPLETE));
		}
	}

}