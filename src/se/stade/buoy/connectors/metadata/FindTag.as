package se.stade.buoy.connectors.metadata
{
	import flash.display.DisplayObject;
	
	import se.stade.buoy.Connector;
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.properties.Property;
	import se.stade.daffodil.qualify;
	import se.stade.flash.dom.DisplayNode;
	import se.stade.flash.dom.FlashQuery;
	import se.stade.flash.dom.querying.limits.MatchLimit;
	
	public class FindTag extends MetadataTagBase implements Connector
	{
		public function FindTag(tag:String = "Find")
		{
			super(tag, this);
		}
		
		protected var document:FlashQuery;
		
		override public function initialize(view:DisplayObject, dependencies:DependencyContainer):void
		{
			super.initialize(view, dependencies);
			document = dependencies.get(FlashQuery) || FlashQuery.from(view);
		}
		
		public function connect(behaviors:Array):void
		{
			var properties:Array = Reflect.all.properties
										  .withMetadata(tag)
										  .withWriteAccess
										  .on(behaviors);
			
			for each (var property:Property in properties)
			{
				var parameters:FindTagParameters = Reflect.first.metadata(tag)
													      .on(property)
													      .into(FindTagParameters);
				
				var targets:FlashQuery = document.find(parameters.target, MatchLimit.of(parameters.limit));
                
                if (property.type == qualify(FlashQuery))
                {
                    property.value = targets;
                }
                else
                {
                    property.value = targets[0].element;
                }
			}
		}

		public function release(behaviors:Array):void
		{
			var properties:Array = Reflect.all.properties
										  .withMetadata(tag)
										  .withWriteAccess
										  .on(behaviors);
			
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