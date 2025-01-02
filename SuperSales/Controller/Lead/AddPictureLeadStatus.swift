//
//  AddPictureLeadStatus.swift
//  SuperSales
//
//  Created by Apple on 17/06/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

class AddPictureLeadStatus: BaseViewController {

    public static var arrOfImageWithStatus:[UIImage]! = [UIImage]()
    var arrOfTempImage:[UIImage] = [UIImage]()
    var isimage1:Bool! = false
    var isimage2:Bool! = false
    var isimage3:Bool! =  false
    var isimage4:Bool! = false
    
    
    @IBOutlet weak var imgLeadStatus: UIImageView!
    
    @IBOutlet weak var lblStatusUpdate: UILabel!
    
    @IBOutlet weak var lblLeadStatus: UILabel!
    @IBOutlet weak var imgLeadStatus1: UIImageView!
    @IBOutlet weak var imgLeadStatus2: UIImageView!
    @IBOutlet weak var imgLeadStatus3: UIImageView!
    @IBOutlet weak var imgLeadStatus4: UIImageView!
    
    @IBOutlet weak var vwUpdateStatus: UIView!
    
    @IBOutlet weak var vwLeadStatus: UIView!
    
    
    @IBOutlet weak var btnAddPicture: UIButton!
    
    @IBOutlet weak var btnOK: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - Method
    func setUI(){
        
        self.setleftbtn(btnType: BtnLeft.back, navigationItem:  self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        btnAddPicture.setbtnFor(title: "ADD PICTURE", type: Constant.kPositive)
        btnOK.setbtnFor(title: "OK", type: Constant.kPositive)
        self.title = "Add Picture"
        
        arrOfTempImage = AddPictureLeadStatus.arrOfImageWithStatus
        print("arr of temp image count = \(arrOfTempImage.count) ")
        if(arrOfTempImage.count == 0){
            lblLeadStatus.isHidden = true
            lblStatusUpdate.isHidden = true
            imgLeadStatus.isHidden = true
            imgLeadStatus1.isHidden = true
            imgLeadStatus2.isHidden = true
            imgLeadStatus3.isHidden = true
            imgLeadStatus4.isHidden = true
        }else if(arrOfTempImage.count > 0 && UpdateLeadStatus.imageExistForLeadStatus == true){
            imgLeadStatus.image = UpdateLeadStatus.imageForLead
            if(arrOfTempImage.count == 1){
            imgLeadStatus.image =  AddPictureLeadStatus.arrOfImageWithStatus[0]
            imgLeadStatus.isHidden   =   false
            lblStatusUpdate.isHidden =   false
            lblLeadStatus.isHidden   =   true
            imgLeadStatus1.isHidden  =   true
            imgLeadStatus2.isHidden  =    true
            imgLeadStatus3.isHidden  =    true
            imgLeadStatus4.isHidden  =    true
            }else if(arrOfTempImage.count == 2){
                imgLeadStatus.image =  AddPictureLeadStatus.arrOfImageWithStatus[0]
                imgLeadStatus1.image =  AddPictureLeadStatus.arrOfImageWithStatus[1]
                lblLeadStatus.isHidden = false
                imgLeadStatus.isHidden = false
                lblStatusUpdate.isHidden = false
                imgLeadStatus1.isHidden = false
                imgLeadStatus2.isHidden = true
                imgLeadStatus3.isHidden = true
                imgLeadStatus4.isHidden = true
            }else if(arrOfTempImage.count == 3){
                imgLeadStatus.image =  AddPictureLeadStatus.arrOfImageWithStatus[0]
                imgLeadStatus1.image =  AddPictureLeadStatus.arrOfImageWithStatus[1]
                imgLeadStatus2.image = AddPictureLeadStatus.arrOfImageWithStatus[2]
                
                lblLeadStatus.isHidden = false
                imgLeadStatus.isHidden = false
                lblStatusUpdate.isHidden = false
                imgLeadStatus1.isHidden = false
                imgLeadStatus2.isHidden = false
                imgLeadStatus3.isHidden = true
                imgLeadStatus4.isHidden = true
            }else if(arrOfTempImage.count == 4){
                imgLeadStatus.image =  AddPictureLeadStatus.arrOfImageWithStatus[0]
                imgLeadStatus1.image =  AddPictureLeadStatus.arrOfImageWithStatus[1]
                imgLeadStatus2.image = AddPictureLeadStatus.arrOfImageWithStatus[2]
                imgLeadStatus3.image = AddPictureLeadStatus.arrOfImageWithStatus[3]
                lblLeadStatus.isHidden = false
                imgLeadStatus.isHidden = false
                lblStatusUpdate.isHidden = false
                imgLeadStatus1.isHidden = false
                imgLeadStatus2.isHidden = false
                imgLeadStatus3.isHidden = false
                imgLeadStatus4.isHidden = true
            }else if(arrOfTempImage.count == 5){
                imgLeadStatus.image =  AddPictureLeadStatus.arrOfImageWithStatus[0]
                imgLeadStatus1.image =  AddPictureLeadStatus.arrOfImageWithStatus[1]
                imgLeadStatus2.image = AddPictureLeadStatus.arrOfImageWithStatus[2]
                imgLeadStatus3.image = AddPictureLeadStatus.arrOfImageWithStatus[3]
                imgLeadStatus4.image = AddPictureLeadStatus.arrOfImageWithStatus[4]
                lblLeadStatus.isHidden = false
                imgLeadStatus.isHidden = false
                lblStatusUpdate.isHidden = false
                imgLeadStatus1.isHidden = false
                imgLeadStatus2.isHidden = false
                imgLeadStatus3.isHidden = false
                imgLeadStatus4.isHidden = false
            }
        }else{
            if(arrOfTempImage.count == 1){
                imgLeadStatus1.image =  AddPictureLeadStatus.arrOfImageWithStatus[0]
            lblLeadStatus.isHidden = false
            imgLeadStatus.isHidden = true
            lblStatusUpdate.isHidden = true
            imgLeadStatus1.isHidden = false
            imgLeadStatus2.isHidden = true
            imgLeadStatus3.isHidden = true
            imgLeadStatus4.isHidden = true
            }else if(arrOfTempImage.count == 2){
                imgLeadStatus1.image =  AddPictureLeadStatus.arrOfImageWithStatus[0]
                imgLeadStatus2.image =  AddPictureLeadStatus.arrOfImageWithStatus[1]
                lblLeadStatus.isHidden = false
                imgLeadStatus.isHidden = true
                lblStatusUpdate.isHidden = true
                imgLeadStatus1.isHidden = false
                imgLeadStatus2.isHidden = false
                imgLeadStatus3.isHidden = true
                imgLeadStatus4.isHidden = true
            }else if(arrOfTempImage.count == 3){
                imgLeadStatus1.image =  AddPictureLeadStatus.arrOfImageWithStatus[0]
                imgLeadStatus2.image =  AddPictureLeadStatus.arrOfImageWithStatus[1]
                imgLeadStatus3.image = AddPictureLeadStatus.arrOfImageWithStatus[2]
                lblLeadStatus.isHidden =  false
                imgLeadStatus.isHidden =  true
                lblStatusUpdate.isHidden = true
                imgLeadStatus1.isHidden = false
                imgLeadStatus2.isHidden = false
                imgLeadStatus3.isHidden = false
                imgLeadStatus4.isHidden = true
            }else if(arrOfTempImage.count == 4){
                imgLeadStatus1.image =  AddPictureLeadStatus.arrOfImageWithStatus[0]
                imgLeadStatus2.image =  AddPictureLeadStatus.arrOfImageWithStatus[1]
                imgLeadStatus3.image = AddPictureLeadStatus.arrOfImageWithStatus[2]
                imgLeadStatus4.image = AddPictureLeadStatus.arrOfImageWithStatus[3]
                
                lblLeadStatus.isHidden = false
                imgLeadStatus.isHidden = true
                lblStatusUpdate.isHidden = true
                imgLeadStatus1.isHidden = false
                imgLeadStatus2.isHidden = false
                imgLeadStatus3.isHidden = false
                imgLeadStatus4.isHidden = false
            }
        }
//        arrOfTempImage = [UIImage]()
//        for img in arrOfTempImage{
//            arrOfTempImage.append(img)
//        }
//        if(arrOfTempImage.count > 0){
//            imgLeadStatus.image = arrOfTempImage[0]
//        }else if(arrOfTempImage.count > 1){
//            imgLeadStatus.image = arrOfTempImage[0]
//            imgLeadStatus1.image = arrOfTempImage[1]
//        }else if(arrOfTempImage.count > 2){
//            imgLeadStatus.image = arrOfTempImage[0]
//            imgLeadStatus1.image = arrOfTempImage[1]
//            imgLeadStatus2.image = arrOfTempImage[2]
//        }else if(arrOfTempImage.count > 3){
//            imgLeadStatus.image = arrOfTempImage[0]
//            imgLeadStatus1.image = arrOfTempImage[1]
//            imgLeadStatus2.image = arrOfTempImage[2]
//            imgLeadStatus3.image = arrOfTempImage[3]
//        }else if(arrOfTempImage.count > 4){
//            imgLeadStatus.image = arrOfTempImage[0]
//            imgLeadStatus1.image = arrOfTempImage[1]
//            imgLeadStatus2.image = arrOfTempImage[2]
//            imgLeadStatus3.image = arrOfTempImage[3]
//            imgLeadStatus4.image = arrOfTempImage[4]
//        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - IBAction
    

    @IBAction func btnAddPictureClicked(_ sender: UIButton) {
        print(arrOfTempImage.count)
        print(UpdateLeadStatus.imageExistForLeadStatus)
        if((arrOfTempImage.count < 5 && UpdateLeadStatus.imageExistForLeadStatus == true) || (arrOfTempImage.count < 4 && UpdateLeadStatus.imageExistForLeadStatus == false)){
            let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                
                imagePicker.sourceType = .camera
                if(UpdateLeadStatus.imageExistForLeadStatus == false){
                print(arrOfTempImage.count)
                switch arrOfTempImage.count {
                case 0:
                    isimage1 = true
                    break
                case 1:
                    isimage2 = true
                    break
                case 2:
                    isimage3 = true
                    break
                case 3:
                    isimage4 = true
                    break
                default:
                    print("nothing")
                }
                }else{
                    
                    switch arrOfTempImage.count {
                    case 1:
                        isimage1 = true
                        break
                    case 2:
                        isimage2 = true
                        break
                    case 3:
                        isimage3 = true
                        break
                    case 4:
                        isimage4 = true
                        break
                    default:
                        print("nothing")
                    }
                }
                self.present(imagePicker, animated: true, completion: nil)
            }else{
    Utils.toastmsg(message:"Camera is not present",view: self.view)
                 }
        }else{
            Utils.toastmsg(message:"Only 4 images allowed",view: self.view)
        }
    }
    
    @IBAction func btnOKClicked(_ sender: UIButton) {
        if(arrOfTempImage.count > AddPictureLeadStatus.arrOfImageWithStatus.count){
           // AddPictureLeadStatus.arrOfImageWithStatus.append(arrOfTempImage.last ?? UIImage())
            AddPictureLeadStatus.arrOfImageWithStatus = [UIImage]()
            for img in arrOfTempImage{
                AddPictureLeadStatus.arrOfImageWithStatus.append(img)
            }
        
    }
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension AddPictureLeadStatus :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if(isimage1){
            isimage1 = false
        }
        if(isimage2){
            isimage2 = false
        }
        if(isimage3){
            isimage3 = false
        }
        if(isimage4){
            isimage4 = false
        }
        picker.dismiss(animated: true
            , completion:   nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       // imageExistForLeadStatus = NSNumber.init(value:1)
        
      self.navigationController?.dismiss(animated: true, completion: nil)
      if let   image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
      {
        lblLeadStatus.isHidden = false
        if(isimage1){
            arrOfTempImage.append(image)
            imgLeadStatus1.image = image
            imgLeadStatus1.isHidden = false
        }
        if(isimage2){
            arrOfTempImage.append(image)
            imgLeadStatus2.image = image
            imgLeadStatus2.isHidden = false
        }
        if(isimage3){
            arrOfTempImage.append(image)
            imgLeadStatus3.image = image
            imgLeadStatus3.isHidden = false
        }
        if(isimage4){
            arrOfTempImage.append(image)
            imgLeadStatus4.image = image
            imgLeadStatus4.isHidden = false
        }
          AddPictureLeadStatus.arrOfImageWithStatus =  arrOfTempImage
          print("arr of temp image count = \(arrOfTempImage.count) , \(AddPictureLeadStatus.arrOfImageWithStatus.count) ")
        isimage1 = false
        isimage2 = false
        isimage3 = false
        isimage4 = false
      }}
    
}
