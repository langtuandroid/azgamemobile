package view.window.windowLayer 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import model.MainData;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.LoadingWindow;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class WindowLayer extends Sprite 
	{
		private var background:Sprite;
		private var windowParent:Sprite;
		private var mainData:MainData = MainData.getInstance();
		public var isNoCloseAll:Boolean;
		
		public function WindowLayer() 
		{
			
		}
		
		private static var _instance:WindowLayer;
		public static function getInstance():WindowLayer
		{
			if (!_instance)
				_instance = new WindowLayer();
			return _instance;
		}
		
		public function openWindow(window:BaseWindow, _parent:Sprite = null, effectType:String = "middleEffect", isNoBackground:Boolean = false):void
		{
			if (!_parent)
				windowParent = this;
			else
				windowParent = _parent;
			
			if (windowParent != this)
			{
				window.background = new Sprite();
				var rect:Shape = new Shape();
				rect.graphics.lineStyle(1,0x000000,0.7);
				rect.graphics.beginFill(0x000000,0.7);
				rect.graphics.drawRect(0, 0, mainData.stageWidth, mainData.stageHeight);
				rect.graphics.endFill();
				window.background.addChild(rect);
				windowParent.addChild(window.background);
			}
			else
			{	
				if (!isNoBackground)
				{
					window.background = new Sprite();
					rect = new Shape();
					rect.graphics.lineStyle(1,0x000000,0.7);
					rect.graphics.beginFill(0x000000,0.7);
					rect.graphics.drawRect(0, 0, mainData.stageWidth, mainData.stageHeight);
					rect.graphics.endFill();
					window.background.addChild(rect);
					windowParent.addChild(window.background);
				}
			}
			
			window.x = Math.round(window.x);
			window.y = Math.round(window.y);
			windowParent.addChild(window);
			window.open(effectType);
			window.addEventListener(BaseWindow.CLOSE_COMPLETE, onCloseWindow);
		}
		
		public function closeAllWindow():void
		{
			if (!stage)
				return;
			for (var i:int = 0; i < numChildren; i++) 
			{
				if (getChildAt(i) is BaseWindow)
					BaseWindow(getChildAt(i)).close(BaseWindow.MIDDLE_EFFECT);
			}
		}
		
		public function openLoadingWindow():void
		{
			var loadingWindow:LoadingWindow = new LoadingWindow();
			openWindow(loadingWindow);
			loadingWindow.startCloseTimer();
		}
		
		public function openAlertWindow(alertSentence:String):void
		{
			var alertWindow:AlertWindow = new AlertWindow();
			alertWindow.setNotice(alertSentence);
			openWindow(alertWindow);
		}
		
		private function onCloseWindow(e:Event):void 
		{
			for (var i:int = 0; i < numChildren; i++) 
			{
				if (getChildAt(i) is BaseWindow)
					return;
			}
			
			if (background)
			{
				if (contains(background))
					removeChild(background);
			}
		}
	}

}