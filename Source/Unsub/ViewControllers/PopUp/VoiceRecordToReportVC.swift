//
//  VoiceRecordToReportVC.swift
//  Unsub
//
//  Created by mac on 22/12/20.
//  Copyright © 2020 codezilla-mac1. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceRecordToReportVC: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate{

    @IBOutlet weak var btnRecordSound: UIButton!
    @IBOutlet weak var btnPlaySound: UIButton!
    @IBOutlet weak var lblRecordStatus: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkRecordPermission()
    }
    
    func checkRecordPermission() {
        let status = AVAudioSession.sharedInstance().recordPermission()
        
        if status == .granted {
            isAudioRecordingGranted = true
        }else if status == .denied {
            isAudioRecordingGranted = false
        }else if status == .undetermined {
            AVAudioSession.sharedInstance().requestRecordPermission { (isAllowed) in
                if isAllowed {
                    self.isAudioRecordingGranted = true
                }else {
                    self.isAudioRecordingGranted = false
                }
            }
        }
    }
    
    func setup_recorder() {
        if isAudioRecordingGranted {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                appShared.alert(vc: self, message: error.localizedDescription)
            }
        }else{
            appShared.alert(vc: self, message: "Don't have access to use your microphone.")
        }
    }
    
    @objc func updateAudioMeter(timer: Timer) {
        if audioRecorder.isRecording {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            lblRecordStatus.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func getFileUrl() -> URL {
        let filename = "myRecording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }

    func finishAudioRecording(success: Bool) {
        if success {
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            print("recorded successfully.")
        }else{
            appShared.alert(vc: self, message: "Recording failed.")
        }
    }
    
    func prepare_play() {
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }catch{
            print("Error")
        }
    }
    
    //MARK:- UIButtonActions
    @IBAction func btnRecord(_ sender: Any) {
        if !isPlaying {
            if(isRecording) {
                
                finishAudioRecording(success: true)
                btnRecordSound.setTitle("Record", for: .normal)
                isRecording = false
                
            }else {
                
                setup_recorder()
                audioRecorder.record()
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                btnRecordSound.setTitle("Stop", for: .normal)
                isRecording = true
            }
            
        }
    }

    @IBAction func play_recording(_ sender: Any) {
        if !isRecording {
            if(isPlaying){
                
                if audioPlayer != nil {
                    audioPlayer.stop()
                    btnPlaySound.setTitle("Play", for: .normal)
                    isPlaying = false
                }
                
            }else{
                if FileManager.default.fileExists(atPath: getFileUrl().path){
                    btnPlaySound.setTitle("pause", for: .normal)
                    prepare_play()
                    isPlaying = true
                }else{
                    appShared.alert(vc: self, message: "Audio file is missing.")
                }
            }
        }
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishAudioRecording(success: false)
        }else {
            NetworkManager.sharedInstance.uploadVideo(videoFileUrl: getFileUrl(), isVideo: true, imageUrl: URL(string: "http://")!, isCamera: false, imageData: UIImageJPEGRepresentation(#imageLiteral(resourceName: "without-check"), 0.1)! as NSData, filePath: URL(string: "http://")!, isFile: false) { (url) in
                print(url)
            }
            lblRecordStatus.text = "Start Recording"
            isRecording = false
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        if flag {
            btnPlaySound.setTitle("Play", for: .normal)
            isPlaying = false
        }
    }
    
    
}
