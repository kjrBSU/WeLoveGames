package  {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import states.BumpState;
	import states.ChaseState;
	import states.IAgentState;
	import states.InitState;
	import states.WanderState;
	
	import flash.display.MovieClip;
	
	public class Skeleton extends MovieClip 
	{
		public static const WANDER:IAgentState = new WanderState();
		public static const BUMP:IAgentState = new BumpState();
		public static const INIT:IAgentState = new InitState();
		
		private var _previousState:IAgentState;
		private var _currentState:IAgentState;
		
		public var vx:Number;
		public var vy:Number;
		
		public var speed:Number;
		
		public var _isBump:Boolean;
		
		public function Skeleton() 
		{
			vx = Math.random() - Math.random();
			vy = Math.random() - Math.random();
			_isBump = false;
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
		
		public function get isBump():Boolean { return _isBump; }
		
		public function move():void {
			var angle = Math.atan2(this.vy * Math.PI, this.vx * Math.PI); 
			this.x += Math.cos(angle) * speed;
			this.y += Math.sin(angle) * speed;
		}
		
		public function isHit(dspOb:DisplayObject):void {
				if (this.hitTestObject(dspOb) == true)
				{
					_isBump = true
				}
		}
	}
	

	
}
