//
//  LoggerSpec.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation

public typealias LogMessageWriter = (_ message: String, _ level: LogLevel) -> Void
public typealias LogErrorObjectWriter = (_ error: Error) -> Void

public protocol LoggerSpec {
    var levels: [LogLevel] { get }
    var messageWriter: LogMessageWriter { get }
    var errorObjectWriter: LogErrorObjectWriter? { get }
}

