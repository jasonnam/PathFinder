//
// PathError.swift
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
// Check https://github.com/nvzqz/FileKit/blob/develop/FileKit/Core/FileKitError.swift
//

import Foundation

public enum PathError: Error {
    public var message: String {
        switch self {
        case let .fileDoesNotExist(path):
            return "File does not exist at \"\(path.pathAsString)\""
        case let .changeDirectoryFail(fromPath, toPath):
            return "Could not change the directory from \"\(fromPath.pathAsString)\" to \"\(toPath.pathAsString)\""
        case let .createSymlinkFail(fromPath, toPath):
            return "Could not create symlink from \"\(fromPath.pathAsString)\" to \"\(toPath.pathAsString)\""
        case let .createFileFail(path):
            return "Could not create file at \"\(path.pathAsString)\""
        case let .createDirectoryFail(path):
            return "Could not create a directory at \"\(path.pathAsString)\""
        case let .deleteFileFail(path):
            return "Could not delete file at \"\(path.pathAsString)\""
        case let .readFromFileFail(path):
            return "Could not read from file at \"\(path.pathAsString)\""
        case let .writeToFileFail(path):
            return "Could not write to file at \"\(path.pathAsString)\""
        case let .moveFileFail(fromPath, toPath):
            return "Could not move file at \"\(fromPath.pathAsString)\" to \"\(toPath.pathAsString)\""
        case let .copyFileFail(fromPath, toPath):
            return "Could not copy file from \"\(fromPath.pathAsString)\" to \"\(toPath.pathAsString)\""
        case let .attributesChangeFail(path):
            return "Could not change file attrubutes at \"\(path.pathAsString)\""
        case let .isNotDirectory(path):
            return "Following path is not a directory: \"\(path.pathAsString)\""
        }
    }

    /// A file does not exist.
    case fileDoesNotExist(path: Path)

    /// Could not change the current directory.
    case changeDirectoryFail(from: Path, to: Path)

    /// A symbolic link could not be created.
    case createSymlinkFail(from: Path, to: Path)

    /// A file could not be created.
    case createFileFail(path: Path)

    /// A directory could not be created.
    case createDirectoryFail(path: Path)

    /// A file could not be deleted.
    case deleteFileFail(path: Path)

    /// A file could not be read from.
    case readFromFileFail(path: Path)

    /// A file could not be written to.
    case writeToFileFail(path: Path)

    /// A file could not be moved.
    case moveFileFail(from: Path, to: Path)

    /// A file could not be copied.
    case copyFileFail(from: Path, to: Path)

    /// One or many attributes could not be changed.
    case attributesChangeFail(path: Path)

    /// Following path is not a directory.
    case isNotDirectory(path: Path)
}
