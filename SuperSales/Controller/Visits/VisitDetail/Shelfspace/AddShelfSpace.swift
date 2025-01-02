//
//  AddShelfSpace.swift
//  
//
//  Created by Apple on 28/06/19.
//

import UIKit
import  DropDown
import SVProgressHUD

class AddShelfSpace: BaseViewController {
    // swiftlint:disable line_length
    var activityIndicator:UIActivityIndicatorView!
    var isEditShelfSpace: Bool!
    var selectedShelfSpace:ShelfSpaceModel!
    var strImagePathForShelfSpace:String = String()
    var dataForPicker:[String]! = [String]()
    
    var arrPosition:[ShelfSpacePosition]!
    
    var objVisitShelf:PlannVisit!
    
    var strError:String! = " "
    
    var chooseBeatID:DropDown!
    
    var selectedPosition:ShelfSpacePosition!
     let ACCEPTABLECHARACTERS = ".0123456789"
    
    @IBOutlet weak var lblGivenTitle: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var btnPosition: UIButton!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    //@property (nonatomic,strong) DropDown *chooseBeatID;
    @IBOutlet weak var lblPositon: UILabel!
    
    @IBOutlet weak var lblSelectedPostion: UILabel!
    
    @IBOutlet weak var txtTotalWidth: UITextField!
    @IBOutlet weak var txtTotalBreadth: UITextField!
    
    @IBOutlet weak var givenWidth: UITextField!
    @IBOutlet weak var givenBreadth: UITextField!
    
    @IBOutlet weak var btnUploadImage: UIButton!
    
    @IBOutlet weak var imgUploadByUser: UIImageView!
   
   // var pickerPosition:DropDown = DropDown()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = "Add ShelfSpace"
    
        activityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.whiteLarge)
        txtTotalBreadth.keyboardType = UIKeyboardType.decimalPad
        txtTotalWidth.keyboardType = UIKeyboardType.decimalPad
        givenWidth.keyboardType =  UIKeyboardType.decimalPad
        givenBreadth.keyboardType = UIKeyboardType.decimalPad
        
        selectedPosition = ShelfSpacePosition([String:Any]())
        self.getPositionList()
        arrPosition = Array()
        self.chooseBeatID = DropDown.init()

        btnUploadImage.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        
        // set delegate
        txtTotalBreadth.delegate = self
        txtTotalWidth.delegate =  self
        givenBreadth.delegate = self
        givenWidth.delegate =  self
        
        
        txtTotalBreadth.setCommonFeature()
        txtTotalWidth.setCommonFeature()
        givenBreadth.setCommonFeature()
        givenWidth.setCommonFeature()
        
        self.setUI()
        if(isEditShelfSpace){
            self.fillData()
        }
        let setting =  Utils().getActiveSetting()
        //Set PlaceHolder
        txtTotalWidth.placeholder = String(format:"Total Width (%@)" ,  setting.shelfSpaceUnit!)
        txtTotalBreadth.placeholder = String(format:"Total Breadth (%@)"  ,setting.shelfSpaceUnit!)
        givenWidth.placeholder = String(format:"Given Width (%@)" ,setting.shelfSpaceUnit!)
        givenBreadth.placeholder = String(format:"Given Breadth   (%@)",setting.shelfSpaceUnit!)
        
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
    }
    func setUI(){
        self.btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setrightbtn(btnType:BtnRight.home , navigationItem: self.navigationItem)
        CustomeTextfield.setBottomBorder(tf: txtTotalWidth)
        CustomeTextfield.setBottomBorder(tf: txtTotalBreadth)
        CustomeTextfield.setBottomBorder(tf: givenWidth)
        CustomeTextfield.setBottomBorder(tf: givenBreadth)
    }
    func fillData(){
        self.lblSelectedPostion.text = selectedShelfSpace.positionName
        self.txtTotalWidth.text = String(format: "%.2f", Float(selectedShelfSpace.totalWidth))
        self.txtTotalBreadth.text = String(format: "%.2f",Float(selectedShelfSpace.totalBreadth))
        self.givenWidth.text = String(format: "%.2f", Float(selectedShelfSpace.givenWidth))
        self.givenBreadth.text = String(format: "%.2f", Float(selectedShelfSpace.givenBreath))
        if(selectedShelfSpace.shelfSpacePicture.count > 0){
            self.strImagePathForShelfSpace = selectedShelfSpace.shelfSpacePicture
            SVProgressHUD.show(withStatus: "loading Image")
            imgUploadByUser.backgroundColor = .black
            activityIndicator.center = imgUploadByUser.center
            imgUploadByUser.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            Common.getImageFromURL(strURL: selectedShelfSpace.shelfSpacePicture) { (imageOfShelfSpace) in
                 DispatchQueue.main.async {
                self.imgUploadByUser.backgroundColor = .clear
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                self.imgUploadByUser.image =  imageOfShelfSpace
                SVProgressHUD.dismiss()
                }
            }
        }
        
    }
    @IBAction func btnSelectPosition(_ sender: UIButton) {
        
        self.chooseBeatID.anchorView = btnPosition
        self.chooseBeatID.bottomOffset = CGPoint.init(x: 0, y: btnPosition.frame.origin.y)
        self.chooseBeatID.selectionAction = {(index,item) in
            self.lblSelectedPostion.text = item
            self.selectedPosition = self.arrPosition[index]
        }
        
        self.chooseBeatID.show()
        
    }
    
    
    @IBAction func btnUploadImageClicked(_ sender: UIButton)     {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
        imagePicker.sourceType = .camera
        
        self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            Utils.toastmsg(message:"Camera is not present ",view: self.view)
        }
    }
    
    func validateFields()->Bool{
//        let IntGivenBreadth = Int(givenWidth.text ?? "0")
//        let IntGivenWidth = Int(givenBreadth.text ?? "0")
//        let IntTotalBreadth = Int(txtTotalBreadth.text ?? "0")
//        let IntTotalWidth = Int(txtTotalWidth.text ?? "0")
        strError = ""
        if(self.selectedPosition == nil){
            strError = "Please Select Shelf Space Position"
             return false
        }
        else if(txtTotalWidth.text?.count == 0){
            strError = "Please Enter Total Width"
           return false
        }else if (txtTotalBreadth.text?.count == 0){
            strError = "Please Enter Total Breadth"
            return false
        }else if(givenWidth.text?.count == 0){
            strError = "Please Enter Given Width"
             return false
        }else if(givenBreadth.text?.count == 0){
            strError = "Please Enter Given Breadth"
             return false
        }
        else if(  (Float(givenWidth.text ?? "0.0") ?? 0.0) > (Float(txtTotalWidth.text ?? "0.0") ?? 0.0 )){
        

            strError = "Given Width can not be greater than total Width"
            return false
            
        }else if((Float(givenBreadth.text ?? "0.0") ?? 0.0) > (Float(txtTotalBreadth.text ?? "0.0") ?? 0.0 )){
            strError = "Given Breadth can not be greater than total Breadth"
            return false
        }
        else{
            return true
        }
        
    }
     @IBAction func btnSubmitclicked(_ sender: Any) {
        
        if(validateFields()){
             SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            var param = Common.returndefaultparameter()
            var param1 = ["positionID":selectedPosition.ID,"totalWidth":txtTotalWidth.text!,"totalBreadth":txtTotalBreadth.text!,"givenWidth": givenWidth.text!,"givenBreath":givenBreadth.text! ,"visitID":objVisitShelf.iD] as [String : Any]
            if(isEditShelfSpace == true){
                param1["ID"] = selectedShelfSpace.ID
            }else{
                 param1["ID"] = "0"
            }
            param1["shelfSpacePicture"] = self.strImagePathForShelfSpace
            param["addEditShelfSpaceJson"] = Common.json(from:param1)
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlAddShelfSpace, method: Apicallmethod.post){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    self.navigationController?.popViewController(animated: true)
                    print(responseType)
                }else if(error.code == 0){
                      
                            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                        }else{
                  
               Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                        }

//
//            callAPIPost(methodName: "post", url:strUrl , parameter: param as! [String : Any]) { (status, result) in
//                SVProgressHUD.dismiss()
//                print(status)
//                 let resultModel = Result(result as! [String : Any])
//                if(status.lowercased() == "success"){
//
//                    do{
//                        //here dataResponse received from a network request
//
//                        print(result )
//
//                        var arrOfProduct:Array<Any> = Array()
//                        print(resultModel)
//                        if(resultModel.status.lowercased() == "success" ){
//
//                            if(resultModel.data.count == 0 &&  resultModel.dataString.count == 0){
//
//                                // self.dataInt  = dictionary["data"] as? Array<Int> ?? [Int]()
//                                let Dic = result as! [String:Any]
//                                // arrOfProduct = Array<Product>() as! Array<_Product>
//                                arrOfProduct = _Product.getAll() as! Array<Any>
//                                print(arrOfProduct)
//
//
//                            }
//                            else{
//                                Utils.toastmsg(message:resultModel.message)
//                                self.navigationController?.popViewController(animated: true)
//                                // self.dataInt = [Int]()
//                            }
//                            //
//
//
//
//
//                        }
//                        else{
//                            self.showAlert(withMessage: "SomeThing Went Wrong")
//
//                        }
//                    }
//                }
//                else if (status == "Invalid Token"){
//                    Utils.toastmsg(message:resultModel.message)
//                    AppDelegate.init().logout()
//                    //  [[AppDelegate appDelegate].window makeToast:result[@"message"]];
//                    // [[AppDelegate appDelegate] logout];
//                }
//                else if (status == "false"){
//                    Utils.toastmsg(message:NSLocalizedString("internet-failure", comment: ""))
//                }
//                else{
//
//                    self.showAlert(withMessage: "SomeThing Went Wrong Please try again")
//                }
//            }
//
//
//
            }
        }else{
            Utils.toastmsg(message:strError , view: self.view)
        }
        
     }
    
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
    
    // MARK: - API Call
    func getPositionList(){
        
        
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        let param = Common.returndefaultparameter()
        
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetPositionList, method: Apicallmethod.get){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        SVProgressHUD.dismiss()
        
        if(status.lowercased() == Constant.SucessResponseFromServer){
            print(responseType)
            if(responseType == ResponseType.arr){
                let arrOfPosition =  arr as? [[String:Any]] ?? [[String:Any]]()
                for Dictionary in arrOfPosition {
                let position = ShelfSpacePosition.init(Dictionary)
                    self.dataForPicker.append(Dictionary["Name"] as! String)
                    self.arrPosition.append(position)
                                                }
                
                
                                                if(self.arrPosition.count > 0){
                                                    self.chooseBeatID.dataSource = self.dataForPicker
                                                    if(self.isEditShelfSpace){
                                                        for Shelfspce in self.arrPosition{
                                                            if(Shelfspce.Name == self.selectedShelfSpace.positionName){
                                                                self.selectedPosition = Shelfspce
                                                                 self.lblSelectedPostion.text = self.selectedPosition.Name
                                                            }
                                                        }
                    
                                                    }else{
                                                self.selectedPosition = self.arrPosition[0]
                    
                                                self.lblSelectedPostion.text = self.selectedPosition.Name
                                                    }
                                                self.chooseBeatID.reloadAllComponents()
                    
            }
        }else{
            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
        }
            }
        }
 
}
        
    

    
}

