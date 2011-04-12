package se.stade.buoy.dependencies
{
	public interface Dependency
	{
		function get name():String;
		function get types():Vector.<String>;
		
		function getInstance(container:DependencyContainer):*;
	}
}