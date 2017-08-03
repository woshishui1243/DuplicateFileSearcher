//
//  Searcher.swift
//  DuplicateFileSearcher
//
//  Created by user on 2017/8/1.
//
//

import Foundation
import PathKit
import Rainbow

class Searcher {
    
    static let excludePrefixDirectory = [".", "Pods"]
    static let excludeSuffixDirectory = [".pbxproj", ".xcworkspace", ".xcodeproj", ".strings", "Contents.json", "Info.plist"]

    class func fileList(atPath pathStr:String, excludePaths: [String]?) -> [Path]
    {
        let path = Path(pathStr)
        let absolutePath = path.absolute()
        var fileList: [Path] = []
        do {
            let list = try FileManager.default.contentsOfDirectory(atPath: absolutePath.string)
            for file in list {
                var breakStatus = false
                
                if let excludes = excludePaths {
                    for exc in excludes {
                        if file.contains(exc) {
                            breakStatus = true
                            break
                        }
                    }
                    if breakStatus {
                        continue
                    }
                }
                
                
                for prefix in excludePrefixDirectory {
                    if file.hasPrefix(prefix) {
                        breakStatus = true
                        break
                    }
                }
                if breakStatus {
                    continue
                }
                for suffix in excludeSuffixDirectory {
                    if file.hasSuffix(suffix) {
                        breakStatus = true
                        break
                    }
                }
                if breakStatus {
                    continue
                }
                let filePath = path+Path(file)
                if filePath.isDirectory {
                   let subFileList = Searcher.fileList(atPath: filePath.string, excludePaths: excludePaths)
                    var subFiles:[Path] = []
                    for subFile in subFileList {
                       let newPath = filePath+subFile
                        subFiles.append(newPath)
                    }
                    fileList.append(contentsOf: subFiles)
                }
                else {
                    fileList.append(filePath)
                }
            }
        }catch {

        }
        return fileList
    }
}
