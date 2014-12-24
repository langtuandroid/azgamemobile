package logic 
{
	/**
	 * ...
	 * @author Bim kute
	 */
	/**
	 * TLMN card
	 * cac quan bai co gia tri, cac thu tu tuong ung BICH, TEP, RO, CO
	 * 3  - 0  1  2  3 
	 * 4  - 4  5  6  7
	 * 5  - 8  9  10 11
	 * 6  - 12 13 14 15
	 * 7  - 16 17 18 19
	 * 8  - 20 21 22 23
	 * 9  - 24 25 26 27
	 * 10 - 28 29 30 31
	 * J  - 32 33 34 35
	 * Q  - 36 37 38 39
	 * K  - 40 41 42 43
	 * A  - 44 45 46 47
	 * 2  - 48 49 50 51
	 */	
	public class CardsTlmn 
	{
		
		private var _cardArr:Array;
		private const CARDNUMBER:int = 51;
		public static const BA:String			=	"Ba";
		public static const BON:String			=	"Bon";
		public static const NAM:String			=	"Nam";
		public static const SAU:String			=	"Sau";
		public static const BAY:String			=	"Bay";
		public static const TAM:String			=	"Tam";
		public static const CHIN:String			=	"Chin";
		public static const MUOI:String			=	"Muoi";
		public static const J:String			=	"J";
		public static const Q:String			=	"Q";
		public static const K:String			=	"K";
		public static const A:String			=	"A";
		public static const HAI:String			=	"Hai";
		public static const BICH:String 		=	"Bich";
		public static const TEP:String			=	"Tep";
		public static const RO:String			=	"Ro";
		public static const CO:String			=	"Co";
		public static const LATHUONG:String 	=	"LaThuong";
		public static const DOITHONG:String 	=	"DoiThong";
		public static const DOIHAI:String		=	"DoiHai";
		public static const BADOITHONG:String 	=	"BaDoiThong";
		public static const BONDOITHONG:String 	=	"BonDoiThong";
		public static const NAMDOITHONG:String 	=	"NamDoiThong";
		public static const BALA:String 		=	"BaLa";
		public static const TUQUY:String 		=	"TuQuy";
		public static const DAY:String 			=	"day";
		public function CardsTlmn()
		{
			setUp();
		}
		private function setUp():void
		{
			_cardArr = new Array();
			for (var i:int = 0; i < CARDNUMBER; i++) 
			{
				_cardArr.push(i);	
			}
		}
		/**
		 * kiem tra co phai la quan HAI ko 
		 * @param card
		 * @return 
		 * 
		 */		
		public function isHai(card:int):Boolean
		{
			if(card>47 && card<52)
				return true;
			return false;
		}
		/**
		 * kiem tra co phai la DOI THONG ko 
		 * @param cardArr
		 * @return 
		 * 
		 */		
		public function isDoiThong(cardArr:Array):Boolean
		{
			if(cardArr.length!=2)return false;
			var card1:int = getCard(cardArr[0]);
			var card2:int = getCard(cardArr[1]);
			//trace(card1+card2);
			//trace(card1 == card2);
			return card1 == card2;
		}
		/**
		 * kiem tra co phai la 3 LA ko 
		 * @param cardArr
		 * @return 
		 * 
		 */		
		public function isBaLa(cardArr:Array):Boolean
		{
			if(cardArr.length!=3)return false;
			var card1:int = getCard(cardArr[0]);
			var card2:int = getCard(cardArr[1]);
			var card3:int = getCard(cardArr[2]);
			//trace("card1*"+card1+"card2*"+card2+"card3*"+card3);
			if(card1 == card2)
				if(card1==card3)return true;
			return false;
		}
		/**
		 *	kiem tra co phai TU QUY ko 
		 * @param cardArr
		 * @return 
		 * 
		 */		
		public function isTuQuy(cardArr:Array):Boolean
		{
			if(cardArr.length!=4)return false;
			var card1:int = getCard(cardArr[0]);
			var card2:int = getCard(cardArr[1]);
			var card3:int = getCard(cardArr[2]);
			var card4:int = getCard(cardArr[3]);
			var con1:Boolean = card2!=card1;
			var con2:Boolean = card3!=card2;
			var con3:Boolean = card4!=card3;
			return !(con1 || con2 || con3);
		}
		/**
		 * kiem tra co phai 3 DOI THONG ko 
		 * @param cardArr
		 * @return 
		 * 
		 */		
		public function isBaDoiThong(cardArr:Array):Boolean
		{
			if(cardArr.length!=6)return false;
			cardArr=cardArr.sort(Array.NUMERIC);
			for (var i:int = 0; i < cardArr.length; i++) 
			{
				if(isHai(cardArr[i]))return false;	
			}
			var card1:int = cardArr[0];
			var card2:int = cardArr[1];
			var card3:int = cardArr[2];
			var card4:int = cardArr[3];
			var card5:int = cardArr[4];
			var card6:int = cardArr[5];
			//
			
			// doi thu 1
			var arr:Array = new Array(card1,card2);
			var doi1:Boolean = isDoiThong(arr);
			if(!doi1)return false;
			// doi thu 2
			arr = new Array(card3, card4);
			var doi2:Boolean = isDoiThong(arr);
			if(!doi2)return false;
			// doi thu 3
			arr = new Array(card5, card6);
			var doi3:Boolean = isDoiThong(arr);
			if(!doi3)return false;
			//
			//if(!doi1 || !doi2 || !doi3)return false;
			if((getCard(card3) - getCard(card2))!=1)return false;
			if((getCard(card5)- getCard(card4))!=1)return false;
			return true;
		}
		/**
		 * kiem tra co phai 4 DOI THONG ko 
		 * @param cardArr
		 * @return 
		 * 
		 */		
		public function isBonDoiThong(cardArr:Array):Boolean
		{
			if(cardArr.length!=8)return false;
			cardArr= cardArr.sort(Array.NUMERIC);
			var arr:Array = cardArr.slice(0,6);
			//trace("arr*"+arr);
			var baDoiThong:Boolean = isBaDoiThong(arr);
			if(baDoiThong)
			{
				var card7:int = cardArr[6];
				var card8:int = cardArr[7];
				var doi:Array = new Array(card7, card8);
				//trace(getCard(cardArr[5]));
				if(getCard(card7)-getCard(cardArr[5]) == 1 && isDoiThong(doi))
					return true;
			}
			return false;
		}
		/**
		 *	kiem tra co phai 5 DOI THONG ko 
		 * @param cardArr
		 * @return 
		 * 
		 */		
		public function isNamDoiThong(cardArr:Array):Boolean
		{
			if(cardArr.length!=10)return false;
			cardArr = cardArr.sort(Array.NUMERIC);
			var arr:Array = cardArr.slice(0,8);
			var bonDoiThong:Boolean = isBonDoiThong(arr);
			if(bonDoiThong)
			{
				var card9:int = cardArr[8];
				var card10:int = cardArr[9];
				var doi:Array = new Array(card9, card10);
				//trace(getCard(cardArr[7]));
				if(getCard(card9)-getCard(cardArr[7]) == 1 && isDoiThong(doi))
					return true;
			}
			return false;
		}
		/**
		 * kiem tra cac quan bai co phai la DAY ko 
		 * @param cardArr
		 * @return 
		 * 
		 */		
		public function isDay(cardArr:Array):Boolean
		{
			if(cardArr.length<3)return false;
			cardArr = cardArr.sort(Array.NUMERIC);
			var card1:int;
			var card2:int;
			
			for(var i:int = 0; i< cardArr.length-1;i++)
			{
				if(isHai(cardArr[i]) || isHai(cardArr[i+1]))return false;
				card1 = getCard(cardArr[i]);
				card2 = getCard(cardArr[i+1]);
				//trace("card1--"+card1+"card2--"+card2);
				if(card2 - card1 != 1)
					return false;
			}
			return true;
		}
		
		
		public function isSpecialDay(cardArr:Array):Boolean
		{
			if(cardArr.length<3)return false;
			cardArr = cardArr.sort(Array.NUMERIC);
			var arrAt:Array = [];
			var arrHai:Array = [];
			
			var card1:int;
			var card2:int;
			
			var i:int;
			
			for(i = 0; i < cardArr.length; i++)
			{
				if(isHai(cardArr[i]))
				{
					arrHai.push(cardArr[i]);
					cardArr.splice(i, 1);
					i--;
				}
				else if(cardArr[i] > 43 && cardArr[i] < 48)
				{
					arrAt.push(cardArr[i]);
					cardArr.splice(i, 1);
					i--;
				}
			}
			
			cardArr = cardArr.sort(Array.NUMERIC);
			if(arrAt.length != 1 && arrHai.length != 1)
			{
				return false;
			}
			else if(arrAt.length == 1 && arrHai.length == 1)
			{
				if(cardArr[cardArr.length - 1] < 44 && cardArr[cardArr.length - 1] > 31)
				{
					return false;
				}
				
				arrAt[0] -= 52;
				arrHai[0] -= 52;
				cardArr = cardArr.concat(arrAt, arrHai);
				
				if(isDay(cardArr))
				{
					return true;
				}
				else
				{
					return false;
				}
				
			}
			else if(arrAt.length == 0 && arrHai.length == 1)
			{
				arrHai[0] -= 52;
				cardArr = cardArr.concat(arrHai);
				cardArr.sort(Array.NUMERIC);
				if(isDay(cardArr))
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else if(arrAt.length == 1 && arrHai.length == 0)
			{
				arrAt[0] -= 52;
				cardArr = cardArr.concat(arrAt);
				cardArr.sort(Array.NUMERIC);
				if(isDay(cardArr))
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
			
			
			return true;
		}
		
		
		/**
		 * tra ve gia tri quan bai.
		 * vi du cardValue: 0 -> quan 3 BICH 
		 * @param cardValue
		 * @return 
		 * 
		 */		
		public function getCard(cardValue:int):int
		{
			return (cardValue/4)+3;
		}
		/**
		 * tra ve chat cua quan bai: 0,1,2,3 tuong ung' voi BICH, TEP, RO, CO 
		 * @param cardValue
		 * @return 
		 * 
		 */		
		public function getSuitIndex(cardValue:int):int
		{
			return (cardValue%4)+3;
		}
		/**
		 * Lay ten cua quan bai 
		 * @param card
		 * @return 
		 * 
		 */		
		public function getCardName(card:int):String
		{
			if(card>=0 && card<4)return BA;
			if(card>3 && card<8)return BON;
			if(card>7 && card<12)return NAM;
			if(card>11 && card<16)return SAU;
			if(card>15 && card< 20)return BAY;
			if(card>19 && card< 24)return TAM;
			if(card>23 && card<28)return CHIN;
			if(card>27 && card<32)return MUOI;
			if(card>31 && card<36)return J;
			if(card>35 && card<40)return Q;
			if(card>39 && card<44)return K;
			if(card>43 && card<48)return A;
			if(card>47 && card<52)return HAI;
			return "";
		}
		/**
		 * lay hoa: 0- BICH. 1- TEP. 2- RO. 3- CO.
		 * @param index
		 * @return 
		 * 
		 */		
		public function convertCardSuit(index:int):String
		{
			switch(index)
			{
				case 0:
					return "bích";
					break;
				case 1:
					return "tép";
					break;
				case 2:
					return "rô";
					break;
				case 3:
					return "cơ";
					break;
			}
			return "";
		}
		
		
		public function getCardSuitName(card:int):String
		{
			return convertCardSuit(getSuitIndex(card));
		}
	}

}