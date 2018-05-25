//
// Path.swift
// PathFinder
//
// Copyright (c) 2016 Jason Nam (http://www.jasonnam.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// Check https://github.com/nvzqz/FileKit/blob/develop/FileKit/Core/Path.swift
//

import Foundation

public func +(left: Path, right: Path) -> Path {
    return left[right]
}

public func +(left: Path, right: String) -> Path {
    return left[right]
}

open class Path {
    private let fileManager = FileManager.default

    open var rawValue: String = ""
    open var customAttributes: [String: Any] = [:]

    public init() {
        rawValue = ""
    }

    public convenience init(_ rawValue: String) {
        self.init()
        self.rawValue = rawValue
    }

    public convenience init(searchPathDirectory: FileManager.SearchPathDirectory, domainMask: FileManager.SearchPathDomainMask, expandTilde: Bool) {
        self.init(NSSearchPathForDirectoriesInDomains(searchPathDirectory, domainMask, expandTilde)[0])
    }

    public convenience init(searchPathDirectory: FileManager.SearchPathDirectory, domainMask: FileManager.SearchPathDomainMask) {
        self.init(searchPathDirectory: searchPathDirectory, domainMask: domainMask, expandTilde: true)
    }

    public convenience init(searchPathDirectory: FileManager.SearchPathDirectory) {
        self.init(searchPathDirectory: searchPathDirectory, domainMask: .userDomainMask, expandTilde: true)
    }

    open var asString: String {
        return rawValue
    }

    open var asURL: URL {
        return URL(fileURLWithPath: rawValue)
    }

    open var name: String {
        return rawValue.lastPathComponent
    }

    open var exists: Bool {
        return fileManager.fileExists(atPath: rawValue)
    }

    open var isDirectory: Bool {
        var isDir: ObjCBool = false
        fileManager.fileExists(atPath: rawValue, isDirectory: &isDir)
        return isDir.boolValue
    }

    open var fileExtension: String {
        return rawValue.lastPathComponent.pathExtension
    }

    open var parent: Path {
        return Path(rawValue.stringByDeletingLastPathComponent)
    }

    open var data: Data? {
        return fileManager.contents(atPath: rawValue)
    }

    open var dataAsString: String {
        return (try? NSString(contentsOfFile: rawValue, encoding: String.Encoding.utf8.rawValue) as String) ?? ""
    }

    /// Returns the path to the user's or application's home directory,
    /// depending on the platform.
    open static var userHome: Path {
        return Path(NSHomeDirectory())
    }

    /// Returns the path to the user's temporary directory.
    open static var userTemporary: Path {
        return Path(NSTemporaryDirectory())
    }

    /// Returns a temporary path for the process.
    open static var processTemporary: Path {
        return Path.userTemporary + ProcessInfo.processInfo.globallyUniqueString
    }

    /// Returns a unique temporary path.
    open static var uniqueTemporary: Path {
        return Path.processTemporary + UUID().uuidString
    }

    /// Returns the path to the user's caches directory.
    open static var userCaches: Path {
        return pathInUserDomain(.cachesDirectory)
    }

    /// Returns the path to the user's applications directory.
    open static var userApplications: Path {
        return pathInUserDomain(.applicationDirectory)
    }

    /// Returns the path to the user's application support directory.
    open static var userApplicationSupport: Path {
        return pathInUserDomain(.applicationSupportDirectory)
    }

    /// Returns the path to the user's desktop directory.
    open static var userDesktop: Path {
        return pathInUserDomain(.desktopDirectory)
    }

    /// Returns the path to the user's documents directory.
    open static var userDocuments: Path {
        return pathInUserDomain(.documentDirectory)
    }

    /// Returns the path to the user's autosaved documents directory.
    open static var userAutosavedInformation: Path {
        return pathInUserDomain(.autosavedInformationDirectory)
    }

    /// Returns the path to the user's downloads directory.
    open static var userDownloads: Path {
        return pathInUserDomain(.downloadsDirectory)
    }

    /// Returns the path to the user's library directory.
    open static var userLibrary: Path {
        return pathInUserDomain(.libraryDirectory)
    }

