//
//  StockOrderCell.swift
//  SuperSales
//
//  Created by Apple on 29/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class StockOrderCell: UITableViewCell {

    @IBOutlet weak var btnOrderValue: UIButton!
    @IBOutlet weak var btnStockValue: UIButton!
  //  @IBOutlet weak var lblProductnm: UILabel!
    
    
    @IBOutlet var btnPlusOrder: UIButton!
    
    @IBOutlet var btnMinusOrder: UIButton!
    
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet var lblProductNm: UILabel!
    
    @IBOutlet weak var btnProductName: UIButton!
    @IBOutlet var lblSuggestedQty: UILabel!
       
    var dictData = [String:Any]()
    
    var completionBlock: ((StockOrderCell, Int) -> Void)?

    
    override func prepareForReuse() {
        
        super.prepareForReuse()
//        self.lblProductnm.text = ""
//        self.lblProductNm.text = ""
//        
//        self.lblSuggestedQty.text = ""
//        self.lblProductPrice.text = ""
        
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    //    self.lblProductnm.setMultilineLabel(lbl: self.lblProductnm)
        self.lblProductNm.setMultilineLabel(lbl: self.lblProductNm)
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func minusStock(_ sender: UIButton) {
        completionBlock?(self, 1)
    }
    
    @IBAction func plusStock(_ sender: UIButton) {
        completionBlock?(self, 2)
    }
    
    
    @IBAction func minusOrder(_ sender: UIButton) {
    }
    
    
    @IBAction func plusOrder(_ sender: UIButton) {
    }
    
}
