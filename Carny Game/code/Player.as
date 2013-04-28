package code
{
	public class Player
	{
		private const STARTING_WEALTH:Number = 1000;
		private var _wealth:int;
		public function get wealth():int { return _wealth; }
		
		private var _employees:Array;
		public function get employees():Array { return _employees; }
		
		public function Player()
		{
			_wealth = STARTING_WEALTH;
			_employees = new Array();
			initEmployees();
		}
		
		private function initEmployees():void
		{
			// TO-DO: Create initial employees instead of default one.
			employees.push(new Employee("Test Employee", 100));
		}
		
		public function getPaid():void
		{
			var profit:Number = 0;
			for (var i:uint = 0; i < employees.length; ++i)
			{
				profit += (_employees[i].generateProfit() - _employees[i].salary);
			}
			
			profit *= ((Math.floor(Math.random() * (60 - 30 + 1)) + 30) / 100); 
			_wealth += profit;
		}
		
		public function hireEmployee(anEmployee:Employee):void
		{
			employees.push(anEmployee);
		}
		
		public function fireEmployee(anEmployee:Employee):void
		{
			employees.splice(employees.indexOf(anEmployee), 1);
		}
	}
}