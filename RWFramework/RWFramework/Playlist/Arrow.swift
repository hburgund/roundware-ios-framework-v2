//
//  Arrow.swift
//  geos
//
//  Created by Halsey Burgund on 5/10/19.
//

import Foundation
import CoreLocation
import SwiftyJSON
import GEOSwift
import AVKit


public struct Arrow: Decodable {
    let id: Int
    let active: Bool
    public let startPoint: ArrowPoint
    let endPoint: ArrowPoint
    let width: Int?
    public let audioUri: URL?
    let projectId: Int
    
    private enum CodingKeys: String, CodingKey {
        case startPoint = "start_point"
        case endPoint = "end_point"
        case audioUri = "audio_uri"
        case projectId = "project_id"
        case id, active, width
    }
}

public struct ArrowPoint: Decodable {
    let type: String
    public let coordinates: [Double]
}

//let arrowPlayer = AVAudioPlayerNode()
private var arrowPlayer: AVPlayer? = nil
//private var arrowPlayer = AVPlayer(url: self.audioUri!)

extension Arrow {
    
//    self.arrowPlayer = AVPlayer(url: URL(string: url)!)
    
    var playerVolume: Float {
        get {
            return arrowPlayer!.volume
        }
        set(value) {
            arrowPlayer!.volume = value
        }
    }
    
    var start: CLLocation {
        return CLLocation(
            latitude: self.startPoint.coordinates[1],
            longitude: self.startPoint.coordinates[0]
        )
    }
    
    var end: CLLocation {
        return CLLocation(
            latitude: self.endPoint.coordinates[1],
            longitude: self.endPoint.coordinates[0]
        )
    }
    
    public var line: LineString {
        return LineString(points:
            [Coordinate(x: self.startPoint.coordinates[1], y: self.startPoint.coordinates[0]),
            Coordinate(x: self.endPoint.coordinates[1], y: self.endPoint.coordinates[0])]
            )!
    }
    
    static func from(data: Data) throws -> [Arrow] {
        let arrows = try JSONDecoder().decode([Arrow].self, from: data)
        return arrows.map { obj in
            return Arrow(
                id: obj.id,
                active: obj.active,
                startPoint: obj.startPoint,
                endPoint: obj.endPoint,
                width: obj.width,
                audioUri: obj.audioUri,
                projectId: obj.projectId
            )
        }
    }
    
    func resume() {
        if arrowPlayer == nil {
            arrowPlayer = AVPlayer(url: audioUri!)
        }
        arrowPlayer?.play()
    }
    
    func pause() {
        if arrowPlayer != nil {
            let s = arrowPlayer?.status
            arrowPlayer?.pause()
        }
    }
    
    public func distance(to loc: CLLocation) -> Double {
        return self.line.distance(geometry: loc.toWaypoint())
    }
    
//    function to return boolean of in range or not
    public func inRange(at loc: CLLocation) -> Bool {
        let inRange = true
        return inRange
    }
    
    public func distanceFrom(at loc: CLLocation) -> Double {
        let nearestPoint = line.nearestPoint(loc.toWaypoint())
//        this needs to be nearest spot on arrow, not nearest point
        let nearestLocation = CLLocation(latitude: nearestPoint.x, longitude: nearestPoint.y)
        let distFromArrow = nearestLocation.distance(from: loc)
        let distFromArrow = loc.distanceToLine(from: start, to: end)
        print("distance from arrow \(id): \(distFromArrow) m")
        return distFromArrow
    }
    
//    public func perpendicularDistance(to loc: CLLocation) -> Double {
//        calculate perpendicular distance unless point has no perpendicular that it intersects with
//        in that case, calculate distance to nearest end point.
//        let a =
//        x, y is your target point and x1, y1 to x2, y2 is your line segment.
//        function pDistance(x, y, x1, y1, x2, y2) {
//
//            var A = x - x1;
//            var B = y - y1;
//            var C = x2 - x1;
//            var D = y2 - y1;
//
//            var dot = A * C + B * D;
//            var len_sq = C * C + D * D;
//            var param = -1;
//            if (len_sq != 0) //in case of 0 length line
//            param = dot / len_sq;
//
//            var xx, yy;
//
//            if (param < 0) {
//                xx = x1;
//                yy = y1;
//            }
//            else if (param > 1) {
//                xx = x2;
//                yy = y2;
//            }
//            else {
//                xx = x1 + param * C;
//                yy = y1 + param * D;
//            }
//
//            var dx = x - xx;
//            var dy = y - yy;
//            return Math.sqrt(dx * dx + dy * dy);
//        }
//    }
    
}
