//
//  AddPicture.swift
//  SuperSales
//
//  Created by Apple on 14/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
 

class AddPicture: BaseViewController {
    // swiftlint:disable line_length
    
    @IBOutlet weak var collectionOfImage: UICollectionView!
    var visitType:VisitType!
    var planVisit:PlannVisit?
    var unplanVisit:UnplannedVisit?
    var visitId:NSNumber!
    var arrOfImages:[ViewPictureData]!
    var browser:IDMPhotoBrowser? = IDMPhotoBrowser()
    var arrImg:[IDMPhoto]!
    var arrOfUrl:[URL]!
    override func viewDidLoad() {
    super.viewDidLoad()
       self.setData()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Method
    func setData(){
        collectionOfImage.delegate = self
        collectionOfImage.dataSource = self
        if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory || visitType == VisitType.manualvisit){
            if( planVisit?.isPictureAvailable == 1){
                 visitId = NSNumber.init(value:planVisit?.iD ?? 0)
                 arrOfImages = [ViewPictureData]()
                self.getImages()
               
               
            }else{
                arrOfImages = [ViewPictureData]()
            }
        }else{
            if(unplanVisit?.isPictureAvailable == 1){
                  visitId = NSNumber.init(value:unplanVisit?.localID ?? 0)
                 arrOfImages = [ViewPictureData]()
                self.getImages()
              
               
            }else{
                 arrOfImages = [ViewPictureData]()
            }
        }
    }
    
    func getImages(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
var param = Common.returndefaultparameter()
    param["VisitID"] =  visitId
self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetVisitUploadImages, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
SVProgressHUD.dismiss()
if(status.lowercased() == Constant.SucessResponseFromServer){
if(responseType == ResponseType.arr){
                    let arrofpicturedata = arr as? [[String:Any]] ?? [[String:Any]]()
                    self.arrImg = [IDMPhoto]()
    self.arrOfUrl = [URL]()
if(arrofpicturedata.count > 0){
for pic in arrofpicturedata{
let visitImage = ViewPictureData().initwithdic(dict: pic)
self.arrOfImages.append(visitImage)
    if let strurlofimg = visitImage.imagePath as? String{
        let urlofimage = URL.init(string:strurlofimg.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "" ?? "")//URL.init(fileURLWithPath: strurlofimg)URLQueryAllowedCharacterSet
    print(urlofimage)
        //IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
        let idmphoto = IDMPhoto.init(url:urlofimage)
        self.arrImg.append(idmphoto!)
      //  self.arrOfUrl.append(urlofimage)
    }
                    }
    //IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:[obj.imagePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
  //  self.arrImg = IDMPhoto.photos(withURLs: self.arrImg) as? [IDMPhoto]
    self.browser = IDMPhotoBrowser.init(photos: self.arrImg)
    
    self.browser?.delegate = self
    self.browser?.displayCounterLabel = true
    self.browser?.displayActionButton = false
    self.browser?.autoHideInterface = false
    self.browser?.dismissOnTouch = false
    self.browser?.displayArrowButton = false
    self.browser?.displayActionButton = false
    self.browser?.disableVerticalSwipe = true
  //  self.browser.
                    }else{
                        
                    }
        self.collectionOfImage.reloadData()
                }
            }else if(error.code == 0){
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            }else{
               Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
    }

}
extension AddPicture:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(visitType == VisitType.planedvisitHistory || visitType == VisitType.coldcallvisitHistory){
        return arrOfImages.count
        }else{
        return arrOfImages.count+1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewimagecell", for: indexPath) as? ViewImageCell{
        if( (arrOfImages.count ==  0) && (!(visitType == VisitType.planedvisitHistory || visitType == VisitType.coldcallvisitHistory))){
             cell.imgVisit.image = UIImage.init(named:"icon_add_picture")
        }
        else
        {
            if((visitType == VisitType.planedvisitHistory || visitType == VisitType.coldcallvisitHistory)){
                let visitpic = arrOfImages[indexPath.row]
                                          
                                                  
cell.imgVisit.sd_setImage(with:URL.init(string:visitpic.imagePath?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "") , placeholderImage: UIImage.init(named: "icon_placeholder_user"), options: []) { (img, erro, SDImageCacheType, url) in
                                             //URLQueryAllowedCharacterSet
                    if let err = erro{
Utils.toastmsg(message:err.localizedDescription,view: self.view)
                    }
                                          }
                
                
            }else{
               if(indexPath.row < arrOfImages.count){
                        
                let visitpic = arrOfImages[indexPath.row]
                                     
                                cell.imgVisit.sd_setImage(with:URL.init(string:visitpic.imagePath?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "") , placeholderImage: nil, options: []) { (img, error, SDImageCacheType, url) in
                                        
                                     }
                               
                               } else {
                     cell.imgVisit.image = UIImage.init(named:"icon_add_picture")
            }
        }
        }
                        // cell.imgVisit.image
//        }else if((indexPath.row == arrOfImages.count + 1) && (!(visitType == VisitType.planedvisitHistory || visitType == VisitType.coldcallvisitHistory))){
//
//             cell.imgVisit.image = UIImage.init(named:"icon_add_picture")
//        }else {
//            let visitpic = arrOfImages[indexPath.row - 1]
//        cell.imgVisit.sd_setImage(with:URL.init(string:visitpic.imagePath?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "") , placeholderImage: nil, options: []) { (img, error, SDImageCacheType, url) in
//                print("image downloaded")
//
//            }
//        }
       // }
        return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath)   as? ViewImageCell {
        if(cell.imgVisit.image == UIImage.init(named:"icon_add_picture")){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                imagePicker.sourceType = .camera
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            else{
           Utils.toastmsg(message:"Camera is not present",view: self.view)
            }
        }else{
//            [browser setInitialPageIndex:indexPath.row];
//               [self presentViewController:browser animated:YES completion:nil];
            
           
          
                self.browser?.setInitialPageIndex(UInt(indexPath.row))
             
                if let idmbrowser =  self.browser as? IDMPhotoBrowser{
                    print(idmbrowser.photo(at: UInt(indexPath.row)))
                    idmbrowser.scaleImage = idmbrowser.photo(at: UInt(indexPath.row)) as? UIImage
            self.present(idmbrowser, animated: true, completion: nil)
               
            
        }
        }
        }
    }
    //layout
    
}
extension AddPicture: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionOfImage.frame.width/2 - 10), height: (collectionOfImage.frame.width/2 - 10))
    }
}

