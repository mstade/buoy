package se.stade.buoy.connectors.metadata
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import se.stade.buoy.Connector;
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.buoy.dependencies.ioc.invoke;
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.methods.Method;
	
	public class InitializeTag extends MetadataTagBase implements Connector
	{
		public function InitializeTag(tag:String = "Init")
		{
			super(tag, this);
		}
		
		protected var executionHistory:Dictionary;
		
		override public function initialize(view:DisplayObject, dependencies:DependencyContainer):void
		{
			super.initialize(view, dependencies);
			executionHistory = new Dictionary(true);
		}
		
		public function connect(behaviors:Array):void
		{
			var initializers:Array = Reflect.all.methods
											.withMetadata(tag)
											.on(behaviors);
			
			for each (var initializer:Method in initializers)
			{
				if (initializer in executionHistory)
					continue;
				
				invoke(initializer, dependencies);
				executionHistory[initializer] = true;
			}
		}

		public function release(behaviors:Array):void
		{
		}
		
		override public function dispose():void
		{
			super.dispose();
			executionHistory = null;
		}
	}
}