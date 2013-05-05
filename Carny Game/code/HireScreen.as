package code
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class HireScreen extends Sprite 
	{
		private var _carnival:Carnival;
		private var _player:Player;
		private var _potentialEmployees:Array;
		private var _potentialEmployeesButtons:Array;
		
		private var _exitButton:Sprite;
		private var _acceptButton:Sprite;
		private var _declineButton:Sprite;
		
		public function HireScreen(aCarnival:Carnival) 
		{
			_carnival = aCarnival;
			_player = _carnival.player;
			_potentialEmployees = new Array();
			_potentialEmployeesButtons = new Array();
			initEmployees();
			this.addEventListener(Event.ADDED_TO_STAGE, onStageAdd);
		}
		
		private function initEmployees():void
		{
			var aEmployee:Employee = new Employee("Bob", 100);
			_potentialEmployees.push(aEmployee);
			
			aEmployee = new Employee("Jeff", 50);
			_potentialEmployees.push(aEmployee);
			
			aEmployee = new Employee("Mark", 150);
			_potentialEmployees.push(aEmployee);
		}
		
		private function onStageAdd(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onStageAdd);
			this.graphics.beginFill(0x999999, 1.0);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			
			_exitButton = new Sprite();
			_exitButton.x = stage.stageWidth - 50;
			_exitButton.graphics.beginFill(0xFF0000, 1.0);
			_exitButton.graphics.drawRect(0, 0, 50, 50);
			addChild(_exitButton);
			
			for (var i:uint = 0; i < _potentialEmployees.length; ++i)
			{
				var aButton:Sprite = new Sprite();
				aButton.x = stage.stageWidth / 4;
				aButton.y = i * 200 + 150;
				aButton.graphics.beginFill(0x00FF00, 1.0);
				aButton.graphics.drawRect(0, 0, stage.stageWidth / 2, 100);
				
				// Set the text - Needs better formatting later.
				var aTextField:TextField = new TextField();
				aTextField.width = stage.stageWidth / 2;
				aTextField.text = "Name: " + _potentialEmployees[i].employeeName + ", Salary: " + _potentialEmployees[i].salary.toString();
				aButton.addChild(aTextField);
				
				addChild(aButton);
				_potentialEmployeesButtons.push(aButton);
				aButton.addEventListener(MouseEvent.CLICK, onEmployeeClick);
			}
		}
		
		private function onExitClick(e:MouseEvent):void
		{
			_carnival.hideHireScreen();
		}
		
		private function onEmployeeClick(e:MouseEvent):void
		{
			// TO-DO: Display accept/decline buttons and then add accordingly. For now, just add them and call it a day.
			var index:uint = _potentialEmployeesButtons.indexOf(e.currentTarget);
			_player.hireEmployee(_potentialEmployees[index] as Employee);
			
			while (_potentialEmployees.length > 0)
				_potentialEmployees.pop();
				
			while (_potentialEmployeesButtons.length > 0)
			{
				var aButton:Sprite = _potentialEmployeesButtons.pop();
				aButton.removeEventListener(MouseEvent.CLICK, onEmployeeClick);
				removeChild(aButton);
			}
		}
		
		public function showScreen():void
		{
			_exitButton.addEventListener(MouseEvent.CLICK, onExitClick);
			this.visible = true;
		}
		
		public function hideScreen():void
		{
			_exitButton.removeEventListener(MouseEvent.CLICK, onExitClick);
			this.visible = false;
		}
	}
}
