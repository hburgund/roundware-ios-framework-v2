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
    
    func resume() {
        arrowPlayer?.play()
    }
    
    func pause() {
        arrowPlayer?.pause()
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
        print("distance from arrow \(id): \(distFromArrow) m")
        let distFromArrow2 = loc.distanceToLine(from: start, to: end)
        return distFromArrow2
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
    
//    static func from(data: Data) throws -> [Arrow] {
//        let items = try JSON(data: data)
    
//        return items.array?.compactMap { item in
//            let start_point: CLLocationCoordinate2D?
//            if let lat = item["start_point"].coordinates[1].double, let lng = item["start_point"].coordinates[0].double {
//                start_point = CLLocationCoordinate2D
//            } else {
//                start_point = nil
//            }
//
//            var coordsShape: Geometry? = nil
//            if let shape = item["shape"].dictionary, let coords = shape["coordinates"]![0][0].array {
//                // TODO: Handle actual multi-polygons
//                coordsShape = Polygon(shell: LinearRing(points: coords.map { p in
//                    Coordinate(x: p[0].double!, y: p[1].double!)
//                })!, holes: nil)
//            }
//
//            // Remove milliseconds from the creation date.
//            let createdString = item["created"].string!.replacingOccurrences(
//                of: "\\.\\d+", with: "", options: .regularExpression
//            )
    
//            guard let id = item["id"].int
//                let audio_uri = item["audio_uri"].string
//                else { return nil }
    
//            return Arrow(
//                id: id
//                audio_uri: audio_uri
//                length: item["audio_length_in_seconds"].double ?? 0,
//                createdDate: dateFormatter.date(from: createdString)!,
//                tags: item["tag_ids"].array!.map { $0.int! },
//                shape: coordsShape,
//                weight: item["weight"].double ?? 0,
//                description: item["description"].string ?? "",
//                activeRegion: (item["start_time"].double!)...(item["end_time"].double!)
//            )
//            } ?? []
//    }
}
