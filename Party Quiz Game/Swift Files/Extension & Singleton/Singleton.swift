//
//  Singleton.swift
//  Party Quiz Game
//
//  Created by Pasquale Bruno on 20/02/2018.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import Foundation
import UIKit


class Singleton {
  static let shared = Singleton()
  
  func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
      completion()
    }
  }
}
