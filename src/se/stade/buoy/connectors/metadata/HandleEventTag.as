package se.stade.buoy.connectors.metadata
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.buoy.dependencies.SimpleContainer;
	import se.stade.buoy.dependencies.ioc.MethodInvoker;
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.methods.Method;
	import se.stade.daffodil.properties.Property;
	import se.stade.flash.dom.events.EventListenerParameters;
	import se.stade.flash.dom.query.FlashQuery;
	
	public class HandleEventTag extends MetadataTagBase implements MetadataTag
	{
		public function HandleEventTag(tag:String = "HandleEvent", eventType:String = "")
		{
			super(tag, this);
			
			this.tag = tag;
			this.eventType = eventType;
		}

		protected var eventType:String;
		protected var document:FlashQuery;
		protected var dispatchers:Dictionary = new Dictionary(true);
		
		override public function initialize(view:UIComponent, dependencies:DependencyContainer):void
		{
			super.initialize(view, dependencies);
			document = dependencies.getInstance(FlashQuery) || FlashQuery.from(view);
		}
		
		public function connect(mediators:Array):void
		{
			var eventHandlers:Array = Reflect.all.methods
                                             .withMetadata(tag)
                                             .on(mediators);
			
			for each (var handler:Method in eventHandlers)
			{
				var eventParameters:Array = Reflect.metadata(tag)
											       .on(handler)
                                                   .asType(HandleEventTagParameters);
				
				for each (var parameters:HandleEventTagParameters in eventParameters)
				{
                    var type:String = eventType || parameters.type;
                    
                    if (type && parameters.target)
                    {
    					var listener:Function = getEventListener(handler, parameters);
    
    					var dispatcher:FlashQuery = document.find(parameters.target);
    					dispatcher.addEventListener(eventType || parameters.type,
    											    listener,
    											    parameters.useCapture,
    											    parameters.priority,
    											    parameters.useWeakReference);
    					
    					dispatchers[handler] = dispatcher;
                    }
				}
			}
		}
		
		private function getEventListener(handler:Method, parameters:HandleEventTagParameters):Function
		{
			if (handler.parameters.length == 1
				&& Reflect.first.type
						  .extending(Event)
						  .on(handler.parameters[0]))
			{
				return handler.invoke;
			}
			else
			{
				return function(event:Event):void
				{
					var methodDependencies:DependencyContainer = dependencies.clone();
                    methodDependencies.setInstance(event);
					
					MethodInvoker.Instance.apply(handler, methodDependencies);
				}
			}
		}
		
		public function release(mediators:Array):void
		{
			for each (var dispatcher:FlashQuery in dispatchers)
			{
				dispatcher.suspendEventListening();
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			for each (var dispatcher:FlashQuery in dispatchers)
			{
				dispatcher.dispose();
			}
			
			dispatchers = new Dictionary(true);
		}
	}
}