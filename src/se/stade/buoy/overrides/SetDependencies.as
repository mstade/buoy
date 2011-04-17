package se.stade.buoy.overrides
{
	import se.stade.buoy.Configuration;
	import se.stade.buoy.ContextEvent;
	import se.stade.buoy.dependencies.DependencyProvider;
	
	[DefaultProperty("dependencies")]
	public class SetDependencies implements ContextOverride
	{
		public var dependencies:Vector.<DependencyProvider>
		
		public function handle(event:ContextEvent):void
		{
			for each (var dependency:DependencyProvider in dependencies)
			{
                event.context.configuration.dependencies.setProvider(dependency);
			}
		}
	}
}