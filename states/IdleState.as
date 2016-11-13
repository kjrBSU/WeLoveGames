/*
The IdleState:
	1. connects to Skeleton through Interface
	2. watches the number of update cycles coming from the agent
	3. set's idling message and speed
	4. sets up an exit transition
*/
package states // self-reference
{
	import Skeleton; // setting up connection to agent
	public class IdleState implements IAgentState // going to be controlled by interface object
	{
		
		/* INTERFACE agent.states.IAgentState */
		
		public function update(a:Skeleton):void
		{
			if (a.numCycles > 30) {
				a.setState(Skeleton.WANDER); // once time limit of previous state is done,
										  // set back to another state
			}
		}
		
		public function enter(a:Skeleton):void
		{
			a.say("Idling...");
			a.speed = 0;
		}
		
		public function exit(a:Skeleton):void
		{
			a.randomDirection();
		}
		
	}

}