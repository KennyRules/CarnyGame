package code 
{
	import flash.display.MovieClip;

	/**
	 * Individual town the player can travel to.
	 * @author Drew Diamantoukos
	 */
	public class Town extends MovieClip 
	{
		private var _townName:String;
		private var _player:Player;
		private var _worldMap:WorldMap;
		private var _population:int;
		private var _wealth:Number;
		private var _employmentRate:Number;
		private var _visited:Boolean;
		
		public function get townName():String { return _townName; }
		public function get player():Player { return _player; }
		public function get worldMap():WorldMap { return _worldMap; }
		public function get population():int { return _population; }
		public function get wealth():Number { return _wealth; }
		public function get employmentRate():Number { return _employmentRate; }
		public function get visited():Boolean { return _visited; }
		
		public function Town(aWorldMap:WorldMap, aName:String, aPop:int, aWealth:Number, aEmployRate:Number) 
		{
			_worldMap = aWorldMap;
			_townName = aName;
			_population = aPop;
			_wealth = aWealth;
			_employmentRate = aEmployRate;
			_visited = false;
			visitedFlag.visible = false;
			_player = worldMap.player;
		}
		
		public function visitTown():void
		{
			_visited = true;
			visitedFlag.visible = true;
		}
	}
}