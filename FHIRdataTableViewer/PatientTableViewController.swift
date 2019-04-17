//
//  PatientTableViewController.swift
//  FHIRdataTableViewer
//
//  Created by Michael O'Connor on 2/17/19.
//  Copyright © 2019 Michael O'Connor. All rights reserved.
//

import UIKit

struct PatientJSON: Codable {
    struct PatientEntry: Codable {
        
        struct ResourceItem: Codable {
            struct PatientName: Codable {
                let family: String?
                let given: [String]?
            }
            
            let resourceType: String
            let id: String
            let name: [PatientName]
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




class PatientTableViewController: UITableViewController {
    
//    @IBOutlet weak var label1: UILabel!
//
//    @IBOutlet weak var label2: UILabel!
    
    
    var patients: [Patient]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load data
        loadPatientData()
        //print("The count in viewDidLoad \(self.patients.count)")
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("The count in numberofrowsinsection \(self.patients.count)")
        return patients.count
    }
    
    func loadPatientData() {
        
        // Create a configuration
        //let configuration = URLSessionConfiguration.ephemeral
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        //configuration.ephemeral = true
        
        // Create a session
        let session = URLSession(configuration: configuration)
        
        
        
        // Setup the url
        //let url = URL(string: "http://snapp.clinfhir.com:8081/baseDstu3/Patient?_format=json")!
        let url = URL(string: "http://demo.oridashi.com.au:8297/Patient?_format=json")!
        
        // Create the task
        let task = session.dataTask(with: url) {
            
            (data, response, error) in
            //print(data!)
            //print("Error info: \(String(describing: error))")
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                //print(httpResponse.statusCode)
                //PlaygroundPage.current.finishExecution()
                return
            }
            // print(httpResponse)
            do {
                let decoder = JSONDecoder()
                let media = try decoder.decode(PatientJSON.self, from: data)
                for entry in media.entry {
                    let id = entry.resource.id
                    let familyName = entry.resource.name[0].family
                    let givenName = entry.resource.name[0].given?[0]
                    let fullName = (givenName ?? "notPresentLast") + " " + (familyName ?? "NotPresentFirst")
                    let patient = Patient(id: id, given: givenName ?? "NoGvnName", family: familyName ?? "NoFamName", fullName: fullName)
                    self.patients.append(patient)
                    //print("id: \(id), family name: \(familyName), given name: \(givenName)")
                }
                let queue = OperationQueue.main
                queue.addOperation {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error info: \(error)")
                //PlaygroundPage.current.finishExecution()
            }
            //    if let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? {
            //        print(result)
            //    }
            //    PlaygroundPage.current.finishExecution()
            //print("The count out of Do \(self.patients.count)")
            
        }
        
        task.resume()
        //print("The count after task.resume \(self.patients.count)")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell", for: indexPath) as! PatientCellTableViewCell
        
//        cell.textLabel?.text = patients[indexPath.row].fullName
//        cell.textLabel?.text = patients[indexPath.row].family  // this overwrote the above textLable
        
 
        
//        label1.text = patients[indexPath.row].family
//        label2.text = patients[indexPath.row].fullName
//        /Users/michaeloconnor/Downloads/FHIRdataTableViewer/FHIRdataTableViewer/Base.lproj/Main.storyboard:lJe-k3-izF: error: The label2 outlet from the PatientTableViewController to the UILabel is invalid. Outlets cannot be connected to repeating content. [12]
//        /Users/michaeloconnor/Downloads/FHIRdataTableViewer/FHIRdataTableViewer/Base.lproj/Main.storyboard:0sn-X1-qiv: error: The label1 outlet from the PatientTableViewController to the UILabel is invalid. Outlets cannot be connected to repeating content. [12]
        
//        let shortID = patients[indexPath.row].family
//        let longID = patients[indexPath.row].fullName
//
//        cell.setPatRowData(shtID: shortID, lngID: longID)
        
        // pass the whole patient to the function.
        let patRowData = patients[indexPath.row]
        
        cell.setPatietRowDataWithStruct(pnt: patRowData)
        
        return cell
    }
    
    // old segue:  "ObservationSegue"
    // old let statement in the guard: let observationViewController = segue.destination as? ObservationViewController
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TabBarSegue" {
            guard let cell = sender as? UITableViewCell, let tabBarViewController = segue.destination as? TabBarViewController, let indexPath = tableView.indexPath(for: cell) else {
                return
            }
            let patientID = patients[indexPath.row].id
            tabBarViewController.patientID = patientID
        } else {
            print("incorrect segue")
        }
    }
    
    
    
}
