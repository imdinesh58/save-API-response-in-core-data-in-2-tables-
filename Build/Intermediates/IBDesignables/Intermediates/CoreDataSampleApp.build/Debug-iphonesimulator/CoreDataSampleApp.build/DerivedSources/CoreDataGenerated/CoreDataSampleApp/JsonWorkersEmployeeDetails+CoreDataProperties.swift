//
//  JsonWorkersEmployeeDetails+CoreDataProperties.swift
//  
//
//  Created by Apple-1 on 13/12/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension JsonWorkersEmployeeDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JsonWorkersEmployeeDetails> {
        return NSFetchRequest<JsonWorkersEmployeeDetails>(entityName: "JsonWorkersEmployeeDetails");
    }

    @NSManaged public var activeYN: String?
    @NSManaged public var address: String?
    @NSManaged public var email: String?
    @NSManaged public var employeeID: String?
    @NSManaged public var employeeLevelID: String?
    @NSManaged public var employeeStatus: String?
    @NSManaged public var firstName: String?
    @NSManaged public var isEnabled: String?
    @NSManaged public var lastName: String?
    @NSManaged public var levelName: String?
    @NSManaged public var phone: String?
    @NSManaged public var userMobileID: String?
    @NSManaged public var workDetails: NSObject?

}
