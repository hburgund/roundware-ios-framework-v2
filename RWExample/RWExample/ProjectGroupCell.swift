//
//  ProjectGroupCell.swift
//  RWExample
//
//  Created by user on 12/14/18.
//  Copyright © 2018 Roundware. All rights reserved.
//

import UIKit

class ProjectGroupCell: UITableViewCell {
    
    // MARK: Proprties
    @IBOutlet weak var projectNameLabel: UILabel!
    
    var projectName: String? {
        didSet {
            return projectNameLabel.text = projectName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //backgroundColor = UIColor.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
