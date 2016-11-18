package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent
	import flash.utils.Timer;
	import flash.display.StageScaleMode;
	
	public class pirateEngine extends MovieClip{
		private var pirateMan:pirateClass = new pirateClass();
		private var treasure:Treasure = new Treasure();
		private var pirateArray:Array = new Array();
		private var pirateTimer:Timer = new Timer (1000, 1);
		
		public var pirate1:Object = { mName: pirateMan, xLocation: 300, yLocation: 0};
		public var pirate2:Object = { mName: pirateMan, xLocation: 600, yLocation: 200};
		public var pirate3:Object = { mName: pirateMan, xLocation: 300, yLocation: 400};
		public var pirate4:Object = { mName: pirateMan, xLocation: 0, yLocation: 200};
		
		public function pirateEngine() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			pirateArray.push(pirate1, pirate2, pirate3, pirate4);
			addAPirate();
			pirateTimer.start();
		}
		
		private function addAPirate():void {
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
				addChild(mName);
				
			}
				
				
			
				//var functionMoveThePirate:Function = moveThePirate(mName);
				//addEventListener(Event.ENTER_FRAME, functionMoveThePirate);
				
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
