package states 
{
	import Skeleton;
	
	public class InitState implements IAgentState
	{
		
		public function update(s:Skeleton):void
		{
			s.setState(Skeleton.WANDER);
		}
		
		public function enter(s:Skeleton):void
		{
			
		}
		public function exit(s:Skeleton):void
		{
			
		}
	}
}