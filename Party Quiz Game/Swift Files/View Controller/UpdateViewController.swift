//
//  UpdateViewController.swift
//  Party Quiz Game
//
//  Created by Ernesto De Crecchio on 14/02/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

class UpdateViewController: UIViewController {
  
  @IBOutlet weak var spiral: UIImageView!
  @IBOutlet var dots: [UILabel]!
  @IBOutlet weak var label: UILabel!
  
  var cloudKitDatabase = CloudKitQuestions.shared
  
  let entityNameQ = "Question"
  
  let context = CoreDataManager.shared.createContext()
  let entity = CoreDataManager.shared.createEntity(nameEntity: "Question")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    cloudKitDatabase.questioningDelegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    label.textColor = UIColor.spiralLabelColor()
    spiral.moveSpiral(view: view)
    dotBlinking()
  }
  
  var loadingView: UIView?
  
  override func viewDidAppear(_ animated: Bool) {
    cloudKitDatabase.resetLocalArray()
    //Make loading view
//    self.loadingView = UIView(frame: self.view.frame)
//    loadingView!.alpha = 0.2
//    loadingView!.backgroundColor = UIColor.black
//    self.view.addSubview(loadingView!)
    
    cloudKitDatabase.downloadAllQuestions()
  }
  
  func downloadEnded() {
    print("Numero domande cloudkit: \(CloudKitQuestions.shared.localQuestions.count)")
    syncronizeDatabases()
    
    self.loadingView?.removeFromSuperview()
    performSegue(withIdentifier: "afterDownload", sender: nil)
  }
  
  func syncronizeDatabases() {
    if(CloudKitQuestions.shared.localQuestions.count > 0) {
      CoreDataManager.shared.clearData(nameEntity: entityNameQ , context: context)
      print("Memorizzo in locale \(CloudKitQuestions.shared.localQuestions.count) domande.\n")
      for i in 0...CloudKitQuestions.shared.localQuestions.count-1 {
        let question = CloudKitQuestions.shared.localQuestions[i]
        let newRecord = CoreDataManager.shared.createRecord(entity: entity, context: context)
        newRecord.setValue(question.object(forKey: "Record Name"), forKey: "id")
        newRecord.setValue(question.object(forKey: "QuestionText"), forKey: "text")
        newRecord.setValue(question.object(forKey: "CorrectAnswer"), forKey: "correctlyAnswer")
        newRecord.setValue(question.object(forKey: "Answer1"), forKey: "wrongAnswer1")
        newRecord.setValue(question.object(forKey: "Answer2"), forKey: "wrongAnswer2")
        newRecord.setValue(question.object(forKey: "Answer3"), forKey: "wrongAnswer3")
        newRecord.setValue(question.object(forKey: "Category") , forKey: "category")
        CoreDataManager.shared.saveContext(context: context)
        CoreDataManager.shared.fetchValue(nameEntity: entityNameQ, context: context)
      }
      
      let requestDomanda = NSFetchRequest<NSFetchRequestResult>(entityName: entityNameQ)
      requestDomanda.returnsObjectsAsFaults = false
      do {
        let result = try context.fetch(requestDomanda)
        for data in result as! [NSManagedObject] {
          CoreDataManager.shared.question.append(data)
        }
      } catch {
        print("Failed")
      }
    } else {
      print("L'app non è stata aggiornata, non memorizzo niente in locale.")
    }
  }
  
  func dot1Blink() {
    dots[0].blink()
  }
  
  func dot2Blink() {
    dots[0].blink()
    dots[1].blink()
  }
  
  func dot3Blink() {
    dots[0].blink()
    dots[1].blink()
    dots[2].blink()
  }
  
  func dotBlinking() {
    dot1Blink()
    Singleton.shared.delayWithSeconds(0.3) {
      self.dot2Blink()
    }
    Singleton.shared.delayWithSeconds(0.6) {
      self.dot3Blink()
    }
    Singleton.shared.delayWithSeconds(0.9) {
      self.dotBlinking()
    }
  }

}

