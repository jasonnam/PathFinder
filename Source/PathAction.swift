//
// PathAction.swift
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
    public func newDirectory(subPath: Path) throws -> Path? {
        do {
            return try newDirectory(subPath.toString())
        } catch {
            throw error
        }
    }

    public func newDirectory(subPath: String) throws -> Path? {
        do {
            try checkExists(self)

            let newPath = rawValue.stringByAppendingPathComponent(subPath)
            try fileManager.createDirectoryAtPath(newPath, withIntermediateDirectories: true, attributes: nil)
            return Path(newPath)
        } catch {
            throw error
        }
    }

    public func touch(name: String, contents: NSData?) throws {
        if !fileManager.createFileAtPath(self[name].toString(), contents: contents, attributes: nil) {
            throw PathError.CreateFileFail(path: self[name])
        }
    }

    public func remove() throws {
        do {
            try checkExists(self)
            
            try fileManager.removeItemAtPath(rawValue)
        } catch {
            throw error
        }
    }

    public func rename(name: String) throws {
        do {
            try checkExists(self)

            let newPath = rawValue.stringByDeletingLastPathComponent.stringByAppendingPathComponent(name)
            try fileManager.moveItemAtPath(rawValue, toPath: newPath)
        } catch {
            throw error
        }
    }

    public func copyTo(path: Path) throws {
        do {
            try checkExists(self)
            try checkExists(path)

            try fileManager.copyItemAtPath(rawValue, toPath: path.toString())
        } catch {
            throw error
        }
    }

    public func moveTo(path: Path) throws {
        do {
            try checkExists(self)
            try checkExists(path)

            try fileManager.moveItemAtPath(rawValue, toPath: path.toString())
        } catch {
            throw error
        }
    }
}
