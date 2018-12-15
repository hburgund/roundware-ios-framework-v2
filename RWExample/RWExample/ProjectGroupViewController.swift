//
//  ProjectGroupViewController.swift
//  RWExample
//
//  Created by user on 12/14/18.
//  Copyright © 2018 Roundware. All rights reserved.
//

import UIKit
import RWFramework


class ProjectGroupViewController: UIViewController, UITableViewDelegate {

    // MARK: Proprties
    @IBOutlet weak var tableView: UITableView!
    var dataSoure: ProjectGroupDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: If (dataSource.projectGroups.count<2) then skip to the next detail view controller.
        // Show the spinning indicator in the status bar onces the view loads.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        RWFramework.sharedInstance.start(false) // You may choose to call this in the AppDelegate

        // tableView setup.
       tableView.delegate = self
       tableView.backgroundColor = UIColor.lightGrayCustom
       tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RWFramework.sharedInstance.addDelegate(self)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RWFramework.sharedInstance.removeDelegate(self)

    }

}

// MARK: extensions

extension ProjectGroupViewController: RWFrameworkProtocol {
    
    
    func rwGetProjectGroupsIdProjectsSuccess(_ data: Data?) {
       
        // temp array to hold Porject data
        var projectGroupArray = [Project]()
        
        // You can now access the projectgroups information
        if let projectgroupsData = RWFrameworkConfig.getConfigDataFromGroup(RWFrameworkConfig.ConfigGroup.projectgroups) as? NSArray {
            var tempDictionary = [String: AnyObject]()
            // TODO: append the projectgroup data into struct model for new app.
            var tempProject: Project
            
            for item in projectgroupsData {
                tempDictionary = item as! [String : AnyObject]
                
                // Preparing the JSON parsed data to initialize the "Project" model.
                let name = tempDictionary["name"] as! String
                let owner = tempDictionary["owner"] as! String?
                let description = tempDictionary["description_loc"] as! String
                let projectId = tempDictionary["project_id"] as! Int
                let thumbnailURL = tempDictionary["thumbnail_url"] as! String
                
                // Initializing each "project" object with its data.
                tempProject = Project(name: name, owner: owner,
                                      description: description,
                                      projectId: projectId,
                                      thumbnailURL: thumbnailURL)
                
                // Appending the new initialized project object to the projectgroup array.
                projectGroupArray.append(tempProject)
                print("This the the projectgroups item: \(tempDictionary)")
                print("this is the project name: \(name)")
            }
            
        }
        // Initilizing the dataSource with projectgroups data
        dataSoure = ProjectGroupDataSource(projectGroups: projectGroupArray)
       
        // Poulating tableView dataSource with data
        tableView.dataSource = dataSoure
        tableView.reloadData()
        
        // Now you can access the whole projctgroup data from a single model "projectgroup" array.
        if let projects = dataSoure?.projectGroups {
            for item in projects {
                print("Project Name: \(item.name)")
                print("Project ID: \(item.projectId)")
                print("Project URL: \(item.thumbnailURL)")
                print("Project URL object: \(item.projectImageURL)")
                print("*****************************************")
            }
        }
        
    }
    
    
}
