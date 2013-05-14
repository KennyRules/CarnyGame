package code {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.*;
	
	public class Task extends MovieClip
	{
		protected var baseTime:int; //a base amount of time that the task will take, measured in hours
		protected var currentTask:String;
		protected var xmlFile:String;
		protected var taskXML:XMLList;
		protected var xmlLoader:URLLoader;
		
		//private var _doc:Document;
		private var _currentXML:XMLList;
		private var _currentIndex:int;
		private var _gameTextBox:GameTextBox;
		private var _gameDialogBox:GameDialogBox;
		
		public function Task(fileName:String)
		{
			baseTime = 0; //will be set by xml
			xmlLoader = new URLLoader();
			xmlFile = fileName;
		}
		
		//load up an XML file that contains information about the task and dialogue
		//this can be overwritten in subclasses
		public function loadXML(taskName:String):void
		{
			currentTask = taskName;
			xmlLoader.load(new URLRequest(xmlFile));
			xmlLoader.addEventListener(Event.COMPLETE, processXML);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadingError);
		}
		
		private function processXML(e:Event):void
		{
			taskXML = new XMLList(e.target.data);
			loadXMLSection(currentTask);
		}
		
		private function onLoadingError(e:Event):void
		{
			trace("XML file did not load correctly"); 
		}
		
		private function loadXMLSection(id:String):void
		{
			_currentXML = null;
			_currentIndex = 0;
			for each (var xmlPiece:XML in taskXML.child("Task"))
			{
				//only load the task we need, can be identified by id attribute of task
				//if (taskXML.Task.@id == id)
					_currentXML = XMLList(xmlPiece);
			}

			if (_currentXML != null)
			{
				_gameTextBox = new GameTextBox(_currentXML.Text[_currentIndex]);
				addChild(_gameTextBox);
				_gameTextBox.addEventListener(MessageEvent.ON_MESSAGE_COMPLETE, onMessageComplete);
			}
		}
		
		private function onMessageComplete(e:MessageEvent):void
		{
			// Checks null attribute - (_overworldXML.child(_currentChild).Text[_currentIndex].@index).toString() == ""
			// .name() gets the node name.

			if (_currentXML == null)
			{
				clearMessageBox();
				return;
			}

			_currentIndex++;
			// If there is a node to evaluate within bounds.
			if (_currentIndex < _currentXML.children().length())
			{
				// Make sure it is a Text node.
				var nodeName:String = _currentXML.child(_currentIndex).name();
				if (nodeName == "Text")
				{
					_gameTextBox.loadMessage(_currentXML.children()[_currentIndex]);
				}
				// If it is a Dialog node, make this node the new current node to generate messages from.
				else if (nodeName == "Dialog")
				{
					_currentXML = _currentXML.child(_currentIndex).children();
					addDialogBox();
					_gameTextBox.removeEventListener(MessageEvent.ON_MESSAGE_COMPLETE, onMessageComplete);
				}
				else if (nodeName == "Task")
				{
					clearMessageBox();
				}
				return;
			}
			// If we are out of bounds, see if there is more text in a parent node.
			else
			{
				if (_currentXML.parent() != null)
				{
					// We need to find the node whose parent isn't a Dialog node.
					while (_currentXML.parent().name() == "Dialog")
					{
						_currentXML = XMLList(_currentXML.parent());
					}

					// Now, find the position of this node in the parent of the current node. This is where we continue the tree.
					for (var i:int = 0; i < _currentXML.parent().children().length(); i++ )
					{
						if (_currentXML.parent().child(i) == _currentXML)
						{
							_currentIndex = i;
							_currentXML = XMLList(_currentXML.parent()); // Set the current node to the parent. This is where we left off from.
							// Add and dispatch the events to display new text.
							_gameTextBox.addEventListener(MessageEvent.ON_MESSAGE_COMPLETE, onMessageComplete);
							onMessageComplete(new MessageEvent(MessageEvent.ON_MESSAGE_COMPLETE));
							return;
						}
					}
				}
				clearMessageBox();
			}
		}
		
		private function addDialogBox():void
		{
			var choices:Array = new Array();
			for (var i:int = 0; i < _currentXML.length(); i++)
			{
				choices.push(_currentXML[i].@choice);
			}

			_gameDialogBox = new GameDialogBox(choices);
			addChild(_gameDialogBox);
			_gameDialogBox.x = stage.stageWidth - _gameDialogBox.width;
			_gameDialogBox.y = stage.stageHeight / 2 - _gameDialogBox.height / 2;
			_gameDialogBox.addEventListener(MessageEvent.ON_DIALOG_SELECT, onDialogSelect);
		}
		
		// Remove the dialog box, continue reading text from the xml tree from the choice selected.
		private function onDialogSelect(e:MessageEvent):void
		{
			_gameDialogBox.removeEventListener(MessageEvent.ON_DIALOG_SELECT, onDialogSelect);
			removeChild(_gameDialogBox);

			if (_currentXML[e.dialogSelected].@flag != null)
			{
				switch ((_currentXML[e.dialogSelected].@flag).toString())
				{

				}
			}
			_currentIndex = 0;
			_currentXML = XMLList(_currentXML[e.dialogSelected]);
			_gameTextBox.loadMessage(_currentXML.Text[_currentIndex]);
			_gameTextBox.addEventListener(MessageEvent.ON_MESSAGE_COMPLETE, onMessageComplete);
		}
		
		private function clearMessageBox():void
		{
			_gameTextBox.removeEventListener(MessageEvent.ON_MESSAGE_COMPLETE, onMessageComplete);
			removeChild(_gameTextBox);
			this.addEventListener(MouseEvent.CLICK, onTaskEnd);
		}
		
		private function onTaskEnd():void
		{
			//TODO: add functionality to when what happens after a task
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