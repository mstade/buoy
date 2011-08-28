package se.stade.buoy.overrides
{
	import se.stade.buoy.Configuration;
	import se.stade.buoy.Connector;
	import se.stade.buoy.Context;
	
	[DefaultProperty("connectors")]
	public class SetConnectors implements ContextOverride
	{
		public var connectors:Vector.<Connector>;
        
        public function applyTo(context:Context, configuration:Configuration):void
        {
            configuration.connectors = connectors;
		}
	}
}