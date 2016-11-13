package states // pointing itself is stored
{
	import Skeleton; // making a connection ot agent
	
	public interface IAgentState 
	{
		function update(a:Skeleton):void;
		function enter(a:Skeleton):void;
		function exit(a:Skeleton):void; // basic function of agent behaviors 
	}
	
}