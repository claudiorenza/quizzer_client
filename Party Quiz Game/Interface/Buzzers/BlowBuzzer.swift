//
//  BlowBuzzer.swift
//  SimpleBuzzer
//
//  Created by Giovanni Frate on 15/02/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreAudio

class BlowBuzzer: UIView {
  var recorder: AVAudioRecorder!
  var levelTimer = Timer()
  
  var audioBuzz = Audio(fileName: "buzz", typeName: "m4a")
  var audioButtonClick = Audio(fileName: "buttonClick", typeName: "m4a")
  
  var index = 0
  var indicatorViewInterval: CGFloat = 0.0
  var indicatorViewInitialPoint: CGFloat = 0.0
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var viewOutlet: UIView!
  @IBOutlet var indicatorView: UIView!
  
  @objc func startBlowing() {
    let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
    let url = documents.appendingPathComponent("record.caf")
    let recordSettings: [String: Any] = [
      AVFormatIDKey:              kAudioFormatAppleIMA4,
      AVSampleRateKey:            44100.0,
      AVNumberOfChannelsKey:      2,
      AVEncoderBitRateKey:        12800,
      AVLinearPCMBitDepthKey:     16,
      AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
    ]
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
      //try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
      //try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions:AVAudioSessionCategoryOptions.DefaultToSpeaker, error: nil)
      //try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
      try audioSession.setActive(true)
      try recorder = AVAudioRecorder(url:url, settings: recordSettings)
    } catch {
      return
    }
    
    recorder.prepareToRecord()
    recorder.isMeteringEnabled = true
    recorder.record()
    
    levelTimer = Timer.scheduledTimer(timeInterval: 0.00009, target: self, selector: #selector(detectData), userInfo: nil, repeats: true)
    
    self.label.text = "0"
  }
  
  @objc func detectData() {
    recorder.updateMeters()
    let level = recorder.averagePower(forChannel: 0)
    if index < 1000 {
      if level > -10 {
        index += 1
        label.text = ("\(index / 10)")
        UIView.animate(withDuration: 0.1, animations: {
          self.indicatorView.frame = CGRect(x: self.indicatorView.frame.origin.x, y: self.indicatorView.frame.origin.y, width: self.indicatorView.frame.width, height: (self.indicatorViewInterval * CGFloat(1000-self.index)/1000))
        })
      }
      if level.truncatingRemainder(dividingBy: 100) == 0 {  //level % 100 == 0
        audioButtonClick.player.play()
      }
    } else if index == 1000 {
      audioBuzz.player.play()
      stopBlowing()
      //viewOutlet.buzzerDown(view: viewOutlet)
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopTimer"), object: nil)
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "buzzer"), object: nil)
      
      Singleton.shared.delayWithSeconds(0.4, completion: {
        //self.removeFromSuperview()
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadProgressView10"), object: nil)
      })
      label.text = "Done!"
    }
  }
  
  @objc func timerWinner() {
    viewOutlet.buzzerDown(view: viewOutlet)
    Singleton.shared.delayWithSeconds(0.4, completion: {
      self.removeFromSuperview()
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadProgressView10"), object: nil)
    })
  }
  
  func setRoundedView() {
    viewOutlet.layer.cornerRadius = 25.0
    viewOutlet.layer.borderColor = UIColor.colorGray().cgColor
    viewOutlet.layer.borderWidth = 6.0
  }
  
  func setIndicatorView() {
    indicatorViewInterval = indicatorView.frame.origin.y + indicatorView.frame.height
    indicatorView.layer.cornerRadius = 25.0
  }
  
  @objc func hideBuzzer() {
    stopBlowing()
    self.removeFromSuperview()
  }
  
  func loadPopUp() {
    NotificationCenter.default.addObserver(self, selector: #selector(self.startBlowing), name: NSNotification.Name(rawValue: "startBlowing"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.stopBlowing), name: NSNotification.Name(rawValue: "stopBlowing"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.timerWinner), name: NSNotification.Name(rawValue: "winnerTimer"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.hideBuzzer), name: NSNotification.Name(rawValue: "hideBuzzer"), object: nil)
    if let blowBuzzerPopUp = Bundle.main.loadNibNamed("BlowBuzzerPopUp", owner: self, options: nil)?.first as? BlowBuzzerPopUp {
      self.addSubview(blowBuzzerPopUp)
      blowBuzzerPopUp.setViewElements()
      blowBuzzerPopUp.frame = self.bounds
    }
  }
  
  @objc func stopBlowing() {
    recorder.stop()
    levelTimer.invalidate()
  }

}
