package se.stade.buoy.overrides
{
	import se.stade.buoy.Configuration;
	import se.stade.buoy.Context;
	
	[DefaultProperty("overrides")]
	public class SpecificConfiguration implements ContextOverride
	{
		public var type:Class;
		
		public var overrides:Vector.<ContextOverride>;
        
        public function applyTo(context:Context, configuration:Configuration):void
        {
			if (configuration is type)
			{
				for each (var override:ContextOverride in overrides)
				{
					override.applyTo(context, configuration);
				}
			}
		}
	}
}