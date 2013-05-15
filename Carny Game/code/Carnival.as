package code 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import code.DailyReport;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Drew Diamantoukos
	 */
	public class Carnival extends MovieClip 
	{
		private var _doc:Document;
		
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
		private var _task:Task;
		private var _report:DailyReport;
		
		public function Carnival(aTown:Town, aTask:Task) 
		{			
			this.gotoAndStop("Carnival");
			town = aTown;
			_task = aTask;
			
			_player = town.player;
			_hoursLeft = MAX_HOURS;
			quadrants = new Array();
			quadrants.push(Rides);
			quadrants.push(Arch);
			quadrants.push(Entertainment);
			quadrants.push(Games);
			
			for (var i:int = 0; i < quadrants.length; ++i)
			{
				removeGlow(quadrants[i]);
			}
			
			_btnHire = new Sprite();
			_btnHire.x = aTown.worldMap.stage.stageWidth / 2;
			_btnHire.graphics.beginFill(0x443F35, 1.0);
			_btnHire.graphics.drawRect(0, 0, 55, 30);
			_btnHire.addChild(new TextField());
			(_btnHire.getChildAt(0) as TextField).text = "HIRE";
			(_btnHire.getChildAt(0) as TextField).setTextFormat(new TextFormat(new EdmondsansFont().fontName, 22, 0xE5E5E5));
			(_btnHire.getChildAt(0) as TextField).selectable = false;
			addChild(_btnHire);
			
			_doc = town.worldMap.GameScreenManager.Doc;
			_doc.soundLibrary.playBG_sound("carnival",99);			// PLAY A SOUND
			
			this.addEventListener(Event.ADDED_TO_STAGE, onStageAdd);
			updateInfo();
		}
		
		private function addDefaultEventListeners():void
		{
			for (var i:int = 0; i < quadrants.length; ++i)
			{
				quadrants[i].addEventListener(MouseEvent.CLICK, onQuadrantSelect);
				quadrants[i].addEventListener(MouseEvent.MOUSE_OVER, onQuadrantMoveOver);
				quadrants[i].addEventListener(MouseEvent.MOUSE_OUT, onQuadrantMoveOff);
				removeGlow(quadrants[i]);
			}
			
			btnBack.addEventListener(MouseEvent.CLICK, onBackClick);
			_btnHire.addEventListener(MouseEvent.CLICK, onHireClick);
		}
		
		private function removeDefaultEventListeners():void
		{
			for(var i:int = 0; i < quadrants.lengths; ++i)
			{
				quadrants[i].removeEventListener(MouseEvent.CLICK, onQuadrantSelect);
				quadrants[i].removeEventListener(MouseEvent.MOUSE_OVER, onQuadrantMoveOver);
				quadrants[i].removeEventListener(MouseEvent.MOUSE_OUT, onQuadrantMoveOff);
				removeGlow(quadrants[i]);
			}
			btnBack.removeEventListener(MouseEvent.CLICK, onBackClick);
			_btnHire.removeEventListener(MouseEvent.CLICK, onHireClick);
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
			if (_hoursLeft <= 0)
				return;
			
			_doc.soundLibrary.playSound("click");			// PLAY A SOUND
			
			this.gotoAndStop(e.currentTarget.name);
			_btnHire.alpha = 0;
			btnBack.removeEventListener(MouseEvent.CLICK, onBackClick);
			
			for (var i:int = 0; i < quadrants.length; ++i)
			{
				quadrants[i].removeEventListener(MouseEvent.CLICK, onQuadrantSelect);
				quadrants[i].removeEventListener(MouseEvent.MOUSE_OVER, onQuadrantMoveOver);
				quadrants[i].removeEventListener(MouseEvent.MOUSE_OUT, onQuadrantMoveOff);
				removeGlow(quadrants[i]);
			}
				
			if (_task.wasTaskCompleted("FROG RIDE") == false)
			{
				if (e.currentTarget.name == "Rides")
				{
					_task.loadXMLSection("FROG RIDE");
					_task.addEventListener(MessageEvent.ON_SECTION_COMPLETE, onSectionComplete);
				}
				else
				{
					// Going to empty space.
					onSectionComplete(new MessageEvent(MessageEvent.ON_SECTION_COMPLETE));
				}
			}
			else
			{
				if (_task.chooseNextTask(e.currentTarget.name) == true)
					_task.addEventListener(MessageEvent.ON_SECTION_COMPLETE, onSectionComplete);
				else
					onSectionComplete(new MessageEvent(MessageEvent.ON_SECTION_COMPLETE));
			}
			
			
			updateInfo();
		}
		
		private function onStageAdd(e:Event):void
		{
			_hireScreen = new HireScreen(this);
			addChild(_hireScreen);
			_hireScreen.visible = false;
			
			if (!_task.wasTaskCompleted("TUTORIAL 2"))
			{
				_task.loadXML("TUTORIAL 2");
				_task.addEventListener(MessageEvent.ON_SECTION_COMPLETE, onTutorialComplete);
			}
			else
			{
				addDefaultEventListeners();
			}
		}
		
		private function onHireClick(e:MouseEvent):void
		{
			_doc.soundLibrary.playSound("click");			// PLAY A SOUND
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
			_doc.soundLibrary.playSound("click");			// PLAY A SOUND
			
			if (this.currentLabel == "Carnival")
			{
				clearEvents();
				player.getPaid();
				trace(player.employees.length);
				_doc.soundLibrary.stopBG_sound();			// STOP THE BG SOUNDS
				town.worldMap.returnToOverworld();
			}
			else
			{
				this.gotoAndStop("Carnival");
				addDefaultEventListeners();
				_btnHire.alpha = 1;
			}
		}
		
		private function onSectionComplete(e:MessageEvent):void
		{
			_hoursLeft -= Math.random() * 3;
			if (_hoursLeft <= 0)
			{
				_hoursLeft = 0;
				// TO-DO: Display "end of day" report, associated logic. For now, just go back to world map.
				_report = new DailyReport(512, 384, this);
				addChild(_report);
			}
			else
				btnBack.addEventListener(MouseEvent.CLICK, onBackClick);
		}
		
		private function onTutorialComplete(e:MessageEvent):void
		{
			addDefaultEventListeners();
		}
		
		public function endReport():void
		{
			removeChild(_report);
			btnBack.addEventListener(MouseEvent.CLICK, onBackClick);
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