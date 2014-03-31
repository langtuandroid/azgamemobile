package sound 
{
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author ZhaoYun
	 */
	public class SoundManager extends EventDispatcher
	{
		private var soundDictionary:Dictionary;
		private var soundChannelDictionary:Dictionary;
		private var musicChannelDictionary:Dictionary;
		private var soundTransform:SoundTransform;
		private var musicTransform:SoundTransform;
		private var _isSoundOn:Boolean = true;
		private var _isMusicOn:Boolean = true;
		private var saveMusicVolume:Number;
		private var saveSoundVolume:Number;
		
		public function SoundManager() 
		{
			soundDictionary = new Dictionary();
			soundChannelDictionary = new Dictionary();
			musicChannelDictionary = new Dictionary();
			saveMusicVolume = 0.5;
			saveSoundVolume = 1;
			soundTransform = new SoundTransform(saveSoundVolume);
			musicTransform = new SoundTransform(saveMusicVolume);
		}
		
		private static var instance:SoundManager;
		
		public static function getInstance():SoundManager
		{
			if (instance == null)
				instance = new SoundManager();
			return instance;
		}
		
		public function registerSound(_name:String, _sound:Sound):void
		{
			soundDictionary[_name] = _sound;
		}
		
		private var currentBackgroundMusicIndex:int = -1;
		public function playBackgroundMusicMauBinh():void
		{
			var randomFinish:Boolean;
			stopAllMusic();
			
			/*switch (currentBackgroundMusicIndex) 
			{
				case 0:
					stopMusic(SoundLibMauBinh.BACKGROUND_SOUND_1);
				break;
				case 1:
					stopMusic(SoundLibMauBinh.BACKGROUND_SOUND_2);
				break;
				case 2:
					stopMusic(SoundLibMauBinh.BACKGROUND_SOUND_3);
				break;
				default:
			}
			stopAllSound();*/
				
			while (!randomFinish) 
			{
				var randomIndex:int = Math.floor(Math.random() * 3);
				
				if (randomIndex != currentBackgroundMusicIndex)
				{
					randomFinish = true;
					currentBackgroundMusicIndex = randomIndex;
					switch (randomIndex) 
					{
						case 0:
							playMusic(SoundLibMauBinh.BACKGROUND_SOUND_1, 1000);
						break;
						case 1:
							playMusic(SoundLibMauBinh.BACKGROUND_SOUND_2, 1000);
						break;
						case 2:
							playMusic(SoundLibMauBinh.BACKGROUND_SOUND_3, 1000);
						break;
						default:
					}
				}
			}
		}
		
		public function playSound(_name:String,loop:int = 1):void
		{
			var tempSound:Sound = soundDictionary[_name];
			try 
			{
				if(tempSound != null)
					soundChannelDictionary[tempSound] = SoundChannel(tempSound.play(0,loop,soundTransform));
			}
			catch (err:Error)
			{
				
			}
		}
		
		public function playMusic(_name:String,loop:int = 1):void
		{
			var tempSound:Sound = soundDictionary[_name];
			try 
			{
				if(tempSound != null)
					musicChannelDictionary[tempSound] = SoundChannel(tempSound.play(0,loop,musicTransform));
			}
			catch (err:Error)
			{
				
			}
		}
		
		public function stopSound(_name:String):void
		{
			var tempSound:Sound = soundDictionary[_name];
			if (tempSound != null && soundChannelDictionary[tempSound] != null)
				SoundChannel(soundChannelDictionary[tempSound]).stop();
		}
		
		public function stopAllSound():void
		{
			for (var s:Object in soundChannelDictionary)
			{
				SoundChannel(soundChannelDictionary[s]).stop();
			}
		}
		
		public function stopAllMusic():void
		{
			for (var s:Object in musicChannelDictionary)
			{
				SoundChannel(musicChannelDictionary[s]).stop();
			}
		}
		
		public function stopMusic(_name:String):void
		{
			var tempSound:Sound = soundDictionary[_name];
			if (tempSound != null && musicChannelDictionary[tempSound] != null)
				SoundChannel(musicChannelDictionary[tempSound]).stop();
		}
		
		public function setVolumeForSound(value:Number):void
		{
			soundTransform.volume = value;
			if (value != 0)
				saveSoundVolume = value;
			for (var s:Object in soundChannelDictionary)
			{
				if (SoundChannel(soundChannelDictionary[s]))
				{
					SoundChannel(soundChannelDictionary[s]).soundTransform = soundTransform;
				}
			}
		}
		
		public function setVolumeForMusic(value:Number):void
		{
			musicTransform.volume = value;
			if (value != 0)
				saveMusicVolume = value;
			for (var s:Object in musicChannelDictionary)
			{
				SoundChannel(musicChannelDictionary[s])
					SoundChannel(musicChannelDictionary[s]).soundTransform = musicTransform;
			}
		}
		
		public function get isSoundOn():Boolean 
		{
			return _isSoundOn;
		}
		
		public function set isSoundOn(value:Boolean):void 
		{
			_isSoundOn = value;
			if (value)
				setVolumeForSound(saveSoundVolume);
			else
				setVolumeForSound(0);
		}
		
		public function get isMusicOn():Boolean 
		{
			return _isMusicOn;
		}
		
		public function set isMusicOn(value:Boolean):void 
		{
			_isMusicOn = value;
			if (value)
			{
				playBackgroundMusicMauBinh();
				setVolumeForMusic(saveMusicVolume);
			}
			else
			{
				setVolumeForMusic(0);
			}
		}
	}

}