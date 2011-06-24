package se.stade.buoy.dependencies
{
	public final class Inject
	{
		public static const inferred:Inject = new Inject();
		
		public function Inject(type:Class = null, name:String = "")
		{
			this.type = type;
			this.name = name;
		}
        
		private var _type:Class;
		public function get type():Class
		{
			return _type;
		}
		
		public function set type(value:Class):void
		{
			_type = value;
		}
		
		private var _name:String;
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
            _name = value;
		}
	}
}