//
//  ConditionsTableViewCell.swift
//  FHIRdataTableViewer
//
//  Created by Michael O'Connor on 6/27/19.
//  Copyright © 2019 Michael O'Connor. All rights reserved.
//

import UIKit

class ConditionsTableViewCell: UITableViewCell {

    @IBOutlet weak var codeTextOl: UILabel!
    @IBOutlet weak var onsetDteTmOl: UILabel!
    @IBOutlet weak var clinStatusOl: UILabel!
    @IBOutlet weak var codeLastOl: UILabel!
    @IBOutlet weak var nbrCodesOl: UILabel!
    @IBOutlet weak var clinAssertrOl: UILabel!
 
    
    func setConditionRowDataWithStruct(condition: Condition) {
        
        codeTextOl.text = condition.codeText
        onsetDteTmOl.text = condition.onsetDteTime
        clinStatusOl.text = condition.clinStatus
        codeLastOl.text = condition.codeLast
        nbrCodesOl.text = String(format: "%i", condition.nbrOfCodes)  // "%i" for int... in Obs "%f" for float
        clinAssertrOl.text = condition.clinAsserter
        
        
    }
    
    
}
