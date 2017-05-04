package utils 
{
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Vinc
	 */
	public class CacheManager 
	{
		
		public function CacheManager() 
		{
			throw new Error("is static");
		}
		
		static public function fileExist(_filepath:String, _storage:Boolean):Boolean 
		{
			var file:File;
			if (!_storage) file = File.applicationDirectory; 
			else file = File.applicationStorageDirectory;
			file = file.resolvePath(_filepath);
			return file.exists;
		}
		
		
		
		static public function writeFile(_filepath:String, _content:String, _storage:Boolean, _mode:String = ""):void
		{
			if (_mode == "") _mode = FileMode.WRITE;
			
			var fileToCreate:File;
			if (!_storage) fileToCreate = new File(File.applicationDirectory.nativePath);
			else fileToCreate = new File(File.applicationStorageDirectory.nativePath);
			
			fileToCreate = fileToCreate.resolvePath(_filepath);
			var fileStream:FileStream = new FileStream();
			fileStream.open(fileToCreate, _mode);
			fileStream.writeUTFBytes(_content);
			fileStream.close();
			
		}
		
		static public function readFile(_filepath:String, _storage:Boolean):String 
		{
			var file:File;
			if (!_storage) file = new File(File.applicationDirectory.nativePath);
			else file = new File(File.applicationStorageDirectory.nativePath);
			
			file = file.resolvePath(_filepath); 
			
			var fDataStream:FileStream = new FileStream();
			fDataStream.open(file, FileMode.READ);
			var sContent:String = fDataStream.readUTFBytes(fDataStream.bytesAvailable);
			fDataStream.close ();
			return sContent;
		}
		
		
		static public function writeImage(_filepath:String, _bmpd:BitmapData, _storage:Boolean = true):void
		{
			//__________________________________
			var _ba:ByteArray;
			_ba = _bmpd.encode(_bmpd.rect, new PNGEncoderOptions(true), _ba);
			var f:File;
			if (_storage) f = File.applicationStorageDirectory.resolvePath(_filepath);
			else f = File.applicationDirectory.resolvePath(_filepath);
			
			var fs:FileStream = new FileStream();
			fs.open(f, FileMode.WRITE);
			
			fs.writeBytes(_ba, 0, _ba.length);
			fs.close();
			
		}
		
		
		
		
		
		
	}

}