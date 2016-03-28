//
// PathNavigation.swift
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
    public func contents(exclude exclude: [String]?) throws -> [Path] {
        do {
            try checkExists(self)

            let contents = try fileManager.contentsOfDirectoryAtPath(rawValue)

            var folder: [Path] = []
            var file: [Path] = []

            for content in contents {
                let contentPath = Path(fromString: rawValue.stringByAppendingPathComponent(content))

                if !(exclude != nil && exclude!.contains(content)) {
                    if contentPath.isDirectory {
                        folder.append(contentPath)
                    } else {
                        file.append(contentPath)
                    }
                }
            }

            folder.sortInPlace { $0.name < $1.name }
            file.sortInPlace { $0.name < $1.name }

            return folder + file
        } catch {
            throw error
        }
    }

    public subscript(name: String) -> Path {
        return Path(fromString: rawValue.stringByAppendingPathComponent(name))
    }

    public subscript(path: Path) -> Path {
        return Path(fromString: rawValue.stringByAppendingPathComponent(path.rawValue))
    }
}
