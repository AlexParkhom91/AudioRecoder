//
//  ExtentionTableView.swift
//  AudioRecorder
//
//  Created by Александр Пархамович on 7.09.22.
//

import Foundation
import UIKit
import AVFoundation

//extension ViewController: UITableViewDataSource, UITableViewDelegate {
//     
//
//
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//      recordings.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let path = recordings[indexPath.row]
//
//        audioPlayer = try? AVAudioPlayer(contentsOf: path)
//
//        let duration = audioPlayer.duration
//
//        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .positional
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.zeroFormattingBehavior = [.pad]
//
//        let fileDuration = formatter.string(from: duration)
//
//     
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Сell", for: indexPath)
//        cell.textLabel?.text = recordings[indexPath.row].lastPathComponent
//        cell.textLabel?.numberOfLines = 2
//        cell.detailTextLabel!.text = fileDuration
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let path = recordings[indexPath.row]
//
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: path)
//            audioPlayer.prepareToPlay()
//            audioPlayer.volume = 5
//            audioPlayer.play()
//        } catch {
//            self.audioPlayer = nil
//        }
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        let path = recordings[indexPath.row]
//
//        if editingStyle == .delete {
//
//            do {
//                try? FileManager.default.removeItem(at: path)
//                listRecordings()
//                listRecordingsTableView.reloadData()
//            }
//        }
//    }
//}

