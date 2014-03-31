package 
{
	import control.MainCommand;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import model.loadingData.LoadingData;
	import model.lobbyRoomData.LobbyRoomData;
	import model.MainData;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author ducBita
	 */
	public class Preloader extends Sprite
	{
		private var loadingBar:Sprite;
		private var _percentNumber:int;
		private var countFirstLoad:int = 0;
		private var loaderList:Array;
		private var countOtherLoad:int = 0;
		private var content:zLoadingScreen;
		private var mainData:MainData = MainData.getInstance();
		
		public var gamepath:String = '../';
		public var basepath:String = '';
		
		public function Preloader() 
		{
			content = new zLoadingScreen();
			addChild(content);
			loadingBar = content.loadingBar;
			
			percentNumber = 0;
			
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			mainData.loadingData.addEventListener(LoadingData.UPDATE_LOADING, onUpdateLoading);
			mainData.lobbyRoomData.addEventListener(LobbyRoomData.UPDATE_ROOM_LIST, onUpdateRoomList);
			mainData.addEventListener(MainData.UPDATE_APP_DOMAIN_DATA, onUpdateAppDomainData);
		}
		
		private function onUpdateAppDomainData(e:Event):void 
		{
			loadingFinished();
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			mainData.loadingData.removeEventListener(LoadingData.UPDATE_LOADING, onUpdateLoading);
			mainData.removeEventListener(MainData.UPDATE_APP_DOMAIN_DATA, onUpdateAppDomainData);
			mainData.lobbyRoomData.removeEventListener(LobbyRoomData.UPDATE_ROOM_LIST, onUpdateRoomList);
		}
		
		private function onUpdateRoomList(e:Event):void 
		{
			mainData.lobbyRoomData.removeEventListener(LobbyRoomData.UPDATE_ROOM_LIST, onUpdateRoomList);
			if (content.parent)
				content.parent.removeChild(content);
		}
		
		private function onUpdateLoading(e:Event):void 
		{
			percentNumber = mainData.loadingData.loadingPercent;
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// TODO update loader
			percentNumber = (e.bytesLoaded / e.bytesTotal) * 100;
			
			if (e.bytesLoaded >= e.bytesTotal)
			{
				loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
				loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
				MainCommand.getInstance().initCommand.loadInit();
			}
		}
		
		private function loadingFinished():void 
		{
			mainData.loadingData.removeEventListener(LoadingData.UPDATE_LOADING, onUpdateLoading);
			
			// TODO hide loader
			
			var mainClass:Class = getDefinitionByName("view.Main") as Class;
			addChild(new mainClass() as DisplayObject);
			percentNumber = 100;
			addChild(content);
		}
		
		public function get percentNumber():int 
		{
			return _percentNumber;
		}
		
		public function set percentNumber(value:int):void 
		{
			if (value > 100)
				value = 100;
			_percentNumber = value;
			loadingBar["child"].x = -208 + 208 * (value / 100);
			trace("aaaaaaaaaa", value);
		}
		
	}
	
}