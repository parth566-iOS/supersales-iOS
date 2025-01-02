//
//  PromotionDetail.swift
//  SuperSales
//
//  Created by Apple on 12/06/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SVProgressHUD

protocol promotionDetailDelegate
{
    func updatePromotionData(arr:Array<Promotion>)->()
    func updateEntitlementData(arr:Array<Entitlement>)->()
}
@objc class PromotionDetail: BaseViewController {
     // swiftlint:disable line_length
    // swiftlint:disable function_body_length
   // swiftlint:disable file_length
    var delegateDetail: promotionDetailDelegate?
    @objc var selectedPromotionID:NSNumber! = nil
    var playerViewController:AVPlayerViewController!
    var actionStrUrl:String!
    let ktitleFont =  CGFloat(14)
    var ai:UIActivityIndicatorView?
    var btnPlay:UIButton = UIButton()
    var URLAudio:URL!
    var webView = UIWebView()
    var newView:UIView! = UIView()
   // var imgView:UIView = UIView()
    var imgParentView:UIImageView = UIImageView()
    var isContentView:Bool!
    var visitType:VisitType!
    var inputFormatter:DateFormatter! = DateFormatter()
    var ArrContnetCaption:Array<String> = Array()
    var ArrContnetURL:Array<String> = Array()
    var getPromotionData:Array<Any> = Array()
    var ObjVisitForPromotionDetail:PlannVisit!
  //  var ObjUnPlanedVisitForPromotionDetail:UnplannedVisit!
    var selectedJustification:Justification!
    var ArrJustification:Array<Justification> = Array()
    var ArrTitle:Array<String> = Array()
    var player: AVAudioPlayer?
    let screenSize = UIScreen.main.bounds
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    var promotionDetail:Promotion!
    
    @IBOutlet weak var tblPromotionDetail: UITableView!
    @objc var promotionData:Array<Promotion>! = nil
    var pickerForJustification:UIPickerView!
    var promotiondetailtoolBar:UIToolbar! =  UIToolbar()
    
    @IBOutlet weak var btnJoin: UIButton!
    
    @IBOutlet weak var btnNotJoin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getJustificationList()
        
        promotionDetail = promotionData?[selectedPromotionID.intValue]
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        self.isContentView =  false
        self.checkContent()
       // self.getPromotionDataToDisplay()
        
        //Title of View
        self.title = promotionDetail.promotionTitle
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        
        //Title
//        ArrTitle = ["Start Date","End Date","TYPE"," "," ","Products",""]
       ArrTitle = self.getHeader()
        print (ArrTitle)
       
        //table style
        self.tblPromotionDetail.delegate = self
        self.tblPromotionDetail.dataSource = self
        self.tblPromotionDetail.tableFooterView = UIView()
        self.tblPromotionDetail.separatorColor = .clear
      
        self.tblPromotionDetail.estimatedRowHeight = 40
        self.tblPromotionDetail.rowHeight =  UITableView.automaticDimension
        DispatchQueue.main.async {
            self.tblPromotionDetail.reloadData()
        }
        //set UI
    
