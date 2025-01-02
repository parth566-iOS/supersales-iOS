//
//  PromotionContainer.swift
//  SuperSales
//
//  Created by Apple on 07/06/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import UIKit
import AVFoundation
import CarbonKit
class PromotionContainer: BaseViewController {

    var isplanVisit:Bool!
    var visitType:VisitType!
    var objPlannedVisit:PlannVisit!
//    var objUnPlannedVisitPromotion:UnplannedVisit!
    var selectedstr:String!
//    var cameraView: CameraView!
//    // AV capture session and dispatch queue
//    let session = AVCaptureSession()
//    let sessionQueue = DispatchQueue(label: AVCaptureSession.self.description(), attributes: [], target: nil)
   
   
   
    @IBOutlet weak var toolBarPromotion: UIToolbar!
    @IBOutlet weak var targetViewPromotion: UIView!
    
    var itempromotions:Array<String>!
    var carbonswipenavigationobj:CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
    // View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.showNavBar1()
        
       

        itempromotions = ["Promotion","Entitlement"]
        carbonswipenavigationobj = CarbonTabSwipeNavigation(items:itempromotions, toolBar:self.toolBarPromotion , delegate:self)
        self.title = NSLocalizedString("Promotion", comment: "")
       carbonswipenavigationobj.insert(intoRootViewController: self, andTargetView: self.targetViewPromotion)

      self.style()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
   
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func style(){
//        let color:UIColor = Common().UIColorFromRGB(rgbValue: 0xFFDCD62)
//        let font = UIFont.init(name: Common.kfontbold, size: 15)
    carbonswipenavigationobj.setIndicatorColor(Common().UIColorFromRGB(rgbValue: 0x009689))
      //  carbonswipenavigationobj.setSelectedColor(color, font: font ?? UIFont.systemFont(ofSize: 15))
        carbonswipenavigationobj.setSelectedColor(UIColor().colorFromHexCode(rgbValue: 0x2B3894) , font: UIFont.boldSystemFont(ofSize: 15))
        self.toolBarPromotion.barTintColor = UIColor.Appskybluecolor
    
    carbonswipenavigationobj.carbonSegmentedControl?.setWidth((UIScreen.main.bounds.size.width)/2 , forSegmentAt: 0)
      
    //    ca
        var width = 1.0
      //  let targetviewwidth = self.targetView.frame.size.width
        if((itempromotions?.count)! > 3){
            width = Double((self.targetViewPromotion.frame.size.width/3.0))
        }
        else{
            width=Double(Int(UIScreen.main.bounds.size.width) / ((itempromotions?.count)!))
            print("count of header is = \(itempromotions.count) items \(itempromotions) width = \(width)")
        }
        for index in itempromotions! {
          //  print(items?.firstIndex(of: index));
          carbonswipenavigationobj.carbonSegmentedControl?.setWidth(CGFloat(width), forSegmentAt: (itempromotions?.firstIndex(of: index))!)
        }
        let boldfont = UIFont.init(name: Common.kFontMedium, size: 15)
      
        
        carbonswipenavigationobj.setNormalColor(UIColor.white, font: boldfont ?? UIFont.systemFont(ofSize: 15))
    carbonswipenavigationobj.carbonTabSwipeScrollView.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: true)
        toolBarPromotion.barTintColor = UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1.0)
        toolBarPromotion.tintColor =  UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1.0)
    }


}
extension PromotionContainer:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
     
        selectedstr = itempromotions![Int(arc4random_uniform(UInt32(index)))]
        selectedstr = itempromotions[Int(index)]
        
   
        if(selectedstr == "Promotion"){
       
       
            if let promoListObj =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePromotion, classname: Constant.PromotionListView) as? PromotionList{
        promoListObj.visitType =  self.visitType
      //  promoListObj.ObjUnplannedVisit = self.objUnPlannedVisitPromotion
        promoListObj.objPlannedVisit = self.objPlannedVisit
        promoListObj.selecedstrForList = "Promotion"
            print(selectedstr)

        return promoListObj
            }else{
          return      UIViewController()
            }
        }
        else{
            if  let promoListObj =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePromotion, classname: Constant.PromotionListView) as? PromotionList{
         
             promoListObj.visitType =  self.visitType
            promoListObj.objPlannedVisit = self.objPlannedVisit
           promoListObj.selecedstrForList = "Entitlement"
            print(selectedstr)
            
            return promoListObj
            }else{
             return   UIViewController()
            }
        }
        
        
            
