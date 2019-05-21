
import Foundation
import CoreLocation
import SwiftyJSON
import GEOSwift
import AVFoundation

public class Speaker {
    private static let fadeDuration: Float = 3.0
    
    let id: Int
    let volume: ClosedRange<Float>
    let url: String
    let backupUrl: String
    let shape: Geometry
    let attenuationShape: Geometry
    let attenuationDistance: Int
    private var player: AVPlayer? = nil
    private var looper: Any? = nil
    private var fadeTimer: Timer? = nil

    init(
        id: Int,
        volume: ClosedRange<Float>,
        url: String,
        backupUrl: String,
        shape: Geometry,
        attenuationShape: Geometry,
        attenuationDistance: Int
    ) {
        self.id = id
        self.volume = volume
        self.url = url
        self.backupUrl = backupUrl
        self.shape = shape
        self.attenuationShape = attenuationShape
        self.attenuationDistance = attenuationDistance
    }
}

extension Speaker {
    private func contains(_ point: CLLocation) -> Bool {
        return point.toWaypoint().within(shape)
    }
    
    private func attenuationShapeContains(_ point: CLLocation) -> Bool {
        return point.toWaypoint().within(attenuationShape)
    }
    
    public func distance(to loc: CLLocation) -> Double {
        return self.shape.distance(geometry: loc.toWaypoint())
    }
    
    private func attenuationRatio(at loc: CLLocation) -> Double {
        let nearestPoint = attenuationShape.nearestPoint(loc.toWaypoint())
        let nearestLocation = CLLocation(latitude: nearestPoint.y, longitude: nearestPoint.x)
        let distToInnerShape = nearestLocation.distance(from: loc)
        print("distance to speaker \(id): \(distToInnerShape) m")
        return 1 - (distToInnerShape / Double(attenuationDistance))
    }
    
    func volume(at point: CLLocation) -> Float {
        if attenuationShapeContains(point) {
            return volume.upperBound
        } else if contains(point) {
            // TODO: Linearly attenuate instead of just averaging.
            let range = volume.difference
            return volume.lowerBound + range * Float(attenuationRatio(at: point))
        } else {
            return volume.lowerBound
        }
    }

    /**
     - returns: whether we're within range of the speaker
    */
    @discardableResult
    func updateVolume(at point: CLLocation) -> Float {
        let vol = self.volume(at: point)
        
        if vol > 0.05 {
            // definitely want to create the player if it needs volume
            if self.player == nil {
                player = AVPlayer(url: URL(string: url)!)

                looper = looper ?? NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player!.currentItem, queue: .main) { [weak self] _ in
                    self?.player?.seek(to: CMTime.zero)
                    self?.player?.play()
                }
            }
            // make sure this speaker is playing if it needs to be audible
            if player!.rate == 0.0 && RWFramework.sharedInstance.isPlaying {
                player!.play()
            }
        }
        
        fadeTimer?.invalidate()
        if let player = self.player {
            let totalDiff = vol - player.volume
            let delta: Float = 0.075
            fadeTimer = Timer.scheduledTimer(withTimeInterval: Double(delta), repeats: true) { timer in
                let currDiff = vol - player.volume
                if currDiff.sign != totalDiff.sign || abs(currDiff) < 0.05 {
                    // we went just enough or too far
                    player.volume = vol
                    
                    if vol < 0.05 {
                        // we can't hear it anymore, so pause it.
                        player.pause()
                    }
                    timer.invalidate()
                } else {
                    player.volume += totalDiff * delta / Speaker.fadeDuration
                }
            }
        }
        
        return vol
    }
    
    func resume() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    static func from(data: Data) throws -> [Speaker] {
        let json = try JSON(data: data)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")

        return json.array!.map { obj in
            let it = obj.dictionaryValue
            let boundary = it["boundary"]!["coordinates"].array!
            let attenBound = it["attenuation_border"]!["coordinates"].array!
            let innerShape = Polygon(shell: LinearRing(points: attenBound.map { it in
                Coordinate(x: it[0].double!, y: it[1].double!)
            })!, holes: nil)!
            let outerShape = GeometryCollection(geometries: boundary.map { line in
                Polygon(shell: LinearRing(points: line.array!.map { p in
                    Coordinate(x: p[0].double!, y: p[1].double!)
                })!, holes: nil)!
            })!
            return Speaker(
                id: it["id"]!.int!,
                volume: it["minvolume"]!.float!...it["maxvolume"]!.float!,
                url: it["uri"]!.string!,
                backupUrl: it["backupuri"]!.string!,
                shape: outerShape,
                attenuationShape: innerShape,
                attenuationDistance: it["attenuation_distance"]!.int!
            )
        }
    }
}

extension CLLocation {
    func toWaypoint() -> Waypoint {
        return Waypoint(latitude: coordinate.latitude, longitude: coordinate.longitude)!
    }
    
    /// Returns the shortest distance (measured in meters) from the current object's location to the imaginary line running between the two specified locations.
    /// https://gist.github.com/pimnijman/f4a821fe2347632a27b940c70247a256
    /// - Parameters:
    ///   - start: The first location that makes up the imaginary line.
    ///   - end: The second location that makes up the imaginary line.
    /// - Returns: The shortest distance (in meters) between the current object's location and the imaginary line.
    func distanceToLine(from start: CLLocation, to end: CLLocation) -> CLLocationDistance {
        let s0lat = degreesToRadians(coordinate.latitude)
        let s0lng = degreesToRadians(coordinate.longitude)
        let s1lat = degreesToRadians(start.coordinate.latitude)
        let s1lng = degreesToRadians(start.coordinate.longitude)
        let s2lat = degreesToRadians(end.coordinate.latitude)
        let s2lng = degreesToRadians(end.coordinate.longitude)
        let s2s1lat = s2lat - s1lat
        let s2s1lng = s2lng - s1lng
        let u = ((s0lat - s1lat) * s2s1lat + (s0lng - s1lng) * s2s1lng) / (s2s1lat * s2s1lat + s2s1lng * s2s1lng)
        if u <= 0.0 {
            return distance(from: start)
        } else if u >= 1.0 {
            return distance(from: end)
        } else {
            let sa = CLLocation(latitude: coordinate.latitude - start.coordinate.latitude,
                                longitude: coordinate.longitude - start.coordinate.longitude)
            let sb = CLLocation(latitude: u * (end.coordinate.latitude - start.coordinate.latitude),
                                longitude: u * (end.coordinate.longitude - start.coordinate.longitude))
            return sa.distance(from: sb)
        }
    }
    
    private func degreesToRadians(_ degrees: Double) -> Double { return degrees * .pi / 180.0 }
}
