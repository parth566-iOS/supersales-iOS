//
//  TerritoryDetailCell.swift
//  SuperSales
//
//  Created by Apple on 27/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class TerritoryDetailCell: UITableViewCell {

    @IBOutlet weak var lblTerritoryDate: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblAddedBy: UILabel!
    
    @IBOutlet weak var cnstTblHeight: NSLayoutConstraint!
    @IBOutlet weak var tblProductListing: UITableView!
    
    var tableViewHeight: CGFloat {
        tblProductListing.layoutIfNeeded()
        return tblProductListing.contentSize.height
    }
    var selectedteritory:TerritoryData?
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        self.lblTerritoryDate.text = ""
        self.lblStartDate.text = ""
        self.lblEndDate.text = ""
        self.lblQuantity.text = ""
        self.lblAddedBy.text = ""
        
       
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tblProductListing.estimatedRowHeight = 30
        tblProductListing.rowHeight = UITableView.automaticDimension
        tblProductListing.delegate = self
        tblProductListing.dataSource = self
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(data:TerritoryData){
        selectedteritory = data
        
        self.lblTerritoryDate.text = selectedteritory?.createdTime
        
      
        let atributedstringcreatedby = NSMutableAttributedString().stratributed(bold: "Added By:", normal:selectedteritory?.createdByName ?? "")
        self.lblAddedBy.attributedText       = atributedstringcreatedby//selectedteritory?.createdByName
       
        tblProductListing.translatesAutoresizingMaskIntoConstraints = false
        
        cnstTblHeight.constant = tableViewHeight
        tblProductListing.layoutIfNeeded()
    }
}
extension TerritoryDetailCell:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(selectedteritory?.aryTertiaryProductList?.count ?? 0)
        return  selectedteritory?.aryTertiaryProductList?.count  ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle =  UITableViewCell.SelectionStyle.none
        let product = selectedteritory?.aryTertiaryProductList?[indexPath.row]
        let lblproductname = cell.contentView.subviews[0] as! UILabel
        lblproductname.text = product?.productName
        print(product?.productName ?? "")
        let lblproductquantity = cell.contentView.subviews[1] as! UILabel
        lblproductquantity.text = String.init(format:"%@",product?.quantity ?? 0)
        return cell
    }
    
    func tableView(_ tableView:UITableView , estimatedRowHeight  index:IndexPath) -> CGFloat {
            return 40
        }
    
        func tableView(_ tableView:UITableView , rowHeight index:IndexPath) -> CGFloat {
            return tableView.contentSize.height
        }
}
