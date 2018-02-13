//
//  LogCentralTests.swift
//  LogCentralTests
//
//  Created by Henrik Akesson on 3/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import XCTest
@testable import LogCentral

enum TestError: Error {
    case test
}
class LogCentralTests: XCTestCase {

    func testActivity() {
        let myActivity = Activity("MY_ACTIVITY", parent: .none)
        myActivity.active {
            log.error(in: .model, "Howdy \(3+2)")
        }

        
        let mySecondActivity = Activity("SECOND_ACTIVITY")
        var scope2 = mySecondActivity.enter()
        
        log.error(in: .model, "MY_ERROR")
        scope2.leave()
    }

    func testExampleLog() {
        log.error(in: .model, "TEST WRAPPED")

        log.activity(for: .external, "MY_ACTIVITY_WRAPPED") {
            log.info(in: .view, "SOME ERROR WRAPPED")
            
            log.activity(for: .internal, "MY_ACTIVITY_WRAPPED_2", {
                log.debug(in: .view, "SOME ERROR WRAPPED 2")
            })
        }
    }
    
    func testError() {
        log.error(in: .model, "TEST WRAPPED")
        
        var caught = false
        do {
            try log.activity(for: .external, "MY_ACTIVITY_WRAPPED") {
                log.info(in: .view, "SOME ERROR WRAPPED")
                
                log.info(in: .view, "SOME ERROR WRAPPED")
                
                try throwser()
                
            }
        } catch TestError.test {
            caught = true
        } catch {
            
        }
        
        XCTAssert(caught)
    }
    
    func throwser() throws {
        throw TestError.test
    }
}
