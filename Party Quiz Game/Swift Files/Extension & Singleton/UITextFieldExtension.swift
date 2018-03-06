//
//  UITextFieldExtension.swift
//  Party Quiz Game
//
//  Created by Pasquale Bruno on 26/02/2018.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
  func moveUp(view: UIView) {
    let animation = CABasicAnimation(keyPath: "position")
    animation.fromValue = self.center
    animation.toValue = CGPoint(x: self.center.x, y: (view.bounds.height * 0.3))
    animation.duration = 0.4
    
    layer.add(animation, forKey: nil)
  }
  
  func moveDown(view: UIView, point: CGPoint) {
    let animation = CABasicAnimation(keyPath: "position")
    animation.fromValue = self.center
    animation.toValue = point
    animation.duration = 0.4
    
    layer.add(animation, forKey: nil)
  }
}
