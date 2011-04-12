package se.stade.buoy.connectors.metadata
{
	import flash.utils.getDefinitionByName;
	
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.Type;
	import se.stade.daffodil.properties.Property;
	
	public class InjectTag extends MetadataTagBase implements MetadataTag
	{
		public function InjectTag(tag:String = "Inject")
		{
			super(tag, this);
		}
		
		public function connect(mediators:Array):void
		{
			var injectables:Array = Reflect.properties.withMetadata(tag).thatAreWritable.on(mediators);
			
			for each (var property:Property in injectables)
			{
				var parameters:InjectTagParameters = Reflect.metadata(tag)
														    .on(property)
														    .asType(InjectTagParameters)[0];
				
				property.value = dependencies.getInstance(parameters.type || property.definition(), parameters.name);
			}
		}

		public function release(mediators:Array):void
		{
			var injectables:Array = Reflect.properties.withMetadata(tag).thatAreWritable.on(mediators);
			
			for each (var property:Property in injectables)
			{
				property.value = null;
			}
		}
	}
}