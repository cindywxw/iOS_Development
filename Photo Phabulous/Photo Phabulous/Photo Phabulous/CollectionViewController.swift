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
//    let myNetwork = SharedNetworking()
//    myNetwork().sharedInstance.createDirectory()
    
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
//    var images_cache = [String:UIImage]()
    var images = [String]()
    let urlString = "http://stachesandglasses.appspot.com/user/cindywen/json/"
    
//    enum networkError: Error {
//        case Connection
//        case Request
//        case Parsing
//        case JOSNCasting
//        case Data
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
            
//            self.loadImages()
        }
        
        SharedNetworking.sharedInstance.get_image(url: urlString) { (returnedImages) in

            guard returnedImages != nil else {
                self.showAlert("Network Connection")
                return
            }
            self.images = returnedImages!
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
                controller.image = images_cache.object(forKey: images[indexPath.row] as AnyObject)!
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
        print(images.count)
        return images.count
    }

    /// attribute: http://www.kaleidosblog.com/uicollectionview-image-gallery-download-and-display-images-inside-the-cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
    
        // Configure the cell
        let image = cell.cellImage as UIImageView

        if (images_cache.object(forKey: images[indexPath.row] as AnyObject) != nil) {
            image.image = images_cache.object(forKey: images[indexPath.row] as AnyObject)
            print("from cache")
//            print(images[indexPath.row])
        }
        else
        {
            print("from server")
//            print("index is: \(images[indexPath.row])")
            load_image(urlString: images[indexPath.row], imageview:image)
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
        
//        do {
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
                        print("added to cache")

                    }
                    
                    imageview.image = image
                    if(self.images.contains(urlString) == false) {
                        print("load image set: \(urlString)")
                        self.images.append(urlString)
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
                    // Reload the table.  The tables data source should be the property you copied the
                    // issues to (above). Remember to refresh the table on the main thread
                    DispatchQueue.main.async {
                        // Anything in here is execute on the main thread
                        // You should reload your table here.
                        //tableView.reload()
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
                // Reload the table.  The tables data source should be the property you copied the
                // issues to (above). Remember to refresh the table on the main thread
                DispatchQueue.main.async {
                    // Anything in here is execute on the main thread
                    // You should reload your table here.
                    //tableView.reload()
                    self.collectionView?.reloadData()
                }
            }

            
        }
        self.dismiss(animated: true, completion: nil)
