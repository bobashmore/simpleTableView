//
//  Person.swift
//  simpleTableView
//
//  Created by bob.ashmore on 14/02/2016.
//  Copyright © 2016 bob.ashmore. All rights reserved.
//

import UIKit

class Person {
    var lastName:String
    var firstname:String?
    var gender:String?
    var jobDescription:String?
    var dateOfBirth:NSDate?
    
    init(lastName:String) {
        self.lastName = lastName
    }
    
    // age is a calculated property
    var ageString:String? {
        get {
            if let bDate = self.dateOfBirth {
                // Calculate number of years between the persons dateOfBirth and today's date
                return String(NSCalendar.currentCalendar().components([.Year], fromDate:bDate, toDate:NSDate(), options:[]).year)
            }
            else {
                return nil
            }
        }
    }
    
    var thumbNail:UIImage? {
        get {
            let initials:String
            if let firstName = self.firstname {
                let index1 = self.lastName.startIndex.advancedBy(1)
                let index2 = firstName.startIndex.advancedBy(1)
                initials = self.lastName.substringToIndex(index1) + "." + firstName.substringToIndex(index2) + "."
            }
            else {
                let index1 = self.lastName.startIndex.advancedBy(1)
                initials = self.lastName.substringToIndex(index1) + "."
            }
            return drawPersonThumnail(initials)
        }
    }
    
    // These two functions are class level functions used to generate random people
    static func generateRandomPerson() -> Person {
        var idx = Int(arc4random_uniform(UInt32(surnameArray.count-1)))
        let newPerson = Person(lastName: surnameArray[idx])
        idx = Int(arc4random_uniform(10))
        // Distribution of male to female is 50%
        if idx < 5 {
            newPerson.gender = "Male"
            let idx1 = Int(arc4random_uniform(UInt32(bfirstArray.count-1)))
            newPerson.firstname = bfirstArray[idx1]
        }
        else {
            newPerson.gender = "Female"
            let idx1 = Int(arc4random_uniform(UInt32(gfirstArray.count-1)))
            newPerson.firstname = gfirstArray[idx1]
        }
        
        // Select a job description
        idx = Int(arc4random_uniform(UInt32(employment.count-1)))
        newPerson.jobDescription = employment[idx]
        
        // Create a random age between 18 an 65 and calculate the persons date of birth from that
        idx = Int(arc4random_uniform(UInt32(age.count-1)))
        let year = age[idx]
        let partYear = Int(arc4random_uniform(UInt32(365)))
        let totalDays = 0 - ((year * 365) + partYear)
        if let dob = NSCalendar.currentCalendar().dateByAddingUnit([.Day], value:totalDays, toDate:NSDate(), options:[]) {
            newPerson.dateOfBirth = dob
        }
        return newPerson
    }
    
    static func generateRandomPeople(total:(Int)) -> [Person] {
        var people:[Person] = []
        
        for _ in 0...total {
            let newPerson = Person.generateRandomPerson()
            people.append(newPerson)
        }
        return people
    }
    
    
}
