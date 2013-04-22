package code 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Drew Diamantoukos
	 */
	public class Carnival extends MovieClip 
	{
		private var town:Town;
		private var quadrants:Array;
		
		private var _player:Player;
		public function get player():Player { return _player; }
		
		private var numGuests:int;
		private var income:Number;
		private var expenses:Number;
		
		private var hours:int;
		
		public function Carnival(aTown:Town) 
		{
			town = aTown;
			quadrants = new Array();
			quadrants.push(Rides);
			quadrants.push(Arch);
			quadrants.push(Entertainment);
			quadrants.push(Games);
			
			for (var i:int = 0; i < quadrants.length; ++i)
				quadrants[i].addEventListener(MouseEvent.CLICK, onQuadrantSelect);
		}
		
		private function onQuadrantSelect(e:MouseEvent)
		{
			trace(e.currentTarget.name);
			switch (e.currentTarget.name)
			{
				
			}
		}
	}
}