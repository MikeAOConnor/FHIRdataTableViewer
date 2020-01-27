//
//  PatientCodableStructs.swift
//  FHIRdataTableViewer
//
//  Created by Michael O'Connor on 1/12/20.
//  Copyright © 2020 Michael O'Connor. All rights reserved.
//

//import Foundation
//import UIKit


struct PatientJSON: Codable {
    struct PatientEntry: Codable {
        
        struct ResourceItem: Codable {
            struct PatientName: Codable {
                let family: String?
                let given: [String]?
            }
            
            let resourceType: String
            let id: String
            let name: [PatientName]?
        }
        let fullUrl: String
        let resource: ResourceItem
        
        
    }
    
    let entry: [PatientEntry]
    
}

struct Patient {
    let id: String
    let given: String
    let family: String
    let fullName: String
}
