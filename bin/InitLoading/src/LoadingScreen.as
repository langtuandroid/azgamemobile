package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import LoadingData;
	import MainData2;
	/**
	 * ...
	 * @author Yun
	 */
	public class LoadingScreen extends Sprite 
	{
		private var loadingBar:Sprite;
		private var description:TextField;
		private var percent:TextField;
		private var mainData:MainData2 = MainData2.getInstance();
		private var childHead:Sprite;
		private var standardWidth:Number;
		private var percent_2:Number = 0;
		private var content:zLoadingScreen;
		
		public function LoadingScreen() 
		{
			super();
			content = new zLoadingScreen();
			addChild(content);
			
			//loadingBar = content["loadingBar"];
			//standardWidth = loadingBar["child"].width;
			//description = content["description"];
			percent = content["percent"];
			//childHead = loadingBar["child"]["head"];
			
			mainData.loadingData.addEventListener(LoadingData.UPDATE_LOADING, onUpdateLoading);
			
			var tempTimer:Timer = new Timer(100);
			tempTimer.addEventListener(TimerEvent.TIMER, onABC);
			//tempTimer.start();
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			mainData.loadingData.removeEventListener(LoadingData.UPDATE_LOADING, onUpdateLoading);
		}
		
		private function onABC(e:TimerEvent):void 
		{
			percent_2++;
			var percentNumber:int = percent_2;
			if (percentNumber > 100)
				percentNumber = 100;
			loadingBar["child"].x = standardWidth * percentNumber / 100 - standardWidth;
			percent.text = String(percent_2) + "%";
		}
		
		private function onUpdateLoading(e:Event):void 
		{
			var percentNumber:int = mainData.loadingData.loadingPercent;
			if (percentNumber > 100)
				percentNumber = 100;
			//loadingBar["child"].x = standardWidth * percentNumber / 100 - standardWidth;
			percent.text = String(mainData.loadingData.loadingPercent) + "%";
		}
		
	}

}