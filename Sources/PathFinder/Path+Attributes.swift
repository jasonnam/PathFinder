//
//  Path+Attributes.swift
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
//  https://developer.apple.com/documentation/foundation/filemanager/1410452-attributesofitem
//  https://developer.apple.com/documentation/foundation/fileattributekey

import Foundation

// MARK: - Attributes
public extension Path {

    /// Set attributes.
    ///
    /// - Parameter attributes: Attributes to update.
    /// - Throws: Error setting attributes.
    public func setAttributes(_ attributes: [FileAttributeKey: Any]) throws {
        try FileManager.default.setAttributes(attributes, ofItemAtPath: absoluteString)
    }

    /// Returns the attributes of the item.
    ///
    /// - Returns: Attributes of the item.
    /// - Throws: Error reading attributes. `PathAttributesError`
    public func attributes() throws -> [FileAttributeKey: Any] {
        do {
            return try FileManager.default.attributesOfItem(atPath: rawValue.absoluteString)
        } catch {
            throw ReadAttributesError.cannotReadAttributes(error)
        }
    }

    /// Returns attribute for key.
    ///
    /// - Parameter fileAttributeKey: `FileAttributeKey`
    /// - Returns: Attribute for key.
    /// - Throws: Error reading attribute. `PathAttributesError`
    public func attribute<T>(forKey fileAttributeKey: FileAttributeKey) throws -> T {
        guard let attribute = try attributes()[fileAttributeKey] as? T else {
            throw ReadAttributesError.attributeNotFound(fileAttributeKey)
        }
        return attribute
    }

    /// The key in a file attribute dictionary whose
    /// value indicates whether the file is read-only.
    public func appendOnly() throws -> Bool {
        return (try attribute(forKey: .appendOnly) as NSNumber).boolValue
    }

    /// The key in a file attribute dictionary whose
    /// value indicates whether the file is busy.
    public func busy() throws -> Bool {
        return (try attribute(forKey: .busy) as NSNumber).boolValue
    }

    /// The key in a file attribute dictionary whose
    /// value indicates the file's creation date.
    public func creationDate() throws -> Date {
        return try attribute(forKey: .creationDate) as Date
    }

    /// The key in a file attribute dictionary whose value
    /// indicates the identifier for the device on which the file resides.
    public func deviceIdentifier() throws -> UInt64 {
        return (try attribute(forKey: .deviceIdentifier) as NSNumber).uint64Value
    }

    /// The key in a file attribute dictionary whose
    /// value indicates whether the file's extension is hidden.
    public func extensionHidden() throws -> Bool {
        return (try attribute(forKey: .extensionHidden) as NSNumber).boolValue
    }

    /// The key in a file attribute dictionary whose
    /// value indicates the file's group ID.
    public func groupOwnerAccountID() throws -> UInt64 {
        return (try attribute(forKey: .groupOwnerAccountID) as NSNumber).uint64Value
    }

    /// The key in a file attribute dictionary whose
    /// value indicates the group name of the file's owner.
    public func groupOwnerAccountName() throws -> String {
        return try attribute(forKey: .groupOwnerAccountName) as String
    }

    /// The key in a file attribute dictionary whose
    /// value indicates the file's HFS creator code.
    public func hfsCreatorCode() throws -> OSType {
        return (try attributes() as NSDictionary).fileHFSCreatorCode()
    }

    /// The key in a file attribute dictionary whose
    /// value indicates the file's HFS type code.
    public func hfsTypeCode() throws -> OSType {
        return (try attributes() as NSDictionary).fileHFSTypeCode()
    }

    /// The key in a file attribute dictionary whose
    /// value indicates whether the file is mutable.
    public func immutable() throws -> Bool {
        return (try attribute(forKey: .immutable) as NSNumber).boolValue
    }

    /// The key in a file attribute dictionary whose
    /// value indicates the file's last modified date.
    public func modificationDate() throws -> Date {
        return try attribute(forKey: .modificationDate) as Date
    }

    /// The key in a file attribute dictionary whose
    /// value indicates the file's owner's account ID.
    public func ownerAccountID() throws -> UInt64 {
        return (try attribute(forKey: .ownerAccountID) as NSNumber).uint64Value
    }

    /// The key in a file attribute dictionary whose
    /// value indicates the name of the file's owner.
    public func ownerAccountName() throws -> String {
        return try attribute(forKey: .ownerAccountName) as String
    }

    /// The key in a file attribute dictionary whose
    /// value indicates the file's Posix permissions.
    public func posixPermissions() throws -> Int16 {
        return (try attribute(forKey: .posixPermissions) as NSNumber).int16Value
    }

    #if os(iOS) || os(watchOS) || os(tvOS)
    /// The extended attribute key that
    /// identifies the protection level for this file.
    public func protectionKey() throws -> String {
        return try attribute(forKey: .protectionKey) as String
    }
    #endif

    /// The key in a file attribute dictionary whose
    /// value indicates the file's reference count.
    public func referenceCount() throws -> UInt64 {
        return (try attribute(forKey: .referenceCount) as NSNumber).uint64Value
    }

    /// The key in a file attribute dictionary whose
    /// value indicates the file's size in bytes.
    public func size() throws -> UInt64 {
        return (try attribute(forKey: .size) as NSNumber).uint64Value
    }

    /// The key in a file attribute dictionary whose
    /// value indicates the file's filesystem file number.
    public func systemFileNumber() throws -> UInt64 {
        return (try attribute(forKey: .systemFileNumber) as NSNumber).uint64Value
    }

    /// The key in a file system attribute dictionary whose
    /// value indicates the number of free nodes in the file system.
    public func systemFreeNodes() throws -> UInt64 {
        return (try attribute(forKey: .systemFreeNodes) as NSNumber).uint64Value
    }

    /// The key in a file system attribute dictionary whose
    /// value indicates the amount of free space on the file system.
    public func systemFreeSize() throws -> UInt64 {
        return (try attribute(forKey: .systemFreeSize) as NSNumber).uint64Value
    }

    /// The key in a file system attribute dictionary whose
    /// value indicates the number of nodes in the file system.
    public func systemNodes() throws -> UInt64 {
        return (try attribute(forKey: .systemNodes) as NSNumber).uint64Value
    }

    /// The key in a file system attribute dictionary whose
    /// value indicates the filesystem number of the file system.
    public func systemNumber() throws -> UInt64 {
        return (try attribute(forKey: .systemNumber) as NSNumber).uint64Value
    }

    /// The key in a file system attribute dictionary whose
    /// value indicates the size of the file system.
    public func systemSize() throws -> UInt64 {
        return (try attribute(forKey: .systemSize) as NSNumber).uint64Value
    }

    /// The key in a file attribute dictionary whose
    /// value indicates the file's type.
    public func type() throws -> String {
        return try attribute(forKey: .type) as String
    }
}
