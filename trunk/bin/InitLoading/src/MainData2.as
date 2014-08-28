package  
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import ApplicationDomainData;
	import LoadingData;
	/**
	 * ...
	 * @author Yun
	 */
	public class MainData2 extends EventDispatcher
	{
		public var stageWidth:Number = 760;
		public var stageHeight:Number = 490;
		
		public function MainData2() 
		{
			
		}
		
		private static var _instance:MainData2;
		public static function getInstance():MainData2
		{
			if (!_instance)
				_instance = new MainData2();
			return _instance;
		}
		
		// chứa nội dung của file init.xml
		private var _init:XML;
		
		public function get init():XML 
		{
			return _init;
		}
		
		public function set init(value:XML):void 
		{
			_init = value;
		}
		
		// Dữ liệu loading ban đầu
		private var _loadingData:LoadingData;
		public function get loadingData():LoadingData 
		{
			if (!_loadingData)
				_loadingData = new LoadingData();
			return _loadingData;
		}
		
		public function set loadingData(value:LoadingData):void 
		{
			_loadingData = value;
		}
		
		// chứa tất cả các class chứa trong các file swf
		public static const UPDATE_APP_DOMAIN_DATA:String = "updateAppDomainData";
		private var _aplicationDomainData:ApplicationDomainData;
		
		public function get aplicationDomainData():ApplicationDomainData 
		{
			if (!_aplicationDomainData)
				_aplicationDomainData = new ApplicationDomainData();
			return _aplicationDomainData;
		}
		
		public function set aplicationDomainData(value:ApplicationDomainData):void 
		{
			_aplicationDomainData = value;
			dispatchEvent(new Event(UPDATE_APP_DOMAIN_DATA));
		}
		
		private var _path:String;
		
		public function get path():String 
		{
			return _path;
		}
		
		public function set path(value:String):void 
		{
			_path = value;
		}
		
		public static const LOAD_PHOM_LOADER_COMPLETE:String = "loadPhomLoaderComplete";
		
		private var _phomLoader:Loader;
		
		public function get phomLoader():Loader 
		{
			return _phomLoader;
		}
		
		public function set phomLoader(value:Loader):void 
		{
			_phomLoader = value;
			dispatchEvent(new Event(LOAD_PHOM_LOADER_COMPLETE));
		}
		
		private var _basepath:String;
		public function get basepath():String 
		{
			return _basepath;
		}
		
		public function set basepath(value:String):void 
		{
			_basepath = value;
		}
	}

}