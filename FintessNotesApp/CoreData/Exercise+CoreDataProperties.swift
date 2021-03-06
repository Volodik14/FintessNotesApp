//
//  Exercise+CoreDataProperties.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 27.03.2021.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }
    

    @NSManaged public var name: String?
    @NSManaged public var numberOfSets: Int16
    @NSManaged public var numberOfReps: Int16
    
    @NSManaged public var weight: Int16
    @NSManaged public var time: Int32
    @NSManaged public var isSwimming: Bool
    @NSManaged public var training: Training?
    @NSManaged public var date: Date?
    @NSManaged public var type: Int16
}

extension Exercise : Identifiable {

}
