package view.myComboBox 
{
	import event.DataFieldMauBinh;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import logic.PlayingLogic;
	import view.BaseView;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class MyComboBox extends BaseView 
	{
		private var downButton:SimpleButton;
		private var currentValueTxt:TextField;
		private var _currentValue:Object;
		private var _currentDescription:String;
		private var _valueArray:Array;
		private var rowContainer:Sprite;
		private var _mainTextFormat:TextFormat;
		private var _rowTextFormat:TextFormat;
		
		public function MyComboBox() 
		{
			addContent("zMyComboBox");
			downButton = content["downButton"];
			downButton.addEventListener(MouseEvent.CLICK, onDownButtonClick);
			currentValueTxt = content["txt"];
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			stage.removeEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		private function onStageClick(e:MouseEvent):void 
		{
			if (e.target == downButton)
				return;
			if (rowContainer)
				rowContainer.visible = false;
		}
		
		private function onDownButtonClick(e:MouseEvent):void 
		{
			if (!rowContainer)
				return;
			rowContainer.visible = !rowContainer.visible;
			//e.stopImmediatePropagation();
		}
		
		public function get currentValue():Object 
		{
			return _currentValue;
		}
		
		public function set currentValue(value:Object):void 
		{
			_currentValue = value;
			currentDescription = value[DataFieldMauBinh.DESCRIPTION];
		}
		
		public function get currentDescription():String 
		{
			return _currentDescription;
		}
		
		public function set currentDescription(value:String):void 
		{
			_currentDescription = value;
			currentValueTxt.text = value;
		}
		
		public function get valueArray():Array 
		{
			return _valueArray;
		}
		
		public function set valueArray(value:Array):void 
		{
			_valueArray = value;
			if (!rowContainer)
			{
				rowContainer = new Sprite();
				rowContainer.y = (new ComboBoxRow()).standardHeight;
				addChild(rowContainer);
			}
			var i:int;
			for (i = rowContainer.numChildren - 1; i >= 0; i--)
			{
				rowContainer.removeChildAt(i);
			}
			for (i = 0; i < value.length; i++) 
			{
				var comboBoxRow:ComboBoxRow = new ComboBoxRow();
				comboBoxRow.value = value[i];
				comboBoxRow.addEventListener(MouseEvent.CLICK, onRowClick);
				comboBoxRow.y = rowContainer.numChildren * comboBoxRow.standardHeight;
				rowContainer.addChild(comboBoxRow);
			}
		}
		
		public function set mainTextFormat(value:TextFormat):void 
		{
			_mainTextFormat = value;
			currentValueTxt.defaultTextFormat = value;
			//currentValueTxt.antiAliasType = AntiAliasType.ADVANCED;
			//currentValueTxt.sharpness = 400;
		}
		
		public function set rowTextFormat(value:TextFormat):void 
		{
			_rowTextFormat = value;
		}
		
		private function onRowClick(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			currentValue = ComboBoxRow(e.currentTarget).value;
			rowContainer.visible = false;
		}
		
	}

}