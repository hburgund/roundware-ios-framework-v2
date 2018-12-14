//
//  ProjectGroupDataSource.swift
//  RWExample
//
//  Created by user on 12/14/18.
//  Copyright © 2018 Roundware. All rights reserved.
//

import Foundation
import UIKit

class ProjectGroupDataSource: NSObject {
    let projectGroups: [Project]
    
    init(projectGroups: [Project]) {
        self.projectGroups = projectGroups
    }
    
}


extension ProjectGroupDataSource: UITableViewDataSource {
    
    // MARK:  UITableView required protocol methods.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProjectGroupCell.self)) as! ProjectGroupCell
        let project: Project
        project = projectGroups[indexPath.row]
        cell.projectName = project.name
        return cell
        
    }
    
}
