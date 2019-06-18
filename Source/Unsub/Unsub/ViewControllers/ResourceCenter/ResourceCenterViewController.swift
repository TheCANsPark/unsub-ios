//
//  ResourceCenterViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 18/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import Gloss
class ResourceCenterViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, URLSessionDownloadDelegate, UIDocumentBrowserViewControllerDelegate, UIDocumentInteractionControllerDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var resourceArr = [Resource]()
    let documentInteractiveVC = UIDocumentInteractionController()
    var fileName = String()
    var fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Resource Center"
        getResourceCenter()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Server Request
    func getResourceCenter() {
        Loader.shared.show()
        tableView.isHidden = true
        NetworkManager.sharedInstance.apiParseGet(url: WEB_URL.getResource, completion: {(response :NSDictionary?, statusCode : Int?) in
            Loader.shared.hide()
            if statusCode == STATUS_CODE.success {
                if let res = [Resource].from(jsonArray: response?.value(forKey: "data") as! [JSON]) {
                    self.resourceArr = res
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resourceArr.count != 0 {
            return resourceArr.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceCenterTableCell")
        let lblName : UILabel = cell?.contentView.viewWithTag(100) as! UILabel
        let lblDescription : UILabel = cell?.contentView.viewWithTag(101) as! UILabel
        let resource = resourceArr[indexPath.row]
        lblName.text = resource.name!
        lblDescription.text = resource.description!
        return cell!
    }
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let imagestring = String(resourceArr[indexPath.row].media_url!)
        Loader.shared.show()
        let url = URL.init(string: resourceArr[indexPath.row].media_url ?? "")
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let downloadTask = session.downloadTask(with: url!)
        downloadTask.resume()
        
        let str = String(describing: resourceArr[indexPath.row].media_url!)
        let fileArray = str.components(separatedBy: "/")
        let finalFileName = fileArray.last
        fileName = finalFileName!
    }
    
    //MARK:- URLSESSION Delegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print(location)
        
        let folderPath = AppSharedData.sharedInstance.getUnsubFolderPath()
        print(folderPath)
        do {
            try fileManager.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            NSLog("Unable to create directory!!!!")
        }
        
        let filePath  = folderPath.appendingPathComponent("\(self.fileName)")
        print(filePath)
        //
        do {
            try fileManager.copyItem(at: location, to: filePath)
            print("\(filePath)")
         //   try? fileManager.removeItem(at: location)
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
        Loader.shared.hide()
        DispatchQueue.main.async {
            self.documentInteractiveVC.url = filePath
            self.documentInteractiveVC.delegate = self
            self.documentInteractiveVC.presentPreview(animated: true)
        }
        
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress =  Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print(progress)
    }
    
    //MARK:- UIDocumentInteractionController Delegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
    
//       /// let str = String(describing: getUrl)
//        let fileArray = imagestring.components(separatedBy: ".")
//        let finalFileName = fileArray.last
//        if finalFileName == "mp4" {
//
//
//        } else if finalFileName == "jpeg" {
//
//        }
//        else {
//            if let url = URL(string: imagestring),
//                let data = try? Data(contentsOf: url),
//                let image = UIImage(data: data) {
//                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//            }
//        }
   
    
    

}
