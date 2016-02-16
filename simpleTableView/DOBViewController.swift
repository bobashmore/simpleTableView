//
//  DOBViewController.swift
//  simpleTableView
//
//  Created by bob.ashmore on 15/02/2016.
//  Copyright © 2016 bob.ashmore. All rights reserved.
//

import UIKit

protocol dobDataChanged  {
    // protocol definition goes here
    func dobDidUpdate(newDOB:String)
}

class DOBViewController: UIViewController {
    var dateOfBirth:String?
    var delegate: dobDataChanged?
    @IBOutlet weak var dobPicker: UIDatePicker!
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d MMM y"
        let sDate = dateFormatter.stringFromDate(dobPicker.date)
        delegate?.dobDidUpdate(sDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Employee's DOB"

        if let sDate = dateOfBirth {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "d MMM y"
            if let birthDate = dateFormatter.dateFromString(sDate) {
                dobPicker.setDate(birthDate, animated: false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
