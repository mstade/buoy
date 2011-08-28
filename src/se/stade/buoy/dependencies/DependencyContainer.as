package se.stade.buoy.dependencies
{
	public interface DependencyContainer
	{
        function setParent(value:DependencyContainer):void;
        
		function get(type:Class, name:String = ""):*;
		function set(instance:*, name:String = ""):DependencyProvider;
		
		function getProvider(type:Class, name:String = ""):DependencyProvider;
		function setProvider(dependency:DependencyProvider, ... dependencies):void;

		function contains(type:Class, name:String = ""):Boolean;
	}
}