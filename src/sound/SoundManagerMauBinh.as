package sound 
{
	/**
	 * ...
	 * @author 
	 */
	public class SoundManagerMauBinh 
	{
		
		public function SoundManagerMauBinh() 
		{
			
		}
		
		public function playDrawPlayerSound(sex:String):void
		{
			trace("soundManagerMauBinh playDrawPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.DRAW_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.DRAW_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.DRAW_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.DRAW_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.DRAW_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.DRAW_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.DRAW_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.DRAW_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.DRAW_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.DRAW_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playOtherWinPlayerSound(sex:String):void
		{
			trace("soundManagerMauBinh playOtherWinPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_WIN_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_WIN_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_WIN_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_WIN_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_WIN_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_WIN_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_WIN_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_WIN_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_WIN_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_WIN_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playLoseAllPlayerSound(sex:String):void
		{
			trace("soundManagerMauBinh playLoseAllPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
				if (sex == 'M')
				{
					switch (randomIndex) 
					{
						case 0:
							SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_ALL_SOUND_MALE_1);
						break;
						case 1:
							SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_ALL_SOUND_MALE_2);
						break;
						case 2:
							SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_ALL_SOUND_MALE_3);
						break;
						case 3:
							SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_ALL_SOUND_MALE_4);
						break;
						case 4:
							SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_ALL_SOUND_MALE_5);
						break;
						default:
					}
				}
				else
				{
					switch (randomIndex) 
					{
						case 0:
							SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_ALL_SOUND_FEMALE_1);
						break;
						case 1:
							SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_ALL_SOUND_FEMALE_2);
						break;
						case 2:
							SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_ALL_SOUND_FEMALE_3);
						break;
						case 3:
							SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_ALL_SOUND_FEMALE_4);
						break;
						case 4:
							SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_ALL_SOUND_FEMALE_5);
						break;
						default:
					}
				}
		}
		
		public function playStartGamePlayerSound(sex:String):void
		{
			trace("soundManagerMauBinh playStartGamePlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.START_GAME_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.START_GAME_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.START_GAME_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.START_GAME_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.START_GAME_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.START_GAME_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.START_GAME_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.START_GAME_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.START_GAME_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.START_GAME_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playOtherJoinGamePlayerSound(sex:String):void
		{
			trace("soundManagerMauBinh playOtherJoinGamePlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_JOIN_GAME_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_JOIN_GAME_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_JOIN_GAME_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_JOIN_GAME_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_JOIN_GAME_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_JOIN_GAME_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_JOIN_GAME_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_JOIN_GAME_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_JOIN_GAME_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_JOIN_GAME_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playOtherExitGamePlayerSound(sex:String):void
		{
			trace("soundManagerMauBinh playOtherExitGamePlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_EXIT_GAME_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_EXIT_GAME_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_EXIT_GAME_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_EXIT_GAME_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_EXIT_GAME_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_EXIT_GAME_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_EXIT_GAME_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_EXIT_GAME_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_EXIT_GAME_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.OTHER_EXIT_GAME_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playExitGamePlayerSound(sex:String):void
		{
			trace("soundManagerMauBinh playExitGamePlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.EXIT_GAME_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.EXIT_GAME_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.EXIT_GAME_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.EXIT_GAME_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.EXIT_GAME_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.EXIT_GAME_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.EXIT_GAME_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.EXIT_GAME_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.EXIT_GAME_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.EXIT_GAME_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playLobbyPlayerSound(sex:String):void
		{
			trace("soundManagerMauBinh playLobbyPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 2);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.LOBBY_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.LOBBY_SOUND_MALE_2);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.LOBBY_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.LOBBY_SOUND_FEMALE_2);
					break;
					default:
				}
			}
		}
		
		public function playSpecialPlayerSound(sex:String, mauBinhIndex:String, groupResult:String):void
		{
			trace("soundManagerMauBinh playSpecialPlayerSound");
			if (sex == 'M')
			{
				switch (mauBinhIndex) 
				{
					case '30':
						SoundManager.getInstance().playSound(SoundLibMauBinh.BA_SANH_SOUND_MALE);
					break;
					case '31':
						SoundManager.getInstance().playSound(SoundLibMauBinh.BA_THUNG_SOUND_MALE);
					break;
					case '32':
						SoundManager.getInstance().playSound(SoundLibMauBinh.LUC_PHE_BON_SOUND_MALE);
					break;
					case '33':
						SoundManager.getInstance().playSound(SoundLibMauBinh.NAM_DOI_MOT_SAM_SOUND_MALE);
					break;
					case '34':
						
					break;
					case '35':
						
					break;
					case '36':
						
					break;
					case '37':
						
					break;
					case '38':
						SoundManager.getInstance().playSound(SoundLibMauBinh.SANH_RONG_SOUND_MALE);
					break;
					case '39':
						SoundManager.getInstance().playSound(SoundLibMauBinh.SANH_RONG_CUON_SOUND_MALE);
					break;
					default:
				}
			}
			else
			{
				switch (groupResult) 
				{
					case '30':
						SoundManager.getInstance().playSound(SoundLibMauBinh.BA_SANH_SOUND_FEMALE);
					break;
					case '31':
						SoundManager.getInstance().playSound(SoundLibMauBinh.BA_THUNG_SOUND_FEMALE);
					break;
					case '32':
						SoundManager.getInstance().playSound(SoundLibMauBinh.LUC_PHE_BON_SOUND_FEMALE);
					break;
					case '33':
						SoundManager.getInstance().playSound(SoundLibMauBinh.NAM_DOI_MOT_SAM_SOUND_FEMALE);
					break;
					case '34':
						
					break;
					case '35':
						
					break;
					case '36':
						
					break;
					case '37':
						
					break;
					case '38':
						SoundManager.getInstance().playSound(SoundLibMauBinh.SANH_RONG_SOUND_FEMALE);
					break;
					case '39':
						SoundManager.getInstance().playSound(SoundLibMauBinh.SANH_RONG_CUON_SOUND_FEMALE);
					break;
					default:
				}
			}
		}
		
		public function playMauBinhPlayerSound(sex:String):void
		{
			trace("soundManagerMauBinh playMauBinhPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playNormalPlayerSound(sex:String, bestResult:String):void
		{
			trace("soundManagerMauBinh playNormalPlayerSound");
			if (sex == 'M')
			{
				switch (bestResult) 
				{
					case '22':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THUNG_PHA_SANH_CHI_2_SOUND_MALE);
					break;
					case '21':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THUNG_PHA_SANH_CHI_2_SOUND_MALE);
					break;
					case '20':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THUNG_PHA_SANH_CHI_2_SOUND_MALE);
					break;
					case '19':
						SoundManager.getInstance().playSound(SoundLibMauBinh.TU_QUY_CHI_2_SOUND_MALE);
					break;
					case '18':
						SoundManager.getInstance().playSound(SoundLibMauBinh.TU_QUY_CHI_2_SOUND_MALE);
					break;
					case '17':
						SoundManager.getInstance().playSound(SoundLibMauBinh.CU_LU_CHI_2_SOUND_MALE);
					break;
					case '16':
						SoundManager.getInstance().playSound(SoundLibMauBinh.XAM_CHI_3_SOUND_MALE);
					break;
					case '15':
						SoundManager.getInstance().playSound(SoundLibMauBinh.XAM_CHI_3_SOUND_MALE);
					break;
					case '14':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THUNG_PHA_SANH_SOUND_MALE);
					break;
					case '13':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THUNG_PHA_SANH_SOUND_MALE);
					break;
					case '12':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THUNG_PHA_SANH_SOUND_MALE);
					break;
					case '11':
						SoundManager.getInstance().playSound(SoundLibMauBinh.TU_QUY_SOUND_MALE);
					break;
					case '10':
						SoundManager.getInstance().playSound(SoundLibMauBinh.TU_QUY_SOUND_MALE);
					break;
					case '9':
						SoundManager.getInstance().playSound(SoundLibMauBinh.CU_LU_SOUND_MALE);
					break;
					case '8':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THUNG_SOUND_MALE);
					break;
					case '7':
						SoundManager.getInstance().playSound(SoundLibMauBinh.SANH_SOUND_MALE);
					break;
					case '6':
						SoundManager.getInstance().playSound(SoundLibMauBinh.SANH_SOUND_MALE);
					break;
					case '5':
						SoundManager.getInstance().playSound(SoundLibMauBinh.SANH_SOUND_MALE);
					break;
					case '4':
						SoundManager.getInstance().playSound(SoundLibMauBinh.XAM_SOUND_MALE);
					break;
					case '3':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THU_SOUND_MALE);
					break;
					case '2':
						SoundManager.getInstance().playSound(SoundLibMauBinh.DOI_SOUND_MALE);
					break;
					case '-4':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_4_SOUND_MALE);
					break;
					case '-5':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_5_SOUND_MALE);
					break;
					case '-6':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_6_SOUND_MALE);
					break;
					case '-7':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_7_SOUND_MALE);
					break;
					case '-8':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_8_SOUND_MALE);
					break;
					case '-9':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_9_SOUND_MALE);
					break;
					case '-10':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_10_SOUND_MALE);
					break;
					case '-11':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_J_SOUND_MALE);
					break;
					case '-12':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_Q_SOUND_MALE);
					break;
					case '-13':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_K_SOUND_MALE);
					break;
					case '-14':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_A_SOUND_MALE);
					break;
					default:
				}
			}
			else
			{
				switch (bestResult) 
				{
					case '22':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THUNG_PHA_SANH_CHI_2_SOUND_FEMALE);
					break;
					case '21':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THUNG_PHA_SANH_CHI_2_SOUND_FEMALE);
					break;
					case '20':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THUNG_PHA_SANH_CHI_2_SOUND_FEMALE);
					break;
					case '19':
						SoundManager.getInstance().playSound(SoundLibMauBinh.TU_QUY_CHI_2_SOUND_FEMALE);
					break;
					case '18':
						SoundManager.getInstance().playSound(SoundLibMauBinh.TU_QUY_CHI_2_SOUND_FEMALE);
					break;
					case '17':
						SoundManager.getInstance().playSound(SoundLibMauBinh.CU_LU_CHI_2_SOUND_FEMALE);
					break;
					case '16':
						SoundManager.getInstance().playSound(SoundLibMauBinh.XAM_CHI_3_SOUND_FEMALE);
					break;
					case '15':
						SoundManager.getInstance().playSound(SoundLibMauBinh.XAM_CHI_3_SOUND_FEMALE);
					break;
					case '14':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THUNG_PHA_SANH_SOUND_FEMALE);
					break;
					case '13':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THUNG_PHA_SANH_SOUND_FEMALE);
					break;
					case '12':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THUNG_PHA_SANH_SOUND_FEMALE);
					break;
					case '11':
						SoundManager.getInstance().playSound(SoundLibMauBinh.TU_QUY_SOUND_FEMALE);
					break;
					case '10':
						SoundManager.getInstance().playSound(SoundLibMauBinh.TU_QUY_SOUND_FEMALE);
					break;
					case '9':
						SoundManager.getInstance().playSound(SoundLibMauBinh.CU_LU_SOUND_FEMALE);
					break;
					case '8':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THUNG_SOUND_FEMALE);
					break;
					case '7':
						SoundManager.getInstance().playSound(SoundLibMauBinh.SANH_SOUND_FEMALE);
					break;
					case '6':
						SoundManager.getInstance().playSound(SoundLibMauBinh.SANH_SOUND_FEMALE);
					break;
					case '5':
						SoundManager.getInstance().playSound(SoundLibMauBinh.SANH_SOUND_FEMALE);
					break;
					case '4':
						SoundManager.getInstance().playSound(SoundLibMauBinh.XAM_SOUND_FEMALE);
					break;
					case '3':
						SoundManager.getInstance().playSound(SoundLibMauBinh.THU_SOUND_FEMALE);
					break;
					case '2':
						SoundManager.getInstance().playSound(SoundLibMauBinh.DOI_SOUND_FEMALE);
					break;
					case '-4':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_4_SOUND_FEMALE);
					break;
					case '-5':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_5_SOUND_FEMALE);
					break;
					case '-6':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_6_SOUND_FEMALE);
					break;
					case '-7':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_7_SOUND_FEMALE);
					break;
					case '-8':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_8_SOUND_FEMALE);
					break;
					case '-9':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_9_SOUND_FEMALE);
					break;
					case '-10':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_10_SOUND_FEMALE);
					break;
					case '-11':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_J_SOUND_FEMALE);
					break;
					case '-12':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_Q_SOUND_FEMALE);
					break;
					case '-13':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_K_SOUND_FEMALE);
					break;
					case '-14':
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_THAU_A_SOUND_FEMALE);
					break;
					default:
				}
			}
		}
		
		public function playDoChiPlayerSound(sex:String, index:int):void
		{
			trace("soundManagerMauBinh playDoChiPlayerSound");
			switch (index) 
			{
				case 1:
					if (sex == 'M')
						SoundManager.getInstance().playSound(SoundLibMauBinh.DO_CHI_1_SOUND_MALE);
					else
						SoundManager.getInstance().playSound(SoundLibMauBinh.DO_CHI_1_SOUND_FEMALE);
				break;
				case 2:
					if (sex == 'M')
						SoundManager.getInstance().playSound(SoundLibMauBinh.DO_CHI_2_SOUND_MALE);
					else
						SoundManager.getInstance().playSound(SoundLibMauBinh.DO_CHI_2_SOUND_FEMALE);
				break;
				case 3:
					if (sex == 'M')
						SoundManager.getInstance().playSound(SoundLibMauBinh.DO_CHI_3_SOUND_MALE);
					else
						SoundManager.getInstance().playSound(SoundLibMauBinh.DO_CHI_3_SOUND_FEMALE);
				break;
				default:
			}
		}
		
		public function playMauBinhLosePlayerSound(sex:String):void
		{
			trace("soundManagerMauBinh playMauBinhLosePlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_LOSE_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_LOSE_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_LOSE_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_LOSE_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_LOSE_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_LOSE_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_LOSE_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_LOSE_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_LOSE_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.MAU_BINH_LOSE_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playBinhLungPlayerSound(sex:String):void
		{
			trace("soundManagerMauBinh playBinhLungPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.BINH_LUNG_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.BINH_LUNG_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.BINH_LUNG_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.BINH_LUNG_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.BINH_LUNG_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.BINH_LUNG_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.BINH_LUNG_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.BINH_LUNG_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.BINH_LUNG_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.BINH_LUNG_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playTimeOutPlayerSound(sex:String):void
		{
			trace("soundManagerMauBinh playTimeOutPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.TIME_OUT_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.TIME_OUT_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.TIME_OUT_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.TIME_OUT_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.TIME_OUT_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.TIME_OUT_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.TIME_OUT_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.TIME_OUT_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.TIME_OUT_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.TIME_OUT_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playLosePlayerSound(sex:String):void
		{
			trace("soundManagerMauBinh playLosePlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibMauBinh.LOSE_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
	}

}