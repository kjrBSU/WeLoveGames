package states 
{
	import Skeleton;
	
	public class InitState implements IAgentState
	{
		
		public function update(a:Skeleton):void
		{
			a.setState(Skeleton.WANDER);
		}
		
		public function enter(a:Skeleton):void
		{
			
		}
		public function exit(a:Skeleton):void
		{
			
		}
	}
}