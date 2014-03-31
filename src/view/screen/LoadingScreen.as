package view.screen 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import model.loadingData.LoadingData;
	import model.MainData;
	/**
	 * ...
	 * @author Yun
	 */
	public class LoadingScreen extends BaseScreen 
	{
		private var loadingBar:Sprite;
		private var description:TextField;
		private var percent:TextField;
		private var mainData:MainData = MainData.getInstance();
		private var childHead:Sprite;
		private var standardWidth:Number;
		private var percent_2:Number = 0;
		
		public function LoadingScreen() 
		{
			super();
			addContent("zLoadingScreen");
			
			loadingBar = content["loadingBar"];
			standardWidth = loadingBar["child"].width;
			description = content["description"];
			percent = content["percent"];
			childHead = loadingBar["child"]["head"];
			
			mainData.loadingData.addEventListener(LoadingData.UPDATE_LOADING, onUpdateLoading);
			
			var tempTimer:Timer = new Timer(100);
			tempTimer.addEventListener(TimerEvent.TIMER, onABC);
			//tempTimer.start();
			var fixPercent:int = Math.round(Number(mainData.init.phomSize) / (Number(mainData.init.phomSize) + Number(mainData.init.swfList.@size)) * 100);
			loadingBar["child"].x = standardWidth * fixPercent / 100 - standardWidth;
			percent.text = String(fixPercent) + "%";
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
			loadingBar["child"].x = standardWidth * percentNumber / 100 - standardWidth;
			percent.text = String(percentNumber) + "%";
		}
		
	}

}