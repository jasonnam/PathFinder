//
//  Path.swift
//  PathFinder
//
//  Copyright (c) 2018 Jason Nam (https://jasonnam.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

/// File path.
open class Path {

    /// Custom attributes
    /// lasting for object life span.
    open var customAttributes: [String: Any] = [:]

    /// Raw value.
    open private(set) var rawValue: URL

    /// Absolute string value.
    open var absoluteString: String {
        return rawValue.absoluteString
    }

    /// Name of the file or directory.
    open var name: String {
        return rawValue.lastPathComponent
    }

    /// File extension.
    open var fileExtension: String {
        return rawValue.pathExtension
    }

    /// File exists.
    open var exists: Bool {
        return FileManager.default.fileExists(atPath: rawValue.absoluteString)
    }

    /// If the path is directory or not.
    open var isDirectory: Bool {
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: rawValue.absoluteString, isDirectory: &isDir)
        return isDir.boolValue
    }

    /// Parent path.
    open var parent: Path {
        return Path(url: rawValue.deletingLastPathComponent())
    }

    /// Init with string value.
    ///
    /// - Parameter string: Raw value.
    public init?(string: String) {
        guard let url = URL(string: string) else { return nil }
        rawValue = url
    }

    /// Init with URL.
    ///
    /// - Parameter url: Raw value.
    public init(url: URL) {
        rawValue = url
    }

    /// Init with search path directory.
    ///
    /// - Parameters:
    ///   - searchPathDirectory: Search path directory.
    ///                          `FileManager.SearchPathDirectory`
    ///   - domainMask: Search path domain mask.
    ///                 `FileManager.SearchPathDomainMask`
    ///   - expandTilde: Expand tilde.
    public init(searchPathDirectory: FileManager.SearchPathDirectory,
                domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
                expandTilde: Bool = true) {
        let path = NSSearchPathForDirectoriesInDomains(searchPathDirectory, domainMask, expandTilde)[0]
        rawValue = URL(string: path)!
    }

    /// Create directory at sub path.
    ///
    /// - Parameters:
    ///   - subPath: Relative path to directory.
    ///   - intermediateDirectories: Create intermediate directories.
    ///   - attributes: Directory attributes.
    /// - Returns: Created directory full path.
    /// - Throws: Create directory error.
    @discardableResult open func createDirectory(atSubPath subPath: String,
                                                 withIntermediateDirectories intermediateDirectories: Bool = true,
                                                 attributes: [FileAttributeKey: Any]? = nil) throws -> Path {
        let targetURL = rawValue.appendingPathComponent(subPath)
        try FileManager.default.createDirectory(at: targetURL,
                                                withIntermediateDirectories: intermediateDirectories,
                                                attributes: attributes)
        return Path(url: targetURL)
    }

    /// Create file at sub path.
    ///
    /// - Parameters:
    ///   - subPath: Relative path to file.
    ///   - contents: Content data.
    ///   - attributes: File attributes.
    /// - Returns: Created file full path.
    /// - Throws: Create file error. `CreateFileError`
    @discardableResult open func createFile(atSubPath subPath: String,
                                            contents: Data?,
                                            attributes: [FileAttributeKey: Any]? = nil) throws -> Path {
        let targetPath = Path(url: rawValue.appendingPathComponent(subPath))
        if targetPath.exists {
            throw CreateFileError.fileAlreadyExists(targetPath)
        }
        if !FileManager.default.createFile(atPath: targetPath.absoluteString,
                                           contents: contents,
                                           attributes: attributes) {
            throw CreateFileError.cannotCreateFile(targetPath)
        }
        return targetPath
    }

    /// Rename item.
    ///
    /// - Parameter newName: New name.
    /// - Returns: Renamed item path.
    /// - Throws: Error moving item.
    @discardableResult open func rename(to newName: String) throws -> Path {
        let newURL = rawValue.deletingLastPathComponent().appendingPathComponent(newName)
        try FileManager.default.moveItem(at: rawValue, to: newURL)
        return Path(url: newURL)
    }

    /// Move item.
    ///
    /// - Parameter path: Target path.
    /// - Throws: Error moving item.
    open func move(to path: Path) throws {
        try FileManager.default.moveItem(at: rawValue, to: path.rawValue)
    }

    /// Copy item.
    ///
    /// - Parameter path: Target path.
    /// - Throws: Error copying item.
    open func copy(to path: Path) throws {
        try FileManager.default.copyItem(at: rawValue, to: path.rawValue)
    }

    /// Remove item.
    ///
    /// - Throws: Error removing item.
    open func remove() throws {
        try FileManager.default.removeItem(at: rawValue)
    }

    #if os(macOS)
    /// Trash item.
    ///
    /// - Throws: Error trashing item.
    open func trash() throws {
        try FileManager.default.trashItem(at: rawValue, resultingItemURL: nil)
    }
    #endif

    /// Get contents of directory.
    ///
    /// - Parameter ignores: Contents to ignore.
    /// - Returns: Containing directories and files.
    /// - Throws: Error getting contents of directory.
    open func contents(ignores: [String] = []) throws -> (directories: [Path], files: [Path]) {
        if !exists {
            return ([], [])
        }

        let contents = try FileManager.default.contentsOfDirectory(atPath: absoluteString)

        var directories: [Path] = []
        var files: [Path] = []

        for content in contents {
            if ignores.contains(content) {
                continue
            }
            let contentPath = Path(url: rawValue.appendingPathComponent(content))
            if contentPath.isDirectory {
                directories.append(contentPath)
            } else {
                files.append(contentPath)
            }
        }

        return (directories, files)
    }

    /// Enumerate contents of directory with block.
    ///
    /// - Parameters:
    ///   - includeSubDirectory: Should include subdirectory.
    ///   - ignores: Contents to ignore.
    ///   - contentHandler: Content path handler.
    /// - Throws: Error getting contents of directory.
    open func enumerate(includeSubDirectory: Bool = true,
                        ignores: [String] = [],
                        contentHandler: ((Path) -> Void)) throws {
        let (directories, files) = try contents(ignores: ignores)
        for directory in directories {
            contentHandler(directory)
            if includeSubDirectory {
                try directory.enumerate(includeSubDirectory: true,
                                        ignores: ignores,
                                        contentHandler: contentHandler)
            }
        }
        for file in files {
            contentHandler(file)
        }
    }
}
