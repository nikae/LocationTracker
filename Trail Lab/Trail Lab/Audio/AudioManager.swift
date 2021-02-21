//
//  AudioManager.swift
//  Trail Lab
//
//  Created by Nika on 12/16/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import CoreLocation
import AVFoundation

class AudioNode {
    let title: String
    let audioId: String
    let latitude: Double
    let longitude: Double
    let next: AudioNode?
    var isPlayed: Bool
    
    init(title: String, audioId: String, latitude: Double, longitude: Double, next: AudioNode? = nil, isPlayed: Bool?=false) {
        self.title = title
        self.audioId = audioId
        self.latitude = latitude
        self.longitude = longitude
        self.next = next
        self.isPlayed = isPlayed ?? false
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
}

class AudioManager {
    static let shared = AudioManager()
   
    var player: AVAudioPlayer?
    
    let node1: AudioNode
    let node: AudioNode
    var nodeLocal: AudioNode?
    var isPlaying: Bool = false
    
    init() {
        node1 = AudioNode(title: "v2", audioId: "V2", latitude: 34.087701, longitude: -118.284537)
        node = AudioNode(title: "v1", audioId: "V1", latitude: 34.088481, longitude: -118.284560, next: node1)
        nodeLocal = node
    }
    
    func checkForLocation(location: CLLocation) {
        if nodeLocal?.isPlayed ?? false {
            nodeLocal = nodeLocal?.next
        }
        
        if  let nodeLocalU = nodeLocal {
            
            let distanceInMeters = location.distance(from: nodeLocalU.location)
            print("DDDDDDDDDD ------- \(distanceInMeters)")
            if distanceInMeters >= 5 && distanceInMeters <= 15 {
                playSound(soundName: nodeLocalU)
                nodeLocal?.isPlayed = true
            }
        }
    }

    func playSound(soundName: AudioNode) {
        guard let url = Bundle.main.url(forResource: soundName.audioId, withExtension: "m4a") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()
           

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
