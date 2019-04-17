//
//  CarePlanTableViewCell.swift
//  FHIRdataTableViewer
//
//  Created by Michael O'Connor on 4/14/19.
//  Copyright © 2019 Michael O'Connor. All rights reserved.
//

import UIKit

class CarePlanTableViewCell: UITableViewCell {

    @IBOutlet weak var subjectID: UILabel!
    @IBOutlet weak var cpStatus: UILabel!
    @IBOutlet weak var catDisplay: UILabel!
    @IBOutlet weak var activityDtlCode: UILabel!
    @IBOutlet weak var activityTiming: UILabel!
    @IBOutlet weak var activityPerformer: UILabel!
    
    
    func setCarePlanRowDataWithStruct(cPlan: CarePlan) {
        
        subjectID.text = cPlan.subject
        cpStatus.text = cPlan.status
        catDisplay.text = cPlan.catDisplay
        activityDtlCode.text = cPlan.actvDtlCodeTxt1
        activityTiming.text = cPlan.actvDtlSchedTmgEvt1
        activityPerformer.text = cPlan.actvDtlPrfmr1
        
        
    }
    
    
}
