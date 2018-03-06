//
//  CloudKitQuestionsClass.swift
//  Party Quiz Game
//
//  Created by Ernesto De Crecchio on 11/02/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitQuestions {
  static let shared = CloudKitQuestions()
  
  //let database = CKContainer.default().privateCloudDatabase
  let database = CKContainer.default().publicCloudDatabase
  
  var questioningDelegate: UpdateViewController?
  
  var localQuestions = [CKRecord]() //Array of records compatible with the database
  
  // Add a question in the database
  func addQuestion(questionText: String, correctAnswer: String, wrongAnswer1: String, wrongAnswer2: String, wrongAnswer3: String, category: String) {
    //Create a new record compatible with the database and set it's value with the argument
    let newQuestion = CKRecord(recordType: "Question")
    newQuestion.setValue(questionText, forKey: "QuestionText")
    newQuestion.setValue(correctAnswer, forKey: "CorrectAnswer")
    newQuestion.setValue(wrongAnswer1, forKey: "Answer1")
    newQuestion.setValue(wrongAnswer2, forKey: "Answer2")
    newQuestion.setValue(wrongAnswer3, forKey: "Answer3")
    newQuestion.setValue(category, forKey: "Category")
    
    database.save(newQuestion) { (record, error) in
      if (record != nil) {
        print("Error saving the question.\n\(error.debugDescription)")
      } else {
        print("Question correctly saved")
      }
    }
  }

  //Download all questions in the local array of questions
  func downloadAllQuestions() {
    resetLocalArray()
    
    self.database.add(createQueryOperation())
    print("All Questions Downloaded")
  }
  
  private func createQueryOperation(cursor: CKQueryCursor? = nil) -> CKQueryOperation {
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: "Question", predicate: predicate)
    
    var operation: CKQueryOperation
    
    if (cursor != nil) {
//      print("Query NOT ended - \(localQuestions.count)")
      operation = CKQueryOperation(cursor: cursor!)
    } else {
//      print("Query ended - \(localQuestions.count)")
      operation = CKQueryOperation(query: query)
    }
    
    operation.recordFetchedBlock = { (record: CKRecord!) in
      self.localQuestions.append(record)
      //print("Retrieved record: \(String(describing: record["QuestionText"]))")
    }
    
    operation.queryCompletionBlock = { (cursor: CKQueryCursor!, error: Error!) in
      if (error != nil) {
        print("Error on fetch. \n\(error.localizedDescription)")
      } else {
        if (cursor != nil) {
          self.database.add(self.createQueryOperation(cursor: cursor))
        } else {
//          print("Questions finished")
          if self.questioningDelegate != nil {
            DispatchQueue.main.async {
              self.questioningDelegate?.downloadEnded()
            }
          }
        }
      }
    }
    return operation
  }
  
  //Reset the array that stores all the questions of the database
  func resetLocalArray() {
    localQuestions.removeAll()
//    print("Local Questions deleted")
  }
  
  //Generate a random list of numerOfQuestions questions
  func generateRandomListQuestions(numberOfQuestions: Int) -> [CKRecord] {
    var listOfQuestions = [CKRecord]()
    var randomNumbers = [Int]()
    var x:Int = 1
    var i:Int = 0
    var check:Bool = true
    
    randomNumbers.append(Int(arc4random_uniform(UInt32(localQuestions.count))))
    print("Inserito \(randomNumbers[0]) in lista\n")
    
    repeat {
      randomNumbers.append(Int(arc4random_uniform(UInt32(localQuestions.count))))
      print("Inserito \(randomNumbers[x]) in lista, controllo se va bene\n")
      i = 0
      check = true
      repeat {
        if (randomNumbers[i] != randomNumbers[x]) {
          print("--\(randomNumbers[i]) diverso da \(randomNumbers[x])\n")
          i = i+1
        } else {
          print("--\(randomNumbers[i]) uguale a \(randomNumbers[x])\n")
          check = false
        }
      } while (check && (i < x))
      
      if(check) {
        print("-Numero valido\n")
        x = x+1
      } else {
        print("-Numero NON valido\n")
        randomNumbers.removeLast()
      }
    } while (x < numberOfQuestions)
    
    print("LISTA:\n")
    for i in 0...numberOfQuestions-1 {
      print("- \(randomNumbers[i])")
    }
    
    print("Creazione lista domande")
    for i in 0...numberOfQuestions-1 {
      listOfQuestions.append(localQuestions[randomNumbers[i]])
    }
    
    return listOfQuestions
  }

}
