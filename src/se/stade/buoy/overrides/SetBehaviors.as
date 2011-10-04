package se.stade.buoy.overrides
{
    import se.stade.buoy.Configuration;
    import se.stade.buoy.Context;
    
    [DefaultProperty("behaviors")]
    public class SetBehaviors implements ContextOverride
    {
        public var behaviors:Array;
        
        public function applyTo(context:Context, configuration:Configuration):void
        {
            configuration.behaviors = behaviors;
        }
    }
}
