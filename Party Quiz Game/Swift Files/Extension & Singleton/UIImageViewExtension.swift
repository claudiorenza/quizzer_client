//
//  UIImageViewExtension.swift
//  SimpleBuzzer
//
//  Created by Pasquale Bruno on 17/02/2018.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import UIKit
import Foundation

extension UIImageView {
  
  func entering(directionFrom: String, view: UIView, duration: Double) {
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
  
  func exit(directionTo: String, view: UIView, duration: Double) {
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
  
  
  
  func oneBuzzerTutorial(value: Float, view: UIView) {
    let animation = CABasicAnimation(keyPath: "position")
    animation.fromValue = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    animation.toValue = CGPoint(x: view.bounds.midX, y: (view.bounds.midY * CGFloat(value)))
    animation.duration = 0.5
    animation.autoreverses = true
    animation.repeatCount = Float.infinity
    
    layer.add(animation, forKey: nil)
  }
  
  func leftHandBuzzerTutorial(value: Float, view: UIView) {
    
    let animation = CABasicAnimation(keyPath: "position")
    animation.fromValue = CGPoint(x: (view.bounds.width * 0.4), y: (view.bounds.height * 0.55))
    animation.toValue = CGPoint(x: (view.bounds.width * 0.4), y: ((view.bounds.height * 0.55) * CGFloat(value)))
    animation.duration = 0.5
    animation.autoreverses = true
    animation.repeatCount = Float.infinity
    
    layer.add(animation, forKey: nil)
  }
  
  func rightHandBuzzerTutorial(value: Float, view: UIView) {
    
    let animation = CABasicAnimation(keyPath: "position")
    animation.fromValue = CGPoint(x: (view.bounds.midX), y: (view.bounds.height * 0.45))
    animation.toValue = CGPoint(x: (view.bounds.midX), y: ((view.bounds.height * 0.45) * CGFloat(value)))
    animation.duration = 0.5
    animation.autoreverses = true
    animation.repeatCount = Float.infinity
    
    layer.add(animation, forKey: nil)
  }
  
  func shakeBuzzerTutorial() {
    let animation = CABasicAnimation(keyPath: "transform.rotation")
    animation.fromValue = Float.pi * 0.25
    animation.toValue = -Float.pi * 0.25
    animation.duration = 0.3
    animation.autoreverses = true
    animation.repeatCount = Float.infinity
    
    layer.add(animation, forKey: nil)
  }
  
  func blowBuzzerTutorial() {
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 1
    animation.toValue = 0.1
    animation.duration = 0.3
    animation.autoreverses = true
    animation.repeatCount = Float.infinity
    
    layer.add(animation, forKey: nil)
  }
  
  func growIcon() {
    let animation = CASpringAnimation(keyPath: "transform.scale")
    animation.duration = 2
    animation.fromValue = 0
    animation.toValue = 1.0
    animation.damping = 5
    
    layer.add(animation, forKey: nil)
  }
  
  func moveSpiral(view: UIView) {
    let animation = CABasicAnimation(keyPath: "position")
    animation.fromValue = self.center
    animation.toValue = CGPoint(x: view.bounds.width * 0.5, y: self.center.y)
    animation.duration = 2
    animation.autoreverses = true
    animation.repeatCount = Float.infinity
    
    layer.add(animation, forKey: nil)
  }
  
}

