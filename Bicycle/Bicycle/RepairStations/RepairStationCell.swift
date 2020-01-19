//
//  RepairStationCell.swift
//  Bicycle
//
//  Created by William Sevigny on 2020-01-18.
//  Copyright © 2020 William Sevigny. All rights reserved.
//

import UIKit

class RepairStationCell: UITableViewCell {
//    var delegate: RepairStationCellDelegate!

    @IBOutlet weak var stationOperatorLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
//    @IBAction func repairStationCellOnAction(_ sender: Any) {
    @IBOutlet weak var container: RoundedCornersView!
    //        if(self.delegate != nil){
//            self.delegate.callSegueFromRepairStation(myData: );
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.layer.cornerRadius = 10;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        super.setSelected(selected, animated: animated)
    }
}

//protocol RepairStationCellDelegate {
//    func callSegueFromRepairStation(myData dataObject: AnyObject);
//}

