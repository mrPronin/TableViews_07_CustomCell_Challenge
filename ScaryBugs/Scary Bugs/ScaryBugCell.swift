//
//  ScaryBugCell.swift
//  Scary Bugs
//
//  Created by Aleksandr Pronin on 3/6/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class ScaryBugCell: UITableViewCell {

    @IBOutlet weak var bugImageView: UIImageView!
    @IBOutlet weak var bugNameLabel: UILabel!
    @IBOutlet weak var howScaryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
