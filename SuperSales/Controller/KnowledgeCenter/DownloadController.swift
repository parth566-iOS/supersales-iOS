//
//  DownloadController.swift
//  SuperSales
//
//  Created by Apple on 20/01/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

protocol DownloadDelegate{
    func downloadcompeleted(url:URL,error:NSError)
}
class DownloadController: BaseViewController , URLSessionDelegate {
    var destinationPath:String!
    var fileUrl:String!
    var delegate:DownloadDelegate?
    var overlayView:UIView!
    var fileOfurl:NSURL!
    var downloadTask: URLSessionDownloadTask!
    fileprivate lazy var downloadsSession: URLSession = {
      let configuration = URLSessionConfiguration.default
        return Foundation.URLSession(configuration: configuration,delegate: self, delegateQueue: .main)
        
       
      //  return Foundation.URLSession(configuration: configuration,delegate: self, delegateQueue: .main)
            /*URLSession(configuration: configuration,
                        delegate: self,
                        delegateQueue: .main)*/
    }()
//    override init() {
//
//    }
   // var backgroundSession: URLSession!
    //fileOfurl
    //MARK: - IBOutlet
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overlayView = UIView.init(frame: CGRect.init(x: 0, y: -20, width: self.view.frame.size.width, height: 64))
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.5
        self.navigationController?.navigationBar.addSubview(overlayView)
        let transform = CGAffineTransform.init(scaleX: 1.0, y: 3.0)
        progressView.transform = transform
        self.showAnimate()
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Method
    func showAnimate(){
        self.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
         //   Alamofire.download
            //NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("mypictostore", ofType: "png")!)
            self.fileOfurl = URL.init(string: self.fileUrl) as NSURL? ?? NSURL.init(string: "")
            self.downloadFileWithUrl(urlString:self.fileOfurl as URL){
                (process, result) in
               
                self.progressView.setProgress(process ?? 0.00, animated: true)
            } 
        } completion: { (status) in
            print("process done \(status)")
        }

        
    }

    func setLoaderProgress(number:NSNumber){
        progressView.setProgress(number.floatValue, animated: true)
    }
    
    func removerAnimate(){
        UIView.animateKeyframes(withDuration: 0.25, delay: 0.1, options: UIView.KeyframeAnimationOptions.beginFromCurrentState) {
            DispatchQueue.main.async {
                self.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                self.view.alpha = 0.0
            }
           
            
            
        } completion: { (status) in
            if(status){
                DispatchQueue.main.async {
                self.view.removeFromSuperview()
                }
            }
        }

    }
    func closePopUp(){
        DispatchQueue.main.async{
            if let view = self.overlayView as? UIView{
            self.overlayView.removeFromSuperview()
            }
        }
        overlayView = nil
        self.removerAnimate()
    }
    
    
    func downloadFileWithUrl(urlString: URL, completion: @escaping ((_ progress: Float?,_ filePath: String?) -> Void)) {
        //    let sizeLimit = defaults.integer(forKey: DefaultKeys.SizeLimitChanged.rawValue)
        let sizeLimit = 2048
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                // path to documents directory
                let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                if let documentDirectoryPath = documentDirectoryPath {
                    // create the custom folder path
                    let provakilDirectoryPath = documentDirectoryPath.appending("")
                    let fileManager = FileManager.default
                    if !fileManager.fileExists(atPath: provakilDirectoryPath) {
                        do {
                            try fileManager.createDirectory(atPath: provakilDirectoryPath,
                                                            withIntermediateDirectories: false,
                                                            attributes: [FileAttributeKey.protectionKey: FileProtectionType.completeUnlessOpen])
                        } catch {
                            print("Error creating images folder in documents dir: \(error)")
                        }
                    }
                }
                
                let documentsURL:NSURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
                
                var fileUrl: URL? = nil
                if let provakilDocUrl = documentsURL.appendingPathComponent("SuperSales/Document") {
                    fileUrl = provakilDocUrl.appendingPathComponent(urlString.lastPathComponent)
                }
                return (fileUrl!,[.removePreviousFile, .createIntermediateDirectories])
            }
