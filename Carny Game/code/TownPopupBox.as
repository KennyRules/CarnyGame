package code 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Drew Diamantoukos
	 */
	public class TownPopupBox extends Sprite 
	{
		private var _town:Town;
		public function get town():Town { return _town; }
		
		public function TownPopupBox() 
		{
			_town = null;
		}	
		
		public function loadInfo(aTown:Town):void
		{
			_town = aTown;
			inputName.text = _town.townName;
			inputPop.text = _town.population.toString();
			inputWealth.text = _town.wealth.toString();
			inputEmploy.text = _town.employmentRate.toString() + "%";
			inputVisited.text = _town.visited.toString();
		}
		
		public function unloadInfo():void
		{
			_town = null;
		}
	}
}