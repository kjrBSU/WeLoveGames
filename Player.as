package  {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class Player extends MovieClip {
		
		public var xVel:Number;
		public var yVel:Number;
		public var speed:Number;
		public var life:Number;
		public var ammo:Number;
		private var collidedObject:DisplayObject;
		private var collided:Boolean = false;
		private var takeDamage:Boolean = false;
		private var damageFrames:Number = 0;
		private var damageBuffer:Number = 15;
		private var bumpBuffer:Number = 20;
		
		public function Player() {
			
			xVel = 0;
			yVel = 0;
			speed = 1;
			life = 1000;
			ammo = 12;
			
		}
		public function didHitObject(dispObj:DisplayObject):void {
			if (this.hitTestObject(dispObj) == true)
			{
				collided = true
				collidedObject = dispObj;
				stopPlayer();
			}
		}
		public function didHitEnemy(enemy:MovieClip):void {
			if(this.hitTestObject(enemy) == true)
			{
				damage();
				takeDamage = true;
				damageFrames++;
			}
		}
		private function damage():void 
		{
			if(damageFrames == damageBuffer && takeDamage == true){
				life -= 100;
				trace(life);
				takeDamage = false;
			}
			else if (damageFrames > damageBuffer){
				//takeDamage = false;
				damageFrames = 0;
			}
		}
		private function hitByBullet():void {
			life -= 100;
		}
		private function stopPlayer():void {
			xVel = 0;
			yVel = 0;
			
			if(this.y > collidedObject.y)
			{
				this.y += bumpBuffer 
			}
			else if(this.y < collidedObject.y)
			{
				this.y -= bumpBuffer;
			}
			
			if (this.x > collidedObject.x)
			{
				this.x += bumpBuffer;
			}
			else if(this.x < collidedObject.x)
			{
				this.x -= bumpBuffer;
			}
			
			//var playerHalfWidth:Number = this.width/2;
			//var playerHalfHeight:Number = this.height/2;
			//
			////stop the player when it reaches the edges
			////if (player.x > stage.stageWidth)
			//if (this.x + playerHalfWidth > collidedObject.width) {
			//	
			//	//player.x = stage.stageWidth;
			//	this.x = collidedObject.width - playerHalfWidth;
			//}/*else if (this.x - playerHalfWidth < 0) {
			//	this.x = 0 + playerHalfWidth;
			//}*/
			//if (this.y + playerHalfHeight > collidedObject.height) {
			//	this.y = collidedObject.height - playerHalfHeight;
			//}/*else if (this.y - playerHalfHeight < 0){
			//	this.y = 0 + playerHalfHeight;
			//}*/
		}
			
		
		public function update():void
		{
			x += xVel;
			y += yVel;
		}
		
	}
	
}
