package code 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Drew Diamantoukos
	 */
	public class TownPopupBox extends Sprite 
	{
		public function TownPopupBox() 
		{
			
		}	
		
		public function loadInfo(aTown:Town)
		{
			inputName.text = aTown.name;
			inputPop.text = aTown.population.toString();
			inputWealth.text = aTown.wealth.toString();
			inputEmploy.text = aTown.employmentRate.toString();
			inputVisited.text = aTown.visited.toString();
		}
	}
}