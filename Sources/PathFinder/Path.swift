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

public func +(left: Path, right: Path) -> Path {
    return left[right]
}

public func +(left: Path, right: String) -> Path {
    return left[right]
}

/// File path.
open class Path {

    /// Custom attributes
    /// lasting for object life span.
    open var customAttributes: [String: Any] = [:]

    /// Raw value.
    open private(set) var rawValue: String

    // MARK: - Init

    /// Init with empty value.
    public init() {
        rawValue = ""
    }

    /// Init with string value.
    ///
    /// - Parameter string: Raw value.
    public init(string: String) {
        rawValue = string
    }

    /// Init with URL.
    ///
    /// - Parameter url: Raw value.
    public init(url: URL) {
        rawValue = url.absoluteString
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
        rawValue = NSSearchPathForDirectoriesInDomains(searchPathDirectory, domainMask, expandTilde)[0]
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
