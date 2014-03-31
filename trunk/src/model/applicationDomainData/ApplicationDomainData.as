package model.applicationDomainData 
{
	import flash.system.ApplicationDomain;
	/**
	 * ...
	 * @author Yun
	 */
	public class ApplicationDomainData 
	{
		private var applicationDomainArray:Array; // Lưu tất cả các domain sau khi load tất cả các file swf
		
		public function ApplicationDomainData() 
		{
			
		}
		
		public function addAppDomain(appDomain:ApplicationDomain):void
		{
			if (!applicationDomainArray)
				applicationDomainArray = new Array();
			applicationDomainArray.push(appDomain);
		}
		
		public function getDefinition(className:String):Object
		{
			for (var i:int = 0; i < applicationDomainArray.length; i++) 
			{
				if (ApplicationDomain(applicationDomainArray[i]).hasDefinition(className))
				{
					return ApplicationDomain(applicationDomainArray[i]).getDefinition(className);
					i = applicationDomainArray.length;
				}
			}
			trace("can not find class name : " + className);
			return { };
		}
	}

}