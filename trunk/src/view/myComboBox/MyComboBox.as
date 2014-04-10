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
	import view.ScrollView.ScrollViewYun;
	
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
		private var scrollView:ScrollViewYun;
		private var isRecentClickRow:Boolean;
		
		public function MyComboBox() 
		{
			addContent("zMyComboBox");
			downButton = content["downButton"];
			downButton.addEventListener(MouseEvent.CLICK, onDownButtonClick);
			currentValueTxt = content["txt"];
			
			if (!rowContainer)
			{
				rowContainer = content["rowContainer"];
				//rowContainer.width = (new ComboBoxRow()).width;
				//rowContainer.height = (new ComboBoxRow()).standardHeight * 4;
				//rowContainer.y = (new ComboBoxRow()).standardHeight;
				//addChild(rowContainer);
				
				scrollView = new ScrollViewYun();
				scrollView.visible = false;
				scrollView.setData(rowContainer);
				addChild(scrollView);
			}
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageClick);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageClick);
		}
		
		private function onStageClick(e:MouseEvent):void 
		{
			if (e.target == downButton)
			{
				isRecentClickRow = false;
				return;
			}
			if (isRecentClickRow)
			{
				isRecentClickRow = false;
				return;
			}
			isRecentClickRow = false;
			if (scrollView)
				scrollView.visible = false;
		}
		
		private function onDownButtonClick(e:MouseEvent):void 
		{
			if (!rowContainer)
				return;
			scrollView.visible = !scrollView.visible;
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
			scrollView.visible = false;
			var i:int;
			//for (i = rowContainer.numChildren - 1; i >= 0; i--)
			//{
				//rowContainer.removeChildAt(i);
			//}
			scrollView.removeAll();
			for (i = 0; i < value.length; i++) 
			{
				var comboBoxRow:ComboBoxRow = new ComboBoxRow();
				comboBoxRow.value = value[i];
				comboBoxRow.addEventListener(MouseEvent.MOUSE_UP, onRowClick);
				//comboBoxRow.y = rowContainer.numChildren * comboBoxRow.standardHeight;
				//rowContainer.addChild(comboBoxRow);
				scrollView.addRow(comboBoxRow);
			}
			scrollView.updateScroll();
			scrollView.recheckTopAndBottom();
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
			isRecentClickRow = true;
			if (scrollView.isRecentMoving)
				return;
			currentValue = ComboBoxRow(e.currentTarget).value;
			scrollView.visible = false;
		}
		
	}

}