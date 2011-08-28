package se.stade.buoy
{
	import flash.display.DisplayObject;
	
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.stilts.Disposable;

	public interface Connector extends Disposable
	{
		function initialize(view:DisplayObject, dependencies:DependencyContainer):void;
		
		function connect(behaviors:Array):void;
		function release(behaviors:Array):void;
	}
}