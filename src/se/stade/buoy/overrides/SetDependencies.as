package se.stade.buoy.overrides
{
	import se.stade.buoy.Configuration;
	import se.stade.buoy.ContextEvent;
	import se.stade.buoy.dependencies.Dependency;
	
	[DefaultProperty("dependencies")]
	public class SetDependencies implements ContextOverride
	{
		public var dependencies:Vector.<Dependency>
		
		public function handle(event:ContextEvent):void
		{
			for each (var dependency:Dependency in dependencies)
			{
                event.context.configuration.dependencies.setDependency(dependency);
			}
		}
	}
}