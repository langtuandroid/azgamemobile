package 
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import MainCommand;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import LoadingData;
	import MainData2;
	import LoadingScreen;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class Main2 extends Sprite 
	{
		public static const TUAN_DUNG:String = "tuanDung";
		
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var mainData:MainData2 = MainData2.getInstance();
		private var loadingScreen:LoadingScreen;
		private var phomLoader:Loader;
		private var eventDispatcher:EventDispatcher;
		
		public function Main2():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			try 
			{
				var keyStr:String;
				var valueStr:String;
				var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;
				for (keyStr in paramObj) 
				{
					valueStr = String(paramObj[keyStr]);
					if (keyStr == "gamepath")
						mainData.path = paramObj[keyStr] + '/';
					if (keyStr == "basepath")
						mainData.basepath = paramObj[keyStr];
				}
			} 
			catch (error:Error) {
				
			}
			
			if(!loadingScreen)
				loadingScreen = new LoadingScreen();
			addChild(loadingScreen);
			
			mainData.loadingData.addEventListener(LoadingData.LOAD_lOADING_COMPLETE, onLoadLoadingComplete); // Load dữ liệu màn hình loading xong thì show bảng loading
			mainData.addEventListener(MainData2.LOAD_PHOM_LOADER_COMPLETE, onLoadPhomLoaderComplete); // sau khi appDomainData được cập nhật xong hết thì show bảng bắt đầu
			mainCommand.initCommand.loadSwfContent(); // Load file init.xml
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onLoadPhomLoaderComplete(e:Event):void 
		{
			//addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//mainData.phomLoader.visible = false;
			//mainData.phomLoader.content["gamepath"] = mainData.path;
			//mainData.phomLoader.content["basepath"] = mainData.basepath;
			eventDispatcher = new EventDispatcher();
			//mainData.phomLoader.content["eventDispatcher"] = eventDispatcher;
			
			eventDispatcher.addEventListener(TUAN_DUNG, onTuanDung);
			addChild(mainData.phomLoader);
		}
		
		private function onTuanDung(e:Event):void 
		{
			trace("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
		}
		
		private function onEnterFrame(e:Event):void 
		{
			trace(mainData.phomLoader.content["loadLoadingFinish"]);
			if (mainData.phomLoader.content["loadLoadingFinish"])
			{
				mainData.phomLoader.visible = true;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				removeChild(loadingScreen);
			}
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onLoadLoadingComplete(e:Event):void 
		{
			if(!loadingScreen)
				loadingScreen = new LoadingScreen();
			addChild(loadingScreen);
		}
		
		private function onShowStartScreen(e:Event):void 
		{
			
		}
		
	}
	
}