//        imageView.image=info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
//            picker!.sourceType = UIImagePickerControllerSourceType.camera
//            self .present(picker!, animated: true, completion: nil)
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
//        if UIDevice.current.userInterfaceIdiom == .phone
//        {
//            self.present(picker!, animated: true, completion: nil)
//        }
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(imagePicker, animated: true, completion: nil)
        } else {
//            popover=UIPopoverController(contentViewController: picker!)
//            popover!.present(from: cameraButton.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            if picker?.popoverPresentationController != nil{
//                popover?.barButtonItem = sender
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
    
    
    //: # Prototype function to retrieve JSON and pass the results to a completion block
    /*func get_image(url: String, completion:@escaping ([[String: AnyObject]]?) -> Void) {
     if (Reachability.isConnectedToNetwork() == false) {
     print("photo sharing corrupted.")
     let alert = UIAlertController(title: "Photo not shared", message: "Internet is not connected", preferredStyle: .alert)
     let action = UIAlertAction(title: "OK", style: .default, handler: nil)
     alert.addAction(action)
     self.present(alert, animated: true, completion: nil)
     return
     }
     images.removeAll()
     //        arrayInFile?.removeAllObjects()
     //        print(url)
     // Transform the `url` parameter argument to a `URL`
     guard let url = URL(string: urlString) else {
     //  fatalError("Unable to create NSURL from string")
     self.showAlert("parsing")
     return
     }
     
     // Create a vanilla url session
     let session = URLSession.shared
     
     
     // Create a data task
     let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
     
     
     // Print out the response (for debugging purpose)
     // print("Response: \(response)")
     
     // Ensure there were no errors returned from the request
     guard error == nil else {
     // fatalError("Error: \(error!.localizedDescription)")
     self.showAlert("request")
     return
     }
     
     // Ensure there is data and unwrap it
     guard let data = data else {
     // fatalError("Data is nil")
     self.showAlert("data")
     return
     }
     
     // We received raw data, print it out for debugging
     // It needs to be converted to JSON
     // print("Raw data: \(data)")
     
     // Serialize the raw data into JSON using `NSJSONSerialization`.  The "do-let" is
     // part of
     do {
     let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
     //                print(json)
     
     // Cast JSON as an array of dictionaries
     guard let results = json as? [String: AnyObject] else {
     // fatalError("We couldn't cast the JSON to a dictionary")
     self.showAlert("JSON casting")
     return
     }
     let arrayOfImage = results["results"] as? [[String: AnyObject]]
     //                let arrayInfile = arrayInFile
     // parse json
     for json in arrayOfImage! {
     
     var url = json["image_url"] as? String
     
     if (url != nil) {
     url = "http://stachesandglasses.appspot.com/" + url!
     //                        print(url as Any)
     //                        if (self.images.contains(url!) == false) {
     self.images.append(url!)
     //                        }
     //                        if(arrayInFile?.contains(url!) == false) {
     //                            arrayInFile?.add(url!)
     //                        }
     }
     
     }
     //                if (arrayInFile?.count != 0) {
     //                    arrayInFile?.removeAllObjects()
     //                }
     //                for i in self.images {
     //                    arrayInFile?.add(i)
     //                }
     //                arrayInFile?.write(toFile: filePath, atomically: true)
     // Call the completion block closure and pass the issues array of dictionaries as the argument to the
     // completion block.  This means that the code executed as part of the
     // completion block will have access to the `issues` data
     completion(arrayOfImage)
     
     
     } catch {
     print("error JSON: \(error)")
     self.showAlert("connection")
     return
     }
     })
     
     // Tasks start off in suspended state, we need to kick it off
     task.resume()
     }
     
     /// based on session7 playground
     func resize(image: UIImage, scale: CGFloat) -> UIImage {
     let size = image.size.applying(CGAffineTransform(scaleX: scale,y: scale))
     let hasAlpha = true
     
     // Automatically use scale factor of main screen
     let scale: CGFloat = 0.0
     
     UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
     image.draw(in: CGRect(origin: CGPoint.zero, size: size))
     let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
     UIGraphicsEndImageContext()
     return scaledImage!
     }
     
     //    func resize(image: UIImage, scale: CGFloat) ->UIImage {
     //        let scale = newWidth / image.size.width
     //        let newHeight = image.size.height * scale
     ////        let newHeight = newWidth
     //        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
     //        image.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
     //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
     //        UIGraphicsEndImageContext()
     //        return newImage!
     //    }*/
 
    /*func uploadRequest(user: NSString, image: UIImage, caption: NSString){
        if (Reachability.isConnectedToNetwork() == false) {
            print("photo sharing corrupted.")
            let alert = UIAlertController(title: "Photo not shared", message: "Internet is not connected", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let boundary = generateBoundaryString()
        let scaledImage = resize(image: image, scale: 0.1)
        let imageJPEGData = UIImageJPEGRepresentation(scaledImage,0.1)
        
        guard let imageData = imageJPEGData else {return}
        
        // Create the URL, the user should be unique
        let url = NSURL(string: "http://stachesandglasses.appspot.com/post/\(user)/")
        
        // Create the request
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Set the type of the data being sent
        let mimetype = "image/jpeg"
        // This is not necessary
        let fileName = "test.png"
        
        // Create data for the body
        let body = NSMutableData()
        body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        
        // Caption data
        body.append("Content-Disposition:form-data; name=\"caption\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("CaptionText\r\n".data(using: String.Encoding.utf8)!)
        
        // Image data
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"image\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        // Trailing boundary
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        // Set the body in the request
        request.httpBody = body as Data
        
        // Create a data task
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            // Need more robust errory handling here
            // 200 response is successful post
//            print(response!)
//            print(error!)
            if (error != nil) {
                print(error as Any)
                self.showAlert("upload")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                //                print(json)
                
                // Cast JSON as an array of dictionaries
                guard let results = json as? [String: AnyObject] else {
                    // fatalError("We couldn't cast the JSON to a dictionary")
                    self.showAlert("JSON casting")
                    return
                }
                let arrayOfImage = results["results"] as? [[String: AnyObject]]
                
                // parse json
                var recent = arrayOfImage?[0]
                var url = recent?["image_url"] as? String
                if (url != nil) {
                    url = "http://stachesandglasses.appspot.com/" + url!
//                    print(url as Any)
                    self.images.append(url!)
                    self.images_cache.setObject(image,forKey: url! as AnyObject)
//                    arrayInFile?.insert(url!, at: 0)
//                    arrayInFile?.write(toFile: filePath, atomically: true)
                }
                
            } catch {
                print("error serializing JSON: \(error)")
                self.showAlert("connection")
                return
            }
            
            // The data returned is the update JSON list of all the images
//            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print(dataString!)
            
            let title: String
            let message: String
            title = "Image uploaded"
            message = "Thank you for uploading"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
//            DispatchQueue.main.async {
//                self.collectionView?.reloadData()
//            }
            self.get_image(url: "http://stachesandglasses.appspot.com/user/cindywen/json/") { (arrayOfImage) in
                
                // Reload the table.  The tables data source should be the property you copied the
                // issues to (above). Remember to refresh the table on the main thread
                DispatchQueue.main.async {
                    // Anything in here is execute on the main thread
                    // You should reload your table here.
                    //tableView.reload()
                    self.collectionView?.reloadData()
                }
            }
        }
        
        task.resume()
    }
    
    /// A unique string that signifies breaks in the posted data
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    /// attribute: https://iosdevcenters.blogspot.com/2016/04/save-and-get-image-from-document.html
//    func saveImageDocumentDirectory(url:String, image: UIImage){
//        let fileManager = FileManager.default
//        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(url)
////        let image = UIImage(named: "apple.jpg")
//        print(paths)
//        let imageData = UIImageJPEGRepresentation(image, 0.5)
//        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
//    }
//    
//    func getDirectoryPath() -> String {
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
//    
//    func getImage(url: String){
//        let fileManager = FileManager.default
//        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(url)
//        if fileManager.fileExists(atPath: imagePAth){
//            self.cellImage.image = UIImage(contentsOfFile: imagePAth)
//        }else{
//            print("No Image")
//        }
//    }*/

}

extension NSCache {
    class var sharedInstance : NSCache<AnyObject, UIImage>
    {
        let cache = NSCache<AnyObject, UIImage>()
        return cache
    }
}

