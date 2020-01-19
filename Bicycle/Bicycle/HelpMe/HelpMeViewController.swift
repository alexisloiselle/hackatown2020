//
//  HelpMeViewController.swift
//  Bicycle
//
//  Created by Maxine Mheir on 2020-01-18.
//  Copyright © 2020 William Sevigny. All rights reserved.
//

import UIKit

class HelpMeViewController: UIViewController {
    @IBOutlet weak var nearbyRiderTable: UITableView!
    
    public var nearbyRiders: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nearbyRiderCellNib = UINib.init(nibName: "NearbyRiderCell", bundle: nil)
        self.nearbyRiderTable.register(nearbyRiderCellNib, forCellReuseIdentifier: "NearbyRiderCell")
        
        // Remove separators
        self.nearbyRiderTable.separatorStyle = UITableViewCell.SeparatorStyle.none;
        self.nearbyRiderTable.reloadData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SocketService.askHelp(lat: globalLocationManager.location!.coordinate.latitude,lng: globalLocationManager.location!.coordinate.longitude)
    }

    @IBAction func closeScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension HelpMeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nearbyRiders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyRiderCell", for: indexPath) as! NearbyRiderCell
        
        cell.label.text = nearbyRiders[indexPath.row]["id"] as! String
        cell.distance.text = "\(String(Int(((nearbyRiders[indexPath.row]["distance"]) as! Double * 1000).rounded()))) m"
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
