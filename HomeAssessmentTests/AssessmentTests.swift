//
//  AssessmentTests.swift
//  HomeAssessmentTests
//
//  Created by Mengoreo on 2020/3/15.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import XCTest
@testable import HomeAssessment
class AssessmentTests: XCTestCase {

    var one: Assessment!
    var two: Assessment!
    var testUser: UserSession!
    override func setUp() {
        super.setUp()
        print(Assessment.all())
        testUser = UserSession.create(name: "testName", token: "testToken")
        one = Assessment.create(for: testUser, with: nil, remarks: "one", address: nil)
        two = Assessment.create(for: testUser, with: nil, remarks: "two", address: nil)
    }

    override func tearDown() {
        super.tearDown()
        print(Assessment.all())
        testUser = nil
        one = nil
        two = nil
    }

    func testUserAssessmentCount() {
        XCTAssertTrue(testUser.assessments?.count == 2)
    }
    
    func testOneIsNotValid() {
        XCTAssertTrue(!one.isValid())
    }
    
    func testUserToAssessmentRelation() {
        one.delete()
        print(testUser)
        XCTAssertTrue(testUser.assessments?.filter{!$0.isDeleted}.count == 1)
    }
    func testTwoIsNotValid() {
        XCTAssertTrue(!two.isValid())
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        testOneIsNotValid()
        testTwoIsNotValid()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            setUp()
        }
    }

}
