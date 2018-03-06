//
//  CoreDataManager.swift
//  Party Quiz Game
//
//  Created by Michele Golino on 08/02/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
  static let shared = CoreDataManager()
  var question:[NSManagedObject] = []
  var questionDictionary = [[String:String]]()
  
  func createContext() -> NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //        l'AppDelegate per essere settato ha bisogno di un container di riferimento
    return appDelegate.persistentContainer.viewContext
    //        abbiamo quindi bisogno di crearci il container di riferimento
  }
    
  func saveContext (context: NSManagedObjectContext) -> Void {
    do {
      try context.save()
      //print ("Record saved")
    } catch {
      print("Failed saving")
    }
  }
    
  func createEntity(nameEntity: String) -> NSEntityDescription {
    return NSEntityDescription.entity(forEntityName: nameEntity, in: createContext())!
  }
    
  func createRecord (entity: NSEntityDescription , context: NSManagedObjectContext) -> NSManagedObject {
    return NSManagedObject(entity: entity, insertInto: context)
  }
    
  func clearData(nameEntity: String,context: NSManagedObjectContext) {
    do {
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: nameEntity)
      do {
        let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
        _ = objects.map{$0.map{context.delete($0)}}
        do {
          try context.save()
          print ("Record deleted")
        } catch {
          print("Delete failed")
        }
      } catch let error {
        print("ERROR DELETING : \(error)")
      }
    }
  }
    
  func countRow (nameEntity:String,context:NSManagedObjectContext) -> Int {
    return try! context.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: nameEntity))
  }
    
  func fetchValue (nameEntity: String,context: NSManagedObjectContext) -> Void {
    let requestDomanda = NSFetchRequest<NSFetchRequestResult>(entityName: nameEntity)
    requestDomanda.returnsObjectsAsFaults = false
    do {
      let result = try context.fetch(requestDomanda)
      for _ in result as! [NSManagedObject] {
      }
    } catch {
      print("Failed")
    }
  }
    
  func printValue (nameEntity: String,context: NSManagedObjectContext) -> Void {
    let requestDomanda = NSFetchRequest<NSFetchRequestResult>(entityName: nameEntity)
    requestDomanda.returnsObjectsAsFaults = false
    do {
      let result = try context.fetch(requestDomanda)
      for data in result as! [NSManagedObject] {
        print ("\(String(describing: data.value(forKey: "id")!))" )
        print ("\(String(describing: data.value(forKey: "text")!))" )
        print ("\(String(describing: data.value(forKey: "correctlyAnswer")!))" )
        print ("\(String(describing: data.value(forKey: "wrongAnswer1")!))" )
        print ("\(String(describing: data.value(forKey: "wrongAnswer2")!))" )
        print ("\(String(describing: data.value(forKey: "wrongAnswer3")!))" )
        print ("\(String(describing: data.value(forKey: "category")!) )")
      }
    } catch {
      print("Failed")
    }
  }
}
 