    /// Returns the path to the user's movies directory.
    open static var userMovies: Path {
        return pathInUserDomain(.moviesDirectory)
    }

    /// Returns the path to the user's music directory.
    open static var userMusic: Path {
        return pathInUserDomain(.musicDirectory)
    }

    /// Returns the path to the user's pictures directory.
    open static var userPictures: Path {
        return pathInUserDomain(.picturesDirectory)
    }

    /// Returns the path to the user's Public sharing directory.
    open static var userSharedPublic: Path {
        return pathInUserDomain(.sharedPublicDirectory)
    }

    #if os(OSX)

    /// Returns the path to the user scripts folder for the calling application
    open static var userApplicationScripts: Path {
        return pathInUserDomain(.applicationScriptsDirectory)
    }

    /// Returns the path to the user's trash directory
    open static var userTrash: Path {
        return pathInUserDomain(.trashDirectory)
    }

    #endif

    /// Returns the path to the system's applications directory.
    open static var systemApplications: Path {
        return pathInSystemDomain(.applicationDirectory)
    }

    /// Returns the path to the system's application support directory.
    open static var systemApplicationSupport: Path {
        return pathInSystemDomain(.applicationSupportDirectory)
    }

    /// Returns the path to the system's library directory.
    open static var systemLibrary: Path {
        return pathInSystemDomain(.libraryDirectory)
    }

    /// Returns the path to the system's core services directory.
    open static var systemCoreServices: Path {
        return pathInSystemDomain(.coreServiceDirectory)
    }

    /// Returns the path to the system's PPDs directory.
    open static var systemPrinterDescription: Path {
        return pathInSystemDomain(.printerDescriptionDirectory)
    }

    /// Returns the path to the system's PreferencePanes directory.
    open static var systemPreferencePanes: Path {
        return pathInSystemDomain(.preferencePanesDirectory)
    }

    /// Returns the paths where resources can occur.
    open static var allLibraries: [Path] {
        return pathsInDomains(.allLibrariesDirectory, domainMask: .allDomainsMask)
    }

    /// Returns the paths where applications can occur
    open static var allApplications: [Path] {
        return pathsInDomains(.allApplicationsDirectory, domainMask: .allDomainsMask)
    }

    open static func pathInUserDomain(_ searchPathDirectory: FileManager.SearchPathDirectory) -> Path {
        return Path(searchPathDirectory: searchPathDirectory, domainMask: .userDomainMask)
    }

    open static func pathInSystemDomain(_ searchPathDirectory: FileManager.SearchPathDirectory) -> Path {
        return Path(searchPathDirectory: searchPathDirectory, domainMask: .systemDomainMask)
    }

    open static func pathsInDomains(_ searchPathDirectory: FileManager.SearchPathDirectory, domainMask: FileManager.SearchPathDomainMask) -> [Path] {
        return NSSearchPathForDirectoriesInDomains(searchPathDirectory, domainMask, true).map({ Path($0) })
    }

    open var attributes: [FileAttributeKey : Any] {
        return (try? fileManager.attributesOfItem(atPath: rawValue)) ?? [:]
    }

    open var appendOnly: Bool? {
        return (attributes[FileAttributeKey.appendOnly] as? NSNumber)?.boolValue
    }

    open var busy: Bool? {
        return (attributes[FileAttributeKey.busy] as? NSNumber)?.boolValue
    }

    open var creationDate: Date? {
        return attributes[FileAttributeKey.creationDate] as? Date
    }

    open var ownerAccountName: String? {
        return attributes[FileAttributeKey.ownerAccountID] as? String
    }

    open var groupOwnerAccountName: String? {
        return attributes[FileAttributeKey.groupOwnerAccountName] as? String
    }

    open var deviceIdentifier: UInt? {
        return (attributes[FileAttributeKey.deviceIdentifier] as? NSNumber)?.uintValue
    }

    open var extensionHidden: Bool? {
        return (attributes[FileAttributeKey.extensionHidden] as? NSNumber)?.boolValue
    }

    open var groupOwnerAccountID: UInt? {
        return (attributes[FileAttributeKey.groupOwnerAccountID] as? NSNumber)?.uintValue
    }

