package se.stade.buoy.connectors.metadata
{
	import mx.core.UIComponent;
	
	import se.stade.buoy.Connector;
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.properties.Property;
	import se.stade.daffodil.qualify;
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
			document = dependencies.get(FlashQuery) || FlashQuery.from(view);
		}
		
		public function connect(mediators:Array):void
		{
			var properties:Array = Reflect.all.properties
										  .withMetadata(tag)
										  .withWriteAccess
										  .on(mediators);
			
			for each (var property:Property in properties)
			{
				var parameters:FindTagParameters = Reflect.first.metadata(tag)
													      .on(property)
													      .into(FindTagParameters);
				
				var targets:FlashQuery = document.find(parameters.target, parameters.limit);
                property.value = property.type == qualify(FlashQuery) ? targets : targets[0];
			}
		}

		public function release(mediators:Array):void
		{
			var properties:Array = Reflect.all.properties
										  .withMetadata(tag)
										  .withWriteAccess
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