package se.stade.buoy.connectors.metadata.eventhandling
{
    import flash.events.Event;
    
    import se.stade.buoy.dependencies.DependencyContainer;
    import se.stade.buoy.dependencies.SimpleContainer;
    import se.stade.buoy.dependencies.ioc.invoke;
    import se.stade.daffodil.Reflect;
    import se.stade.daffodil.define;
    import se.stade.daffodil.methods.Method;
    import se.stade.daffodil.methods.Parameter;
    import se.stade.daffodil.qualify;

    internal class HandleEventTagListener
    {
        public function HandleEventTagListener(handler:Method, parameters:HandleEventTagParameters, dependencies:DependencyContainer)
        {
            this.handler = handler;
            this.parameters = parameters;
            
            listenerDependencies = new SimpleContainer(dependencies);
            
            this.listener = function(event:Event):void
            {
                listenerDependencies.clear();
                listenerDependencies.set(event);
                
                invoke(handler, listenerDependencies);
            };
        }
        
        protected var handler:Method;
        protected var listener:Function;
        protected var parameters:HandleEventTagParameters;
        protected var listenerDependencies:SimpleContainer;
    }
}