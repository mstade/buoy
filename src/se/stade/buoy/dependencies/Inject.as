package se.stade.buoy.dependencies
{
	public final class Inject
	{
		public static const inferred:Inject = new Inject();
		
		public function Inject(type:Class = null, id:String = "")
		{
			this.type = type;
			this.id = id;
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
		
		private var _id:String;
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id = value;
		}
	}
}