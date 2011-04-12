package se.stade.buoy.connectors.metadata
{
	import mx.core.UIComponent;
	
	import se.stade.buoy.Connector;
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.properties.Property;
	import se.stade.flash.dom.query.FlashQuery;
	
	public class FindTag extends MetadataTagBase implements Connector
	{
		public function FindTag(tag:String = "Find")
		{
			super(tag, this);
		}
		
		protected var document:FlashQuery;
		
		override public function initialize(view:UIComponent, dependencies:DependencyContainer):void
		{
			super.initialize(view, dependencies);
			document = dependencies.getInstance(FlashQuery) || FlashQuery.from(view);
		}
		
		public function connect(mediators:Array):void
		{
			var properties:Array = Reflect.properties
										  .ofType(FlashQuery)
										  .withMetadata(tag)
										  .thatAreWritable
										  .on(mediators);
			
			for each (var property:Property in properties)
			{
				var parameters:FindTagParameters = Reflect.metadata(tag)
													   .on(property)
													   .asType(FindTagParameters)[0];
				
				var targets:FlashQuery = document.find(parameters.target, parameters.limit);
				property.value = targets;
			}
		}

		public function release(mediators:Array):void
		{
			var properties:Array = Reflect.properties
										  .ofType(FlashQuery)
										  .withMetadata(tag)
										  .thatAreWritable
										  .on(mediators);
			
			for each (var property:Property in properties)
			{
				property.value = null;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			document.dispose();
		}
	}
}