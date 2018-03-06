//
//  UIButtonExtension.swift
//  Party Quiz Game
//
//  Created by Claudio Renza on 14/02/2018.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import Foundation
import UIKit

extension UIButton  {
  
  func entering(view: UIView) {
    let animation = CABasicAnimation(keyPath: "position")
    
    animation.fromValue = self.center
    animation.toValue = CGPoint(x: view.frame.midX, y: self.center.y)
    animation.duration = 1
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
  
  func fadeIn() {
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = 0.3
    
    layer.add(animation, forKey: nil)
  }
  
  func fadeOut() {
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 1
    animation.toValue = 0
    animation.duration = 0.3
    
    layer.add(animation, forKey: nil)
  }
  
}

