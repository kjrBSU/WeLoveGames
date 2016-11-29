﻿
package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent
	import flash.utils.Timer;
	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	
	public class pirateEngine extends MovieClip{
		private var pirateLayer:Sprite = new Sprite();
		
		private var pirateMan:pirateClass = new pirateClass();
		private var pirateGoal:piratePad = new piratePad();
		private var pirateWithTreasure:treasurePirate = new treasurePirate();
		private var treasure:Treasure = new Treasure();
		private var pirateArray:Array = new Array();
		private var pirateTimer:Timer = new Timer (5000);
		
		public var pirate1:Object = { mName: pirateMan, xLocation: 300, yLocation: 0};
		public var pirate2:Object = { mName: pirateMan, xLocation: 600, yLocation: 200};
		public var pirate3:Object = { mName: pirateMan, xLocation: 300, yLocation: 400};
		public var pirate4:Object = { mName: pirateMan, xLocation: 0, yLocation: 200};
		
		public function pirateEngine() {
			addChild(pirateLayer);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			pirateArray.push(pirate1, pirate2, pirate3, pirate4);
			pirateTimer.addEventListener(TimerEvent.TIMER, addAPirate);
			addEventListener(Event.ENTER_FRAME, didPirateHitTreasure);
			addEventListener(Event.ENTER_FRAME, pirateHitTest);
			
			pirateGoal.x = 300;
			pirateGoal.y = 0;
			pirateLayer.addChild(pirateGoal);
			
			treasure.x = stage.stageWidth/2;
			treasure.y = stage.stageHeight/2;
			pirateLayer.addChild(treasure);
			pirateTimer.start();
		}
		private function pirateHitTest(e:Event):void 
		{
			if(pirateMan.hitTestPoint(mouseX, mouseY) && pirateMan.status == "Alive"){
				pirateLayer.removeChild(pirateMan);
				//fixed? 
				//removeEventListener(Event.ENTER_FRAME, pirateHitTest);
				pirateMan.status = "Dead";
			}
		}
		
		private function didPirateHitTreasure(e:Event):void 
		{
				
					if(pirateMan.hitTestPoint(treasure.x, treasure.y) && pirateMan.status == "Alive") {
						pirateWithTreasure.x = pirateMan.x;
						pirateWithTreasure.y = pirateMan.y;
						pirateLayer.removeChild(treasure);
						pirateLayer.removeChild(pirateMan);
						addChild(pirateWithTreasure);
						removeEventListener(Event.ENTER_FRAME, didPirateHitTreasure);
						removeEventListener(Event.ENTER_FRAME, movePirateToTreasure);
						pirateTimer.removeEventListener(TimerEvent.TIMER, addAPirate);
						pirateWithTreasure.addEventListener(Event.ENTER_FRAME, movePirateToPad);
					}
		}
		
		private function movePirateToPad(e:Event):void
		{
			var speed = 5;
					if(e.currentTarget.x > pirateGoal.x)
					{
						e.currentTarget.x -= speed;
						
					}
					else if(e.currentTarget.x < pirateGoal.x)
					   {
						   e.currentTarget.x += speed;
					   }
					 else if (e.currentTarget.y > pirateGoal.y)
					 {
						 e.currentTarget.y -= speed;
					 }
					 else if (e.currentTarget.y < pirateGoal.y)
					 {
						 e.currentTarget.y += speed;
					 }
			
		}
		
		private function addAPirate(timer:TimerEvent):void {
			var mName:pirateClass = new pirateClass();
			var pirateX:Number;
			var pirateY:Number;
			
			pirateTimer.reset();
			trace("timer done");
			var i:Number;
			
			for (var j:int = 0; j < 1; j++) {
			for (var element:String in pirateArray[i = Math.floor(Math.random()*pirateArray.length)]) {
				
					if(element == "mName" && element != "xLocation" && element != "yLocation") {
						mName = pirateArray[i][element];
						trace (mName);
					}
					else if (element == "xLocation" && element != "mName" && element != "yLocation") {
						trace (pirateArray [i][element]);
						pirateX = pirateArray[i][element];
						
					}
					else if (element == "yLocation" && element != "mName" && element != "xLocation") {
						trace (pirateArray[i][element]);
						pirateY = pirateArray[i][element];
						

					}
					
				}
				trace(i);
				mName.x = pirateX;
				mName.y = pirateY;
				mName.status = "Alive";
				pirateLayer.addChild(mName);
				
				pirateTimer.start();
				
			}
				
				
			
				mName.addEventListener(Event.ENTER_FRAME, movePirateToTreasure);
				
			}
			
			
			private function movePirateToTreasure():void
				{
					var speed = 5;
					if(e.currentTarget.x > treasure.x)
					{
						e.currentTarget.x -= speed;
						
					}
					else if(e.currentTarget.x < treasure.x)
					   {
						   e.currentTarget.x += speed;
					   }
					 else if (e.currentTarget.y > treasure.y)
					 {
						 e.currentTarget.y -= speed;
					 }
					 else if (e.currentTarget.y < treasure.y)
					 {
						 e.currentTarget.y += speed;
					 }
					 
					  
					}
			/*
			private function moveThePirate(pirate:pirateClass):Function {
				  return function(e:Event):void {
					movePirate();
				  };
			}
			
			public function movePirate ():void {
			
			this.x += zFriction (this.x, treasure.x, 1);
			this.y += zFriction (this.y, treasure.y, 1);
			}
			public function zFriction (startPosition:Number, destination:Number, coeff:Number):Number{
				return (destination-startPosition)/coeff;
			}
			*/
			
			
		/*	if(myNum <= 5){
				addPirate_Left_Right(pirateMan);
			}else if (myNum > 5){
				addPirate_Top_Bottom(pirateMan);
			}*/
		
		
		/*
		private function addPirate_Left_Right( pirate:pirateClass ):void
		{
			trace("got to move pirate left and right");
			pirate.y = 200;
			  //Get a random number
			  var random:Number = Math.ceil(Math.random()*10);

			  //If the number is even , place the zombie on the right
			  if( random <= 5 )
			  {
				  //add the zombie outside the stage
				  pirate.x == 500;
				  trace("placed pirate on the right of the stage");

			  }else if(random > 5) { //otherwise , place it on the left

				   //add the pirate outside the stage
				   pirate.x = -10;
				  trace("placed pirate on left of stage");
			  }
			  stage.addEventListener(Event.ENTER_FRAME, movePirate_Left_Right);

			  addChild( pirate );
			  pirateArray.push(pirate);
			  pirateTimer.start();

		}
		private function movePirate_Left_Right(e:Event):void {
			for each(var pirate:pirateClass in pirateArray){
				if(pirate.x < stage.stageWidth/2){
					pirate.pirateMoveRight();
					trace("moving pirate right");
				}
				else if(pirate.x > stage.stageWidth/2 +1){
					pirate.pirateMoveLeft();
					trace("moving pirate left");
				}
			}
		}
		private function addPirate_Top_Bottom( pirate:pirateClass ):void
		{
			trace("got to move pirate top and bottom");
			pirate.x = 200;
			  //Get a random number
			  var random:Number = Math.ceil(Math.random()*10);
			
				
			  //If the number is even , place the zombie on the top
			  if( random <= 5 )
			  {
				  //add the zombie outside the stage
				  trace("inside the  first if statement");
				  pirate.y == -10

			  }else if (random > 5){ //otherwise , place it on the bottom

				   //add the pirate outside the stage
				   trace("inside the second if statement");
				   pirate.y = stage.stageHeight+10;
			  }
			  stage.addEventListener(Event.ENTER_FRAME, movePirate_Up_Down);

			  addChild( pirate );
			  pirateArray.push(pirate);
			  
			  pirateTimer.start();

		}
		private function movePirate_Up_Down(e:Event):void {
			for each(var pirate:pirateClass in pirateArray){
				if(pirate.y < stage.stageHeight/2 ){
					pirate.pirateMoveDown();
					trace("moving pirate down");
				}
				else if(pirate.y > stage.stageHeight/2 + 1){
					pirate.pirateMoveUp();
					trace("moving pirate up");
				}
			}
		} */

	}
	
}
