import Foundation
import CommandLineKit
import Rainbow
import PathKit

class FileInfo {
    let path: Path!
    let fileName: String!
    let index: Int!
    var dupIndexes: [Int] = []
    init(path atPath:Path, fileName name:String, index: Int = 0) {
        self.path = atPath
        self.fileName = name
        self.index = index
    }
}

let cli = CommandLineKit.CommandLine()

let projectPath = StringOption(shortFlag: "p", longFlag: "project", required: false,
                            helpMessage: "Path to the project.")
let excludePath = MultiStringOption(shortFlag: "e", longFlag: "exclude", required: false,
                      helpMessage: "exclude path don't search")
let help = BoolOption(shortFlag: "h", longFlag: "help",
                      helpMessage: "Prints a help message.")

cli.addOptions(projectPath, excludePath, help)


cli.formatOutput = { s, type in
    var str: String
    switch(type) {
    case .error:
        str = s.red.bold
    case .optionFlag:
        str = s.green.underline
    case .optionHelp:
        str = s.blue
    default:
        str = s
    }
    return cli.defaultFormat(s: str, type: type)
}

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

if let exclude = excludePath.value {
    print("ExcludePath path is \(exclude)")
}

if help.value == true {
    cli.printUsage()
}

let project = projectPath.value ?? "."
let fileList = Searcher.fileList(atPath: project, excludePaths: excludePath.value)

var fileInfos: [FileInfo] = []
var fileNames: [String] = []

for index in 0..<fileList.count {
    let path = fileList[index]
    let fileName = path.lastComponent

    let duplicateFiles = fileInfos.filter { fileInfo in
        return fileInfo.fileName == fileName
    }
    let info = FileInfo(path: path, fileName: fileName, index:index)
    fileInfos.append(info)
    
    if duplicateFiles.count > 0 {
        var indexes: [Int] = []
        for dupFile in duplicateFiles {
            indexes.append(dupFile.index)
        }
        indexes.append(index)
        let firstDupFile = duplicateFiles[0]
        firstDupFile.dupIndexes = indexes
    }
}

let dupFileList = fileInfos.filter {
    $0.dupIndexes.count > 0
}

let _ = dupFileList.map { fileInfo in
    for idx in fileInfo.dupIndexes {
        print("\(fileList[idx].absolute())".red)
    }
    print("---------------------------我是分隔符-----------------------------------".green)
}












