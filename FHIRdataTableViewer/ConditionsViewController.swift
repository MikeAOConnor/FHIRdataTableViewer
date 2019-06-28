//
//  ConditionsViewController.swift
//  FHIRdataTableViewer
//
//  Created by Michael O'Connor on 6/16/19.
//  Copyright © 2019 Michael O'Connor. All rights reserved.
//

import UIKit

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



class ConditionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var conditions: [Condition] = []
    var patientID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadConditionsData()
    }
    
    func loadConditionsData() {
        
        let filterConditions = "?subject=Patient/" + patientID! + "&_format=json"
        
        
        let baseURL = "http://demo.oridashi.com.au:8297/Condition"
        let fullURL = baseURL + filterConditions
        
        // Create a configuration
        //let configuration = URLSessionConfiguration.ephemeral
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        //configuration.ephemeral = true
        
        // Create a session
        let session = URLSession(configuration: configuration)
        
        // Setup the url
        let url = URL(string: fullURL)!
        
        
        //        var csvString = "\("Status"), \("CategoryDisplay"), \("Subject"), \("ActivityDetailCode"), \("ActivityTiming"), \("ActivityPerformer")\n"
        
        
        
        
        
        let task = session.dataTask(with: url) {
            
            (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                //print(httpResponse.statusCode)
                //PlaygroundPage.current.finishExecution()
                return
            }
            
            
            
            do {
                let decoder = JSONDecoder()
                let media = try decoder.decode(ConditionJSON.self, from: data)
                // for loop  for entry in media.entry
                if media.entry == nil {
                    print("no data for member")
                    // Performing any operation from a background thread on UIView or a subclass is not supported and may result             in unexpected and insidious behavior
                    let queueForMessage = OperationQueue.main
                    queueForMessage.addOperation {
                        let ac = UIAlertController(title: "Patient Data Message", message: "There is no Condition Data for this Member.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                    
                    return
                }
                
                for entry in media.entry! {
                    
                    let codeText = entry.resource.code.text
                    let onsetDateTime = entry.resource.onsetDateTime
                    let clinicalStatus = entry.resource.clinicalStatus
                    let clinicalAsserter = entry.resource.asserter?["reference"]
                    

                    var codeCodingCode_max: String = ""
                    var codingCodeCount: Int = 0
                    
                    if entry.resource.code.coding != nil {
                        codingCodeCount = entry.resource.code.coding?.count ?? 0
                        codeCodingCode_max = entry.resource.code.coding?[codingCodeCount - 1].code ?? ""
                    }
                    
                    
//                    let carePlan = CarePlan(status: status, catDisplay: catDisp, subject: subject ?? "", actvDtlCodeTxt1: actvDtlCodeTxt ?? "", actvDtlSchedTmgEvt1: actvDtlSchedTmgEvt ?? "", actvDtlPrfmr1: actvDtlPrfmr ?? "")
                    
                    let condition = Condition(codeText: codeText, onsetDteTime: onsetDateTime ?? "", clinStatus: clinicalStatus, codeLast: codeCodingCode_max, nbrOfCodes: codingCodeCount, clinAsserter: clinicalAsserter ?? "")
                    
                    
                    self.conditions.append(condition)
                    
                }
                
                
                let queue = OperationQueue.main
                queue.addOperation {
                    self.tableView.reloadData()
                    //self.obsvCount = self.observations.count
                }
                
                
            } catch {
                print("Error info: \(error)")
                //PlaygroundPage.current.finishExecution()
            }
            
            
            
        }
        
        task.resume()
    

    }

}


extension ConditionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(self.observations.count)
        return conditions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let condition = conditions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConditionsCell") as! ConditionsTableViewCell
        
        //cell.setObservationRowDataWithStruct(obs: observation)
        cell.setConditionRowDataWithStruct(condition: condition)
        
        return cell

    }
}
