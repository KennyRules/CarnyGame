package code 
{
	public class Employee 
	{
		private var _employeeName:String;
		public function get employeeName():String { return _employeeName; }
		
		private var _salary:Number;
		public function get salary():Number { return _salary; }
		
		private var _profit:Number;
		public function get profit():Number { return _profit; }
		
		public function Employee(aName:String, aSalary:Number) 
		{
			_employeeName = aName;
			_salary = aSalary;
		}
		
		public function generateProfit(a:int, b:Number, c:Number):Number	// population, hourly wage, employment rate
		{
			// TO-DO: Determine how much money an employee makes. Probably need extra parameters and/or using town/carnival.
			_profit = int(((((a * c/100) * .05) * b) * (Math.random() *_salary/10 + .3) - _salary)* 100)/100;
			return _profit;
		}
	}
}
