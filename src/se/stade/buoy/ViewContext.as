package se.stade.buoy
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    import se.stade.buoy.overrides.ContextOverride;
    import se.stade.daffodil.Reflect;
    import se.stade.flash.dom.FlashQuery;

    [Event(name="attachContext", type="se.stade.buoy.ContextEvent")]
    [Event(name="disposeContext", type="se.stade.buoy.ContextEvent")]
    
    public class ViewContext extends SimpleConfiguration implements Context, Configuration, IEventDispatcher
    {
        private var _subcontextOverrides:Vector.<ContextOverride>;
        public function get subcontextOverrides():Vector.<ContextOverride>
        {
            return _subcontextOverrides;
        }

        public function set subcontextOverrides(value:Vector.<ContextOverride>):void
        {
            _subcontextOverrides = value;
        }
        
        private var viewToBeAttached:DisplayObject;

        public function set autoAttach(view:DisplayObject):void
        {
            if (!view || view == viewToBeAttached)
                return;
            
            var initEvent:String = Event.ADDED_TO_STAGE;
            
            if (Flex.isUIComponent(view))
            {
                if (Flex.isInitialized(view))
                {
                    attach(view);
                    return;
                }
                else
                    initEvent = Flex.CreationComplete;
            }
            
            viewToBeAttached = view;
            
            var deferredAttachRequests:Vector.<ContextEvent> = new <ContextEvent>[];

            var deferAttachRequest:Function = function(event:ContextEvent):void
            {
                deferredAttachRequests.push(event);
                event.preventDefault();
            };

            view.addEventListener(ContextEvent.ATTACH, deferAttachRequest);
            view.addEventListener(initEvent, function(event:Event):void
            {
                view.removeEventListener(ContextEvent.ATTACH, deferAttachRequest);
                view.removeEventListener(initEvent, arguments.callee);
                
                if (view == viewToBeAttached)
                {
                    attach(view);

                    for each (var request:ContextEvent in deferredAttachRequests)
                    {
                        request.configuration.dependencies.setParent(dependencies);
                        request.context.attach(request.view);
                    }
                }
            });
        }
        
        protected var attachedView:DisplayObject;
        
        public function attach(view:DisplayObject):void
        {
            if (attachedView || viewToBeAttached)
            {
                dispose();
            }

            if (view.dispatchEvent(ContextEvent.attach(this, this, view)))
            {
                attachedView = view;
                dependencies.set(FlashQuery.from(view));

                for each (var connector:Connector in connectors)
                {
                    connector.initialize(attachedView, dependencies);
                }

                activate();
            }
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
            if (attachedView)
            {
                for each (var connector:Connector in connectors)
                {
                    connector.dispose();
                }

                attachedView = null;
                dispatchEvent(ContextEvent.dispose(this, this, attachedView));
            }
            
            viewToBeAttached = null;
        }
    }
}

import flash.display.DisplayObject;

import se.stade.daffodil.Reflect;

class Flex
{
    public static const CreationComplete:String = "creationComplete";

    public static function isInitialized(view:DisplayObject):Boolean
    {
        return "initialized" in view && view["initialized"] === true;
    }

    public static function isUIComponent(view:DisplayObject):Boolean
    {
        return Reflect.first.type.named("UIComponent").inPackage("mx.core").on(view);
    }
}