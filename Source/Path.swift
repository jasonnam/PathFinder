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

public class Path {
    let fileManager = NSFileManager.defaultManager()

    public var rawValue: String = ""
    public var customAttributes: [String: Any] = [:]

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

    public convenience init(searchPathDirectory: NSSearchPathDirectory, domainMask: NSSearchPathDomainMask) {
        self.init(searchPathDirectory: searchPathDirectory, domainMask: domainMask, expandTilde: true)
    }

    public convenience init(searchPathDirectory: NSSearchPathDirectory) {
        self.init(searchPathDirectory: searchPathDirectory, domainMask: .UserDomainMask, expandTilde: true)
    }
}

public extension Path {
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

public extension Path {
    /// Returns the path to the user's or application's home directory,
    /// depending on the platform.
    public static var UserHome: Path {
        return Path(NSHomeDirectory())
    }

    /// Returns the path to the user's temporary directory.
    public static var UserTemporary: Path {
        return Path(NSTemporaryDirectory())
    }

    /// Returns a temporary path for the process.
    public static var ProcessTemporary: Path {
        return Path.UserTemporary + NSProcessInfo.processInfo().globallyUniqueString
    }

    /// Returns a unique temporary path.
    public static var UniqueTemporary: Path {
        return Path.ProcessTemporary + NSUUID().UUIDString
    }

    /// Returns the path to the user's caches directory.
    public static var UserCaches: Path {
        return pathInUserDomain(.CachesDirectory)
    }

    /// Returns the path to the user's applications directory.
    public static var UserApplications: Path {
        return pathInUserDomain(.ApplicationDirectory)
    }

    /// Returns the path to the user's application support directory.
    public static var UserApplicationSupport: Path {
        return pathInUserDomain(.ApplicationSupportDirectory)
    }

    /// Returns the path to the user's desktop directory.
    public static var UserDesktop: Path {
        return pathInUserDomain(.DesktopDirectory)
    }

    /// Returns the path to the user's documents directory.
    public static var UserDocuments: Path {
        return pathInUserDomain(.DocumentDirectory)
    }

    /// Returns the path to the user's autosaved documents directory.
    public static var UserAutosavedInformation: Path {
        return pathInUserDomain(.AutosavedInformationDirectory)
    }

    /// Returns the path to the user's downloads directory.
    public static var UserDownloads: Path {
        return pathInUserDomain(.DownloadsDirectory)
    }

    /// Returns the path to the user's library directory.
    public static var UserLibrary: Path {
        return pathInUserDomain(.LibraryDirectory)
    }

    /// Returns the path to the user's movies directory.
    public static var UserMovies: Path {
        return pathInUserDomain(.MoviesDirectory)
    }

    /// Returns the path to the user's music directory.
    public static var UserMusic: Path {
        return pathInUserDomain(.MusicDirectory)
    }

    /// Returns the path to the user's pictures directory.
    public static var UserPictures: Path {
        return pathInUserDomain(.PicturesDirectory)
    }

    /// Returns the path to the user's Public sharing directory.
    public static var UserSharedPublic: Path {
        return pathInUserDomain(.SharedPublicDirectory)
    }

    #if os(OSX)

    /// Returns the path to the user scripts folder for the calling application
    public static var UserApplicationScripts: Path {
        return pathInUserDomain(.ApplicationScriptsDirectory)
    }

    /// Returns the path to the user's trash directory
    public static var UserTrash: Path {
        return pathInUserDomain(.TrashDirectory)
    }

    #endif

    /// Returns the path to the system's applications directory.
    public static var SystemApplications: Path {
        return pathInSystemDomain(.ApplicationDirectory)
    }

    /// Returns the path to the system's application support directory.
    public static var SystemApplicationSupport: Path {
        return pathInSystemDomain(.ApplicationSupportDirectory)
    }

    /// Returns the path to the system's library directory.
    public static var SystemLibrary: Path {
        return pathInSystemDomain(.LibraryDirectory)
    }

    /// Returns the path to the system's core services directory.
    public static var SystemCoreServices: Path {
        return pathInSystemDomain(.CoreServiceDirectory)
    }

    /// Returns the path to the system's PPDs directory.
    public static var SystemPrinterDescription: Path {
        return pathInSystemDomain(.PrinterDescriptionDirectory)
    }

    /// Returns the path to the system's PreferencePanes directory.
    public static var SystemPreferencePanes: Path {
        return pathInSystemDomain(.PreferencePanesDirectory)
    }

    /// Returns the paths where resources can occur.
    public static var AllLibraries: [Path] {
        return pathsInDomains(.AllLibrariesDirectory, domainMask: .AllDomainsMask)
    }

    /// Returns the paths where applications can occur
    public static var AllApplications: [Path] {
        return pathsInDomains(.AllApplicationsDirectory, domainMask: .AllDomainsMask)
    }

    private static func pathInUserDomain(searchPathDirectory: NSSearchPathDirectory) -> Path {
        return Path(searchPathDirectory: searchPathDirectory, domainMask: .UserDomainMask)
    }

    private static func pathInSystemDomain(searchPathDirectory: NSSearchPathDirectory) -> Path {
        return Path(searchPathDirectory: searchPathDirectory, domainMask: .SystemDomainMask)
    }

    private static func pathsInDomains(searchPathDirectory: NSSearchPathDirectory, domainMask: NSSearchPathDomainMask) -> [Path] {
        return NSSearchPathForDirectoriesInDomains(searchPathDirectory, domainMask, true).map({ Path($0) })
    }
}
