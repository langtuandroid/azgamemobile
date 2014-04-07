package sound 
{
	/**
	 * ...
	 * @author 
	 */
	public class SoundManagerPhom 
	{
		
		public function SoundManagerPhom() 
		{
			
		}
		
		public function playFullDeckPlayerSound(sex:String):void
		{
			trace("soundManagerPhom playFullDeckPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playFullDeckAndCompensateAllPlayerSound(sex:String):void
		{
			trace("soundManagerPhom playFullDeckAndCompensateAllPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_AND_COMPENSATE_ALL_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_AND_COMPENSATE_ALL_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_AND_COMPENSATE_ALL_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_AND_COMPENSATE_ALL_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_AND_COMPENSATE_ALL_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_AND_COMPENSATE_ALL_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_AND_COMPENSATE_ALL_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_AND_COMPENSATE_ALL_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_AND_COMPENSATE_ALL_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.FULL_DECK_AND_COMPENSATE_ALL_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playCompensateAllPlayerSound(sex:String):void
		{
			trace("soundManagerPhom playCompensateAllPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.COMPENSATE_ALL_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.COMPENSATE_ALL_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.COMPENSATE_ALL_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.COMPENSATE_ALL_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.COMPENSATE_ALL_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.COMPENSATE_ALL_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.COMPENSATE_ALL_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.COMPENSATE_ALL_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.COMPENSATE_ALL_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.COMPENSATE_ALL_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playOtherWinPlayerSound(sex:String):void
		{
			trace("soundManagerPhom playOtherWinPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_WIN_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_WIN_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_WIN_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_WIN_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_WIN_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_WIN_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_WIN_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_WIN_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_WIN_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_WIN_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playLoseAllPlayerSound(sex:String):void
		{
			trace("soundManagerPhom playLoseAllPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
				if (sex == 'M')
				{
					switch (randomIndex) 
					{
						case 0:
							SoundManager.getInstance().playSound(SoundLibPhom.LOSE_ALL_SOUND_MALE_1);
						break;
						case 1:
							SoundManager.getInstance().playSound(SoundLibPhom.LOSE_ALL_SOUND_MALE_2);
						break;
						case 2:
							SoundManager.getInstance().playSound(SoundLibPhom.LOSE_ALL_SOUND_MALE_3);
						break;
						case 3:
							SoundManager.getInstance().playSound(SoundLibPhom.LOSE_ALL_SOUND_MALE_4);
						break;
						case 4:
							SoundManager.getInstance().playSound(SoundLibPhom.LOSE_ALL_SOUND_MALE_5);
						break;
						default:
					}
				}
				else
				{
					switch (randomIndex) 
					{
						case 0:
							SoundManager.getInstance().playSound(SoundLibPhom.LOSE_ALL_SOUND_FEMALE_1);
						break;
						case 1:
							SoundManager.getInstance().playSound(SoundLibPhom.LOSE_ALL_SOUND_FEMALE_2);
						break;
						case 2:
							SoundManager.getInstance().playSound(SoundLibPhom.LOSE_ALL_SOUND_FEMALE_3);
						break;
						case 3:
							SoundManager.getInstance().playSound(SoundLibPhom.LOSE_ALL_SOUND_FEMALE_4);
						break;
						case 4:
							SoundManager.getInstance().playSound(SoundLibPhom.LOSE_ALL_SOUND_FEMALE_5);
						break;
						default:
					}
				}
		}
		
		public function playStartGamePlayerSound(sex:String):void
		{
			trace("soundManagerPhom playStartGamePlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.START_GAME_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.START_GAME_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.START_GAME_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.START_GAME_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.START_GAME_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.START_GAME_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.START_GAME_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.START_GAME_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.START_GAME_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.START_GAME_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playStealFirstCardPlayerSound(sex:String):void
		{
			trace("soundManagerPhom playStealFirstCardPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_FIRST_CARD_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_FIRST_CARD_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_FIRST_CARD_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_FIRST_CARD_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_FIRST_CARD_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_FIRST_CARD_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_FIRST_CARD_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_FIRST_CARD_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_FIRST_CARD_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_FIRST_CARD_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playStealSecondCardPlayerSound(sex:String):void
		{
			trace("soundManagerPhom playStealSecondCardPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_SECOND_CARD_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_SECOND_CARD_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_SECOND_CARD_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_SECOND_CARD_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_SECOND_CARD_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_SECOND_CARD_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_SECOND_CARD_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_SECOND_CARD_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_SECOND_CARD_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_SECOND_CARD_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playStealBoltPlayerSound(sex:String):void
		{
			trace("soundManagerPhom playStealBoltPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_BOLT_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_BOLT_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_BOLT_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_BOLT_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_BOLT_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_BOLT_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_BOLT_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_BOLT_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_BOLT_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.STEAL_BOLT_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playOtherJoinGamePlayerSound(sex:String):void
		{
			trace("soundManagerPhom playOtherJoinGamePlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_JOIN_GAME_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_JOIN_GAME_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_JOIN_GAME_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_JOIN_GAME_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_JOIN_GAME_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_JOIN_GAME_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_JOIN_GAME_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_JOIN_GAME_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_JOIN_GAME_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_JOIN_GAME_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playOtherExitGamePlayerSound(sex:String):void
		{
			trace("soundManagerPhom playOtherExitGamePlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_EXIT_GAME_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_EXIT_GAME_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_EXIT_GAME_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_EXIT_GAME_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_EXIT_GAME_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_EXIT_GAME_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_EXIT_GAME_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_EXIT_GAME_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_EXIT_GAME_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.OTHER_EXIT_GAME_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playRiskDiscardPlayerSound(sex:String):void
		{
			trace("soundManagerPhom playRiskDiscardPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
				if (sex == 'M')
				{
					switch (randomIndex) 
					{
						case 0:
							SoundManager.getInstance().playSound(SoundLibPhom.RISK_DISCARD_SOUND_MALE_1);
						break;
						case 1:
							SoundManager.getInstance().playSound(SoundLibPhom.RISK_DISCARD_SOUND_MALE_2);
						break;
						case 2:
							SoundManager.getInstance().playSound(SoundLibPhom.RISK_DISCARD_SOUND_MALE_3);
						break;
						case 3:
							SoundManager.getInstance().playSound(SoundLibPhom.RISK_DISCARD_SOUND_MALE_4);
						break;
						case 4:
							SoundManager.getInstance().playSound(SoundLibPhom.RISK_DISCARD_SOUND_MALE_5);
						break;
						default:
					}
				}
				else
				{
					switch (randomIndex) 
					{
						case 0:
							SoundManager.getInstance().playSound(SoundLibPhom.RISK_DISCARD_SOUND_FEMALE_1);
						break;
						case 1:
							SoundManager.getInstance().playSound(SoundLibPhom.RISK_DISCARD_SOUND_FEMALE_2);
						break;
						case 2:
							SoundManager.getInstance().playSound(SoundLibPhom.RISK_DISCARD_SOUND_FEMALE_3);
						break;
						case 3:
							SoundManager.getInstance().playSound(SoundLibPhom.RISK_DISCARD_SOUND_FEMALE_4);
						break;
						case 4:
							SoundManager.getInstance().playSound(SoundLibPhom.RISK_DISCARD_SOUND_FEMALE_5);
						break;
						default:
					}
				}
		}
		
		public function playGetDeckPlayerSound(sex:String):void
		{
			trace("soundManagerPhom playGetDeckPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.GET_DECK_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.GET_DECK_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.GET_DECK_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.GET_DECK_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.GET_DECK_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.GET_DECK_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.GET_DECK_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.GET_DECK_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.GET_DECK_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.GET_DECK_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playNoDeckPlayerSound(sex:String):void
		{
			trace("soundManagerPhom playNoDeckPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.NO_DECK_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.NO_DECK_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.NO_DECK_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.NO_DECK_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.NO_DECK_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.NO_DECK_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.NO_DECK_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.NO_DECK_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.NO_DECK_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.NO_DECK_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playDiscardPlayerSound(sex:String):void
		{
			trace("soundManagerPhom playDiscardPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.DISCARD_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.DISCARD_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.DISCARD_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.DISCARD_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.DISCARD_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.DISCARD_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.DISCARD_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.DISCARD_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.DISCARD_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.DISCARD_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playExitGamePlayerSound(sex:String):void
		{
			trace("soundManagerPhom playExitGamePlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.EXIT_GAME_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.EXIT_GAME_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.EXIT_GAME_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.EXIT_GAME_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.EXIT_GAME_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.EXIT_GAME_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.EXIT_GAME_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.EXIT_GAME_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.EXIT_GAME_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.EXIT_GAME_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playLobbyPlayerSound(sex:String):void
		{
			trace("soundManagerPhom playLobbyPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 2);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.LOBBY_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.LOBBY_SOUND_MALE_2);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.LOBBY_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.LOBBY_SOUND_FEMALE_2);
					break;
					default:
				}
			}
		}
		
		public function playTimeOutPlayerSound(sex:String):void
		{
			trace("soundManagerPhom playTimeOutPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.TIME_OUT_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.TIME_OUT_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.TIME_OUT_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.TIME_OUT_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.TIME_OUT_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.TIME_OUT_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.TIME_OUT_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.TIME_OUT_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.TIME_OUT_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.TIME_OUT_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playLosePlayerSound(sex:String):void
		{
			trace("soundManagerPhom playLosePlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.LOSE_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.LOSE_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.LOSE_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.LOSE_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.LOSE_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.LOSE_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.LOSE_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.LOSE_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.LOSE_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.LOSE_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
		
		public function playBoltSoundPlayerSound(sex:String):void
		{
			trace("soundManagerPhom playBoltSoundPlayerSound");
			var randomIndex:int = Math.floor(Math.random() * 5);
			if (sex == 'M')
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.BOLT_SOUND_MALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.BOLT_SOUND_MALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.BOLT_SOUND_MALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.BOLT_SOUND_MALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.BOLT_SOUND_MALE_5);
					break;
					default:
				}
			}
			else
			{
				switch (randomIndex) 
				{
					case 0:
						SoundManager.getInstance().playSound(SoundLibPhom.BOLT_SOUND_FEMALE_1);
					break;
					case 1:
						SoundManager.getInstance().playSound(SoundLibPhom.BOLT_SOUND_FEMALE_2);
					break;
					case 2:
						SoundManager.getInstance().playSound(SoundLibPhom.BOLT_SOUND_FEMALE_3);
					break;
					case 3:
						SoundManager.getInstance().playSound(SoundLibPhom.BOLT_SOUND_FEMALE_4);
					break;
					case 4:
						SoundManager.getInstance().playSound(SoundLibPhom.BOLT_SOUND_FEMALE_5);
					break;
					default:
				}
			}
		}
	}

}