   //  self.showNavBar1()
     self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
     self.btnJoin.setTitle(NSLocalizedString("Promotion_Join", comment: ""), for: UIControl.State.normal)
//     self.btnJoin.backgroundColor = UIColor.Appskybluecolor//Common().UIColorFromRGB(rgbValue: 0x2A718E)
//     self.btnNotJoin.backgroundColor = UIColor.Appskybluecolor//Common().UIColorFromRGB(rgbValue: 0x2A718E)
     self.btnNotJoin.setTitle(NSLocalizedString("Promotion_Not_Join", comment: ""), for: UIControl.State.normal)
    self.pickerForJustification = UIPickerView(frame: CGRect.init(x: 0, y: self.view.frame.size.height-300, width: self.view.frame.size.width, height: 300))
    self.pickerForJustification.delegate = self
    self.pickerForJustification.dataSource = self
        self.pickerForJustification.backgroundColor = .white
    self.pickerForJustification.showsSelectionIndicator = true
        toolBar = UIToolbar()
        toolBar.frame = CGRect.init(x: 0, y: self.view.frame.size.height-300, width: self.view.frame.size.width, height: 50)
        toolBar.backgroundColor = .gray
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
            //UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
      //  let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action:  selector())
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(doneClick) )
            //UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.Style.plain, target: self, action:#Selector(doneClick))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelClick))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

       
        self.btnJoin.layer.cornerRadius = 10.0
        self.btnNotJoin.layer.cornerRadius = 10.0
        
        if(promotionDetail.status == 1 ){
            self.btnJoin.isHidden = true
            self.btnNotJoin.isHidden = true
        }
        else if (promotionDetail.status == 2){
           // self.btnNotJoin.isUserInteractionEnabled = false
            self.btnNotJoin.isEnabled = false
        }
        
        if ObjVisitForPromotionDetail == nil   {
            btnJoin.isHidden = true
            btnNotJoin.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    override  func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(true)
//        NSNotificationCenter.defaultCenter().addObserver(
//            self,
//            selector: #selector(updateData:),
//        name: UIDeviceBatteryLevelDidChangeNotification,
//        object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    override func viewDidDisappear(_  animated:Bool){
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    func getContnetCount()->Int{
        var i:Int = 0
        if(promotionDetail.contentURL1?.count ?? 0  > 4){
            ArrContnetCaption.append(promotionDetail.contentURL1Caption ?? " ")
            ArrContnetURL.append(promotionDetail.contentURL1 ?? " ")
            i = i + 1
        }
        if(promotionDetail.contentURL2?.count ?? 0  > 4){
             ArrContnetCaption.append(promotionDetail.contentURL2Caption ?? " ")
            ArrContnetURL.append(promotionDetail.contentURL2 ?? " ")
            i = i + 1
        }
        if(promotionDetail.contentURL3?.count ?? 0  > 4){
        ArrContnetCaption.append(promotionDetail.contentURL3Caption ?? " ")
            ArrContnetURL.append(promotionDetail.contentURL3 ?? " ")
            i = i + 1
        }
        return i
    }
    func getCountOfHeader() -> Int  {
        var  i = 0
        if(promotionDetail.startDate?.count ?? 0 > 0){
            i = i+1
        }
        if(promotionDetail.endDate?.count ?? 0 > 0){
            i = i+1
        }
        if(promotionDetail.promodescription?.count ?? 0 > 0){
            i = i+1
        }
        if(promotionDetail.promotionProductList.count > 0){
            i = i+1
        }
        if(promotionDetail.freeBonusProductList.count > 0){
            i = i+1
        }
        if(promotionDetail.flatPromotionSlabDetails.count > 0 ){
            i = i+1
        }
        if(promotionDetail.status == 1 || promotionDetail.status == 2){
            i = i+1
        }
        if(promotionDetail.status == 2){
            i = i + 1
        }
        
        return i
    }
    func getHeader() -> Array<String> {
        ArrTitle = Array()
        if(promotionDetail.startDate?.count ?? 0 > 0){
           ArrTitle.append("Start Date")
            getPromotionData.append(promotionDetail.startDate ?? "NO Date")
        }
        if(promotionDetail.endDate?.count ?? 0 > 0){
            ArrTitle.append("End Date")
            getPromotionData.append(promotionDetail.endDate ?? "NO ENd Date")
        }
        if(promotionDetail.promotionType == 1 || promotionDetail.promotionType == 2){
            ArrTitle.append("Type")
        }
        if(promotionDetail.promodescription?.count ?? 0 > 0){
            ArrTitle.append(" ")
            getPromotionData.append(promotionDetail.promodescription ?? "No Description")
        }
        
        
        if(getContnetCount()>0){
            ArrTitle.append(" ")
            getPromotionData.append(ArrContnetCaption)
        }

        if(promotionDetail.promotionProductList.count > 0){
            ArrTitle.append("Products")
            getPromotionData.append(promotionDetail.promotionProductList)
        }
       
        if(promotionDetail.freeBonusProductList.count > 0){
            ArrTitle.append("Bonus Product")
            getPromotionData.append(promotionDetail.freeBonusProductList)
        }
        if(promotionDetail.flatPromotionSlabDetails.count > 0){
            ArrTitle.append(" ")
            getPromotionData.append(promotionDetail.flatPromotionSlabDetails)
        }

        if(!(promotionDetail.status == 0)){
            ArrTitle.append("Status")
            getPromotionData.append(promotionDetail.status)
        }
        if(promotionDetail.status == 2){
            ArrTitle.append("Justification")
            getPromotionData.append(promotionDetail.justificationID)
        }
        if(promotionDetail.promotionType == 1){
            getPromotionData.append("Flat")
        }
        else if(promotionDetail.promotionType == 2){
            getPromotionData.append("Bonus")
        }
        return ArrTitle
    }
    
    func checkContent(){
        
        if(promotionDetail.contentURL1 != nil && promotionDetail.contentURL1!.count > 4 ){
            isContentView =  true
        }
        else  if(promotionDetail.contentURL2 != nil && promotionDetail.contentURL2!.count > 4 ){
            isContentView =  true
        }
        else  if(promotionDetail.contentURL3 != nil && promotionDetail.contentURL3!.count > 4 ){
            isContentView =  true
        }
        
    }
    
    func displayContnet(StrURL:String)  {
        if StrURL.count >= 3 {
           // let str = "."
            ai = UIActivityIndicatorView.init(style: .whiteLarge)
           // ai?.startAnimating()
           
            
            let arr = StrURL.components(separatedBy: ".")
            let lastExt = arr.last
            print(lastExt ?? "no")
            
            if(lastExt == "pdf" || lastExt == "png" || lastExt == "jpeg" || lastExt == "jpg" || lastExt == "mp3"  || lastExt == "gif" || lastExt == "mov" ){
                if(!(actionStrUrl == StrURL )){
                    imgParentView.image = nil
                    URLAudio =  nil
                }
                actionStrUrl = StrURL
                let btnClose = UIButton(type: UIButton.ButtonType.custom)
                btnClose.backgroundColor =  UIColor.black
                newView.backgroundColor = UIColor.black
               
                view.addSubview(newView)
                
               newView.addSubview(btnClose)
                
                let image = UIImage(named: "icon_close") as UIImage?
                btnClose.setImage(image, for: UIControl.State.normal)
                btnClose.addTarget(self, action: #selector(closeTapped), for: UIControl.Event.touchUpInside)
                
                newView.translatesAutoresizingMaskIntoConstraints = false
                btnClose.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 5).isActive = true
                NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 5).isActive = true
                NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: screenWidth-40).isActive = true
                NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant:screenHeight-120).isActive = true
                print(newView.frame)
                //btn close
                NSLayoutConstraint(item: btnClose, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -5).isActive = true
                NSLayoutConstraint(item: btnClose, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 5).isActive = true
                NSLayoutConstraint.init(item:btnClose ,attribute: .height , relatedBy: .equal , toItem:nil , attribute: .notAnAttribute , multiplier: 1.0 , constant : 40).isActive = true
                
                NSLayoutConstraint.init(item:btnClose ,attribute: .width , relatedBy: .equal , toItem:nil , attribute: .notAnAttribute , multiplier: 1.0 , constant : 40).isActive = true
                
                
                newView.addSubview(imgParentView)
                
                
                imgParentView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint(item:imgParentView , attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
                
                NSLayoutConstraint(item:imgParentView , attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
                
                NSLayoutConstraint(item: imgParentView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: imgParentView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: imgParentView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300).isActive = true
                
                ai?.center = CGPoint(x: screenWidth/2-10, y: newView.frame.origin.y + screenHeight/4)
                ai?.startAnimating()
                newView.addSubview(ai ?? UIActivityIndicatorView())
                if(lastExt == "pdf"){
                    //display PDF
                    imgParentView.isHidden = true
                     btnPlay.isHidden =  true
                    newView.addSubview(webView)
                  
                    webView.delegate = self
                    webView.translatesAutoresizingMaskIntoConstraints = false
                    newView.translatesAutoresizingMaskIntoConstraints = false
                   
                
                    let url: URL! = URL(string: StrURL)
                    webView.loadRequest(URLRequest(url: url))
                    newView.addSubview(webView)
                    NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem:newView , attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 50).isActive = true
                    NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -10).isActive = true
                    NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0).isActive = true
                    NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0).isActive = true
                    
                }
                else if(lastExt == "MOV" || lastExt == "mov" || lastExt == "mp4" ){
                    imgParentView.isHidden = true
                      btnPlay.isHidden =  true
                    //play video
                    let videoURL = URL(string: StrURL)
                    let player = AVPlayer(url: videoURL!)
                    playerViewController = AVPlayerViewController()
                  
                    playerViewController.player = player
                    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)

                    self.present(playerViewController, animated: true) {
                        DispatchQueue.main.async {
                            self.playerViewController.player!.play()
                            
                        }
                                }

                    
                }
                else if(lastExt == "png" || lastExt == "jpg" || lastExt == "jpeg" || lastExt == "gif" ){
                    //display image
                    imgParentView.isHidden = false
                      btnPlay.isHidden =  true
                    
                    
                    let catPictureURL = URL(string: StrURL)!
                    let session = URLSession(configuration: .default)
                    
                    // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
                    let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
                        // The download has finished.
                        if let e = error {
                            self.ai?.stopAnimating()
                            self.ai?.removeFromSuperview()
                            print("Error downloading cat picture: \(e)")
                        } else {
                            // No errors found.
                            // It would be weird if we didn't have a response, so check for that too.
                            DispatchQueue.main.async {
                               self.ai?.stopAnimating()
                                self.ai?.removeFromSuperview()
                            }
                            
                            if let res = response as? HTTPURLResponse {
                                print("Downloaded cat picture with response code \(res.statusCode)")
                                if let imageData = data {
                                    // Finally convert that Data into an image and do what you wish with it.
                                    var image = UIImage(data: imageData)
                                    print(image?.size ?? "N?1")
                                    
                                    DispatchQueue.main.async {
                                       // self.imgParentView.frame = self.imgView.frame
                                        if(image!.size.width > self.imgParentView.frame.size.width ){
                                            if(image!.size.height > self.imgParentView.frame.size.height){
                                                
                                                    image = Common.createImage(withImage: image ?? UIImage()
                                                        , forSize:  CGSize.init(width: self.newView.frame.size.width, height: self.newView.frame.size.height))
                                                 self.imgParentView.image = image
                                               // self.imgParentView.center = CGPoint(x: self.newView.center.x - 25, y: self.newView.center.y + 25 )
                                            }else{
                                                image = Common.createImage(withImage: image ?? UIImage()
                                                    , forSize:  CGSize.init(width: self.newView.frame.size.width, height: image!.size.height))
                                                
                                                self.imgParentView.image = image
                                            }
                                           
                             
                                        }
                                        else{
                                          
                                            self.imgParentView.image = image
                                        }
                                      
                                        self.newView.addSubview(self.imgParentView)
                                        
                                        
                                    }
                                    
                                    // Do something with your image.
                                } else {
                                    self.ai?.stopAnimating()
                                    self.ai?.removeFromSuperview()
                                    print("Couldn't get image: Image is nil")
                                }
                            } else {
                                print("Couldn't get response code for some reason")
                            }
                        }
                    }
                    downloadPicTask.resume()
                    
                } else if (lastExt == "mp3"){
                    //play audio
                 //   strURLAudio = StrURL
                imgParentView.isHidden = false
               
                self.downloadFileFromURL(url: StrURL )
                btnPlay = UIButton(type: UIButton.ButtonType.custom)
                newView.addSubview(btnPlay)
                btnPlay.isHidden =  false
                btnPlay.translatesAutoresizingMaskIntoConstraints = false
                btnPlay.backgroundColor = .blue
                    
                    let image = UIImage(named: "play") as UIImage?
                    btnPlay.setImage(image, for: UIControl.State.normal)
                    btnPlay.addTarget(self, action: #selector(playTapped), for: UIControl.Event.touchUpInside)
                   
                NSLayoutConstraint.init(item:btnPlay ,attribute: .height , relatedBy: .equal , toItem:nil , attribute: .notAnAttribute , multiplier: 1.0 , constant : 50).isActive = true
                    
                NSLayoutConstraint.init(item:btnPlay ,attribute: .width , relatedBy: .equal , toItem:nil , attribute: .notAnAttribute , multiplier: 1.0 , constant : 50).isActive = true
                    
                    
                NSLayoutConstraint(item: btnPlay, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
                   
                    
                NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: btnPlay, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 50).isActive = true
             
                }
                
        } else if(lastExt == "MOV" || lastExt == "mov" || lastExt == "mp4" ){
                imgParentView.isHidden = true
                btnPlay.isHidden =  true
            //play video
            let videoURL = URL(string: StrURL)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
           // playerViewController.view.frame = newView.frame
            playerViewController.player = player
                ai?.stopAnimating()
                ai?.removeFromSuperview()
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }

            }
            else{
                ai?.stopAnimating()
                ai?.removeFromSuperview()
                btnPlay.isHidden =  true
                Common.showalert(msg: "Content is not Supported",view:self)
            }
            
     
            }
        else {
           
            print("not proper URL")
        }
            
        }
  
    
    // MARK: Actions
    @objc  func doneClick(){
        SVProgressHUD.show(withStatus: "Not Joining")
        pickerForJustification.removeFromSuperview()
                toolBar.removeFromSuperview()
        
                if(selectedJustification != nil)
                {
                    JointThePromotion(strStatus: "0")
                }
                else{
                    selectedJustification = ArrJustification[0]
                    JointThePromotion(strStatus: "0")
                }
    }
    @objc func cancelClick(){
        pickerForJustification.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
    
    @objc func closeTapped(){
        if(self.player?.isPlaying ?? true){
            self.player?.stop()
        }
        imgParentView.removeFromSuperview()
     //  btnplay.removeFromSuperview()
       webView.removeFromSuperview()
       newView.removeFromSuperview()
    
    }
    
    @objc func playTapped(){
 
        DispatchQueue.main.async {
            if(self.btnPlay.currentImage == UIImage(named: "play")){
                self.btnPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                self.player?.play()
        }else{
                self.btnPlay.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                self.player?.pause()
                
        }
        }

    }
    
    func downloadFileFromURL(url:String){
     

     
            // then lets create your document folder url
        if let audioUrl = URL(string: url) {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                 imgParentView.image = UIImage.init(named: "music_blue")
                URLAudio =  destinationUrl
                print("The file already exists at path")
                do {
                    self.player = try AVAudioPlayer(contentsOf: URLAudio as URL)
                }
                catch{
                    Utils.toastmsg(message:"can not play audio",view:self.view)
                }

                DispatchQueue.main.async {
                   // self.playTapped()
                    self.ai?.stopAnimating()
                    self.ai?.removeFromSuperview()
                }
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder %@",destinationUrl)
                        DispatchQueue.main.async {
                        self.imgParentView.image = UIImage.init(named: "music_blue")
                        }
                        self.URLAudio = destinationUrl
                        
                        do {
                            self.player = try AVAudioPlayer(contentsOf: self.URLAudio as URL)
                        }
                        catch{
                            Utils.toastmsg(message:"can not play audio",view:self.view)
                        }
                        DispatchQueue.main.async {
                          //  self.playTapped()
                            self.ai?.stopAnimating()
                            self.ai?.removeFromSuperview()
                        }
                        
                    } catch {
                        DispatchQueue.main.async {
                            self.imgParentView.removeFromSuperview()
                            self.webView.removeFromSuperview()
                            self.newView.removeFromSuperview()
                             Utils.toastmsg(message:error.localizedDescription,view:self.view)
                            self.ai?.stopAnimating()
                            self.ai?.removeFromSuperview()
                        }
                        print(error)
                    }
                    }.resume()
          //  }
        }
        }

    }
