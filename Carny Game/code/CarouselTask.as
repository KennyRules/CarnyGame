package code 
{
	/**
	 * ...
	 * @author ...
	 */
	public class CarouselTask extends Task 
	{
		
		public function CarouselTask() 
		{
			
		}
		
		override public function loadXML(xmlFile:XML):void
		{
			taskData.ignoreWhite = true;
			taskData.load(xmlFile);
			taskData.onLoad = function(success)
			{
				if (success)
				{
					
				}
			}
		}
	}

}