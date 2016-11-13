package  {
	
	import states.ChaseState;
	import states.ConfusionState;
	import states.FleeState;
	import states.IAgentState;
	import states.IdleState; 
	import states.WanderState;
	
	import flash.display.MovieClip;
	
	
	public class Skeleton extends MovieClip 
	{
		public static const WANDER:IAgentState = new WanderState();
		
		private var _previousState:IAgentState;
		private var _currentState:IAgentState;
		
		public function Skeleton() 
		{
			_currentState = WANDER;
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
	}
	
}
