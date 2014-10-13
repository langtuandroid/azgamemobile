package sound 
{
	import control.ConstTlmn;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import model.MainData;
	
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
		public var soundManagerMauBinh:SoundManagerMauBinh;
		public var soundManagerPhom:SoundManagerPhom;
		
		public var isLoadSoundChung:Boolean;
		public var isLoadSoundMauBinh:Boolean;
		public var isLoadSoundPhom:Boolean;
		public var isLoadSoundTlmn:Boolean;
		public var isLoadMusicBackground:Boolean;
		private var mainData:MainData = MainData.getInstance();
		
		public function SoundManager() 
		{
			soundDictionary = new Dictionary();
			soundChannelDictionary = new Dictionary();
			musicChannelDictionary = new Dictionary();
			saveMusicVolume = 0.5;
			saveSoundVolume = 1;
			soundTransform = new SoundTransform(saveSoundVolume);
			musicTransform = new SoundTransform(saveMusicVolume);
			soundManagerMauBinh = new SoundManagerMauBinh();
			soundManagerPhom = new SoundManagerPhom();
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
		private var countLoadBackgroundSound:int;
		public function playBackgroundMusicMauBinh():void
		{
			var randomFinish:Boolean;
			stopAllMusic();
				
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
							playMusic(SoundLibChung.BACKGROUND_SOUND_1, 1000);
						break;
						case 1:
							playMusic(SoundLibChung.BACKGROUND_SOUND_2, 1000);
						break;
						case 2:
							playMusic(SoundLibChung.BACKGROUND_SOUND_3, 1000);
						break;
						default:
					}
				}
			}
		}
		
		public function stopBackgroundMusicMauBinh():void
		{
			stopMusic(SoundLibChung.BACKGROUND_SOUND_1);
			stopMusic(SoundLibChung.BACKGROUND_SOUND_2);
			stopMusic(SoundLibChung.BACKGROUND_SOUND_3);
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
		
		public function loadSoundMauBinh():void 
		{
			isLoadSoundMauBinh = true;
			for (var i:int = 0; i < mainData.init.soundMauBinhList.child.length(); i++) 
			{
				var soundUrl:String = mainData.init.soundMauBinhList.child[i];
				var tempSound:Sound = new Sound();
				tempSound.load(new URLRequest("http://203.162.121.120/gamebai/bimkute/maubinh/soundMauBinh/" + soundUrl + ".az"));
				tempSound.addEventListener(IOErrorEvent.IO_ERROR, onLoadSoundIOError);
				tempSound.addEventListener(Event.COMPLETE, onLoadSoundComplete);
				
				SoundManager.getInstance().registerSound(soundUrl, tempSound);
			}
		}
		
		private function onLoadSoundBinhComplete(e:Event):void 
		{
			trace("onLoadSoundBinhComplete");
		}
		
		public function loadSoundPhom():void 
		{
			isLoadSoundPhom = true;
			for (var i:int = 0; i < mainData.init.soundPhomList.child.length(); i++) 
			{
				var soundUrl:String = mainData.init.soundPhomList.child[i];
				var tempSound:Sound = new Sound();
				tempSound.load(new URLRequest("http://203.162.121.120/gamebai/bimkute/phom/soundPhom/" + soundUrl + ".az"));
				tempSound.addEventListener(IOErrorEvent.IO_ERROR, onLoadSoundIOError);
				tempSound.addEventListener(Event.COMPLETE, onLoadSoundComplete);
				SoundManager.getInstance().registerSound(soundUrl, tempSound);
			}
		}
		
		private function onLoadSoundPhomComplete(e:Event):void 
		{
			trace("onLoadSoundPhomComplete");
		}
		
		public function loadSoundChung():void 
		{
			isLoadSoundChung = true;
			for (var i:int = 0; i < mainData.init.soundChungList.child.length(); i++) 
			{
				var soundUrl:String = mainData.init.soundChungList.child[i];
				var tempSound:Sound = new Sound();
				tempSound.addEventListener(IOErrorEvent.IO_ERROR, onLoadSoundIOError);
				tempSound.addEventListener(Event.COMPLETE, onLoadSoundComplete);
				tempSound.load(new URLRequest("http://203.162.121.120/gamebai/bimkute/maubinh/soundChung/" + soundUrl + ".az"));
				SoundManager.getInstance().registerSound(soundUrl, tempSound);
				
				//var urlCache:URLCache
			}
		}
		
		private function onLoadSoundComplete(e:Event):void 
		{
			//trace("load sound thanh cong");
			mainData.loadSoundPercent++;
			mainData.loadSoundPercent = mainData.loadSoundPercent;
		}
		
		public function loadBackgroundMusic():void 
		{
			isLoadMusicBackground = true;
			
			countLoadBackgroundSound = 0;
			
			for (var i:int = 0; i < 3; i++) 
			{
				var tempSound:Sound = new Sound();
				SoundManager.getInstance().registerSound("GB001 (" + String(i + 1) + ")", tempSound);
				tempSound.load(new URLRequest("http://203.162.121.120/gamebai/bimkute/maubinh/soundChung/" + "GB001 (" + String(i + 1) + ")" + ".az"));
				tempSound.addEventListener(Event.COMPLETE, onLoadBackgroundMusicComplete);
				tempSound.addEventListener(IOErrorEvent.IO_ERROR, onLoadSoundIOError);
			}
		}
		
		private function onLoadBackgroundMusicComplete(e:Event):void 
		{
			countLoadBackgroundSound++;
			if (countLoadBackgroundSound == 3)
				SoundManager.getInstance().playBackgroundMusicMauBinh();
		}
		
		private function onLoadSoundIOError(e:IOErrorEvent):void 
		{
			
			mainData.loadSoundPercent++;
			mainData.loadSoundPercent = mainData.loadSoundPercent;
		}
		
		public function addSound():void 
		{
			isLoadSoundTlmn = true;
			var arrSoundName:Array = [
			ConstTlmn.SOUND_BOY_HELLO_1, ConstTlmn.SOUND_BOY_HELLO_2,
			ConstTlmn.SOUND_BOY_BYE_1, ConstTlmn.SOUND_BOY_BYE_2, ConstTlmn.SOUND_BOY_BYE_3, ConstTlmn.SOUND_BOY_BYE_4,
			ConstTlmn.SOUND_BOY_BYE_5, ConstTlmn.SOUND_BOY_JOINGAME_1, ConstTlmn.SOUND_BOY_JOINGAME_2, 
			ConstTlmn.SOUND_BOY_JOINGAME_3, ConstTlmn.SOUND_BOY_JOINGAME_4, ConstTlmn.SOUND_BOY_JOINGAME_5,
			ConstTlmn.SOUND_BOY_USER_OUTROOM_1, ConstTlmn.SOUND_BOY_USER_OUTROOM_2, ConstTlmn.SOUND_BOY_USER_OUTROOM_3,
			ConstTlmn.SOUND_BOY_USER_OUTROOM_4, ConstTlmn.SOUND_BOY_USER_OUTROOM_5, ConstTlmn.SOUND_BOY_STARTGAME_1,
			ConstTlmn.SOUND_BOY_STARTGAME_2, ConstTlmn.SOUND_BOY_STARTGAME_3, ConstTlmn.SOUND_BOY_STARTGAME_4,
			ConstTlmn.SOUND_BOY_STARTGAME_5, ConstTlmn.SOUND_BOY_OVERTIME_1, ConstTlmn.SOUND_BOY_OVERTIME_2,
			ConstTlmn.SOUND_BOY_OVERTIME_3, ConstTlmn.SOUND_BOY_OVERTIME_4, ConstTlmn.SOUND_BOY_OVERTIME_5,
			ConstTlmn.SOUND_BOY_DISCARD1CARD_1, ConstTlmn.SOUND_BOY_DISCARD1CARD_2, ConstTlmn.SOUND_BOY_DISCARD1CARD_3,
			ConstTlmn.SOUND_BOY_DISCARD1CARD_4, ConstTlmn.SOUND_BOY_DISCARD1CARD_5, ConstTlmn.SOUND_BOY_CHATDE1CARD_1,
			ConstTlmn.SOUND_BOY_CHATDE1CARD_2, ConstTlmn.SOUND_BOY_CHATDE1CARD_3, ConstTlmn.SOUND_BOY_CHATDE1CARD_4,
			ConstTlmn.SOUND_BOY_CHATDE1CARD_5, ConstTlmn.SOUND_BOY_CHATDE1CARD_6, ConstTlmn.SOUND_BOY_CHATDE1CARD_6,
			ConstTlmn.SOUND_BOY_CHATDE1CARD_8, ConstTlmn.SOUND_BOY_CHATDE1CARD_9, ConstTlmn.SOUND_BOY_CHATDE1CARD_10,
			ConstTlmn.SOUND_BOY_DANH2_1, ConstTlmn.SOUND_BOY_DANH2_2, ConstTlmn.SOUND_BOY_DANH2_3, 
			ConstTlmn.SOUND_BOY_DANH2_4, ConstTlmn.SOUND_BOY_DANH2_5, ConstTlmn.SOUND_BOY_DISCARD2CARD_1, 
			ConstTlmn.SOUND_BOY_DISCARD2CARD_2, ConstTlmn.SOUND_BOY_DISCARD2CARD_3, ConstTlmn.SOUND_BOY_DISCARD2CARD_4, 
			ConstTlmn.SOUND_BOY_DISCARD2CARD_5, ConstTlmn.SOUND_BOY_CHATDE2CARD_1, ConstTlmn.SOUND_BOY_CHATDE2CARD_2,
			ConstTlmn.SOUND_BOY_CHATDE2CARD_3, ConstTlmn.SOUND_BOY_CHATDE2CARD_4, ConstTlmn.SOUND_BOY_CHATDE2CARD_5,
			ConstTlmn.SOUND_BOY_DISCARD3CARD_1, ConstTlmn.SOUND_BOY_DISCARD3CARD_2, ConstTlmn.SOUND_BOY_DISCARD3CARD_3,
			ConstTlmn.SOUND_BOY_DISCARD3CARD_4, ConstTlmn.SOUND_BOY_DISCARD3CARD_5, ConstTlmn.SOUND_BOY_CHATDE3CARD_1,
			ConstTlmn.SOUND_BOY_CHATDE3CARD_2, ConstTlmn.SOUND_BOY_CHATDE3CARD_3, ConstTlmn.SOUND_BOY_CHATDE3CARD_4,
			ConstTlmn.SOUND_BOY_CHATDE3CARD_5, ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_1, ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_2,
			ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_3, ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_4, ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_5,
			ConstTlmn.SOUND_BOY_PASSTURN_1, ConstTlmn.SOUND_BOY_PASSTURN_2, ConstTlmn.SOUND_BOY_PASSTURN_3,
			ConstTlmn.SOUND_BOY_PASSTURN_4, ConstTlmn.SOUND_BOY_PASSTURN_5, ConstTlmn.SOUND_BOY_WIN_1,
			ConstTlmn.SOUND_BOY_WIN_2, ConstTlmn.SOUND_BOY_WIN_3, ConstTlmn.SOUND_BOY_WIN_4,
			ConstTlmn.SOUND_BOY_WIN_5, ConstTlmn.SOUND_BOY_LOSE_1, ConstTlmn.SOUND_BOY_LOSE_2,
			ConstTlmn.SOUND_BOY_LOSE_3, ConstTlmn.SOUND_BOY_LOSE_4, ConstTlmn.SOUND_BOY_LOSE_5,
			ConstTlmn.SOUND_BOY_OVERMONEY_1, ConstTlmn.SOUND_BOY_OVERMONEY_2, ConstTlmn.SOUND_BOY_OVERMONEY_3,
			ConstTlmn.SOUND_BOY_OVERMONEY_4, ConstTlmn.SOUND_BOY_OVERMONEY_5, 
			
			ConstTlmn.SOUND_GIRL_HELLO_1, ConstTlmn.SOUND_GIRL_HELLO_2,
			ConstTlmn.SOUND_GIRL_BYE_1, ConstTlmn.SOUND_GIRL_BYE_2, ConstTlmn.SOUND_GIRL_BYE_3, ConstTlmn.SOUND_GIRL_BYE_4,
			ConstTlmn.SOUND_GIRL_BYE_5, ConstTlmn.SOUND_GIRL_JOINGAME_1, ConstTlmn.SOUND_GIRL_JOINGAME_2, 
			ConstTlmn.SOUND_GIRL_JOINGAME_3, ConstTlmn.SOUND_GIRL_JOINGAME_4, ConstTlmn.SOUND_GIRL_JOINGAME_5,
			ConstTlmn.SOUND_GIRL_USER_OUTROOM_1, ConstTlmn.SOUND_GIRL_USER_OUTROOM_2, ConstTlmn.SOUND_GIRL_USER_OUTROOM_3,
			ConstTlmn.SOUND_GIRL_USER_OUTROOM_4, ConstTlmn.SOUND_GIRL_USER_OUTROOM_5, ConstTlmn.SOUND_GIRL_STARTGAME_1,
			ConstTlmn.SOUND_GIRL_STARTGAME_2, ConstTlmn.SOUND_GIRL_STARTGAME_3, ConstTlmn.SOUND_GIRL_STARTGAME_4,
			ConstTlmn.SOUND_GIRL_STARTGAME_5, ConstTlmn.SOUND_GIRL_OVERTIME_1, ConstTlmn.SOUND_GIRL_OVERTIME_2,
			ConstTlmn.SOUND_GIRL_OVERTIME_3, ConstTlmn.SOUND_GIRL_OVERTIME_4, ConstTlmn.SOUND_GIRL_OVERTIME_5,
			ConstTlmn.SOUND_GIRL_DISCARD1CARD_1, ConstTlmn.SOUND_GIRL_DISCARD1CARD_2, ConstTlmn.SOUND_GIRL_DISCARD1CARD_3,
			ConstTlmn.SOUND_GIRL_DISCARD1CARD_4, ConstTlmn.SOUND_GIRL_DISCARD1CARD_5, ConstTlmn.SOUND_GIRL_CHATDE1CARD_1,
			ConstTlmn.SOUND_GIRL_CHATDE1CARD_2, ConstTlmn.SOUND_GIRL_CHATDE1CARD_3, ConstTlmn.SOUND_GIRL_CHATDE1CARD_4,
			ConstTlmn.SOUND_GIRL_CHATDE1CARD_5, ConstTlmn.SOUND_GIRL_CHATDE1CARD_6, ConstTlmn.SOUND_GIRL_CHATDE1CARD_6,
			ConstTlmn.SOUND_GIRL_CHATDE1CARD_8, ConstTlmn.SOUND_GIRL_CHATDE1CARD_9, ConstTlmn.SOUND_GIRL_CHATDE1CARD_10,
			ConstTlmn.SOUND_GIRL_DANH2_1, ConstTlmn.SOUND_GIRL_DANH2_2, ConstTlmn.SOUND_GIRL_DANH2_3, 
			ConstTlmn.SOUND_GIRL_DANH2_4, ConstTlmn.SOUND_GIRL_DANH2_5, ConstTlmn.SOUND_GIRL_DISCARD2CARD_1, 
			ConstTlmn.SOUND_GIRL_DISCARD2CARD_2, ConstTlmn.SOUND_GIRL_DISCARD2CARD_3, ConstTlmn.SOUND_GIRL_DISCARD2CARD_4, 
			ConstTlmn.SOUND_GIRL_DISCARD2CARD_5, ConstTlmn.SOUND_GIRL_CHATDE2CARD_1, ConstTlmn.SOUND_GIRL_CHATDE2CARD_2,
			ConstTlmn.SOUND_GIRL_CHATDE2CARD_3, ConstTlmn.SOUND_GIRL_CHATDE2CARD_4, ConstTlmn.SOUND_GIRL_CHATDE2CARD_5,
			ConstTlmn.SOUND_GIRL_DISCARD3CARD_1, ConstTlmn.SOUND_GIRL_DISCARD3CARD_2, ConstTlmn.SOUND_GIRL_DISCARD3CARD_3,
			ConstTlmn.SOUND_GIRL_DISCARD3CARD_4, ConstTlmn.SOUND_GIRL_DISCARD3CARD_5, ConstTlmn.SOUND_GIRL_CHATDE3CARD_1,
			ConstTlmn.SOUND_GIRL_CHATDE3CARD_2, ConstTlmn.SOUND_GIRL_CHATDE3CARD_3, ConstTlmn.SOUND_GIRL_CHATDE3CARD_4,
			ConstTlmn.SOUND_GIRL_CHATDE3CARD_5, ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_1, ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_2,
			ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_3, ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_4, ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_5,
			ConstTlmn.SOUND_GIRL_PASSTURN_1, ConstTlmn.SOUND_GIRL_PASSTURN_2, ConstTlmn.SOUND_GIRL_PASSTURN_3,
			ConstTlmn.SOUND_GIRL_PASSTURN_4, ConstTlmn.SOUND_GIRL_PASSTURN_5, ConstTlmn.SOUND_GIRL_WIN_1,
			ConstTlmn.SOUND_GIRL_WIN_2, ConstTlmn.SOUND_GIRL_WIN_3, ConstTlmn.SOUND_GIRL_WIN_4,
			ConstTlmn.SOUND_GIRL_WIN_5, ConstTlmn.SOUND_GIRL_LOSE_1, ConstTlmn.SOUND_GIRL_LOSE_2,
			ConstTlmn.SOUND_GIRL_LOSE_3, ConstTlmn.SOUND_GIRL_LOSE_4, ConstTlmn.SOUND_GIRL_LOSE_5,
			ConstTlmn.SOUND_GIRL_OVERMONEY_1, ConstTlmn.SOUND_GIRL_OVERMONEY_2, ConstTlmn.SOUND_GIRL_OVERMONEY_3,
			ConstTlmn.SOUND_GIRL_OVERMONEY_4, ConstTlmn.SOUND_GIRL_OVERMONEY_5, 
			
			];
			//"Ready", , "Bichat"
			var arrSound:Array = [
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M001 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M001 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M002 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M002 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M002 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M002 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M002 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M003 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M003 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M003 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M003 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M003 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M004 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M004 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M004 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M004 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M004 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M005 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M005 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M005 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M005 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M005 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M006 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M006 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M006 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M006 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M006 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M007 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M007 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M007 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M007 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M007 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M008 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M008 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M008 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M008 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M008 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M008 (6).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M008 (7).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M008 (8).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M008 (9).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M008 (10).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M009 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M009 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M009 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M009 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M009 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M010 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M010 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M010 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M010 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M010 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M011 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M011 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M011 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M011 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M011 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M012 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M012 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M012 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M012 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M012 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M013 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M013 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M013 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M013 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M013 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M014 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M014 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M014 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M014 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M014 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M015 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M015 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M015 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M015 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M015 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M016 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M016 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M016 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M016 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M016 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M017 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M017 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M017 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M017 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M017 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M018 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M018 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M018 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M018 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Male/TL.M018 (5).az",
									
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F001 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F001 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F002 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F002 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F002 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F002 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F002 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F003 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F003 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F003 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F003 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F003 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F004 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F004 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F004 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F004 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F004 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F005 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F005 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F005 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F005 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F005 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F006 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F006 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F006 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F006 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F006 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F007 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F007 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F007 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F007 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F007 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F008 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F008 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F008 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F008 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F008 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F008 (6).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F008 (7).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F008 (8).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F008 (9).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F008 (10).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F009 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F009 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F009 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F009 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F009 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F010 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F010 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F010 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F010 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F010 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F011 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F011 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F011 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F011 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F011 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F012 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F012 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F012 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F012 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F012 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F013 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F013 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F013 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F013 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F013 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F014 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F014 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F014 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F014 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F014 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F015 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F015 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F015 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F015 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F015 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F016 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F016 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F016 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F016 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F016 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F017 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F017 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F017 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F017 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F017 (5).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F018 (1).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F018 (2).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F018 (3).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F018 (4).az",
									"http://203.162.121.120/gamebai/bimkute/sound/TL.Female/TL.F018 (5).az"
								];
			for (var i:int = 0; i < arrSoundName.length; i++) 
			{
				
				var mySound:Sound = new Sound();
				mySound.load(new URLRequest(arrSound[i]));
				mySound.addEventListener(IOErrorEvent.IO_ERROR, onLoadSoundIOError);
				mySound.addEventListener(Event.COMPLETE, onLoadSoundComplete);
				SoundManager.getInstance().registerSound(arrSoundName[i], mySound);
			}
		}
	}

}