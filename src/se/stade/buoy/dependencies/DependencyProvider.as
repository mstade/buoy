package se.stade.buoy.dependencies
{
	public interface DependencyProvider
	{
		function get name():String;
		function get types():Vector.<String>;
		
		function getInstance(container:DependencyContainer):*;
	}
}