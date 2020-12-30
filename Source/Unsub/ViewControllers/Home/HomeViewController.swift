//
//  HomeViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 04/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import AVFoundation


class HomeViewController: BaseViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var viewSoundWave: UIView!
    @IBOutlet weak var lblStartRecord: UILabel!
    @IBOutlet weak var imageRecord: UIImageView!
    @IBOutlet weak var viewRecordAudio: UIView!
    
    var audioRecorder: AVAudioRecorder!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    
    var arrVoiceName = [String]()
    
    //MARK:- LifeCycleOfViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        checkRecordPermission()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if UserDefaults.standard.bool(forKey: kLogin) == true {
//            viewRecordAudio.isHidden = false
//        }else {
//            viewRecordAudio.isHidden = true
//        }
    }
    
    override func didReceiveMemoryWarning() {  
        super.didReceiveMemoryWarning()
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
            
            lblStartRecord.isHidden = false
            viewSoundWave.isHidden = true
            
            print("recorded successfully.")
            
            
        }else{
            appShared.alert(vc: self, message: "Recording failed.")
        }
    }
    
    
    //MARK:- UIButtonActions
    @IBAction func btnRecord(_ sender: Any) {
        if(isRecording) {
            
            finishAudioRecording(success: true)
            isRecording = false
            imageRecord.image = #imageLiteral(resourceName: "speaker")
            
        }else {
            
            setup_recorder()
            audioRecorder.record()
            
            lblStartRecord.isHidden = true
            viewSoundWave.isHidden = false
            
            imageRecord.image = #imageLiteral(resourceName: "stop_recording")
            
            isRecording = true
        }
    }
    
    @IBAction func fileComplaintAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FileComplaintsViewController") as? FileComplaintsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func emergencyAction(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("loadContactViewController"), object: nil)
    }
    
    @IBAction func myComplaintsActio(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: kLogin) == true  {
            NotificationCenter.default.post(name: Notification.Name("loadIncidentsViewController"), object: nil)
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginnViewController") as! LoginnViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func resourceCenterAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ResourceCenterViewController") as? ResourceCenterViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK:- AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishAudioRecording(success: false)
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VoiceRecordToReportVC") as! VoiceRecordToReportVC
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overCurrentContext
            
            vc.voiceURL = getFileUrl()
            self.present(vc, animated: true, completion: nil)
            
            isRecording = false
        }
    }
}
