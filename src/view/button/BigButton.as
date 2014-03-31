package view.button 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import model.MainData;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class BigButton extends Sprite 
	{
		private var enableStatus:MovieClip;
		private var disableStatus:Sprite;
		private var background:MovieClip;
		private var label:Sprite;
		
		public function BigButton() 
		{
			setBackground("zBackgroundButtonForm_2");
			buttonMode = true;
			mouseChildren = false;
		}
		
		public function setBackground(className:String):void
		{
			var tempClass:Class;
			tempClass = Class(getDefinitionByName(className));
			background = MovieClip(new tempClass());
			enableStatus = background["enableStatus"];
			disableStatus = background["disableStatus"];
			disableStatus.visible = false;
			enableStatus.stop();
			
			var tempClass_2:Class = Class(getDefinitionByName("MyriadPro_2"));
			label = Sprite(new tempClass_2());
			
			enable = true;
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addChild(background);
			addChild(label);
		}
		
		public function setLabel(_name:String):void
		{
			label["content"].text = _name;
			label.x = - label.width / 2;
			label.y = - label.height / 2 + 1.5;
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			if (_enable)
				enableStatus.gotoAndStop(2);
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			if (_enable)
				enableStatus.gotoAndStop(1);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			if (_enable)
				enableStatus.gotoAndStop(3);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if (_enable)
				enableStatus.gotoAndStop(2);
		}
		
		private var _enable:Boolean;
		private var mainData:MainData = MainData.getInstance();
		
		public function get enable():Boolean 
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void 
		{
			_enable = value;
			enableStatus.gotoAndStop(1);
			if (_enable)
			{
				disableStatus.visible = false;
				enableStatus.visible = true;
				label.alpha = 1;
			}
			else
			{
				disableStatus.visible = true;
				enableStatus.visible = false;
				label.alpha = 0.5;
			}
		}
	}

}