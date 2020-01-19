//
//  SocketManager.swift
//  Bicycle
//
//  Created by William Sevigny on 2020-01-18.
//  Copyright © 2020 William Sevigny. All rights reserved.
//

import Foundation
import SocketIO
import PromiseKit

let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(false), .compress])
let socket = manager.defaultSocket

class SocketService {
    static func start(lat: Double, lng: Double) -> Void {
        socket.on(clientEvent: .connect) {data, ack in
            self.updatePosition(lat: lat, lng: lng)
            print("socket connected")
        }
        
        socket.on("askedForHelp") {data, _  in
            print("Asked for help")
        }
        
        socket.on("askForHelp") {data, _ in
            print("Someone needs help")
        }
        
        socket.connect()
    }
    
    static func askHelp(lat: Double, lng: Double) -> Void {
        socket.emit("needHelp", lat, lng);
    }
    
    static func updatePosition(lat: Double, lng: Double) -> Void {
        socket.emit("updatePosition", lat, lng)
    }
    
}


