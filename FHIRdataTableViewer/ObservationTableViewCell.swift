//
//  ObservationTableViewCell.swift
//  FHIRdataTableViewer
//
//  Created by Michael O'Connor on 3/8/19.
//  Copyright © 2019 Michael O'Connor. All rights reserved.
//

import UIKit

class ObservationTableViewCell: UITableViewCell {

    @IBOutlet weak var catCodeLabel: UILabel!
    @IBOutlet weak var codeDisplayLabel: UILabel!
    @IBOutlet weak var codeCodeLabel: UILabel!
    @IBOutlet weak var effctvDateLabel: UILabel!
    @IBOutlet weak var valQuantValLabel: UILabel!
    @IBOutlet weak var valQuantUnitLabel: UILabel!
    
    @IBOutlet weak var compo1DispLabel: UILabel!
    @IBOutlet weak var compo1ValLabel: UILabel!
    @IBOutlet weak var compo1UnitLabel: UILabel!
    
    @IBOutlet weak var compo2DispLabel: UILabel!
    @IBOutlet weak var compo2ValLabel: UILabel!
    @IBOutlet weak var compo2UnitLabel: UILabel!
    
    func setObservationRowDataWithStruct(obs: Observation) {
        catCodeLabel.text = obs.catCode
        codeDisplayLabel.text = obs.codeDisplay
        codeCodeLabel.text = obs.codeCode
        effctvDateLabel.text = obs.effctvDate
        valQuantValLabel.text = String(format: "%f", obs.valQuantVal)
        //String(format: "%f", revenueFloat)
        valQuantUnitLabel.text = obs.valQuanUnit
        compo1DispLabel.text = obs.compo1Disp
        compo1ValLabel.text = String(format: "%f", obs.compo1Value)
        compo1UnitLabel.text = obs.compo1Unit
        compo2DispLabel.text = obs.compo2Disp
        compo2ValLabel.text = String(format: "%f", obs.compo2Value)
        compo2UnitLabel.text = obs.compo2Unit
        
    }
    
    
}
