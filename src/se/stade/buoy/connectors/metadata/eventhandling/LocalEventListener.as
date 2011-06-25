package se.stade.buoy.connectors.metadata.eventhandling
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    import mx.binding.utils.BindingUtils;
    import mx.binding.utils.ChangeWatcher;
    
    import se.stade.buoy.dependencies.DependencyContainer;
    import se.stade.daffodil.methods.Method;
    import se.stade.stilts.Disposable;

    internal class LocalEventListener extends HandleEventTagListener implements Disposable
    {
        public function LocalEventListener(handler:Method, parameters:HandleEventTagParameters, dependencies:DependencyContainer)
        {
            super(handler, parameters, dependencies);
            
            var chain:Array = parameters.target.split(".");
            watcher = BindingUtils.bindProperty(this, "currentTarget", handler.owner, chain, false, true);
        }
        
        private var watcher:ChangeWatcher;
        
        private var _currentTarget:IEventDispatcher
        public function set currentTarget(value:Object):void
        {
            if (_currentTarget)
                _currentTarget.removeEventListener(parameters.type, listener, parameters.useCapture);
            
            _currentTarget = value as IEventDispatcher;
            
            if (_currentTarget)
                _currentTarget.addEventListener(parameters.type,
                                                listener,
                                                parameters.useCapture,
                                                parameters.priority,
                                                parameters.useWeakReference);
        }
        
        public function dispose():void
        {
            if (_currentTarget)
                _currentTarget.removeEventListener(parameters.type, listener, parameters.useCapture);
            
            watcher.unwatch();
        }
    }
}