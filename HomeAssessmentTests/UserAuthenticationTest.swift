//
//  UserAuthenticationTest.swift
//  HomeAssessmentTests
//
//  Created by Mengoreo on 2020/3/15.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import XCTest
@testable import HomeAssessment
class UserAuthenticationTest: XCTestCase {

    var signInViewModel: SignInViewModel!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testErrorMessageTyep() {
        UserSession.performCreate(name: "testName", password: "testPassword", completionHandler: { error in
            XCTAssertTrue(error?.type == ErrorType.signInError(.passwordField))
        })
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            testErrorMessageTyep()
        }
    }

}
