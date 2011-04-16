package se.stade.buoy
{
    import flash.events.IEventDispatcher;
    
    import se.stade.buoy.overrides.ContextOverride;
    import se.stade.stilts.Disposable;

    internal final class OverrideList
    {
        private var _list:Vector.<ContextOverride>
        public function set list(value:Vector.<ContextOverride>):void
        {
            removeHandlers();
            _list = value;
            addHandlers();
        }
        
        private var _view:IEventDispatcher
        public function set view(value:IEventDispatcher):void
        {
            removeHandlers();
            _view = value;
            addHandlers();
        }
        
        private function removeHandlers():void
        {
            if (_view)
            {
                for each (var override:ContextOverride in _list)
                {
                    _view.removeEventListener(ContextEvent.ATTACH, override.handle);
                }
            }
        }
        
        private function addHandlers():void
        {
            if (_view)
            {
                for each (var override:ContextOverride in _list)
                {
                    _view.addEventListener(ContextEvent.ATTACH, override.handle);
                }
            }
        }
    }
}