//
//  SocketManager.swift
//  Party Quiz Game
//
//  Created by Giovanni Frate on 06/03/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import Foundation
import SocketIO

class SocketService {
  static let shared = SocketService()
  public let manager = SocketManager(socketURL: URL(string: "http://10.20.32.45:9091")!)
  public let client: SocketIOClient!
  public var rooms: [Room] = []
  
  
  private init() {
    self.client = self.manager.defaultSocket
  }
  
  public func connect() {
    self.setEvents()
    print(client.status)
    client.connect(timeoutAfter: 10.0, withHandler: {
      print("not connected")
    })
    print(client.status)
  }
  
  public func createRoom(room: Room) {
    client.emitWithAck("create room", room as! SocketData)
  }
  
  private func setEvents() {
    client.on(clientEvent: .connect) { (data, ack) in
      print("connected")
      let rooms = data as! [Room]
      debugPrint(rooms.count)
      if rooms.count > 0 {

        self.rooms = rooms
        self.rooms = rooms.map({
          Room(name: $0.name, creator: $0.creator, channel: $0.channel, numberOfQuestions: $0.numberOfQuestions)
        })
      }
    }
  }
}
