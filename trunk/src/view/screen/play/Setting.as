package view.screen.play 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.GameDataTLMN;
	import view.Base;
	
	import sound.SoundManager;
	
	/**
	 * ...
	 * @author Bim kute
	 */
	public class Setting extends Base 
	{
		
		public function Setting() 
		{
			createShadow();
			content = new MySetting();
			addChild(content);
			
			content.x = (1024 - content.width) / 2;
			content.y = (600 - content.height) / 2;
			
			content.music.chooseMusic.visible = false;
			content.sound.chooseSound.visible = false;
			
			content.music.musicTxt.mouseEnabled = false;
			content.sound.soundTxt.mouseEnabled = false;
			
			if (GameDataTLMN.getInstance().playGameBackGroud) 
			{
				content.music.musicTxt.text = "Tắt nhạc nền";
			}
			else 
			{
				content.music.musicTxt.text = "Bật nhạc nền";
			}
			content.sound.soundTxt.text = "Tắt âm thanh";
			
			content.music.buttonMode = true;
			content.sound.buttonMode = true;
			content.exit.buttonMode = true;
			
			content.music.addEventListener(MouseEvent.ROLL_OVER, onOverMusic);
			content.sound.addEventListener(MouseEvent.ROLL_OVER, onOverSound);
			
			content.music.addEventListener(MouseEvent.ROLL_OUT, onOutMusic);
			content.sound.addEventListener(MouseEvent.ROLL_OUT, onOutrSound);
			
			content.music.addEventListener(MouseEvent.CLICK, onClickMusic);
			content.sound.addEventListener(MouseEvent.CLICK, onClickSound);
			content.exit.addEventListener(MouseEvent.CLICK, onClickExit);
		}
		
		private function onClickExit(e:MouseEvent):void 
		{
			dispatchEvent(new Event("exit"));
		}
		
		private function onClickMusic(e:MouseEvent):void 
		{
			if (GameDataTLMN.getInstance().playGameBackGroud) 
			{
				GameDataTLMN.getInstance().playGameBackGroud = false;
				content.music.musicTxt.text = "Bật nhạc nền";
				musicOff();
			}
			else 
			{
				GameDataTLMN.getInstance().playGameBackGroud = true;
				content.music.musicTxt.text = "Tắt nhạc nền";
				musicOn();
			}
			
		}
		
		private function musicOff():void 
		{
			
			SoundManager.getInstance().stopSound(GameDataTLMN.getInstance().typeSound);
		}
		
		private function musicOn():void 
		{
			var random:int = int(Math.random() * 2);
			if (random == 1) 
			{
				if (GameDataTLMN.getInstance().playGameBackGroud) 
				{
					SoundManager.getInstance().playSound("background", 1000);
					GameDataTLMN.getInstance().typeSound = "background";
				}
				else 
				{
					SoundManager.getInstance().stopSound("background");
				}
			}
			else 
			{
				if (GameDataTLMN.getInstance().playGameBackGroud) 
				{
					SoundManager.getInstance().playSound("background2", 1000);
					GameDataTLMN.getInstance().typeSound = "background2";
				}
				else 
				{
					SoundManager.getInstance().stopSound("background2");
				}
			}
		}
		
		private function onClickSound(e:MouseEvent):void 
		{
			if (GameDataTLMN.getInstance().playSound) 
			{
				GameDataTLMN.getInstance().playSound = false;
				content.sound.soundTxt.text = "Bật âm thanh";
			}
			else 
			{
				GameDataTLMN.getInstance().playSound = true;
				content.sound.soundTxt.text = "Tắt âm thanh";
			}
		}
		
		private function onOutrSound(e:MouseEvent):void 
		{
			content.music.chooseMusic.visible = false;
			content.sound.chooseSound.visible = false;
		}
		
		private function onOutMusic(e:MouseEvent):void 
		{
			content.music.chooseMusic.visible = false;
			content.sound.chooseSound.visible = false;
		}
		
		private function onOverSound(e:MouseEvent):void 
		{
			content.music.chooseMusic.visible = false;
			content.sound.chooseSound.visible = true;
		}
		
		private function onOverMusic(e:MouseEvent):void 
		{
			content.music.chooseMusic.visible = true;
			content.sound.chooseSound.visible = false;
		}
		
	}

}