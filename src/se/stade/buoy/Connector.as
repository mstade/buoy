package se.stade.buoy
{
	import mx.core.UIComponent;
	
	import se.stade.stilts.Disposable;
	import se.stade.buoy.dependencies.DependencyContainer;

	public interface Connector extends Disposable
	{
		function initialize(view:UIComponent, dependencies:DependencyContainer):void;
		
		function connect(behaviors:Array):void;
		function release(behaviors:Array):void;
	}
}