//
//  CoreDataManager.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 07.05.2021.
//

import Foundation
import UIKit
import CoreData

struct CoreDataManager {
    public static var shared = CoreDataManager()
    
    private var container: NSPersistentContainer
    
    private init() {
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    public func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    public func initNewExercise() -> Exercise {
        return Exercise(context: container.viewContext)
    }
    
    public func initNewTraining() -> Training {
        return Training(context: container.viewContext)
    }
    
    public func initNewTrainingTemplate() -> TrainingTemplate {
        return TrainingTemplate(context: container.viewContext)
    }
    
    public func initNewExerciseTemplate() -> ExerciseTemplate {
        return ExerciseTemplate(context: container.viewContext)
    }
    
    public func initNewTrainingByTemplate(template: TrainingTemplate) -> Training {
        let training = Training(context: container.viewContext)
        training.date = Date()
        training.name = template.name
        for ex in template.allExercisesTemplates {
            let exer = Exercise(context: container.viewContext)
            exer.name = ex.name
            exer.type = ex.type
            exer.isSwimming = ex.isSwimming
            exer.date = nil
            exer.numberOfReps = 0
            training.addToExercises(exer)
        }
        return training
    }
    
    public func deleteTraining(training: Training) {
        container.viewContext.delete(training)
        try? container.viewContext.save()
    }
    
    public func deleteExercise(exercise: Exercise) {
        container.viewContext.delete(exercise)
        try? container.viewContext.save()
    }
    
    public func deleteTrainingTemplate(training: TrainingTemplate) {
        container.viewContext.delete(training)
        try? container.viewContext.save()
    }
    
    public func deleteTrainingTemplate(training: Training) {
        let predicate = NSPredicate(format: "name = %@", training.name!)
        let request = TrainingTemplate.createFetchRequest()
        var trainingTemplates = [TrainingTemplate]()
        request.predicate = predicate
        do {
            trainingTemplates = try container.viewContext.fetch(request)
        } catch {
            print("Fetch failed")
        }
        container.viewContext.delete(trainingTemplates[0])
        try? container.viewContext.save()
    }
    
    
    
    public func deleteExerciseTemplate(exercise: ExerciseTemplate) {
        container.viewContext.delete(exercise)
        try? container.viewContext.save()
    }
    
    func DeleteAllData(entity: String) {
        let managedContext = container.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do
    {
        let results = try managedContext.fetch(fetchRequest)
        for managedObject in results
        {
            let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
            managedContext.delete(managedObjectData)
        }
    } catch let error as NSError {
        print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
    }
        try? container.viewContext.save()
    }
    
    public func getSavedTemplates() -> [TrainingTemplate] {
        var trainingPredicate: NSPredicate?
        var trainingTemplates = [TrainingTemplate]()
        let request = TrainingTemplate.createFetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = trainingPredicate
        do {
            trainingTemplates = try container.viewContext.fetch(request)
            //print("Got \(trainingTemplates.count) trainingTemplates")
            //tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
        return trainingTemplates
    }
    
    //    public func getLastTraining(training: TrainingTemplate) -> Training {
    //        let predicate = NSPredicate(format: "name = %@", training.name!)
    //        let request = Training.createFetchRequest()
    //        let sort = NSSortDescriptor(key: "date", ascending: true)
    //        request.sortDescriptors = [sort]
    //        request.predicate = predicate
    //        do {
    //            let allTrainings = try container.viewContext.fetch(request)
    //            if allTrainings.count > 0 {
    //                trainings.append(allTrainings[0])
    //            }
    //
    //        } catch {
    //            print("Fetch failed")
    //        }
    //    }
    
    public func getAllLastTrainings(trainingTemplates: [TrainingTemplate]) -> [Training?] {
        var trainings: [Training?] = []
        for training in trainingTemplates {
            let predicate = NSPredicate(format: "name = %@", training.name!)
            let request = Training.createFetchRequest()
            let sort = NSSortDescriptor(key: "date", ascending: true)
            request.sortDescriptors = [sort]
            request.predicate = predicate
            do {
                let allTrainings = try container.viewContext.fetch(request)
                if allTrainings.count > 0 {
                    trainings.append(allTrainings[0])
                } else {
                    //trainings.append(initNewTrainingByTemplate(template: training))
                    trainings.append(nil)
                }
            } catch {
                print("Fetch failed")
            }
        }
        return trainings
        
        
    }
    
    public func getAllTrainings() -> [Training] {
        var trainings: [Training] = []
        var predicate: NSPredicate?
        let request = Training.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = predicate
        do {
            trainings = try container.viewContext.fetch(request)
        } catch {
            print("Fetch failed")
        }
        return trainings
    }
    
    public func getAllExerciseTemplates() -> [ExerciseTemplate] {
        var exerciseTemplates: [ExerciseTemplate] = []
        var predicate: NSPredicate?
        let request = ExerciseTemplate.createFetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = predicate
        do {
            exerciseTemplates = try container.viewContext.fetch(request)
        } catch {
            print("Fetch failed")
        }
        return exerciseTemplates
    }
}
