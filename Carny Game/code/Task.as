package code {
	
	import flash.display.MovieClip;
	import flash.xml.*;
	
	public class Task extends MovieClip
	{
		protected var baseTime:int; //a base amount of time that the task will take, measured in hours
		protected var taskData:XML;
		
		public function Task(t:int)
		{
			baseTime = t;
			taskData = new XML();
		}
		
		//load up an XML file that contains information about the task and dialogue
		//this can be overwritten in subclasses
		public function loadXML(xmlFile:String):void
		{
			taskData.ignoreWhite = true;
			taskData.load(xmlFile);
			taskData.onLoad = function(success)
			{
				if (success)
				{
					var s1:String = taskData.firstChild.childNodes[0];
					var s2:String = taskData.firstChild.childNodes[1];
					
					trace(s1 + " " + s2);
				}
			}
		}
		
		//variable amounts of time for the task
		public function actualTime():int
		{
			//for basic variation just do random number and add it, have range of negative numbers
			var incrementer:int = Math.random() * 10 - 5;
			return incrementer;
		}
	}
}