package  {
	
		import flash.display.MovieClip;
		import flash.events.KeyboardEvent;
		import flash.ui.Keyboard;
		import flash.events.Event;
		import flash.display.Sprite;
	
	public class CharacterMovement extends MovieClip {
	
		public var ammoLayer:Sprite = new Sprite();
			public var vx:Number;
			public var vy:Number;
		public var score:Number = 0;
		public var player:Player = new Player;
		public var ammoArray:Array= new Array();
	
		
		
		public function CharacterMovement()  :void {
			// constructor code
			init();
			
		}
		
		private function init():void {
			player.x = 200;
			player.y = 200;
			
			for (var i=0; i < 5; i++){
			makeammoBox();
			}
			
			ammoLayer.addChild(player);
			
			addChild(ammoLayer);
			
			vx = 0;
			vy = 0;
			
			
			
			stage.addEventListener (KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener (KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener (Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function makeammoBox():void {
			
			var ammo:Ammo = new Ammo;
			ammo.x = Math.random() * stage.stageWidth;
			ammo.y = Math.random() * stage.stageHeight;
			
				ammoLayer.addChild(ammo);
				ammoArray.push(ammo);
				
				trace ("added ammobox");
			
			
			
		}
		
		private function onKeyDown (event:KeyboardEvent): void{
			
			if(event.keyCode == Keyboard.A) {
				vx = -5;
			} else if (event.keyCode == Keyboard.D) {
				vx = 5;
			}else if (event.keyCode == Keyboard.W) {
				vy = -5;
			}else if (event.keyCode == Keyboard.S) {
				vy=5;
			}
				
			}
		
		
		private function onKeyUp (event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.A || event.keyCode == Keyboard.D) {
				vx = 0;
			} else if (event.keyCode == Keyboard.S || event.keyCode == Keyboard.W) {
				vy = 0;
			}
			
		}
		
		private function onEnterFrame(event:Event):void {
			player.x += vx;
			player.y += vy;
			
			
			
			for each(var ammo:Ammo in ammoArray){
				
				if (contains(ammo)){
					
				
		if(player.hitTestPoint(ammo.x,ammo.y)) {
			ammoLayer.removeChild(ammo);
				}
			}
		}
			
			
		}
	/*private function ammoHitTest(ammo:Ammo):void{
		
	}*/
			
	}

}		
	

