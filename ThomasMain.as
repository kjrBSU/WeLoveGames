﻿package {

	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import Player;
	import Particle;
	import Pirate;
	import Treasure;




	public class ThomasMain extends MovieClip {

		private var player: Player;
		private var background: Map = new Map();
		private var bullet: Bullet;
		private var bullets: Array;
		private var shotAngle: Number;

		private var pirateMan: Pirate = new Pirate();
		//private var pirateHealth: pirateHealthBar = new pirateHealthBar();
		private var pirateWithTreasure: Boolean = false;
		private var treasure: Treasure = new Treasure();
		private var piratePad: Point = new Point();
		private var pirateArray: Array = new Array();
		private var pirates: Array = new Array();
		private var pirateTimer: Timer = new Timer(10000);

		public var pirate1: Object = {
			mName: pirateMan,
			xLocation: background.width / 2,
			yLocation: background.height - background.height
		};
		public var pirate2: Object = {
			mName: pirateMan,
			xLocation: background.width,
			yLocation: background.height / 2
		};
		public var pirate3: Object = {
			mName: pirateMan,
			xLocation: background.width / 2,
			yLocation: background.height
		};
		public var pirate4: Object = {
			mName: pirateMan,
			xLocation: background.width - background.width,
			yLocation: background.height / 2
		};

		public var skeleton: Skeleton = new Skeleton();

		public function ThomasMain() {
			bullets = new Array();

			background.x = 0;
			background.y = 0;
			addChild(background);

			player = new Player();
			player.x = stage.stageWidth / 2;
			player.y = stage.stageHeight / 2;
			addChild(player);

			treasure.x = background.width / 2;
			treasure.y = background.height / 2;
			addChild(treasure);
			
			//pirateHealth.width = 100;

			skeleton.x = background.width / 2;
			skeleton.y = background.height / 2;
			addChild(skeleton);
			skeleton.target = player;
			
			/*boneyBullet.x = background.width / 2;
			boneyBullet.y = background.height / 2 + 100;
			addChild(boneyBullet);*/
			
			

			pirateArray.push(pirate1, pirate2, pirate3, pirate4);


			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(MouseEvent.MOUSE_DOWN, fireBullet);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			pirateTimer.addEventListener(TimerEvent.TIMER, addAPirate);

			pirateTimer.start();
		}

		private function fireBullet(evt: MouseEvent): void {
			var shot: Particle;

			shot = new Bullet();

			shot.x = player.x;
			shot.y = player.y;

			shot.interacts = true;

			shot.xVel = Math.cos(shotAngle) * player.speed * 30;
			shot.yVel = Math.sin(shotAngle) * player.speed * 30;
			if (player.ammo > 0) {
				addChild(shot);
				bullets.push(shot);
				player.ammo -= 1;
			}
			trace(player.ammo);

		}

		private function keyDownHandler(evt: KeyboardEvent): void {
			//87=w 68=d 83=s 65=a
			if (evt.keyCode == 87) {
				player.yVel = -20;
			} else if (evt.keyCode == 83) {
				player.yVel = 20;
			} else if (evt.keyCode == 68) {
				player.xVel = 20;
			} else if (evt.keyCode == 65) {
				player.xVel = -20;
			}
		}

		private function keyUpHandler(evt: KeyboardEvent): void {
			//87=w 68=d 83=s 65=a
			if (evt.keyCode == 87 || evt.keyCode == 83) {
				player.yVel = 0;
			} else if (evt.keyCode == 68 || evt.keyCode == 65) {
				player.xVel = 0;
			}
		}

		private function update(evt: Event): void {
			if (pirateMan.currentFrame == 1) {
				movePirateToTreasure(pirateMan);
			} else if (pirateMan.currentFrame == 2) {
				movePirateToPad(pirateMan);
			}
			didPirateHitTreasure(pirateMan);
			
			/*for each(var b: Bullet in bullets) {
				didBulletHitPirate(b);
			}*/
			
			camera(player);

			player.update();

			shotAngle = Math.atan2(stage.mouseY - stage.stageHeight / 2, stage.mouseX - stage.stageWidth / 2);

			var playerAngle: Number = shotAngle * 180 / Math.PI;

			player.rotation = playerAngle;

			for each(var bullet: Particle in bullets) {

				bullet.update();

				if (bullet.life <= 0) {
					killBullet(bullet);
				} else if(bullet.interacts){
						for each(var targetPirate:Pirate in pirates){
							if(targetPirate.hitTestPoint(bullet.x, bullet.y)){
								targetPirate.life -= 100;
								killBullet(bullet);
								break;
							}
						}
					}
				}
			
			for each(var pirate:Pirate in pirates){
				if(pirate.life == 0){
					killPirate(pirate);
				}
			}
			skeleton.update();
			skeleBump();
		}
		
		private function killPirate(pirate:Pirate):void {
			if(contains(pirate)){
				try{
					var i:int;
					for(i=0; i<pirates.length; i++){
						if(pirates[i].name == pirate.name){
							pirates.splice(i, 1);
							background.removeChild(pirate);
							i = pirates.length;
						}
					}
				}
				catch(e:Error){
					trace("failed to delete pirate", e);
				}
			}
		}
		//private function didBulletHitPirate(bullet: Particle): void {

		//	for each(var pirate: Pirate in pirates) {
		//		if (contains(pirate) && contains(pirateHealth)) {
		//			if (pirate.hitTestPoint(bullet.x, bullet.y) && pirate.status == "Alive") {
		//				pirateHealth.width -= 50;
		//				killBullet(bullet);

		//			}
		//			if (pirateHealth.width < 1) {
		//				//pirateHealth.width = 100;
		//				pirate.removeChild(pirateHealth);
		//				//pirateHealth = null;
		//				//pirateHealth = new pirateHealthBar;
		//				
		//				background.removeChild(pirate);
		//				
		//			}
		//		}
		//	}
		//}

		private function camera(char: Sprite): void {
			root.scrollRect = new Rectangle(char.x - stage.stageWidth / 2, char.y - stage.height / 2, stage.stageWidth, stage.stageHeight);
		}

		private function killBullet(bullet: Particle): void {
			try {
				var i: int;
				for (i = 0; i < bullets.length; i++) {
					if (bullets[i].name == bullet.name) {
						bullets.splice(i, 1);
						removeChild(bullet);

						/*if (bullet.interacts)
						{
							var j:int;
							for (j = 0; j < splodeNum; j++)
							{
								var splode:Particle = new Explosion();
								splode.scaleX = splode.scaleY = 1 + Math.random();
								splode.x = arrow.x;
								splode.y = arrow.y;
								splode.xVel = Math.random() * splodeSpread - splodeSpread / 2;
								splode.yVel = Math.random() * splodeSpread - splodeSpread / 2;
								splode.life = 20;
								splode.interacts = false;
								arrows.push(splode);
								particlesLayer.addChild(splode);
							}
						}*/

						i = bullets.length;
					}
				}
			} catch (e: Error) {
				trace("Failed to delete bullet!", e);
			}
		}

		private function addAPirate(timer: TimerEvent): void {
			var mName = pirateMan;
			var pirateX: Number;
			var pirateY: Number;

			pirateTimer.reset();
			trace("timer done");
			var i: Number;

			for (var j: int = 0; j < 1; j++) {
				for (var element: String in pirateArray[i = Math.floor(Math.random() * pirateArray.length)]) {

					if (element == "mName" && element != "xLocation" && element != "yLocation") {
						mName = pirateArray[i][element];
						trace(mName);
					} else if (element == "xLocation" && element != "mName" && element != "yLocation") {
						trace(pirateArray[i][element]);
						pirateX = pirateArray[i][element];

					} else if (element == "yLocation" && element != "mName" && element != "xLocation") {
						trace(pirateArray[i][element]);
						pirateY = pirateArray[i][element];


					}

				}
				trace(i);
				mName.x = pirateX;
				mName.y = pirateY;
				mName.status = "Alive";
				background.addChild(mName);
				mName.gotoAndStop(1);
				pirates.push(mName);

				pirateTimer.start();

			}


		}

		private function setPiratePad(): void {

			var padX: Number;
			var padY: Number;
			var i: uint;

			for (var j: int = 0; j < 1; j++) {
				for (var element: String in pirateArray[i = Math.floor(Math.random() * pirateArray.length)]) {

					if (element == "xLocation" && element != "yLocation") {

						padX = pirateArray[i][element];

					} else if (element == "yLocation" && element != "xLocation") {

						padY = pirateArray[i][element];
					}
					piratePad.x = padX;
					piratePad.y = padY;

				}
			}
		}
		private function movePirateToPad(pirate: Pirate): void {
			var speed: Number = 25;
			var dx: Number = pirate.x - piratePad.x;
			var dy: Number = pirate.y - piratePad.y;
			var angle = Math.atan2(dy, dx);
			pirate.x += Math.cos(angle) * speed;
			pirate.y += Math.sin(angle) * speed;
		}
		private function movePirateToTreasure(pirate: Pirate): void {
			var speed = 25;
			if (pirate.x > treasure.x) {
				pirate.x -= speed;

			} else if (pirate.x < treasure.x) {
				pirate.x += speed;
			} else if (pirate.y > treasure.y) {
				pirate.y -= speed;
			} else if (pirate.y < treasure.y) {
				pirate.y += speed;
			}


		}

		private function didPirateHitTreasure(pirate: Pirate): void {
			if (contains(treasure)) {
				if (pirate.hitTestPoint(treasure.x, treasure.y) && pirate.status == "Alive") {
					removeChild(treasure);
					pirate.gotoAndStop(2);
					setPiratePad();
				}
			}
		}

		public function skeleBump(): void {
			for (var i: int = 0; i < background.numChildren; i++) {
				if (String(background.getChildAt(i)) == "[object MapBound]")
				//{
					skeleton.didHitObject(background.getChildAt(i));
				//}
			}
		}


	}

}
