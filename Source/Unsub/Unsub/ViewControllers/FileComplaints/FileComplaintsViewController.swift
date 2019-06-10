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
class FileComplaintsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastname: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCategory: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCrimeDetail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtDatetime: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAddress: SkyFloatingLabelTextField!
    
    
    let picker = UIImagePickerController()
    var videoURL = NSURL()
    var imageURL = NSURL()
    var imgData = Data()
    var imgVideoUrls = [URL]()
    var categoriesArr = [Categories]()
    let pickerCategories:UIPickerView = UIPickerView()
    var selectedTextField:UITextField!
    var catName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        self.title = "File Complaint"
        getCategories()
    }
    
    //MARK:- Server Requests
    func getCategories() {
        Loader.shared.show()
        NetworkManager.sharedInstance.apiParseGet(url: WEB_URL.categories, completion: {(response: NSDictionary?) in
            Loader.shared.hide()
            print(response!)
            if let cat = [Categories].from(jsonArray: response?.value(forKey: "data") as! [JSON]) {
                self.categoriesArr = cat
            }
        })
    }
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        createStockPicker(txtCategory)
        return true
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
    }
    @objc func pickerDone(){
        txtCategory.text = catName
        self.view.endEditing(true)
    }
    @objc func pickerCancel(){
        self.view.endEditing(true)
    }
    //MARK:- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageVideoCollectionCell", for: indexPath)
        let imgView : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        imgView.image = #imageLiteral(resourceName: "bg-top")
        return cell
    }
    //MARK:- UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print(info)
        if picker.sourceType == .photoLibrary {
            if let mediaType = info[UIImagePickerControllerMediaType] as? String {
                if mediaType  == "public.image" {
                    print("Image Selected")
                    imageURL = (info["UIImagePickerControllerImageURL"] as? NSURL)!
                  //  NetworkManager.sharedInstance.uploadVideo(videoFileUrl: videoURL as URL, isVideo: false, imageUrl: imageURL as URL, isCamera: false, imageData: imgData as NSData, filePath: fileURL as URL, isFile: false)
                }
                if mediaType == "public.movie" {
                    print("Video Selected")
                    videoURL = (info["UIImagePickerControllerMediaURL"] as? NSURL)!
                  //  NetworkManager.sharedInstance.uploadVideo(videoFileUrl: videoURL as URL, isVideo: true, imageUrl: imageURL as URL, isCamera: false, imageData: imgData as NSData, filePath: fileURL as URL, isFile: false)
                }
            }
            
        } else if picker.sourceType == .camera {
            if let mediaType = info[UIImagePickerControllerMediaType] as? String {
                if mediaType  == "public.image" {
                    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                    imgData = UIImagePNGRepresentation(image)!
                  //  NetworkManager.sharedInstance.uploadVideo(videoFileUrl: videoURL as URL, isVideo: false, imageUrl: imageURL as URL, isCamera: true, imageData: imgData as NSData, filePath: fileURL as URL, isFile: false)
                }
                if mediaType == "public.movie" {
                    videoURL = (info["UIImagePickerControllerMediaURL"] as? NSURL)!
                   // NetworkManager.sharedInstance.uploadVideo(videoFileUrl: videoURL as URL, isVideo: true, imageUrl: imageURL as URL, isCamera: true, imageData: imgData as NSData, filePath: fileURL as URL, isFile: false)
                }
            }
        }
        dismiss(animated: true,completion: nil)
     }
    
    //MARK:- UIButtonActions
    @IBAction func chooseMedia(_ sender: Any) {
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
            print("Gallery Action pressed")
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    
    @IBAction func submit(_ sender: Any) {
        
    }
    
}
