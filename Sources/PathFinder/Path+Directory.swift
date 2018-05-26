//
//  Path+Directory.swift
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

//  Refer:
//  https://developer.apple.com/documentation/foundation/filemanager
//  https://developer.apple.com/documentation/foundation/filemanager.searchpathdirectory
//  https://developer.apple.com/documentation/foundation/filemanager/1412643-containerurl

import Foundation

// MARK: - Directory
public extension Path {

    /// Returns the container directory associated with
    /// the specified security application group identifier.
    ///
    /// - Parameter securityApplicationGroupIdentifier: A string that names the group whose
    ///                                                 shared directory you want to obtain.
    /// - Returns: Container directory path.
    public static func containerURL(forSecurityApplicationGroupIdentifier
        securityApplicationGroupIdentifier: String) -> Path? {
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: securityApplicationGroupIdentifier) else { return nil }
        return Path(url: containerURL)
    }

    /// Returns a string containing
    /// the full name of the current user.
    public static var fullUserName: String {
        return NSFullUserName()
    }

    /// Returns the path to either the user’s or
    /// application’s home directory, depending on the platform.
    public static var homeDirectory: Path {
        return Path(string: NSHomeDirectory())!
    }

    /// Returns the path to a given user’s home directory.
    ///
    /// - Parameter userName: The name of a user.
    /// - Returns: The path to the home directory for the user specified by userName.
    public static func homeDirectory(forUser userName: String) -> Path? {
        guard let homeDirectoryForUser = NSHomeDirectoryForUser(userName) else { return nil }
        return Path(string: homeDirectoryForUser)
    }

    /// Returns the root directory of the user’s system.
    public static var openStepRootDirectory: Path {
        return Path(string: NSOpenStepRootDirectory())!
    }

    /// Returns the path to the user's temporary directory.
    public static var temporaryDirectory: Path {
        return Path(string: NSTemporaryDirectory())!
    }

    /// Returns the logon name of the current user.
    public static var userName: String {
        return NSUserName()
    }

    /// Supported applications (`/Applications`).
    public static var applicationDirectory: Path {
        return Path(searchPathDirectory: .applicationDirectory)
    }

    /// Unsupported applications and demonstration versions.
    public static var demoApplicationDirectory: Path {
        return Path(searchPathDirectory: .demoApplicationDirectory)
    }

    /// Developer applications (`/Developer/Applications`).
    public static var developerApplicationDirectory: Path {
        return Path(searchPathDirectory: .developerApplicationDirectory)
    }

    /// System and network administration applications.
    public static var adminApplicationDirectory: Path {
        return Path(searchPathDirectory: .adminApplicationDirectory)
    }

    /// Various user-visible documentation,
    /// support, and configuration files (`/Library`).
    public static var libraryDirectory: Path {
        return Path(searchPathDirectory: .libraryDirectory)
    }

    /// Developer resources (`/Developer`).
    public static var developerDirectory: Path {
        return Path(searchPathDirectory: .developerDirectory)
    }

    /// User home directories (`/Users`).
    public static var userDirectory: Path {
        return Path(searchPathDirectory: .userDirectory)
    }

    /// Documentation.
    public static var documentationDirectory: Path {
        return Path(searchPathDirectory: .documentationDirectory)
    }

    /// Document directory.
    public static var documentDirectory: Path {
        return Path(searchPathDirectory: .documentDirectory)
    }

    /// Location of core services (`System/Library/CoreServices`).
    public static var coreServiceDirectory: Path {
        return Path(searchPathDirectory: .coreServiceDirectory)
    }

    /// Location of user’s autosaved
    /// documents `Library/Autosave Information`
    public static var autosavedInformationDirectory: Path {
        return Path(searchPathDirectory: .autosavedInformationDirectory)
    }

    /// Location of user’s desktop directory.
    public static var desktopDirectory: Path {
        return Path(searchPathDirectory: .desktopDirectory)
    }

    /// Location of discardable cache files (`Library/Caches`).
    public static var cachesDirectory: Path {
        return Path(searchPathDirectory: .cachesDirectory)
    }

    /// Location of application support files (`Library/Application Support`).
    public static var applicationSupportDirectory: Path {
        return Path(searchPathDirectory: .applicationSupportDirectory)
    }

    /// Location of the user’s downloads directory.
    public static var downloadsDirectory: Path {
        return Path(searchPathDirectory: .downloadsDirectory)
    }

    /// Location of Input Methods (`Library/Input Methods`)
    public static var inputMethodsDirectory: Path {
        return Path(searchPathDirectory: .inputMethodsDirectory)
    }

    /// Location of user's Movies directory (`~/Movies`)
    public static var moviesDirectory: Path {
        return Path(searchPathDirectory: .moviesDirectory)
    }

    /// Location of user's Music directory (`~/Music`)
    public static var musicDirectory: Path {
        return Path(searchPathDirectory: .musicDirectory)
    }

    /// Location of user's Pictures directory (`~/Pictures`)
    public static var picturesDirectory: Path {
        return Path(searchPathDirectory: .picturesDirectory)
    }

    /// Location of system's PPDs directory (`Library/Printers/PPDs`)
    public static var printerDescriptionDirectory: Path {
        return Path(searchPathDirectory: .printerDescriptionDirectory)
    }

    /// Location of user's Public sharing directory (`~/Public`)
    public static var sharedPublicDirectory: Path {
        return Path(searchPathDirectory: .sharedPublicDirectory)
    }

    /// Location of the PreferencePanes directory for
    /// use with System Preferences (`Library/PreferencePanes`)
    public static var preferencePanesDirectory: Path {
        return Path(searchPathDirectory: .preferencePanesDirectory)
    }

    #if os(macOS)
    /// Location of the user scripts folder for the calling
    /// application (`~/Library/Application Scripts/<code-signing-id>`)
    public static var applicationScriptsDirectory: Path {
        return Path(searchPathDirectory: .applicationScriptsDirectory)
    }
    #endif

    /// Passed to the FileManager method url(for:in:appropriateFor:create:)
    /// in order to create a temporary directory.
    public static var itemReplacementDirectory: Path {
        return Path(searchPathDirectory: .itemReplacementDirectory)
    }

    /// All directories where applications can occur.
    public static var allApplicationsDirectory: Path {
        return Path(searchPathDirectory: .allApplicationsDirectory)
    }

    /// All directories where resources can occur.
    public static var allLibrariesDirectory: Path {
        return Path(searchPathDirectory: .allLibrariesDirectory)
    }

    #if os(macOS) || os(iOS)
    /// Location of the trash directory.
    public static var trashDirectory: Path {
        return Path(searchPathDirectory: .trashDirectory)
    }
    #endif
}
