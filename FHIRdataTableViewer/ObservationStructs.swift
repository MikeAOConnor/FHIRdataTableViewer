//
//  ObservationStructs.swift
//  FHIRdataTableViewer
//
//  Created by Michael O'Connor on 1/19/20.
//  Copyright © 2020 Michael O'Connor. All rights reserved.
//

//import Foundation

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

struct Observation {
    let catCode: String
    let codeDisplay: String
    let codeCode: String
    let effctvDate: String
    let valQuantVal: Float
    let valQuanUnit: String
    let valCodeableDisp: String
    let compo1Disp: String
    let compo1Value: Float
    let compo1Unit: String
    let compo2Disp: String
    let compo2Value: Float
    let compo2Unit: String
    
    
}
