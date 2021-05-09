//
//  SearchRecordCell.swift
//  Weather
//
//  Created by Simon on 8/5/2021.
//

import UIKit

class SearchRecordCell: UITableViewCell {
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
