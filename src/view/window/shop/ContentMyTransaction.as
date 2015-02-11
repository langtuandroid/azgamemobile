package view.window.shop 
{
	import view.Base;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ContentMyTransaction extends Base 
	{
		
		public function ContentMyTransaction() 
		{
			super();
			
			content = new ContentTransationMc();
			addChild(content);
			
			content.codeTxt.mouseEnabled = false;
			content.timeTxt.mouseEnabled = false;
			content.nameTxt.mouseEnabled = false;
			content.receiveNameTxt.mouseEnabled = false;
			content.typeTxt.mouseEnabled = false;
			content.goldTxt.mouseEnabled = false;
		}
		
		public function setInfo(obj:Object):void 
		{
			content.codeTxt.text = obj.order_id;
			var str:String = obj.rgt_dtm;
			var str1:String = str.substr(0, 8);
			var str3:String = "";
			var i:int;
			var count:int = 0;
			for (i = 0; i < str1.length; i++)
			{
				if (i % 2 == 1)
				{
					str3 += str1.charAt(i);
				}
				else
				{
					if (count == 1 || count == 2)
					{
						str3 += "/";
						str3 += str1.charAt(i);
					}
					else
					{
						str3 += str1.charAt(i);
					}
						
					count++;
				}
				
			}
			content.timeTxt.text = str3;
			content.nameTxt.text = obj.nk_nm_buyer;
			content.receiveNameTxt.text = obj.nk_nm_aplt;
			
			str3 = obj.trans_info;
			count = str3.indexOf("=");
			str1 = str3.substr(0, count);
			if (str1.length > 18) 
			{
				content.typeTxt.text = str1.substr(0, 18) + "...";
			}
			else 
			{
				content.typeTxt.text = str1;
			}
			
			
			str1 = str3.substring(count + 1, str3.length);
			str1 = str1.replace(" ", "");
			str1 = str1.replace("chip", "");
			str1 = format(Number(str1)) + " chip";
			if (str1.length > 12) 
			{
				content.goldTxt.text = str1.substr(0, 12) + "...";
			}
			else 
			{
				content.goldTxt.text = str1;
			}
			
		}
		
	}

}