//            let header = CommonUtils().getRequestHeaders()
//            AFManager.sharedInstance.manager?.download(urlString, headers: header, to: destination).downloadProgress(closure: { (prog) in
  //      Alamofire.download(urlString, method: .get, parameters: nil, encoding: Unicode.UTF8.self as! ParameterEncoding, headers: nil, to: destination).downloadProgress(closure: { (prog) in
        Alamofire.download(urlString, to: destination).downloadProgress(closure: { (prog) in
                completion(Float(prog.fractionCompleted),nil)
            }).response { response in
                
                if response.error == nil, let filePath = response.destinationURL?.path, let contentLength = response.response?.expectedContentLength {
                    let newContentLength = contentLength / 1024 / 612
                    if newContentLength < sizeLimit {
                       completion(nil, "\(filePath)")
                        let obj = UIDocumentInteractionController.init(url: (response.destinationURL! ?? URL.init(string: ""))!)
                        print("url for open document = \(filePath)")
                        self.closePopUp()
                        obj.delegate = self
                        
                        obj.presentPreview(animated: true)
                    }else{
                    completion(nil, "")
                    }
                }
            }
        }
    
 /*   func loadURLWithAlamofire(urlOfDoc:NSURL){
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                   let datapath = documentsUrl?.appendingPathComponent("SuperSales/Document")
                  let destinationUrl = datapath?.appendingPathComponent(urlOfDoc.lastPathComponent ?? "")
// let response = HTTPURLResponse.init()
// let downloadoption  =
//        let taskOfDownloadFile = Alamofire.download(urlOfDoc as! URLRequestConvertible) { (url, httpurlresponse) -> (destinationURL: destinationUrl, options: .) in
//            return(destinationUrl,.createIntermediateDirectories)
//        }
//        var taskOfDownloadFile = Alamofire.download(urlOfDoc as! URLRequestConvertible) { (destinationUrl, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
//            print(response)
//        }
      //  let request = Alamofire.URLRequestConvertible
        let taskOfDownloadFile = Alamofire.download(urlOfDoc.absoluteURL as! URLRequestConvertible)
        taskOfDownloadFile.response(queue: DispatchQueue?.init(.main)) { (response) in
            
        }
        taskOfDownloadFile.resume()
            //Alamofire.download(urlOfDoc as! URLRequestConvertible)
     //   taskOfDownloadFile.DownloadFileDestination =
        //let downloadfiledestination =
        taskOfDownloadFile.downloadProgress(queue: DispatchQueue.main) { (progress) in
            if #available(iOS 11.0, *) {
                print(progress.fileCompletedCount ?? 0)
            } else {
                // Fallback on earlier versions
                print(progress.fractionCompleted)
            }
        }
        
        taskOfDownloadFile.response { (response) in
            print(response)
            print("url of doc = \(response.destinationURL as? URL ?? URL.init(string: ""))")
//            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//            let datapath = documentsUrl?.appendingPathComponent("SuperSales/Document")
//            let destinationUrl = datapath?.appendingPathComponent(urlOfDoc.lastPathComponent ?? "")
//            response.destinationURL = destinationUrl
        }
    }
    */
    func load(URLofdoc: NSURL) {
       // let config = URLSessionConfiguration.default
//        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
//        let delegatequeue = OperationQueue.main
//        let session = Foundation.URLSession.self
     /*   let backgroundSession =
            Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: delegatequeue)
          */  //Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.mainQueue)
   //     Foundation.URLSession.init(configuration: backgroundSessionConfiguration)
        
            //
//        backgroundSession.delegate = self
//        backgroundSession.delegateQueue = .main
            //Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        progressView.setProgress(0.0, animated: false)
       // let url = URL(string: "http://publications.gbdirect.co.uk/c_book/thecbook.pdf")!
        downloadTask = downloadsSession.downloadTask(with: URLofdoc as URL)
        downloadTask.resume()
//        manager.download(URLofdoc) { (url, response) -> (destinationURL: URL, options: .DownloadOptions) in
//            print(url)
//                      print(response)
//        }
////        manager.download(URLofdoc, method: .get, parameters: nil, encoding: nil, headers: nil) { (url, response) -> (destinationURL: URL, options: .DownloadOptions) in
//            print(url)
//            print(response)
//        }
    }
    
  func load1(URLofdoc: NSURL) {
        let sessionConfig = URLSessionConfiguration.default
      //  let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URLofdoc as URL)
        request.httpMethod = "GET"
    let urldestinationpath = URL.init(string: self.destinationPath)
    
   
    //Create URL to the source file you want to download
    let session = Foundation.URLSession(configuration: sessionConfig)
  //  let request = URLRequest(url:URLofdoc!)
    // URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
//    guard let location = location, error == nil else { return }
//    do {
//        // after downloading your file you need to move it to your destination url
//        try FileManager.default.moveItem(at: location, to: destinationUrl)
    let task = session.downloadTask(with: request as URLRequest) { (tempLocalUrl, response, error) in
       
        if let tempLocalUrl = tempLocalUrl, error == nil {
            // Success
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                print("Successfully downloaded. Status code: \(statusCode) , on path = \(tempLocalUrl) with error = \(error?.localizedDescription)")
            }
            
            do {
                
               /* try FileManager.default.copyItem(at: tempLocalUrl, to: urldestinationpath!)
                do {
                    //Show UIActivityViewController to save the downloaded file
                    let contents  = try FileManager.default.contentsOfDirectory(at: URLofdoc as URL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                    for indexx in 0..<contents.count {
                        if contents[indexx].lastPathComponent == urldestinationpath?.lastPathComponent {
                            let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                            self.present(activityViewController, animated: true, completion: nil)
                        }
                    }
                }
                catch (let err) {
                    print("error: \(err)")
                 
                 var documentsDirectoryURL  =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                 documentsDirectoryURL =   documentsDirectoryURL.appendingPathComponent("SuperSales/Document")
                 
                 var documentsDirectoryURL  =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                 documentsDirectoryURL =   documentsDirectoryURL.appendingPathComponent("SuperSales/Document")
                 // lets create your destination file url
                 let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl?.lastPathComponent ?? "")
                }*/
                let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                let datapath = documentsUrl?.appendingPathComponent("SuperSales/Document")
                if let destinationUrl = datapath?.appendingPathComponent(URLofdoc.lastPathComponent ?? ""){
                    //documentsUrl!.URLByAppendingPathComponent(URLofdoc.lastPathComponent!)
             //       print("here should move = \(destinationUrl) , document url = \(URLofdoc.lastPathComponent)")
               // let dataFromURL = NSData(contentsOf: destinationUrl)
//                dataFromURL?.writeToURL(destinationUrl ?? , atomically: true)
                try FileManager.default.moveItem(at:tempLocalUrl , to: destinationUrl)
                //fun writeToFile(_ path: String, atomically useAuxiliaryFile: Bool, encoding enc: UInt) throws or func writeToURL(_ url: NSURL, atomically useAuxiliaryFile: Bool, encoding enc: UInt) throws
                   // try dataFromURL?.write(to: destinationUrl, options: NSData.WritingOptions.atomicWrite)
                    do{
                        let filesize =  try FileManager.default.attributesOfItem(atPath: destinationUrl.absoluteString)
                        print("file size = \(filesize)")
                    }catch(let error){
                        print("error of file \(error.localizedDescription) , for url = \(destinationUrl)")
                    }
                    let obj = UIDocumentInteractionController.init(url: destinationUrl)
                    print("url for open document = \(destinationUrl)")
                    self.closePopUp()
                    obj.delegate = self
                    
                    obj.presentPreview(animated: true)
                } 
            } catch (let writeError) {
                print("Error creating a file \(urldestinationpath) : \(writeError) for url = \(self.fileOfurl)")
                Utils.toastmsg(message: writeError.localizedDescription, view: self.view)
                self.closePopUp()
            }
        } else {
            print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
        }
    }
    task.resume()
       /* let task = session.dataTask(with: request as URLRequest, completionHandler: { (data: Data!, response: URLResponse!, error: Error!) -> Void in
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("Success: \(statusCode)")
                    print("url = \(data)")
                    do{
                    let dic =   try JSONSerialization.jsonObject(with: data  , options: []) as? [[String:Any]]
                    print(dic)
                    }catch{
                        print(error.localizedDescription)
                        self.closePopUp()
                    }
                    do{
                    let dic1 =   try JSONSerialization.jsonObject(with: data  , options: []) as? [String:Any]
                    print(dic1)
                    }catch{
                        print(error.localizedDescription)
                        self.closePopUp()
                    }
                    do{
                    let dic2 =   try JSONSerialization.jsonObject(with: data  , options: []) as? String
                    print(dic2)
                    }catch{
                        print(error.localizedDescription)
                        self.closePopUp()
                    }
                    
                    // This is your file-variable:
                    // data
                }
                else {
                    // Failure
                    print("Failure: %@", error.localizedDescription);
                    self.closePopUp()
                }
            })
            task.resume()*/
        }
    
    
    func URLSession(session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // println("download task did write data")

        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            
        print("progress = \(progress)")
       // dispatch_async(dispatch_get_main_queue()) {
            self.progressView.progress = progress
        }
    }
    
    
    
    func urlSession(_ session: URLSession,
                        downloadTask: URLSessionDownloadTask,
                        didFinishDownloadingTo location: URL){
            
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    let documentDirectoryPath:String = path[0]
    let fileManager = FileManager()
    let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat("/file.pdf"))
            
    if fileManager.fileExists(atPath: destinationURLForFile.path){
         showFileWithPath(path: destinationURLForFile.path)
        }
    else{
          do {
               try fileManager.moveItem(at: location, to: destinationURLForFile)
               // show file
               showFileWithPath(path: destinationURLForFile.path)
          }catch{
               print("An error occurred while moving file to destination url")
          }
       }
    }
    // 2
    func urlSession(_ session: URLSession,
                   downloadTask: URLSessionDownloadTask,
                   didWriteData bytesWritten: Int64,
                   totalBytesWritten: Int64,
                   totalBytesExpectedToWrite: Int64){
       progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        }else{
            print("not found on path = \(path)")
        }
    }
}
extension DownloadController:UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerWillBeginPreview(_ controller: UIDocumentInteractionController) {
        print("preview should begin")
    }
    
}
