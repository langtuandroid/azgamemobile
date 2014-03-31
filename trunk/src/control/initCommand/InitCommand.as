package control.initCommand 
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import model.applicationDomainData.ApplicationDomainData;
	import model.MainData;
	/**
	 * ...
	 * @author Yun
	 */
	public class InitCommand 
	{
		private var applicationDomainData:ApplicationDomainData;
		private var countLoadSwfFinish:int = 0;
		private var mainData:MainData = MainData.getInstance();
		private var totalByte:Number = 0;
		private var byteLoaded:Number = 0;
		private var loaderList:Array;
		
		public function InitCommand() 
		{
			
		}
		
		public function loadInit():void
		{
			var urlRequest:URLRequest = new URLRequest(mainData.path + "init.xml");
			var contentLoader:URLLoader = new URLLoader(urlRequest);
			contentLoader.addEventListener(Event.COMPLETE, onLoadInitComplete);
			contentLoader.load(urlRequest);
		}
		
		private function onLoadInitComplete(e:Event):void 
		{
			mainData.init = new XML(URLLoader(e.currentTarget).data);
			loadLoadingScreen(); // load dữ liệu của màn hình loading về
		}
		private function loadLoadingScreen():void
		{
			var tempLoader:Loader;
			tempLoader = new Loader();
			tempLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadLoadingComplete);
			tempLoader.load(new URLRequest(mainData.path + mainData.init.swfLoading.@src));
		}
		
		private function onLoadLoadingComplete(e:Event):void 
		{
			mainData.aplicationDomainData.addAppDomain(LoaderInfo(e.currentTarget).applicationDomain); // lưu appDomain sau khi load swf vào
			mainData.loadingData.isLoadLoadingComplete = true;
			loadSwfContent();
		}
		
		private function loadSwfContent():void
		{
			var tempLoader:Loader;
			var swfList:XMLList = mainData.init.swfList.swfFile;
			totalByte = mainData.init.swfList.@size;
			loaderList = new Array();
			for (var i:int = 0; i < swfList.length(); i++) 
			{
				tempLoader = new Loader();
				loaderList.push(tempLoader);
				tempLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadSwfComplete);
				tempLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressLoad);
				tempLoader.load(new URLRequest(mainData.path + swfList[i].@src));
			}
		}
		
		private function onProgressLoad(e:ProgressEvent):void 
		{
			byteLoaded = 0;
			for (var i:int = 0; i < loaderList.length; i++) 
			{
				byteLoaded += Loader(loaderList[i]).contentLoaderInfo.bytesLoaded;
			}
			var swfList:XMLList = mainData.init.swfList.swfFile;
			var fixPercent:int = Math.round(Number(mainData.init.phomSize) / (Number(mainData.init.phomSize) + totalByte) * 100);
			mainData.loadingData.loadingPercent = fixPercent + int(Math.round(byteLoaded / (Number(mainData.init.phomSize) + totalByte) * 100));
		}
		
		private function onLoadSwfComplete(e:Event):void 
		{
			mainData.aplicationDomainData.addAppDomain(LoaderInfo(e.currentTarget).applicationDomain); // lưu appDomain sau khi load swf vào
			countLoadSwfFinish++;
			var swfList:XMLList = mainData.init.swfList.swfFile;
			if (countLoadSwfFinish == swfList.length()) // sau khi load xong tất cả các file swf thì tắt bảng preLoader đi và hiện bảng chọn kênh
				mainData.aplicationDomainData = mainData.aplicationDomainData;
		}
	}

}