package se.stade.buoy.connectors.metadata.eventhandling
{
    import se.stade.buoy.dependencies.DependencyCollection;
    import se.stade.buoy.dependencies.DependencyContainer;
    import se.stade.buoy.dependencies.ioc.invoke;
    import se.stade.daffodil.methods.Method;

    import flash.events.Event;

    internal class HandleEventTagListener
    {
        public function HandleEventTagListener(handler:Method, parameters:HandleEventTagParameters, dependencies:DependencyContainer)
        {
            this.handler = handler;
            this.parameters = parameters;
            
            listenerDependencies = new DependencyCollection(dependencies);
            
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
        protected var listenerDependencies:DependencyCollection;
    }
}
