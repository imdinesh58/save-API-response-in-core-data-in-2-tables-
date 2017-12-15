//
//  JsonAssignedTasks+CoreDataProperties.swift
//  
//
//  Created by Apple-1 on 13/12/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension JsonAssignedTasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JsonAssignedTasks> {
        return NSFetchRequest<JsonAssignedTasks>(entityName: "JsonAssignedTasks");
    }

    @NSManaged public var assignedBY: String?
    @NSManaged public var assignedByName: String?
    @NSManaged public var assignedByRole: String?
    @NSManaged public var assignedTaskID: Int16
    @NSManaged public var assignedToRole: String?
    @NSManaged public var belongsTo: String?
    @NSManaged public var branchId: String?
    @NSManaged public var checkListIds: String?
    @NSManaged public var dateAssigned: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var distributedToId: String?
    @NSManaged public var distributedToName: String?
    @NSManaged public var duration: String?
    @NSManaged public var employeeID: String?
    @NSManaged public var employeeName: String?
    @NSManaged public var floorNumber: String?
    @NSManaged public var image: String?
    @NSManaged public var imageCount: String?
    @NSManaged public var isDistributsed: String?
    @NSManaged public var location: String?
    @NSManaged public var priorities: String?
    @NSManaged public var taskListId: String?
    @NSManaged public var taskStatusID: String?

}
