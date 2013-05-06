package code 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import code.DailyReport;
	
	/**
	 * ...
	 * @author Drew Diamantoukos
	 */
	public class Carnival extends MovieClip 
	{
		private var town:Town;
		public function get getTown():Town { return town; }
		private var quadrants:Array;
		
		private var _player:Player;
		public function get player():Player { return _player; }
		
		private var numGuests:int;
		private var income:Number;
		private var expenses:Number;
		private const MAX_HOURS:int = 10;
		
		private var _hoursLeft:int;
		public function get hoursLeft():int { return _hoursLeft; }
		
		public function Carnival(aTown:Town) 
		{
			town = aTown;
			_player = town.player;
			_hoursLeft = MAX_HOURS;
			quadrants = new Array();
			quadrants.push(Rides);
			quadrants.push(Arch);
			quadrants.push(Entertainment);
			quadrants.push(Games);
			
			btnBack.addEventListener(MouseEvent.CLICK, onBackClick);
			
			for (var i:int = 0; i < quadrants.length; ++i)
				quadrants[i].addEventListener(MouseEvent.CLICK, onQuadrantSelect);
				
			updateInfo();
		}
		
		private function onQuadrantSelect(e:MouseEvent):void
		{
			trace(e.currentTarget.name);
			switch (e.currentTarget.name)
			{
				 
			}
			
			_hoursLeft -= Math.random() * 3;
			if (_hoursLeft <= 0)
			{
				// TO-DO: Display "end of day" report, associated logic. For now, just go back to world map.
				var report:DailyReport = new DailyReport(512, 384, this);
				addChild(report);
			}
			updateInfo();
		}
		
		private function updateInfo():void
		{
			txtHoursLeft.text = "Hours Left: " + _hoursLeft;
		}
		
		private function onBackClick(e:MouseEvent):void
		{
			clearEvents();
			player.getPaid();
			town.worldMap.returnToOverworld();
		}
		
		private function clearEvents():void
		{
			btnBack.removeEventListener(MouseEvent.CLICK, onBackClick);
			for (var i:int = 0; i < quadrants.length; ++i)
				quadrants[i].removeEventListener(MouseEvent.CLICK, onQuadrantSelect);
		}
	}
}