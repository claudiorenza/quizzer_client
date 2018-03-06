//
//  SingletonAudio.swift
//  Party Quiz Game
//
//  Created by Claudio Renza on 23/02/2018.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class Audio {
  var player: AVAudioPlayer!
  
  init(fileName: String, typeName: String)  {
    let audioURL = Bundle.main.path(forResource: fileName, ofType: typeName)
    do {
      player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioURL!))
    }
    catch{
      print(error)
    }
  }
}

