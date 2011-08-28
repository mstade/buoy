package se.stade.buoy.overrides
{
	import se.stade.buoy.Configuration;
	import se.stade.buoy.Context;
	import se.stade.buoy.dependencies.DependencyProvider;
	
	[DefaultProperty("dependencies")]
	public class SetDependencies implements ContextOverride
	{
		public var dependencies:Vector.<DependencyProvider>

        public function applyTo(context:Context, configuration:Configuration):void
        {
			for each (var dependency:DependencyProvider in dependencies)
			{
                configuration.dependencies.setProvider(dependency);
			}
		}
	}
}