package code 
{
	public class Employee 
	{
		private var _employeeName:String;
		public function get employeeName():String { return _employeeName; }
		
		private var _salary:Number;
		public function get salary():Number { return _salary; }
		
		public function Employee(aName:String, aSalary:Number) 
		{
			_employeeName = aName;
			_salary = aSalary;
		}
		
		public function generateProfit():Number
		{
			// TO-DO: Determine how much money an employee makes. Probably need extra parameters and/or using town/carnival.
			return Math.random() * 200;
		}
	}
}
