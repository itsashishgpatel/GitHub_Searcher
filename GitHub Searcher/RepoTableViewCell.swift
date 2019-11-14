//
//  RepoTableViewCell.swift
//  GitHub Searcher
//
//  Created by IMCS2 on 11/13/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet var repoNameLbl: UILabel!
    @IBOutlet var repoForksLbl: UILabel!
    @IBOutlet var repoStarsLbl: UILabel!
    
}