extension AddShelfSpace :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true
            , completion:   nil)
    }
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        imgUploadByUser.backgroundColor = .black
        activityIndicator.startAnimating()
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.imgUploadByUser.contentMode = .scaleAspectFit
       
        
        self.imgUploadByUser.image = Common.createImage(withImage: chosenImage, forSize: CGSize.init(width: chosenImage.size.width > 200 ? 200 : chosenImage.size.width , height: chosenImage.size.height > 200 ? 200 :  chosenImage.size.height))
        self.UploadRequest()

        dismiss(animated:true, completion: nil)
        
    }
    func UploadRequest()
    {
        SVProgressHUD.show(withStatus: "Uploading Image")
        let param = Common.returndefaultparameter()
        self.apihelper.addunplanVisitpostWithMultipartBody(fullUrl: ConstantURL.kWSUrlUploadImage, img: self.imgUploadByUser.image!, imgparamname: "Image", param:param) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                
                print(responseType)
                let dicresponse = arr as? [String:Any] ?? [String:Any]()
                print(dicresponse)
                if(dicresponse.keys.contains("filePath")){
                    self.strImagePathForShelfSpace  = dicresponse["filePath"] as! String
                }
            }else{
                
            }
    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }

        }
      // self.imgUploadByUser.image = UIImage.init(imageLiteralResourceName: "icon_products_grey")
