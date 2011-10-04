package se.stade.buoy.connectors.metadata
{
    import se.stade.buoy.Connector;
    import se.stade.daffodil.Reflect;
    import se.stade.daffodil.define;
    import se.stade.daffodil.properties.Property;
    
    public class InjectTag extends MetadataTagBase implements Connector
    {
        public function InjectTag(tag:String = "Inject")
        {
            super(tag, this);
        }
        
        public function connect(behaviors:Array):void
        {
            var injectees:Array = Reflect.all.properties
                                         .withWriteAccess
                                         .withMetadata(tag)
                                         .on(behaviors);
            
            for each (var property:Property in injectees)
            {
                var parameters:InjectTagParameters = Reflect.first.metadata(tag)
                                                            .on(property)
                                                            .into(InjectTagParameters);
                
                property.value = dependencies.get(parameters.type || define(property.type), parameters.name);
            }
        }

        public function release(behaviors:Array):void
        {
            var injectees:Array = Reflect.all.properties
                                         .withWriteAccess
                                         .withMetadata(tag)
                                         .on(behaviors);
            
            for each (var property:Property in injectees)
            {
                property.value = null;
            }
        }
    }
}
