package view.window.news 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ContentNews extends MovieClip 
	{
		private var content:MovieClip;
		public var articleId:String = "";
		public var articleSeo:String = "";
		public function ContentNews() 
		{
			super();
			
			content = new ContentNewsMc();
			addChild(content);
			
			content.titleTxt.mouseEnabled = false;
			content.timeTxt.mouseEnabled = false;
			
			
		}
		
		public function addInfo(newsId:String, title:String, timeNews:String, seo:String):void 
		{
			articleId = newsId;
			articleSeo = seo;
			content.titleTxt.text = title;
			//content.timeTxt.text = timeNews;
			content.timeTxt.text = formatDate(timeNews);
			
			
		}
		
		private function formatDate(str:String):String 
		{
			var string:String = "";
			var pos:int = str.search("T");
			var str1:String = str.substring(pos + 1, str.length) + "'";
			var str2:String = "";
			var str3:String = "";
			var str4:String = "";
			var count:int = 0;
			for (var i:int = 0; i < pos; i++) 
			{
				if (count < 1) 
				{
					str4 += str.charAt(i);
				}
				else if (count == 1) 
				{
					str3 += str.charAt(i);
				}
				else if (count == 2) 
				{
					str2 += str.charAt(i);
				}
				
				if (str.charAt(i) == "-") 
				{
					count++;
				}
			}
			
			string = str1 + " " + str2 + "-" + str3 + str4.replace("-", "");
			return string;
		}
		
	}

}