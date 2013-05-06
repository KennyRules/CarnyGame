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
		private var _employee_textfields:Array;	// array of the employee text fields
		
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
			
			// assign values to the textfield stuff
			_leftAlign = (this.x - width * 2) + 10;
			_spaceBetween = 5;
			_boxHeight = 30;
			_startingY = textbox_title.y + 40;
			
			// Set up the report menu
			setDay();
			setIncome();
			setEmployees();
		}
		
		// Will make the title say "End of Day XX"
		private function setDay()
		{
			textbox_title.text = "End of week " + _town.worldMap.weeksLeft;
		}
		
		// Will display the income data
		private function setIncome()
		{
			textbox_money.text = "Total money: $" + _player.wealth;
		}
		
		//  Display our list of employees
		private function setEmployees()
		{
			for(var i = 0; i < _player.employees.length; ++i)
			{
				var tf:TextField = new TextField();	// textfield for each employee
				
				tf.x = -270;					// set x and y coords
				tf.y = -150 + (_spaceBetween * i);
				tf.height = _boxHeight;				// set the textfield height
								
				tf.text = _player.employees[i].employeeName;	// set the name of the employee
				addChild(tf);
				
				var button:FireButton = new FireButton(i);		// make the firing button
				button.y = tf.y + 8;
				button.x = 200;
				addChild(button);
				
				button.addEventListener(MouseEvent.CLICK, onClick(i));
			}
		}
		
		// parameterized eventListener
		function onClick(i:Number):Function {
			return function(e:MouseEvent):void {
				// remove the employee
				_player.employees.splice(i,1);
				_employee_textfields.splice(i,1);
			}
		}
		
	}
	
}
