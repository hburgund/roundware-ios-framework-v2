//
//  Project.swift
//  RWExample
//
//  Created by user on 12/13/18.
//  Copyright © 2018 Roundware. All rights reserved.
//

import Foundation
import RWFramework

// This to be removed as we replaced it with dataSource model controller.
typealias ProjectGroup = [Project]

struct Project {
    let name: String
    let owner: String?
    let description: String
    let projectId: Int
    let thumbnailURL: String
}


extension Project {
    // A computed property that constructs and returns project thumbnail URL.
    var projectImageURL: URL {
        let baseURL = RWFrameworkConfig.getConfigValueAsString("base_url")
        let imageURL = URL(string: (baseURL + thumbnailURL))!
        return imageURL
    }
}


extension Project {
    // Fetches the project image as a UIImage from a given URL of a valid image format.
    func getProjectImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
}



