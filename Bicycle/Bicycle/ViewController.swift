//
//  ViewController.swift
//  Bicycle
//
//  Created by William Sevigny on 2020-01-18.
//  Copyright © 2020 William Sevigny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var repairStationTable: UITableView!
    @IBOutlet weak var repairStationTableTitleLabel: UILabel!
    
    public var repairStations: [RepairStation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect to socket
        SocketService.start();
        
        let repairStationCellNib = UINib.init(nibName: "RepairStationCell", bundle: nil)
        self.repairStationTable.register(repairStationCellNib, forCellReuseIdentifier: "RepairStationCell")
        
        self.repairStationTable.separatorStyle = UITableViewCell.SeparatorStyle.none;
    }
    
    override func viewWillAppear(_ animated: Bool){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
        RepairStationService.getCloseStations().done { (stations) in
            self.repairStations = stations;
            self.repairStationTable.reloadData();
            self.repairStationTableTitleLabel.text = " \(self.repairStations.count) stations nearby";
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repairStations.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepairStationCell", for: indexPath) as! RepairStationCell

        cell.stationOperatorLabel.text = "\(self.repairStations[indexPath.row].stationOperator)";
        cell.distanceLabel.text = "\(Int(self.repairStations[indexPath.row].distance * 1000)) m"
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            if let repairStationDetailsViewController = storyboard?.instantiateViewController(identifier: "RepairStationDetailsViewController") as? RepairStationDetailsViewController {
                repairStationDetailsViewController.station = self.repairStations[indexPath.row]
                navigationController?.pushViewController(repairStationDetailsViewController, animated: true)
            }
        }
    }
}

