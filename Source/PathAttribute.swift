//
// PathAttribute.swift
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

public extension Path {
    public var exists: Bool {
        return fileManager.fileExistsAtPath(rawValue)
    }

    public func checkExists(path: Path) throws {
        if !path.exists {
            throw PathError.FileDoesNotExist(path: path)
        }
    }

    public var isDirectory: Bool {
        var isDir: ObjCBool = false
        fileManager.fileExistsAtPath(rawValue, isDirectory: &isDir)
        return Bool(isDir)
    }

    public var fileExtension: String {
        return rawValue.lastPathComponent.pathExtension
    }

    public var attributes: [String : AnyObject] {
        return (try? fileManager.attributesOfFileSystemForPath(rawValue)) ?? [:]
    }

    public var appendOnly: Bool? {
        if let appendOnly = attributes[NSFileAppendOnly] as? NSNumber {
            return appendOnly.boolValue
        } else {
            return nil
        }
    }

    public var busy: Bool? {
        if let busy = attributes[NSFileBusy] as? NSNumber {
            return busy.boolValue
        } else {
            return nil
        }
    }

    public var creationDate: NSDate? {
        return attributes[NSFileCreationDate] as? NSDate
    }

    public var ownerAccountName: String? {
        return attributes[NSFileOwnerAccountID] as? String
    }

    public var groupOwnerAccountName: String? {
        return attributes[NSFileGroupOwnerAccountName] as? String
    }

    public var deviceIdentifier: UInt? {
        if let deviceIdentifier = attributes[NSFileDeviceIdentifier] as? NSNumber {
            return deviceIdentifier.unsignedLongValue
        } else {
            return nil
        }
    }

    public var extensionHidden: Bool? {
        if let extensionHidden = attributes[NSFileExtensionHidden] as? NSNumber {
            return extensionHidden.boolValue
        } else {
            return nil
        }
    }

    public var groupOwnerAccountID: UInt? {
        if let groupOwnerAccountID = attributes[NSFileGroupOwnerAccountID] as? NSNumber {
            return groupOwnerAccountID.unsignedLongValue
        } else {
            return nil
        }
    }

    public var HFSCreatorCode: UInt? {
        if let HFSCreatorCode = attributes[NSFileHFSCreatorCode] as? NSNumber {
            return HFSCreatorCode.unsignedIntegerValue
        } else {
            return nil
        }
    }

    public var immutable: Bool? {
        if let immutable = attributes[NSFileImmutable] as? NSNumber {
            return immutable.boolValue
        } else {
            return nil
        }
    }

    public var modificationDate: NSDate? {
        return attributes[NSFileModificationDate] as? NSDate
    }

    public var ownerAccountID: UInt? {
        if let ownerAccountID = attributes[NSFileOwnerAccountID] as? NSNumber {
            return ownerAccountID.unsignedLongValue
        } else {
            return nil
        }
    }

    public var posixPermissions: Int16? {
        if let posixPermissions = attributes[NSFilePosixPermissions] as? NSNumber {
            return posixPermissions.shortValue
        } else {
            return nil
        }
    }

    public var referenceCount: UInt? {
        if let referenceCount = attributes[NSFileReferenceCount] as? NSNumber {
            return referenceCount.unsignedLongValue
        } else {
            return nil
        }
    }

    public var size: UInt64? {
        if let size = attributes[NSFileSize] as? NSNumber {
            return size.unsignedLongLongValue
        } else {
            return nil
        }
    }
}