//    func play(url:URL) {
//        print("playing \(url)")
//
//        do {
//            self.player = try AVAudioPlayer(contentsOf: url as URL)
//            player?.prepareToPlay()
//            player?.volume = 1.0
//
//        } catch let error as NSError {
//            //self.player = nil
//            print(error.localizedDescription)
//        } catch {
//            print("AVAudioPlayer init failed")
//        }
//         DispatchQueue.main.async {
//            if(self.btnPlay.currentImage == UIImage(named: "play")){
//                self.btnPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
//                self.player?.pause()
//        }else{
//                self.btnPlay.setImage(UIImage(named: "play"), for: UIControl.State.normal)
//                self.player?.play()
//        }
//        }
//
//    }
//    func donePicker(sender:UIBarButtonItem){
//        pickerForJustification.removeFromSuperview()
//        toolBar.removeFromSuperview()
//        if(selectedJustification != nil)
//        {
//            JointThePromotion(strStatus: "0")
//        }
//        //selectedJustification =
  //  }
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    @objc func gotoHome()  {
//        self.navigationController?.popToRootViewController(animated: true)
//    }
    
    @IBAction func btnJoinClicked(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: "Joining")
     //   btnJoin.isUserInteractionEnabled =  false
        self.callAPIForSendOTP()
      
    }
    
    
    @IBAction func btnNotJoinClicked(_ sender: UIButton) {
       
        if(ArrJustification.count > 0){
        self.view.addSubview(pickerForJustification)
        self.view.addSubview(toolBar)
        }else{
           Utils.toastmsg(message:"No Justifications Available",view:self.view)
        }
     
    }
    
    func getJustificationThroughID(ID:Int) -> Justification {
        var justificationObj:Justification! = Justification.init(["1" : "Nothing"])
        for Justification in ArrJustification {
            if(Justification.iD == ID){
                justificationObj = Justification
            }
        }
        return justificationObj
    }
    
   
    
    // MARK: - API Call
    
    func getJustificationList(){
        
        
        self.apihelper.getCustomerVendorSettings(urlstring: ConstantURL.kWSUrlGetJustificationList) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                if(responseType == ResponseType.arr){
                    let arrjustification = arr as? [[String:Any]] ?? [[String:Any]]()
                    var Arr:Array<Justification> = Array()
                    for Dictionary in arrjustification{
                        let justificationObj = Justification.init(Dictionary)
                        Arr.append(justificationObj)
                    }
                    self.ArrJustification = Arr
                    print(self.ArrJustification)
                    self.pickerForJustification.reloadAllComponents()
                }
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
        
        
  
    }
    
    func JointThePromotion(strStatus:String){
        
        var param = Common.returndefaultparameter()
        
        
        var param1 = [String:Any]()
        if  let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: ObjVisitForPromotionDetail?.customerID ?? 1)){
            param1 = ["promotionID":promotionDetail.ID,"visitID":ObjVisitForPromotionDetail.iD,"customerID":customer.iD ,"userID":activeuser?.userID ?? NSNumber.init(value: 0),"hasJoinedPromotion":strStatus]
        }else{
             param1 = ["promotionID":promotionDetail.ID,"visitID":ObjVisitForPromotionDetail.iD,"customerID":0 ,"userID":activeuser?.userID ?? NSNumber.init(value: 0),"hasJoinedPromotion":strStatus]
        }
        
        if(isContentView == true){
            param1["hasViewContent"] = 1
        }else{
             param1["hasViewContent"] = 0
        }
        
        if(strStatus == "0"){
            //set justification ID
            param1["justificationID"] = selectedJustification.iD
          
            
        }
        param["joinPromotionJson"] = Common.json(from: param1)
       
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.KWSUrlJointPromotion, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                self.promotionData.remove(at: self.selectedPromotionID as? Int ?? 0)
                if(strStatus == "0"){
                    self.promotionDetail.status = 2
                    self.promotionDetail.justificationID = self.selectedJustification.iD
                }
                else{
                    self.promotionDetail.status = 1
                }
                self.promotionData.insert(self.promotionDetail, at: self.selectedPromotionID as? Int ?? 0)
                
                self.delegateDetail?.updatePromotionData(arr: self.promotionData)
                let  promotionListObj:PromotionList = PromotionList()
                promotionListObj.updateDataCompletion?(self.promotionData)
                NotificationCenter.default.post(name: Notification.Name("UpdatePromotionListNotification"), object: nil)
//                NotificationCenter.default.post(name: .peru, object: [])
                print(self.promotionData)
                //PromotionList().updatePromotionData(arr: self.promotionData)
