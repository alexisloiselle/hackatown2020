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
    
    @IBOutlet weak var helpButton: RoundedCorners!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let repairStationCellNib = UINib.init(nibName: "RepairStationCell", bundle: nil)
        self.repairStationTable.register(repairStationCellNib, forCellReuseIdentifier: "RepairStationCell")
        self.repairStationTable.layer.cornerRadius = 10;
        self.repairStationTableTitleLabel.text = "3 stations nearby";
        
        self.helpButton.backgroundColor = hexStringToUIColor(hex: "#32CD32");
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func viewWillAppear(_ animated: Bool){
        RepairStationService.getCloseStations().done { (stations) in
            print(stations)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepairStationCell", for: indexPath) as! RepairStationCell
        
        cell.stationOperatorLabel.text = "Bicyle station \(indexPath.row+1)";
        cell.distanceLabel.text = "\((indexPath.row+1)*3) m"
        
        return cell;
    }
}

