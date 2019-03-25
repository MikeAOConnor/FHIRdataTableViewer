//
//  FHIRdataTableViewerSlowTests.swift
//  FHIRdataTableViewerSlowTests
//
//  Created by Michael O'Connor on 3/25/19.
//  Copyright © 2019 Michael O'Connor. All rights reserved.
//

import XCTest
@testable import FHIRdataTableViewer

class FHIRdataTableViewerSlowTests: XCTestCase {
    
    var sessionUnderTest: URLSession!
    
    // not sure if this should go here
    struct ObservationJSON: Codable {
        struct ObservationEntry: Codable {
            struct ResourceItem: Codable {
                struct CodingStruct: Codable {
                    let system: String
                    let code: String
                    let display: String
                }
                struct CatCodeStruct: Codable {
                    let coding: [CodingStruct]
                    //let coding: [Dictionary<String, Any>]
                }
                
                
                
                //            struct CodeStruct: Codable {
                //                let coding: [CodingStruct]
                //            }
                struct ValueQuant: Codable {
                    let value: Float
                    let unit: String
                    let system: String?
                    
                }
                
                struct ComponentStruct: Codable {
                    let code: CatCodeStruct
                    let valueQuantity: ValueQuant
                }
                
                let resourceType: String
                let id: String
                let status: String
                let category: [CatCodeStruct]?
                let code: CatCodeStruct
                let effectiveDateTime: String
                let valueCodeableConcept: CatCodeStruct?
                let valueQuantity: ValueQuant?
                let component: [ComponentStruct]?
                
            }
            
            
            let fullUrl: String
            let resource: ResourceItem
            
        }
        
        let entry: [ObservationEntry]
        
    }
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
        
    }

    override func tearDown() {
        sessionUnderTest = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testDoTryDecodeResultCount() {
        // 1. given
        var patientID: String?
        var sssnFullURL: String?
        
        var obsvCount: Int?
        // 1
        let promise = expectation(description: "Decoder invoked")
        var statusCode: Int?
        var responseError: Error?
        
        patientID = "4BA4B29974331B56E7B2DA67C457688D.5"
        
        let filterConditions = "?subject=Patient/" + patientID! + "&_format=json"
        
        let baseURL = "http://demo.oridashi.com.au:8297/Observation"
        sssnFullURL = baseURL + filterConditions
        
        // Setup the url
        let url = URL(string: sssnFullURL!)!
        
        // 2. when
        let task = sessionUnderTest.dataTask(with: url) {
            
            (data, response, error) in
            
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
//                return
//            }
            let data = data
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            
            

            do {
                let decoder = JSONDecoder()
                let media = try decoder.decode(ObservationJSON.self, from: data!)
                //print("The count in Do for media.entry \(media.entry.count)")
                
                // 2
                obsvCount = media.entry.count
                promise.fulfill()
                //print(tempObservations.count)  //correct here out of For Loop
                // do I need to reload data on the main queue???????
               
                } catch {
                    print("Error info: \(error)")
                    //PlaygroundPage.current.finishExecution()
                }
            
        }
        
        task.resume()
        
        // 3
        waitForExpectations(timeout: 10, handler: nil)
        
        
        // 3. then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
        XCTAssertEqual(obsvCount, 8, "The count doesn't equal 8")
        
    }
    
    
    

}
