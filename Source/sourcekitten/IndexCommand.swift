//
//  IndexCommand.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-04-24.
//  Copyright (c) 2016 SourceKitten. All rights reserved.
//

import Commandant
import Foundation
import Result
import SourceKittenFramework

struct IndexCommand: CommandType {
    let verb = "index"
    let function = "Index Swift file and print as JSON"

    struct Options: OptionsType {
        let file: String

        static func create(file: String) -> Options {
            return self.init(file: file)
        }

        static func evaluate(_ m: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> m <| Option(key: "file", defaultValue: "", usage: "relative or absolute path of Swift file to index")
        }
    }

    func run(_ options: Options) -> Result<(), SourceKittenError> {
        guard !options.file.isEmpty else {
            return .failure(.InvalidArgument(description: "file must be set when calling index"))
        }
        #if os(Linux)
            let absoluteFile = options.file
        #else
            let absoluteFile = (options.file as NSString).absolutePathRepresentation()
        #endif
        print(toJSON(toAnyObject(Request.Index(file: absoluteFile).send())))
        return .success()
    }
}
