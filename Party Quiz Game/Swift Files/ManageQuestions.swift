//
//  ManageQuestions.swift
//  Party Quiz Game
//
//  Created by Ernesto De Crecchio on 15/02/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import Foundation
import CoreData

class ManageQuestions {
  static let shared = ManageQuestions()
  
  func getRandomQuestion() {
    
  }
  
  func generateRandomListNumber(number: Int, numMax: Int) -> [Int] {
    var randomNumbers = [Int]()
    var x = 1
    var i = 0
    var check = true
    
    randomNumbers.append(Int(arc4random_uniform(UInt32(numMax))))
//    print("Inserito \(randomNumbers[0]) in lista\n")
    
    repeat {
      randomNumbers.append(Int(arc4random_uniform(UInt32(numMax))))
//      print("Inserito \(randomNumbers[x]) in lista, controllo se va bene\n")
      i = 0
      check = true
      repeat {
        if (randomNumbers[i] != randomNumbers[x]) {
//          print("--\(randomNumbers[i]) diverso da \(randomNumbers[x])\n")
          i = i+1
        } else {
//          print("--\(randomNumbers[i]) uguale a \(randomNumbers[x])\n")
          check = false
        }
      } while (check && (i < x))
      
      if(check) {
//        print("-Numero valido\n")
        x = x+1
      } else {
//        print("-Numero NON valido\n")
        randomNumbers.removeLast()
      }
    } while (x < number)
    
    return randomNumbers
  }
  
  func generateRandomListQuestions(numberOfQuestions: Int) -> [NSManagedObject] {
    let context = CoreDataManager.shared.createContext()
    print("Numero massimo di domande: \(CoreDataManager.shared.countRow(nameEntity: "Domanda", context: context))")
    let randomNumbers = generateRandomListNumber(number: numberOfQuestions, numMax: CoreDataManager.shared.countRow(nameEntity: "Domanda", context: context))
    
    var listQuestion = [NSManagedObject]()
    
    let requestDomanda = NSFetchRequest<NSFetchRequestResult>(entityName: "Domanda")
    requestDomanda.returnsObjectsAsFaults = false
    
    for i in 0...randomNumbers.count-1 {
      print("i= \(randomNumbers[i])")
    }
    
    for i in 0...numberOfQuestions-1 {
      do {
        let result = try context.fetch(requestDomanda)
        listQuestion.append(contentsOf: result[randomNumbers[i]] as! [NSManagedObject])
      } catch {
        print("FAILEEEEED")
      }
    }
    return listQuestion
  }
}
