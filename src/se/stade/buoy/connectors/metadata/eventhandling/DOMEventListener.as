package se.stade.buoy.connectors.metadata.eventhandling
{
    import se.stade.buoy.dependencies.DependencyContainer;
    import se.stade.daffodil.methods.Method;
    import se.stade.flash.dom.query.FlashQuery;
    import se.stade.stilts.Disposable;
    
    internal class DOMEventListener extends HandleEventTagListener implements Disposable
    {
        public function DOMEventListener(document:FlashQuery, handler:Method, parameters:HandleEventTagParameters, dependencies:DependencyContainer)
        {
            super(handler, parameters, dependencies);
            
            target = document.find(parameters.target);
            target.live = parameters.live;
            
            target.addEventListener(parameters.type,
                                    listener,
                                    parameters.useCapture,
                                    parameters.priority,
                                    parameters.useWeakReference);
        }
        
        private var target:FlashQuery;
        
        public function dispose():void
        {
            target.dispose();
        }
    }
}