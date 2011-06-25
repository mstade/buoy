package se.stade.buoy.connectors.metadata.eventhandling
{
	public final class HandleEventTagParameters
	{
		[DefaultProperty]
		public var target:String;
		public var type:String;
        
        private var _scope:String
        public function get scope():String
        {
            return _scope || HandleEventTag.SCOPE_DOM;
        }
        
        public function set scope(value:String):void
        {
            _scope = {
                "this": HandleEventTag.SCOPE_THIS,
                "dom": HandleEventTag.SCOPE_DOM
            }[value];
        }
		
        public var live:Boolean;
		public var priority:int;
		public var useCapture:Boolean;
		public var useWeakReference:Boolean;
	}
}