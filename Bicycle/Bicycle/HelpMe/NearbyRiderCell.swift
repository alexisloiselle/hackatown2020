//
//  NearbyRiderCell.swift
//  Bicycle
//
//  Created by William Sevigny on 2020-01-18.
//  Copyright © 2020 William Sevigny. All rights reserved.
//

import UIKit

class NearbyRiderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.message.isHidden = true
        self.message.textColor = .black
    }

    @IBOutlet weak var container: RoundedCorners!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var message: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        super.setSelected(selected, animated: animated)
    }
    
}
