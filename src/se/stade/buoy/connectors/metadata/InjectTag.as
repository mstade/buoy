package se.stade.buoy.connectors.metadata
{
	import flash.utils.getDefinitionByName;
	
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.Reflection;
	import se.stade.daffodil.Type;
	import se.stade.daffodil.properties.Property;
	
	public class InjectTag extends MetadataTagBase implements MetadataTag
	{
		public function InjectTag(tag:String = "Inject")
		{
			super(tag, this);
            allInjectees = Reflect.all.properties.withMetadata(tag).withWriteAccess;
		}
        
        private var allInjectees:Reflection;
		
		public function connect(mediators:Array):void
		{
			var injectees:Array = allInjectees.on(mediators);
			
			for each (var property:Property in injectees)
			{
				var parameters:InjectTagParameters = Reflect.metadata(tag)
														    .on(property)
														    .asType(InjectTagParameters)[0];
				
				property.value = dependencies.getInstance(parameters.type || property.definition(), parameters.name);
			}
		}

		public function release(mediators:Array):void
		{
			var injectees:Array = Reflect.all.properties
                                         .withMetadata(tag)
                                         .withWriteAccess
                                         .on(mediators);
			
			for each (var property:Property in injectees)
			{
				property.value = null;
			}
		}
	}
}