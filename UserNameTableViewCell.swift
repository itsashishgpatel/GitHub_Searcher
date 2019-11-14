//
//  UserNameTableViewCell.swift
//  GitHub Searcher
//
//  Created by IMCS2 on 11/12/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit

class UserNameTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userRepo: UILabel!
    
}
