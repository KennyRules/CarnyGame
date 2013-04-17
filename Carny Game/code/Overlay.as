package code 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author ...
	 */
	public class Overlay extends Sprite
	{
		private var _healthBar:Sprite;
		private var _healthBarWidth:int = 200;
		
		private var _energyBar:Sprite;
		private var _energyBarWidth:int = 200;
		
		private var _barTimer:Timer;
		private var _barDelay:int = 1000; // In seconds.
		
		private var _doc:Document;
		
		public function Overlay(aDoc:Document) 
		{
			_doc = aDoc;
			this.addEventListener(Event.ADDED_TO_STAGE, onStageAdd);
		}
		
		private function onStageAdd(e:Event)
		{
			
		}
	}
}