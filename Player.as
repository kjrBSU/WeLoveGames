package  {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;	
	
	public class Player extends MovieClip {
		
		public var xVel:Number;
		public var yVel:Number;
		public var speed:Number;	
		public var life:Number;
		public var ammo:Number;
		
		public function Player() {
			
			xVel = 0;
			yVel = 0;
			speed = 1;
			life = 10;
			ammo = 12;
			
		}
			
		
		public function update():void
		{
			
			x += xVel;
			y += yVel;
		}
		
	}
	
}
