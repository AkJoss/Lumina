//
//  MusicModels.swift
//  Lu
//

import Foundation

struct Track: Hashable {
    let title: String
    let artist: String
    /// Duration in seconds (demo values).
    let duration: TimeInterval

    var durationText: String {
        let m = Int(duration) / 60
        let s = Int(duration) % 60
        return String(format: "%d:%02d", m, s)
    }
}

enum MusicCatalog {
    static let soundHelixArtist = "SoundHelix"

    static let soundHelixTracks: [Track] = (1...4).map { n in
        Track(
            title: "SoundHelix Song \(n)",
            artist: soundHelixArtist,
            duration: 180 + Double(n) * 12
        )
    }

    static let libraryTracks: [Track] = soundHelixTracks
}
