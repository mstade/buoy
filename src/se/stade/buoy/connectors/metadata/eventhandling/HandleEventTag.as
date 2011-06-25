package se.stade.buoy.connectors.metadata.eventhandling
{
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	
	import se.stade.buoy.Connector;
	import se.stade.buoy.connectors.metadata.MetadataTagBase;
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.methods.Method;
	import se.stade.flash.dom.query.FlashQuery;
	import se.stade.stilts.Disposable;
	
	public class HandleEventTag extends MetadataTagBase implements Connector
	{
        public static const SCOPE_THIS:String = "this";
        public static const SCOPE_DOM:String = "dom";

		public function HandleEventTag(tag:String = "HandleEvent", eventType:String = "")
		{
			super(tag, this);
			
			this.tag = tag;
			this.eventType = eventType;
		}

		protected var eventType:String;
		protected var document:FlashQuery;
        
		protected var listeners:Dictionary = new Dictionary(true);
		
		override public function initialize(view:UIComponent, dependencies:DependencyContainer):void
		{
			super.initialize(view, dependencies);
			document = dependencies.get(FlashQuery) || FlashQuery.from(view);
		}
		
		public function connect(behaviors:Array):void
		{
			var eventHandlers:Array = Reflect.all.methods
                                             .withMetadata(tag)
                                             .on(behaviors);
			
			for each (var handler:Method in eventHandlers)
			{
                var eventParameters:Array = Reflect.all.metadata(tag)
                                                       .on(handler)
                                                       .into(HandleEventTagParameters);
                
				for each (var parameters:HandleEventTagParameters in eventParameters)
				{
                    parameters.type = eventType || parameters.type;
                    
                    if (parameters.type && parameters.target)
                    {
                        listeners[handler] ||= new <Disposable>[];
                        
                        if (parameters.scope.toLowerCase() == SCOPE_THIS)
                        {
                            listeners[handler].push(new LocalEventListener(handler, parameters, dependencies));
                        }
                        else
                        {
                            listeners[handler].push(new DOMEventListener(document, handler, parameters, dependencies));
                        }
                    }
				}
			}
        }
		
		public function release(behaviors:Array):void
		{
            var eventHandlers:Array = Reflect.all.methods
                                             .withMetadata(tag)
                                             .on(behaviors);
            
            for each (var handler:Method in eventHandlers)
            {
                for each (var listener:Disposable in listeners[handler])
                {
                    listener.dispose();
                }
                
                delete listeners[handler];
            }
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			for each (var list:Vector.<Disposable> in listeners)
			{
                for each (var listener:Disposable in list)
                {
                    listener.dispose();
                }
			}
			
			listeners = new Dictionary(true);
		}
	}
}