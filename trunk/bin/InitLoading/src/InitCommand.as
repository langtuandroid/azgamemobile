package  
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import ApplicationDomainData;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import MainData2;
	/**
	 * ...
	 * @author Yun
	 */
	public class InitCommand 
	{
		private var applicationDomainData:ApplicationDomainData;
		private var countLoadSwfFinish:int = 0;
		private var mainData:MainData2 = MainData2.getInstance();
		private var totalByte:Number = 0;
		private var byteLoaded:Number = 0;
		private var loaderList:Array;
		private var phomLoader:Loader;
		
		public function InitCommand() 
		{
			
		}
		
		public function loadInit():void
		{
			var urlRequest:URLRequest = new URLRequest(mainData.path + "InitLoading/init.xml");
			var contentLoader:URLLoader = new URLLoader(urlRequest);
			contentLoader.addEventListener(Event.COMPLETE, onLoadInitComplete);
			contentLoader.load(urlRequest);
		}
		
		private function onLoadInitComplete(e:Event):void 
		{
			mainData.init = new XML(URLLoader(e.currentTarget).data);
			loadLoadingScreen(); // load dữ liệu của màn hình loading về
		}
		
		public function loadLoadingScreen():void
		{
			var tempLoader:Loader;
			tempLoader = new Loader();
			tempLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadLoadingComplete);
			tempLoader.load(new URLRequest("loadingScreen.swf"));
		}
		
		private function onLoadLoadingComplete(e:Event):void 
		{
			mainData.aplicationDomainData.addAppDomain(LoaderInfo(e.currentTarget).applicationDomain); // lưu appDomain sau khi load swf vào
			mainData.loadingData.isLoadLoadingComplete = true;
			loadSwfContent();
		}
		
		public function loadSwfContent():void
		{
			//var swfList:XMLList = mainData.init.swfList.swfFile;
			//totalByte = mainData.init.swfList.@size;
			//loaderList = new Array();
			
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			context.applicationDomain = ApplicationDomain.currentDomain;
			phomLoader = new Loader();
			phomLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadSwfComplete);
			phomLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressLoad);
			phomLoader.load(new URLRequest("SanhBaiMobile.swf"),context);
		}
		
		private function onProgressLoad(e:ProgressEvent):void 
		{
			byteLoaded = LoaderInfo(e.currentTarget).bytesLoaded;
			var totalByte:Number = 7576455;
			mainData.loadingData.loadingPercent = byteLoaded / totalByte * 100;
		}
		
		private function onLoadSwfComplete(e:Event):void 
		{
			mainData.phomLoader = phomLoader;
			//mainData.aplicationDomainData.addAppDomain(LoaderInfo(e.currentTarget).applicationDomain); // lưu appDomain sau khi load swf vào
			//countLoadSwfFinish++;
			//var swfList:XMLList = mainData.init.swfList.swfFile;
		}
	}

}