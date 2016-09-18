//
//  FileHeaderChecker.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09.11.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

private extension String {
   func trimmingWhitespaces() -> String {
      return trimmingCharacters(in: CharacterSet.whitespaces)
   }
}

public struct FileHeaderCheckerIssue {
   public var filePath: String
   public var issueReason: String
}

private enum FHCError: Error {
   case FileHeaderCheckerIssue(String)
}

// MARK: ->

struct FileHeaderContents {
   var fileNameComponent: FileHeaderComponent
   var projectNameComponent: FileHeaderComponent
   var authorComponent: FileHeaderComponent
   var copyrightComponent: FileHeaderComponent
   private var invalidComponents: [FileHeaderComponent] {
      let components = [fileNameComponent, projectNameComponent, authorComponent, copyrightComponent].filter {
         return $0.valid == false
      }
      return components
   }
   var valid: Bool {
      return invalidComponents.count == 0
   }
   var issueReason: String {
      if valid {
         return ""
      }
      let reason = invalidComponents.reduce("") { (result: String, element: FileHeaderComponent) -> String in
         return result.isEmpty ? element.prefix : result + ", " + element.prefix
      }
      return "Invalid or missed header fields: " + reason
   }

   init(fileName: String, projectName: String, author: String, copyright: String, hasPrefixes: Bool = true) {
      if hasPrefixes {
         fileNameComponent = FileHeaderComponent(prefix: "File", fullValue: fileName)
         projectNameComponent = FileHeaderComponent(prefix: "Project", fullValue: projectName)
         authorComponent = FileHeaderComponent(prefix: "Author", fullValue: author)
         copyrightComponent = FileHeaderComponent(prefix: "Copyright", fullValue: copyright)
      } else {
         fileNameComponent = FileHeaderComponentWithoutPrefix(fullValue: fileName)
         projectNameComponent = FileHeaderComponentWithoutPrefix(fullValue: projectName)
         authorComponent = FileHeaderComponentWithoutPrefix(fullValue: author)
         copyrightComponent = FileHeaderComponentWithoutPrefix(fullValue: copyright)
      }
   }
}

// MARK: ->

class FileHeaderComponent {
   var fullValue: String
   var prefix = ""
   var value = ""
   var valid = false

   init(prefix aPrefix: String, fullValue aFullValue: String) {
      prefix = aPrefix
      fullValue = aFullValue
      validate()
   }

   func validate() {
      let correctedPrefix = prefix + ": "
      if fullValue.hasPrefix(correctedPrefix) {
         let indexFrom = fullValue.index(fullValue.startIndex, offsetBy: correctedPrefix.characters.count)
         let val = fullValue.substring(from: indexFrom)
         value = val.trimmingCharacters(in: CharacterSet.whitespaces)
         if !value.isEmpty {
            valid = true
         }
      }
   }
}

class FileHeaderComponentWithoutPrefix: FileHeaderComponent {
   init(fullValue aFullValue: String) {
      super.init(prefix: "", fullValue: aFullValue)
      valid = !aFullValue.isEmpty
      value = fullValue
   }
}

// MARK: ->

public final class FileHeaderChecker {
   private lazy var fileManager = FileManager.default
   private var knownExtensions: [String]
   private var projectNames: [String]

   //  MARK: -> Public
   public init(projectNames names: [String], fileExtensions: [String] = ["h", "m", "mm", "swift", "metal"]) {
      projectNames = names
      knownExtensions = fileExtensions
   }

   public func performAnalysis(fileOrDirectoryPath: String) throws -> [FileHeaderCheckerIssue] {
      var filePathsToAnalyze = [String]()
      if fileManager.regularFileExists(atPath: fileOrDirectoryPath) {
         if knownExtensions.contains(fileOrDirectoryPath.pathExtension) {
            filePathsToAnalyze.append(fileOrDirectoryPath)
         }
      } else if fileManager.directoryExists(atPath: fileOrDirectoryPath) {
         let enumerator = fileManager.enumerator(atPath: fileOrDirectoryPath)
         while let filePath = enumerator?.nextObject() as? String {
            if knownExtensions.contains(filePath.pathExtension) {
               let srcFilePath = fileOrDirectoryPath.appending(pathComponent: filePath)
               filePathsToAnalyze.append(srcFilePath)
            }
         }
      } else {
         throw FileManagerError.CanNotOpenFileAtPath(fileOrDirectoryPath)
      }

      var issues = [FileHeaderCheckerIssue]()
      for filePath in filePathsToAnalyze {
         let headerContents = try readFileHeader(filePath)
         if let headerIssue = try analyseHeader(filePath, headerContents: headerContents) {
            issues.append(headerIssue)
         }
      }
      return issues
   }

   // MARK: -> Private

