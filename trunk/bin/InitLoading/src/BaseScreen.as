package  
{
	import flash.display.Sprite;
	import MainData2;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class BaseScreen extends Sprite 
	{
		private var mainData:MainData2 = MainData2.getInstance();
		protected var content:Sprite;
		
		public function BaseScreen() 
		{
			
		}
		
		protected function addContent(className:String):void
		{
			var tempClass:Class;
			tempClass = Class(mainData.aplicationDomainData.getDefinition(className));
			content = Sprite(new tempClass());
			addChild(content);
		}
	}

}