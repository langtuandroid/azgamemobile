package view.screen.play 
{
	import com.electrotank.electroserver5.api.AddBuddiesRequest;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.GameDataTLMN;
	
	/**
	 * ...
	 * @author Bim kute
	 */
	public class Emoticon extends MovieClip 
	{
		//, "Laught_Game""Whistling_Game", , "Blink_Game"
		private var _container:Sprite;
		public var nameOfEmo:String;
		private var arrChat:Array = ["Sad_Game", "Nausea_Game", "BigLaugh_Game", "Glass_Game", "Heart_Game", 
										"Cry_Game", "Kiss_Game", "Tongue_Game", "Agree_Game", 
										"CrashHeart_Game", "Angry_Game", "Waving_Game", "Sleep_Game"];
		
		public function Emoticon() 
		{
			if (!_container) 
			{
				_container = new Sprite();
				addChild(_container);
				_container.graphics.beginFill(0x000000, .5);
				_container.graphics.drawRect(0, 0, 250, 330);
				_container.graphics.endFill();
			}
			var myClass:Class;
			var mc:MovieClip;
			var loader:Loader;
			var countX:int = 0;
			var countY:int = 0;
			var arr:Array = GameDataTLMN.getInstance().arrEmoticonChat;
			trace(Loader(arr["Cry_Game"][0]).contentLoaderInfo.applicationDomain.getDefinition("Cry_Game"))
			
			trace("====chsat====")
			for (var i:int = 0; i < arrChat.length; i++) 
			{
				var sp:Sprite = new Sprite();
				addChild(sp);
				sp.graphics.lineStyle(2, 0xA6D9F2, 0);
				sp.graphics.beginFill(0xC5E8F7, 0);
				
				loader = arr[arrChat[i]][0];
				
				myClass = loader.contentLoaderInfo.applicationDomain.getDefinition(arrChat[i]) as Class;
				mc = new myClass();
				sp.graphics.drawRect(0, 0, mc.width, mc.height);
				sp.graphics.endFill(); 
				mc.x += mc.width / 2;
				mc.y += mc.height / 2;
				sp.addChild(mc);
				sp.name = GameDataTLMN.getInstance().arrEmoticonChat[arrChat[i]][1];
				_container.addChild(sp);
				sp.scaleX = sp.scaleY = .45;
				sp.x = 60 * countX;
				sp.y = 80 * countY;
				if (countX < 3) 
				{
					countX++;
				}
				else 
				{
					countX = 0;
					countY++;
				}
				
				sp.addEventListener(MouseEvent.CLICK, onClick);
			}
		}
		
		private function onClick(e:MouseEvent):void 
		{
			nameOfEmo = e.currentTarget.name;
			dispatchEvent(new Event("chose emo"));
		}
		
	}

}