package code 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.filters.GlowFilter;
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
		
		private var _btnHire:Sprite;
		private var _hireScreen:HireScreen;
		
		public function Carnival(aTown:Town) 
		{
			this.gotoAndStop("Carnival");
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
			{
				quadrants[i].addEventListener(MouseEvent.CLICK, onQuadrantSelect);
				quadrants[i].addEventListener(MouseEvent.MOUSE_OVER, onQuadrantMoveOver);
				quadrants[i].addEventListener(MouseEvent.MOUSE_OUT, onQuadrantMoveOff);
				removeGlow(quadrants[i]);
			}
				
			_btnHire = new Sprite();
			_btnHire.x = aTown.worldMap.stage.stageWidth / 2;
			_btnHire.graphics.beginFill(0xFF0000, 1.0);
			_btnHire.graphics.drawRect(0, 0, 50, 50);
			_btnHire.addEventListener(MouseEvent.CLICK, onHireClick);
			addChild(_btnHire);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onStageAdd);
			updateInfo();
		}
		
		private function onQuadrantMoveOver(e:MouseEvent):void
		{
			addGlow(e.currentTarget as MovieClip);
		}
		
		private function onQuadrantMoveOff(e:MouseEvent):void
		{
			removeGlow(e.target as MovieClip);
		}
		
		private function onQuadrantSelect(e:MouseEvent):void
		{
			this.gotoAndStop(e.currentTarget.name);
			
			for (var i:int = 0; i < quadrants.length; ++i)
			{
				quadrants[i].removeEventListener(MouseEvent.CLICK, onQuadrantSelect);
				quadrants[i].removeEventListener(MouseEvent.MOUSE_OVER, onQuadrantMoveOver);
				quadrants[i].removeEventListener(MouseEvent.MOUSE_OUT, onQuadrantMoveOff);
				removeGlow(quadrants[i]);
			}
				
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
		
		private function updateInfo():void
		{
			carnivalUI.txtHoursLeft.text = _hoursLeft;
			carnivalUI.txtWealth.text = player.wealth;
		}
		
		private function onBackClick(e:MouseEvent):void
		{
			if (this.currentLabel == "Carnival")
			{
				clearEvents();
				player.getPaid();
				trace(player.employees.length);
				town.worldMap.returnToOverworld();
			}
			else
			{
				this.gotoAndStop("Carnival");
				
				for (var i:int = 0; i < quadrants.length; ++i)
				{
					quadrants[i].alpha = 1;
					removeGlow(quadrants[i]);
					quadrants[i].addEventListener(MouseEvent.CLICK, onQuadrantSelect);
					quadrants[i].addEventListener(MouseEvent.MOUSE_OVER, onQuadrantMoveOver);
					quadrants[i].addEventListener(MouseEvent.MOUSE_OUT, onQuadrantMoveOff);
				}
			}
		}
		
		private function clearEvents():void
		{
			btnBack.removeEventListener(MouseEvent.CLICK, onBackClick);
			for (var i:int = 0; i < quadrants.length; ++i)
				quadrants[i].removeEventListener(MouseEvent.CLICK, onQuadrantSelect);
		}
		
		private function addGlow(aMC:MovieClip):void
		{
			var glow:GlowFilter = new GlowFilter();
			glow.color = 0xffff00;
			glow.alpha = 1;
			glow.blurX = 25;
			glow.blurY = 25;
			aMC.filters = [glow];
			aMC.alpha = 1;
		}
		
		private function removeGlow(aMC:MovieClip):void
		{
			aMC.filters = [];
			aMC.alpha = 0;
		}
	}
}