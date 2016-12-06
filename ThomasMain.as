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

	import MapBound
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

		private var ammoLayer: Sprite = new Sprite();
		private var topLeft: Point = new Point(365, 402);
		private var topRight: Point = new Point(6085, 422);
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
		private var skeletons: Vector.<Skeleton> = new Vector.<Skeleton> ();
		private var pirateTimer: Timer = new Timer(15000);

		private var skeleton: Skeleton = new Skeleton();
		private var skeleton2: Skeleton = new Skeleton();

		public function ThomasMain() {

			bullets = new Array();

			background.x = 0;
			background.y = 0;
			addChild(background);

			player = new Player();
			player.x = 200;
			player.y = 200;
			addChild(player);

			treasure.x = background.width / 2;
			treasure.y = background.height / 2;
			background.addChild(treasure);

			skeleton.x = background.width / 2;
			skeleton.y = background.height / 2;
			addChild(skeleton);
			skeleton.target = player;

			skeleton2.x = background.width / 2;
			skeleton2.y = background.height / 2 + 100;
			addChild(skeleton2);
			skeleton2.target = player;

			ammoPoints.push(topLeft, topRight, bottomLeft, bottomRight);
			for (var i = 0; i < 4; i++) {
				makeammoBox();
			}

			ammoLayer.addChild(player);

			addChild(ammoLayer);

			skeletons.push(skeleton, skeleton2);
			/*boneyBullet.x = background.width / 2;
			   boneyBullet.y = background.height / 2 + 100;
			   addChild(boneyBullet);*/

			piratePoints.push(topPirate, bottomPirate, leftPirate, rightPirate);

			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(MouseEvent.MOUSE_DOWN, fireBullet);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			pirateTimer.addEventListener(TimerEvent.TIMER, addAPirate);

			pirateTimer.start();
		}

		private function update(evt: Event): void {

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
					for each (var skele:Skeleton in skeletons)
					{
						if (skele.hitTestPoint(bullet.x, bullet.y)) 
						{
							skele.health -= 100
							if (skele.health < 1)
							{
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
				background.removeChild(pirateMan);
			}

			for each(var ammo: Ammo in ammoArray) {

				if (contains(ammo)) {


					if (player.hitTestPoint(ammo.x, ammo.y)) {
						background.removeChild(ammo);
						player.ammo += 3;
					}
				}
			}
			for each(var s: Skeleton in skeletons) {

				s.update();



				for each(var b: Particle in s.bulletsFired) {
					s.parent.addChild(b);
					if (b.life < 1) {
						s.bulletsFired.removeAt(s.bulletsFired.indexOf(b));
						s.parent.removeChild(b);
					}
					b.update();
				}
			}

			collision();
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

		private function makeammoBox(): void {

			var ammo: Ammo = new Ammo();
			var i: Number;
			var point: Point = ammoPoints[i = Math.floor(Math.random() * ammoPoints.length)];
			ammo.x = point.x;
			ammo.y = point.y;

			background.addChild(ammo);
			ammoArray.push(ammo);

			trace("added ammobox");



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

		private function killPirate(pirate: Pirate): void {
			if (contains(pirateMan)) {
				if (pirateMan.currentFrame == 2) {
					treasure.x = background.width / 2;
					treasure.y = background.height / 2;
					background.addChild(treasure);
					treasure.dropped = true;
				}
				background.removeChild(pirateMan);
			}
		}

		private function addAPirate(timer: TimerEvent): void {
			pirateMan = new Pirate();
			pirateTimer.reset();
			trace("timer done");
			pirateTimer.start();
			var i: Number;
			var point: Point = piratePoints[i = Math.floor(Math.random() * piratePoints.length)];
			pirateMan.x = point.x;
			pirateMan.y = point.y;
			trace(point);
			background.addChild(pirateMan);
			pirates.push(pirateMan);
			pirateMan.gotoAndStop(1);
		}

		private function setPiratePad(): void {
			var i: Number;
			var point: Point = piratePoints[i = Math.floor(Math.random() * piratePoints.length)];
			trace(point);
			trace("setting pirate pad");

			piratePad.x = point.x;
			piratePad.y = point.y;

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
					if(player.hitTestObject(background.getChildAt(i))){
						player.didHitObject(background.getChildAt(i));
					}
				}

			}
		}

		private function camera(char: Sprite): void {
			root.scrollRect = new Rectangle(char.x - stage.stageWidth / 2, char.y - stage.height / 2, stage.stageWidth, stage.stageHeight);
		}

	}

}