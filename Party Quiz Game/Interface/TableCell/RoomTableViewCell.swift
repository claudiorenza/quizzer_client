//
//  RoomTableViewCell.swift
//  Party Quiz Game
//
//  Created by Giovanni Frate on 06/03/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {

  @IBOutlet weak var roomName: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
