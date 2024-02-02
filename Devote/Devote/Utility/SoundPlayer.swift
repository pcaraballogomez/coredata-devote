//
//  SoundPlayer.swift
//  Devote
//
//  Created by Pablo Caraballo Gómez on 2/2/24.
//

import Foundation
import AVFoundation

enum Mp3Sound: String {
    case ding = "sound-ding"
    case rise = "sound-rise"
    case tap = "sound-tap"
}

var audioPlayer: AVAudioPlayer?

func playMp3Sound(_ sound: Mp3Sound) {
    guard let path = Bundle.main.path(forResource: sound.rawValue,
                                      ofType: "mp3") else {
        return
    }
    do {
        let url = URL(fileURLWithPath: path)
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
    } catch {
        print("Could not find and play the sound file")
    }
}
