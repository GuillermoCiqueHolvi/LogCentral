//
//  LogManager.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation
import os.log

struct LogManager<T: CategorySpec, U: ActivitySpec> {
    private let osLoggers: OsLoggers
    private let loggers: [LoggerSpec]
    
    init<T: CategorySpec>(subsystem: String, categories: [T], loggers: [LoggerSpec]) {
        self.osLoggers = OsLoggers(categories, subsystem: subsystem)
        self.loggers = loggers
    }
    
    func activity(for activity: U, in category: T, dso: UnsafeRawPointer?, _ description: StaticString, _ body: () -> Void) {
        
        let options: Activity.Options = activity.isTopLevel ? .detached : []
        var scope = Activity(description, dso: dso, options: options).enter()
        body()
        scope.leave()
    }
    
    //log errors
    func log(category: T, dso: UnsafeRawPointer?, _ message: String, _ error: NSError) {
        toConsole(message, category: category, dso: dso, level: .error)
        toLoggers(message, level: .error)
        loggers.filter { $0.levels.contains(.error) }.forEach { (logger) in
            logger.errorObjectWriter?(error)
        }
    }
    
    //log messages
    func log(category: T, dso: UnsafeRawPointer?, level: LogLevel, _ message: String) {
        toConsole(message, category: category, dso: dso, level: level)
        toLoggers(message, level: level)
    }
    
    private func toLoggers(_ message: String, level lvl: LogLevel) {
        loggers.filter { $0.levels.contains(lvl) }.forEach { (logger) in
            logger.messageWriter(message, lvl)
        }
    }
    
    private func toConsole(_ message: String, category: T, dso: UnsafeRawPointer?, level lvl: LogLevel) {
        if #available(iOS 10.0, *) {
            os_log("%@", dso: dso, log: osLoggers.osLog(for: category), type: lvl.osLogType, message)
        } else {
            print(message)
        }
    }
}
