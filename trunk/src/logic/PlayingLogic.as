package logic 
{
	/**
	 * ...
	 * @author Yun
	 */
	public class PlayingLogic 
	{
		
		public function PlayingLogic() 
		{
			
		}
		
		public static function format(number:Number, precision:int, decimalDelimiter:String = ",", commaDelimiter:String = ".", prefix:String = "", suffix:String = ""):String
		{
			if (number == 0)
				return '0';
			
			var decimalMultiplier:int = Math.pow(10, precision);
			var str:String = Math.round(number * decimalMultiplier).toString();
			
			var leftSide:String = str.substr(0, -precision);
			var rightSide:String = str.substr(-precision);
			
			var leftSideNew:String = "";
				for (var i:int = 0;i < leftSide.length;i++)
				{
					if (i > 0 && (i % 3 == 0 ))
					{
						leftSideNew = commaDelimiter + leftSideNew;
					}
						 
					leftSideNew = leftSide.substr(-i - 1, 1) + leftSideNew;
				} 
				   
			return prefix + leftSideNew /*+ decimalDelimiter + rightSide + suffix*/;
		}
	}

}