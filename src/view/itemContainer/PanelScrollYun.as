/** 
* Very simple demo of panel flick-scrolling. It loads in an XML file
* containing the file names for 5 panel jpg files and then arranges them 
* side-by-side in a Sprite (_container) and makes it scrollable horizontally.
* Feel free to add more panels in the XML, change the _panelBounds position/size, 
* add a preloader, error handling, etc. the goal was to keep this simple. 
* 
* Get more code at http://www.greensock.com
**/
package  view.itemContainer 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	public class PanelScrollYun extends Sprite {
		public static const PANEL_SCROLL_MOUSE_UP:String = "panelScrollMouseUp";
		private var _panelBounds:Rectangle;// = new Rectangle(0, 0, 400, 225);
		private var _container:Sprite;
		private var _currentPanelIndex:int = 0;
		private var _panelCount:int;
		private var _x1:Number;
		private var _x2:Number;
		private var _t1:uint;
		private var _t2:uint;
		public var view:Sprite = new Sprite();
		public var columnNumber:int = 3;
		public var rowNumber:int = 1;
		private var _viewList:Array;
		public var startX:Number;
		public var endX:Number;
		public var isMoving:Boolean;

		public function PanelScrollYun() {
			
			//var xmlLoader:XMLLoader = new XMLLoader("assets/panels.xml", {onComplete:_xmlCompleteHandler});
			//xmlLoader.load();
			
			/*var arr:Array = [0x123456, 0xFF0000, 0x80FFFF, 0xFF80FF, 0xC0C0C0];
			var arrMc:Array = [];
			var recWidth:int = 400;
			var recHeight:int = 225;
			
			for (var i:int = 0; i < arr.length; i++) 
			{
				var mc:MovieClip = new MovieClip();
				mc.graphics.beginFill(arr[i], 1);
				mc.graphics.drawRect(0, 0, recWidth, recHeight);
				mc.graphics.endFill();
				arrMc.push(mc);
			}*/
			
			//var rec:Rectangle = new Rectangle(0, 0, recWidth, recHeight);
			//
			//
			//addContent(arrMc, rec);
			
		}
		
		public function removeAll(isResetScroll:Boolean = true):void
		{
			if (isResetScroll)
				_currentPanelIndex = 0;
			if (_container)
			{
				if (_container.parent)
					_container.parent.removeChild(_container);
			}
		}
		
		/**
		 * 
		 * @param	arr: array movieclip
		 * @param	rec: rectange panel bound
		 */
		public function addContent(arr:Array, rec:Rectangle):void 
		{
			scrollRect = new Rectangle(0, 0, rec.width, rec.height);
			_panelBounds = rec;
			_panelCount = arr.length;
			_container = new Sprite();
			_container.x = _panelBounds.x;
			_container.y = _panelBounds.y;
			addChildAt(_container, 0);
			_container.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownHandler, false, 0, true);
			//addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownHandler, false, 0, true);
			
			trace(arr.length)
			for (var i:int = 0; i < arr.length; i++) 
			{
				_container.addChild(arr[i]);
				arr[i].x = i * rec.width;
			}
			
			if (_currentPanelIndex > _panelCount - 1)
				_currentPanelIndex = _panelCount - 1;
			if (_currentPanelIndex != 0)
				_container.x = _currentPanelIndex * -_panelBounds.width + _panelBounds.x;
		}
		
		public function moveToNext():void
		{
			if (_currentPanelIndex < _panelCount - 1) 
			{
				_currentPanelIndex++;
			}
			TweenLite.to(_container, 0.7, { x:_currentPanelIndex * -_panelBounds.width + _panelBounds.x, ease:Strong.easeOut } );
		}
		
		public function moveToPrevivous():void
		{
			if (_currentPanelIndex > 0) 
				_currentPanelIndex--;
			TweenLite.to(_container, 0.7, { x:_currentPanelIndex * -_panelBounds.width + _panelBounds.x, ease:Strong.easeOut } );
		}
		
		/*private function _xmlCompleteHandler(event:LoaderEvent):void {
			var panels:XMLList = event.target.content.panel;
			_panelCount = panels.length();
			var queue:LoaderMax = new LoaderMax();
			for (var i:int = 0; i < _panelCount; i++) {
				queue.append( new ImageLoader("assets/" + panels[i].@file, {x:i * _panelBounds.width, width:_panelBounds.width, height:_panelBounds.height, container:_container}) );
			}
			//feel free to add a PROGRESS event listener to the LoaderMax instance to show a loading progress bar. 
			queue.load();
		}*/
		
		private function _mouseDownHandler(event:MouseEvent):void {
			startX = stage.mouseX;
			TweenLite.killTweensOf(_container);
			_x1 = _x2 = this.mouseX;
			_t1 = _t2 = getTimer();
			_container.startDrag(false, new Rectangle(_panelBounds.x - 9999, _panelBounds.y, 9999999, 0));
			this.stage.addEventListener(MouseEvent.MOUSE_UP, _mouseUpHandler, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, _enterFrameHandler, false, 0, true);
		}
		
		private function _enterFrameHandler(event:Event):void {
			_x2 = _x1;
			_t2 = _t1;
			_x1 = this.mouseX;
			_t1 = getTimer();
		}
		
		private function _mouseUpHandler(event:MouseEvent):void {
			_container.stopDrag();
			endX = stage.mouseX;
			this.removeEventListener(Event.ENTER_FRAME, _enterFrameHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, _mouseUpHandler);
			dispatchEvent(new Event(PANEL_SCROLL_MOUSE_UP));
			var elapsedTime:Number = (getTimer() - _t2) / 1000;
			var xVelocity:Number = (this.mouseX - _x2) / elapsedTime;
			//we make sure that the velocity is at least 20 pixels per second in either direction in order to advance. Otherwise, look at the position of the _container and if it's more than halfway into the next/previous panel, tween there.
			if (_currentPanelIndex > 0 && (xVelocity > 20 || _container.x > (_currentPanelIndex - 0.5) * -_panelBounds.width + _panelBounds.x)) {
				_currentPanelIndex--;
			} else if (_currentPanelIndex < _panelCount - 1 && (xVelocity < -20 || _container.x < (_currentPanelIndex + 0.5) * -_panelBounds.width + _panelBounds.x)) {
				_currentPanelIndex++;
			}
			TweenLite.to(_container, 0.7, { x:_currentPanelIndex * -_panelBounds.width + _panelBounds.x, ease:Strong.easeOut } );
		}
		
		public function get viewList():Array 
		{
			return _viewList;
		}
		
		public function set viewList(value:Array):void 
		{
			_viewList = value;
			
			var tempArray:Array = new Array();
			//rowNumber = Math.ceil(viewList.length / columnNumber);
			var horizontalDistance:Number = (view.width - (viewList[0].width * columnNumber)) / (columnNumber - 1);
			if (rowNumber - 1 > 0)
			{
				if (viewList[0]["standardHeight"])
					var verticalDistance:Number  = (view.height - (viewList[0]["standardHeight"] * rowNumber)) / (rowNumber - 1);
				else
					verticalDistance  = (view.height - (viewList[0].height * rowNumber)) / (rowNumber - 1);
			}
			else
				verticalDistance = 0;
			for (var i:int = 0; i < viewList.length; i++) 
			{
				viewList[i].x = (i % columnNumber) * (viewList[0].width + horizontalDistance);
				var tempIndex:int = (i % (rowNumber * columnNumber)) / columnNumber;
				viewList[i].y = Math.floor(tempIndex) * (viewList[0].height + verticalDistance);
				var pageIndex:int = Math.floor((i / (columnNumber * rowNumber)));
				if (tempArray[pageIndex])
				{
					Sprite(tempArray[pageIndex]).addChild(viewList[i]);
				}
				else
				{
					tempArray[pageIndex] = new Sprite();
					Sprite(tempArray[pageIndex]).graphics.beginFill(0x0000FF, 0);
					Sprite(tempArray[pageIndex]).graphics.drawRect(0,0,view.width,view.height);
					Sprite(tempArray[pageIndex]).graphics.endFill();
					Sprite(tempArray[pageIndex]).addChild(viewList[i])
				}
			}
			
			var rect:Rectangle = new Rectangle(0, 0, view.width, view.height);
			//addChild(view);
			addContent(tempArray, rect);
		}

	}
	
}
