//
//  EditPersonTableViewController.swift
//  simpleTableView
//
//  Created by bob.ashmore on 14/02/2016.
//  Copyright © 2016 bob.ashmore. All rights reserved.
//

import UIKit

protocol personDataChanged  {
    // protocol definition goes here
    func personDidUpdate()
}

class EditPersonTableViewController: UITableViewController,dobDataChanged {
    var person:Person?
    var delegate: personDataChanged?
    
    @IBOutlet weak var editSurname: UITextField!
    @IBOutlet weak var editFirstName: UITextField!
    @IBOutlet weak var editGender: UISegmentedControl!
    @IBOutlet weak var editJobDescription: UITextField!
    @IBOutlet weak var editDOB: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "savePerson:")

        // get the Person data and put into the edit fields
        editSurname.text = person?.lastName
        editFirstName.text = person?.firstname
        editJobDescription.text = person?.jobDescription
        
        if let gender = person?.gender {
            if gender == "Male" {
                editGender.selectedSegmentIndex = 0
            }
            else {
                editGender.selectedSegmentIndex = 1
            }
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d MMM y"
        editDOB.text = dateFormatter.stringFromDate((person?.dateOfBirth)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    // make the seperator lines between cells go all the way to the view's left edge
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    // MARK: - Navigation
    
    // Not much to do here its a static table defined in interface builder

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDOBEdit" {
            if let controller = segue.destinationViewController as? DOBViewController {
                controller.dateOfBirth = editDOB.text
                controller.delegate = self
            }
        }
    }
    
    func savePerson(sender:AnyObject) {
        print("Saved")
        if let surname = editSurname.text {
            let trimmedString = surname.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            // A person's last name is required for the Person object to be valid
            if trimmedString.characters.count == 0 {
                return
            }
            person?.lastName = trimmedString
        }
        person?.firstname = editFirstName.text!
        person?.jobDescription = editJobDescription.text!
        
        if editGender.selectedSegmentIndex == 0 {
            person?.gender = "Male"
        }
        else {
            person?.gender = "Female"
        }
        
        if let sDate = editDOB.text {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "d MMM y"
            person?.dateOfBirth = dateFormatter.dateFromString(sDate)
        }
        // tell the delegate to update its data
        self.delegate?.personDidUpdate()
    }

    func dobDidUpdate(newDOB:String) {
       editDOB.text = newDOB
    }
}
