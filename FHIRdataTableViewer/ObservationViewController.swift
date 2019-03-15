//
//  ObservationViewController.swift
//  FHIRdataTableViewer
//
//  Created by Michael O'Connor on 2/25/19.
//  Copyright © 2019 Michael O'Connor. All rights reserved.
//

import UIKit

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


class ObservationViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var observations: [Observation] = []
    
    
   // @IBOutlet weak var patientIDLabel: UILabel!
    
    var patientID: String?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //observations =
        loadObservationData()
       // print("The count in viewDidLoad \(self.observations.count)")
       //patientIDLabel.text = patientID
        
    }
    
    func loadObservationData() {
        
        //var tempObservations: [Observation] = []
        
        let filterConditions = "?subject=Patient/" + patientID! + "&_format=json"
        
        let baseURL = "http://demo.oridashi.com.au:8297/Observation"
        let sssnFullURL = baseURL + filterConditions
        
        //print(sssnFullURL)
        
        // Create a configuration
        //let configuration = URLSessionConfiguration.ephemeral
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        //configuration.ephemeral = true
        
        // Create a session
        let session = URLSession(configuration: configuration)
        
        
        
        // Setup the url
        let url = URL(string: sssnFullURL)!
        
//        var csvString = "\("Cat Code"), \("Code Disp"), \("Code Code"), \("Code Syst"), \("Effective Date"), \("ValQuantVal"), \("ValQuantUnit"), \("ValCodeableDisp"), \("Comp1Disp"), \("Comp1Val"), \("Comp1Unit"), \("Comp2Disp"), \("Comp2Val"), \("Comp2Unit")\n"
        
        
        let task = session.dataTask(with: url) {
            
            (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                //print(httpResponse.statusCode)
                //PlaygroundPage.current.finishExecution()
                return
            }
            // print(httpResponse)
            do {
                let decoder = JSONDecoder()
                let media = try decoder.decode(ObservationJSON.self, from: data)
                for entry in media.entry {
                    let id = entry.resource.id
                    
                    let resourceType = entry.resource.resourceType
                    let status = entry.resource.status
                    
                    //            let cat_code = entry.resource.category.coding[0].code
                    let cat_code = entry.resource.category?[0].coding[0].code
                    //            let cat_disp = entry.resource.category.coding[0].display
                    //            let cat_syst = entry.resource.category.coding[0].system
                    //            let code_code = entry.resource.code.coding[0].code
                    let code_disp = entry.resource.code.coding[0].display
                    let code_code = entry.resource.code.coding[0].code
                    let code_system = entry.resource.code.coding[0].system
                    //            let code_syst = entry.resource.code.coding[0].system
                    let valCode_disp = entry.resource.valueCodeableConcept?.coding[0].display
                    
                    let effDateTime = entry.resource.effectiveDateTime
                    let valQuant = entry.resource.valueQuantity
                    let valQuantVal = entry.resource.valueQuantity?.value
                    let valQuantUnit = entry.resource.valueQuantity?.unit
                    let comp1disp = entry.resource.component?[0].code.coding[0].display
                    let comp1syst = entry.resource.component?[0].code.coding[0].system
                    let comp1code = entry.resource.component?[0].code.coding[0].code
                    let comp1val = entry.resource.component?[0].valueQuantity.value
                    let comp1unit = entry.resource.component?[0].valueQuantity.unit
                    
                    
                    //            guard let comp2 = entry.resource.component?[1], let comp2disp = entry.resource.component?[1].code.coding[0].display, let comp2val = entry.resource.component?[1].valueQuantity.value else {
                    //                return  //this stops the task from running
                    //            }
                    
                   // to prevent index out of bounds.
                    
                    var comp2disp: String = ""
                    var comp2syst: String = ""
                    var comp2code: String = ""
                    var comp2val: Float = 0.0
                    var comp2unit: String = ""
                    //var comp2unit: String = ""
                    
                    // print("component count: \(entry.resource.component?.count ?? 0)")
                    
 
                    
                    if ((entry.resource.component?.count ?? 0) > 1) {
                        //print("comp count > 1")
                        comp2disp = (entry.resource.component?[1].code.coding[0].display)!
                        comp2syst = (entry.resource.component?[1].code.coding[0].system)!
                        comp2code = (entry.resource.component?[1].code.coding[0].code)!
                        comp2val = (entry.resource.component?[1].valueQuantity.value)!
                        comp2unit = (entry.resource.component?[1].valueQuantity.unit)!
                    }
                    
                    let observation = Observation(catCode: cat_code ?? "", codeDisplay: code_disp, codeCode: code_code, effctvDate: effDateTime, valQuantVal: (valQuantVal ?? 0), valQuanUnit: (valQuantUnit ?? ""), valCodeableDisp: valCode_disp ?? "", compo1Disp: comp1disp ?? "", compo1Value: comp1val ?? 0, compo1Unit: comp1unit ?? "", compo2Disp: comp2disp, compo2Value: comp2val, compo2Unit: comp2unit)
                    
                    self.observations.append(observation)
//                    print(self.observations.count)
                    
                    //tempObservations.append(observation)
                    
//                    print("status: \(status), cat_code: \(cat_code ?? ""), code_disp: \(code_disp), code_code: \(code_code), code_syst: \(code_system),  effectiveDtTm: \(effDateTime), ValQuantVal: \(valQuantVal ??  0), ValQuantUnit: \(valQuantUnit ?? ""), valCodeableDisp: \(valCode_disp ?? ""), comp1disp: \(comp1disp ?? ""), comp1val: \(comp1val ?? 0), comp1Unit: \(comp1unit ?? ""), comp2disp: \(comp2disp), comp2val: \(comp2val), comp2Unit: \(comp2unit)")

//                    csvString = csvString.appending("\(cat_code), \(code_disp), \(code_code), \(code_system), \(effDateTime), \(valQuantVal ?? 0), \(valQuantUnit ?? ""), \(valCode_disp ?? ""), \(comp1disp ?? ""), \(comp1val ?? 0), \(comp1unit ?? ""), \(comp2disp), \(comp2val), \(comp2unit)\n")
                    
                    
                }
                //print(tempObservations.count)  //correct here out of For Loop
                // do I need to reload data on the main queue???????
                let queue = OperationQueue.main
                queue.addOperation {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error info: \(error)")
                //PlaygroundPage.current.finishExecution()
            }
            //print(tempObservations.count)  //correct here out of Do
            // print(csvString)
            
//            let fileManager = FileManager.default
//
//            do {
//                let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//                print("\(path)")
//                let fileURL = path.appendingPathComponent("CSVObs.csv")
//                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
//            } catch {
//                print("error creating file")
//            }
            
            //PlaygroundPage.current.finishExecution()
            
        }
            
            //.resume()
        
        task.resume()
        
       //print(self.observations.count)
        //print(tempObservations.count)  //incorrect here
        //return tempObservations
    }
    
    

}

extension ObservationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(self.observations.count)
        return observations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let observation = observations[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObservationCell") as! ObservationTableViewCell
        
        cell.setObservationRowDataWithStruct(obs: observation)
        
        return cell
    }
}
