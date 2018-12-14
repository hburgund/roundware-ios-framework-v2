//
//  Project.swift
//  RWExample
//
//  Created by user on 12/13/18.
//  Copyright © 2018 Roundware. All rights reserved.
//

import Foundation

// This to be removed as we replaced it with dataSource model controller.
typealias ProjectGroup = [Project]

struct Project {
    let name: String
    let owner: String?
    let description: String
    let projectId: Int
    let thumbnailURL: String
}

