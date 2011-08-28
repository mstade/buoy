package se.stade.buoy.connectors.metadata
{
	import flash.display.DisplayObject;
	
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.stilts.errors.AbstractTypeError;

	public class MetadataTagBase
	{
		public function MetadataTagBase(tag:String, self:MetadataTagBase)
		{
			if (this != self)
				throw new AbstractTypeError();
			
			this.tag = tag;
		}
		
		private var _tag:String;
		public function get tag():String
		{
			return _tag;
		}
		
		public function set tag(value:String):void
		{
			_tag = value;
		}
		
		protected var dependencies:DependencyContainer;
		
		public function initialize(view:DisplayObject, dependencies:DependencyContainer):void
		{
			this.dependencies = dependencies;
		}
		
		public function dispose():void
		{
			dependencies = null;
		}
	}
}