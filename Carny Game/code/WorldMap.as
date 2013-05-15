package code 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Drew Diamantoukos
	 */
	public class WorldMap extends MovieClip 
	{
		private const MAX_TOWNS:int = 11;
		private const MAX_DAYS:int = 7;
		
		private var gameScreenManager:GameScreens;
		private var towns:Array;
		private var townPopup:TownPopupBox;
		
		private var _doc:Document;
		private var _mapXml:XMLList;
		private var _currentXML:XMLList;
		private var _gameTextBox:GameTextBox;
		private var _gameDialogBox:GameDialogBox;
		private var _player:Player;
		private var _currentTown:Town;
		private var _daysLeft:int;
		private var _currentIndex:int;
		private var _currentSection:String;
		
		public function get GameScreenManager():GameScreens { return gameScreenManager; }
		public function get player():Player { return _player; }
		public function get currentTown():Town { return _currentTown; }
		public function get daysLeft():int { return _daysLeft; }
		
		public function WorldMap(aManager:GameScreens)
		{
			gameScreenManager = aManager;
			_player = gameScreenManager.player;
			
			towns = new Array();
			_currentTown = null;
			_mapXml = null;
			_currentXML = null;
			
			initTowns();
			_daysLeft = MAX_DAYS;
			
			_doc = gameScreenManager.Doc;
			
			townPopup = new TownPopupBox();
			
			addChild(townPopup);
			townPopup.visible = false;
			updateInfo();
			
			//var textUrlLoader:URLLoader = new URLLoader(new URLRequest("WorldMapText.xml"));
			//textUrlLoader.addEventListener(Event.COMPLETE, onTextLoadComplete);
		}
		
		public function addEventListeners():void
		{
			townPopup.btnTravel.addEventListener(MouseEvent.CLICK, onTravelClick);
			this.addEventListener(MouseEvent.CLICK, onWorldClick);
		}
		
		private function onTextLoadComplete(e:Event):void
		{
			_mapXml = new XMLList(e.target.data);
			loadXmlSection();
		}
		
		// Call when day at carnival is done.
		public function returnToOverworld():void
		{
			_daysLeft--;
			if (_daysLeft > 0)
			{
				updateInfo();
				gameScreenManager.changeLocation("World Map");
			}
			else
			{
				// TO-DO: Handle the end of game, evaluation, etc.
			}
		}
		
		private function onWorldClick(e:MouseEvent):void
		{			
			if (e.target is Town)
			{
				_doc.soundLibrary.playSound("click");			// PLAY A SOUND
				
				if (_currentTown)
				{
					// TO-DO: Pop-up message detailing travel plans, etc.
				}
				
				showPopup(e.target as Town);
			}
			else
			{
				townPopup.visible = false;
				townPopup.unloadInfo();
			}
		}
		
		public function showPopup(aTown:Town):void
		{
			// Don't move the popup box if it's the same town.
			if (townPopup.town == aTown)
				return;
				
			townPopup.visible = true;
			townPopup.loadInfo(aTown);
			townPopup.x = mouseX;
			townPopup.y = mouseY;
			
			// Make sure the entire pop-up box fits in the window.
			if (townPopup.x + townPopup.width >= stage.stageWidth)
				townPopup.x -= (townPopup.x + townPopup.width - stage.stageWidth);
				
			if (townPopup.y + townPopup.height >= stage.stageHeight)
				townPopup.y -= (townPopup.y + townPopup.height - stage.stageHeight);
		}
		
		private function onTravelClick(e:MouseEvent):void
		{
			_currentTown = townPopup.town;
			_currentTown.visitTown();
			gameScreenManager.changeLocation("Overhead Carnival");
		}
		
		private function updateInfo():void
		{
			worldUI.txtDaysLeft.text = _daysLeft;
			worldUI.txtWealth.text = player.wealth;
		}
		
		// Loads a new section of the XML to display.
		private function loadXmlSection():void
		{
			_currentXML = null;
			_currentIndex = 0;
			for each (var xmlPiece:XML in _mapXml.child("Task"))
			{
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
				else if (nodeName == "Section")
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

					// Now, fina the position of this node in the parent of the current node. This is where we continue the tree.
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

		private function clearMessageBox():void
		{
			_gameTextBox.removeEventListener(MessageEvent.ON_MESSAGE_COMPLETE, onMessageComplete);
			removeChild(_gameTextBox);
			this.addEventListener(MouseEvent.CLICK, onWorldClick);
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
		
		private function initTowns():void
		{
			var aTown:Town = new Town(this, "Nebraska Far Left", Math.round(Math.random() * 1000 + 1500), int(Math.random() * 40 + 35)/100, Math.round(Math.random() * 4 + 18));
			aTown.x = 111;
			aTown.y = 122;
			addChild(aTown);
			towns.push(aTown);
			
			aTown = new Town(this, "Nebraska Far right", Math.round(Math.random() * 1430 + 1536), int(Math.random() * 40 + 35)/100, Math.round(Math.random() * 4 + 18));
			aTown.x = 460;
			aTown.y = 265;
			addChild(aTown);
			towns.push(aTown);
			
			aTown = new Town(this, "Iowa Top", Math.round(Math.random() * 1500 + 1500), int(Math.random() * 35 + 25)/100, Math.round(Math.random() * 2 + 20));
			aTown.x = 520;
			aTown.y = 105;
			addChild(aTown);
			towns.push(aTown);
			
			aTown = new Town(this, "Iowa Left", Math.round(Math.random() * 1000 + 1563), int(Math.random() * 40 + 35)/100, Math.round(Math.random() * 5 + 18));
			aTown.x = 560;
			aTown.y = 200;
			addChild(aTown);
			towns.push(aTown);
			
			aTown = new Town(this, "Iowa Right", Math.round(Math.random() * 1340 + 1536), int(Math.random() * 40 + 35)/100, Math.round(Math.random() * 4 + 18));
			aTown.x = 796;
			aTown.y = 188;
			addChild(aTown);
			towns.push(aTown);
			
			aTown = new Town(this, "Missouri Top", Math.round(Math.random() * 1340 + 1134), int(Math.random() * 40 + 35)/100, Math.round(Math.random() * 4 + 23));
			aTown.x = 643.5;
			aTown.y = 325;
			addChild(aTown);
			towns.push(aTown);
			
			aTown = new Town(this, "Missouri Right", Math.round(Math.random() * 1340 + 1490), int(Math.random() * 35 + 25)/100, Math.round(Math.random() * 4 + 18));
			aTown.x = 786.5;
			aTown.y = 412;
			addChild(aTown);
			towns.push(aTown);
			
			aTown = new Town(this, "Missouri Bottom", Math.round(Math.random() * 1035 + 1334), int(Math.random() * 40 + 35)/100, Math.round(Math.random() * 4 + 18));
			aTown.x = 640;
			aTown.y = 508;
			addChild(aTown);
			towns.push(aTown);
			
			aTown = new Town(this, "Kansas Right", Math.round(Math.random() * 1643 + 1732), int(Math.random() * 40 + 15)/100, Math.round(Math.random() * 5 + 18));
			aTown.x = 556;
			aTown.y = 548;
			addChild(aTown);
			towns.push(aTown);
			
			aTown = new Town(this, "Kansas Bottom", Math.round(Math.random() * 1340 + 1553), int(Math.random() * 35 + 35)/100, Math.round(Math.random() * 5 + 18));
			aTown.x = 320;
			aTown.y = 516;
			addChild(aTown);
			towns.push(aTown);
			
			aTown = new Town(this, "Kansas Top", Math.round(Math.random() * 1230 + 1540), int(Math.random() * 40 + 35)/100, Math.round(Math.random() * 4 + 21));
			aTown.x = 214;
			aTown.y = 380;
			
			addChild(aTown);
			towns.push(aTown);

			
			
		}
	}
}