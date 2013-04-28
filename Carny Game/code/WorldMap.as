package code 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Drew Diamantoukos
	 */
	public class WorldMap extends MovieClip 
	{
		private const MAX_TOWNS:int = 5;
		private const MAX_WEEKS:int = 13;
		
		private var gameScreenManager:GameScreens;
		private var _player:Player;
		private var _currentTown:Town;
		private var _weeksLeft:int;
		private var towns:Array;
		private var townPopup:TownPopupBox;
		
		public function get player():Player { return _player; }
		public function get currentTown():Town { return _currentTown; }
		public function get weeksLeft():int { return _weeksLeft; }
		
		public function WorldMap(aManager:GameScreens)
		{
			gameScreenManager = aManager;
			_player = gameScreenManager.player;
			
			towns = new Array();
			_currentTown = null;
			
			initTowns();
			_weeksLeft = MAX_WEEKS;
			
			townPopup = new TownPopupBox();
			townPopup.btnTravel.addEventListener(MouseEvent.CLICK, onTravelClick);
			addChild(townPopup);
			townPopup.visible = false;
			
			this.addEventListener(MouseEvent.CLICK, onWorldClick);
			updateInfo();
		}
		
		// Call when day at carnival is done.
		public function returnToOverworld():void
		{
			_weeksLeft--;
			if (_weeksLeft > 0)
			{
				updateInfo();
				gameScreenManager.changeLocation("World Map");
			}
			else
			{
				// TO-DO: Handle the end of game, evaluation, etc.
			}
		}
		
		private function initTowns():void
		{
			for (var i:int = 0; i < MAX_TOWNS; ++i)
			{
				var aTown:Town = new Town(this, "Town " + i, Math.random() * 100 + 1, Math.random() * 100000 + 1, Math.random() * 101);
				aTown.x = Math.random() * gameScreenManager.stage.stageWidth;
				aTown.y = Math.random() * gameScreenManager.stage.stageHeight / 2 + Math.random() * gameScreenManager.stage.stageHeight / 2;
				addChild(aTown);
				towns.push(aTown);
			}
		}
		
		private function onWorldClick(e:MouseEvent):void
		{
			if (e.target is Town)
			{
				if (_currentTown)
				{
					// TO-DO: Pop-up message detailing travel plans, etc.
				}
				
				showPopup(e.target as Town);
			}
			else
			{
				townPopup.visible = false;
				townPopup.unloadInfo();
			}
		}
		
		public function showPopup(aTown:Town):void
		{
			// Don't move the popup box if it's the same town.
			if (townPopup.town == aTown)
				return;
				
			townPopup.visible = true;
			townPopup.loadInfo(aTown);
			townPopup.x = mouseX;
			townPopup.y = mouseY;
			
			// Make sure the entire pop-up box fits in the window.
			if (townPopup.x + townPopup.width >= stage.stageWidth)
				townPopup.x -= (townPopup.x + townPopup.width - stage.stageWidth);
				
			if (townPopup.y + townPopup.height >= stage.stageHeight)
				townPopup.y -= (townPopup.y + townPopup.height - stage.stageHeight);
		}
		
		private function onTravelClick(e:MouseEvent):void
		{
			_currentTown = townPopup.town;
			_currentTown.visitTown();
			gameScreenManager.changeLocation("Overhead Carnival");
		}
		
		private function updateInfo():void
		{
			txtWeeksLeft.text = "Weeks Left: " + _weeksLeft;
			txtWealth.text = "Wealth: " + player.wealth;
		}
	}
}