//        SVProgressHUD.show(withStatus: "Uploading Image")
//        //for test
//        let strurl = kBaseTeamworkURL + "uploadImage"
//        let url = NSURL(string: strurl)
//
//        let request = NSMutableURLRequest(url: url! as URL)
//        request.httpMethod = "POST"
//
//        let boundary = generateBoundaryString()
//
//        //define the multipart request type
//
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        if (self.imgUploadByUser.image == nil)
//        {
//            SVProgressHUD.dismiss()
//            self.imgUploadByUser.image =  nil
//            self.imgUploadByUser.backgroundColor = .clear
//            return
//        }
//       // self.imgUploadByUser.image =  Common.createImage
//        let image_data = self.imgUploadByUser.image?.jpegData(compressionQuality:0.5)
//
//
//        let body = NSMutableData()
//
//        let parameter = NSMutableDictionary()
//        parameter.setObject(account.user_id ?? 1, forKey: "UserID" as NSCopying)
//        parameter.setObject(account.securityToken ?? 1, forKey: "TokenID" as NSCopying)
//        parameter.setObject(account.company_info.company_id ?? 1, forKey: "CompanyID" as NSCopying)
//        print("parameter for upload image \(parameter)")
//
//        request.httpBody =  body as Data
//
//        print(request.httpBody ?? Data())
//
//
//        let manager = AFHTTPSessionManager.init()
//        manager.responseSerializer = AFJSONResponseSerializer.init(readingOptions: JSONSerialization.ReadingOptions.allowFragments)
//
//        manager.responseSerializer.acceptableContentTypes = nil
//            //set as? Set<String>
//        manager.post(strurl, parameters: parameter, constructingBodyWith: { (body) in
//
//           body.appendPart(withFileData: image_data ?? Data() , name: "Image", fileName: "image.jpeg", mimeType: "image.jpeg")
//
//
//        }, progress: { (p) in
//            print(p)
//        }, success: { (task, response) in
//           // print(response)
//             SVProgressHUD.dismiss()
//            let result = response as! [String : Any]
//            if((result["status"] as! String) ==  "Success"){
//                self.activityIndicator.stopAnimating()
//                Utils.toastmsg(message:result["message"] as? String)
//                self.strImagePathForShelfSpace = result["filepath"] as? String ?? ""
//            }
//        }) { (task, Error) in
//             SVProgressHUD.dismiss()
//            self.imgUploadByUser.image =  nil
//            self.imgUploadByUser.backgroundColor = .clear
//            self.activityIndicator.stopAnimating()
//            Utils.toastmsg(message:Error.localizedDescription)
//            print(Error.localizedDescription)
//        }
    }
    
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
extension AddShelfSpace:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.isEqual(txtTotalWidth)){
            //textField.text = "\(textField.text ?? "0.00")"
            textField.text =  (txtTotalWidth.text?.count==0) ? "0" : String(format: "%.2f",Float(txtTotalWidth.text ?? "0.0") ?? 0.0)
        }else if (textField.isEqual(txtTotalBreadth)){
            textField.text = (txtTotalBreadth.text?.count == 0) ? "0" : String(format: "%.2f",  Float(txtTotalBreadth.text ?? "0.0") ?? 0.0)
        }else if (textField.isEqual(givenWidth)){
            textField.text = (givenWidth.text?.count == 0) ? "0" : String(format: "%.2f", Float(givenWidth.text ?? "0.0") ?? 0.0 )
        }else if (textField.isEqual(givenBreadth)){
            textField.text = (givenBreadth.text?.count == 0) ? "0" : String(format: "%.2f",  Float(givenBreadth.text ?? "0.0") ?? 0.0)
        }
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let allowedCharacters = CharacterSet(charactersIn:".0123456789")//Here change this characters based on your requirement
//        let characterSet = CharacterSet(charactersIn: string)
//        allowedCharacters.isSuperset(of: characterSet)
//        let maxlength =  ((textField.text ?? " ").contains(".")) ? 7:5
//        print(maxlength)
//        if(string.count <= maxlength){
//            return true
//        }else
//        {
//            return false
//        }
//
//
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                print("Backspace was pressed")
                return true
            }
        }
        let cs = NSCharacterSet(charactersIn: ACCEPTABLECHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        if(string == filtered){
           // var  maxlength =  0
             print ("textfield is \(textField.text ?? "N/A") ")
            if((textField.text ?? " ").contains(".")){
               // let string = "Hello Swift"
               
                guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                    return true
                }
                
                let newText = oldText.replacingCharacters(in: r, with: string)
                let isNumeric = newText.isEmpty || (Double(newText) != nil)
                let numberOfDots = newText.components(separatedBy: ".").count - 1
                
                let numberOfDecimalDigits: Int
                if let dotIndex = newText.firstIndex(of: ".") {
                    numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
                } else {
                    numberOfDecimalDigits = 0
                }
                let newTextBeforedot = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
                let number = Float(newTextBeforedot)
                
                return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && (newTextBeforedot.isEmpty || newTextBeforedot == "." || number != nil && number! < 10000 )
        
            }
            else {
                let newTextBeforedot = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
                let number = Float(newTextBeforedot)
                return newTextBeforedot.isEmpty || newTextBeforedot == "." || number != nil && number! < 100000
            }
//            print("max length is = \(maxlength)")
//            if(textField.text?.count ?? 0 > maxlength){
//                return false
//            }
//            else{
//                return true
//            }
        }else{
        return false
        }
    }
}
