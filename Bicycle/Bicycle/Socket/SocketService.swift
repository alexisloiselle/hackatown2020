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
import NotificationBannerSwift

let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(false), .compress])
let socket = manager.defaultSocket

class SocketService {
    public static var initialized: Bool = false
    public static var delegate: HelpMeViewController? = nil
    
    static func start(lat: Double, lng: Double, viewController: UIViewController) -> Void {
        socket.on(clientEvent: .connect) {data, ack in
            self.updatePosition(lat: lat, lng: lng)
            print("socket connected")
        }
        
        socket.on("askedForHelp") {data, _  in
            print("Asked for help")
            
            let riders = data[0] as! [[String: Any]]
            print(data[0])
            
            self.delegate?.nearbyRiders = riders
            self.delegate?.nearbyRiderTable.reloadData()
        }
        
        socket.on("askForHelp") {data, _ in
            print("Someone needs help")
            let banner3 = GrowingNotificationBanner(title: "Someone needs help", style: .info)
            banner3.show()
        }
        
        socket.on("helpComing") {data, _ in
            let rider = data[0] as! [String: Any]
            let someonesIsViewController = viewController.storyboard?.instantiateViewController(withIdentifier: "SomeonesIsViewController") as! SomeonesIsViewController
            
            // Allo, faut dismiss la view courante qui est modally, sinon erreur, merci
            self.delegate!.dismiss(animated: true, completion: nil)
            someonesIsViewController.rider = rider
            viewController.present(someonesIsViewController, animated: true, completion: nil)
        }
        
        socket.on("triste") {data, _ in
            let id = data[0] as! String
            
            for (index, element) in (self.delegate?.nearbyRiders.enumerated())! {
                if (element["id"] as! String == id) {
                    self.delegate?.nearbyRiders[index]["bailed"] = true
                }
            }
            self.delegate?.nearbyRiderTable.reloadData()
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


