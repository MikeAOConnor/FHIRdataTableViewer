//
//  TabBarViewController.swift
//  FHIRdataTableViewer
//
//  Created by Michael O'Connor on 4/12/19.
//  Copyright © 2019 Michael O'Connor. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var patientID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        print("the patient id is: \(patientID ?? "nada")")
        
        
        let viewC_A = self.viewControllers?.first
        let viewC_B = self.viewControllers?[1]
        let viewC_C = self.viewControllers?[2]
        
        // Do any additional setup after loading the view.
        
       // let viewC = self.tabBarController!.viewControllers?.first // will give single Navigation Controller on index 0

        //let viewC = self?.tabBarController?.viewControllers// will give array of Navigation Controller
        
        //Further you can check the Visible ViewController
//
//        if let nav = viewC as? UINavigationController {
//            if nav.visibleViewController is ObservationViewController {
//
//            }
//        }
        
        if let myObs = viewC_A as? ObservationViewController {
            myObs.patientID = patientID
        } else {
            print("not working")
        }
        
        if let myCareP = viewC_B as? CarePlanViewController {
            myCareP.patientID = patientID
        } else {
            print("Didn't get the careplan view controller")
        }
        
        if let myCondition = viewC_C as? ConditionsViewController {
            myCondition.patientID = patientID
        } else {
            print("Didn't get the conition view controller")
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // this doesn't fire off initially  --- doens't seem to fire at all
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let obsViewController = segue.destination as? ObservationViewController {
            obsViewController.patientID = patientID
        } else
            {
                print("not called")
                
        }
    }

}