    open var HFSCreatorCode: UInt? {
        return (attributes[FileAttributeKey.hfsCreatorCode] as? NSNumber)?.uintValue
    }

    open var immutable: Bool? {
        return (attributes[FileAttributeKey.immutable] as? NSNumber)?.boolValue
    }

    open var modificationDate: Date? {
        return attributes[FileAttributeKey.modificationDate] as? Date
    }

    open var ownerAccountID: UInt? {
        return (attributes[FileAttributeKey.ownerAccountID] as? NSNumber)?.uintValue
    }

    open var posixPermissions: Int16? {
        return (attributes[FileAttributeKey.posixPermissions] as? NSNumber)?.int16Value
    }

    open var referenceCount: UInt? {
        return (attributes[FileAttributeKey.referenceCount] as? NSNumber)?.uintValue
    }

    open var size: UInt64? {
        return (attributes[FileAttributeKey.size] as? NSNumber)?.uint64Value
    }

    open func newDirectory(at subPath: String, withIntermediateDirectories intermediateDirectories: Bool = false, with attributes: [String: Any]? = nil) throws {
        do {
            let newPath = rawValue.stringByAppending(pathComponent: subPath)
            try fileManager.createDirectory(atPath: newPath, withIntermediateDirectories: intermediateDirectories, attributes: attributes)
        } catch {
            throw error
        }
    }

    open func touch(name: String, contents: Data?, attributes: [String: Any]? = nil) throws {
        if !fileManager.createFile(atPath: self[name].asString, contents: contents, attributes: attributes) {
            throw PathError.createFileFail(path: self[name])
        }
    }

    open func remove() throws {
        do {
            try fileManager.removeItem(atPath: rawValue)
        } catch {
            throw error
        }
    }

    open func rename(to name: String) throws {
        do {
            let newPath = rawValue.stringByDeletingLastPathComponent.stringByAppending(pathComponent: name)
            try fileManager.moveItem(atPath: rawValue, toPath: newPath)
        } catch {
            throw error
        }
    }

    open func copy(to path: Path) throws {
        do {
            try fileManager.copyItem(atPath: rawValue, toPath: path.asString)
        } catch {
            throw error
        }
    }

    open func move(to path: Path) throws {
        do {
            try fileManager.moveItem(atPath: rawValue, toPath: path.asString)
        } catch {
            throw error
        }
    }

    open func checkUnique(_ name: String, caseSensitive: Bool) throws -> Bool {
        if !isDirectory {
            throw PathError.isNotDirectory(path: self)
        }

        var unique = true

        let nameToCompare = caseSensitive ? name : name.lowercased()

        do {
            try enumerate { path in
                let pathName = caseSensitive ? path.name : path.name.lowercased()
                if nameToCompare == pathName {
                    unique = false
                }
            }
        } catch {
            return false
        }
        
        return unique
    }

    open func contents(exclude: [String]? = nil) throws -> [Path] {
        guard exists else {
            return []
        }

        do {
            let contents = try fileManager.contentsOfDirectory(atPath: rawValue)

            var folder: [Path] = []
            var file: [Path] = []

            contents.forEach { content in
                let contentPath = Path(rawValue.stringByAppending(pathComponent: content))

                if !(exclude != nil && exclude!.contains(content)) {
                    if contentPath.isDirectory {
                        folder.append(contentPath)
                    } else {
                        file.append(contentPath)
                    }
                }
            }

            folder.sort { $0.name < $1.name }
            file.sort { $0.name < $1.name }

            return folder + file
        } catch {
            throw error
        }
    }

    open func enumerate(includeSubDirectory: Bool = false, exclude: [String]? = nil, block: ((Path) -> Void)) throws {
        do {
            try contents(exclude: exclude).forEach { content in
                block(content)
                if content.isDirectory && includeSubDirectory {
                    try content.enumerate(includeSubDirectory: true, block: block)
                }
            }
        } catch {
            throw error
        }
    }

    open subscript(name: String) -> Path {
        return Path(rawValue.stringByAppending(pathComponent: name))
    }

    open subscript(path: Path) -> Path {
        return Path(rawValue.stringByAppending(pathComponent: path.rawValue))
    }
}
