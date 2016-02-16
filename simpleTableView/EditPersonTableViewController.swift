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
    var saveButton:UIBarButtonItem?
    var editsChanged:Bool = false {
        willSet(incomingStatus) {
            print("About to set status to:  \(incomingStatus)")
            if incomingStatus == true {
                // If the surname is not valid then disable the save button
                if isSurnameValid().isValid == false {
                    print("ERROR: Surname invalid will not Save")
                    self.saveButton?.enabled = false
                   return
                }

                self.saveButton?.enabled = true
            }
            else {
                self.saveButton?.enabled = false
            }
        }
    }
    
    @IBAction func clearDOB(sender: AnyObject) {
        editDOB.text = ""
        editsChanged = true
    }
    
    @IBAction func editSurnameChanged(sender: UITextField) {
        print("Surname Updated")
        editsChanged = true
    }
    
    @IBAction func editGenderChanged(sender: AnyObject) {
        print("Gender Updated")
        editsChanged = true
    }

    @IBAction func editJobChanged(sender: UITextField) {
        print("Job Updated")
        editsChanged = true
    }

    @IBAction func editFirstNameChanged(sender: UITextField) {
        print("Firstname Updated")
        editsChanged = true
    }
    
    @IBOutlet weak var editSurname: UITextField!
    @IBOutlet weak var editFirstName: UITextField!
    @IBOutlet weak var editGender: UISegmentedControl!
    @IBOutlet weak var editJobDescription: UITextField!
    @IBOutlet weak var editDOB: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "savePerson:")
        navigationItem.rightBarButtonItem = saveButton
        editsChanged = false

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
        if let dob = person?.dateOfBirth {
            editDOB.text = dateFormatter.stringFromDate(dob)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    // Make the seperator lines between cells go all the way to the view's left edge
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    // If you want a section header then we need to return a size
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // Put in the new section header view
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        headerView.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1)
        headerView.textColor = UIColor.darkGrayColor()
        
        var hdr = "Edit Employee"
        if let fname = person?.firstname, sname = person?.lastName {
            hdr = String(format: "Edit Employee: %@ %@", fname, sname)
        }

        headerView.text = hdr
        
        headerView.textAlignment = .Center
        return headerView
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
        print("About to Save")
        let retTuple = isSurnameValid()
        if retTuple.isValid == true {
            person?.lastName = retTuple.surname!
        }
        else {
            print("ERROR: Surname invalid will not Save")
            return
        }
        
        // An empty UITextField returns "" and not nil but we want the field to be nil when it has no content
        if let fname = editFirstName.text {
            person?.firstname = (fname.isEmpty) ? nil : fname
        }

        if let jdesc = editJobDescription.text {
            person?.jobDescription = (jdesc.isEmpty) ? nil : jdesc
        }
        
        switch editGender.selectedSegmentIndex {
            case 0:
                person?.gender = "Male"
            case 1:
                person?.gender = "Female"
            default:
                person?.gender = nil
        }
        
        if let sDate = editDOB.text {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "d MMM y"
            person?.dateOfBirth = dateFormatter.dateFromString(sDate)
        }
        // tell the delegate to update its data
        self.delegate?.personDidUpdate()
        print("Saved OK")
        editsChanged = false

    }

    // dobDataChanged protocol has fired
    func dobDidUpdate(newDOB:String) {
       editDOB.text = newDOB
        editsChanged = true
    }
    
    // Check if the surname is valid and return a tuple with surname or nil and a bool to indicate validity
    // note the tuple used named variables
    func isSurnameValid() -> (surname:String?,isValid:Bool) {
        if let surname = editSurname.text {
            let trimmedString = surname.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            // A person's last name is required for the Person object to be valid
            if trimmedString.characters.count == 0 {
                return (nil,isValid:false)
            }
            else {
                return (trimmedString,isValid:true)
            }
        }
        return (nil,isValid:false)
    }
}
