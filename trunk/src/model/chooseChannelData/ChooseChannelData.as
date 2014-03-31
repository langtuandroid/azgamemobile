package model.chooseChannelData 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Yun
	 */
	public class ChooseChannelData extends EventDispatcher
	{
		
		public function ChooseChannelData() 
		{
			
		}
		
		// chứa thông tin user
		public static const UPDATE_MY_INFO:String = "updateMyInfo";
		private var _myInfo:MyInfo;
		
		public function get myInfo():MyInfo 
		{
			return _myInfo;
		}
		
		public function set myInfo(value:MyInfo):void 
		{
			_myInfo = value;
			dispatchEvent(new Event(UPDATE_MY_INFO));
		}
		
		// chứa thông tin các kênh
		public static const UPDATE_CHANNEL_INFO:String = "updateChannelInfo";
		private var _channelInfoArray:Array;
		
		public function get channelInfoArray():Array 
		{
			return _channelInfoArray;
		}
		
		public function set channelInfoArray(value:Array):void 
		{
			_channelInfoArray = value;
			dispatchEvent(new Event(UPDATE_CHANNEL_INFO));
		}
	}

}