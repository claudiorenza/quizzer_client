//
//  UIViewExtension.swift
//  SimpleBuzzer
//
//  Created by Pasquale Bruno on 17/02/2018.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  func enteringView(directionFrom: String, view: UIView, duration: Double) {
    let animation = CABasicAnimation(keyPath: "position")
    var cgPointImageInit = self.center
    let cgPointImageFinal = cgPointImageInit
    
    if(directionFrom == "left") {
      cgPointImageInit.x = -self.frame.width
    } else if (directionFrom == "right")    {
      cgPointImageInit.x = view.bounds.width + self.frame.width
    }
    
    animation.fromValue = NSValue(cgPoint: cgPointImageInit)
    animation.toValue = NSValue(cgPoint: cgPointImageFinal)
    animation.duration = duration
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    
    layer.add(animation, forKey: nil)
  }
  
  func exitView(directionTo: String, view: UIView, duration: Double) {
    let animation = CABasicAnimation(keyPath: "position")
    var finalPosition = CGPoint()
    
    if(directionTo == "left") {
      finalPosition.x = view.bounds.width + self.frame.width
    } else if (directionTo == "right") {
      finalPosition.x = -self.frame.width
    }
    
    animation.fromValue = self.center
    animation.toValue = CGPoint(x: finalPosition.x, y: self.center.y)
    animation.duration = duration
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    
    layer.add(animation, forKey: nil)
  }
  
  
  func tutorialDismiss(view: UIView) {
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 1
    animation.toValue = 0
    animation.duration = 0.5
    
    layer.add(animation, forKey: nil)
  }
  
  func buzzerDown(view: UIView) {
    let animation = CABasicAnimation(keyPath: "position")
    animation.fromValue = NSValue(cgPoint: self.center)
    animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: (view.bounds.height + self.frame.height)))
    animation.duration = 0.5
    
    layer.add(animation, forKey: nil)
  }
  
  func changeBackgroundColor(initColor: UIColor, finalColor: UIColor) {
    let animation = CABasicAnimation(keyPath: "backgroundColor")
    animation.fromValue = initColor.cgColor
    animation.toValue = finalColor.cgColor
    animation.duration = 2
    
    layer.add(animation, forKey: nil)
  }
  
}
