package se.stade.buoy
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	
	import mx.core.IMXMLObject;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import se.stade.buoy.connectors.metadata.HandleEventTag;
	import se.stade.buoy.overrides.ContextOverride;
	import se.stade.buoy.sequencing.Sequence;
	import se.stade.buoy.sequencing.Step;
	import se.stade.buoy.sequencing.StepEvent;
	
	[Event(name="attachContext", type="se.stade.buoy.ContextEvent")]
	[Event(name="disposeContext", type="se.stade.buoy.ContextEvent")]
	
	[DefaultProperty("configuration")]
	public class OverridableContext extends EventDispatcher implements Context, IMXMLObject
	{
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
		
		private var _configuration:Configuration;
		public function get configuration():Configuration
		{
			return _configuration;
		}
		
		public function set configuration(value:Configuration):void
		{
			_configuration = value;
		}
		
		protected var overrides:OverrideList = new OverrideList;

        public function set overrideSubContext(list:Vector.<ContextOverride>):void
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
			if (!view.dispatchEvent(ContextEvent.attach(this, view)))
				return;
            
            attachedView = view;
			
			startupSequence.addEventListener(StepEvent.Finished, function():void
			{
                overrides.view = attachedView;
                
				for each (var connector:Connector in configuration.connectors)
				{
					connector.initialize(attachedView, configuration.dependencies);
				}
                
				for each (var request:ContextEvent in deferredAttachRequests)
				{
                    request.context.configuration.dependencies.setParent(configuration.dependencies);
					request.context.attach(request.view);
				}
				
				activate();
			});
			
            startupSequence.start(this);
		}
        
		public function activate():void
		{
			for each (var connector:Connector in configuration.connectors)
			{
				connector.connect(configuration.behaviours);
			}
		}

		public function deactivate():void
		{
			for each (var connector:Connector in configuration.connectors)
			{
				connector.release(configuration.behaviours);
			}
		}
		
		public function dispose():void
		{
			if (!attachedView)
				return;
			
            for each (var connector:Connector in configuration.connectors)
            {
                connector.dispose();
            }

            overrides.view = attachedView = null;
            
			shutdownSequence.addEventListener(StepEvent.Finished, function():void
			{
                shutdownSequence.removeEventListener(StepEvent.Finished, arguments.callee);
                dispatchEvent(ContextEvent.dispose(this, attachedView));
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