//
//  RWFrameworkURLFactory.swift
//  RWFramework
//
//  Created by Joe Zobkiw on 2/2/15.
//  Copyright (c) 2015 Roundware. All rights reserved.
//

import Foundation
import CoreLocation

open class RWFrameworkURLFactory {

    fileprivate class func api2() -> String {
        return "api/2/"
    }
    
    // Returns the preferred language of the device
    class func preferredLanguage() -> String {
        let preferredLanguage = Locale.preferredLanguages[0] as String
        let arr = preferredLanguage.components(separatedBy: "-")
        if let deviceLanguage = arr.first {
            return deviceLanguage
        }
        return "en"
    }

    class func postUsersURL() -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "users/"
    }

    class func postSessionsURL() -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "sessions/"
    }
    
    // MARK: Gets projectgroups URL 
    // Returns the initial projectgroups GET request's URL as a string.
    class func getProjectGroupsIdProjectsURL(_ projectgroup_id: NSNumber, latitude: NSNumber, longitude: NSNumber) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "projectgroups/" + projectgroup_id.stringValue + "/projects" + "/?language_code=" + preferredLanguage() + "&latitude=" + latitude.stringValue + "&longitude=" + longitude.stringValue
    }

    class func getProjectsIdURL(_ project_id: NSNumber, session_id: NSNumber) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "projects/" + project_id.stringValue + "/?session_id=" + session_id.stringValue
    }

    class func getProjectsIdTagsURL(_ project_id: NSNumber, session_id: NSNumber) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "projects/" + project_id.stringValue + "/tags/" + "?session_id=" + session_id.stringValue
    }
    
    class func getProjectsIdUIGroupsURL(_ project_id: NSNumber, session_id: NSNumber) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "projects/" + project_id.stringValue + "/uigroups/" + "?session_id=" + session_id.stringValue
    }

    class func getTagCategoriesURL() -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "tagcategories/"
    }
    
    class func getUIConfigURL(_ project_id: NSNumber, session_id: NSNumber) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "projects/" + project_id.stringValue + "/uiconfig/" + "?session_id=" + session_id.stringValue
    }

    class func postStreamsURL() -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "streams/"
    }

    class func patchStreamsIdURL(_ stream_id: String) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "streams/" + stream_id + "/"
    }

    class func postStreamsIdHeartbeatURL(_ stream_id: String) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "streams/" + stream_id + "/heartbeat/"
    }

    class func postStreamsIdReplayURL(_ stream_id: String) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "streams/" + stream_id + "/replayasset/"
    }
    
    class func postStreamsIdSkipURL(_ stream_id: String) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "streams/" + stream_id + "/skipasset/"
    }
    
    class func postStreamsIdPauseURL(_ stream_id: String) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "streams/" + stream_id + "/pause/"
    }
    
    class func postStreamsIdResumeURL(_ stream_id: String) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "streams/" + stream_id + "/resume/"
    }
    
    class func getStreamsIdIsActiveURL(_ stream_id: String) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "streams/" + stream_id + "/isactive/"
    }
    
    class func postEnvelopesURL() -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "envelopes/"
    }

    class func patchEnvelopesIdURL(_ envelope_id: String) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "envelopes/" + envelope_id + "/"
    }

    class func getAssetsURL(_ dict: [String:String]) -> String {
        var url = RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "assets/"
        if (dict.count > 0) {
            url += "?"
        }
        for (key, value) in dict {
            url += (key + "=" + value + "&")
        }
        return url
    }

    class func getAssetsIdURL(_ asset_id: String) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "assets/" + asset_id + "/"
    }

    class func postAssetsIdVotesURL(_ asset_id: String) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "assets/" + asset_id + "/votes/"
    }

    class func getAssetsIdVotesURL(_ asset_id: String) -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "assets/" + asset_id + "/votes/"
    }

    class func postEventsURL() -> String {
        return RWFrameworkConfig.getConfigValueAsString("base_url") + api2() + "events/"
    }

}
