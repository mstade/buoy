package se.stade.buoy.connectors.metadata.eventhandling
{
    import flash.events.IEventDispatcher;
    import flash.utils.getDefinitionByName;
    
    import se.stade.buoy.dependencies.DependencyContainer;
    import se.stade.daffodil.methods.Method;
    import se.stade.stilts.Disposable;

    internal class LocalEventListener extends HandleEventTagListener implements Disposable
    {
        private static var Binding:Object;
        {
            try
            {
                Binding = getDefinitionByName("mx.binding.utils.BindingUtils");
            }
            catch (e:Error)
            {
                // This means we ain't running no flex-y stuff, thus we can't bind (right now)
            }
        }
        
        public function LocalEventListener(handler:Method, parameters:HandleEventTagParameters, dependencies:DependencyContainer)
        {
            super(handler, parameters, dependencies);
            
            var chain:Array = parameters.target.split(".");
            
            if (Binding)
            {
                watcher = Binding.bindProperty(this, "currentTarget", handler.owner, chain, false, true);
            }
            else
            {
                var owner:Object = handler.owner;
                
                while (chain.length > 1 && owner)
                {
                    var property:String = chain.shift();
                    
                    if (property in owner)
                    {
                        owner = owner[property];
                    }
                }
                
                property = chain[0];
                
                if (owner && property in owner)
                {
                    currentTarget = owner[property];
                }
            }
        }
        
        private var watcher:Object;
        
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
            
            if (watcher)
            {
                watcher["unwatch"]();
            }
        }
    }
}
