package se.stade.buoy.connectors.metadata
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	import se.stade.buoy.Connector;
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.flash.dom.query.FlashQuery;
	
	[DefaultProperty("dependencies")]
	public class DefaultTags implements Connector
	{
		protected var connectorOrder:Vector.<Connector> = new <Connector>[
			// DOM connectors
			new FindTag(),
			
			// Dependencies
			new InjectTag(),
			
			// Event connectors
			new HandleEventTag(),
            
            // Common events
            new HandleEventTag("Change", Event.CHANGE),
			
			// Mouse events
			new HandleEventTag("Click", MouseEvent.CLICK),
			new HandleEventTag("DoubleClick", MouseEvent.DOUBLE_CLICK),
			
			new HandleEventTag("MouseOut", MouseEvent.MOUSE_OUT),
			new HandleEventTag("MouseOver", MouseEvent.MOUSE_OVER),
			new HandleEventTag("MouseMove", MouseEvent.MOUSE_MOVE),
			
			new HandleEventTag("MouseUp", MouseEvent.MOUSE_UP),
			new HandleEventTag("MouseDown", MouseEvent.MOUSE_DOWN),
			new HandleEventTag("MouseWheel", MouseEvent.MOUSE_WHEEL),
			
			new HandleEventTag("RollOut", MouseEvent.ROLL_OUT),
			new HandleEventTag("RollOver", MouseEvent.ROLL_OVER),
			
			// Keyboard events
			new HandleEventTag("KeyUp", KeyboardEvent.KEY_UP),
			new HandleEventTag("KeyDown", KeyboardEvent.KEY_DOWN),
			
			// Life cycle connectors 
			new InitializeTag(),
			new ActivateTag(),
			new DeactivateTag(),
			new DisposeTag()
		];
		
		public function initialize(view:UIComponent, dependencies:DependencyContainer):void
		{
            var query:FlashQuery = new FlashQuery(new <DisplayObject>[view]);
			dependencies.setInstance(query);
			
			for each (var connector:Connector in connectorOrder)
			{
				connector.initialize(view, dependencies);
			}
		}
		
		public function connect(mediators:Array):void
		{
			for each (var connector:Connector in connectorOrder)
			{
				connector.connect(mediators);
			}
		}
		
		public function release(mediators:Array):void
		{
			for each (var connector:Connector in connectorOrder)
			{
				connector.release(mediators);
			}
		}
		
		public function dispose():void
		{
			for each (var connector:Connector in connectorOrder)
			{
				connector.dispose();
			}
		}
	}
}