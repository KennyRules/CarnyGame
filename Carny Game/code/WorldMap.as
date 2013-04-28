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
		
		private var gameScreenManager:GameScreens;
		private var _player:Player;
		private var _currentTown:Town;
		private var towns:Array;
		private var townPopup:TownPopupBox;
		
		public function get player():Player { return _player; }
		public function get currentTown():Town { return _currentTown; }
		
		public function WorldMap(aManager:GameScreens)
		{
			gameScreenManager = aManager;
			_player = gameScreenManager.player;
			
			towns = new Array();
			_currentTown = null;
			
			initTowns();
			
			townPopup = new TownPopupBox();
			townPopup.btnTravel.addEventListener(MouseEvent.CLICK, onTravelClick);
			addChild(townPopup);
			townPopup.visible = false;
			
			this.addEventListener(MouseEvent.CLICK, onWorldClick);
		}
		
		public function returnToOverworld():void
		{
			gameScreenManager.changeLocation("World Map");
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
			gameScreenManager.changeLocation("Overhead Carnival");
		}
	}
}