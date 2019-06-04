//
//  LocalFileManager.swift
//  IMLeMo
//
//  Created by xionghx on 2018/8/2.
//  Copyright © 2018 四川省商投信息技术有限责任公司. All rights reserved.
//

import UIKit

public class LocalFileManager: NSObject {
	enum DirectoryType {
		case documents
		case temp
		case library
		case caches
	}
	
	class func LocalDirectoryPath(with type:DirectoryType ) -> String{
		switch type {
		case .documents:
			let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
			return paths[0]
		case .temp:
			let path = NSTemporaryDirectory()
			return path
		case .library:
			let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
			return paths[0]
		case .caches:
			let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
			return paths[0]
		}
	}
	
	
	class func caculateCache() -> Float{
		let cachePath = LocalDirectoryPath(with: .caches)
		let fileManager = FileManager.default
		var total: Float = 0
		if fileManager.fileExists(atPath: cachePath){
			let childrenPath = fileManager.subpaths(atPath: cachePath)
			if childrenPath != nil{
				for path in childrenPath!{
					let childPath = cachePath + "/" + path
					do{
						let attr = try fileManager.attributesOfItem(atPath: childPath)
						let fileSize = attr[FileAttributeKey.size] as! Float
						total += fileSize
					}catch _{
					}
				}
			}
		}
		return total
	}
	
	
	class func clearCache(finshed : (() -> Void)){
		let cachePath = LocalDirectoryPath(with: .caches)
		let fileManager = FileManager.default
		guard let files = fileManager.subpaths(atPath: cachePath) else {
			return
		}
		for tempStr in files{
			let path = (cachePath as NSString).appendingPathComponent(tempStr)
			do {
				try fileManager.removeItem(atPath: path)
				if tempStr == files.last{
					finshed()
				}
			} catch {
				finshed()
			}
		}
	}
	
//	class func UserDefaultSetDictionary(dictionary:Dictionary<String, Any>, with key:String){
//
//		do {
//			let data =  try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
//			UserDefaults.standard.setValue(data, forKey: key)
//		} catch  {
//
//		}
//
//	}
	
	
}
