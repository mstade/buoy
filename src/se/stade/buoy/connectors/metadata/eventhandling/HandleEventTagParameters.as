package se.stade.buoy.connectors.metadata.eventhandling
{
    public final class HandleEventTagParameters
    {
        private var _target:String
        
        [DefaultProperty]
        public function get target():String
        {
            return _target;
        }
        
        public function set target(value:String):void
        {
            _target = value || "";
            
            if (_target.indexOf(EventHandlerScope.THIS) == 0)
            {
                _target = _target.substr(EventHandlerScope.THIS.length);
                _scope = EventHandlerScope.THIS;
            }
        }
        
        private var _scope:String = EventHandlerScope.DOM;
        public function get scope():String
        {
            return _scope;
        }
        
        public var type:String;
        public var live:Boolean;
        public var priority:int;
        public var useCapture:Boolean;
        public var useWeakReference:Boolean;
    }
}
