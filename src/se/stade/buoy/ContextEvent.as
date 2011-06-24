package se.stade.buoy
{
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	public class ContextEvent extends Event
	{
		public static const ATTACH:String = "attachContext";
		public static const DISPOSE:String = "disposeContext";
		
		public static function attach(context:Context, configuration:Configuration, view:UIComponent):ContextEvent
		{
			return new ContextEvent(ATTACH, context, configuration, view);
		}
		
		public static function dispose(context:Context, configuration:Configuration, view:UIComponent):ContextEvent
		{
			return new ContextEvent(DISPOSE, context, configuration, view);
		}
		
		public function ContextEvent(type:String, context:Context, configuration:Configuration, view:UIComponent)
		{
			super(type, type == ATTACH, type == ATTACH);
			
			_view = view;
			_context = context;
            _configuration = configuration;
		}
		
		private var _context:Context;
		public function get context():Context
		{
			return _context;
		}
        
        private var _configuration:Configuration;
        public function get configuration():Configuration
        {
            return _configuration;
        }
		
		private var _view:UIComponent;
		public function get view():UIComponent
		{
			return _view;
		}
		
		public override function clone():Event
		{
			return new ContextEvent(type, context, configuration, view);
		}
	}
}