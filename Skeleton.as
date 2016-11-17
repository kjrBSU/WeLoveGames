package  {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import states.BumpState;
	import states.ChaseState;
	import states.IAgentState;
	import states.InitState;
	import states.WanderState;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Skeleton extends MovieClip 
	{
		public static const WANDER:IAgentState = new WanderState();
		public static const BUMP:IAgentState = new BumpState();
		public static const INIT:IAgentState = new InitState();
		public static const CHASE:IAgentState = new ChaseState();
		
		private var _previousState:IAgentState;
		private var _currentState:IAgentState;
		
		public var vx:Number;
		public var vy:Number;
		
		public var speed:Number;
		
		public var isSkeleBump:Boolean;
		public var isPlayerNear:Boolean = false;
		
		public var chaseRadius:Number = 200;
		
		public var player:MovieClip;
		
		
		public function Skeleton() 
		{
			vx = Math.random() - Math.random();
			vy = Math.random() - Math.random();
			isSkeleBump = false;
			speed = 5;
			_currentState = WANDER;
		}
		
		public function update():void 
		{
			if (!_currentState) return;
			_currentState.update(this);
			//trace ("Spoopy Skeleton Update!");
		}
		
		public function setState(newState:IAgentState):void
		{
			if (_currentState == newState) return;
			if (_currentState) { // this will be clear when we look at other states
				_currentState.exit(this);
			}
			_previousState = _currentState; // moving from one state to another
			_currentState = newState;
			_currentState.enter(this);
		}
		
		public function get previousState():IAgentState { return _previousState; }
		
		public function get currentState():IAgentState { return _currentState; }
		
		public function get isBump():Boolean { return isSkeleBump; }
		
		public function move():void {
			var angle = Math.atan2(this.vy * Math.PI, this.vx * Math.PI); 
			this.x += Math.cos(angle) * speed;
			this.y += Math.sin(angle) * speed;
		}
		
		public function isHit(dspOb:DisplayObject):void 
		{
				if (this.hitTestObject(dspOb) == true)
				{
					isSkeleBump = true
				}
		}
		
		public function playerNear():void
		{
			var dx:Number = player.x - this.x;
			var dy:Number = player.y - this.y;
			var distanceToPlayer = Math.sqrt(dx * dx + dy * dy);
			
			if (distanceToPlayer < chaseRadius)
			{
				isPlayerNear = true;
			}
			else 
			{
				isPlayerNear = false;
			}
		}
		
		public function moveTowardPlayer()
		{
			var dx:Number = player.x - this.x;
			var dy:Number = player.y - this.y;
			var angle = Math.atan2(dy, dx);
			this.vx = Math.cos(angle);
			this.vy = Math.sin(angle);
		}
	}
}
