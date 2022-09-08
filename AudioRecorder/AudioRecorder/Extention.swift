//
//  Extention.swift
//  AudioRecorder
//
//  Created by Александр Пархамович on 7.09.22.
//

import Foundation
import UIKit
extension ViewController {
    
    @objc func updateAudioMeter(_ timer: Timer) {
               
        if let recorder = self.audioRecorder {
           if recorder.isRecording {
               let min = Int(recorder.currentTime / 60)
               let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
               let timeString = String(format: "%02d:%02d", min, sec)
               recordingTimeLabel.text = timeString
               recorder.updateMeters()
            }
    }
}
        
    func startTimer() {
       self.meterTimer = Timer.scheduledTimer(
       timeInterval: 0.1,
       target: self,
       selector: #selector(self.updateAudioMeter(_:)),
       userInfo: nil,
       repeats: true)
   }
}
