package com.gestureworks.utils
{
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	/**
	 * The CMLLoader class loads and stores a global reference to an external CML file.
	 * 
	 * @author Charles
	 */
	public class CMLLoader extends EventDispatcher
	{				
		private var urlRequest:URLRequest;
		
		
		/**
		 * Constructor
		 * @param	enforcer
		 */	 
		public function CMLLoader(enforcer:SingletonEnforcer)
		{
			_isLoaded = false;
		}	
		
		
		/**
		 * Holds class instances of the multiton
		 */
		static private var instances:Dictionary = new Dictionary;
		
		
		/**
		 * returns the XML loader key value
		 * @param	key
		 * @return
		 */
		public static function getInstance(key:*):CMLLoader
		{
			if (instances[key] == null)
				CMLLoader.instances[key] = new CMLLoader(new SingletonEnforcer());
			return CMLLoader.instances[key];
		}
		

		/**
		 * The COMPLETE string is dispatched when the file has loaded.
		 */
		static public const COMPLETE:String = "COMPLETE";	
		
		
		private var _loader:URLLoader;
		/**
		 * Contains the loader
		 */		
		public function get loader():URLLoader {return _loader;}


		public var _data:XML;
		/**
		 * Contains the loaded data
		 */		
		public function get data():XML {return _data;}		
		
		
		private var _isLoaded:Boolean = false;
		/**
		 * Returns true if the file is loaded
		 */
		public function get isLoaded():Boolean {return _isLoaded;}	
		
		
		private var _percentLoaded:Number;
		/**
		 * Returns the percentage loaded value
		 */
		public function get percentLoaded():Number { return _percentLoaded; }	
		
		
		private var _src:String = "";		
		/**
		 * Sets the file source path
		 */
		public function get src():String {return _src;}
		public function set src(value:String):void 
		{
			_src = value;
		}	
		
		
		// public methods
				
		
		/**
		 * Loads an external CML file
		 * @param	url
		 */
		public function load(url:String):void
		{
			_src = url;
			urlRequest = new URLRequest(url);
			
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(ProgressEvent.PROGRESS, onProgress);						
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.load(urlRequest);
		}		
			

		// private methods
		
		
		private function onComplete(e:Event):void
		{
			_isLoaded = true;
			_loader.removeEventListener(Event.COMPLETE, onComplete);
			_loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);							
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);	
			
			try {
				_data = XML(_loader.data);	
			}
			catch (er:Error) {
				throw new Error(er.message + " File Path: " + urlRequest.url);
			}
			
			dispatchEvent(new Event(CMLLoader.COMPLETE, false, false));
		}
	
		
		private function onProgress(e:ProgressEvent):void
		{
			_percentLoaded = e.bytesLoaded / e.bytesTotal;
		}	


		private function onError(e:IOErrorEvent):void 
		{
			throw new Error(e.text);
		}			
		
	}
}

class SingletonEnforcer{}