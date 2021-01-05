//
//  VoiceRecordToReportVC.swift
//  Unsub
//
//  Created by mac on 22/12/20.
//  Copyright © 2020 codezilla-mac1. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceRecordToReportVC: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var isFromCaseDetail = false
    
    var audioPlayer : AVAudioPlayer!
    var isPlaying = false
    
    private var arrVoiceName = [String]()
    var voiceURL: URL?
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromCaseDetail {
            btnSubmit.isHidden = true
            lblTitle.text = "Play"
            
            NetworkManager.sharedInstance.downloadAndSaveFile(withUrl: voiceURL!, andFilePath: appShared.homeViewControllerRef.getFileUrl()) { (url) in
                self.prepare_play()
            }
        }else {
            self.prepare_play()
        }
    }
    
    //MARK: Helper
    /*func downloadFileFromURL(url:URL){

        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self](url1, response, error) -> Void in
            
            self?.voiceURL = url1
            self?.prepare_play()
            
        })
            
        downloadTask.resume()
        
    }*/
    
    func showAlert(message: String) {
        
        let refreshAlert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    @objc func updateTime(withDuration: Bool = false) {
        
        var currentTime = Int(audioPlayer.currentTime)
        
        if withDuration {
            currentTime = Int(audioPlayer.duration)
        }
        let minutes = currentTime/60
        let seconds = currentTime - minutes / 60
        
        updateSlider(to: self.audioSlider.value + Float(timer.timeInterval))
        //audioSlider.value = Float(currentTime)
        lblStartTime.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }
    
    private func updateSlider(to value: Float) {
        audioSlider.value = value
    }
    
    func prepare_play(){
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: appShared.homeViewControllerRef.getFileUrl())
            
            audioPlayer.volume = 1.0
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            
            let minutes = Int(audioPlayer.duration)/60
            let seconds = Int(audioPlayer.duration) - minutes / 60
            
            audioSlider.maximumValue = Float(audioPlayer.duration)
            audioSlider.minimumValue = 0.0
            
            //audioSlider.value = 0.0
            updateSlider(to: 0.0)
            
            lblEndTime.text = NSString(format: "%02d:%02d", minutes,seconds) as String
            lblStartTime.text = "00.00"
            
        }catch{
            print("Error")
        }
    }
    
    func playAudio() {
        if audioPlayer != nil {
            audioPlayer.play()
            
            if audioPlayer.currentTime  == audioPlayer.duration {
                self.updateSlider(to: 0.0)
                self.lblStartTime.text = "00.00"
            }
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            
            btnPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            isPlaying = true
        }
    }
    
    private func stopPlayer() {
        if audioPlayer != nil {
            audioPlayer.stop()
            timer.invalidate()
            btnPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            isPlaying = false
        }
    }
    
    //MARK:- Server Request
    func createIncidents() {
        
        let param = [
            "incident_type"             : 2,
            "voice_file"                : arrVoiceName
            ] as [String : Any]
        
        NetworkManager.sharedInstance.apiParsePostWithJsonEncoding(WEB_URL.createIncidents as NSString, postParameters: param as NSDictionary, completionHandler: {(response : NSDictionary?, statusCode : Int?) in
            Loader.shared.hide()
            if statusCode == STATUS_CODE.success {
                
                self.showAlert(message: response?.value(forKey: "message") as? String ?? "")
                
            } else if statusCode == STATUS_CODE.internalServerError {
                
                self.showAlert(message: response?.value(forKey: "message") as? String ?? "")
                //AppSharedData.sharedInstance.alert(vc: self, message: response?["message"] as? String ?? "Please wait while the file is being uploaded")
            }
        })
    }
    
    //MARK:- UIButtonActions
    @IBAction func play_recording(_ sender: Any){
        if(isPlaying){
            
            stopPlayer()
            
        }else{
            
            /*if isFromCaseDetail {
                
                playAudio()
                
            }else */
            if FileManager.default.fileExists(atPath: appShared.homeViewControllerRef.getFileUrl().path){
                
                playAudio()
                
            }else{
                appShared.alert(vc: self, message: "Audio file is missing.")
            }
            
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        audioPlayer.currentTime = TimeInterval(audioSlider.value)
        
        if audioPlayer.currentTime  == audioPlayer.duration {
            stopPlayer()
        }else {
            updateTime()
        }
    }
    
    @IBAction func btnUpload(_ sender: Any) {
        
        stopPlayer()
        
        Loader.shared.show()
        
        NetworkManager.sharedInstance.uploadVideo(videoFileUrl: voiceURL!, isVideo: false, imageUrl: URL(string: "http://")!, isCamera: false, imageData: UIImageJPEGRepresentation(#imageLiteral(resourceName: "without-check"), 0.1)! as NSData, filePath: URL(string: "http://")!, isFile: false, isVoice: true) { (urlVoice) in
            
            let str = String(describing: urlVoice)
            let fileArray = str.components(separatedBy: "/")
            let finalFileName = fileArray.last
            
            self.arrVoiceName.append(finalFileName ?? "")
            
            self.createIncidents()
            
            print(urlVoice)
        }
        
    }
    
    @IBAction func btnClose(_ sender: Any) {
        
        if isFromCaseDetail {
            self.dismiss(animated: true, completion: nil)
            self.stopPlayer()
        }else {
            self.showAlert(message: "Are you sure you want to Cancel?")
            self.stopPlayer()
        }
        
//        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Cancel?", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
//
//            self.dismiss(animated: true, completion: nil)
//            self.stopPlayer()
//
//        }))
//        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        if flag {
            btnPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            DispatchQueue.main.async() {
                self.updateSlider(to: 0.0)
                self.lblStartTime.text = "00.00"
            }
            timer.invalidate()
            isPlaying = false
        }
    }
    
}
