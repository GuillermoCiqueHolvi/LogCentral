//
//  LogManager.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation
import os.log

struct LogManager<T: LoggerSpec, U: ActivitySpec> {
    private let osLoggers: OsLoggers<T>
    private let crashlogger: LogWriter?
    
    init(subsystem: String, loggers: [T], crashlogger: LogWriter?) {
        self.osLoggers = OsLoggers(loggers, subsystem: subsystem)
        self.crashlogger = crashlogger
    }
    
    init(subsystem: String, loggers: [T]) {
        self.init(subsystem: subsystem, loggers: loggers, crashlogger: nil)
    }
    
    func activity(for type: U, in logSpec: T, dso: UnsafeRawPointer?, _ description: StaticString, _ body: () -> Void) {
        crashlog(description)
        
        let options: Activity.Options = type.isTopLevel ? .detached : []
        var scope = Activity(description, dso: dso, options: options).enter()
        body()
        scope.leave()
    }
    
    func log(log: T, dso: UnsafeRawPointer?, type: Level, _ message: StaticString, _ args: CVarArg...) {
        let messageString = LazyString(message: message, args)
        
        console(messageString, log: log, dso: dso, type: type)
        
        if type != .debug {
            crashlog(messageString)
        }
    }
    
    private func console(_ message: LazyString, log: T, dso: UnsafeRawPointer?, type: Level) {
        if #available(iOS 10.0, *), let args = message.args {
            os_log(message.message, dso: dso, log: osLoggers.osLog(for: log), type: type.osLogType, args)
        } else {
            print(message)
        }
    }
    
    private func crashlog(_ message: CustomStringConvertible) {
        if let crashlogger = crashlogger {
            crashlogger(message.description)
        }
    }
}
