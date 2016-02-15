//
//  MyTableViewController.swift
//  simpleTableView
//
//  Created by bob.ashmore on 13/02/2016.
//  Copyright © 2016 bob.ashmore. All rights reserved.
//


// NOTE this UITableViewController is embeded in a UINavigation controller
import UIKit

class MyTableViewController: UITableViewController,personDataChanged {
    var people:[Person] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Employee's"

        // Create the random dataset in a background thread then update UI on the main thread
        // my iPhone managed 1 million but at 2 million it ran out of memory :)
        let backgroundQueue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(backgroundQueue) {
            self.people = Person.generateRandomPeople(10)
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        
        // display an Edit and + buttons in the navigation bar for this view controller.
        let newButton  = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewPerson:")
        let editButton = editButtonItem()
        navigationItem.rightBarButtonItems = [ newButton, editButton ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Out of Memory")
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count // total number of people in the array
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("person", forIndexPath: indexPath)

        // Configure the cell...
        // only the persons lastname is guaranteed to exist so we must
        // check if the optional firstname is not nill and build the full
        // name otherwise just display the lastname
        if let first = people[indexPath.row].firstname {
            // The ? after textLabel will make sure that if textLabel is nil the line
            // will not be executed
            cell.textLabel?.text = people[indexPath.row].lastName + ", " + first
        }
        else {
            cell.textLabel?.text = people[indexPath.row].lastName
        }
        
        // if the job is not nil then display it along with the calculated age
        // using chained optionals for both job and age
        if let job =  people[indexPath.row].jobDescription, ageString = people[indexPath.row].ageString {
            cell.detailTextLabel?.text = String(format:"Age: %@ Job Description: %@",ageString,job)
        }
        
        // Display gender color if gender is not nil
        if let gender = people[indexPath.row].gender {
            if gender == "Male" {
                cell.backgroundColor = UIColor(red: 0.858, green: 0.923, blue: 0.979, alpha: 1) // Blue
            }
            else {
                cell.backgroundColor = UIColor(red: 0.979, green: 0.911, blue: 0.911, alpha: 1) // Pink
            }
        }
        // Generate and display the thumbnail
        if let thumb = people[indexPath.row].thumbNail {
            cell.imageView?.image = thumb
        }
        return cell
    }

    // make the seperator lines between cells go all the way to the view's left edge
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.people.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        // Update the model
        let person = self.people[fromIndexPath.row]
        self.people.removeAtIndex(fromIndexPath.row)
        self.people.insert(person, atIndex: toIndexPath.row)
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editPerson" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.people[indexPath.row]
                if let controller = segue.destinationViewController as? EditPersonTableViewController {
                    controller.person = object
                    controller.delegate = self
                }
            }
        }
    }
    
    func personDidUpdate() {
        print("Delegate fired")
        self.tableView.reloadData()
    }
    
    func insertNewPerson(sender:AnyObject) {
        people.append(Person.generateRandomPerson())
        self.tableView.reloadData()
    }
}
