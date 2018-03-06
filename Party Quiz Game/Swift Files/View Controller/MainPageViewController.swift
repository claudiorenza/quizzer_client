//
//  MainPageViewController.swift
//  Party Quiz Game
//
//  Created by Giovanni Frate on 14/02/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import AVFoundation

class MainPageViewController: UIViewController {
  
  @IBOutlet weak var createGameOutlet: UIButton!
  @IBOutlet weak var joinGameOutlet: UIButton!
  @IBOutlet var imageLogo: UIImageView!
  
  
  var audioButtonClick = Audio(fileName: "buttonClick", typeName: "m4a")
  
  let borderColor = UIColor(red: 96.0/255.0, green: 96.0/255.0, blue: 96.0/255.0, alpha: 1.0).cgColor
  
  override func viewDidLoad() {
    super.viewDidLoad()
    PeerManager.peerShared.mainVC = self
    PeerManager.peerShared.viewController = self
    PeerManager.peerShared.setupConnection()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    imageLogo.isHidden = false
    setButton(tempButton: createGameOutlet)
    setButton(tempButton: joinGameOutlet)
    createGameOutlet.center.x = -createGameOutlet.frame.width
    joinGameOutlet.center.x = joinGameOutlet.frame.width + view.frame.width
    
    AudioSingleton.shared.setAudioShared()
    
    AudioSingleton.shared.audioMusic.player.play()
    
    imageLogo.entering(directionFrom: "left", view: self.view, duration: 0.5)
    Singleton.shared.delayWithSeconds(0.5) {
      self.createGameOutlet.entering(view: self.view)
      self.joinGameOutlet.entering(view: self.view)
    }
    Singleton.shared.delayWithSeconds(1.3) {
      self.createGameOutlet.center.x = self.view.frame.midX
      self.joinGameOutlet.center.x = self.view.frame.midX
    }
  }
  
  
  func setButton(tempButton: UIButton) {
    tempButton.layer.cornerRadius = 25.0
    tempButton.layer.borderColor = UIColor.borderColorGray()
    tempButton.layer.borderWidth = 6.0
  }
  
  @IBAction func pressToCreate(_ sender: UIButton) {
    audioButtonClick.player.play()
    
    createGameOutlet.exit(directionTo: "left", view: view, duration: 1.0)
    joinGameOutlet.exit(directionTo: "right", view: view, duration: 1.0)
    imageLogo.exit(directionTo: "left", view: view, duration: 0.5)
    Singleton.shared.delayWithSeconds(0.4) {
      self.imageLogo.isHidden = true
    }
    Singleton.shared.delayWithSeconds(0.7) {
      self.performSegue(withIdentifier: "fromCreate1", sender: self)
    }}
  
  @IBAction func pressToJoin(_ sender: UIButton) {
//    audioButtonClick.player.play()
//
//    createGameOutlet.exit(directionTo: "left", view: view, duration: 1.0)
//    joinGameOutlet.exit(directionTo: "right", view: view, duration: 1.0)
//    imageLogo.exit(directionTo: "left", view: view, duration: 0.5)
//
    
    // FEATURE IN ARRIVO
//    let alertController = UIAlertController(title: "Coming Soon", message: "This feature is under development!", preferredStyle: UIAlertControllerStyle.alert)
//
//    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
//    {
//      (result : UIAlertAction) -> Void in
//      print("You pressed OK")
//    }
//    alertController.addAction(okAction)
//    self.present(alertController, animated: true, completion: nil)
    
    
//[SINGLE PLAYER]    PeerManager.peerShared.stopAdvertiser()
//[SINGLE PLAYER]    PeerManager.peerShared.startBrowser()
//[SINGLE PLAYER]    PeerManager.peerShared.setupBrowserVC()
//[SINGLE PLAYER]    present(PeerManager.peerShared.browserVC, animated: true, completion: nil)
  }
  
  @IBAction func pressForInfo(_ sender: UIButton) {
    let alertController = UIAlertController(title: "About Us", message: "Quizzer created by Abusive Designers (27/02/2018)\n\nPasquale Bruno\nErnesto De Crecchio\nArmando Feniello\nGiovanni Frate\nMichele Golino\nClaudio Renza", preferredStyle: UIAlertControllerStyle.alert)
    
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
    {
      (result : UIAlertAction) -> Void in
      print("You pressed OK")
    }
    alertController.addAction(okAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
//  @IBAction func createGameAction(_ sender: UIButton) {
//    createGameOutlet.exit(directionTo: "left", view: view)
//    joinGameOutlet.exit(directionTo: "right", view: view)
//    Singleton.shared.delayWithSeconds(0.8) {
//      self.performSegue(withIdentifier: "fromCreate1", sender: self)
//    }
//  }
}
