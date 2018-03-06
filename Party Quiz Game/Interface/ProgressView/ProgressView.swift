//
//  ProgressView.swift
//  SimpleBuzzer
//
//  Created by Giovanni Frate on 16/02/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import UIKit

class ProgressView: UIView {
  
  @IBOutlet weak var progressView: UIProgressView!
  
  var totalSeconds = Int()
  var currentSeconds = 0
  var timer : Timer!
  
  let hapticFeedbackBuzz = UIImpactFeedbackGenerator(style: .heavy)
  
  var audioTimerTick = Audio(fileName: "timerTick", typeName: "m4a")
  
  let myOrange = UIColor(red: 1.00, green: 0.67, blue: 0.00, alpha: 1.0)
  
  func manageProgress(seconds: Int) {
    NotificationCenter.default.addObserver(self, selector: #selector(self.stopTimer), name: NSNotification.Name(rawValue: "stopTimer"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.startTimer), name: NSNotification.Name(rawValue: "startTimer"), object: nil)
    totalSeconds = seconds-1
    currentSeconds = totalSeconds
    // Progress view
    progressView.progress = Float(currentSeconds / totalSeconds)
    progressView.trackTintColor = UIColor.gray
    progressView.progressTintColor = UIColor.green
    // Set the rounded edge for the progress view
    progressView.layer.cornerRadius = 5
    progressView.clipsToBounds = true
    // Set the rounded edge for the inner bar
    progressView.layer.sublayers![1].cornerRadius = 5
    progressView.subviews[1].clipsToBounds = true
    startTimer()
  }
  
  @objc func decreaseTimer() {
    if currentSeconds > 0 {
      currentSeconds -= 1
      if (currentSeconds < 5) {
        audioTimerTick.player.play()
        hapticFeedbackBuzz.impactOccurred()
      }
      if totalSeconds >= 20 {
        if (currentSeconds < ((totalSeconds/3) + 1)) {
          audioTimerTick.player.play()
          progressView.progressTintColor = myOrange
        } else if (currentSeconds < ((totalSeconds/2) + 1)) {
          progressView.progressTintColor = UIColor.yellow
        } else  {
          progressView.progressTintColor = UIColor.red
        }
      } else {
        if (currentSeconds < ((totalSeconds/4) + 1)) {
          audioTimerTick.player.play()
          progressView.progressTintColor = UIColor.red
        } else if (currentSeconds < ((totalSeconds/3) + 1)) {
          audioTimerTick.player.play()
          progressView.progressTintColor = myOrange
        } else if (currentSeconds < ((totalSeconds/2) + 1)) {
          progressView.progressTintColor = UIColor.yellow
        }
      }
      UIView.animate(withDuration: 1.6, animations: {
        self.progressView.setProgress(Float(self.progressView.progress - (1 / Float(self.totalSeconds))), animated: true)
      })
    } else {
      stopTimer()
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timeOut"), object: nil)
    }
  }
  
  @objc func stopTimer() {
    timer.invalidate()
    self.removeFromSuperview()
  }
  
  @objc func startTimer() {
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decreaseTimer), userInfo: nil, repeats: true)
  }
}
