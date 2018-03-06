//
//  StartViewController.swift
//  Party Quiz Game
//
//  Created by Ernesto De Crecchio on 15/02/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import UIKit

class PreStartViewController: UIViewController {
  @IBOutlet var abusive: [UILabel]!
  @IBOutlet var designers: [UILabel]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    for i in abusive {
      i.logoEnter(view: view, enter: "Up")
    }
      for i in self.designers {
        i.logoEnter(view: self.view, enter: "Down")
      }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let when = DispatchTime.now() + 3
    
    let notLaunchedBefore = UserDefaults.standard.value(forKey: "launchedBefore") as! Bool
    let lastRuns = UserDefaults.standard.value(forKey: "lastRun") as! Date
    let lastUpdate = UserDefaults.standard.value(forKey: "lastUpdate") as! Date
    
    if notLaunchedBefore {
      // Primo avvio dell'App
      
      if CheckConnection.shared.isConnectedToNetwork() {
        //C'è connessione
        
        DispatchQueue.main.asyncAfter(deadline: when) {
          UserDefaults.standard.set(Date() , forKey: "lastUpdate")
          self.performSegue(withIdentifier: "updateDatabase", sender: nil)
        }
      } else {
        //NON c'è connessione
        
        UserDefaults.standard.set(nil, forKey: "launchedBefore")
        let alert = UIAlertController(title: "Internet Connection Reqiured", message: "To download important elements for the app you need an internet connection!", preferredStyle: UIAlertControllerStyle.alert)
        //        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
    } else {
      //NON primo avvio

      if Date().interval(ofComponent: .second, fromDate: lastUpdate) > 20 {
        //Passati più di 13 giorni
        
        if CheckConnection.shared.isConnectedToNetwork() {
          //C'è la connessione
          
          DispatchQueue.main.asyncAfter(deadline: when) {
            UserDefaults.standard.set(Date() , forKey: "lastUpdate")
            self.performSegue(withIdentifier: "updateDatabase", sender: nil)
          }
        } else {
          DispatchQueue.main.asyncAfter(deadline: when) {
            self.performSegue(withIdentifier: "afterStart", sender: nil)
          }
        }
      } else {
        //Non sono passsati più di 13 giorni
        
        DispatchQueue.main.asyncAfter(deadline: when) {
          self.performSegue(withIdentifier: "afterStart", sender: nil)
        }
      }
    }
  }
}

extension Date {
  
  func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
    
    let currentCalendar = Calendar.current
    
    guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
    guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
    
    return end - start
  }
}
