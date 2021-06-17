//
//  UserListCell.swift
//  Twiiiiiter
//
//  Created by remuty on 2020/01/16.
//  Copyright © 2020 remuty. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
