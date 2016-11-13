package  {
	
	import states.ChaseState;
	import states.ConfusionState;
	import states.FleeState;
	import states.IAgentState;
	import states.IdleState; 
	import states.InitState;
	import states.WanderState;
	
	import flash.display.MovieClip;
	
	public class Skeleton extends MovieClip 
	{
		public static const WANDER:IAgentState = new WanderState();
		public static const INIT:IAgentState = new InitState();
		
		private var _previousState:IAgentState;
		private var _currentState:IAgentState;
		
		public var vx:Number;
		public var vy:Number;
		
		public var speed:Number;
		
		public function Skeleton() 
		{
			speed = 2;
			_currentState = INIT;
		}
		
		public function update():void 
		{
			if (!_currentState) return;
			_currentState.update(this);
			trace ("Spoopy Skeleton Update!");
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
		
		public function move():void {
			//var vx:Number = Math.random() - Math.random();
			//var vy:Number = Math.random() - Math.random();
			var angle = Math.atan2(this.vy * Math.PI, this.vx * Math.PI); 
			this.x += Math.cos(angle) * speed;
			this.y += Math.sin(angle) * speed;
		}
	}
	

	
}
