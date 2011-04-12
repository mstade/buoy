package se.stade.buoy.connectors.metadata
{
	import mx.core.UIComponent;
	
	import se.stade.stilts.errors.AbstractTypeError;
	import se.stade.buoy.dependencies.DependencyContainer;

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
		
		public function initialize(view:UIComponent, dependencies:DependencyContainer):void
		{
			this.dependencies = dependencies;
		}
		
		public function dispose():void
		{
			dependencies = null;
		}
	}
}