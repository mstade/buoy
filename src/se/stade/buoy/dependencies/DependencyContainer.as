package se.stade.buoy.dependencies
{
	import se.stade.colligo.Collection;
	
	public interface DependencyContainer extends Collection
	{
        function set parent(value:DependencyContainer):void;
        
		function getInstance(type:Class, name:String = ""):*;
		function setInstance(instance:*, name:String = ""):Dependency;
		
		function getDependency(type:Class, name:String = ""):Dependency;
		function setDependency(dependency:Dependency, ... dependencies):void;
		
		function getAllDependencies():Vector.<Dependency>;

		function canResolve(type:Class, name:String = ""):Boolean;
		
		function clone():DependencyContainer;
	}
}