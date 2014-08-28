package  
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Yun
	 */
	public class LoadingData extends EventDispatcher
	{
		
		public function LoadingData() 
		{
			
		}
		
		// cập nhật dung lượng đã load xong ở màn hình loading
		public static const UPDATE_LOADING:String = "updateLoading";
		private var _loadingPercent:int = 0;
		
		public function get loadingPercent():int 
		{
			return _loadingPercent;
		}
		
		public function set loadingPercent(value:int):void 
		{
			_loadingPercent = value;
			dispatchEvent(new Event(UPDATE_LOADING));
		}
		
		// loading dữ liệu của màn hình Loading xong
		public static const LOAD_lOADING_COMPLETE:String = "loadLoadingComplete";
		private var _isLoadLoadingComplete:Boolean;
		
		public function get isLoadLoadingComplete():Boolean 
		{
			return _isLoadLoadingComplete;
		}
		
		public function set isLoadLoadingComplete(value:Boolean):void 
		{
			_isLoadLoadingComplete = value;
			if (value)
				dispatchEvent(new Event(LOAD_lOADING_COMPLETE, value));
		}
	}

}