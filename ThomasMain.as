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
	import flash.media.Sound;
    import flash.media.SoundChannel; 
	import flash.net.*;

	import MapBound;
	import ammoSpawn;
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
		private var scoreText: TextField;
		private var score: uint = 0;
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
		private var rightPirate: Point = new Point(background.width, (background.height / 2 + 200));
		private var leftPirate: Point = new Point(0, (background.height / 2 + 200));
		private var piratePoints: Array = new Array();
		private var skeletonPoints:Array = new Array();
		private var pirates: Array = new Array();
		private var piratePOI: Number;
		private var pirateEscaped:Boolean = false;
		private var pirateHasTreasure:Boolean = false;
		private var skeletons: Array = new Array();

		private var globalTimer: Timer = new Timer(1000, 30);

		private var viewRect: Rectangle;
		
		private var resetBtn:resetButton;
		
		private var snd:Sound;
		private var soundStart:int = 2000;
		private var soundEffectChannel:SoundChannel;
		private var themeChannel:SoundChannel;
		private var endChannel:SoundChannel;
		private var skeletonSound:Sound;
		private var pirateDying:Sound;
		private var pirateSpawned:Sound;
		private var pirateGrabbedTreasure:Sound;
		private var playerGotHit:Sound;
		private var endMusic:Sound;
		private var ammoPickUp:Sound;

		public function ThomasMain() {
			
			snd = new Sound(new URLRequest("gameSounds/inGame.mp3"));
			themeChannel = snd.play(2000, 1);
			skeletonSound = new Sound(new URLRequest("gameSounds/skeleSound.mp3"));
			pirateDying = new Sound(new URLRequest("gameSounds/pirateDying.mp3"));
			pirateSpawned = new Sound(new URLRequest("gameSounds/PirateSpawn.mp3"));
			pirateGrabbedTreasure = new Sound(new URLRequest("gameSounds/PickedUpTreasure.mp3"));
			playerGotHit = new Sound(new URLRequest("gameSounds/playerBeingHit.mp3"));
			endMusic = new Sound(new URLRequest("gameSounds/endGameTheme.mp3"));
			ammoPickUp = new Sound(new URLRequest("gameSounds/ammoPickUp.mp3"));

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
			
			scoreText = new TextField();
			scoreText.defaultTextFormat = myFormat;
			healthText.width = 500;
			scoreText.width = 400;
			addChild(scoreText);

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

			treasure.x = 3216;
			treasure.y = 2400;
			background.addChild(treasure);
			
			pushAmmoPoints();
			pushSkeletonPoints();
			trace(ammoPoints.length);

			piratePoints.push(topPirate, bottomPirate, leftPirate, rightPirate);

			addEventListener(Event.ADDED_TO_STAGE, addToStage);
			
			globalTimer.start();
		}
		
		private function addToStage(e:Event)
		{	
			removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(MouseEvent.MOUSE_DOWN, fireBullet);
			themeChannel.addEventListener(Event.SOUND_COMPLETE, loopSound);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			//stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseCoords);

			globalTimer.addEventListener(TimerEvent.TIMER, dankSpawnSystem);
			globalTimer.addEventListener(TimerEvent.TIMER_COMPLETE, resetTimer);
			
			viewRect = new Rectangle(stage.stageWidth / 2, stage.height / 2, stage.stageWidth, stage.stageHeight);

		}
		private function loopSound(e:Event):void {
			themeChannel = snd.play();
		}
		/*private function mouseCoords(e:MouseEvent):void {
			trace(mouseX, mouseY);
			trace(treasure.x, treasure.y);
		}*/
		
		private function removeFromStage():void
		{
			removeEventListener(Event.ENTER_FRAME, update);
			removeEventListener(MouseEvent.MOUSE_DOWN, fireBullet);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			removeEventListener(Event.SOUND_COMPLETE, loopSound);
			

			globalTimer.removeEventListener(TimerEvent.TIMER, dankSpawnSystem);
			globalTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, resetTimer);
		}
		
		private function pushAmmoPoints():void
		{
			for ( var i:int = 0; i < background.numChildren; i++)
			{
				if (background.getChildAt(i) is ammoSpawn)
				{
					ammoPoints.push(background.getChildAt(i));
				}
			}
		}
		
		private function pushSkeletonPoints():void
		{
			for ( var i:int = 0; i < background.numChildren; i++)
			{
				if (background.getChildAt(i) is skeletonSpawn)
				{
					skeletonPoints.push(background.getChildAt(i));
				}
			}
		}

		private function update(evt: Event): void {
		
			ammoIcon.x = player.x + 1150;
			ammoIcon.y = player.y - 800;

			ammoText.x = player.x + 800;
			ammoText.y = player.y - 850;
			ammoAmount = player.ammo;
			ammoText.text = (ammoAmount.toString() + " / 25");
			
			scoreText.x = player.x + 850;
			scoreText.y = player.y -750;
			scoreText.text = ("score: " + score.toString());

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
			if(contains(pirateMan)){
			didPirateHitTreasure(pirateMan);
			}
			
			if (pirateMan.life < 1) {
					killPirate(pirateMan);
			}

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
								soundEffectChannel = skeletonSound.play(500, 1);
							}

						}
					}
				}
			}

			

			for each(var ammo: Ammo in ammoArray) {

				if (contains(ammo)) {


					if (player.hitTestPoint(ammo.x, ammo.y)) {
						background.removeChild(ammo);
						player.addAmmo();
						soundEffectChannel = ammoPickUp.play();
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
						soundEffectChannel = playerGotHit.play();
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
			
			endGame()
			
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
			} else if (event.target.currentCount == 5 || event.target.currentCount == 35) {
				addAPirate();
			} else if (event.target.currentCount == 30) {
				makeASkeleton();
				removeAmmo();
				addScore();
			}
		}
		private function addScore():void {
			score += 10;
			pirateMan.speed += 3;
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

		for each(var ammoPack:ammoSpawn in ammoPoints)
		{
			var ammo: Ammo = new Ammo()
			ammo.x = ammoPack.x;
			ammo.y = ammoPack.y;
			ammoArray.push(ammo);
			background.addChild(ammo);
		}
			
			
			
			
			
			
			/*var i: Number;
			for (i = 0; i < ammoPoints.length; i++) {
				var point: ammoSpawn = ammoPoints[i];
				var ammo: Ammo = new Ammo();
				ammo.x = point.x;
				ammo.y = point.y;

				background.addChild(ammo);
				trace("added ammobox");
				ammoArray.push(ammo);
			}*/



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
				player.yVel = -player.movingSpeed;
				player.movingVerticle = true;
			} else if (evt.keyCode == 83) {
				player.yVel = player.movingSpeed;
				player.movingVerticle = true;
			} else if (evt.keyCode == 68) {
				player.xVel = player.movingSpeed;
				player.movingVerticle = false;
			} else if (evt.keyCode == 65) {
				player.xVel = -player.movingSpeed;
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
			for (var i: uint = 0; i < 2; i++) {
				var skeletonTimed: Skeleton = new Skeleton();
				var spawnPoint: skeletonSpawn = skeletonPoints[i = Math.floor(Math.random() * ammoPoints.length)];
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
				if(pirateMan.currentFrame == 1) {
					background.removeChild(pirateMan);
					soundEffectChannel = pirateDying.play();
					
				}
				if (pirateMan.currentFrame == 2) {
					treasure.x = 3216;
					treasure.y = 2400;
					background.addChild(treasure);
					pirateHasTreasure = false;
					background.removeChild(pirateMan);
					soundEffectChannel = pirateDying.play();
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
			soundEffectChannel = pirateSpawned.play();
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
			var speed: Number = pirate.speed;
			var dx: Number = pirate.x - piratePad.x;
			var dy: Number = pirate.y - piratePad.y;
			var angle = Math.atan2(dy, dx);
			pirate.x += Math.cos(angle) * speed;
			pirate.y += Math.sin(angle) * speed;
		}

		private function movePirateToTreasure(pirate: Pirate): void {
			var speed = pirate.speed;
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
					pirateHasTreasure = true;
					soundEffectChannel = pirateGrabbedTreasure.play();
				}
			}
		}

		public function collision(): void {
			for (var i: int = 0; i < background.numChildren; i++) {
				if (background.getChildAt(i) is MapBound) {
					for each(var skele: Skeleton in skeletons) 
					{
						for each(var sb:SkeleBullet in skele.bulletsFired)
						{
							if (sb.hitTestObject(background.getChildAt(i)))
							{
								background.removeChild(sb)
								skele.bulletsFired.removeAt(skele.bulletsFired.indexOf(sb));
							}
						}
						skele.didHitObject(background.getChildAt(i));
					}

					if (player.hitTestObject(background.getChildAt(i))) {
						player.didHitObject(background.getChildAt(i));
					}

					if(pirateMan.hitTestObject(background.getChildAt(i)) && pirateHasTreasure == true){
						pirateEscaped = true;

					}
					for each (var b:Particle in bullets)
					{
						if (b.hitTestObject(background.getChildAt(i)))
						{
							killBullet(b);
						}

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
			/*if(pirateMan.hitTestPoint(piratePad.x, piratePad.y)){
				pirateEscaped = true;
			}*/
		}
		
		private function camera(char: Sprite): void {
			viewRect.x = char.x - stage.stageWidth / 2;
			viewRect.y = char.y - stage.stageHeight / 2;
			root.scrollRect = viewRect;
			//new Rectangle(char.x - stage.stageWidth / 2, char.y - stage.height / 2, stage.stageWidth, stage.stageHeight);
		}
		
		private function endGame()
		{
			if (player.life < 1 || pirateEscaped == true)
			{
				
				removeFromStage();
				resetBtn = new resetButton();
				addChild(resetBtn);
				resetBtn.x = viewRect.x + viewRect.width / 2 - resetBtn.width / 2;
				resetBtn.y = viewRect.y + viewRect.height / 2 - resetBtn.height / 2;
				resetBtn.addEventListener(MouseEvent.CLICK, resetGame);	

				themeChannel.stop();
				endChannel = endMusic.play(5000, 1);
				//snd.close();
				
			}
			/*if (pirateHasTreasure == true && pirateEscaped == true)
			{
				
				removeFromStage();
				resetBtn = new resetButton();
				addChild(resetBtn);
				resetBtn.x = viewRect.x + viewRect.width / 2 - resetBtn.width / 2;
				resetBtn.y = viewRect.y + viewRect.height / 2 - resetBtn.height / 2;
				resetBtn.addEventListener(MouseEvent.CLICK, resetGame);	
				channel.stop();
				snd.close();
			}*/
			
		}
		private function resetGame(e:Event):void 
		{
			trace("reset game");
			//removeChild(background);
			resetBtn.removeEventListener(MouseEvent.CLICK, resetGame);
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			//removeChild(resetBtn);
			var game:ThomasMain = new ThomasMain();
			endChannel.stop();
			addChild(game);
			
		}

	}

}