//                self.view.makeToast(message:message, duration: 3.0, position: nil , title: nil, image: nil, style: nil, completion: { (flag) in
                self.view.makeToast(message, duration: 3.0, position: nil , title: nil, image: nil, style: nil, completion: { (flag) in
                    print(flag)
                    // delegate?.changeBackgroundColor(tapGesture.view?.backgroundColor)
                    
                    
                    self.navigationController?.popViewController(animated: true)
                })
                
            }
            else if(error.code == 0){
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            }else{
               Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
        
     /*   let account = Utils().getActiveAccount()
        
        let param = NSMutableDictionary()
        
        let param1 = NSMutableDictionary()
        
          let customer = _CustomerDetails.getCustomerByID(NSNumber.init(value: ObjVisitForPromotionDetail?.customerID ?? 1))
        
        param1.setObject(promotionDetail.ID , forKey: "promotionID" as NSCopying)
        
        param1.setObject(ObjVisitForPromotionDetail.iD, forKey: "visitID" as NSCopying)
        param1.setObject(customer?.iD ?? 1 , forKey: "customerID" as NSCopying)
        param1.setObject(account?.user_id ?? 1, forKey: "userID" as NSCopying)
        param1.setObject(strStatus, forKey: "hasJoinedPromotion" as NSCopying)
        if(isContentView){
            param1.setObject(1, forKey: "hasViewContent" as NSCopying)
        }
        else{
            param1.setObject(0, forKey: "hasViewContent" as NSCopying)
        }
        if(strStatus == "0"){
            //set justification ID
            
            param1.setObject(selectedJustification.ID, forKey: "justificationID" as NSCopying)
            
        }
        param.setObject(param1.rs_jsonString(withPrettyPrint: true), forKey: "joinPromotionJson" as NSCopying)
        param.setObject(account?.user_id ?? 1, forKey: "UserID" as NSCopying)
        param.setObject(account?.securityToken ?? 1 , forKey: "TokenID" as NSCopying)
        param.setObject(account?.company_info.company_id ?? 1, forKey: "CompanyID" as NSCopying)
        print(param)
        callAPIPost(methodName: "Post", url: kBaseTeamworkURL + KWSUrlJointPromotion , parameter: param as! [String : Any]) { (status, result) in
             SVProgressHUD.dismiss()
            print(status)
            let resultModel = Result(result as! [String : Any])
            if(resultModel != nil){
                
                if(status.lowercased() == "success"){
                    do{
                        //here dataResponse received from a network request
                        print(result)
                        print(resultModel)
                        if(resultModel.status.lowercased() == "success"){
                            self.promotionData.remove(at: self.selectedPromotionID as! Int)
                            if(strStatus == "0"){
                                self.promotionDetail.status = 2
                                self.promotionDetail.justificationID = self.selectedJustification.ID
                            }
                            else{
                                self.promotionDetail.status = 1
                            }
                            self.promotionData.insert(self.promotionDetail, at: self.selectedPromotionID as! Int)
                            
                            self.delegateDetail?.updatePromotionData(arr: self.promotionData)
                            let  promotionListObj:PromotionList = PromotionList()
                              promotionListObj.updateDataCompletion?(self.promotionData)
                            NotificationCenter.default.post(name: Notification.Name("UpdatePromotionListNotification"), object: nil)
                           NotificationCenter.default.post(name: .peru, object: nil)
                            print(self.promotionData)
                            //PromotionList().updatePromotionData(arr: self.promotionData)
                            Utils.toastmsg(message:resultModel.message, duration: 3.0, position: nil , title: nil, image: nil, style: nil, completion: { (flag) in
                                print(flag)
                             // delegate?.changeBackgroundColor(tapGesture.view?.backgroundColor)
                               
                               
                                self.navigationController?.popViewController(animated: true)
                            })
                           
                            
                        }
                        else{
                            self.showAlert(withMessage: "SomeThing Went Wrong")
                            print("SomeThing Went Wrong")
                            if(!resultModel.message.isEmpty){
                               Utils.toastmsg(message:resultModel.message)
                            }
                            else{
                                
                            }
                            
                        }
                    }
                }
            }
            else{
                self.showAlert(withMessage: "SomeThing Went Wrong Please try again")
                
            }
        }*/
    }
    
    func callAPIForSendOTP()  {
        
        
        if let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: ObjVisitForPromotionDetail.customerID)){
        self.apihelper.sendOTP(mobileNo: customer.mobileNo) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                SVProgressHUD.dismiss()
                let alertForGetOTP = UIAlertController.init(title: "OTP Verification", message: "" , preferredStyle: UIAlertController.Style.alert)
                //  let text = UITextField.init()
                // text.placeholder = "AddOTP"
                
                alertForGetOTP.addTextField { (textField : UITextField!) -> Void in
                    textField.setCommonFeature()
                    textField.placeholder = "Please enter OTP"
                }
                
                let cancelAction = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                
                let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                    if((alertForGetOTP.textFields!.first?.text?.isEmpty)!){
                        Utils.toastmsg(message:"Please Enter OTP",view:self.view)
                        //self.showAleert(withMessage: "Please Enter OTP")
                    }
                    else{
                        self.callAPIForVerifyOTP(OTP: (alertForGetOTP.textFields!.first?.text)!)
                    }
                })
                alertForGetOTP.addAction(okAction)
                alertForGetOTP.addAction(cancelAction)
                
                
                self.present(alertForGetOTP, animated: true, completion: nil)
            }else{
       Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
        }else{
            Utils.toastmsg(message:"Not valid customer mobile number",view:self.view)
        }
        
        /*
         @Field("CustomerMobileNo") String CustomerMobileNo,
         @Field(Constants.COMPANY_ID) Integer companyID,
         @Field(Constants.USER_ID) Integer userID,
         @Field(Constants.TOKEN_ID) String tokenID);
         
         */
     /*   let account = Utils().getActiveAccount()
        
        let param = NSMutableDictionary()
        
        let customer = _CustomerDetails.getCustomerByID(NSNumber.init(value: ObjVisitForPromotionDetail?.customerID ?? 1))
        
        //_CustomerDetails.getCustomerByID(ObjVisit!.customerID as NSNumber) as!
        
        //[_CustomerDetails getCustomerByName:self.objVisit.customerName];
        param.setObject(account?.user_id ?? 1, forKey: "UserID" as NSCopying)
        param.setObject(account?.securityToken ?? 1, forKey: "TokenID" as NSCopying)
        param.setObject(account?.company_info.company_id ?? 1, forKey: "CompanyID" as NSCopying)
        //    param.setObject(customer?.mobileNo! ?? 1111111, forKey: "CustomerMobileNo" as NSCopying)
        // param.setObject(1, forKey: "CompanyID" as NSCopying)
        param.setObject(customer?.mobileNo ?? 3223545 , forKey: "CustomerMobileNo" as NSCopying)
        //param.setObject(status, forKey: "IsReceived" as NSCopying)
        print("parameter for send OTP:",param)
        
        callAPIPost(methodName: "Post", url: kBaseURL + kWSUrlForSendOTP , parameter: param as! [String : Any]) { (status, result) in
            SVProgressHUD.dismiss()
            print(status)
            if(status.lowercased() == "success"){
                do{
                    //here dataResponse received from a network request
                    
                    print(result )
                    let resultModel = Result(result as! [String : Any])
                    
                    print(resultModel)
                    if(resultModel.status.lowercased() == "success" ){
                         Utils.toastmsg(message:resultModel.message)
                        let AlertForGetOTP = UIAlertController.init(title: "OTP Verification", message: "" , preferredStyle: UIAlertController.Style.alert)
                        //  let text = UITextField.init()
                        // text.placeholder = "AddOTP"
                        
                        AlertForGetOTP.addTextField { (textField : UITextField!) -> Void in
                            textField.placeholder = "Please enter OTP"
                        }
                        
                        let cancelAction = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.default, handler: { (action) in
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                        let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                            if((AlertForGetOTP.textFields!.first?.text?.isEmpty)!){
                                self.showAlert(withMessage: "Please Enter OTP")
                            }
                            else{
                                self.callAPIForVerifyOTP(OTP: (AlertForGetOTP.textFields!.first?.text)!)
                            }
                        })
                        AlertForGetOTP.addAction(okAction)
                        AlertForGetOTP.addAction(cancelAction)
                        
                        
                        self.present(AlertForGetOTP, animated: true, completion: nil)
                        
                    }
                    else{
                       // self.btnJoin.isUserInteractionEnabled = true
                        self.showAlert(withMessage: "SomeThing Went Wrong")
                        
                    }
                }
            }
                
            else{
             //   self.btnJoin.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                self.showAlert(withMessage: "SomeThing Went Wrong Please try again")
            }
        }
        
        */
    }
    
    func callAPIForVerifyOTP(OTP:String)  {
        
      
            
        if   let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: ObjVisitForPromotionDetail.customerID)){
            
            self.apihelper.verifyOTP(mobileNo: customer.mobileNo, OTP: OTP) {  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                if(error.code == 0){
                     if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                    self.JointThePromotion(strStatus: "1")
//                    self.callAPIForResponse(entitlement: self.entitlementObjData, status: 1)
                }else{
                    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                }
            }
        }
        /*
         @Field("CustomerMobileNo") String CustomerMobileNo,
         @Field("Otp") String Otp,
         @Field(Constants.APPLICATION) String application,
         @Field(Constants.COMPANY_ID) Integer companyID,
         @Field(Constants.USER_ID) Integer userID,
         @Field(Constants.TOKEN_ID) String tokenID);
         
         */
    /*    let account = Utils().getActiveAccount()
        
        let param = NSMutableDictionary()
        
        
        //   let customer = _CustomerDetails.getCustomerByID(NSNumber.i)
        //   let customer = _CustomerDetails.getCustomerByID(NSNumber.init(coder: ObjVisit?.customerID)  as NSNumber?)
        let customer = _CustomerDetails.getCustomerByID(NSNumber.init(value: ObjVisitForPromotionDetail.customerID))
        
        param.setObject(account?.user_id ?? 1, forKey: "UserID" as NSCopying)
        param.setObject(account?.securityToken ?? 1, forKey: "TokenID" as NSCopying)
        param.setObject(account?.company_info.company_id ?? 1, forKey: "CompanyID" as NSCopying)
        // param.setObject(1, forKey: "CompanyID" as NSCopying)
        param.setObject(customer?.mobileNo! ?? 1111111, forKey: "CustomerMobileNo" as NSCopying)
        param.setObject(OTP, forKey: "Otp" as NSCopying)
        param.setObject("Application", forKey: "Application" as NSCopying)
        
        //param.setObject(status, forKey: "IsReceived" as NSCopying)
        print(param)
        
        callAPIPost(methodName: "Post", url: kBaseURL + kWSUrlForVerifyOTP , parameter: param as! [String : Any]) { (status, result) in
            print(status)
            
           
                
                if(status.lowercased() == "success"){
                    do{
                        //here dataResponse received from a network request
                        let resultModel = Result(result as! [String : Any])
                         if(resultModel != nil){
                        print(result )
                        
                        
                        print(resultModel)
                        if(resultModel.status.lowercased() == "success" ){
                         Utils.toastmsg(message:resultModel.message)
                                self.JointThePromotion(strStatus: "1")
                            
                           
                        }
                        else{
                        
                          //  self.showAlert(withMessage: "SomeThing Went Wrong")
                            print("SomeThing Went Wrong")
                            if(!resultModel.message.isEmpty){
                               Utils.toastmsg(message:resultModel.message)
                            }
                            else{
                                
                            }
                            
                        }
                    }
                }
//                else{
//                     Utils.toastmsg(message:resultModel.message)
//                }
            }
            else{
          
                     let resultModel = Result(result as! [String : Any])
                    Utils.toastmsg(message:resultModel.message as? String ?? "SomeThing Went Wrong Please try again")
                //dictionary["message"]
               // Utils.toastmsg(message:"SomeThing Went Wrong Please try again")
                
            }
        }
        
        */
    }
   

}


