//
//  PeerManager.swift
//  Party Quiz Game
//
//  Created by Giovanni Frate on 22/02/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreData

class PeerManager: NSObject, MCSessionDelegate, MCAdvertiserAssistantDelegate, MCNearbyServiceBrowserDelegate, MCBrowserViewControllerDelegate {
  
  // - MARK: 1: Properties
  static let peerShared = PeerManager()
  var session: MCSession!
  var advertiser: MCAdvertiserAssistant!
  var peerID: MCPeerID!
  var browser: MCNearbyServiceBrowser!
  var browserVC: MCBrowserViewController!
  var service: String = "AbDesigners"
  var array: [NSManagedObject] = []
  var viewController: UIViewController!
  var mainVC: UIViewController!
  
  // - MARK: 2: Custom functions
  func setupConnection() {
    // peerID
    peerID = MCPeerID(displayName: UIDevice.current.name)
    // session
    session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
    session.delegate = self
    // advertiser
    advertiser = MCAdvertiserAssistant(serviceType: service, discoveryInfo: nil, session: self.session)
    advertiser.delegate = self
    // browser
    browser = MCNearbyServiceBrowser(peer: peerID, serviceType: service)
    browser.delegate = self
  }
  
  func startBrowser() {
    browser?.startBrowsingForPeers()
  }
  
  func stopBrowser() {
    browser?.stopBrowsingForPeers()
  }
  
  func setupBrowserVC() {
    browserVC = MCBrowserViewController(serviceType: service, session: self.session)
    browserVC.delegate = self
  }
  
  func startAdvertiser() {
    advertiser.start()
  }
  
  func stopAdvertiser() {
    advertiser.stop()
  }
  
  func convertData(temp: String) -> Data {
    let data = temp.data(using: .utf8)
    return data!
  }
  
  var convertedDictionary: Data?
  
  // Function that sends dictionary to connected peers
  func sendDictionary() {
    self.convertedDictionary = NSKeyedArchiver.archivedData(withRootObject: CoreDataManager.shared.questionDictionary)
    print("\n\nCONVERTED DICTIONARY: \(String(describing: self.convertedDictionary))\n\n")
    do {
      try self.session.send(self.convertedDictionary!, toPeers:  self.session.connectedPeers,with: .reliable)
      //      print("\n\nDictionary succesfully sent!\n\n")
    } catch {
      print("Error sending dictionary converted in data")
    }
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    print("Sono nel receive")
    browserVC.dismiss(animated: true, completion: {
      self.mainVC.performSegue(withIdentifier: "fromJoin", sender: nil)
    })
    let arrivedDictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String :  String]]
    let domanda1 = arrivedDictionary![0]
    NSLog("Peer \(peerID.displayName) has sent \(String(describing: domanda1["text"]))")
    CoreDataManager.shared.questionDictionary = arrivedDictionary!
    print(data)
  }
  
  // - MARK: 3: MCBrowserViewControllerDelegate functions
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    // Do something when DONE button is pressed
    browserVC.dismiss(animated: true, completion: {
      print("fromCreate2 ESEGUITO")
      self.viewController.performSegue(withIdentifier: "fromCreate2", sender: nil)
    })
    sendDictionary()
  }
  
  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    // Do something when CANCEL button is pressed
    browserViewController.dismiss(animated: true, completion: {
      self.stopBrowser()
      self.stopAdvertiser()
    })
  }
  
  // - MARK: 4: MCSessionDelegate functions
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
  }
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
  }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
  }
  
  // - MARK: 5: MCAdvertiserAssistantDelegate functions
  func advertiserAssistantWillPresentInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
  }
  
  func advertiserAssistantDidDismissInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
  }
  
  // - MARK: 6: MCNearbyServiceBrowserDelegate functions
  func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
  }
  
  func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
  }
  
  func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
  }
}

