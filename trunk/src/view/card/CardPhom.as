package view.card 
{
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.easing.Quadratic;
	import com.gskinner.motion.GTween;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import model.MainData;
	import view.userInfo.playerInfo.PlayerInfoPhom;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class CardPhom extends Sprite 
	{
		public static const UN_LEAVE_CARD:String = "unLeaveCard"; // bài chưa đánh
		public static const LEAVED_CARD:String = "leavedCard"; // bài đã đánh
		public static const DOWN_CARD:String = "downCard"; // bài đã hạ
		public static const STEAL_CARD:String = "stealCard"; // bài ăn
		
		public static const SMALL_SIZE:String = "smallSize"; // kích thước nhỏ
		public static const NORMAL_SIZE:String = "normalSize"; // kích thước vừa
		
		public static const IS_SELECTED:String = "isSelected"; // vừa được người chơi chọn
		public static const IS_DE_SELECTED:String = "isDeSelected"; // vừa được người chơi bỏ chọn
		
		private const normalSize:Number = 1;
		private const smallSize:Number = 0.616;
		
		public var id:int = 0;
		public var isChoose:Boolean; // Biến xác định xem quân bài này có đang được chọn không
		
		private var content:Sprite;
		private var cardChilds:Array;
		private var size:Number = 1;
		public var isMoving:Boolean; // Biến để xác định xem có đang bị tween di chuyển không
		private var isOpen:Boolean; // Biến để xác định xem quân bài đã được lật chưa
		private var movingTween:GTween; // tween để di chuyển quân bài
		private var openTween:GTween; // tween để lật quân bài
		private const openTime:Number = 0.3; // thời gian thực hiện effect mở
		public var startX:Number; // phục vụ cho việc click bài di chuyển lên xuống
		public var startY:Number; // phục vụ cho việc click bài di chuyển lên xuống
		private var _isStealCard:Boolean; // Cờ đánh dấu con bài này là con bài ăn được
		private var _isMouseInteractive:Boolean;
		private var mainData:MainData = MainData.getInstance();
		private var filterNumber:Number = 0;
		private var isFilterDown:Boolean;
		private var bitmap:Bitmap;
		public var isMine:Boolean;
		public var sendObject:Object;
		private var hilightMc:MovieClip;
		
		public function CardPhom(_size:Number = 1)
		{
			size = _size;
			
			scaleX = scaleY = size;
			
			addContent("zCardPhom");
			
			cardChilds = new Array();
			var i:int;
			for (i = 0; i < content.numChildren; i++) 
			{
				cardChilds.push(content.getChildAt(i));
			}
			for (i = 1; i < cardChilds.length; i++) 
			{
				content.removeChild(cardChilds[i]);
			}
			
			hilightMc = content["hilightMc"];
			addChild(hilightMc);
			hilightMc.visible = false;
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			//cacheAsBitmap = true;
		}
		
		public function showFilter():void
		{
			if (isStealCard)
				return;
			hilightMc.visible = true;
		}
		
		public function hideFilter():void
		{
			if (isStealCard)
				return;
			hilightMc.visible = false;
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
		}
		
		public function moving(finishPoint:Point, movingTime:Number, movingType:String, scaleNumber:Number = 1, rotationNumber:Number = 0,reAddChild:Boolean = true,reAddStartPoint:Boolean = true,reRotate:Boolean = true, alphaNumber:Number = 1, isEaseOut:Boolean = false):void
		{	
			if (movingTween)
				movingTween.end();
				
			if (reAddChild)
				parent.addChild(this);
				
			GTween.defaultDispatchEvents = true;
			var tempPoint:Point = new Point();
			tempPoint = parent.globalToLocal(finishPoint);
			
			if (reAddStartPoint)
			{
				startX = tempPoint.x;
				startY = tempPoint.y;
			}
			
			size = scaleNumber;
			if (int(x) == int(tempPoint.x) && int(y) == int(tempPoint.y)) // Nếu lá bài đang ở đúng điểm đích rồi thì không di chuyển bằng tween nữa
				return;
			isMoving = true;
			//if(reRotate)
				//this.rotation = rotationNumber + 60;
			switch (movingType) 
			{
				case CardManagerPhom.TURN_OVER_STYLE:
					if (isEaseOut)
						movingTween = new GTween(this, movingTime, { x:tempPoint.x, y:tempPoint.y, scaleX:scaleNumber, scaleY:scaleNumber, rotation:rotationNumber, alpha:alphaNumber }, { ease:Back.easeOut } );
					else
						movingTween = new GTween(this, movingTime, { x:tempPoint.x, y:tempPoint.y, scaleX:scaleNumber, scaleY:scaleNumber, rotation:rotationNumber, alpha:alphaNumber } );
					movingTween.addEventListener(Event.COMPLETE, movingComplete);
				break;
				case CardManagerPhom.OPEN_MIDDLE_STYLE:
					if (isEaseOut)
						movingTween = new GTween(this, movingTime, { x:tempPoint.x, y:tempPoint.y, scaleX:scaleNumber, scaleY:scaleNumber, rotation:rotationNumber, alpha:alphaNumber }, { ease:Back.easeOut } );
					else
						movingTween = new GTween(this, movingTime, { x:tempPoint.x, y:tempPoint.y, scaleX:scaleNumber, scaleY:scaleNumber, rotation:rotationNumber, alpha:alphaNumber } );
					effectOpen(movingTime);
					movingTween.addEventListener(Event.COMPLETE, movingComplete);
				break;
				case CardManagerPhom.OPEN_FINISH_STYLE:
					if (isEaseOut)
						movingTween = new GTween(this, movingTime, { x:tempPoint.x, y:tempPoint.y, scaleX:scaleNumber, scaleY:scaleNumber, rotation:rotationNumber, alpha:alphaNumber }, { ease:Back.easeOut } );
					else
						movingTween = new GTween(this, movingTime, { x:tempPoint.x, y:tempPoint.y, scaleX:scaleNumber, scaleY:scaleNumber, rotation:rotationNumber, alpha:alphaNumber } );
					movingTween.addEventListener(Event.COMPLETE, continueEffectOpen);
				break;
				default:
					
				break;
			}
		}
		
		private function movingComplete(e:Event):void 
		{
			isMoving = false;
			if (_isStealCard)
			{
				if (isMine)
				{
					var filterTemp:GlowFilter = new GlowFilter(0xFF0033, 1, 5, 5, 10, 1);
					filters = [filterTemp];
				}
				else
				{
					filterTemp = new GlowFilter(0xFF0033, 1, 3, 3, 10, 1);
					filters = [filterTemp];
				}
			}			
		}
		
		private function continueEffectOpen(e:Event):void 
		{
			effectOpen();
		}
		
		public function setId(_id:int):void 
		{
			if (content.contains(cardChilds[id]) && id != 0)
				content.removeChild(cardChilds[id]);
			id = _id;
			if (!content.contains(cardChilds[0]))
				content.addChild(cardChilds[id]);
		}
		
		private function addContent(className:String):void
		{
			var tempClass:Class;
			tempClass = Class(getDefinitionByName(className));
			content = Sprite(new tempClass());
			addChild(content);
		}
		
		public function destroy():void
		{
			content = null;
			cardChilds = null;
			id = 0;
			size = 0;
			isMoving = false;
			movingTween = null;
			openTween = null;
			
		/*private var size:Number = 1;
		public var isMoving:Boolean; // Biến để xác định xem có đang bị tween di chuyển không
		private var isOpen:Boolean; // Biến để xác định xem quân bài đã được lật chưa
		private var movingTween:GTween; // tween để di chuyển quân bài
		private var openTween:GTween; // tween để lật quân bài
		private var openTime:Number = 0.3; // thời gian thực hiện effect mở
		public var startX:Number; // phục vụ cho việc click bài di chuyển lên xuống
		public var startY:Number; // phục vụ cho việc click bài di chuyển lên xuống
		private var _isStealCard:Boolean; // Cờ đánh dấu con bài này là con bài ăn được
		private var _isMouseInteractive:Boolean;
		private var mainData:MainData = MainData.getInstance();
		private var filterNumber:Number = 0;
		private var isFilterDown:Boolean;*/
			
			if (parent)
				parent.removeChild(this);
		}
		
		public function simpleOpen():void // lật quân bài không có effect
		{
			if (!stage)
				return;
			if (content.contains(cardChilds[0]))
				content.removeChild(cardChilds[0]);
			content.addChild(cardChilds[id]);
			
			/*var bounds:Rectangle = cardChilds[id].getBounds(cardChilds[id]);
			var tempBitmapData:BitmapData = new BitmapData( int( bounds.width + 0.5 ), int( bounds.height + 0.5 ), true, 0 );
			tempBitmapData.draw( cardChilds[id], new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y) );
			bitmap = new Bitmap(tempBitmapData);
			bitmap.smoothing = true;
			bitmap.x = - bitmap.width / 2 + 50;
			bitmap.y = - bitmap.height / 2;
			addChild(bitmap);*/
		}
		
		public function effectOpen(_openTime:Number = 0):void // lật quân bài có effect
		{
			if (!stage)
				return;
			if (!isOpen && id != 0)
			{
				isOpen = true;
				if(_openTime == 0)
					_openTime = openTime;
				if (openTween)
					openTween.end();
				openTween = new GTween(this, _openTime / 2, { scaleX:0 }/*, {ease:Quadratic.easeInOut}*/);
				openTween.addEventListener(Event.COMPLETE, effectOpenChild);
			}
			else
			{
				
			}
		}
		
		private function effectOpenChild(e:Event):void 
		{
			if (!stage)
				return;
			simpleOpen();
			if (openTween)
				openTween.end();
			openTween = new GTween(this, openTime / 2, { scaleX:size }/*, {ease:Quadratic.easeInOut}*/);
			openTween.addEventListener(Event.COMPLETE, effectOpenChildComplete);
		}
		
		private function effectOpenChildComplete(e:Event):void 
		{
			isMoving = false;
		}
		
		public function set isMouseInteractive(value:Boolean):void 
		{
			_isMouseInteractive = value;
			if (value)
			{
				buttonMode = true;
				mouseEnabled = mouseChildren = true;
				addEventListener(MouseEvent.CLICK, onMouseClick);
			}
			else
			{
				buttonMode = false;
				mouseEnabled = mouseChildren = false;
				removeEventListener(MouseEvent.CLICK, onMouseClick);
			}
		}
		
		public function get isStealCard():Boolean 
		{
			return _isStealCard;
		}
		
		public function set isStealCard(value:Boolean):void 
		{
			_isStealCard = value;
			if (value)
			{
				
			}
			else
			{
				filters = null;
			}
		}
		
		private function onMouseClick(e:MouseEvent):void 
		{
			if(isChoose)
				var distance:Number = Math.sqrt(Math.pow(startX - x, 2) + Math.pow(startY - height / 4 - y, 2));
			else
				distance = Math.sqrt(Math.pow(startX - x, 2) + Math.pow(startY - y, 2));
				
			if (distance >= 10)
				return;
				
			if (movingTween)
				movingTween.end();
			var point:Point = new Point();
			if (isChoose)
			{
				isChoose = false;
				point.x = startX
				point.y = startY;
				point = parent.localToGlobal(point);
				moving(point, CardManagerPhom.clickCardTime, CardManagerPhom.TURN_OVER_STYLE, 1, 0, false, false);
				dispatchEvent(new Event(IS_DE_SELECTED));
			}
			else
			{
				isChoose = true;
				point.x = startX
				point.y = startY - height / 4;
				point = parent.localToGlobal(point);
				moving(point, CardManagerPhom.clickCardTime, CardManagerPhom.TURN_OVER_STYLE, 1, 0, false, false);
				dispatchEvent(new Event(IS_SELECTED));
			}
		}
		
		public function moveToStartPoint():void
		{
			if (movingTween)
				movingTween.end();
			y = startY;
			isChoose = false;
		}
		
		public function showTwinkle():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function hideTwinkle():void
		{
			filters = null;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (!stage)
				hideTwinkle();
			if (isFilterDown)
			{
				if(filterNumber >= 1)
					filterNumber -= 1.2;
				else
					isFilterDown = false;
			}
			else
			{
				if(filterNumber <= 7)
					filterNumber += 1.2;
				else
					isFilterDown = true;
			}
			
			var filterTemp:GlowFilter = new GlowFilter(0xFF0000, 1, filterNumber, filterNumber, 5, 1);
			filters = [filterTemp];
		}
	}

}