package view 
{
	import flash.text.TextField;
	import logic.PlayingLogic;
	import logic.XitoLogic;
	import logic.XitoLogic;
	/**
	 * ...
	 * @author ...
	 */
	public class ChipContainer extends BaseView 
	{
		private var chipArray:Array;
		private var _value:Number = 0;
		
		public function ChipContainer(type:int = 1) 
		{
			if (type == 1)
				addContent("zChipContainer");
			else
				addContent("zChipContainer2");
			
			content["position1"].visible = false;
			content["position2"].visible = false;
			content["position3"].visible = false;
			content["position4"].visible = false;
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			_value = value;
			
			if (chipArray)
			{
				for (var i:int = 0; i < chipArray.length; i++) 
				{
					for (var j:int = 0; j < chipArray[i].length; j++) 
					{
						if (chipArray[i][j].parent)
							chipArray[i][j].parent.removeChild(chipArray[i][j]);
					}
				}
			}
			
			chipArray = XitoLogic.convertMoneyToChip(value);
			for (i = 0; i < chipArray.length; i++) 
			{
				switch (i) 
				{
					case 0:
						var tempX:int = content["position1"].x;
						var tempY:int = content["position1"].y;
					break;
					case 1:
						tempX = content["position2"].x;
						tempY = content["position2"].y;
					break;
					case 2:
						tempX = content["position3"].x;
						tempY = content["position3"].y;
					break;
					case 3:
						tempX = content["position4"].x;
						tempY = content["position4"].y;
					break;
					default:
				}
				for (j = 0; j < chipArray[i].length; j++) 
				{
					chipArray[i][j].x = tempX;
					chipArray[i][j].y = tempY - j * 3;
					addChild(chipArray[i][j]);
				}
			}
			if (chipArray[2])
			{
				for (j = 0; j < chipArray[0].length; j++) 
				{
					addChild(chipArray[0][j]);
				}
				for (j = 0; j < chipArray[1].length; j++) 
				{
					addChild(chipArray[1][j]);
				}
			}
			if (chipArray[3])
			{
				for (j = 0; j < chipArray[3].length; j++) 
				{
					addChild(chipArray[3][j]);
				}
			}
		}
	}

}