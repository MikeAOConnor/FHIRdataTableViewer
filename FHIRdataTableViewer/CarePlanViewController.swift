//
//  CarePlanViewController.swift
//  FHIRdataTableViewer
//
//  Created by Michael O'Connor on 4/13/19.
//  Copyright © 2019 Michael O'Connor. All rights reserved.
//

import UIKit


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





class CarePlanViewController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //@IBOutlet weak var patIDLabel: UILabel!
    
    var carePlans: [CarePlan] = []
    
    var patientID: String?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // patIDLabel.text = patientID ?? "nothing nada"
        
        loadCarePlanData()
        
        
    }
    
    
    func loadCarePlanData() {
        
        let filterConditions = "?subject=Patient/" + patientID! + "&_format=json"
        
        
        let baseURL = "http://demo.oridashi.com.au:8297/CarePlan"
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
            
            //    let fileManager = FileManager.default
            //
            //    do {
            //        let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
            //        //print("\(path)")
            //        let fileURL = path.appendingPathComponent("CarePlan.json")
            //        //try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            //        try data.write(to: fileURL, options: .atomic)
            //
            //    } catch {
            //        print("error creating file")
            //        PlaygroundPage.current.finishExecution()
            //    }
            
            
            do {
                let decoder = JSONDecoder()
                let media = try decoder.decode(CarePlanJSON.self, from: data)
                // for loop  for entry in media.entry
                if media.entry == nil {
                    print("no data for member")
                    // Performing any operation from a background thread on UIView or a subclass is not supported and may result             in unexpected and insidious behavior
                    let queueForMessage = OperationQueue.main
                    queueForMessage.addOperation {
                        let ac = UIAlertController(title: "Patient Data Message", message: "There is no Care Plan Data for this Member.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                    
                    return
                }
                
                for entry in media.entry! {
                    
                    let resourceType = entry.resource.resourceType
                    let status = entry.resource.status
                    let catDisp = entry.resource.category[0].coding[0].display
                    let subject = entry.resource.subject["reference"]
                    let actvDtlCodeTxt = entry.resource.activity?[0].detail.code["text"]
                    let actvDtlSchedTmgEvt = entry.resource.activity?[0].detail.scheduledTiming.event[0]
                    let actvDtlPrfmr = entry.resource.activity?[0].detail.performer?[0]["display"]
                    
                    
//                    print("resourceType: \(resourceType), status: \(status), cat_disp: \(catDisp), subject: \(subject ?? ""), actvityCode: \(actvDtlCodeTxt ?? ""), Event: \(actvDtlSchedTmgEvt ?? ""), Performer: \(actvDtlPrfmr ?? "")")
//
//
//                    csvString = csvString.appending("\(status), \(catDisp), \(subject ?? ""), \(actvDtlCodeTxt ?? ""), \(actvDtlSchedTmgEvt ?? ""), \(actvDtlPrfmr ?? "")\n")
                    
                    let carePlan = CarePlan(status: status, catDisplay: catDisp, subject: subject ?? "", actvDtlCodeTxt1: actvDtlCodeTxt ?? "", actvDtlSchedTmgEvt1: actvDtlSchedTmgEvt ?? "", actvDtlPrfmr1: actvDtlPrfmr ?? "")
                    
                    
                    self.carePlans.append(carePlan)
                    
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
            
//            let fileManager = FileManager.default
//
//            do {
//                let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//                print("\(path)")
//                let fileURL = path.appendingPathComponent("CsvCarePlan.csv")
//                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
//            } catch {
//                print("error creating file")
//            }
            
            
           // print("The count of careplans is: \(self.carePlans.count)")
            
            //PlaygroundPage.current.finishExecution()
            
            
        }
        
        task.resume()
        
        
        
        
        
        
        
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CarePlanViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(self.observations.count)
        return carePlans.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let carePlan = carePlans[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarePlanCell") as! CarePlanTableViewCell
        
        //cell.setObservationRowDataWithStruct(obs: observation)
        cell.setCarePlanRowDataWithStruct(cPlan: carePlan)
        
        return cell
    }
}
