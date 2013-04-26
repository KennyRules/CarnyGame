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
		private var towns:Array;
		private var currentTown:Town;
		private var townPopup:TownPopupBox;
		
		public function get player():Player { return _player; }
		
		public function WorldMap(aManager:GameScreens) 
		{
			gameScreenManager = aManager;
			_player = gameScreenManager.player;
			
			towns = new Array();
			currentTown = null;
			
			initTowns();
			
			townPopup = new TownPopupBox();
			addChild(townPopup);
			townPopup.visible = false;
			
			this.addEventListener(MouseEvent.CLICK, onWorldClick);
		}
		
		private function initTowns()
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
		
		private function onWorldClick(e:MouseEvent)
		{
			trace(e.target);
			if (e.target is Town)
			{
				if (currentTown)
				{
					// TO-DO: Pop-up message detailing travel plans, etc.
				}
				
				showPopup(e.target as Town);
				//gameScreenManager.changeLocation("Overhead Carnival");	
			}
			else
			{
				townPopup.visible = false;
			}
		}
		
		public function showPopup(aTown:Town)
		{
			townPopup.visible = true;
			townPopup.loadInfo(aTown);
			townPopup.x = mouseX;
			townPopup.y = mouseY;
			
			if (townPopup.x + townPopup.width >= stage.stageWidth)
				townPopup.x -= (townPopup.x + townPopup.width - stage.stageWidth);
				
			if (townPopup.y + townPopup.height >= stage.stageHeight)
				townPopup.y -= (townPopup.y + townPopup.height - stage.stageHeight);
		}
	}
}