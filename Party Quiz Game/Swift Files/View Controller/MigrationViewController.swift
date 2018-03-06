//
//  MigrationViewController.swift
//  Party Quiz Game
//
//  Created by Ernesto De Crecchio on 12/02/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

class MigrationViewController: UIViewController {
  
  @IBOutlet weak var localDatabaseLabel: UILabel!
  @IBOutlet weak var coreDataLabel: UILabel!
  
  let entityNameQ = "Question"
  
  let context = CoreDataManager.shared.createContext()
  let entity = CoreDataManager.shared.createEntity(nameEntity: "Question")
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    localDatabaseLabel.text = CloudKitQuestions.shared.localQuestions.count.description
    
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
    } else {
      print("L'app non è stata aggiornata, non memorizzo niente in locale.")
    }
    
    
    //CoreDataManager.shared.printValue(nameEntity: "Domanda", context: context)
    
    coreDataLabel.text = CoreDataManager.shared.countRow(nameEntity: entityNameQ, context: context).description
  }
  
  @IBOutlet weak var questionTextLabel: UILabel!
  @IBOutlet weak var answer1Label: UIButton!
  @IBOutlet weak var answer2Label: UIButton!
  @IBOutlet weak var answer3Label: UIButton!
  @IBOutlet weak var answer4Label: UIButton!
  
  @IBAction func otherQuestionPressed(_ sender: Any) {
    var question:[NSManagedObject] = []
    let requestDomanda = NSFetchRequest<NSFetchRequestResult>(entityName: entityNameQ)
    requestDomanda.returnsObjectsAsFaults = false
    do {
      let result = try context.fetch(requestDomanda)
      for data in result as! [NSManagedObject] {
        question.append(data)
      }
    } catch {
      print("Failed")
    }
    
    
    if CoreDataManager.shared.countRow(nameEntity: entityNameQ, context: context) > 0 {
      let randomNumber = Int(arc4random_uniform(UInt32(CoreDataManager.shared.countRow(nameEntity: entityNameQ, context: context))))
      questionTextLabel.text = (question[randomNumber].value(forKey: "text") as! String)
      answer1Label.setTitle((question[randomNumber].value(forKey: "wrongAnswer1") as! String), for: UIControlState.normal)
      answer2Label.setTitle((question[randomNumber].value(forKey: "wrongAnswer2") as! String), for: UIControlState.normal)
      answer3Label.setTitle((question[randomNumber].value(forKey: "wrongAnswer3") as! String), for: UIControlState.normal)
      answer4Label.setTitle((question[randomNumber].value(forKey: "correctlyAnswer") as! String), for: UIControlState.normal)
    } else {
      questionTextLabel.text = "Nessuna domanda presente!"
    }
  }
}
