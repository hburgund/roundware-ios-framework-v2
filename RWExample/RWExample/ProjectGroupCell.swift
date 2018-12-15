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
    @IBOutlet weak var projectDescriptionLabel: UILabel!
    @IBOutlet weak var projectImage: UIImageView!
    
    var projectName: String? {
        didSet {
            return projectNameLabel.text = projectName
        }
    }
    
    var projectDescription: String? {
        didSet {
            return projectDescriptionLabel.text = projectDescription
        }
    }
    
    var projectThumbnail: UIImage? {
        didSet {
            return projectImage.image = projectThumbnail
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

