package code 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MessageEvent extends Event 
	{
		public static const ON_MESSAGE_COMPLETE:String = "onMessageComplete";
		public static const ON_SECTION_COMPLETE:String = "onMessageComplete";
		public static const ON_DIALOG_SELECT:String = "OnDialogSelect";
		
		public var dialogSelected:int = 0;
		
		public function MessageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			//we call the super class Event
			super(type, bubbles, cancelable);
		}	
	}
}