package se.stade.buoy
{
	import se.stade.buoy.dependencies.DependencyContainer;

	public interface Configuration
	{
		function get dependencies():DependencyContainer;
		function set dependencies(value:DependencyContainer):void;
		
		function get connectors():Vector.<Connector>;
		function set connectors(value:Vector.<Connector>):void;
		
		function get behaviors():Array;
		function set behaviors(value:Array):void;
	}
}
