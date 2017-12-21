//
//  CollectionViewController.swift
//  Photo Phabulous
//
//  Created by Cynthia on 25/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO

private let reuseIdentifier = "cell"
let captureSession = AVCaptureSession()

class CollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var cameraButton: UIButton!
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
//    var popover:UIPopoverPresentationController?=nil
  
    @IBAction func imagePicker(_ sender: UIBarButtonItem) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.present(from: cameraButton.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        }
        
    }
//    @IBOutlet weak var cellImage: UIImageView!
    var objects = [Any]()
    var images_cache = [String:UIImage]()
    var images = [String]()
    let urlString = "http://stachesandglasses.appspot.com/user/default/json/"
//    let layout = UICollectionViewFlowLayout()
//    layout.scrollDirection = .Vertical
//    let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
//    
//    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//        layout.scrollDirection = .Vertical
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        self.present(picker!, animated: true, completion: nil)
        // Do any additional setup after loading the view.
        
//        let urlString = "http://stachesandglasses.appspot.com/user/default/json/"

        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
//        layout.itemSize = CGSizeMake(120,120)
        layout.itemSize = CGSize(width: 120, height: 120)
        
        self.collectionView?.setCollectionViewLayout(layout, animated: true)
        
//        get_json()
        get_image(url: urlString) { (arrayOfImage) in

            // Reload the table.  The tables data source should be the property you copied the
            // issues to (above). Remember to refresh the table on the main thread
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
    
        // Configure the cell
//        let image = cell.viewWithTag(1) as! UIImageView
//        image.image = objects[indexPath.row] as! UIImage
        let image = cell.cellImage as UIImageView
        if (images_cache[images[indexPath.row]] != nil)
        {
//            print("here")
            image.image = images_cache[images[indexPath.row]]
        }
        else
        {
//            print("there")
            load_image(urlString: images[indexPath.row], imageview:image)
        }
        
        return cell
    }
    
    func showAlert() {
        
        let title: String
        let message: String
        title = "Can't open.Try again later"
        message = "There might be some problem on the connection."
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    /// attribute: http://www.kaleidosblog.com/uicollectionview-image-gallery-download-and-display-images-inside-the-cell
    func load_image(urlString:String, imageview:UIImageView)
    {
        
        let url:NSURL = NSURL(string: urlString)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url as URL)
        request.timeoutInterval = 10
        
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
                
                return
            }
            
            
            var image = UIImage(data: data!)
//            image = self.resize(image: image!, newWidth:100)
            
            if (image != nil)
            {
                
                
                func set_image()
                {
                    self.images_cache[urlString] = image
                    imageview.image = image
                }
                
                DispatchQueue.main.async{
                    set_image()
                }
//                DispatchQueue.main.asynchronously(execute: set_image)
                
            }
            
        }
        
        task.resume()
        
    }
