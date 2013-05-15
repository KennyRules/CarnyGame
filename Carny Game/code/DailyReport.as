package  code{
	
	import flash.display.MovieClip;
	import code.Player;
	import code.Document;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import fl.motion.MotionEvent;
	
	
	public class DailyReport extends MovieClip {
		
		private var _carnival:Carnival;
		private var _player:Player;
		private var _town:Town;
		private var _doc:Document;
		private var _employee_textfields:Array;	// array of the employee text fields
		private var _firebuttons:Array;			// array of the employee text fields
		
		// textfield stuff
		private var _leftAlign:Number;		// where the text boxes will align on the left
		private var _spaceBetween:Number; 	// the space between textfields
		private var _boxHeight:Number;		// height of the individual textfield
		private var _startingY:Number;		// the y position of the first textfield 
		
		public function DailyReport(xPos:Number, yPos:Number, aCarnival:Carnival) {
			// constructor code
			x = xPos;
			y = yPos;
			_carnival = aCarnival;
			_player = _carnival.player;
			_town = _carnival.getTown;
			_employee_textfields = new Array();
			_firebuttons = new Array();
			_doc = _town.worldMap.GameScreenManager.Doc;
			
			// assign values to the textfield stuff
			_leftAlign = (this.x - width * 2) + 10;
			_spaceBetween = 40;
			_boxHeight = 30;
			_startingY = textbox_title.y + 40;
			
			_player.getPaid(_town.population, _town.wealth, _town.employmentRate);
			
			// Set up the report menu
			setDay();
			setIncome();
			setEmployees();
			
			exitBtn.addEventListener(MouseEvent.CLICK, onExitClick);
		}
		
		// Will make the title say "End of Day XX"
		private function setDay()
		{
			textbox_title.text = "End of Day " + _town.worldMap.daysLeft;
		}
		
		// Will display the income data
		private function setIncome()
		{
			textbox_money.text = "Money: $" + _player.wealth;
		}
		
		//  Display our list of employees
		private function setEmployees()
		{
			for(var i = 0; i < _player.employees.length; ++i)
			{
				var tf:TextField = new TextField();	// textfield for each employee
				
				tf.x = -270;						// set x and y coords
				tf.y = -150 + (_spaceBetween * i);
				tf.height = _boxHeight;				// set the textfield height
				tf.width = 300;
								
				tf.text = _player.employees[i].employeeName + "Profit: " + _player.employees[i].profit;	// set the name of the employee
				addChild(tf);									// add to the scene
				_employee_textfields.push(tf);					// add to the array
				
				var button:FireButton = new FireButton(i);		// make the firing button
				button.y = tf.y + 8;							// set coords
				button.x = 200;
				addChild(button);								// add to the scene
				_firebuttons.push(button);						// add to the array
				
				
				button.addEventListener(MouseEvent.CLICK, onClick(i));
			}
		}
		
		private function clearArrays()
		{
			for(var i = 0; i < _player.employees.length + 1; ++i)	// remove them from the scene
			{
				removeChild(_employee_textfields[i]);
				removeChild(_firebuttons[i]);
			}
			for(i = 0; i < _player.employees.length + 1; ++i)	// clear the arrays
			{
				//_firebuttons[i].removeEventListener(MouseEvent.CLICK, onClick(i));
				_employee_textfields.pop();
				_firebuttons.pop();
			}
		}
		
		// parameterized eventListener
		function onClick(i:Number):Function {
			return function(e:MouseEvent):void {
				_doc.soundLibrary.playSound("click");
				// remove the employee
				_player.employees.splice(i,1);
				clearArrays();
				setEmployees();
			}
		}
		
		private function onExitClick(e:MouseEvent):void
		{
			_doc.soundLibrary.playSound("click");
			_carnival.endReport();
		}
	}
	
}
