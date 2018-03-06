//
//  LobbyViewController.swift
//  Party Quiz Game
//
//  Created by Giovanni Frate on 06/03/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  
  
  let arrayOfNames = [String]()
  var index = 0
  let alert = UIAlertController(title: "Lobby Name", message: "Enter the Lobby name", preferredStyle: .alert)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    SocketService.shared.connect()
    tableView.delegate = self
    tableView.dataSource = self
    setAlert()
  }
  
  func setAlert() {
    alert.addTextField { (textField) in
      textField.text = ""
    }
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
      let textField = alert?.textFields![0]
      let questions = 5
      let room = Room(name: textField!.text!, creator: "Ernesto", channel: nil, numberOfQuestions: questions)
      // INSERT textField in TableView
      // increment index
    }))
  }

  @IBAction func addLobby(_ sender: UIButton) {
    self.present(alert, animated: true, completion: nil)
  }
  
  // Delegate functions
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return SocketService.shared.rooms.count
//    return 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60.0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "lobbyCell") as! RoomTableViewCell
    cell.roomName.text = SocketService.shared.rooms[indexPath.row].name
//    cell.roomName.text = "Ernesto foresto"
    
    return cell
  }
  
  

}