   private func readFileHeader(_ filePath: String) throws -> String {
      if let fh = FileHandle(forReadingAtPath: filePath) {
         let headerData = fh.readData(ofLength: 256)
         if let headerContents = NSString(data: headerData, encoding: String.Encoding.utf8.rawValue) as? String {
            return headerContents
         } else {
            throw FileManagerError.CanNotOpenFileAtPath(filePath)
         }
      } else {
         throw FileManagerError.CanNotOpenFileAtPath(filePath)
      }
   }

   private func analyseHeader(_ filePath: String, headerContents: String) throws -> FileHeaderCheckerIssue? {

      var fileHeader: FileHeaderContents?
      do {
         if headerContents.hasPrefix("///") {
            fileHeader = try analyzeHeaderType1(filePath, headerContents: headerContents)
         } else if headerContents.hasPrefix("/**") {
            fileHeader = try analyzeHeaderType2(filePath, headerContents: headerContents)
         } else if headerContents.hasPrefix("//!") {
            // 3rd party source file.
            return nil
         } else {

            fileHeader = try analyzeHeaderType3(filePath, headerContents: headerContents)

         }
      } catch FHCError.FileHeaderCheckerIssue(let reason) {
         return FileHeaderCheckerIssue(filePath: filePath, issueReason: reason)
      }

      guard let headerComponents = fileHeader else {
         return nil
      }

      if !headerComponents.valid {
         return FileHeaderCheckerIssue(filePath: filePath, issueReason:headerComponents.issueReason)
      } else {
         let actualFilename = headerComponents.fileNameComponent.value
         let expectedFileName = filePath.lastPathComponent
         if actualFilename != expectedFileName {
            return FileHeaderCheckerIssue(filePath: filePath,
                                          issueReason:"Incorrect file name. Expected file name \"\(expectedFileName)\".")
         }

         let observerProjectName = headerComponents.projectNameComponent.value
         if !projectNames.contains(observerProjectName) {
            return FileHeaderCheckerIssue(filePath: filePath,
               issueReason:"Incorrect project name: expected=\"\(projectNames)\"; observed=\"\(observerProjectName)\".")
         }
      }

      return nil
   }

   private func analyzeHeaderType1(_ filePath: String, headerContents: String) throws -> FileHeaderContents {
      let componentsUnfiltered = headerContents.components(separatedBy: CharacterSet(charactersIn: "\n\r"))

      var components = [String]()
      for component in componentsUnfiltered {
         if component.hasPrefix("/// ") {
            let index = component.index(component.startIndex, offsetBy: "/// ".characters.count)
            components.append(component.substring(from: index).trimmingCharacters(in: CharacterSet.whitespaces))
         } else {
            break
         }
      }

      if components.count != 4 {
         throw FHCError.FileHeaderCheckerIssue("Unexpected header structure. Should be 4 lines starting from \"/// \".")
      }

      let fileHeader = FileHeaderContents(fileName: components[0], projectName: components[1],
                                          author: components[2], copyright: components[3])
      return fileHeader
   }

   private func analyzeHeaderType2(_ filePath: String, headerContents: String) throws -> FileHeaderContents {
      let componentsUnfiltered = headerContents.components(separatedBy: CharacterSet(charactersIn: "\n\r"))

      var componentsFiltered = [String]()
      for component in componentsUnfiltered {
         if component.hasPrefix("/**") || component.hasPrefix(" *") || component.hasPrefix(" */") {
            componentsFiltered.append(component)
         } else {
            break
         }
      }

      if componentsFiltered.count != 7 {
         throw FHCError.FileHeaderCheckerIssue("Unexpected header structure. Should be 7 lines for this header type.")
      }

      let componentsToProcess = [componentsFiltered[1], componentsFiltered[2], componentsFiltered[4], componentsFiltered[5]]
      let components: [String] = componentsToProcess.map {
         let index = $0.index($0.startIndex, offsetBy: " * ".characters.count)
         return $0.substring(from: index).trimmingWhitespaces()
      }
      let fileHeader = FileHeaderContents(fileName: components[0], projectName: components[1],
                                          author: components[2], copyright: components[3])
      return fileHeader
   }

   private func analyzeHeaderType3(_ filePath: String, headerContents: String) throws -> FileHeaderContents {
      let componentsUnfiltered = headerContents.components(separatedBy: CharacterSet(charactersIn: "\n\r"))

      var components = [String]()
      for component in componentsUnfiltered {
         if component.hasPrefix("//") {
            let index = component.index(component.startIndex, offsetBy: "//".characters.count)
            let value = component.substring(from: index).trimmingWhitespaces()
            components.append(value)
         } else {
            break
         }
      }

      if components.count != 7 {
         throw FHCError.FileHeaderCheckerIssue("Unexpected header structure. Should be 7 lines starting from \"//\".")
      }

      let fileHeader = FileHeaderContents(fileName: components[1], projectName: components[2],
                                          author: components[4], copyright: components[5], hasPrefixes: false)
      return fileHeader
   }

}
