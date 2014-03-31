package view.button 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import model.MainData;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class MyButton extends Sprite 
	{
		public var content:Sprite;
		private var background:MovieClip;
		private var label:TextField;
		private var mainData:MainData = MainData.getInstance();
		
		public function MyButton() 
		{
			setBackground("zBackgroundButtonForm_1");
			buttonMode = true;
			mouseChildren = false;
		}
		
		public function setBackground(className:String):void
		{
			var tempClass:Class;
			tempClass = Class(getDefinitionByName(className));
			background = MovieClip(new tempClass());
			background.stop();
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addChild(background);
			
			if(!label)
				label = new TextField();
			label.defaultTextFormat = new TextFormat("Tahoma", 11, 0x000000, true);
			//var tempFilters:DropShadowFilter = new DropShadowFilter(2, 45, 0x000000, 0.5, 3, 3, 1.5,BitmapFilterQuality.HIGH);
			//label.filters = [tempFilters];
			label.autoSize = TextFieldAutoSize.CENTER;
			label.selectable = false;
			addChild(label);
		}
		
		public function addContent(className:String):void
		{
			// Nếu addcontent khác thì bỏ background đi
			removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			mouseChildren = true;
			if (contains(background))
			{
				removeChild(background);
				removeChild(label);
			}
			
			var tempClass:Class;
			tempClass = Class(getDefinitionByName(className));
			content = Sprite(new tempClass());
			addChild(content);
		}
		
		public function setLabel(_name:String):void
		{
			label.text = _name;
			label.x = - label.width / 2;
			label.y = - label.height / 2;
		}
		
		public function setWidth(_width:Number):void
		{
			background.width = _width;
		}
		
		public function setHeight(_height:Number):void
		{
			background.height = _height;
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			background.gotoAndStop(2);
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			background.gotoAndStop(1);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			background.gotoAndStop(3);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			background.gotoAndStop(2);
		}
	}

}