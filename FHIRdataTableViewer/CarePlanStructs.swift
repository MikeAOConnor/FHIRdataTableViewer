//
//  CarePlanStructs.swift
//  FHIRdataTableViewer
//
//  Created by Michael O'Connor on 1/26/20.
//  Copyright © 2020 Michael O'Connor. All rights reserved.
//

//import Foundation


struct CarePlanJSON: Codable {
    struct CarePlanEntry: Codable {
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
            
            struct ScheduledTimingStruct: Codable {
                let event: [String]
            }
            
            struct DetailStruct: Codable {
                let code: Dictionary<String, String> // have to use 'text' as the key to get descript
                let status: String?
                let scheduledTiming: ScheduledTimingStruct
                let performer: [Dictionary<String, String>]? // have to refer to 'display'
                
            }
            struct ActivityStruct: Codable {
                let detail: DetailStruct
            }
            
            
            
            let resourceType: String
            let id: String
            let status: String
            let intent: String
            let category: [CatCodeStruct]
            let subject: Dictionary<String, String>  // have to use 'reference' as a key to get the patient id
            let activity: [ActivityStruct]?  // had to make this optional.. must be a record or two w/out it.
            
        }
        
        let fullUrl: String
        let resource: ResourceItem
    }
    
    let entry: [CarePlanEntry]?
}

struct CarePlan {
    let status: String
    let catDisplay: String
    let subject: String
    let actvDtlCodeTxt1: String
    let actvDtlSchedTmgEvt1: String
    let actvDtlPrfmr1: String
}

