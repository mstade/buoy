package se.stade.buoy
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	
	import mx.core.IMXMLObject;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import se.stade.buoy.connectors.metadata.DefaultTags;
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.buoy.dependencies.DependencyProvider;
	import se.stade.buoy.dependencies.SimpleContainer;
	import se.stade.buoy.overrides.ContextOverride;
	import se.stade.buoy.sequencing.Sequence;
	import se.stade.buoy.sequencing.Step;
	import se.stade.buoy.sequencing.StepEvent;
	
	[Event(name="attachContext", type="se.stade.buoy.ContextEvent")]
	[Event(name="disposeContext", type="se.stade.buoy.ContextEvent")]
	
	[DefaultProperty("configuration")]
	public class MXMLContext extends EventDispatcher implements Context, Configuration, IMXMLObject
	{
        private var _dependencyContainer:DependencyContainer;
        public function get dependencyContainer():DependencyContainer
        {
            if (!_dependencyContainer)
            {
                _dependencyContainer = new SimpleContainer;
            }
            
            return _dependencyContainer;
        }
        
        public function set dependencyContainer(value:DependencyContainer):void
        {
            _dependencyContainer = value;
        }
        
        public function set dependencies(value:Vector.<DependencyProvider>):void
        {
            for each (var provider:DependencyProvider in value)
            {
                dependencyContainer.setProvider(provider);
            }
        }
        
        private var _connectors:Vector.<Connector> = new <Connector>[new DefaultTags];
        public function get connectors():Vector.<Connector>
        {
            return _connectors ;
        }
        
        public function set connectors(value:Vector.<Connector>):void
        {
            _connectors = value;
        }
        
        private var _behaviors:Array;
        public function get behaviors():Array
        {
            return _behaviors;
        }
        
        public function set behaviors(value:Array):void
        {
            _behaviors = value;
        }
        
		private var startupSequence:Sequence = new Sequence(null);
		public function set startup(value:Vector.<Step>):void
		{
			startupSequence = new Sequence(value);
		}
		
		private var shutdownSequence:Sequence = new Sequence(null);
        public function set shutdown(value:Vector.<Step>):void
		{
			shutdownSequence = new Sequence(value);
		}
		
		protected var overrides:OverrideList = new OverrideList;

        public function set subcontextOverrides(list:Vector.<ContextOverride>):void
		{
            overrides.list = list;
            overrides.view = attachedView;
		}
		
		protected var attachedView:UIComponent;
		
		public function attach(view:UIComponent):void
		{
            if (attachedView)
                throw new IllegalOperationError("This context may only be attached to one view at a time, dispose it before attaching it to another.");
            
			if (view.initialized)
				initialize(view);
			else
			{
				var deferredAttachRequests:Vector.<ContextEvent> = new <ContextEvent>[];
				
				var deferAttachRequest:Function = function(event:ContextEvent):void
				{
					deferredAttachRequests.push(event);
					event.preventDefault();
				};
				
				view.addEventListener(ContextEvent.ATTACH, deferAttachRequest);
				view.addEventListener(FlexEvent.CREATION_COMPLETE, function():void
				{
					view.removeEventListener(ContextEvent.ATTACH, deferAttachRequest);
					view.removeEventListener(FlexEvent.CREATION_COMPLETE, arguments.callee);
					
					initialize(view, deferredAttachRequests);
				});
			}
		}
		
		protected function initialize(view:UIComponent, deferredAttachRequests:Vector.<ContextEvent> = null):void
		{
			if (!view.dispatchEvent(ContextEvent.attach(this, this, view)))
				return;
            
            attachedView = view;
			
			startupSequence.addEventListener(StepEvent.Finished, function():void
			{
                overrides.view = attachedView;
                
				for each (var connector:Connector in connectors)
				{
					connector.initialize(attachedView, dependencyContainer);
				}
                
				for each (var request:ContextEvent in deferredAttachRequests)
				{
                    request.configuration.dependencyContainer.setParent(dependencyContainer);
					request.context.attach(request.view);
				}
				
				activate();
			});
			
            startupSequence.start(this);
		}
        
		public function activate():void
		{
			for each (var connector:Connector in connectors)
			{
				connector.connect(behaviors);
			}
		}

		public function deactivate():void
		{
			for each (var connector:Connector in connectors)
			{
				connector.release(behaviors);
			}
		}
		
		public function dispose():void
		{
			if (!attachedView)
				return;
			
            for each (var connector:Connector in connectors)
            {
                connector.dispose();
            }

            overrides.view = attachedView = null;
            
			shutdownSequence.addEventListener(StepEvent.Finished, function():void
			{
                shutdownSequence.removeEventListener(StepEvent.Finished, arguments.callee);
                dispatchEvent(ContextEvent.dispose(this, this, attachedView));
			});
			
            shutdownSequence.start(this);
		}

		public function initialized(document:Object, id:String):void
		{
			var view:UIComponent = document as UIComponent;
			
			if (view)
				attach(view);
		}
	}
}