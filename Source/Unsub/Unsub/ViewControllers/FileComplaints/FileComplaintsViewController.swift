//
//  FileComplaintsViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 10/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
import Gloss
import SkyFloatingLabelTextField
import AVFoundation
import CoreLocation
import AES256CBC

class FileComplaintsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDelegateFlowLayout, UIDocumentMenuDelegate, UIDocumentPickerDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastname: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCategory: SkyFloatingLabelTextField!
    @IBOutlet weak var txtDatetime: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobVictim: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAddressLocation: SkyFloatingLabelTextField!
   
    @IBOutlet weak var txtAnnonymousName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCrimeDetail: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblNameAttachment: UILabel!
    @IBOutlet weak var btnAddRemoveAttachment: UIButton!
    
    @IBOutlet weak var imgAccept: UIImageView!
    @IBOutlet weak var imgSomeOne: UIImageView!
    @IBOutlet weak var imgMyself: UIImageView!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let picker = UIImagePickerController()
    var videoURL = NSURL()
    var imageURL = NSURL()
    var imgData = Data()
    var categoriesArr = [Categories]()
    let pickerCategories:UIPickerView = UIPickerView()
    var selectedTextField:UITextField!
    var catName = String()
    var catID = String()
    var fileURL = NSURL()
   
    var photoVideoImageArr = [UIImage]()
    var isPicVideoSelected : Int = 2
    var picVideoUrlArr = [URL]()
    var onlyVideoURL = NSURL()
    var onceVideoSelected = 1
    var pdfName = String()
    let documentInteractionController = UIDocumentInteractionController()
    let locationManager = CLLocationManager()

    let datePicker:UIDatePicker = UIDatePicker()
    var dateUTC = String()
    var latitute : Double = 0.0
    var longitute : Double = 0.0
    var arrImagesName = [String]()
    var arrVideoName = [String]()
    var isAttachedFile : Int = 0
    var submittedBy = String()
    var arrType = [String]()
    var arrTypeNonLogin = [String]()
    var isType : Int = 0
    var isAccept : Int = 0
    var isVideoOrPic = [String]()
    var vidImgCount = [String]()
    var vidImgCountUpload = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        if UserDefaults.standard.bool(forKey: kLogin) == true {
            let val = UserDefaults.standard.value(forKey: kLoginResponse) as! NSDictionary
            let name = val.value(forKey: "name") as! NSDictionary
            self.txtFirstName.text = name.value(forKey: "first") as? String
            self.txtFirstName.isUserInteractionEnabled = false
            self.txtLastname.text = name.value(forKey: "last") as? String
            self.txtLastname.isUserInteractionEnabled = false
            self.txtMobVictim.text = val.value(forKey: "mobile_number") as? String
            self.txtMobVictim.isUserInteractionEnabled = false
            self.txtAnnonymousName.text = val.value(forKey: "annonymous_name") as? String
            self.txtAnnonymousName.isUserInteractionEnabled = false
            self.txtEmail.text = val.value(forKey: "email") as? String
            self.txtEmail.isUserInteractionEnabled = false
            self.imgMyself.image = #imageLiteral(resourceName: "radio_filled")
            self.imgSomeOne.image = #imageLiteral(resourceName: "radio_unfilled")
            submittedBy = "Myself"
        }
       
        picker.delegate = self
        self.title = "File Incidence"
        getCategories()
        lblNameAttachment.isHidden = true
        txtCrimeDetail.layer.cornerRadius = 10.0
        txtCrimeDetail.clipsToBounds = true
        txtCrimeDetail.layer.borderWidth = 1.0
        txtCrimeDetail.layer.borderColor = UIColor.lightGray.cgColor
    }
    //MARK:- Server Requests
    func getCategories() {
        Loader.shared.show()
        NetworkManager.sharedInstance.apiParseGet(url: WEB_URL.categories, completion: {(response: NSDictionary?,statusCode : Int?) in
            Loader.shared.hide()
            print(response!)
            if statusCode == STATUS_CODE.success {
                
                
                if let cat = [Categories].from(jsonArray: response?.value(forKey: "data") as! [JSON]) {
                    self.categoriesArr = cat
                }
            } else if statusCode == STATUS_CODE.internalServerError {
                AppSharedData.sharedInstance.alert(vc: self, message: response?.value(forKey: "message") as! String)
            }
            
        })
    }
    func createIncidents() {
        Loader.shared.show()
        let param = ["first_name"                : txtFirstName.text!,
                     "last_name"                 : txtLastname.text!,
                     "email"                     : txtEmail.text!,
                     "phone_number"              : txtMobVictim.text!,
                     "Category"                  : catID,
                     "crime_details"             : txtCrimeDetail.text!,
                     "images"                    : arrImagesName,
                     "videos"                    : arrVideoName,
                     "incident_date"             : dateUTC,
                     "lat"                       : latitute,
                     "long"                      : longitute,
                     "address"                   : txtAddressLocation.text!,
                     "attachment"                : pdfName,
                     "submitted_by"              : submittedBy,
                     "annonymous_name"           : txtAnnonymousName.text!
                    ] as [String : Any]
        NetworkManager.sharedInstance.apiParsePostWithJsonEncoding(WEB_URL.createIncidents as NSString, postParameters: param as NSDictionary, completionHandler: {(response : NSDictionary?, statusCode : Int?) in
            Loader.shared.hide()
            if statusCode == STATUS_CODE.success {
                let refreshAlert = UIAlertController(title: "Alert", message: response?.value(forKey: "message") as? String, preferredStyle: UIAlertControllerStyle.alert)
                refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(refreshAlert, animated: true, completion: nil)
                
            } else if statusCode == STATUS_CODE.internalServerError {
                AppSharedData.sharedInstance.alert(vc: self, message: "Please wait while the image is being uploaded")
            }
        })
    }
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtCategory {
          createStockPicker(txtCategory)
        } else if textField == txtDatetime {
          createDatePicker()
        }
        return true
    }
    //MARK:- UIDocumentPickerDelegate
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        fileURL = myURL as NSURL
        let fileName = myURL.lastPathComponent
        lblNameAttachment.isHidden = false
        lblNameAttachment.text = fileName
        btnAddRemoveAttachment.setTitle("Delete it", for: .normal)
        isAttachedFile = 1
        lblNameAttachment.isHidden = false
        NetworkManager.sharedInstance.uploadVideo(videoFileUrl: videoURL as URL, isVideo: false, imageUrl: imageURL as URL, isCamera: false, imageData: imgData as NSData, filePath: fileURL as URL, isFile: true, completionHandler: {(urlImgVideo : URL?) in
            print(urlImgVideo!)
            let str = String(describing: urlImgVideo!)
            let fileArray = str.components(separatedBy: "/")
            let finalFileName = fileArray.last
            self.pdfName = finalFileName!
        })
    }
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
   func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    //MARK:- Date Picker
    func createDatePicker(){
        datePicker.datePickerMode = .dateAndTime
        datePicker.maximumDate = Date()
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(fromTimePickerDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(fromTimePickerCancel))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        txtDatetime.inputAccessoryView = toolbar
        txtDatetime.inputView = datePicker
    }
    @objc func fromTimePickerDone(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy  hh:mm:ss a"
        txtDatetime.text = formatter.string(from: datePicker.date)
        dateUTC = get_Date_time_from_UTC_time(string: txtDatetime.text!)
        self.view.endEditing(true)
    }
    func get_Date_time_from_UTC_time(string : String) -> String {
        
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "MMM dd,yyyy  hh:mm:ss a"
        let dt = string
        let dt1 = dateformattor.date(from: dt)
        dateformattor.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        dateformattor.timeZone = NSTimeZone.init(abbreviation: "UTC") as TimeZone!
        return dateformattor.string(from: dt1!)
    }
    @objc func fromTimePickerCancel(){
        self.view.endEditing(true)
    }
    //MARK:- UIPickerView
    func createStockPicker(_ textField: UITextField){
        pickerCategories.delegate = self
        pickerCategories.dataSource = self
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(pickerDone))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(pickerCancel))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        textField.inputAccessoryView = toolbar
        textField.tintColor = .clear
        textField.inputView = pickerCategories
        selectedTextField = textField
    }
    //MARK:- UIPickerViewDataSource
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesArr.count
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        return "\(categoriesArr[row].name!)"
        
    }
    //MARK:- UIPickerViewDelegate
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        catName = "\(categoriesArr[row].name!)"
        catID = categoriesArr[row]._id!
    }
    //MARK:- Helper
    @objc func pickerDone(){
        txtCategory.text = catName
        self.view.endEditing(true)
    }
    @objc func pickerCancel(){
        self.view.endEditing(true)
    }
    //MARK:- UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if photoVideoImageArr.count != 0 && isPicVideoSelected == 1 {
                return photoVideoImageArr.count
            } else if photoVideoImageArr.count != 0 && isPicVideoSelected == 0 {
                return photoVideoImageArr.count + 1
            } else if photoVideoImageArr.count == 0 && isPicVideoSelected == 0 {
                return 1
            } else {
                return 0
            }
            
        } else {
            return 1
        }
   }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageVideoCollectionCell", for: indexPath)
            let imgView : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
            let activityInd : UIActivityIndicatorView = cell.contentView.viewWithTag(200) as! UIActivityIndicatorView
            let videoImgView : UIImageView = cell.contentView.viewWithTag(300) as! UIImageView
            
            if isPicVideoSelected == 1 {
                activityInd.startAnimating()
                activityInd.isHidden = false
                videoImgView.isHidden = true
                activityInd.isHidden = true
                activityInd.stopAnimating()
                let image = photoVideoImageArr[indexPath.row]
                imgView.image = image
                
                if self.isVideoOrPic.count != 0 {
                    let isVideoPic = isVideoOrPic[indexPath.row]
                    if isVideoPic == "mov" {
                        videoImgView.isHidden = false
                    } else {
                        videoImgView.isHidden = true
                    }
                }
            }
            return cell
          
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMediaCollectionCell", for: indexPath)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            // create an actionSheet
            let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            // create an action
            let firstAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
                print("Camera Action pressed")
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.picker.allowsEditing = true
                    self.picker.sourceType = .camera
                    self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
                    self.picker.mediaTypes = ["public.image", "public.movie"]
                    self.present(self.picker, animated: true, completion: nil)
                } else {
                    AppSharedData.sharedInstance.alert(vc: self, message: "There is no camera available")
                }
           }
            let secondAction: UIAlertAction = UIAlertAction(title: "Select from gallery", style: .default) { action -> Void in
                self.picker.allowsEditing = true
                self.picker.sourceType = .photoLibrary
                self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.picker.mediaTypes = ["public.image", "public.movie"]
                self.present(self.picker, animated: true, completion: nil)
                print("Gallery A ction pressed")
            }
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
            
            // add actions
            actionSheetController.addAction(firstAction)
            actionSheetController.addAction(secondAction)
            actionSheetController.addAction(cancelAction)
            
            // present an actionSheet...
            present(actionSheetController, animated: true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60.0, height: 60.0)
    }
    //MARK:- UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print(info)
       
        if picker.sourceType == .photoLibrary {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            if let mediaType = info[UIImagePickerControllerMediaType] as? String {
                if mediaType  == "public.image" {
                    self.isPicVideoSelected = 0
                    self.collectionView.reloadData()
                    print("Image Selected")
                    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                    imgData = UIImagePNGRepresentation(image)!
                    imageURL = (info["UIImagePickerControllerImageURL"] as? NSURL)!
                    self.photoVideoImageArr.append(image)
                    self.isPicVideoSelected = 1
                    self.picVideoUrlArr.append(imageURL as URL)
                    self.isVideoOrPic.append("jpg")
                    self.vidImgCount.append("jpg")
                    self.collectionView.reloadData()
                    NetworkManager.sharedInstance.uploadVideo(videoFileUrl: videoURL as URL, isVideo: false, imageUrl: imageURL as URL, isCamera: false, imageData: imgData as NSData, filePath: fileURL as URL, isFile: false, completionHandler: {(urlImgVideo : URL?) in
                        let str = String(describing: urlImgVideo!)
                        let fileArray = str.components(separatedBy: "/")
                        let finalFileName = fileArray.last
                        self.arrImagesName.append(finalFileName!)
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.vidImgCountUpload.append("jpg")
                       // self.picVideoUrlArr.append(urlImgVideo!)
                      //  self.collectionView.reloadData()
                    })
                }
                if mediaType == "public.movie" {
                    print("Video Selected")
                    
                    if self.onlyVideoURL.absoluteString?.isEmpty == false && onceVideoSelected == 2 {
                        dismiss(animated: true,completion: nil)
                        AppSharedData.sharedInstance.alert(vc: self, message: "Only one video can be attached.")
                    } else {
                        activityIndicator.isHidden = false
                        activityIndicator.startAnimating()
                        self.isPicVideoSelected = 0
                        self.collectionView.reloadData()
                        videoURL = (info["UIImagePickerControllerMediaURL"] as? NSURL)!
                        let img = self.thumbnailForVideoAtURL(url: self.videoURL)!
                        self.photoVideoImageArr.append(img)
                        self.isPicVideoSelected = 1
                        self.onceVideoSelected = 2
                        self.picVideoUrlArr.append(videoURL as URL)
                        print(self.picVideoUrlArr)
                        self.onlyVideoURL = videoURL as NSURL
                        self.isVideoOrPic.append("mov")
                        self.vidImgCount.append("jpg")
                        self.collectionView.reloadData()
                        NetworkManager.sharedInstance.uploadVideo(videoFileUrl: videoURL as URL, isVideo: true, imageUrl: imageURL as URL, isCamera: false, imageData: imgData as NSData, filePath: fileURL as URL, isFile: false, completionHandler: {(urlImgVideo : URL?) in
                            let str = String(describing: urlImgVideo!)
                            let fileArray = str.components(separatedBy: "/")
                            let finalFileName = fileArray.last
                            self.arrVideoName.append(finalFileName!)
                            self.activityIndicator.isHidden = true
                            self.activityIndicator.stopAnimating()
                            self.vidImgCountUpload.append("jpg")
                          //  self.picVideoUrlArr.append(urlImgVideo!)
                           // self.collectionView.reloadData()
                        })
                    }
                }
            }
            
        } else if picker.sourceType == .camera {
            print("Image Selected")
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            if let mediaType = info[UIImagePickerControllerMediaType] as? String {
                if mediaType  == "public.image" {
                    self.isPicVideoSelected = 0
                    self.collectionView.reloadData()
                    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                    imgData = UIImagePNGRepresentation(image)!
                    self.photoVideoImageArr.append(image)
                    self.isPicVideoSelected = 1
                    self.picVideoUrlArr.append(imageURL as URL)
                    print(self.picVideoUrlArr)
                    self.isVideoOrPic.append("jpg")
                    self.vidImgCount.append("jpg")
                    self.collectionView.reloadData()
                    NetworkManager.sharedInstance.uploadVideo(videoFileUrl: videoURL as URL, isVideo: false, imageUrl: imageURL as URL, isCamera: true, imageData: imgData as NSData, filePath: fileURL as URL, isFile: false, completionHandler: {(urlImgVideo : URL?) in
                        let str = String(describing: urlImgVideo!)
                        let fileArray = str.components(separatedBy: "/")
                        let finalFileName = fileArray.last
                        self.arrImagesName.append(finalFileName!)
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.vidImgCountUpload.append("jpg")
                       // self.picVideoUrlArr.append(urlImgVideo!)
                        //self.collectionView.reloadData()
                    })
                }
                if mediaType == "public.movie" {
                    print("Video Selected")
                    if self.onlyVideoURL.absoluteString?.isEmpty == false  && onceVideoSelected == 2 {
                        dismiss(animated: true,completion: nil)
                        AppSharedData.sharedInstance.alert(vc: self, message: "Only one video can be attached.")
                    } else {
                        activityIndicator.isHidden = false
                        activityIndicator.startAnimating()
                        self.isPicVideoSelected = 0
                        self.collectionView.reloadData()
                        videoURL = (info["UIImagePickerControllerMediaURL"] as? NSURL)!
                        let img = self.thumbnailForVideoAtURL(url: self.videoURL)!
                        self.photoVideoImageArr.append(img)
                        self.isPicVideoSelected = 1
                        self.onceVideoSelected = 2
                        self.onlyVideoURL = videoURL as NSURL
                        self.picVideoUrlArr.append(videoURL as URL)
                        print(self.picVideoUrlArr)
                        self.isVideoOrPic.append("mov")
                        self.vidImgCount.append("jpg")
                        self.collectionView.reloadData()
                        NetworkManager.sharedInstance.uploadVideo(videoFileUrl: videoURL as URL, isVideo: true, imageUrl: imageURL as URL, isCamera: true, imageData: imgData as NSData, filePath: fileURL as URL, isFile: false, completionHandler: {(urlImgVideo : URL?) in
                            let str = String(describing: urlImgVideo!)
                            let fileArray = str.components(separatedBy: "/")
                            let finalFileName = fileArray.last
                            self.arrVideoName.append(finalFileName!)
                            self.activityIndicator.isHidden = true
                            self.activityIndicator.stopAnimating()
                            self.vidImgCountUpload.append("jpg")
                        })
                    }
                }
            }
        }
        dismiss(animated: true,completion: nil)
     }
    //MARK:- Generate Thumbnail
     func thumbnailForVideoAtURL(url: NSURL) -> UIImage? {
        let asset = AVAsset(url: url as URL)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
    //MARK:- CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        latitute = locValue.latitude
        longitute = locValue.longitude
        getAddressFromLatLon(pdblLatitude: "\(locValue.latitude)", withLongitude: "\(locValue.longitude)")
    }
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    print(pm.location)
                    print(pm.name)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    print(addressString)
                    self.locationManager.stopUpdatingLocation()
                    self.txtAddressLocation.text = addressString
                }
        })
        
    }
    //MARK:- UIButtonActions
    @IBAction func getLocation(_ sender: Any) {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    @IBAction func addAttachment(_ sender: Any) {
        if isAttachedFile == 1 {
            btnAddRemoveAttachment.setTitle("Add Attachment", for: .normal)
            lblNameAttachment.isHidden = true
            lblNameAttachment.text = ""
            self.isAttachedFile = 0
            
        } else {
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
            documentPicker.delegate = self
            present(documentPicker, animated: true, completion: nil)
        }
        
    }
    @IBAction func submit(_ sender: Any) {
       if txtFirstName.text?.count  == 0 || txtCategory.text?.count == 0 || txtCrimeDetail.text?.count == 0 || txtEmail.text?.count == 0 {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please enter all the fields.")
            
        } else if isAccept == 0 {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please accept all terms and conditions")
       } else if vidImgCount != vidImgCountUpload {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please wait while the image is being uploaded")
       }
            /*else if txtMobSubmitter.text?.count != 10 {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please enter 10 digit mobile number.")
        } */else {
            createIncidents()
        }
    }
    
    @IBAction func accept(_ sender: Any) {
        if isAccept == 0 {
            imgAccept.image = #imageLiteral(resourceName: "checked")
            isAccept = 1
        } else {
            imgAccept.image = #imageLiteral(resourceName: "without-check")
            isAccept = 0
        }
    }
    @IBAction func goToTermsAndConditions(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        self.present(vc, animated: true, completion: nil)
    }
   @IBAction func myself(_ sender: Any) {
    
    if UserDefaults.standard.bool(forKey: kLogin) == true {
        let val = UserDefaults.standard.value(forKey: kLoginResponse) as! NSDictionary
        let name = val.value(forKey: "name") as! NSDictionary
        self.txtFirstName.text = name.value(forKey: "first") as? String
        self.txtFirstName.isUserInteractionEnabled = false
        self.txtLastname.text = name.value(forKey: "last") as? String
        self.txtLastname.isUserInteractionEnabled = false
        self.txtMobVictim.text = val.value(forKey: "mobile_number") as? String
        self.txtMobVictim.isUserInteractionEnabled = false
        self.txtAnnonymousName.text = val.value(forKey: "annonymous_name") as? String
        self.txtAnnonymousName.isUserInteractionEnabled = false
        self.txtEmail.text = val.value(forKey: "email") as? String
        self.txtEmail.isUserInteractionEnabled = false
        self.imgMyself.image = #imageLiteral(resourceName: "radio_filled")
        self.imgSomeOne.image = #imageLiteral(resourceName: "radio_unfilled")
        submittedBy = "Myself"
        
        
    } else {
        self.imgMyself.image = #imageLiteral(resourceName: "radio_filled")
        self.imgSomeOne.image = #imageLiteral(resourceName: "radio_unfilled")
        submittedBy = "Someone else"
    }
}
    @IBAction func someoneElse(_ sender: Any) {
        self.txtFirstName.isUserInteractionEnabled = true
        self.txtLastname.isUserInteractionEnabled = true
        self.txtMobVictim.isUserInteractionEnabled = true
        self.txtAnnonymousName.isUserInteractionEnabled = true
        self.txtEmail.isUserInteractionEnabled = true
        if UserDefaults.standard.bool(forKey: kLogin) == true {
        
            self.txtFirstName.text = ""
            self.txtLastname.text = ""
            self.txtMobVictim.text = ""
            self.txtAnnonymousName.text = ""
            self.txtEmail.text = ""
            self.imgSomeOne.image = #imageLiteral(resourceName: "radio_filled")
            self.imgMyself.image = #imageLiteral(resourceName: "radio_unfilled")
            submittedBy = "Someone else"
        } else {
            self.imgSomeOne.image = #imageLiteral(resourceName: "radio_filled")
            self.imgMyself.image = #imageLiteral(resourceName: "radio_unfilled")
            submittedBy = "Someone else"
        }
    }
    @IBAction func deleteGallery(_ sender: Any) {
        let button = sender as? UIButton
        let cell = button?.superview?.superview as? UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell!)
        photoVideoImageArr.remove(at: (indexPath?.row)!)
        collectionView.reloadData()
    }
 }
