//
//  OneBuzzer.swift
//  SimpleBuzzer
//
//  Created by Giovanni Frate on 15/02/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import UIKit

class OneBuzzer: UIView {
  
  @IBOutlet weak var buzzer: UIButton!
  @IBOutlet weak var view: UIView!
  @IBOutlet var outletCounter: UILabel!
  
  var index = 10
  
  var audioBuzz = Audio(fileName: "buzz", typeName: "m4a")
  var audioButtonClick = Audio(fileName: "buttonClick", typeName: "m4a")
  
  
  func setBuzzer() {
    buzzer.layer.cornerRadius = 25.0
    buzzer.layer.borderWidth = 6.0
    buzzer.layer.borderColor = UIColor.colorGray().cgColor
    outletCounter.text = "\(index)"
  }
  
  @IBAction func pressBuzzer(_ sender: UIButton) {
    audioButtonClick.player.play()
    index -= 1
    outletCounter.text = "\(index)"
    if index == 0 {
      audioBuzz.player.play()
      //view.buzzerDown(view: view)
      buzzer.isUserInteractionEnabled = false
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopTimer"), object: nil)
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "buzzer"), object: nil)
      Singleton.shared.delayWithSeconds(0.4, completion: {
        //self.removeFromSuperview()
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadProgressView10"), object: nil)
      })
      outletCounter.text = "Done!"
    }
  }
  
  @objc func timerWinner() {
    view.buzzerDown(view: view)
    Singleton.shared.delayWithSeconds(0.4, completion: {
      self.removeFromSuperview()
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadProgressView10"), object: nil)
    })
  }
  
  @objc func hideBuzzer() {
    self.removeFromSuperview()
  }
  
  func loadPopUp(view: UIView) {
    NotificationCenter.default.addObserver(self, selector: #selector(self.timerWinner), name: NSNotification.Name(rawValue: "winnerTimer"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.hideBuzzer), name: NSNotification.Name(rawValue: "hideBuzzer"), object: nil)
    if let oneBuzzerPopUp = Bundle.main.loadNibNamed("OneBuzzerPopUp", owner: self, options: nil)?.first as? OneBuzzerPopUp {
      self.addSubview(oneBuzzerPopUp)
      oneBuzzerPopUp.setViewElements(view: view)
      oneBuzzerPopUp.frame = self.bounds
    }
  }
  
}
