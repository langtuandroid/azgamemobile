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
	import flash.utils.getTimer;
	import model.GameDataTLMN;
	
	import view.screen.play.PlayerInfoTLMN;
	import com.greensock.TweenMax;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class CardTlmn extends Sprite 
	{
		
		public static const IS_SELECTED:String = "isSelected"; // vừa được người chơi chọn
		public static const IS_DE_SELECTED:String = "isDeSelected"; // vừa được người chơi bỏ chọn
		
		private const normalSize:Number = 0.9;
		private const smallSize:Number = 0.616;
		
		public var id:int = 0;
		public var pos:int = 0;
		public var isChoose:Boolean; // Biến xác định xem quân bài này có đang được chọn không
		public var isMouseDown:Boolean = false; // Biến xác định xem quân bài này da duoc nghe mousedown truoc chua
		//public var isDoubleClick:Boolean = false;//biến để ko bị click 2 lần liên tiếp khi đang tween
		
		private var content:MovieClip;
		public var cardChilds:Array;
		
		public var startX:Number; // phục vụ cho việc click bài di chuyển lên xuống
		public var startY:Number; // phục vụ cho việc click bài di chuyển lên xuống
		private var _isStealCard:Boolean; // Cờ đánh dấu con bài này là con bài ăn được
		
		private var mainData:GameDataTLMN = GameDataTLMN.getInstance();
		
		public var cardBorder:Sprite;
		
		public var _posCardY:Number;
		public var _posCardX:Number;
		
		private var _posLastMouseX:Number;
		private var _posNewMouseX:Number;
		
		
		public function CardTlmn(cardName:int)
		{
			
			content = new MyCard();
			addChild(content);
			
			cardBorder = content["cardBorder"];
			cardBorder.visible = false;
			
			cardChilds = new Array();
			var i:int;
			for (i = 0; i < content.numChildren - 1; i++) 
			{
				cardChilds.push(content.getChildAt(i));
			}
			for (i = 1; i < cardChilds.length; i++) 
			{
				content.removeChild(cardChilds[i]);
			}
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			content.addChild(cardChilds[cardName]);
			//cacheAsBitmap = true;
			//_posCardY = this.y;
			
			id = cardName;
			//addEventListener(MouseEvent.CLICK, onClickCard);
			//addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
		}
		
		public function setId(_id:int):void 
		{
			if (content.contains(cardChilds[id]) && id != 0)
				content.removeChild(cardChilds[id]);
			id = _id;
			if (!content.contains(cardChilds[0]))
			{
				content.addChild(cardChilds[id]);
				content.addChild(cardBorder);
			}
		}
		
		private function addContent(str:String, nameSwf:String):void
		{
			
		}
		
		public function destroy():void
		{
			content = null;
			cardChilds = null;
			id = 0;
			
			if (parent)
				parent.removeChild(this);
		}
		
	}

}