package se.stade.buoy.connectors.metadata.eventhandling
{
    import se.stade.buoy.dependencies.DependencyContainer;
    import se.stade.daffodil.methods.Method;
    import se.stade.flash.dom.FlashQuery;
    import se.stade.stilts.Disposable;
    
    internal class DOMEventListener extends HandleEventTagListener implements Disposable
    {
        public function DOMEventListener(document:FlashQuery,
                                         handler:Method,
                                         parameters:HandleEventTagParameters,
                                         dependencies:DependencyContainer)
        {
            super(handler, parameters, dependencies);
            
            target = document.find(parameters.target);
            parameters.live && target.subscribe();
            
            target.addEventListener(parameters.type,
                                    listener,
                                    parameters.capture,
                                    parameters.priority,
                                    parameters.weak);
        }
        
        private var target:FlashQuery;
        
        public function dispose():void
        {
            target.dispose();
        }
    }
}
