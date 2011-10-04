package se.stade.buoy.overrides
{
    import se.stade.buoy.Configuration;
    import se.stade.buoy.Context;

    public interface ContextOverride
    {
        function applyTo(context:Context, configuration:Configuration):void;
    }
}