//            return INSTANTIATE_With_SB("Visit","promotionlsit")

    //    }
    }
    
    /*
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     _MenuTabs *selectedMenu = (_MenuTabs *)[items objectAtIndex:index];
     switch (selectedMenu.menuID) {
     case 18:
     return [storyboard instantiateViewControllerWithIdentifier:@"planvisit"];
     case 19:
     return [storyboard instantiateViewControllerWithIdentifier:@"unplanvisit"];
     case 20:
     return [storyboard instantiateViewControllerWithIdentifier:@"visitapproval"];
     default:
     return [storyboard instantiateViewControllerWithIdentifier:@"jointvisitlist"];
     }
     */
    
    
}

class CameraView: UIView {
    override class var layerClass: AnyClass {
        get {
            return AVCaptureVideoPreviewLayer.self
        }
    }
    override var layer: AVCaptureVideoPreviewLayer {
        get {
            return super.layer as? AVCaptureVideoPreviewLayer ?? AVCaptureVideoPreviewLayer()
        }
    }
}
extension PromotionContainer: AVCaptureMetadataOutputObjectsDelegate {
    // Camera view
   
//    override func loadView() {
//        cameraView = CameraView()
//        view = cameraView
//    }
//     func loadBarcode() {
//
//        session.beginConfiguration()
//        let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
//        //AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//        if (videoDevice != nil) {
//            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!)
//            if (videoDeviceInput != nil) {
//                if (session.canAddInput(videoDeviceInput!)) {
//                    session.addInput(videoDeviceInput!)
//                }
//            }
//            let metadataOutput = AVCaptureMetadataOutput()
//            if (session.canAddOutput(metadataOutput)) {
//                session.addOutput(metadataOutput)
//                metadataOutput.metadataObjectTypes = [
//                    AVMetadataObject.ObjectType.ean13,
//                    AVMetadataObject.ObjectType.qr
//                ]
//                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            }
//        }
//        session.commitConfiguration()
//        cameraView.layer.session = session
//        cameraView.layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        // Set initial camera orientation
//        let videoOrientation: AVCaptureVideoOrientation
//        switch UIApplication.shared.statusBarOrientation {
//        case .portrait:
//            videoOrientation = .portrait
//        case .portraitUpsideDown:
//            videoOrientation = .portraitUpsideDown
//        case .landscapeLeft:
//            videoOrientation = .landscapeLeft
//        case .landscapeRight:
//            videoOrientation = .landscapeRight
//        default:
//            videoOrientation = .portrait
//        }
//        cameraView.layer.connection?.videoOrientation = videoOrientation
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Start AV capture session
//        sessionQueue.async {
//            self.session.startRunning()
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop AV capture session
//        sessionQueue.async {
//            self.session.stopRunning()
//        }
    }
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        // Update camera orientation
//        let videoOrientation: AVCaptureVideoOrientation
//        switch UIDevice.current.orientation {
//        case .portrait:
//            videoOrientation = .portrait
//        case .portraitUpsideDown:
//            videoOrientation = .portraitUpsideDown
//        case .landscapeLeft:
//            videoOrientation = .landscapeRight
//        case .landscapeRight:
//            videoOrientation = .landscapeLeft
//        default:
//            videoOrientation = .portrait
//        }
//        cameraView.layer.connection?.videoOrientation = videoOrientation
//    }
//    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
//        // Display barcode value
//        if (metadataObjects.count > 0 && metadataObjects.first is AVMetadataMachineReadableCodeObject) {
//            let scan = metadataObjects.first as! AVMetadataMachineReadableCodeObject
//            let alertController = UIAlertController(title: "Barcode Scanned", message: scan.stringValue, preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
//            present(alertController, animated: true, completion: nil)
//        }
//    }
}
