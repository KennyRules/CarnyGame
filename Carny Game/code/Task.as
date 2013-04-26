package code {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.*;
	
	public class Task extends MovieClip
	{
		protected var baseTime:int; //a base amount of time that the task will take, measured in hours
		protected var taskData:XML;
		protected var xmlLoader:URLLoader;
		
		public function Task(t:int)
		{
			baseTime = t;
			xmlLoader = new URLLoader();
		}
		
		//load up an XML file that contains information about the task and dialogue
		//this can be overwritten in subclasses
		public function loadXML(xmlFile:String):void
		{
			xmlLoader.load(new URLRequest(xmlFile));
			xmlLoader.addEventListener(Event.COMPLETE, processXML);

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
		
		public function processXML(e:Event):void
		{
			taskData = new XML(e.target.data);
			trace(taskData);
		}
		/**
		*/
		
		//variable amounts of time for the task
		public function actualTime():int
		{
			//for basic variation just do random number and add it, have range of negative numbers
			var incrementer:int = Math.random() * 10 - 5;
			return incrementer;
		}
	}
}