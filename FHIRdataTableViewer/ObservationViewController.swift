//
//  ObservationViewController.swift
//  FHIRdataTableViewer
//
//  Created by Michael O'Connor on 2/25/19.
//  Copyright © 2019 Michael O'Connor. All rights reserved.
//

import UIKit

class ObservationViewController: UIViewController {
    
    
    @IBOutlet weak var patientIDLabel: UILabel!
    
    var patientID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

       patientIDLabel.text = patientID
        
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
