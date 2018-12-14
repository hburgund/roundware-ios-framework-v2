//
//  ViewController.swift
//  RWExample
//
//  Created by Joe Zobkiw on 1/24/15.
//  Copyright (c) 2015 Roundware. All rights reserved.
//

import UIKit
import Foundation
import RWFramework
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    // MARK: -

    @IBOutlet var listenButton: UIButton!
    @IBOutlet var speakButton: UIButton!
    @IBOutlet var heartbeatButton: UIButton!
    @IBOutlet var map: MKMapView!
    
    var projectGroup = ProjectGroup()
 
    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()

        self.map.delegate = self
        
        RWFramework.sharedInstance.start(false) // You may choose to call this in the AppDelegate
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RWFramework.sharedInstance.addDelegate(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RWFramework.sharedInstance.removeDelegate(self)
    }

    // MARK: -
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(mapView.userLocation.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        return true
    }
    
    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        // let sourceViewController = sender.source
        // Pull any data from the view controller which initiated the unwind segue.
    }

}

extension ViewController: RWFrameworkProtocol {

    func rwGetProjectsIdSuccess(_ data: Data?) {

        // You can now access the project information
        if let projectData = RWFrameworkConfig.getConfigDataFromGroup(RWFrameworkConfig.ConfigGroup.project) as? NSDictionary {
            let listen_enabled = projectData["listen_enabled"] as! Bool
            if (listen_enabled) {
                self.listenButton.isEnabled = true
            }
            
            let speak_enabled = projectData["speak_enabled"] as! Bool
            if (speak_enabled) {
                self.speakButton.isEnabled = true
            }
        }
    }
    
    func rwGetProjectGroupsIdProjectsSuccess(_ data: Data?) {
        
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
                projectGroup.append(tempProject)

                print("This the the projectgroups item: \(tempDictionary)")
                print("this is the project name: \(name)")
            }
        }
        print("This is the ProjectGroup Model: \(projectGroup)")
        
        // Now you can access the whole projctgroup data from a single model "projectgroup" array.
        for item in projectGroup {
            print("Project Name: \(item.name)")
            print("Project ID: \(item.projectId)")
            print("Project Image: \(item.thumbnailURL)")
            print("*****************************************")
        }
    }

    
    func rwPostStreamsIdHeartbeatSuccess(_ data: Data?) {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.heartbeatButton.alpha = 0.0
        }, completion: { (Bool) -> Void in
            self.heartbeatButton.alpha = 1.0
        })
    }
}
