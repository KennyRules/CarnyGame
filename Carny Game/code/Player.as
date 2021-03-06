﻿package code
{
	public class Player
	{
		private const STARTING_WEALTH:Number = 100;
		private var _wealth:int;
		public function get wealth():int { return _wealth; }
		
		private var _prevWealth:int;
		public function get prevWealth():int { return _prevWealth; }
		public function setprevWealth(w:int) { _prevWealth = w; }
		
		private var _employees:Array;
		public function get employees():Array { return _employees; }
		
		public function Player()
		{
			_wealth = STARTING_WEALTH;
			_prevWealth = STARTING_WEALTH;
			_employees = new Array();
			initEmployees();
		}
		
		private function initEmployees():void
		{
			// TO-DO: Create initial employees instead of default one.
			employees.push(new Employee("Test Employee", 2.50));
		}
		
		public function getPaid(pop:int, hw:Number, er:Number):void	// population, hourly wage, employment rate
		{
			var profit:Number = 0;
			for (var i:uint = 0; i < employees.length; ++i)
			{
				profit += _employees[i].generateProfit(pop, hw, er);
			}
			
			profit *= ((Math.floor(Math.random() * (60 - 30 + 1)) + 30) / 100); 
			//????????????????
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