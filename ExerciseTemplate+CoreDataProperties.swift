//
//  ExerciseTemplate+CoreDataProperties.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 29.03.2021.
//
//

import Foundation
import CoreData


extension ExerciseTemplate {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ExerciseTemplate> {
        return NSFetchRequest<ExerciseTemplate>(entityName: "ExerciseTemplate")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: Int16
    @NSManaged public var isSwimming: Bool
    @NSManaged public var trainingTemplate: NSSet?
    @NSManaged public var lastRep: Int16
    @NSManaged public var lastWeight: Int16
    @NSManaged public var lastTime: Int32
}

extension ExerciseTemplate : Identifiable {

}
