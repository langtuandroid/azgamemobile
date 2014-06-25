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
			BoGameBaiMainView;
			content = new zLoadingScreen();
			addChild(content);
			
			percentNumber = 0;
			
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onLoadComplete(e:Event):void 
		{
			loadingFinished();
		}
		
		private function onAddedToStage(e:Event):void 
		{
			
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// TODO update loader
			percentNumber = (e.bytesLoaded / e.bytesTotal) * 100;
		}
		
		private function loadingFinished():void 
		{
			// TODO hide loader
			
			var mainClass:Class = getDefinitionByName("BoGameBaiMainView") as Class;
			addChild(new mainClass() as DisplayObject);
			percentNumber = 100;
			removeChild(content);
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
			content.percent.text = String(value) + "%";
		}
		
	}
	
}