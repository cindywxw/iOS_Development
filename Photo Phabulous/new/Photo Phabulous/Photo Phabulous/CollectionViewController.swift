//
//  CollectionViewController.swift
//  Photo Phabulous
//
//  Created by Cynthia on 25/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import ImageIO

private let reuseIdentifier = "cell"
let captureSession = AVCaptureSession()

class CollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let images_cache = NSCache<AnyObject, UIImage>.sharedInstance

    
    @IBOutlet weak var cameraButton: UIButton!
    var picker:UIImagePickerController?=UIImagePickerController()

    /// attribute: https://developer.apple.com/reference/uikit/uiviewcontroller#//apple_ref/c/tdef/UIModalPresentationStyle
    @IBAction func imagePicker(_ sender: UIBarButtonItem) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default){
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){
            UIAlertAction in
        }
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.present(alert, animated: true, completion: nil)
        } else {
            if let popoverController = alert.popoverPresentationController {
                popoverController.barButtonItem = sender
            }
            self.present(alert, animated:true, completion:nil)
        }
        
    }
    var displayArray = [UIImage]()
    var images = [String]()
    let urlString = "http://stachesandglasses.appspot.com/user/cindywen/json/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let screenSize: CGRect = UIScreen.main.bounds
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.itemSize = CGSizeMake(120,120)
        layout.itemSize = CGSize(width: screenSize.width/3.2, height: screenSize.width/3.2)
        self.collectionView?.setCollectionViewLayout(layout, animated: true)
        
        if let savedData = AppFileManager.sharedInstance.getCoreFile() {
            guard let json = (try? JSONSerialization.jsonObject(with:savedData, options: .allowFragments)) as? [String : AnyObject] else {
                    print("Error Serialization Json")
                self.showAlert("JSON Casting")
                    return
            }
            let arrayOfImage = json["results"] as? [[String: AnyObject]]
            // parse json
            for json in arrayOfImage! {
                
                var url = json["image_url"] as? String
                
                if (url != nil) {
                    url = "http://stachesandglasses.appspot.com/" + url!
                    // print(url as Any)
                    if (self.images.contains(url!) == false) {
                        self.images.append(url!)
                    }
//                    load_image(urlString: url, imageview:image)
                }
            }
            
        }
        
        SharedNetworking.sharedInstance.get_image(url: urlString) { (returnedImages) in

            guard returnedImages != nil else {
                self.showAlert("Network Connection")
                return
            }
//            self.images = returnedImages!
            for item in returnedImages! {
                if (self.images.contains(item) == false) {
//                    self.images.insert(item, at: 0)
                     self.images.append(item)
                }
            }
            DispatchQueue.main.async {
                // Anything in here is execute on the main thread
                // You should reload your table here.
                //tableView.reload()
                self.collectionView?.reloadData()
            }
        }
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        picker?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)

    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showImage" {
            let cell = sender as! CollectionViewCell
            if let indexPath = self.collectionView?.indexPath(for: cell) {
                let controller:ImageDetailViewController = segue.destination as! ImageDetailViewController
                controller.image = images_cache.object(forKey: self.images[indexPath.row] as AnyObject)!
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print(self.images.count)
        return self.images.count
    }

    /// attribute: http://www.kaleidosblog.com/uicollectionview-image-gallery-download-and-display-images-inside-the-cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
    
        // Configure the cell
        let image = cell.cellImage as UIImageView

        if (images_cache.object(forKey: self.images[indexPath.row] as AnyObject) != nil) {
            image.image = images_cache.object(forKey: self.images[indexPath.row] as AnyObject)

        } else {
            load_image(urlString: self.images[indexPath.row], imageview:image)
        }
        
        return cell
    }
    
    func showAlert(_ errorMessage: String) {
        
        let title: String
        let message: String
        title = "Error in \(errorMessage)"
        message = "Please try again later"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    /// attribute: http://www.kaleidosblog.com/uicollectionview-image-gallery-download-and-display-images-inside-the-cell
    func load_image(urlString:String, imageview:UIImageView) {
        
        var imageArray = images
        let url:NSURL = NSURL(string: urlString)!
        let session = URLSession.shared
    
        let request = NSMutableURLRequest(url: url as URL)
        request.timeoutInterval = 10
        
//        print("urlString is: \(urlString)")
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
                self.showAlert((error?.localizedDescription)!)
                return
            }
            
            var image = UIImage(data: data!)
            
            if (image != nil) {
                func set_image() {
                    if (self.images_cache.object(forKey: urlString as AnyObject) == nil) {
                        self.images_cache.setObject(image!,forKey: urlString as AnyObject)
//                        print("added to cache")

                    }
                    
                    imageview.image = image
                    if(self.images.contains(urlString) == false) {
                        print("load image set: \(urlString)")
                        self.images.append(urlString)
//                        self.images.insert(urlString, at: 0)
                    }
                }
                
                DispatchQueue.main.async{
                    set_image()
                }
            }
        }
        task.resume()

    }

    
    /// attribute: http://www.theappguruz.com/blog/user-interaction-camera-using-uiimagepickercontroller-swift
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {

            SharedNetworking.sharedInstance.uploadRequest(user: "cindywen", image: chosenImage, caption: "photo") { (returnedImages) in
                print("image uploaded")
                
                let alert = UIAlertController(title: "Image uploaded", message: "Thank you for uploading", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                guard let returnedImages = returnedImages else {
                    self.showAlert("Network Connection")
                    return
                }
                self.images = returnedImages
                for item in self.images {
                    if (self.images_cache.object(forKey: item as AnyObject) == nil) {
                        self.images_cache.setObject(chosenImage,forKey: item as AnyObject)
                    }

                }
                DispatchQueue.main.async {
                    // Anything in here is execute on the main thread
                    // You should reload your table here.
                    self.collectionView?.reloadData()
                }
            }
            
        
        } else if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {

            SharedNetworking.sharedInstance.uploadRequest(user: "cindywen", image: chosenImage, caption: "photo") { (returnedImages) in
                print("image uploaded")
                
                let alert = UIAlertController(title: "Image uploaded", message: "Thank you for uploading", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                guard let returnedImages = returnedImages else {
                    self.showAlert("Network Connection")
                    return
                }
                self.images = returnedImages
                for item in self.images {
                    if (self.images_cache.object(forKey: item as AnyObject) == nil) {
                        self.images_cache.setObject(chosenImage,forKey: item as AnyObject)
                    }
                    
                }
                DispatchQueue.main.async {
                    // Anything in here is execute on the main thread
                    // You should reload your table here.
                    self.collectionView?.reloadData()
                }
            }

            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    func openGallary() {
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            if picker?.popoverPresentationController != nil{
            }
            self.present(picker!, animated:true, completion:nil)
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
}

extension NSCache {
    class var sharedInstance : NSCache<AnyObject, UIImage>
    {
        let cache = NSCache<AnyObject, UIImage>()
        return cache
    }
}

