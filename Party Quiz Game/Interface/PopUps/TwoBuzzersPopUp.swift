//
//  TwoBuzzersPopUp.swift
//  SimpleBuzzer
//
//  Created by Giovanni Frate on 17/02/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import UIKit

class TwoBuzzersPopUp: UIView {

  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var okOutlet: UIButton!
  @IBOutlet weak var leftHand: UIImageView!
  @IBOutlet weak var rightHand: UIImageView!
  
  var audioButtonClick = Audio(fileName: "buttonClick", typeName: "m4a")
  
  func setViewElements(view: UIView) {
    self.layer.cornerRadius = 25.0
    self.layer.borderColor = UIColor.borderColorGray()
    self.layer.borderWidth = 6.0
    okOutlet.layer.cornerRadius = 15.0
    okOutlet.layer.borderColor = UIColor.black.cgColor
    okOutlet.layer.borderWidth = 1.5
    leftHand.leftHandBuzzerTutorial(value: 0.8, view: view)
    rightHand.rightHandBuzzerTutorial(value: 1.2, view: view)
  }
  
  @IBAction func okAction(_ sender: UIButton) {
    audioButtonClick.player.play()
    self.tutorialDismiss(view: self)
    Singleton.shared.delayWithSeconds(0.1) {
      self.removeFromSuperview()
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadProgressView10"), object: nil)
    }
  }
  
}
