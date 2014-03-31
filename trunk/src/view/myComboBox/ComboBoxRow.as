package view.myComboBox 
{
	import event.DataFieldMauBinh;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import logic.PlayingLogic;
	import view.BaseView;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class ComboBoxRow extends BaseView 
	{
		private var overStatus:Sprite;
		private var valueTxt:TextField;
		private var _value:Object;
		private var _description:String;
		public var standardHeight:int = 29;
		
		public function ComboBoxRow() 
		{
			addContent("zComboBoxRow");
			overStatus = content["overStatus"];
			overStatus.visible = false;
			valueTxt = content["txt"];
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			overStatus.visible = false;
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			overStatus.visible = true;
		}
		
		public function get value():Object 
		{
			return _value;
		}
		
		public function set value(value:Object):void 
		{
			_value = value;
			description = value[DataFieldMauBinh.DESCRIPTION];
		}
		
		public function get description():String 
		{
			return _description;
		}
		
		public function set description(value:String):void 
		{
			_description = value;
			valueTxt.text = value;
		}
		
	}

}