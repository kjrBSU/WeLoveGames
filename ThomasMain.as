package {

	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.*;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	import flash.events.TimerEvent;
	import flash.text.*;

	import MapBound
	import Player;
	import Particle;
	import Pirate;
	import Treasure;
	import flash.text.engine.GraphicElement;

	public class ThomasMain extends MovieClip {

		private var player: Player;
		private var playerHealthBar: playerHealth = new playerHealth();
		private var background: Map = new Map();
		private var bullet: Bullet;
		private var bullets: Array;
		private var shotAngle: Number;

		private var healthText: TextField;
		private var health: uint;
		private var ammoText: TextField;
		private var ammoAmount: uint;
		private var ammoIcon: Sprite = new ammoSymbol();

		private var ammoLayer: Sprite = new Sprite();
		private var topLeft: Point = new Point(365, 602);
		private var topRight: Point = new Point(6085, 622);
		private var bottomLeft: Point = new Point(365, 4062);
		private var bottomRight: Point = new Point(6085, 4062);
		private var ammoPoints: Array = new Array();
		private var ammoArray: Array = new Array();

		private var pirateMan: Pirate = new Pirate();
		private var treasure: Treasure = new Treasure();
		private var piratePad: Point = new Point();
		private var topPirate: Point = new Point(background.width / 2, 0);
		private var bottomPirate: Point = new Point(background.width / 2, background.height);
		private var rightPirate: Point = new Point(background.width, background.height / 2);
		private var leftPirate: Point = new Point(0, background.height / 2);
		private var piratePoints: Array = new Array();
		private var pirates: Array = new Array();
		private var piratePOI: Number;
		private var skeletons: Vector.<Skeleton> = new Vector.<Skeleton>();

		private var globalTimer: Timer = new Timer(1000, 30);

		private var viewRect: Rectangle = new Rectangle(stage.stageWidth / 2, stage.height / 2, stage.stageWidth, stage.stageHeight);

		public function ThomasMain() {

			bullets = new Array();

			background.x = 0;
			background.y = 0;
			addChild(background);


			var myFormat: TextFormat = new TextFormat();
			myFormat.size = 100;


			healthText = new TextField();
			healthText.defaultTextFormat = myFormat;
			healthText.width = 500;
			healthText.height = 400;
			addChild(healthText);

			ammoText = new TextField();
			ammoText.defaultTextFormat = myFormat;
			ammoText.width = 500;
			ammoText.height = 400;
			addChild(ammoText);


			player = new Player();
			player.x = background.width / 2;
			player.y = background.height / 2;
			background.addChild(player);


			addChild(playerHealthBar);
			addChild(ammoIcon);

			treasure.x = background.width / 2;
			treasure.y = background.height / 2;
			background.addChild(treasure);

			ammoPoints.push(topLeft, topRight, bottomLeft, bottomRight);
			trace(ammoPoints.length);

			piratePoints.push(topPirate, bottomPirate, leftPirate, rightPirate);

			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(MouseEvent.MOUSE_DOWN, fireBullet);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);

			globalTimer.addEventListener(TimerEvent.TIMER, dankSpawnSystem);
			globalTimer.addEventListener(TimerEvent.TIMER_COMPLETE, resetTimer);


			globalTimer.start();
		}

		private function update(evt: Event): void {

			ammoIcon.x = player.x + 1150;
			ammoIcon.y = player.y - 800;

			ammoText.x = player.x + 800;
			ammoText.y = player.y - 850;
			ammoAmount = player.ammo;
			ammoText.text = (ammoAmount.toString() + " / 25");

			playerHealthBar.x = player.x + 250;
			playerHealthBar.y = player.y - 900;

			healthText.x = player.x - 150;
			healthText.y = player.y - 960;
			health = player.life / 10;
			healthText.text = (health.toString() + " / 100");

			playerHealthBar.width = player.life;

			if (pirateMan.currentFrame == 1) {
				movePirateToTreasure(pirateMan);
			} else if (pirateMan.currentFrame == 2) {
				movePirateToPad(pirateMan);
			}
			didPirateHitTreasure(pirateMan);

			camera(player);
			player.update();

			shotAngle = Math.atan2(stage.mouseY - stage.stageHeight / 2, stage.mouseX - stage.stageWidth / 2);
			var playerAngle: Number = shotAngle * 180 / Math.PI;
			player.rotation = playerAngle;

			for each(var bullet: Particle in bullets) {
				bullet.update();

				if (bullet.life <= 0) {
					killBullet(bullet);
				} else if (bullet.interacts) {
					if (pirateMan.hitTestPoint(bullet.x, bullet.y)) {
						pirateMan.life -= 100;
						killBullet(bullet);
						break;
					}
					for each(var skele: Skeleton in skeletons) {
						if (skele.hitTestPoint(bullet.x, bullet.y)) {
							skele.health -= 100
							if (skele.health < 1) {
								skeletons.removeAt(skeletons.indexOf(skele))
								skele.kill();
								killBullet(bullet);
							}

						}
					}
				}
			}

			if (pirateMan.life == 0) {
				killPirate(pirateMan);
			}

			for each(var ammo: Ammo in ammoArray) {

				if (contains(ammo)) {


					if (player.hitTestPoint(ammo.x, ammo.y)) {
						background.removeChild(ammo);
						player.addAmmo();
					}
				}
			}
			for each(var s: Skeleton in skeletons) {
				/*if (s.visible == false )
				{
					background.addChild(s);
				}*/
				if (s.contains(s) == true && s.visible == true) {
					s.update();
				}




				for each(var b: Particle in s.bulletsFired) {
					s.parent.addChild(b);
					if (b.hitTestObject(player)) {
						player.life -= 100;
						s.bulletsFired.removeAt(s.bulletsFired.indexOf(b));
						s.parent.removeChild(b);
					}

					if (b.life < 1) {
						s.bulletsFired.removeAt(s.bulletsFired.indexOf(b));
						s.parent.removeChild(b);
					}
					b.update();
				}
			}

			pirateMan.lookAtIt();

			collision();
		}

		private function resetTimer(e: TimerEvent) {
			globalTimer.reset();
			globalTimer.start();
		}

		private function dankSpawnSystem(event: TimerEvent) {
			if (event.target.currentCount == 1) {
				makeammoBoxes();
			} else if (event.target.currentCount == 10 || event.target.currentCount == 20) {
				makeASkeleton();
			} else if (event.target.currentCount == 5) {
				addAPirate();
			} else if (event.target.currentCount == 30) {
				makeASkeleton();
				removeAmmo();
			}
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

		private function makeammoBoxes(): void {

			var i: Number;
			for (i = 0; i < ammoPoints.length; i++) {
				var point: Point = ammoPoints[i];
				var ammo: Ammo = new Ammo();
				ammo.x = point.x;
				ammo.y = point.y;

				background.addChild(ammo);
				trace("added ammobox");
				ammoArray.push(ammo);
			}



		}

		private function removeAmmo(): void {
			for each(var ammo:Ammo in ammoArray){
				if (contains(ammo)) {
				for (var j: int = 0; j < ammoArray.length; j++) {
						if(ammoArray[j].name == ammo.name){
							background.removeChild(ammoArray[j]);
						}
					}
				}
			}
		}


		private function killBullet(bullet: Particle): void {
			try {
				var i: int;
				for (i = 0; i < bullets.length; i++) {
					if (bullets[i].name == bullet.name) {
						bullets.splice(i, 1);
						removeChild(bullet);
						i = bullets.length;
					}
				}
			} catch (e: Error) {
				trace("Failed to delete bullet!", e);
			}
		}

		private function keyDownHandler(evt: KeyboardEvent): void {
			//87=w 68=d 83=s 65=a
			if (evt.keyCode == 87) {
				player.yVel = -20;
				player.movingVerticle = true;
			} else if (evt.keyCode == 83) {
				player.yVel = 20;
				player.movingVerticle = true;
			} else if (evt.keyCode == 68) {
				player.xVel = 20;
				player.movingVerticle = false;
			} else if (evt.keyCode == 65) {
				player.xVel = -20;
				player.movingVerticle = false;
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

		private function makeASkeleton(): void {
			for (var i: uint = 0; i < 1; i++) {
				var skeletonTimed: Skeleton = new Skeleton();
				var spawnPoint: Point = ammoPoints[i = Math.floor(Math.random() * ammoPoints.length)];
				skeletonTimed.x = spawnPoint.x;
				skeletonTimed.y = spawnPoint.y;
				skeletonTimed._target = player;
				background.addChild(skeletonTimed);
				skeletons.push(skeletonTimed);
			}
			trace(skeletons);
		}

		private function killPirate(pirate: Pirate): void {
			if (contains(pirateMan)) {
				if (pirateMan.currentFrame == 2) {
					treasure.x = background.width / 2;
					treasure.y = background.height / 2;
					background.addChild(treasure);
					treasure.dropped = true;
					background.removeChild(pirateMan);
				}

			}
		}

		private function addAPirate(): void {
			pirateMan = new Pirate();
			trace("timer done");
			var i: Number;
			var point: Point = piratePoints[i = Math.floor(Math.random() * piratePoints.length)];
			pirateMan.x = point.x;
			pirateMan.y = point.y;
			trace(point);
			background.addChild(pirateMan);
			pirates.push(pirateMan);
			pirateMan.gotoAndStop(1);
			pirateMan.pointOfInterest = pirateMan.lookAtAnObject(treasure.x, treasure.y);
		}

		private function setPiratePad(): void {
			var i: Number;
			var point: Point = piratePoints[i = Math.floor(Math.random() * piratePoints.length)];
			trace(point);
			trace("setting pirate pad");

			piratePad.x = point.x;
			piratePad.y = point.y;
			pirateMan.pointOfInterest = pirateMan.lookAtAnObject(point.x, point.y);

		}

		private function movePirateToPad(pirate: Pirate): void {
			var speed: Number = 15;
			var dx: Number = pirate.x - piratePad.x;
			var dy: Number = pirate.y - piratePad.y;
			var angle = Math.atan2(dy, dx);
			pirate.x += Math.cos(angle) * speed;
			pirate.y += Math.sin(angle) * speed;
		}

		private function movePirateToTreasure(pirate: Pirate): void {
			var speed = 15;
			if (pirateMan != null) {
				var dx: Number = treasure.x - pirate.x;
				var dy: Number = treasure.y - pirate.y;
				var angle = Math.atan2(dy, dx);
				pirate.x += Math.cos(angle) * speed;
				pirate.y += Math.sin(angle) * speed;
			}
			/*if (pirate.x > treasure.x) {
		   pirate.x -= speed;
		
		   } else if (pirate.x < treasure.x) {
		   pirate.x += speed;
		   } else if (pirate.y > treasure.y) {
		   pirate.y -= speed;
		   } else if (pirate.y < treasure.y) {
		   pirate.y += speed;
		   }*/

		}

		private function didPirateHitTreasure(pirate: Pirate): void {
			if (contains(treasure)) {
				if (pirate.hitTestPoint(treasure.x, treasure.y) && pirate.status == "Alive") {
					background.removeChild(treasure);
					pirate.gotoAndStop(2);
					setPiratePad();
				}
			}
		}

		public function collision(): void {
			for (var i: int = 0; i < background.numChildren; i++) {
				if (background.getChildAt(i) is MapBound) {
					for each(var skele: Skeleton in skeletons) {
						skele.didHitObject(background.getChildAt(i));
					}

					if (player.hitTestObject(background.getChildAt(i))) {
						player.didHitObject(background.getChildAt(i));
					}
				}
				if (background.getChildAt(i) is Pirate) {
					player.didHitEnemy(pirateMan);
				}
				if (background.getChildAt(i) is Skeleton) {
					for each(var skeletonI: Skeleton in skeletons) {
						player.didHitEnemy(skeletonI);
					}
				}


			}
		}

		private function camera(char: Sprite): void {
			viewRect.x = char.x - stage.stageWidth / 2;
			viewRect.y = char.y - stage.stageHeight / 2;
			root.scrollRect = viewRect;
			//new Rectangle(char.x - stage.stageWidth / 2, char.y - stage.height / 2, stage.stageWidth, stage.stageHeight);
		}

	}

}