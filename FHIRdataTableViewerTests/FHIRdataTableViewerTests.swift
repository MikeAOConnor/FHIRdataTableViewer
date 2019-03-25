//
//  FHIRdataTableViewerTests.swift
//  FHIRdataTableViewerTests
//
//  Created by Michael O'Connor on 3/21/19.
//  Copyright © 2019 Michael O'Connor. All rights reserved.
//

import XCTest
@testable import FHIRdataTableViewer

class FHIRdataTableViewerTests: XCTestCase {
    
    var obsViewUnderTest: ObservationViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        obsViewUnderTest = ObservationViewController()
        
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
       obsViewUnderTest = nil
    }

    func testsssnFullURL() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // 1. given
        obsViewUnderTest.patientID = "4BA4B29974331B56E7B2DA67C457688D.5"
        
        // 2. when
        obsViewUnderTest.viewDidLoad()
        
        // 3. then
      // XCTAssertGreaterThan(obsViewUnderTest.observations.count, 0, "The obs count not gt 0")
        
      //  XCTAssertEqual(obsViewUnderTest.observations.count, 0, "the array might be nil")
        XCTAssertEqual(obsViewUnderTest.sssnFullURL, "http://demo.oridashi.com.au:8297/Observation?subject=Patient/4BA4B29974331B56E7B2DA67C457688D.5&_format=json")
        
        //XCTAssertEqual(obsViewUnderTest.obsvCount, 8, "Count is not retained in obsvCount var")
        
    }

    


}
