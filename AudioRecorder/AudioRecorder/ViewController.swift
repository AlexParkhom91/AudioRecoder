//
//  ViewController.swift
//  AudioRecorder
//
//  Created by Александр Пархамович on 7.09.22.
//

import UIKit

import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
//    MARK: - constants
    
    let recordingTimeLabel = UILabel()
    let recordButton = UIButton()
    let stopButton = UIButton()
    let listRecordingsTableView = UITableView()
    let cell = UITableViewCell()
    
//    MARK: - Properties
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var recordSession: AVAudioSession!
    
    var recordings = [URL]()
    
    var meterTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        setupUI()
        listRecordings()
        checkPermission()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        audioRecorder = nil
        audioPlayer = nil
    }
    
//    MARK: - Custom methods
    
    private func setupUI() {
      

        
        let recordButton = createNewButton(buttonTitle: "Record")
        recordButton.addTarget(self, action: #selector(recordPressed), for: .touchUpInside)
        view.addSubview(recordButton)
        
        NSLayoutConstraint.activate([
            recordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30 ),
            recordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: -30),
            recordButton.widthAnchor.constraint(equalToConstant: 120),
            recordButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let stopButton = createNewButton(buttonTitle: "Stop")
        stopButton.addTarget(self, action: #selector(stopPressed), for: .touchUpInside)
        view.addSubview(stopButton)
        
        NSLayoutConstraint.activate([
            stopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30 ),
            stopButton.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: -30),
            stopButton.widthAnchor.constraint(equalToConstant: 120),
            stopButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        recordingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recordingTimeLabel)
        NSLayoutConstraint.activate([
            recordingTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70 ),
            recordingTimeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: -70),
            recordingTimeLabel.widthAnchor.constraint(equalToConstant: 150),
            recordingTimeLabel.heightAnchor.constraint(equalToConstant: 100)
            
        ])
        
      view.addSubview(listRecordingsTableView)
        listRecordingsTableView.backgroundColor = .cyan
        listRecordingsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([

            listRecordingsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            listRecordingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor ),
            listRecordingsTableView.widthAnchor.constraint(equalTo: view.widthAnchor ),
            listRecordingsTableView.heightAnchor.constraint(equalToConstant: 450)

        ])
       
    }
    private func checkPermission() {
        
        recordSession = AVAudioSession.sharedInstance()
        
        do {
            try recordSession.setCategory(.playAndRecord, mode: .default)
            try recordSession.setActive(true)
            recordSession.requestRecordPermission() { [unowned self] allowed in
                
                if allowed {
                    
                    print("Доступ получен")

                } else {
                    
                    DispatchQueue.main.async {
                        self.recordButton.isEnabled = false
                        self.recordButton.backgroundColor = .darkGray
                        
                        self.stopButton.isEnabled = false
                        
                        self.recordingTimeLabel.text = "Нет доступа"
                    }
                }
            }
            
            if AVAudioSession.sharedInstance().recordPermission == .denied {

                print("Нет доступа")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getDirectoryUrl() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func listRecordings() {
        
        do {
            let urls = try FileManager.default.contentsOfDirectory(at:
                getDirectoryUrl(), includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            self.recordings = urls.filter({ (name: URL) -> Bool in
                return name.pathExtension == "m4a"
            }).sorted(by: { $0.lastPathComponent > $1.lastPathComponent })
                        
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupRecorder() {

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        
        let recordingName = getDirectoryUrl().appendingPathComponent("Recording_\(format.string(from: Date())).m4a")
                
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
                
        do {

            audioRecorder = try AVAudioRecorder(url: recordingName, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()

        } catch {
            
            finishAudioRecording(success: false)
            print(#line, #function, error.localizedDescription)
        }
    }
    
    private func finishAudioRecording(success: Bool) {
        
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            print("recodr")
        } else {
            print("error")
        }
        
        recordButton.isEnabled = true
        recordButton.isHighlighted = false
    }
    
//    MARK: -   @objc Functions
    
  @objc func recordPressed(_ sender: UIButton) {
        
        if audioPlayer != nil && audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        
        if audioRecorder == nil {
            
            setupRecorder()
            
            recordButton.isEnabled = false
            recordButton.isHighlighted = true
            
            stopButton.isEnabled = true
            stopButton.isHighlighted = false
            
            startTimer()
            audioRecorder.record()
        }
    }
    
    @objc func stopPressed(_ sender: UIButton) {
        
        stopButton.isEnabled = false
        stopButton.isHighlighted = true

        recordButton.isEnabled = true
        recordButton.isHighlighted = false

        recordingTimeLabel.text = "00:00"
        meterTimer.invalidate()
        
        if audioRecorder != nil {
            finishAudioRecording(success: true)

            listRecordings()
            listRecordingsTableView.reloadData()
        }
    }

    
//    MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

        if !flag {
            finishAudioRecording(success: false)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if !flag {
        recordButton.isEnabled = true
        stopButton.isEnabled = false
        }
    }
}
