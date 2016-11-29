package  {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;	
	import flash.geom.*;
	import Player;
	import Particle;
	
	
	public class Main extends MovieClip {
		
		private var player:Player;
	    private var background:Sprite;
		private var bullet:Bullet;
		private var bullets:Array;
		private var shotAngle:Number;
		
		public function Main() 
		{
			
			bullets = new Array();
			
			background = new Map();			
			addChild(background);
			
			player = new Player();
			addChild(player);
			

			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(MouseEvent.MOUSE_DOWN, fireBullet);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		private function fireBullet(evt:MouseEvent):void
		{
			var shot:Particle;			
						
			shot = new Bullet();
			
				shot.x = player.x;
				shot.y = player.y;
				
				shot.interacts = true;
			
				shot.xVel = Math.cos(shotAngle) * player.speed * 30;
				shot.yVel = Math.sin(shotAngle) * player.speed * 30;
			if (player.ammo > 0) 
			{
				addChild(shot);
				bullets.push(shot);
				player.ammo -= 1;
			}
			    trace(player.ammo);
			
		}
		
		private function keyDownHandler(evt:KeyboardEvent):void
		{
			//87=w 68=d 83=s 65=a
		if (evt.keyCode == 87)
			{
				player.yVel = -20;
			}
			else if (evt.keyCode == 83)
			{
				player.yVel = 20;
			}
			else if (evt.keyCode == 68)
			{
				player.xVel = 20;
			}
			else if (evt.keyCode == 65)
			{
				player.xVel = -20;
			}
		}
		
		private function keyUpHandler(evt:KeyboardEvent):void
		{
			//87=w 68=d 83=s 65=a
		if (evt.keyCode == 87 || evt.keyCode == 83)
			{
				player.yVel = 0;
			}
			else if (evt.keyCode == 68 || evt.keyCode == 65)
			{
				player.xVel = 0;
			}
		}
		
		private function update(evt:Event):void
		{
			
			camera(player);
			
			player.update();
			
			shotAngle = Math.atan2(stage.mouseY - stage.stageHeight / 2, stage.mouseX - stage.stageWidth / 2);
			
			var playerAngle:Number = shotAngle * 180 / Math.PI;
			
			player.rotation = playerAngle;			
			
			for each (var bullet:Particle in bullets)
			{
				
				bullet.update();
				
				if (bullet.life <= 0)
				{
					killBullet(bullet);
				}
			}
		}
		
		private function camera(char:Sprite):void
		{
			root.scrollRect = new Rectangle(char.x - stage.stageWidth / 2, char.y - stage.height / 2, stage.stageWidth, stage.stageHeight);
		}
		
		private function killBullet(bullet:Particle):void
		{
			try
			{
				var i:int;
				for (i = 0; i < bullets.length; i++)
				{
					if (bullets[i].name == bullet.name)
					{
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
			}
			catch(e:Error)
			{
				trace("Failed to delete bullet!", e);
			}
		}
		

	}
	
}
