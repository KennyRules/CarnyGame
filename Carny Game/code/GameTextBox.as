package code 
{
	import code.graphics.NextButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameTextBox extends Sprite 
	{
		private var _textSpeed:Number = 0; // How fast a character displays, in milliseconds. 0 = instant.
		private var _textField:TextField;
		private var _textFormat:TextFormat = new TextFormat("Arial", 20, 0x000000, null, null, null, null, null, null, null, null, null, 5); // Font, Size, color, leading are set.
		private var _textFieldTimer:Timer;
		private var _textHeight:int = 0;
		
		private var _message:String = "";
		private var _numLines:int = 2; // How many lines we want displayed at a time.
		
		private var _nextButton:NextButton;
		
		public function GameTextBox(aMessage:String) 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onStageAdd);
			_message = aMessage;
		}
		
		private function onStageAdd(e:Event):void
		{
			initTextField();
			addNextButton();
			loadMessage(_message);
		}
		
		private function initTextField():void
		{
			_textField = new TextField();
			addChild(_textField);
			
			// We need a quick dummy text to get the textHeight with our set text formating.
			_textField.text = ".";
			_textField.setTextFormat(_textFormat);
			_textField.height = _textField.textHeight * _numLines + int(_textField.getTextFormat().leading) * _numLines;
			_textField.text = "";
			
			_textField.width = stage.stageWidth;
			_textField.x = 0;	
			_textField.y = stage.stageHeight - _textField.height;
			_textHeight = _textField.textHeight;
			_textField.border = true;
			_textField.multiline = true;
			_textField.wordWrap = true;
			_textField.selectable = false;
			_textField.background = true;
		}
		
		public function loadMessage(aMessage:String):void
		{
			_textField.text = "";
			if (_textSpeed == 0)
			{
				addText(aMessage);
				_nextButton.addEventListener(MouseEvent.CLICK, onMouseClick);
			}
			else
			{
				_message = aMessage;
				_textFieldTimer = new Timer(_textSpeed);
				_textFieldTimer.addEventListener(TimerEvent.TIMER, onTimerTick);
				_textFieldTimer.start();
				_nextButton.removeEventListener(MouseEvent.CLICK, onMouseClick);
			}
		}
		
		// Add the next character in the message to the text field.
		private function onTimerTick(e:TimerEvent):void 
		{
			if ((e.target as Timer).currentCount <= _message.length)
			{
				addText(_message.charAt((e.target as Timer).currentCount - 1));
				
				// If we made a new line, scroll down to it.
				if (_textField.maxScrollV >= _numLines)
				{
					_textField.scrollV++;
				}
			}
			// If we're at the end of the message, remove the timer.
			else
			{
				removeTimer();
				_nextButton.addEventListener(MouseEvent.CLICK, onMouseClick);
			}
		}
		
		// Load text into the message box and reset the formatting.
		private function addText(aString:String):void
		{
			_textField.appendText(aString);
			_textField.setTextFormat(_textFormat);
		}
		
		private function removeTimer():void
		{
			_textFieldTimer.removeEventListener(TimerEvent.TIMER, onTimerTick);
			_textFieldTimer.stop();
		}
		
		private function addNextButton():void
		{
			_nextButton = new NextButton();
			addChild(_nextButton);
			
			
			_nextButton.x = stage.stageWidth - _nextButton.width;
			_nextButton.y = stage.stageHeight - _textField.height - _nextButton.height;
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE_COMPLETE));
		}
	}
}