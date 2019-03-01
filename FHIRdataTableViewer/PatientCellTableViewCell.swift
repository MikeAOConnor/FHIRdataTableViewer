//
//  PatientCellTableViewCell.swift
//  FHIRdataTableViewer
//
//  Created by Michael O'Connor on 2/20/19.
//  Copyright © 2019 Michael O'Connor. All rights reserved.
//

import UIKit

class PatientCellTableViewCell: UITableViewCell {

    @IBOutlet weak var patientLabelShort: UILabel!
    
    @IBOutlet weak var patientLabelLong: UILabel!
    
    func setPatRowData(shtID: String, lngID: String) {
        patientLabelShort.text = shtID
        patientLabelLong.text = lngID
    }
    
    func setPatietRowDataWithStruct(pnt: Patient) {
        //patientLabelShort.text = pnt.family
        patientLabelShort.text = pnt.id
        patientLabelLong.text = pnt.fullName
    }

    
}