//
//    
//    
//    
//    func extract_json_data(data:NSString)
//    {
//        let jsonData:NSData = data.data(using: String.Encoding.ascii.rawValue)! as NSData
//        let json: Any
//        
//        do
//        {
//            json = try JSONSerialization.jsonObject(with: jsonData as Data, options: [])
//        }
//        catch
//        {
//            print("error")
//            return
//        }
//        guard let results = json as? [String: AnyObject] else {
//            //                    //                    fatalError("We couldn't cast the JSON to a dictionary")
//            self.showAlert()
//            return
//        }
//        let arrayOfImage = results["results"] as? [[String: AnyObject]]
//            //
//            //                //        let request: NSURLRequest = NSURLRequest(url: url as URL)
//            //                //        NSURLConnection.sendAsynchronousRequest(
//            //                //            request as URLRequest, queue: OperationQueue.main,
//            //                //            completionHandler: {(data, response, error) -> Void in
//            //                //                if error == nil {
//            //                //                    self.image_element.image = UIImage(data: data)
//            //                //                }
//            //                //        })
//            //                // parse json
//        
//        for imageInfo in arrayOfImage! {
//            //
//            let url = imageInfo["image_url"] as? String
////            let urlstring = URL(string: url!)
////            let data = try? Data(contentsOf: urlstring!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
////            let image = UIImage(data: data!)
//            ////                    image.image = UIImage(data: data!)
//            ////                    self.cellImage.image = UIImage(data: data!)
//            //                    if(image != nil) {
//            //                         self.objects.append(image!)
//            //                    }
//            //                   
//            //                }
//             images.append(url!)
//        }
////        guard let images_array = json as? NSArray else
////        {
////            print("error")
////            return
////        }
//        
//        
////        for j in 0 ..< images_array.count
////        {
////            images.append(image as! String as AnyObject)
////        }
//        
////        dispatch_get_main_queue().asynchronously(execute: refresh)
//        DispatchQueue.main.async{
//            self.refresh()
//        }
//    }
//    
//    
//    
//    func refresh()
//    {
//        self.collectionView?.reloadData()
//    }
//    
//    
//    func get_json()
//    {
//        
//        let url:NSURL = NSURL(string: urlString)!
//        let session = URLSession.shared
//        
//        let request = NSMutableURLRequest(url: url as URL)
//        request.timeoutInterval = 10
//        
//        
//        let task = session.dataTask(with: request as URLRequest) {
//            (data, response, error) in
//            
//            guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
//                
//                return
//            }
//            
//            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            
//            self.extract_json_data(data: dataString!)
//            
//        }
//        
//        task.resume()
//        
//    }
    
    
    //: # Prototype function to retrieve JSON and pass the results to a completion block
    func get_image(url: String, completion:@escaping ([[String: AnyObject]]?) -> Void) {
        
//        objects.removeAll()
//        print(url)
        // Transform the `url` parameter argument to a `URL`
//        guard let url = NSURL(string: url) else {
//        guard let url:NSURL = NSURL(string: url) else {
        guard let url = URL(string: urlString) else {
            //            fatalError("Unable to create NSURL from string")
            self.showAlert()
            return
        }
        
        // Create a vanilla url session
        let session = URLSession.shared

        
        // Create a data task
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
            
            // Print out the response (for debugging purpose)
            //            print("Response: \(response)")
            
            // Ensure there were no errors returned from the request
            guard error == nil else {
                //                fatalError("Error: \(error!.localizedDescription)")
                self.showAlert()
                return
            }
            
            // Ensure there is data and unwrap it
            guard let data = data else {
                //                fatalError("Data is nil")
                self.showAlert()
                return
            }
            
            // We received raw data, print it out for debugging
            // It needs to be converted to JSON
            //            print("Raw data: \(data)")
            
            // Serialize the raw data into JSON using `NSJSONSerialization`.  The "do-let" is
            // part of
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //                print(json)
                
                // Cast JSON as an array of dictionaries
                guard let results = json as? [String: AnyObject] else {
                    //                    fatalError("We couldn't cast the JSON to a dictionary")
                    self.showAlert()
                    return
                }
                let arrayOfImage = results["results"] as? [[String: AnyObject]]
                
                //        let request: NSURLRequest = NSURLRequest(url: url as URL)
                //        NSURLConnection.sendAsynchronousRequest(
                //            request as URLRequest, queue: OperationQueue.main,
                //            completionHandler: {(data, response, error) -> Void in
                //                if error == nil {
                //                    self.image_element.image = UIImage(data: data)
                //                }
                //        })
                // parse json
                for json in arrayOfImage! {
                    
                    var url = json["image_url"] as? String
                    
                    if (url != nil) {
//                    let urlstring = URL(string: url!)
//                    let data = try? Data(contentsOf: urlstring!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//                    let image = UIImage(data: data!)
//                    image.image = UIImage(data: data!)
//                    self.cellImage.image = UIImage(data: data!)
//                    if(image != nil) {
                        url = "http://stachesandglasses.appspot.com/" + url!
                        print(url as Any)
                        self.images.append(url!)
                    }
                   
                }
                // Call the completion block closure and pass the issues array of dictionaries as the argument to the
                // completion block.  This means that the code executed as part of the
                // completion block will have access to the `issues` data
                completion(arrayOfImage)
                
                
            } catch {
                print("error serializing JSON: \(error)")
                self.showAlert()
                return
            }
        })
        
        // Tasks start off in suspended state, we need to kick it off
        task.resume()
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    func resize(image: UIImage, newWidth: CGFloat) ->UIImage {
//        let size = __CGSizeApplyAffineTransform(image.size, CGAffineTransform(scaleX: scale, y: scale))
//        let hasAlpha = true
//        let scale: CGFloat = 0.0
//        
//        UIGraphicsBeginImageContent(size, !hasAlpha, scale)
//        image.draw(in: CGRect(origin: CGPoint.zero, size:size))
//        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return scaledImage!
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
//        let newHeight = newWidth
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        image.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /// attribute: http://www.theappguruz.com/blog/user-interaction-camera-using-uiimagepickercontroller-swift
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
//        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
//        imageView.contentMode = .scaleAspectFit //3
//        imageView.image = chosenImage //4
        picker.dismiss(animated: true, completion: nil)
//        imageView.image=info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        print("picker cancel.")
    }
    
    func openCamera()
    {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
//            picker!.sourceType = UIImagePickerControllerSourceType.camera
//            self .present(picker!, animated: true, completion: nil)
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            noCamera()
        }
    }
    func openGallary()
    {
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
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.present(from: cameraButton.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
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
   
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//        imagePicked.image = image
//        self.dismiss(animated: true, completion: nil);
//    }
}
