//
//  HomeViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 04/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO
import Accelerate

enum RecorderState {
    case recording
    case stopped
    case denied
}

class HomeViewController: BaseViewController, AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var lblStartRecord: UILabel!
    @IBOutlet weak var imageRecord: UIImageView!
    @IBOutlet weak var viewRecordAudio: UIView!
    @IBOutlet weak var visualizer: AudioVisualizerView!
    
    var audioRecorder: AVAudioRecorder!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPushFileComplaint = true
    
    var arrVoiceName = [String]()
    
    //For Audio
    var handleView = UIView()
    var recordButton = String()
    let settings = [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMBitDepthKey: 16, AVLinearPCMIsFloatKey: true, AVSampleRateKey: Float64(44100), AVNumberOfChannelsKey: 1] as [String : Any]
    let audioEngine = AVAudioEngine()
    private var renderTs: Double = 0
    private var recordingTs: Double = 0
    private var silenceTs: Double = 0
    private var audioFile: AVAudioFile?
    
    //MARK:- LifeCycleOfViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        //isRecording = true
        appShared.homeViewControllerRef = self
        
        if UserDefaults.standard.bool(forKey: kLogin) == true {
            viewRecordAudio.isHidden = false
            
        }else {
            viewRecordAudio.isHidden = true
            
        }
        self.lblStartRecord.isHidden = false
        checkRecordPermission()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isPushFileComplaint = true
        
        //self.navigationController?.navigationBar.isHidden = true
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
                
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: self.settings)
                audioRecorder.delegate = self
                //audioRecorder.isMeteringEnabled = true
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
        //        let format = DateFormatter()
        //        format.dateFormat="yyyy-MM-dd-HH-mm-ss-SSS"
        //        let filename = "recording-\(format.string(from: Date()))" + ".wav"
        
        let filename = "myRecording.wav"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    private func createAudioRecordFile() -> AVAudioFile? {
        guard let path = self.getFileUrl() as? URL else {
            return nil
        }
        do {
            let file = try AVAudioFile(forWriting: path, settings: self.settings, commonFormat: .pcmFormatFloat32, interleaved: true)
            return file
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func format() -> AVAudioFormat? {
        let format = AVAudioFormat(settings: self.settings)
        return format
    }
    
    // MARK:- Recording
    func startRecording() {
        self.recordingTs = NSDate().timeIntervalSince1970
        self.silenceTs = 0
        do {
            let session = AVAudioSession.sharedInstance()
            //try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        let inputNode = self.audioEngine.inputNode
        guard let format = self.format() else {
            return
        }
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { (buffer, time) in
            let level: Float = -50
            let length: UInt32 = 1024
            buffer.frameLength = length
            let channels = UnsafeBufferPointer(start: buffer.floatChannelData, count: Int(buffer.format.channelCount))
            var value: Float = 0
            vDSP_meamgv(channels[0], 1, &value, vDSP_Length(length))
            var average: Float = ((value == 0) ? -100 : 20.0 * log10f(value))
            if average > 0 {
                average = 0
            } else if average < -100 {
                average = -100
            }
            let silent = average < level
            let ts = NSDate().timeIntervalSince1970
            if ts - self.renderTs > 0.1 {
                let floats = UnsafeBufferPointer(start: channels[0], count: Int(buffer.frameLength))
                let frame = floats.map({ (f) -> Int in
                    return Int(f * Float(Int16.max))
                })
                DispatchQueue.main.async {
                    let seconds = (ts - self.recordingTs)
                    //self.timeLabel.text = seconds.toTimeString
                    self.renderTs = ts
                    let len = self.visualizer.waveforms.count
                    for i in 0 ..< len {
                        let idx = ((frame.count - 1) * i) / len
                        let f: Float = sqrt(1.5 * abs(Float(frame[idx])) / Float(Int16.max))
                        self.visualizer.waveforms[i] = min(49, Int(f * 50))
                    }
                    self.visualizer.active = !silent
                    self.visualizer.setNeedsDisplay()
                }
            }
            
            let write = true
            if write {
                if self.audioFile == nil {
                    self.audioFile = self.createAudioRecordFile()
                }
                if let f = self.audioFile {
                    do {
                        try f.write(from: buffer)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        do {
            self.audioEngine.prepare()
            try self.audioEngine.start()
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        self.updateUI(.recording)
    }
    
    func finishAudioRecording(success: Bool) {
        
        if success {
            
            audioRecorder.stop()
            audioRecorder = nil
            
            lblStartRecord.isHidden = false
            
            
            self.audioFile = nil
            self.audioEngine.inputNode.removeTap(onBus: 0)
            self.audioEngine.stop()
            self.updateUI(.stopped)
            
            print("recorded successfully.")
            
        }else{
            appShared.alert(vc: self, message: "Recording failed.")
        }
    }
    
    private func stopRecording() {
        self.audioFile = nil
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.audioEngine.stop()
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch  let error as NSError {
            print(error.localizedDescription)
            return
        }
        self.updateUI(.stopped)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VoiceRecordToReportVC") as! VoiceRecordToReportVC
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.voiceURL = getFileUrl()
        self.present(vc, animated: true, completion: nil)
    }
    
    private func checkPermissionAndRecord() {
        let permission = AVAudioSession.sharedInstance().recordPermission()
        switch permission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (result) in
                DispatchQueue.main.async {
                    if result {
                        self.startRecording()
                    }
                    else {
                        self.updateUI(.denied)
                    }
                }
            })
            break
        case .granted:
            self.startRecording()
            break
        case .denied:
            self.updateUI(.denied)
            break
        }
    }
    
    
    //MARK:- Update User Interface
    private func updateUI(_ recorderState: RecorderState) {
        switch recorderState {
        case .recording:
            UIApplication.shared.isIdleTimerDisabled = true
            self.visualizer.isHidden = false
            lblStartRecord.isHidden = true
            break
        case .stopped:
            UIApplication.shared.isIdleTimerDisabled = false
            self.visualizer.isHidden = true
            lblStartRecord.isHidden = false
            break
        case .denied:
            UIApplication.shared.isIdleTimerDisabled = false
            self.visualizer.isHidden = true
            lblStartRecord.isHidden = false
            break
        }
    }
    
    //MARK:- UIButtonActions
    @IBAction func btnRecord(_ sender: Any) {
        if(isRecording) {
            isRecording = false
            imageRecord.image = #imageLiteral(resourceName: "speaker")
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            stopRecording()
            
        }else {
            //setup_recorder()
            //audioRecorder.record()
            visualizer.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.visualizer.alpha = 1
            }, completion: nil)
            self.checkPermissionAndRecord()//startRecording()
            lblStartRecord.isHidden = true
            imageRecord.image = #imageLiteral(resourceName: "stop_recording")
            isRecording = true
        }
    }
    
    @IBAction func fileComplaintAction(_ sender: Any) {
        
        if isPushFileComplaint {
            
            isPushFileComplaint = false
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FileComplaintsViewController") as? FileComplaintsViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
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
        /*let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ResourceCenterViewController") as? ResourceCenterViewController
        self.navigationController?.pushViewController(vc!, animated: true)*/
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForumListViewController") as? ForumListViewController
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
