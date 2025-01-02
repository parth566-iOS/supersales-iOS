//
//  OrderProdDescCell.swift
//  SuperSales
//
//  Created by ebsadmin on 31/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

class OrderProdDescCell: UITableViewCell {
    @IBOutlet weak var lblProductNm: UILabel!
    @IBOutlet weak var lblProductQty: UILabel!
    @IBOutlet weak var lblProductVal: UILabel!
    @IBOutlet weak var lblFoc: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(product: SOrderProducts, isFocShow:Bool = false) {
        lblProductNm.text = product.name
        lblProductQty.text = "\(product.quantity)"
        lblProductVal.text = "\(product.price * Double(product.quantity))"
        lblFoc.text = "\(product.focQuantity)"
        lblFoc.isHidden = !isFocShow
    }

    func configureCell1(product: [String: Any], isFocShow:Bool = false) {
        lblProductNm.text = "Above Product FOC"
        lblProductQty.text = "\(product["Quantity"] as? Int64 ?? 0)"
        lblProductVal.text = "0.0"
        lblFoc.isHidden = !isFocShow
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
