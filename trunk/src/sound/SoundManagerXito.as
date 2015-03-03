package sound 
{
	/**
	 * ...
	 * @author 
	 */
	public class SoundManagerXito 
	{
		
		public function SoundManagerXito() 
		{
			
		}
		
		public function playWinPlayerSound(sex:String):void
		{
			//trace("soundManagerXito playWinPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.WIN_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.WIN_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.WIN_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.WIN_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.WIN_SOUND_MALE_5);
					break;
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.WIN_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.WIN_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.WIN_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.WIN_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.WIN_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playLoseAllPlayerSound(sex:String):void
		{
			//trace("soundManagerXito playLoseAllPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
				if (sex == 'M')
				{
					switch (randomIndex) 
					{
						case 0:
							SoundManager.getInstance().playSound(SoundLibXito.LOSE_ALL_SOUND_MALE_1);
						break;
						case 1:
							SoundManager.getInstance().playSound(SoundLibXito.LOSE_ALL_SOUND_MALE_2);
						break;
						case 2:
							SoundManager.getInstance().playSound(SoundLibXito.LOSE_ALL_SOUND_MALE_3);
						break;
						case 3:
							SoundManager.getInstance().playSound(SoundLibXito.LOSE_ALL_SOUND_MALE_4);
						break;
						case 4:
							SoundManager.getInstance().playSound(SoundLibXito.LOSE_ALL_SOUND_MALE_5);
						break;
						default:
					}
				}
				else
				{
					switch (randomIndex) 
					{
						case 0:
							SoundManager.getInstance().playSound(SoundLibXito.LOSE_ALL_SOUND_FEMALE_1);
						break;
						case 1:
							SoundManager.getInstance().playSound(SoundLibXito.LOSE_ALL_SOUND_FEMALE_2);
						break;
						case 2:
							SoundManager.getInstance().playSound(SoundLibXito.LOSE_ALL_SOUND_FEMALE_3);
						break;
						case 3:
							SoundManager.getInstance().playSound(SoundLibXito.LOSE_ALL_SOUND_FEMALE_4);
						break;
						case 4:
							SoundManager.getInstance().playSound(SoundLibXito.LOSE_ALL_SOUND_FEMALE_5);
						break;
						default:
					}
				}
		}
		
		public function playStartGamePlayerSound(sex:String):void
		{
			//trace("soundManagerXito playStartGamePlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.START_GAME_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.START_GAME_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.START_GAME_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.START_GAME_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.START_GAME_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.START_GAME_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.START_GAME_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.START_GAME_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.START_GAME_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.START_GAME_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playOtherJoinGamePlayerSound(sex:String):void
		{
			//trace("soundManagerXito playOtherJoinGamePlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_JOIN_GAME_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_JOIN_GAME_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_JOIN_GAME_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_JOIN_GAME_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_JOIN_GAME_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_JOIN_GAME_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_JOIN_GAME_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_JOIN_GAME_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_JOIN_GAME_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_JOIN_GAME_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playOtherExitGamePlayerSound(sex:String):void
		{
			//trace("soundManagerXito playOtherExitGamePlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_EXIT_GAME_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_EXIT_GAME_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_EXIT_GAME_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_EXIT_GAME_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_EXIT_GAME_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_EXIT_GAME_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_EXIT_GAME_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_EXIT_GAME_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_EXIT_GAME_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.OTHER_EXIT_GAME_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playLobbyPlayerSound(sex:String):void
		{
			//trace("soundManagerXito playLobbyPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 2);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.LOBBY_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.LOBBY_SOUND_MALE_2);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.LOBBY_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.LOBBY_SOUND_FEMALE_2);
					break;
					default:
				}
			}
		}
		
		public function playNormalPlayerSound(sex:String, bestResult:String):void
		{
			//trace("soundManagerXito playNormalPlayerSound");
			if (sex == 'M')
			{
				switch (bestResult) 
				{
					case '9':
						SoundManager.getInstance().playSound(SoundLibXito.THUNG_PHA_SANH_SOUND_MALE);
					break;
					case '10':
						SoundManager.getInstance().playSound(SoundLibXito.THUNG_PHA_SANH_SOUND_MALE);
					break;
					case '8':
						SoundManager.getInstance().playSound(SoundLibXito.TU_QUY_SOUND_MALE);
					break;
					case '7':
						SoundManager.getInstance().playSound(SoundLibXito.CU_LU_SOUND_MALE);
					break;
					case '6':
						SoundManager.getInstance().playSound(SoundLibXito.THUNG_SOUND_MALE);
					break;
					case '5':
						SoundManager.getInstance().playSound(SoundLibXito.SANH_SOUND_MALE);
					break;
					case '4':
						SoundManager.getInstance().playSound(SoundLibXito.XAM_SOUND_MALE);
					break;
					case '3':
						SoundManager.getInstance().playSound(SoundLibXito.THU_SOUND_MALE);
					break;
					case '2':
						SoundManager.getInstance().playSound(SoundLibXito.DOI_SOUND_MALE);
					break;
					case '-7':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_7_SOUND_MALE);
					break;
					case '-8':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_8_SOUND_MALE);
					break;
					case '-9':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_9_SOUND_MALE);
					break;
					case '-10':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_10_SOUND_MALE);
					break;
					case '-11':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_J_SOUND_MALE);
					break;
					case '-12':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_Q_SOUND_MALE);
					break;
					case '-13':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_K_SOUND_MALE);
					break;
					case '-14':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_A_SOUND_MALE);
					break;
					default:
				}
			}
			else
			{
				switch (bestResult) 
				{
					case '9':
						SoundManager.getInstance().playSound(SoundLibXito.THUNG_PHA_SANH_SOUND_FEMALE);
					break;
					case '10':
						SoundManager.getInstance().playSound(SoundLibXito.THUNG_PHA_SANH_SOUND_FEMALE);
					break;
					case '8':
						SoundManager.getInstance().playSound(SoundLibXito.TU_QUY_SOUND_FEMALE);
					break;
					case '7':
						SoundManager.getInstance().playSound(SoundLibXito.CU_LU_SOUND_FEMALE);
					break;
					case '6':
						SoundManager.getInstance().playSound(SoundLibXito.THUNG_SOUND_FEMALE);
					break;
					case '5':
						SoundManager.getInstance().playSound(SoundLibXito.SANH_SOUND_FEMALE);
					break;
					case '4':
						SoundManager.getInstance().playSound(SoundLibXito.XAM_SOUND_FEMALE);
					break;
					case '3':
						SoundManager.getInstance().playSound(SoundLibXito.THU_SOUND_FEMALE);
					break;
					case '2':
						SoundManager.getInstance().playSound(SoundLibXito.DOI_SOUND_FEMALE);
					break;
					case '-7':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_7_SOUND_FEMALE);
					break;
					case '-8':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_8_SOUND_FEMALE);
					break;
					case '-9':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_9_SOUND_FEMALE);
					break;
					case '-10':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_10_SOUND_FEMALE);
					break;
					case '-11':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_J_SOUND_FEMALE);
					break;
					case '-12':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_Q_SOUND_FEMALE);
					break;
					case '-13':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_K_SOUND_FEMALE);
					break;
					case '-14':
						SoundManager.getInstance().playSound(SoundLibXito.MAU_THAU_A_SOUND_FEMALE);
					break;
					default:
				}
			}
		}
		
		public function playTimeOutPlayerSound(sex:String):void
		{
			//trace("soundManagerXito playTimeOutPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.TIME_OUT_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.TIME_OUT_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.TIME_OUT_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.TIME_OUT_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.TIME_OUT_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.TIME_OUT_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.TIME_OUT_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.TIME_OUT_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.TIME_OUT_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.TIME_OUT_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playLosePlayerSound(sex:String):void
		{
			//trace("soundManagerXito playLosePlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.LOSE_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.LOSE_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.LOSE_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.LOSE_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.LOSE_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.LOSE_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.LOSE_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.LOSE_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.LOSE_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.LOSE_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playCheckSound(sex:String):void
		{
			//trace("soundManagerXito playCheckSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.CHECK_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.CHECK_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.CHECK_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.CHECK_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.CHECK_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.CHECK_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.CHECK_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.CHECK_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.CHECK_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.CHECK_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playRaiseSound(sex:String):void
		{
			//trace("soundManagerXito playRaiseSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playCallSound(sex:String):void
		{
			//trace("soundManagerXito playCallSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playRaiseDoubleSound(sex:String):void
		{
			//trace("soundManagerXito playRaiseDoubleSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_DOUBLE_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_DOUBLE_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_DOUBLE_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_DOUBLE_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_DOUBLE_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_DOUBLE_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_DOUBLE_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_DOUBLE_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_DOUBLE_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_DOUBLE_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playRaiseTripleSound(sex:String):void
		{
			//trace("soundManagerXito playRaiseTripleSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_TRIPLE_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_TRIPLE_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_TRIPLE_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_TRIPLE_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_TRIPLE_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_TRIPLE_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_TRIPLE_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_TRIPLE_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_TRIPLE_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_TRIPLE_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playRaiseFourpleSound(sex:String):void
		{
			//trace("soundManagerXito playRaiseFourpleSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_FOURPLE_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_FOURPLE_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_FOURPLE_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_FOURPLE_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_FOURPLE_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_FOURPLE_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_FOURPLE_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_FOURPLE_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_FOURPLE_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.RAISE_FOURPLE_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playFoldSound(sex:String):void
		{
			//trace("soundManagerXito playFoldSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.FOLD_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.FOLD_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.FOLD_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.FOLD_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.FOLD_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.FOLD_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.FOLD_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.FOLD_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.FOLD_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.FOLD_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playAllInSound(sex:String):void
		{
			//trace("soundManagerXito playAllInSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.ALL_IN_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.ALL_IN_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.ALL_IN_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.ALL_IN_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.ALL_IN_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.ALL_IN_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.ALL_IN_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.ALL_IN_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.ALL_IN_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.ALL_IN_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playCallAllSound(sex:String):void
		{
			//trace("soundManagerXito playCallAllSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_ALL_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_ALL_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_ALL_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_ALL_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_ALL_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_ALL_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_ALL_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_ALL_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_ALL_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibXito.CALL_ALL_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playRaiseChipSound():void
		{
			//trace("soundManagerXito playRaiseChipSound");
			SoundManager.getInstance().playSound(SoundLibXito.RAISE_CHIP_SOUND);
		}
		
		public function playAddUpChipSound():void
		{
			//trace("soundManagerXito playAddUpChipSound");
			SoundManager.getInstance().playSound(SoundLibXito.ADD_UP_CHIP_SOUND);
		}
		
		public function playReceiveChipSound():void
		{
			//trace("soundManagerXito playReceiveChipSound");
			SoundManager.getInstance().playSound(SoundLibXito.RECEIVE_CHIP_SOUND);
		}
	}

}