package se.stade.buoy.connectors.metadata
{
	import se.stade.buoy.Connector;
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.Reflection;
	import se.stade.daffodil.define;
	import se.stade.daffodil.properties.Property;
	
	public class InjectTag extends MetadataTagBase implements Connector
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
				
				property.value = dependencies.get(parameters.type || define(property.type), parameters.name);
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