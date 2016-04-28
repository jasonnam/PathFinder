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

import Foundation

public class Path {
    let fileManager = NSFileManager.defaultManager()

    public var rawValue: String = ""

    public init() {
        rawValue = ""
    }

    public convenience init(_ rawValue: String) {
        self.init()
        self.rawValue = rawValue
    }

    public convenience init(searchPathDirectory: NSSearchPathDirectory, domainMask: NSSearchPathDomainMask, expandTilde: Bool) {
        self.init(NSSearchPathForDirectoriesInDomains(searchPathDirectory, domainMask, expandTilde)[0])
    }

    public convenience init(searchPathDirectory: NSSearchPathDirectory) {
        self.init(searchPathDirectory: searchPathDirectory, domainMask: .UserDomainMask, expandTilde: true)
    }

    public var customAttributes: [String: Any] = [:]

    #if os(iOS)

    public static var homeDirectory: Path {
        return Path(NSHomeDirectory())
    }

    public static var documentsDirectory: Path {
        return Path(searchPathDirectory: .DocumentDirectory)
    }

    public static var libraryDirectory: Path {
        return Path(searchPathDirectory: .LibraryDirectory)
    }

    public static var cacheDirectory: Path {
        return Path(searchPathDirectory: .CachesDirectory)
    }

    public static var temporaryDirectory: Path {
        return Path(NSTemporaryDirectory())
    }

    #endif

    public func toString() -> String {
        return rawValue
    }

    public func toURL() -> NSURL {
        return NSURL(fileURLWithPath: rawValue)
    }

    public var name: String {
        return rawValue.lastPathComponent
    }

    public var parent: Path {
        return Path(rawValue.stringByDeletingLastPathComponent)
    }

    public var data: NSData? {
        return fileManager.contentsAtPath(rawValue)
    }

    public var dataAsString: String {
        do {
            return try NSString(contentsOfFile: rawValue, encoding: NSUTF8StringEncoding) as String
        }
        catch {
            return ""
        }
    }
}
