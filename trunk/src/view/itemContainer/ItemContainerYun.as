package view.itemContainer 
{
	import com.gskinner.motion.easing.Quintic;
	import com.gskinner.motion.GTween;
	import com.urbansquall.metronome.Ticker;
	import com.urbansquall.metronome.TickerEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class ItemContainerYun extends Sprite 
	{
		private var itemContainer:Sprite;
		private var itemContainerWidth:Number;
		
		private var _viewList:Array;
		private var currentView:Sprite;
		private var movingTime:Number = 0.5;
		
		private var startX:Number;
		private var startY:Number;
		
		public var isGroupItem:Boolean;
		public var numberForRow:int;
		public var numberForColumn:int;
		
		public var currentPage:int = 1;
		
		private var actionArray:Array;
		
		private var _itemList:Array;
		private var currentX:int;
		public var currentIndex:int;
		
		
		
		
		
		
		
		
		
		public var isMoving:Boolean; // Biến check xem scroll có đang di chuyển hoặc đang được drag ko
		private var isDraggingScroll:Boolean; // Biến check xem scroll có đang được drag ko
		private var container:Sprite;
		private var containerChildHeight:Number = 0;
		private var containerChildWidth:Number = 0;
		private var distance:Number;
		private var positionArray:Array;
		public var movingRate:Number = 3;
		public var rowArray:Array;
		private var isCheckPosition:Boolean;
		public var movingSpeed:Number;
		private var rub:Number = 0;
		
		private static const VELOCITY_WEIGHTS:Vector.<Number> = new <Number>[2, 1.66, 1.33, 1];
		private static const MAXIMUM_SAVED_VELOCITY_COUNT:int = 4;
		private var previousTime:Number;
		private var previousYPosition:Number;
		private var currentYPosition:Number;
		private var previousXPosition:Number;
		private var currentXPosition:Number;
		private var saveObject:Array;
		private var velocityY:Number;
		private var velocityX:Number;
		private var previousVelocityY:Vector.<Number> = new <Number>[];
		private var previousVelocityX:Vector.<Number> = new <Number>[];
		
		public var classNameForItem:Class;
		
		private var _dataList:Array;
		
		private var standardHeight:Number;
		private var containerStartY:Number;
		private var containerStartX:Number;
		private var topIndex:int = 0;
		private var bottomIndex:int = -100;
		
		private var startPosition:Number = 0; // Biến dùng để kiểm tra xem sau khi mouseDown vào scrollview thì có di chuyển ko
		private var tweenAlphaScroll:GTween;
		
		public var isRecentMoving:Boolean;
		private var timerToSavePosition:Timer;
		private var isStartDrag:Boolean;
		private var distanceFromChildToMouse:Number;
		private var nextDistanceFromChildToMouse:Number;
		private var previousDistanceFromChildToMouse:Number;
		private var xPosition:Number;
		private var startMousePosition:Number;
		public var isResetScroll:Boolean = true;
		public var maxList:int = -1; // Dùng trong trường hợp cần giới hạn số phần tử tối đa của list
		
		public var rowNumber:int = 1; // Số dòng trong trường hợp scroll dọc
		public var columnNumber:int = 1; // số cột trong trường hợp scroll ngang
		public var distanceInRow:Number = 0; // khoảng cách giữa các phần tử trong 1 dòng (scroll dọc)
		public var distanceInColumn:Number = 0; // khoảng cách giữa các phần tử trong 1 cột (scroll ngang)
		
		
		
		
		
		
		
		
		
		public function ItemContainerYun() 
		{
			actionArray = new Array();
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			removeEnterFrame();
		}
		
		public function setData(_itemContainer:Sprite, _movingTime:Number = 0.5, _startX:Number = 0, _startY:Number = 0, _mask:Sprite = null):void
		{
			itemContainer = _itemContainer;
			itemContainerWidth = itemContainer.width;
			if (!_mask)
				scrollRect = new Rectangle(0, 0, itemContainer.width, itemContainer.height);
			else
				mask = _mask;
			movingTime = _movingTime;
			startX = _startX;
			startY = _startY;
			itemContainer.x = 0;
			itemContainer.y = 0;
			addChild(itemContainer);
		}
		
		public function moveToPage(pageIndex:int, isNoTime:Boolean = false):void
		{
			var nextIndex:int;
			var xNumber:Number;
			var xNumber2:Number;
			
			nextIndex = pageIndex - 1;
			if (nextIndex == currentIndex)
				return;
			if (nextIndex > currentIndex)
			{
				xNumber = itemContainerWidth;
				xNumber2 = - itemContainerWidth;
			}
			else
			{
				xNumber = - itemContainerWidth;
				xNumber2 = itemContainerWidth;
			}
			
			viewList[nextIndex].x = xNumber;
			currentView = viewList[nextIndex];
			itemContainer.addChild(viewList[nextIndex]);
				
			if (isNoTime)
			{
				viewList[nextIndex].x = startX;
				viewList[currentIndex].x = xNumber2;
				itemContainer.removeChild(viewList[currentIndex]);
			}
			else
			{
				GTween.defaultDispatchEvents = true;
				viewList[nextIndex].alpha = 0;
				var tempTween1:GTween = new GTween(viewList[nextIndex], movingTime, { x:startX, alpha:1 }, { ease:Quintic.easeInOut } );
				var tempTween2:GTween = new GTween(viewList[currentIndex], movingTime, { x:xNumber2, alpha:0 }, { ease:Quintic.easeInOut } );
				tempTween2.addEventListener(Event.COMPLETE, movingComplete);
			}
			currentIndex = nextIndex;
		}
		
		public function get viewList():Array 
		{
			if (!_viewList)
				_viewList = new Array();
			return _viewList;
		}
		
		public function set viewList(value:Array):void 
		{
			_viewList = value;
			
			while (!viewList[currentIndex])
			{
				currentIndex--;
			}
			
			value[currentIndex].x = startX;
			value[currentIndex].y = startY;
			itemContainer.addChild(value[currentIndex]);
			currentView = value[currentIndex];
		}
		
		public function removeAll(_isResetScroll:Boolean = true):void
		{
			for (var i:int = 0; i < viewList.length; i++) 
			{
				if (viewList[i].parent)
					viewList[i].parent.removeChild(viewList[i]);
			}
			_viewList = null;
			currentView = null;
			if (_isResetScroll)
				currentIndex = 0;
		}
		
		public function get itemList():Array 
		{
			return _itemList;
		}
		
		public function set itemList(value:Array):void 
		{
			_itemList = value;
			
			if (!value)
				return;
			if (value.length == 0)
				return;
			
			if (value[0].hasOwnProperty("standardWidth"))
				var standardWidth:Number = value[0].standardWidth;
			else
				standardWidth = value[0].width;
			if (value[0].hasOwnProperty("standardHeight"))
				var standardHeight:Number = value[0].standardHeight;
			else
				standardHeight = value[0].height;
				
			var numberForPage:Number = numberForColumn * numberForRow;
			var i:int;
			var distanceH:int = (itemContainer.width - standardWidth * numberForRow) / (numberForRow + 1);
			var distanceV:int = (itemContainer.height - standardHeight * numberForColumn) / (numberForColumn + 1);
			var pageList:Array = new Array();
			for (i = 0; i < value.length; i++) 
			{
				value[i].x = (i % numberForRow) * standardWidth + ((i % numberForRow) + 1) * distanceH; 
				value[i].y = (Math.floor((i % numberForPage) / numberForRow)) * standardHeight + (Math.floor((i % numberForPage) / numberForRow) + 1) * distanceV;
				if ((i + numberForPage) / numberForPage == pageList.length + 1)
				{
					var page:Sprite = new Sprite();
					pageList.push(page);
				}
				Sprite(pageList[pageList.length - 1]).addChild(value[i]);
			}
			
			viewList = pageList;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private var _isDragFar:Boolean; // Biến check xem đã kéo đi kéo lại chưa, nếu kéo đi kéo lại thì ko cho click vào Row
		public function get isDragFar():Boolean 
		{
			isDragFar = false;
			//trace("cccccccccccccccccccccccc",stage.mouseX,startMousePosition);
			if (Math.abs(stage.mouseX - startMousePosition) > 10)
				isDragFar = true;
			return _isDragFar;
		}
		
		public function set isDragFar(value:Boolean):void 
		{
			_isDragFar = value;
		}
		
		private var currentDisplay:Sprite;
		private var nextDisplay:Sprite;
		private var previousDisplay:Sprite;
		private var maxSpeed:int;
		public var minSpeed:int;
		private var isRollBack:Boolean;
		private var startMouseX:Number;
		public var mouseDistanceMoving:Number;
		
		private function onMouseDown(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			
			mouseDistanceMoving = 0;
			isMoving = true;
			
			currentDisplay = null;
			nextDisplay = null;
			previousDisplay = null;
			
			if (viewList)
			{
				var previousIndex:int;
				var nextIndex:int;
			
				nextIndex = currentIndex + 1;
				previousIndex = currentIndex - 1;
				
				if (viewList[currentIndex])
				{
					currentX = viewList[currentIndex].x;
					//viewList[currentIndex].startDrag(false, new Rectangle( -1000, 0, 2000, 0));
					currentDisplay = viewList[currentIndex];
				}
				if (viewList[nextIndex])
				{
					nextDisplay = viewList[nextIndex];
					nextDisplay.x = startX + itemContainerWidth;
					itemContainer.addChild(nextDisplay);
					//viewList[nextIndex].startDrag(false, new Rectangle( -1000, 0, 2000, 0));
				}
				if (viewList[previousIndex])
				{
					previousDisplay = viewList[previousIndex]
					previousDisplay.x = startX - itemContainerWidth;
					itemContainer.addChild(previousDisplay);
					//viewList[previousIndex].startDrag(false, new Rectangle( -1000, 0, 2000, 0));
				}
			}
				
			if (timerToSavePosition)
			{
				timerToSavePosition.removeEventListener(TimerEvent.TIMER, onSavePosition);
				timerToSavePosition.stop();
			}
			saveObject = new Array();
			timerToSavePosition = new Timer(25);
			timerToSavePosition.addEventListener(TimerEvent.TIMER, onSavePosition);
			timerToSavePosition.start();
			
			isStartDrag = true;
			distanceFromChildToMouse = currentDisplay.x - globalToLocal(new Point(stage.mouseX, 0)).x;
			if (nextDisplay)
				nextDistanceFromChildToMouse = nextDisplay.x - globalToLocal(new Point(stage.mouseX, 0)).x;
			if (previousDisplay)
				previousDistanceFromChildToMouse = previousDisplay.x - globalToLocal(new Point(stage.mouseX, 0)).x;
			startPosition = currentDisplay.x;
			startMouseX = stage.mouseX;
			startMousePosition = stage.mouseX;
			currentXPosition = previousXPosition = stage.mouseX;
			previousVelocityX.length = 0;
			
			positionArray = new Array();
			isCheckPosition = true;
			movingSpeed = 0;
			
			previousTime = getTimer();
			
			addEnterFrame();
		}
		
		private var ticker:Ticker;
		private function addEnterFrame():void
		{
			//dispatchEvent(new Event(RoomListComponent.START_MOVING, true));
			
			//addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			ticker = new Ticker(33);
			ticker.addEventListener(TickerEvent.TICK, onTick);
			ticker.start();
		}
		
		private function onTick(e:TickerEvent):void 
		{
			calculateMoving();
		}
		
		private function onEnterFrame(e:Event):void 
		{
			calculateMoving();
		}
		
		private function calculateMoving():void
		{
			if (!stage)
				return;
			/*if (isStartDrag)
			{
				if (!isDragFar)
				{
					if (Math.abs(stage.mouseX - startMouseX) > 10)
						isDragFar = true;
				}
			}*/
			if (isCheckPosition) // Vấn đang giữ chuột chưa thả ra
			{
				mouseDistanceMoving += Math.abs(stage.mouseX - startMouseX);
				startMouseX = stage.mouseX;
				if (positionArray.length > 100)
					positionArray = new Array();
				positionArray.push(currentDisplay.x);
				var timeMoving:Number = getTimer() - previousTime;
				velocityX = (currentXPosition - previousXPosition) / timeMoving;
				previousXPosition = currentXPosition;
				
				previousVelocityX.unshift(velocityX);
				if (previousVelocityX.length > MAXIMUM_SAVED_VELOCITY_COUNT)
					previousVelocityX.pop();
					
				var newXPosition:Number = globalToLocal(new Point(stage.mouseX, 0)).x + distanceFromChildToMouse;
				if (newXPosition < startX && !nextDisplay)
				{
					currentDisplay.x = startX;
					if (previousDisplay)
						previousDisplay.x = startX - itemContainerWidth;
				}
				else if (newXPosition > startX && !previousDisplay)
				{
					currentDisplay.x = startX;
					if (nextDisplay)
						nextDisplay.x = startX + itemContainerWidth;
				}
				else
				{
					currentDisplay.x = newXPosition;
					if (nextDisplay)
					{
						newXPosition = globalToLocal(new Point(stage.mouseX, 0)).x + nextDistanceFromChildToMouse;
						nextDisplay.x = newXPosition;
					}
					if (previousDisplay)
					{
						newXPosition = globalToLocal(new Point(stage.mouseX, 0)).x + previousDistanceFromChildToMouse;
						previousDisplay.x = newXPosition;
					}
				}	
			}
			else
			{
				if (viewList.length < 2)
				{
					removeEnterFrame();
					return;
				}
				if (isRollBack)
				{
					if (movingSpeed > 0 && currentDisplay.x + movingSpeed > startX)
					{
						currentDisplay.x = startX;
						if (previousDisplay)
							previousDisplay.x = startX - itemContainerWidth;
						if (nextDisplay)
							nextDisplay.x = startX + itemContainerWidth;
						removeEnterFrame();
						return;
					}
					else if (movingSpeed < 0 && currentDisplay.x + movingSpeed < startX)
					{
						currentDisplay.x = startX;
						if (previousDisplay)
							previousDisplay.x = startX - itemContainerWidth;
						if (nextDisplay)
							nextDisplay.x = startX + itemContainerWidth;
						removeEnterFrame();
						return;
					}
					else
					{
						currentDisplay.x += movingSpeed;
						if (nextDisplay)
							nextDisplay.x += movingSpeed;
						if (previousDisplay)
							previousDisplay.x += movingSpeed;
					}
				}
				else
				{
					if (currentDisplay.x + movingSpeed < startX && !nextDisplay)
					{
						currentDisplay.x = startX;
						previousDisplay.x = startX - itemContainerWidth;
						removeEnterFrame();
					}
					else if (currentDisplay.x + movingSpeed > startX && !previousDisplay)
					{
						currentDisplay.x = startX;
						nextDisplay.x = startX + itemContainerWidth;
						removeEnterFrame();
					}
					else if (currentDisplay.x + movingSpeed < startX - itemContainerWidth)
					{
						currentDisplay.x = startX - itemContainerWidth;
						if (nextDisplay)
							nextDisplay.x = startX;
						removeEnterFrame();
						resetView(1);
					}
					else if (currentDisplay.x + movingSpeed > startX + itemContainerWidth)
					{
						currentDisplay.x = startX + itemContainerWidth;
						if (previousDisplay)
							previousDisplay.x = startX;
						removeEnterFrame();
						resetView(-1);
					}
					else
					{
						currentDisplay.x += movingSpeed;
						if (nextDisplay)
							nextDisplay.x += movingSpeed;
						if (previousDisplay)
							previousDisplay.x += movingSpeed;
					}
				}
			}
		}
		
		private function resetView(changeIndex:int):void 
		{
			currentIndex += changeIndex;
			if (changeIndex == 1)
			{
				if (previousDisplay)
				{
					if (previousDisplay.parent)
						previousDisplay.parent.removeChild(previousDisplay);
				}
			}
			else if (changeIndex == -1)
			{
				if (nextDisplay)
				{
					if (nextDisplay.parent)
						nextDisplay.parent.removeChild(nextDisplay);
				}
			}
			if (currentDisplay)
			{
				if (currentDisplay.parent)
					currentDisplay.parent.removeChild(currentDisplay);
			}
		}
		
		private function removeEnterFrame():void
		{
			dispatchEvent(new Event(RoomListComponent.STOP_MOVING, true));
			
			//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			isMoving = false;
			isRecentMoving = false;
			isRollBack = false;
			
			ticker.removeEventListener(TickerEvent.TICK, onTick);
			ticker.stop();
		}
		
		private function onSavePosition(e:TimerEvent):void 
		{
			if (!stage)
				return;
			var object:Object = new Object();
			object["currentXPosition"] = stage.mouseX;
			object["time"] = getTimer();
			saveObject.push(object);
		}
		
		private function onStageMouseUp(e:MouseEvent):void 
		{	
			if (!stage)
				return;
			//trace("onStageMouseUp", stage.mouseX);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			
			isStartDrag = false;
			if (timerToSavePosition)
			{
				timerToSavePosition.removeEventListener(TimerEvent.TIMER, onSavePosition);
				timerToSavePosition.stop();
			}
			
			var movingTime:Number;
			if (saveObject.length >= 3)
			{
				movingTime = (getTimer() - saveObject[saveObject.length - 3]["time"]) / 1000;
				movingSpeed = ((stage.mouseX - saveObject[saveObject.length - 3]["currentXPosition"]) / movingTime) / 30;
				checkMoving();
			}
			else
			{
				movingTime = (getTimer() - previousTime) / 1000;
				movingSpeed = ((stage.mouseX - currentXPosition) / movingTime) / 30;
				
				checkMoving();
			}
			
			if (movingSpeed < 0)
				rub = -stage.stageHeight / 1000;
			else
				rub = stage.stageHeight / 1000;
					
			isCheckPosition = false;
			
			if (movingSpeed > minSpeed && !isRecentMoving)
			{
				
			}
			else
			{
				//e.stopImmediatePropagation();
				//isRecentMoving = true;
			}
		}
		
		public function getMovingSpeed():Number
		{
			if (saveObject.length >= 3)
			{
				movingTime = (getTimer() - saveObject[saveObject.length - 3]["time"]) / 1000;
				movingSpeed = ((stage.mouseX - saveObject[saveObject.length - 3]["currentXPosition"]) / movingTime) / 30;
			}
			else
			{
				movingTime = (getTimer() - previousTime) / 1000;
				movingSpeed = ((stage.mouseX - currentXPosition) / movingTime) / 30;
			}
			return Math.abs(movingSpeed);
		}
		
		private function checkMoving():void 
		{
			maxSpeed = itemContainerWidth / 15;
			minSpeed = itemContainerWidth / 15;
			
			var rate:Number = (itemContainerWidth - Math.abs(currentDisplay.x - startX)) / itemContainerWidth;
			//maxSpeed = maxSpeed * rate;
			rate = Math.abs(currentDisplay.x - startX) / (itemContainerWidth * 0.3);
			minSpeed = minSpeed * rate;
			
			if (Math.abs(movingSpeed) <= 10)
			{
				if (Math.abs(currentDisplay.x - startX) > itemContainerWidth * 0.3)
				{
					if (currentDisplay.x - startX < 0)
						movingSpeed = maxSpeed * -1;
					else
						movingSpeed = maxSpeed;
				}
				else
				{
					if (currentDisplay.x < startX)
						movingSpeed = minSpeed;
					else
						movingSpeed = minSpeed * -1;
					isRollBack = true;
				}
			}
			else
			{
				if (movingSpeed < 0)
					movingSpeed = maxSpeed * -1;
				else
					movingSpeed = maxSpeed;
			}
		}
		
		public function moveToNext(isNoTime:Boolean = false):void
		{
			if (!isNoTime)
				actionArray.push(1);
			else
				moving(true, isNoTime);
			if (actionArray.length == 1)
				moving(true, isNoTime);
		}
		
		public function moveToPrevivous(isNoTime:Boolean = false):void
		{
			if (!isNoTime)
				actionArray.push( -1);
			else
				moving(true, isNoTime);
			if (actionArray.length == 1)
				moving(false, isNoTime);
		}
		
		private function moving(isNext:Boolean, isNoTime:Boolean = false):void
		{
			var nextIndex:int = currentIndex;
			var previousIndex:int;
			var xNumber:Number;
			var xNumber2:Number;
			
			if (isNext)
			{
				if (currentIndex == viewList.length - 1)
					nextIndex = 0;
				else
					nextIndex = currentIndex + 1;
				xNumber = startX + itemContainerWidth;
				xNumber2 = startX - itemContainerWidth;
			}
			else
			{
				if (currentIndex == 0)
					nextIndex = viewList.length - 1;
				else
					nextIndex = currentIndex - 1;
				xNumber = startX - itemContainerWidth;
				xNumber2 = startX + itemContainerWidth;
			}
			
			viewList[nextIndex].x = xNumber;
			currentView = viewList[nextIndex];
			itemContainer.addChild(viewList[nextIndex]);
				
			if (isNoTime)
			{
				viewList[nextIndex].x = startX;
				viewList[currentIndex].x = xNumber2;
				itemContainer.removeChild(viewList[currentIndex]);
			}
			else
			{
				GTween.defaultDispatchEvents = true;
				viewList[nextIndex].alpha = 0;
				var tempTween1:GTween = new GTween(viewList[nextIndex], movingTime, { x:startX, alpha:1 }, { ease:Quintic.easeInOut } );
				var tempTween2:GTween = new GTween(viewList[currentIndex], movingTime, { x:xNumber2, alpha:0 }, { ease:Quintic.easeInOut } );
				tempTween2.addEventListener(Event.COMPLETE, movingComplete);
			}
			currentIndex = nextIndex;
		}
		
		private function movingComplete(e:Event):void 
		{
			for (var i:int = 0; i < viewList.length; i++) 
			{
				if (currentView != viewList[i] && Sprite(viewList[i]).parent == itemContainer)
					itemContainer.removeChild(viewList[i]);
			}
			actionArray.splice(0, 1);
			if (actionArray.length > 0)
			{
				if (actionArray[0] == -1)
					moving(false);
				else
					moving(true);
			}
		}
	}

}