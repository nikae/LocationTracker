//
//  TracksVCCellTableViewCell.swift
//  Trail Lab
//
//  Created by Nika on 3/3/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class TracksVCCellTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var difficultyLabel: UILabel!
    
    @IBOutlet weak var accLabel: UILabel!
    
    @IBOutlet weak var favoritesLabel: UILabel!
    
    @IBOutlet weak var starBut: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
