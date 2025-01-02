//
//  ProductDetail.swift
//  SuperSales
//
//  Created by Apple on 28/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SDWebImage

class ProductDetail: BaseViewController {
    var selectedProduct:Product!
    var selectedProductCategory:ProdCategory!
    var selectedProductSubCategory:ProductSubCat!
    var startFrom:Int!
    var fromProductDrive:Bool!
    var arrOfProduct:[Product]!
    var currentProductNumber:Int!
    var becomeoncezero:Bool!
    var product:Product!
    @IBOutlet weak var lblProductName: UILabel!
  
    
    @IBOutlet weak var imgProductDetails: UIImageView!
    
    
    
    @IBOutlet weak var imgProductDetails2: UIImageView!
    
    @IBOutlet weak var lblProductCategory: UILabel!
    
    
    @IBOutlet weak var lblProductSubCat: UILabel!
    
    @IBOutlet weak var btnViewCompanyStock: UIButton!
    
    @IBOutlet weak var lblProductPrice: UILabel!
    
    @IBOutlet weak var lblProductSpec: UILabel!
    
    var timerForProductChange:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if(fromProductDrive == true){
        timerForProductChange.invalidate()
        }
    }
    
    // MARK: Method
    func setUI(){
        self.title = "Product Details"
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        if(self.activesetting.viewCompanyStock == 1 && self.fromProductDrive ==  false){
            btnViewCompanyStock.isHidden = false
        }else{
            btnViewCompanyStock.isHidden = true
        }
      
        lblProductCategory.setMultilineLabel(lbl: lblProductCategory)
        lblProductSubCat.setMultilineLabel(lbl: lblProductSubCat)
        if(fromProductDrive == true){
              timerForProductChange = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(changeProductData), userInfo: nil, repeats: true)
            Utils.toastmsg(message:"Product will change after 10 second",view:self.view)
            currentProductNumber =  self.startFrom
           self.changeProductData()
        }else{
            selectedProductCategory = ProdCategory.getProductByCatID(catId: NSNumber.init(value: product.productCatId))
                   selectedProductSubCategory = ProductSubCat.getSubCatProduct(subcatid: NSNumber.init(value: product.productSubCatId))
                   lblProductSubCat.text = selectedProductSubCategory.name
                   lblProductCategory.text = selectedProductCategory.name
            lblProductName.text = product.productName
      if(product.specifications?.count ?? 0 > 0){
                     lblProductSpec.text = product.specifications
                  
                }else{
                      lblProductSpec.text = "Description not mentioned."
                }
                if(product.specifications2?.count ?? 0 > 0){
                    lblProductSpec.text = lblProductSpec.text?.appendingFormat("\n%@", product.specifications2 ?? "")
                }
                if(product.specifications3?.count ?? 0 > 0){
                    lblProductSpec.text = lblProductSpec.text?.appendingFormat("\n%@", product.specifications3 ?? "")
                }
                if(product.specifications4?.count ?? 0 > 0){
                    lblProductSpec.text = lblProductSpec.text?.appendingFormat("\n%@", product.specifications4 ?? "")
                }
               
                lblProductPrice.text = String.init(format: "%.1f", product.price)
        //        if(selectedProduct.productName)
        
                if(product.productPath?.count ?? 0 > 0){
                    imgProductDetails.sd_setImage(with:URL.init(string:product.productPath?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "") , placeholderImage: nil, options: []) { (img, error, SDImageCacheTypeNone, url) in
                        print("image downloaded")
                    }
                }else{
                   imgProductDetails.isHidden = true
                }
                if(product.productPath2?.count ?? 0 > 0){
                    imgProductDetails2.sd_setImage(with:URL.init(string:product.productPath?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "") , placeholderImage: nil, options: []) { (img, error, SDImageCacheType, url) in
                        print("image downloaded")
                    }
                }else{
                    imgProductDetails2.isHidden = true
                }
        }
    }
    
    @objc func changeProductData(){
        if(becomeoncezero == true){
            if(currentProductNumber == self.startFrom){
                timerForProductChange.invalidate()
            }
        }
        
        imgProductDetails.image = nil
        imgProductDetails2.image = nil
        selectedProduct = arrOfProduct[currentProductNumber]
       
    
         selectedProductCategory = ProdCategory.getProductByCatID(catId: NSNumber.init(value: selectedProduct.productCatId))
        selectedProductSubCategory = ProductSubCat.getSubCatProduct(subcatid: NSNumber.init(value: selectedProduct.productSubCatId))
        lblProductSubCat.text = selectedProductSubCategory.name
        lblProductCategory.text = selectedProductCategory.name
        lblProductName.text = selectedProduct.productName
        
        if(selectedProduct.specifications?.count ?? 0 > 0){
             lblProductSpec.text = selectedProduct.specifications
          
        }else{
              lblProductSpec.text = "Description not mentioned."
        }
        if(selectedProduct.specifications2?.count ?? 0 > 0){
            lblProductSpec.text = lblProductSpec.text?.appendingFormat("\n%@", selectedProduct.specifications2 ?? "")
        }
        if(selectedProduct.specifications3?.count ?? 0 > 0){
            lblProductSpec.text = lblProductSpec.text?.appendingFormat("\n%@", selectedProduct.specifications3 ?? "")
        }
        if(selectedProduct.specifications4?.count ?? 0 > 0){
            lblProductSpec.text = lblProductSpec.text?.appendingFormat("\n%@", selectedProduct.specifications4 ?? "")
        }
        print(selectedProduct)
        lblProductPrice.text = String.init(format: "%.1f", selectedProduct.price)
//        if(selectedProduct.productName)
        currentProductNumber = currentProductNumber + 1
        if(selectedProduct.productPath?.count ?? 0 > 0){
            imgProductDetails.sd_setImage(with:URL.init(string:selectedProduct.productPath?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "") , placeholderImage: nil, options: []) { (img, error, SDImageCacheTypeNone, url) in
                print("image downloaded")
            }
        }else{
           imgProductDetails.isHidden = true
        }
        if(selectedProduct.productPath2?.count ?? 0 > 0){
            imgProductDetails2.sd_setImage(with:URL.init(string:selectedProduct.productPath?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "") , placeholderImage: nil, options: []) { (img, error, SDImageCacheType, url) in
                print("image downloaded")
            }
        }else{
            imgProductDetails2.isHidden = true
        }
        if(currentProductNumber == self.arrOfProduct.count){
            currentProductNumber = 0
            becomeoncezero = true
        }
    }
    
    // MARK: IBAction
    
    @IBAction func openCompanyStock(_ sender: UIButton) {
        if let viewcompanystock = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.ViewCompanyStock) as? ViewCompanyStock{
        self.navigationController?.pushViewController(viewcompanystock, animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
