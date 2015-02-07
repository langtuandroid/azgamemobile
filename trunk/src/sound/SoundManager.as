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
	import model.MyDataTLMN;
	
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
		public var soundManagerXito:SoundManagerXito;
		
		public var isLoadSoundChung:Boolean;
		public var isLoadSoundMauBinh:Boolean;
		public var isLoadSoundPhom:Boolean;
		public var isLoadSoundXito:Boolean;
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
			soundManagerXito = new SoundManagerXito();
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
			//trace("onLoadSoundBinhComplete");
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
			//trace("onLoadSoundPhomComplete");
		}
		
		public function loadSoundXito():void 
		{
			isLoadSoundXito = true;
			for (var i:int = 0; i < mainData.init.soundXitoList.child.length(); i++) 
			{
				var soundUrl:String = mainData.init.soundXitoList.child[i];
				var tempSound:Sound = new Sound();
				tempSound.load(new URLRequest("http://203.162.121.120/gamebai/bimkute/xito/soundXito/" + soundUrl + ".az"));
				tempSound.addEventListener(IOErrorEvent.IO_ERROR, onLoadSoundIOError);
				tempSound.addEventListener(Event.COMPLETE, onLoadSoundXitoComplete);
				SoundManager.getInstance().registerSound(soundUrl, tempSound);
			}
		}
		
		private function onLoadSoundXitoComplete(e:Event):void 
		{
			//trace("onLoadSoundXitoComplete",e.currentTarget.url);
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
				tempSound.load(new URLRequest("http://203.162.121.120/gamebai/bimkute/newSound/" + "SBS.000" + String(i + 1) + ".az"));
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
			trace("onLoadSoundIOError",e.text);
			mainData.loadSoundPercent++;
			mainData.loadSoundPercent = mainData.loadSoundPercent;
		}
		
		public function addSound():void 
		{
			isLoadSoundTlmn = true;
			var arrSoundName:Array = [
			ConstTlmn.SOUND_BOY_HELLO_1, ConstTlmn.SOUND_BOY_HELLO_2, ConstTlmn.SOUND_BOY_HELLO_SAM_1, ConstTlmn.SOUND_BOY_HELLO_SAM_2,
			ConstTlmn.SOUND_BOY_BYE_1, ConstTlmn.SOUND_BOY_BYE_2, ConstTlmn.SOUND_BOY_BYE_3, ConstTlmn.SOUND_BOY_BYE_4,
			ConstTlmn.SOUND_BOY_BYE_5, ConstTlmn.SOUND_BOY_JOINGAME_1, ConstTlmn.SOUND_BOY_JOINGAME_2, 
			ConstTlmn.SOUND_BOY_JOINGAME_3, ConstTlmn.SOUND_BOY_JOINGAME_4, ConstTlmn.SOUND_BOY_JOINGAME_5,
			ConstTlmn.SOUND_BOY_USER_OUTROOM_1, ConstTlmn.SOUND_BOY_USER_OUTROOM_2, ConstTlmn.SOUND_BOY_USER_OUTROOM_3,
			ConstTlmn.SOUND_BOY_USER_OUTROOM_4, ConstTlmn.SOUND_BOY_USER_OUTROOM_5, ConstTlmn.SOUND_BOY_STARTGAME_1,
			ConstTlmn.SOUND_BOY_STARTGAME_2, ConstTlmn.SOUND_BOY_STARTGAME_3, ConstTlmn.SOUND_BOY_STARTGAME_4,
			ConstTlmn.SOUND_BOY_STARTGAME_5,
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
			ConstTlmn.SOUND_BOY_WIN_5, ConstTlmn.SOUND_BOY_WIN_SAM_1,
			ConstTlmn.SOUND_BOY_WIN_SAM_2, ConstTlmn.SOUND_BOY_WIN_SAM_3, ConstTlmn.SOUND_BOY_WIN_SAM_4,
			ConstTlmn.SOUND_BOY_WIN_SAM_5, ConstTlmn.SOUND_BOY_LOSE_SAM_1, ConstTlmn.SOUND_BOY_LOSE_SAM_2,
			ConstTlmn.SOUND_BOY_LOSE_SAM_3, ConstTlmn.SOUND_BOY_LOSE_SAM_4, ConstTlmn.SOUND_BOY_LOSE_SAM_5,
			ConstTlmn.SOUND_BOY_LOSE_1, ConstTlmn.SOUND_BOY_LOSE_2,
			ConstTlmn.SOUND_BOY_LOSE_3, ConstTlmn.SOUND_BOY_LOSE_4, ConstTlmn.SOUND_BOY_LOSE_5,
			ConstTlmn.SOUND_BOY_OVERMONEY_1, ConstTlmn.SOUND_BOY_OVERMONEY_2, ConstTlmn.SOUND_BOY_OVERMONEY_3,
			ConstTlmn.SOUND_BOY_OVERMONEY_4, ConstTlmn.SOUND_BOY_OVERMONEY_5, 
			
			ConstTlmn.SOUND_GIRL_HELLO_1, ConstTlmn.SOUND_GIRL_HELLO_2, ConstTlmn.SOUND_GIRL_HELLO_SAM_1, ConstTlmn.SOUND_GIRL_HELLO_SAM_2,
			ConstTlmn.SOUND_GIRL_BYE_1, ConstTlmn.SOUND_GIRL_BYE_2, ConstTlmn.SOUND_GIRL_BYE_3, ConstTlmn.SOUND_GIRL_BYE_4,
			ConstTlmn.SOUND_GIRL_BYE_5, ConstTlmn.SOUND_GIRL_JOINGAME_1, ConstTlmn.SOUND_GIRL_JOINGAME_2, 
			ConstTlmn.SOUND_GIRL_JOINGAME_3, ConstTlmn.SOUND_GIRL_JOINGAME_4, ConstTlmn.SOUND_GIRL_JOINGAME_5,
			ConstTlmn.SOUND_GIRL_USER_OUTROOM_1, ConstTlmn.SOUND_GIRL_USER_OUTROOM_2, ConstTlmn.SOUND_GIRL_USER_OUTROOM_3,
			ConstTlmn.SOUND_GIRL_USER_OUTROOM_4, ConstTlmn.SOUND_GIRL_USER_OUTROOM_5, ConstTlmn.SOUND_GIRL_STARTGAME_1,
			ConstTlmn.SOUND_GIRL_STARTGAME_2, ConstTlmn.SOUND_GIRL_STARTGAME_3, ConstTlmn.SOUND_GIRL_STARTGAME_4,
			ConstTlmn.SOUND_GIRL_STARTGAME_5,
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
			ConstTlmn.SOUND_GIRL_WIN_5, 
			ConstTlmn.SOUND_GIRL_WIN_SAM_1,
			ConstTlmn.SOUND_GIRL_WIN_SAM_2, ConstTlmn.SOUND_GIRL_WIN_SAM_3, ConstTlmn.SOUND_GIRL_WIN_SAM_4,
			ConstTlmn.SOUND_GIRL_WIN_SAM_5, ConstTlmn.SOUND_GIRL_LOSE_SAM_1, ConstTlmn.SOUND_GIRL_LOSE_SAM_2,
			ConstTlmn.SOUND_GIRL_LOSE_SAM_3, ConstTlmn.SOUND_GIRL_LOSE_SAM_4, ConstTlmn.SOUND_GIRL_LOSE_SAM_5,
			ConstTlmn.SOUND_GIRL_LOSE_1, ConstTlmn.SOUND_GIRL_LOSE_2,
			ConstTlmn.SOUND_GIRL_LOSE_3, ConstTlmn.SOUND_GIRL_LOSE_4, ConstTlmn.SOUND_GIRL_LOSE_5,
			ConstTlmn.SOUND_GIRL_OVERMONEY_1, ConstTlmn.SOUND_GIRL_OVERMONEY_2, ConstTlmn.SOUND_GIRL_OVERMONEY_3,
			ConstTlmn.SOUND_GIRL_OVERMONEY_4, ConstTlmn.SOUND_GIRL_OVERMONEY_5, 
			
			];
			//"Ready", , "Bichat"
			var arrSound:Array;
			//if (MyDataTLMN.getInstance().isGame == 1) 
			{
				arrSound = [
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0083.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0084.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0429.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0084.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0090.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0091.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0092.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0093.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0094.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0085.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0086.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0087.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0088.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0089.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0090.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0091.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0092.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0093.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0094.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0095.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0096.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0097.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0098.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0099.az",
									
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0100.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0101.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0102.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0103.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0104.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0105.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0106.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0107.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0108.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0109.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0110.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0111.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0112.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0113.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0114.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0115.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0116.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0117.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0118.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0119.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0120.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0121.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0122.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0123.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0124.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0125.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0126.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0127.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0128.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0129.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0130.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0131.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0132.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0133.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0134.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0135.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0136.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0137.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0138.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0139.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0140.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0141.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0142.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0143.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0144.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0145.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0146.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0147.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0148.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0149.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0150.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0151.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0152.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0153.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0154.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0525.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0526.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0527.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0528.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0529.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0530.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0531.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0532.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0533.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0534.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0155.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0156.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0157.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0158.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0159.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0160.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0161.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0162.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0163.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0164.az",
									
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0001.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0002.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0513.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0514.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0008.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0009.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0010.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0011.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0012.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0003.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0004.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0005.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0006.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0007.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0008.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0009.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0010.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0011.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0012.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0013.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0014.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0015.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0016.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0017.az",
									
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0018.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0019.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0020.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0021.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0022.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0023.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0024.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0025.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0026.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0027.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0028.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0029.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0030.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0031.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0032.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0033.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0034.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0035.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0036.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0037.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0038.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0039.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0040.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0041.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0042.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0043.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0044.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0045.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0046.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0047.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0048.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0049.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0050.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0051.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0052.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0053.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0054.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0055.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0056.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0057.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0058.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0059.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0060.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0061.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0062.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0063.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0064.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0065.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0066.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0067.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0068.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0069.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0070.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0071.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0072.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0515.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0516.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0517.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0518.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0519.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0520.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0521.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0522.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0523.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0524.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0073.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0074.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0075.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0076.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0077.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0078.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0079.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0080.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0081.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0082.az"
								];
			}
			/*else 
			{
				arrSound = [
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0429.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0084.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0090.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0091.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0092.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0093.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0094.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0085.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0086.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0087.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0088.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0089.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0090.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0091.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0092.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0093.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0094.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0095.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0096.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0097.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0098.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0099.az",
									
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0100.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0101.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0102.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0103.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0104.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0105.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0106.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0107.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0108.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0109.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0110.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0111.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0112.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0113.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0114.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0115.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0116.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0117.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0118.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0119.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0120.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0121.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0122.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0123.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0124.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0125.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0126.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0127.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0128.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0129.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0130.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0131.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0132.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0133.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0134.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0135.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0136.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0137.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0138.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0139.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0140.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0141.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0142.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0143.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0144.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0145.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0146.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0147.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0148.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0149.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0525.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0526.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0527.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0528.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0529.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0530.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0531.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0532.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0533.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0534.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0160.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0161.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0162.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0163.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0164.az",
									
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0513.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0514.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0008.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0009.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0010.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0011.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0012.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0003.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0004.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0005.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0006.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0007.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0008.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0009.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0010.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0011.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0012.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0013.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0014.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0015.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0016.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0017.az",
									
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0018.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0019.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0020.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0021.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0022.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0023.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0024.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0025.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0026.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0027.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0028.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0029.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0030.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0031.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0032.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0033.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0034.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0035.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0036.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0037.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0038.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0039.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0040.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0041.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0042.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0043.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0044.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0045.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0046.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0047.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0048.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0049.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0050.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0051.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0052.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0053.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0054.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0055.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0056.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0057.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0058.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0059.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0060.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0061.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0062.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0063.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0064.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0065.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0066.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0067.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0515.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0516.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0517.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0518.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0519.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0520.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0521.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0522.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0523.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0524.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0078.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0079.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0080.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0081.az",
									"http://203.162.121.120/gamebai/bimkute/newSound/SBV.0082.az"
								];
			}*/
			
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