extension AddPicture :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true
            , completion:   nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        //        imgUploadByUser.backgroundColor = .black
        //        activityIndicator.startAnimating()
       
        var param = Common.returndefaultparameter()
        if let currentcoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
        
        param["lattitude"] = currentcoordinate.latitude
        param["longitude"] = currentcoordinate.longitude
        }else{
            param["lattitude"] = 0.0
            param["longitude"] = 0.0
        }
        param["createdBy"] = self.activeuser?.userID
        if(visitType == VisitType.planedvisit || visitType == VisitType.beatplan){
            param["visitID"] = planVisit?.iD
        }else{
        param["visitID"] = unplanVisit?.localID
        }
        param["companyID"] = self.activeuser?.company?.iD
    if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
           {
         //  arrOfImages.append(chosenImage)
    self.apihelper.addunplanVisitpostWithMultipartBody(fullUrl: ConstantURL.kWSUrlUploadVisitImage, img: chosenImage, imgparamname: "visitImage", param: param)
        {
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
          in
        SVProgressHUD.dismiss()
    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
  
    if(self.visitType == VisitType.planedvisit || self.visitType == VisitType.manualvisit){
                self.planVisit?.isPictureAvailable = 1
                self.planVisit?.managedObjectContext?.mr_save({ (localcontext) in
                    print("saving")
                }, completion: { (status, error) in
                    print(error?.localizedDescription ?? "no error")
                    print("saved , \(self.planVisit?.isPictureAvailable)")
                    self.setData()
                })
        
            }else{
                self.unplanVisit?.isPictureAvailable = 1
                self.setData()
            }
            
        }
        }
        // self.imgUploadByUser.contentMode = .scaleAspectFit
        
        
        //        self.imgUploadByUser.image = Common.createImage(withImage: chosenImage, forSize: CGSize.init(width: chosenImage.size.width > 200 ? 200 : chosenImage.size.width , height: chosenImage.size.height > 200 ? 200 :  chosenImage.size.height))
        //        self.UploadRequest()
        
        dismiss(animated:true, completion: nil)
        
    }
}
extension AddPicture:IDMPhotoBrowserDelegate{
    func photoBrowser(_ photoBrowser: IDMPhotoBrowser!, didShowPhotoAt index: UInt) {
        let pic = arrOfImages![Int(index)]
        if let idmphoto = browser!.photo(at: index) as? IDMPhoto{
            if (pic.addres) != nil {
                var strtis = ""
                if let strtemp = Utils.getDateBigFormatToDefaultFormat(date: pic.timeStamp! , format: "yyyy/MM/dd HH:mm:ss"){
    strtis = strtemp
                }
idmphoto.caption  = String.init(format:"%@\n%@\n%@: %f %@: %f",Utils.getDatestringWithGMT(gmtDateString:strtis, format: "dd-MM-yyyy hh:mm a") ,pic.addres!,NSLocalizedString("latitude", comment:""),pic.lattitude ?? "0.00",NSLocalizedString("longitude", comment:""),pic.longitude ?? "0.00")
        }else{
            //[Utils getDatestringWithGMT:[Utils getDateBigFormatToDefaultFormat:obj.timeStamp andFormat:@"yyyy/MM/dd HH:mm:ss"] andFormat:@"dd-MM-yyyy hh:mm a"]
        
        }
        }else{
            
        }
    }
    
    
    func photoBrowser(_ photoBrowser: IDMPhotoBrowser!, imageFailed index: UInt, imageView: IDMTapDetectingImageView!) {
        print("image failed")
    }
}
