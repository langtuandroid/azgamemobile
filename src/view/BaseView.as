package view 
{
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import model.MainData;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class BaseView extends Sprite 
	{
		protected var mainData:MainData = MainData.getInstance();
		
		protected var content:Sprite;
		
		public function BaseView() 
		{
			
		}
		
		protected function addContent(className:String):void
		{
			var tempClass:Class;
			tempClass = Class(getDefinitionByName(className));
			content = Sprite(new tempClass());
			addChild(content);
		}
	}

}