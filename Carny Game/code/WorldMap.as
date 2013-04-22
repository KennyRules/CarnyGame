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
		
		public function get player():Player { return _player; }
		
		public function WorldMap(aManager:GameScreens) 
		{
			gameScreenManager = aManager;
			_player = gameScreenManager.player;
			
			towns = new Array();
			currentTown = null;
			
			initTowns();
		}
		
		private function initTowns()
		{
			for (var i:int = 0; i < MAX_TOWNS; ++i)
			{
				var aTown:Town = new Town(this);
				aTown.x = Math.random() * gameScreenManager.stage.stageWidth;
				aTown.y = Math.random() * gameScreenManager.stage.stageHeight / 2 + Math.random() * gameScreenManager.stage.stageHeight / 2;
				aTown.addEventListener(MouseEvent.CLICK, onTownClick);
				addChild(aTown);
				towns.push(aTown);
			}
		}
		
		private function onTownClick(e:MouseEvent)
		{
			if (currentTown)
			{
				// TO-DO: Pop-up message detailing travel plans, etc.
			}
			
			// TO-DO: Prompt user for travel.
			gameScreenManager.changeLocation("Overhead Carnival");	
		}
	}
}