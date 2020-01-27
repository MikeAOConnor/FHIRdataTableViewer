//
//  ConditionStructs.swift
//  FHIRdataTableViewer
//
//  Created by Michael O'Connor on 1/26/20.
//  Copyright © 2020 Michael O'Connor. All rights reserved.
//

//import Foundation

struct ConditionJSON: Codable {
    struct ConditionEntry: Codable {
        struct ResourceItem: Codable {
            struct CodingStruct: Codable {
                let system: String
                let code: String
                let display: String
            }
            struct CodeStruct: Codable {
                let coding: [CodingStruct]?
                let text: String
            }
            
            let resourceType: String
            let id: String
            let text: Dictionary<String, String>  // have to use 'div' as a key to get the xhtml descriptive info
            let clinicalStatus: String
            let code: CodeStruct
            let subject: Dictionary<String, String>  // have to use 'reference' as a key to get the patient id
            let onsetDateTime: String?
            let asserter: Dictionary<String, String>?  // have to use 'reference' as a key to get the clinician
        }
        
        let fullUrl: String
        let resource: ResourceItem
    }
    
    let entry: [ConditionEntry]?
}

struct Condition {
    let codeText: String
    let onsetDteTime: String
    let clinStatus: String
    let codeLast: String
    let nbrOfCodes: Int
    let clinAsserter: String
}
