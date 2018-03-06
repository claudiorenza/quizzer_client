//
//  TwoBuzzers.swift
//  SimpleBuzzer
//
//  Created by Giovanni Frate on 15/02/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import UIKit

class TwoBuzzers: UIView {
  
  @IBOutlet weak var leftBuzzer: UIButton!
  @IBOutlet weak var rightBuzzer: UIButton!
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var view: UIView!
  
  var index = 10
  var audioBuzz = Audio(fileName: "buzz", typeName: "m4a")
  var audioButtonClick = Audio(fileName: "buttonClick", typeName: "m4a")
  
  
  func setBuzzers() {
    leftBuzzer.layer.cornerRadius = 25
    leftBuzzer.layer.borderWidth = 6.0
    leftBuzzer.layer.borderColor = UIColor.colorGray().cgColor
    
    rightBuzzer.layer.cornerRadius = 25
    rightBuzzer.layer.borderWidth = 6.0
    rightBuzzer.layer.borderColor = UIColor.colorGray().cgColor
    
    label.layer.cornerRadius = 15
    label.layer.borderWidth = 3.0
    label.layer.borderColor = UIColor.colorGray().cgColor
    label.clipsToBounds = true
    label.text = "\(index)"
    
    leftBuzzer.isUserInteractionEnabled = true
    rightBuzzer.isUserInteractionEnabled = false
  }
  
  @IBAction func pressLeftBuzzer(_ sender: UIButton) {
    audioButtonClick.player.play()
    index -= 1
    label.text = "\(index)"
    if index > 0 {
      leftBuzzer.isUserInteractionEnabled = false
      rightBuzzer.isUserInteractionEnabled = true
    } else {
      rightBuzzer.isUserInteractionEnabled = false
    }
  }
  
  @IBAction func pressRightBuzzer(_ sender: UIButton) {
    audioButtonClick.player.play()
    index -= 1
    label.text = "\(index)"
    if index > 0 {
      leftBuzzer.isUserInteractionEnabled = true
      rightBuzzer.isUserInteractionEnabled = false
    } else {
      audioBuzz.player.play()
      //view.buzzerDown(view: view)
      leftBuzzer.isUserInteractionEnabled = false
      rightBuzzer.isUserInteractionEnabled = false
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopTimer"), object: nil)
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "buzzer"), object: nil)
      Singleton.shared.delayWithSeconds(0.4, completion: {
        //self.removeFromSuperview()
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadProgressView10"), object: nil)
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "twoBuzzersException"), object: nil)
      })
    }
  }
  
  @objc func timerWinner() {
    view.buzzerDown(view: view)
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "twoBuzzersException"), object: nil)
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
    if let twoBuzzersPopUp = Bundle.main.loadNibNamed("TwoBuzzersPopUp", owner: self, options: nil)?.first as? TwoBuzzersPopUp {
      self.addSubview(twoBuzzersPopUp)
      twoBuzzersPopUp.setViewElements(view: view)
      twoBuzzersPopUp.frame = self.bounds
    }
  }
  
  
}
