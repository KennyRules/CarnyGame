package code 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
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
		private const MAX_HOURS:int = 10;
		
		private var _hoursLeft:int;
		public function get hoursLeft():int { return _hoursLeft; }
		
		private var _btnHire:Sprite;
		private var _hireScreen:HireScreen;
		
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
				
			_btnHire = new Sprite();
			_btnHire.x = aTown.worldMap.stage.stageWidth / 2;
			_btnHire.graphics.beginFill(0xFF0000, 1.0);
			_btnHire.graphics.drawRect(0, 0, 50, 50);
			_btnHire.addEventListener(MouseEvent.CLICK, onHireClick);
			addChild(_btnHire);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onStageAdd);
			updateInfo();
		}
		
		private function onStageAdd(e:Event):void
		{
			_hireScreen = new HireScreen(this);
			addChild(_hireScreen);
			_hireScreen.visible = false;
		}
		
		private function onHireClick(e:MouseEvent):void
		{
			_btnHire.removeEventListener(MouseEvent.CLICK, onHireClick);
			_hireScreen.showScreen();
		}
		
		public function hideHireScreen():void
		{
			_btnHire.addEventListener(MouseEvent.CLICK, onHireClick);
			_hireScreen.hideScreen();
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
				btnBack.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
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
			trace(player.employees.length);
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