extension PromotionDetail:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(ArrTitle.count)
        return ArrTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0 || section == 1 || section == 2){
            return 1
        }
        else if (section == 3 ){
            if(promotionDetail.promodescription?.count ?? 0 > 0  && getContnetCount() > 0){
                
                return 1
            
            }else if (promotionDetail.promodescription?.count ?? 0 == 0 && getContnetCount() == 0){
                 return promotionDetail.promotionProductList.count
            } else if(promotionDetail.promodescription?.count ?? 0 == 0 ||  getContnetCount() == 0){
                if(promotionDetail.promodescription?.count ?? 0 > 0 ){
                    return 1
                }
                else if(getContnetCount()>0){
                    return getContnetCount()
                }
                else{
                   return promotionDetail.promotionProductList.count
                }
             }else{
                return 1
            }
          
        }else if(section == 4){
            
            if(promotionDetail.promodescription?.count ?? 0 > 0  && getContnetCount() > 0){
                
                return getContnetCount()
                
            }else if (promotionDetail.promodescription?.count ?? 0 == 0 && getContnetCount() == 0){
                if(promotionDetail.freeBonusProductList.count > 0){
                    return promotionDetail.freeBonusProductList.count
                }
                else {
                  return  promotionDetail.flatPromotionSlabDetails.count + 1
                }
              
            } else if(promotionDetail.promodescription?.count ?? 0 == 0 ||  getContnetCount() == 0){
                 return  promotionDetail.promotionProductList.count
            }else{
                return 1
            }
            
         
        }else if (section == 5){
            if(promotionDetail.promodescription?.count ?? 0 > 0 && getContnetCount() > 0 ){
                if(promotionDetail.promotionProductList.count > 0){
                    return promotionDetail.promotionProductList.count
                }
                else{
                    if(promotionDetail.freeBonusProductList.count > 0 || promotionDetail.flatPromotionSlabDetails.count > 0 ){
                        if(promotionDetail.flatPromotionSlabDetails.count > 0){
                            return promotionDetail.flatPromotionSlabDetails.count + 1
                        }else{
                            return promotionDetail.freeBonusProductList.count
                        }
                    }
                    else  if(promotionDetail.status == 1 || promotionDetail.status == 2){
                        return 1
                    }
                    else{
                        return 0
                    }
                    
                    
                }
            }else if(promotionDetail.promodescription?.count ?? 0 == 0 && getContnetCount() == 0){
            if(promotionDetail.status == 1 || promotionDetail.status == 2){
                return 1
            }
            else{
                return 0
            }
            }else if (promotionDetail.promodescription?.count ?? 0 == 0 || getContnetCount() == 0){
            
            if(promotionDetail.freeBonusProductList.count > 0 || promotionDetail.flatPromotionSlabDetails.count > 0 ){
                if(promotionDetail.flatPromotionSlabDetails.count > 0){
                    return promotionDetail.flatPromotionSlabDetails.count + 1
                }else{
                    return promotionDetail.freeBonusProductList.count
                }
            }
            else  if(promotionDetail.status == 1 || promotionDetail.status == 2){
                return 1
            }
            else{
                return 1
            }
        }else{
                return 1
            }
            }
        else if(section == 6){
            print(promotionDetail.flatPromotionSlabDetails)
            if(promotionDetail.promodescription?.count ?? 0 > 0 && getContnetCount() > 0){
                if(promotionDetail.freeBonusProductList.count > 0 || promotionDetail.flatPromotionSlabDetails.count > 0 ){
                    
                    if(promotionDetail.flatPromotionSlabDetails.count > 0){
                        return promotionDetail.flatPromotionSlabDetails.count + 1
                    }else{
                        return promotionDetail.freeBonusProductList.count
                    }
                }
                else  if(promotionDetail.status == 1 || promotionDetail.status == 2){
                    return 1
                }
                else{
                    return 0
                }
            }
            else if (promotionDetail.promodescription?.count ?? 0 == 0 && getContnetCount()  == 0){
                if(promotionDetail.status == 2){
                    return 1
                }
                else {
                    return 0
                }
                
            }
            else if (promotionDetail.promodescription?.count ?? 0 == 0 || getContnetCount() == 0){
                // based on status
                if(promotionDetail.status == 1 || promotionDetail.status == 2){
                    return 1
                }
                else{
                    return 0
                }
            }else {
                return 0
            }
            
        }
        
        else if (section == 7){
            if(promotionDetail.promodescription?.count ?? 0 > 0 && getContnetCount() > 0 && promotionDetail.promotionProductList.count > 0 && (promotionDetail.freeBonusProductList.count > 0  || promotionDetail.flatPromotionSlabDetails.count > 0)){
                
                 if(promotionDetail.status == 1 || promotionDetail.status == 2){
                    return 1
                }
                else{
                    return 0
                }
            }else if (
                promotionDetail.promodescription?.count ?? 0 == 0  || getContnetCount() == 0){
                if(promotionDetail.status == 1 || promotionDetail.status == 2){
                    return 1
                }
                else{
                    return 0
                }
            }else {
                return 1
                
            }
        }else if (section == 8){
            if(promotionDetail.promodescription?.count ?? 0 > 0 && getContnetCount() > 0 && promotionDetail.promotionProductList.count > 0 && (promotionDetail.freeBonusProductList.count > 0  || promotionDetail.flatPromotionSlabDetails.count > 0) &&  promotionDetail.status == 2){
                return 1
            }
                else{
                    return 0
                }
        }
        
        else
        {
        return 0
        }
}

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    
    
       if let promocell = tableView.dequeueReusableCell(withIdentifier: "promotionlinedetail", for: indexPath)
        as? PromotionLineDetail{
        
        
        promocell.lblPromotionDetail.lineBreakMode = .byWordWrapping
        promocell.lblPromotionDetail.numberOfLines = 0
        promocell.lblPromotionDetail.preferredMaxLayoutWidth = promocell.lblPromotionDetail.frame.size.width

       // promocell.lblPromotionDetail.
     
        promocell.contentView.layoutMargins = UIEdgeInsets(top: 10 , left: 20, bottom: 5, right: 10)
        promocell.selectionStyle = .none
        promocell.btnEye.isHidden = true
        promocell.btnEye.isUserInteractionEnabled = false
        // promocell.lblP
       promocell.viewBgForPromotionDetail.layer.cornerRadius = 10
     //  promocell.viewBgForPromotionDetail.backgroundColor = .red
      inputFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        
        if(indexPath.section == 0 || indexPath.section == 1){
            //start date and end date
            let showDate = inputFormatter.date(from: getPromotionData[indexPath.section] as? String ?? "2000-12-2 12:00:12")
            print(showDate ?? "N/A")
            inputFormatter.dateFormat = "dd/MM/yyyy"
            let resultString = inputFormatter.string(from: showDate!)
            print(resultString)
            promocell.lblPromotionDetail?.text = inputFormatter.string(from: showDate!)
            return promocell
        
        }else if (indexPath.section == 2){
            //promotion type
            promocell.lblPromotionDetail.text = promotionDetail.promotionType == 1 ? "Flat":"Bonus"
            return promocell
        }
        else if(indexPath.section == 3){
            if(promotionDetail.promodescription?.count ?? 0 > 0  && getContnetCount() > 0){
                let strBoldDesc = NSMutableAttributedString.init(string: "Description:", attributes: [NSAttributedString.Key.font : UIFont(name: Common.kfontbold, size: 15) ?? .systemFont(ofSize: 15)])
                strBoldDesc.append(NSAttributedString.init(string: promotionDetail.promodescription ?? "No Description"))
                promocell.lblPromotionDetail?.attributedText = strBoldDesc
                return promocell
            }else if (promotionDetail.promodescription?.count == 0 && getContnetCount() == 0){
                let promoProduct = promotionDetail.promotionProductList[indexPath.row]
                if(promotionDetail.promotionType == Int(Common.PROMOTION_TYPE_FLAT)){
                    //display product for flat promotion
                    print(promoProduct.productName)
                    if(!(promoProduct.productName == "")){
                    promocell.lblPromotionDetail?.text = promoProduct.productName
                    }
                    else{
                        let mutstr = NSMutableString()
                        mutstr.append(promoProduct.productCategoryName)
                        mutstr.append("/" + promoProduct.productSubCategoryName)
                        promocell.lblPromotionDetail.text = mutstr as String
                    }
                }
                else{
                    //display product for bonus promotion
                    let atrProName:NSMutableAttributedString = NSMutableAttributedString(string: promoProduct.productName)
                    atrProName.append(NSAttributedString(string: "\n Quantity:", attributes: [NSAttributedString.Key.font : UIFont(name: Common.kfontbold, size: 15) ?? .systemFont(ofSize: 15)]))
                    atrProName.append(NSAttributedString(string: String(promoProduct.qtyEligibleForBonus)))
                    promocell.lblPromotionDetail?.attributedText = atrProName
                }
                return promocell
            } else if(promotionDetail.promodescription?.count ?? 0 == 0 ||  getContnetCount() == 0){
                if(promotionDetail.promodescription?.count ?? 0 > 0 ){
                    let strBoldDesc = NSMutableAttributedString.init(string: "Description:", attributes: [NSAttributedString.Key.font : UIFont(name: Common.kfontbold, size: 15) ?? .systemFont(ofSize: 15)])
                    strBoldDesc.append(NSAttributedString.init(string: promotionDetail.promodescription ?? "No Description"))
                    promocell.lblPromotionDetail?.attributedText = strBoldDesc
                    return promocell
                }else {
                    promocell.viewBgForPromotionDetail.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                    promocell.btnEye.isHidden = false
                    
                    promocell.lblPromotionDetail.text  = ArrContnetCaption[indexPath.row]
                    return promocell
                }
             }
            
                let cell = UITableViewCell.init()
                return cell
            }
           
            
            
        
        else if(indexPath.section == 4){
            if(promotionDetail.promodescription?.count ?? 0 > 0 && getContnetCount() > 0){
          
//            }else if(promotionDetail.promodescription??.count ?? 0 > 0){
            
                if(ArrContnetURL.count>0){
                    //display content
               
                    promocell.btnEye.isHidden = false
                  promocell.viewBgForPromotionDetail.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                    promocell.lblPromotionDetail.text  = ArrContnetCaption[indexPath.row]
                    return promocell
                }
                else{
          promocell.viewBgForPromotionDetail.backgroundColor = .clear
                    if(promotionDetail.promotionProductList.count > 0){
                        //Display product list
                        let promoProduct = promotionDetail.promotionProductList[indexPath.row]
                        if(promotionDetail.promotionType == Int(Common.PROMOTION_TYPE_FLAT)){
                            //display product for flat promotion
                            print(promoProduct.productName)
                            if(!(promoProduct.productName == "")){
                                promocell.lblPromotionDetail?.text = promoProduct.productName
                            }
                            else{
                                let mutstr = NSMutableString()
                                mutstr.append(promoProduct.productCategoryName)
                                mutstr.append("/" + promoProduct.productSubCategoryName)
                                promocell.lblPromotionDetail.text = mutstr as String
                            }
                        }
                        else{
                              //display product for bonus promotion
                            let atrProName:NSMutableAttributedString = NSMutableAttributedString(string: promoProduct.productName)
                            atrProName.append(NSAttributedString(string:"     \nQuantity:", attributes: [NSAttributedString.Key.font : UIFont(name: Common.kfontbold, size: 15) ?? .systemFont(ofSize: 15)]))
                            atrProName.append(NSAttributedString(string: String(promoProduct.qtyEligibleForBonus)))
                            promocell.lblPromotionDetail?.attributedText = atrProName
                        }
                        return promocell
                    }
                    else{
                        if(promotionDetail.promotionType == Int(Common.PROMOTION_TYPE_FLAT))
                        {
                            if(promotionDetail.flatPromotionSlabDetails.count > 0){
                                //display product for flat promotion
                                let cell = tableView.dequeueReusableCell(withIdentifier: "promotionvalidationcell", for: indexPath) as! PromotionValidationCell
                                //cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: -10, bottom: 10, right: 10)
                            cell.viewStartFrom.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                                
                                cell.viewUpto.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                                cell.viewFrom.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                                
                            cell.viewStartFrom.layer.cornerRadius = 5
                                cell.viewUpto.layer.cornerRadius = 5
                                cell.viewFrom.layer.cornerRadius = 5
                                cell.selectionStyle = .none
                                if(indexPath.row == 0)
                                {
                                    cell.lblStartFrom.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                                    cell.lblUpTo.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                                    cell.lblFrom.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                                    
                                    cell.lblStartFrom.text = "Start From"
                                    cell.lblUpTo.text = "Up To"
                                    cell.lblFrom.text = "Offer"
                                    cell.layoutIfNeeded()
                                }
                                else{
                                    print(indexPath.row)
                                    
                                    let freebonus = promotionDetail.flatPromotionSlabDetails[indexPath.row - 1 ]
                                    cell.lblStartFrom.text = String(freebonus.startSlabAmount)//freebonus.startSlabAmount
                                    cell.lblUpTo.text = String(freebonus.endSlabAmount)
                                    cell.lblFrom.text = String(freebonus.slabPercentage)
                                }
                                return cell
                            }
                            else if(promotionDetail.status == 1 || promotionDetail.status == 2){
                                //display status
                                if(promotionDetail.status == 1){
                                    promocell.lblPromotionDetail.text = "Joined"
                                }
                                else if(promotionDetail.status == 2){
                                    promocell.lblPromotionDetail.text = "Not Joined"
                                }
                                return promocell
                            }
                            else{
                                //finish
                                let cell = UITableViewCell.init()
                                return cell
                            }
                        }
                        else{
                            //Promotion bonus
                            if( promotionDetail.freeBonusProductList.count > 0 ){
                                //products for bonus
                                let bonusProduct = promotionDetail.freeBonusProductList[indexPath.row]
                                let atrProName:NSMutableAttributedString =  NSMutableAttributedString(string: bonusProduct.productName)
                                //bonusProduct.productName
                                atrProName.append(NSAttributedString(string: "\nQuantity:", attributes: [NSAttributedString.Key.font : UIFont(name: Common.kfontbold, size: 15) ?? .systemFont(ofSize: 15)]))
                                atrProName.append(NSAttributedString(string: String(bonusProduct.freeProductQty)))
                                promocell.lblPromotionDetail?.attributedText = atrProName
                                
                                return promocell
                            }
                            else if(promotionDetail.status == 1 || promotionDetail.status == 2){
                                //display status
                                if(promotionDetail.status == 1){
                                    promocell.lblPromotionDetail.text = "Joined"
                                }
                                else if(promotionDetail.status == 2){
                                    promocell.lblPromotionDetail.text = "Not Joined"
                                }
                                return promocell
                            }
                            else{
                                //finish
                                let cell = UITableViewCell.init()
                                return cell
                            }
                        }
                       
                    }
                }
            }else if (getContnetCount() == 0 && promotionDetail.promodescription?.count == 0){
                if(promotionDetail.promotionType == Int(Common.PROMOTION_TYPE_FLAT))
                {
                    if(promotionDetail.flatPromotionSlabDetails.count > 0){
                        //display product for flat promotion
                        if   let cell = tableView.dequeueReusableCell(withIdentifier: "promotionvalidationcell", for: indexPath) as? PromotionValidationCell{
                        //cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: -10, bottom: 10, right: 10)
                        cell.viewStartFrom.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                        
                        cell.viewUpto.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                        cell.viewFrom.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                        
                        cell.viewStartFrom.layer.cornerRadius = 5
                        cell.viewUpto.layer.cornerRadius = 5
                        cell.viewFrom.layer.cornerRadius = 5
                        cell.selectionStyle = .none
                        if(indexPath.row == 0)
                        {
                            cell.lblStartFrom.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                            cell.lblUpTo.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                            cell.lblFrom.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                            
                            cell.lblStartFrom.text = "Start From"
                            cell.lblUpTo.text = "Up To"
                            cell.lblFrom.text = "Offer"
                             cell.layoutIfNeeded()
                        }
                        else{
                            print(indexPath.row)
                            
                            let freebonus = promotionDetail.flatPromotionSlabDetails[indexPath.row - 1 ]
                            cell.lblStartFrom.text = String(freebonus.startSlabAmount)//freebonus.startSlabAmount
                            cell.lblUpTo.text = String(freebonus.endSlabAmount)
                            cell.lblFrom.text = String(freebonus.slabPercentage)
                        }
                        return cell
                        }else{
                            return UITableViewCell()
                        }
                    }
                    else if(promotionDetail.status == 1 || promotionDetail.status == 2){
                        //display status
                        if(promotionDetail.status == 1){
                            promocell.lblPromotionDetail.text = "Joined"
                        }
                        else if(promotionDetail.status == 2){
                            promocell.lblPromotionDetail.text = "Not Joined"
                        }
                        return promocell
                    }
                    else{
                        //finish
                        let cell = UITableViewCell.init()
                        return cell
                    }
                }
                else{
                    //Promotion bonus
                    if( promotionDetail.freeBonusProductList.count > 0 ){
                        //products for bonus
                        let bonusProduct = promotionDetail.freeBonusProductList[indexPath.row]
                        let atrProName:NSMutableAttributedString = NSMutableAttributedString(string: bonusProduct.productName)
                        //bonusProduct.productName
                        atrProName.append(NSAttributedString(string: " \nQuantity:", attributes: [NSAttributedString.Key.font : UIFont(name: Common.kfontbold, size: 15) ?? .systemFont(ofSize: 15)]))
                        atrProName.append(NSAttributedString(string: String(bonusProduct.freeProductQty)))
                        promocell.lblPromotionDetail?.attributedText = atrProName
                        
                        return promocell
                    }
                    else if(promotionDetail.status == 1 || promotionDetail.status == 2){
                        //display status
                        if(promotionDetail.status == 1){
                            promocell.lblPromotionDetail.text = "Joined"
                        }
                        else if(promotionDetail.status == 2){
                            promocell.lblPromotionDetail.text = "Not Joined"
                        }
                        return promocell
                    }
                    else{
                        //finish
                        let cell = UITableViewCell.init()
                        return cell
                    }
                }
            }
            else{
                if(promotionDetail.promotionProductList.count > 0){
                    //Display product list
                    let promoProduct = promotionDetail.promotionProductList[indexPath.row]
                    if(promotionDetail.promotionType == Int(Common.PROMOTION_TYPE_FLAT)){
                        //display product for flat promotion
                        print(promoProduct.productName)
                        if(!(promoProduct.productName == "")){
                            promocell.lblPromotionDetail?.text = promoProduct.productName
                        }
                        else{
                            let mutstr = NSMutableString()
                            mutstr.append(promoProduct.productCategoryName)
                            mutstr.append("/" + promoProduct.productSubCategoryName)
                            promocell.lblPromotionDetail.text = mutstr as String
                        }
                    }
                    else{
                        //display product for bonus promotion
                        let atrProName:NSMutableAttributedString = NSMutableAttributedString(string: promoProduct.productName)
                        atrProName.append(NSAttributedString(string: "\nQuantity:", attributes: [NSAttributedString.Key.font : UIFont(name: Common.kfontbold, size: 15) ?? .systemFont(ofSize: 15)]))
                        atrProName.append(NSAttributedString(string: String(promoProduct.qtyEligibleForBonus)))
                        promocell.lblPromotionDetail?.attributedText = atrProName
                    }
                    return promocell
                }
                else{
                    if(promotionDetail.promotionType == Int(Common.PROMOTION_TYPE_FLAT))
                    {
                        if(promotionDetail.flatPromotionSlabDetails.count > 0){
                            //display product for flat promotion
                            if  let cell = tableView.dequeueReusableCell(withIdentifier: "promotionvalidationcell", for: indexPath) as? PromotionValidationCell{
                            //cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: -10, bottom: 10, right: 10)
                            cell.viewStartFrom.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                            
                            cell.viewUpto.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                            cell.viewFrom.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                            
                            cell.viewStartFrom.layer.cornerRadius = 5
                            cell.viewUpto.layer.cornerRadius = 5
                            cell.viewFrom.layer.cornerRadius = 5
                            cell.selectionStyle = .none
                            if(indexPath.row == 0)
                            {
                                cell.lblStartFrom.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                                cell.lblUpTo.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                                cell.lblFrom.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                                
                                cell.lblStartFrom.text = "Start From"
                                cell.lblUpTo.text = "Up To"
                                cell.lblFrom.text = "Offer"
                                 cell.layoutIfNeeded()
                            }
                            else{
                                print(indexPath.row)
                                
                                let freebonus = promotionDetail.flatPromotionSlabDetails[indexPath.row - 1 ]
                                cell.lblStartFrom.text = String(freebonus.startSlabAmount)//freebonus.startSlabAmount
                                cell.lblUpTo.text = String(freebonus.endSlabAmount)
                                cell.lblFrom.text = String(freebonus.slabPercentage)
                            }
                            return cell
                            }else{
                                return UITableViewCell()
                            }
                        }
                        else if(promotionDetail.status == 1 || promotionDetail.status == 2){
                            //display status
                            if(promotionDetail.status == 1){
                                promocell.lblPromotionDetail.text = "Joined"
                            }
                            else if(promotionDetail.status == 2){
                                promocell.lblPromotionDetail.text = "Not Joined"
                            }
                            return promocell
                        }
                        else{
                            //finish
                            let cell = UITableViewCell.init()
                            return cell
                        }
                    }
                    else{
                        if( promotionDetail.freeBonusProductList.count > 0 ){
                            //products for bonus
                            let bonusProduct = promotionDetail.freeBonusProductList[indexPath.row]
                            let atrProName:NSMutableAttributedString = (NSAttributedString(string: bonusProduct.productName) as? NSMutableAttributedString ?? NSAttributedString(string:"No ProductName") as! NSMutableAttributedString)
                            //bonusProduct.productName
                            atrProName.append(NSAttributedString(string: " \nQuantity:", attributes: [NSAttributedString.Key.font : UIFont(name: Common.kfontbold, size: 15) ?? .systemFont(ofSize: 15)]))
                            atrProName.append(NSAttributedString(string: String(bonusProduct.freeProductQty)))
                            promocell.lblPromotionDetail?.attributedText = atrProName
                            
                            return promocell
                        }
                        else if(promotionDetail.status == 1 || promotionDetail.status == 2){
                            //display status
                            if(promotionDetail.status == 1){
                                promocell.lblPromotionDetail.text = "Joined"
                            }
                            else if(promotionDetail.status == 2){
                                promocell.lblPromotionDetail.text = "Not Joined"
                            }
                            return promocell
                        }
                        else{
                            //finish
                            let cell = UITableViewCell.init()
                            return cell
                        }
                    }
                    
                }
            }
        }else if (indexPath.section == 5){
            if(promotionDetail.promodescription?.count ?? 0 > 0 && getContnetCount() > 0 ){
                // display product list
                if(promotionDetail.promotionProductList.count > 0){
                    //Display product list
                    let promoProduct = promotionDetail.promotionProductList[indexPath.row]
                    if(promotionDetail.promotionType == Int(Common.PROMOTION_TYPE_FLAT)){
                        //display product for flat promotion
                        print(promoProduct.productName)
                        if(!(promoProduct.productName == "")){
                            promocell.lblPromotionDetail?.text = promoProduct.productName
                        }
                        else{
                            let mutstr = NSMutableString()
                            mutstr.append(promoProduct.productCategoryName)
                            mutstr.append("/" + promoProduct.productSubCategoryName)
                            promocell.lblPromotionDetail.text = mutstr as String
                        }
                    }
                    else{
                        
                        //display product for bonus promotion
                        let atrProName:NSMutableAttributedString = NSMutableAttributedString(string: promoProduct.productName)
                        atrProName.append(NSAttributedString(string: "\nQuantity:", attributes: [NSAttributedString.Key.font : UIFont(name: Common.kfontbold, size: 15) ?? .systemFont(ofSize: 15)]))
                        atrProName.append(NSAttributedString(string: String(promoProduct.qtyEligibleForBonus)))
                        promocell.lblPromotionDetail?.attributedText = atrProName
                    }
                    return promocell
                }
                else{
                    if(promotionDetail.promotionType == Int(Common.PROMOTION_TYPE_FLAT))
                    {
                        if(promotionDetail.flatPromotionSlabDetails.count > 0){
                            //display product for flat promotion
                            if let cell = tableView.dequeueReusableCell(withIdentifier: "promotionvalidationcell", for: indexPath) as? PromotionValidationCell{
                            //cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: -10, bottom: 10, right: 10)
                            cell.viewStartFrom.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                            
                            cell.viewUpto.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                            cell.viewFrom.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                            
                            cell.viewStartFrom.layer.cornerRadius = 5
                            cell.viewUpto.layer.cornerRadius = 5
                            cell.viewFrom.layer.cornerRadius = 5
                            cell.selectionStyle = .none
                            if(indexPath.row == 0)
                            {
                                cell.lblStartFrom.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                                cell.lblUpTo.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                                cell.lblFrom.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                                
                                cell.lblStartFrom.text = "Start From"
                                cell.lblUpTo.text = "Up To"
                                cell.lblFrom.text = "Offer"
                                 cell.layoutIfNeeded()
                            }
                            else{
                                print(indexPath.row)
                                
                                let freebonus = promotionDetail.flatPromotionSlabDetails[indexPath.row - 1 ]
                                cell.lblStartFrom.text = String(freebonus.startSlabAmount)//freebonus.startSlabAmount
                                cell.lblUpTo.text = String(freebonus.endSlabAmount)
                                cell.lblFrom.text = String(freebonus.slabPercentage)
                            }
                            return cell
                            }else{
                                return UITableViewCell()
                            }
                        }
                        else if(promotionDetail.status == 1 || promotionDetail.status == 2){
                            //display status
                            if(promotionDetail.status == 1){
                                promocell.lblPromotionDetail.text = "Joined"
                            }
                            else if(promotionDetail.status == 2){
                                promocell.lblPromotionDetail.text = "Not Joined"
                            }
                            return promocell
                        }
                        else{
                            //finish
                            let cell = UITableViewCell.init()
                            return cell
                        }
                    }
                    else{
                        if( promotionDetail.freeBonusProductList.count > 0 ){
                            //products for bonus
                            let bonusProduct = promotionDetail.freeBonusProductList[indexPath.row]
                            let atrProName:NSMutableAttributedString = NSMutableAttributedString(string: bonusProduct.productName)
                            //bonusProduct.productName
                            atrProName.append(NSAttributedString(string: "\nQuantity:", attributes: [NSAttributedString.Key.font : UIFont(name: Common.kfontbold, size: 15) ?? .systemFont(ofSize: 15)]))
                            atrProName.append(NSAttributedString(string: String(bonusProduct.freeProductQty)))
                            promocell.lblPromotionDetail?.attributedText = atrProName
                            
                            return promocell
                        }
                        else if(promotionDetail.status == 1 || promotionDetail.status == 2){
                            //display status
                            if(promotionDetail.status == 1){
                                promocell.lblPromotionDetail.text = "Joined"
                            }
                            else if(promotionDetail.status == 2){
                                promocell.lblPromotionDetail.text = "Not Joined"
                            }
                            return promocell
                        }
                        else{
                            //finish
                            let cell = UITableViewCell.init()
                            return cell
                        }
                    }
            }
            }else if (promotionDetail.promodescription?.count ?? 0 == 0 && getContnetCount()  == 0)
            {
                if(promotionDetail.status == 1 || promotionDetail.status == 2){
                    //display status
                    if(promotionDetail.status == 1){
                        promocell.lblPromotionDetail.text = "Joined"
                    }
                    else if(promotionDetail.status == 2){
                        promocell.lblPromotionDetail.text = "Not Joined"
                    }
                    return promocell
                }
                else{
                    //finish
                    let cell = UITableViewCell.init()
                    return cell
                }
            }
            else if (promotionDetail.promodescription?.count ?? 0 == 0 || getContnetCount() == 0){
                if(promotionDetail.promotionType == Int(Common.PROMOTION_TYPE_FLAT))
                {
                    if(promotionDetail.flatPromotionSlabDetails.count > 0){
                        //display product for flat promotion
                        if    let cell = tableView.dequeueReusableCell(withIdentifier: "promotionvalidationcell", for: indexPath) as? PromotionValidationCell{
                        //cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: -10, bottom: 10, right: 10)
                        cell.viewStartFrom.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                        
                        cell.viewUpto.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                        cell.viewFrom.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                        
                        cell.viewStartFrom.layer.cornerRadius = 5
                        cell.viewUpto.layer.cornerRadius = 5
                        cell.viewFrom.layer.cornerRadius = 5
                        cell.selectionStyle = .none
                        if(indexPath.row == 0)
                        {
                            cell.lblStartFrom.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                            cell.lblUpTo.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                            cell.lblFrom.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                            
                            cell.lblStartFrom.text = "Start From"
                            cell.lblUpTo.text = "Up To"
                            cell.lblFrom.text = "Offer"
                             cell.layoutIfNeeded()
                        }
                        else{
                            print(indexPath.row)
                            
                            let freebonus = promotionDetail.flatPromotionSlabDetails[indexPath.row - 1 ]
                            cell.lblStartFrom.text = String(freebonus.startSlabAmount)//freebonus.startSlabAmount
                            cell.lblUpTo.text = String(freebonus.endSlabAmount)
                            cell.lblFrom.text = String(freebonus.slabPercentage)
                        }
                        return cell
                        }else{
                            return UITableViewCell()
                        }
                    }
                    else if(promotionDetail.status == 1 || promotionDetail.status == 2){
                        //display status
                        if(promotionDetail.status == 1){
                            promocell.lblPromotionDetail.text = "Joined"
                        }
                        else if(promotionDetail.status == 2){
                            promocell.lblPromotionDetail.text = "Not Joined"
                        }
                        return promocell
                    }
                    else{
                        //finish
                        let cell = UITableViewCell.init()
                        return cell
                    }
                }
                else{
                    if( promotionDetail.freeBonusProductList.count > 0 ){
                        //products for bonus
                        let bonusProduct = promotionDetail.freeBonusProductList[indexPath.row]
                        let atrProName:NSMutableAttributedString = NSMutableAttributedString(string: bonusProduct.productName)
                        //bonusProduct.productName
                        atrProName.append(NSAttributedString(string: "\nQuantity:", attributes: [NSAttributedString.Key.font : UIFont(name: Common.kfontbold, size: 15) ?? .systemFont(ofSize: 15)]))
                        atrProName.append(NSAttributedString(string: String(bonusProduct.freeProductQty)))
                        promocell.lblPromotionDetail?.attributedText = atrProName
                        
                        return promocell
                    }
                    else if(promotionDetail.status == 1 || promotionDetail.status == 2){
                        //display status
                        if(promotionDetail.status == 1){
                            promocell.lblPromotionDetail.text = "Joined"
                        }
                        else if(promotionDetail.status == 2){
                            promocell.lblPromotionDetail.text = "Not Joined"
                        }
                        return promocell
                    }
                    else{
                        //finish
                        let cell = UITableViewCell.init()
                        return cell
                    }
                }
            }
            
            else{
                //finish
                let cell = UITableViewCell.init()
                return cell
            }
            
        }
        else if (indexPath.section == 6){
            
            if(promotionDetail.promodescription?.count ?? 0 > 0 && getContnetCount() > 0 && promotionDetail.promotionProductList.count > 0){
                
                if(promotionDetail.promotionType == Int(Common.PROMOTION_TYPE_FLAT)){
                   //check type of promotion
                        if(promotionDetail.flatPromotionSlabDetails.count > 0){
                            //display slab
                            if   let cell = tableView.dequeueReusableCell(withIdentifier: "promotionvalidationcell", for: indexPath) as? PromotionValidationCell{
                            //cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: -10, bottom: 10, right: 10)
                            cell.viewStartFrom.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                            
                            cell.viewUpto.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                            cell.viewFrom.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
                            
                            cell.viewStartFrom.layer.cornerRadius = 5
                            cell.viewUpto.layer.cornerRadius = 5
                            cell.viewFrom.layer.cornerRadius = 5
                            cell.selectionStyle = .none
                            if(indexPath.row == 0)
                            {
                                cell.lblStartFrom.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                                cell.lblUpTo.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                                cell.lblFrom.font = UIFont(name: Common.kfontbold, size: ktitleFont)
                                
                                cell.lblStartFrom.text = "Start From"
                                cell.lblUpTo.text = "Up To"
                                cell.lblFrom.text = "Offer"
                                 cell.layoutIfNeeded()
                            }
                            else{
                                print(indexPath.row)
                                
                                let freebonus = promotionDetail.flatPromotionSlabDetails[indexPath.row - 1 ]
                                cell.lblStartFrom.text = String(freebonus.startSlabAmount)//freebonus.startSlabAmount
                                cell.lblUpTo.text = String(freebonus.endSlabAmount)
                                cell.lblFrom.text = String(freebonus.slabPercentage)
                            }
                            return cell
                            }else{
                                return UITableViewCell()
                            }
                        }else if (promotionDetail.status == 1 || promotionDetail.status
                            == 2){
                            if(promotionDetail.status == 1){
                                promocell.lblPromotionDetail.text = "Joined"
                            }
                            else if(promotionDetail.status == 2){
                                promocell.lblPromotionDetail.text = "Not Joined"
                            }
                            return promocell
                        }
                        else{
                            let cell = UITableViewCell.init()
                            return cell
                        }
                
                }else {
                    if( promotionDetail.freeBonusProductList.count > 0 ){
                        //products for bonus
                        let bonusProduct = promotionDetail.freeBonusProductList[indexPath.row]
                        let atrProName:NSMutableAttributedString = NSMutableAttributedString(string: bonusProduct.productName)
                        //bonusProduct.productName
                        atrProName.append(NSAttributedString(string: "\nQuantity:", attributes: [NSAttributedString.Key.font : UIFont(name: Common.kfontbold, size: 15) ?? .systemFont(ofSize: 15)]))
                        atrProName.append(NSAttributedString(string: String(bonusProduct.freeProductQty)))
                        promocell.lblPromotionDetail?.attributedText = atrProName
                        
                        return promocell
                    }
                    else if(promotionDetail.status == 1 || promotionDetail.status == 2){
                        //display status
                        if(promotionDetail.status == 1){
                            promocell.lblPromotionDetail.text = "Joined"
                        }
                        else if(promotionDetail.status == 2){
                            promocell.lblPromotionDetail.text = "Not Joined"
                        }
                        return promocell
                    }
                    else{
                        //finish
                        let cell = UITableViewCell.init()
                        return cell
                    }
                }
            }else if (getContnetCount() == 0 && promotionDetail.promodescription?.count == 0){
                if(promotionDetail.status == 2){
                    let justifiObj = self.getJustificationThroughID(ID: promotionDetail.justificationID)
                    promocell.lblPromotionDetail.text = justifiObj.strJustification
                    return promocell
                }else{
                    //finish
                    let cell = UITableViewCell.init()
                    return cell
                }
            }
            else if (getContnetCount() == 0 || promotionDetail.promodescription?.count == 0){
                if(promotionDetail.status == 1 || promotionDetail.status == 2){
                    //display status
                    if(promotionDetail.status == 1){
                        promocell.lblPromotionDetail.text = "Joined"
                    }
                    else if(promotionDetail.status == 2){
                        promocell.lblPromotionDetail.text = "Not Joined"
                    }
                    return promocell
                }
                else{
                    //finish
                    let cell = UITableViewCell.init()
                    return cell
                }
            }
            else{
                //product list nill
                let cell = UITableViewCell.init()
                return cell
            }
        }else if (indexPath.section == 7){
            if(promotionDetail.promotionType == Int(Common.PROMOTION_TYPE_FLAT)){
               // for flat promotion
                if (promotionDetail.promodescription?.count ?? 0 > 0 && getContnetCount() > 0 && promotionDetail.promotionProductList.count > 0 && promotionDetail.flatPromotionSlabDetails.count > 0){
                    if(promotionDetail.status == 1 || promotionDetail.status == 2){
                        //display status
                        if(promotionDetail.status == 1){
                            promocell.lblPromotionDetail.text = "Joined"
                        }
                        else if(promotionDetail.status == 2){
                            promocell.lblPromotionDetail.text = "Not Joined"
                        }
                        return promocell
                    }
                    else{
                        //finish
                        let cell = UITableViewCell.init()
                        return cell
                    }
                }else if (promotionDetail.promodescription?.count ?? 0 == 0 || getContnetCount() == 0){
                    if(promotionDetail.status == 2){
                        let justifiObj = self.getJustificationThroughID(ID: promotionDetail.justificationID)
                        promocell.lblPromotionDetail.text = justifiObj.strJustification
                        return promocell
                    }else{
                        let cell = UITableViewCell.init()
                        return cell
                    }
                }
                else if (getContnetCount() == 0 || promotionDetail.promodescription?.count == 0){
                    if(promotionDetail.status == 1){
                        let cell = UITableViewCell.init()
                        return cell
                    }
                    else if(promotionDetail.status == 2){
                        let justifiObj = self.getJustificationThroughID(ID: promotionDetail.justificationID)
                        promocell.lblPromotionDetail.text = justifiObj.strJustification
                        return promocell
                    }else{
                        let cell = UITableViewCell.init()
                        return cell
                    }
                   
                }else{
                    let cell = UITableViewCell.init()
                    return cell
                }
                
            }else{
              // for bonus promotion
                if (promotionDetail.promodescription?.count ?? 0 > 0 && getContnetCount() > 0 && promotionDetail.promotionProductList.count > 0 && promotionDetail.freeBonusProductList.count > 0){
                    if(promotionDetail.status == 1 || promotionDetail.status == 2){
                        //display status
                        if(promotionDetail.status == 1){
                            promocell.lblPromotionDetail.text = "Joined"
                        }
                        else if(promotionDetail.status == 2){
                            promocell.lblPromotionDetail.text = "Not Joined"
                        }
                        return promocell
                    }
                    else{
                        //finish
                        let cell = UITableViewCell.init()
                        return cell
                    }
                    
                }else if (getContnetCount() == 0 || promotionDetail.promodescription?.count == 0){
                    if(promotionDetail.status == 1){
                        let cell = UITableViewCell.init()
                        return cell
                    }
                    else if(promotionDetail.status == 2){
                        let justifiObj = self.getJustificationThroughID(ID: promotionDetail.justificationID)
                        promocell.lblPromotionDetail.text = justifiObj.strJustification
                        return promocell
                    }
                    else{
                        let cell = UITableViewCell.init()
                        return cell
                    }
                }else{
                    let cell = UITableViewCell.init()
                    return cell
                }
            
            }
           
        }
        else if (indexPath.section == 8){
            if(promotionDetail.promotionType == Int(Common.PROMOTION_TYPE_FLAT)){
                // for flat promotion
                if (promotionDetail.promodescription?.count ?? 0 > 0 && getContnetCount() > 0 && promotionDetail.promotionProductList.count > 0 && promotionDetail.flatPromotionSlabDetails.count > 0 && promotionDetail.status == 2){
                    let justifiObj = self.getJustificationThroughID(ID: promotionDetail.justificationID)
                    promocell.lblPromotionDetail.text = justifiObj.strJustification
                    return promocell
                }else{
                    let cell = UITableViewCell.init()
                    return cell
                }
            }else{
                //bonus promotion
                if (promotionDetail.promodescription?.count ?? 0 > 0 && getContnetCount() > 0 && promotionDetail.promotionProductList.count > 0 && promotionDetail.freeBonusProductList.count > 0 && promotionDetail.status == 2){
                    let justifiObj = self.getJustificationThroughID(ID: promotionDetail.justificationID)
                    promocell.lblPromotionDetail.text = justifiObj.strJustification
                    return promocell
                }else{
                    let cell = UITableViewCell.init()
                    return cell
                }
            }
           
        }
        else{
            let cell = UITableViewCell.init()
            return cell
        }
       }else{
            return UITableViewCell()
        }
        

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print(section)
        print(ArrTitle[section])
        return ArrTitle[section]
     
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if(ArrTitle[section] == " "){
          
            let viewEmpty = UIView.init(frame: CGRect.init())
            return viewEmpty
        }
        else{
            let coverView:UIView = UIView()
        let view:UIView = UIView.init(frame: CGRect.init(x: 10, y: 5, width: tableView.frame.size.width-20, height: 40))
        view.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
        view.layer.cornerRadius = 5
        let lblTitle = UILabel.init(frame: CGRect.init(x: Int(view.frame.origin.x) , y: Int(view.frame.origin.y), width: Int(view.frame.size.width - 5), height:Int(view.frame.size.height-10)))
           view.addSubview(lblTitle)
            print(section)
            lblTitle.font = UIFont(name: Common.kfontbold, size: 17)
            lblTitle.text = ArrTitle[section]
        coverView.addSubview(view)
        return coverView
    }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
           // if(Arrcontent.contain cell.lblPromotionDetail.text)
        if(getContnetCount()>0){
            if let promocell = tableView.cellForRow(at: indexPath)  as? PromotionLineDetail{
            print(promocell.lblPromotionDetail.text ?? " ")
            if(ArrContnetCaption.contains(promocell.lblPromotionDetail.text ?? "")){
                
               
                displayContnet(StrURL: ArrContnetURL[indexPath.row] as String)
               
            }
}
        }
        else{
            print(getContnetCount())
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       // return view.frame.size.height
        if(ArrTitle[section] == " "){
            return 0
        }
        else{
        return 40
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.playerViewController.dismiss(animated: true)
    }
   
//    func tableView(_ tableView:UITableView , estimatedRowHeight  index:IndexPath) -> CGFloat {
//        return 40
//    }
//
//    func tableView(_ tableView:UITableView , rowHeight index:IndexPath) -> CGFloat {
//        return tableView.contentSize.height
//    }
    
    
}
extension PromotionDetail:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ArrJustification.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let justification = ArrJustification[row]
        return justification.strJustification
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        selectedJustification = ArrJustification[row]
    
    }
    
}
extension PromotionDetail:UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("loading start")
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
       print(error)
        webView.removeFromSuperview()
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
     //   webView.frame = newView.frame
//        NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView
//            , attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0).isActive = true
    
    }
}
//class SomeClass : NSObject, URLSessionTaskDelegate, URLSessionDownloadDelegate {
//
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        if totalBytesExpectedToWrite > 0 {
//            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
//            debugPrint("Progress \(downloadTask) \(progress)")
//        }
//    }
//
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        debugPrint("Download finished: \(location)")
//        try? FileManager.default.removeItem(at: location)
//    }
//
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        debugPrint("Task completed: \(task), error: \(error)")
//    }
//
//}
