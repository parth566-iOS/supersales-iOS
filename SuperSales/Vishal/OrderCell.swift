//
//  OrderCell.swift
//  SuperSales
//
//  Created by Apple on 25/06/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import Foundation

protocol OrderCellDelegate {
    func deleteSO(cell: OrderCell)
    func shareSO(cell: OrderCell)
    func dispatchSO(cell: OrderCell)
}

class OrderCell: UITableViewCell {
    @IBOutlet weak var lblCustomerNm: UILabel!
    @IBOutlet weak var lblProposalNo: UILabel!
    @IBOutlet weak var lblProposalDt: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnDispatch: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var vwColor: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cnstTblHeight: NSLayoutConstraint!

    @IBOutlet weak var vwProAmt: UIView!
    @IBOutlet weak var vwDis: UIView!
    @IBOutlet weak var vwGross: UIView!
    @IBOutlet weak var vwProm: UIView!
    @IBOutlet weak var vwTax: UIView!
    @IBOutlet weak var vwNet: UIView!

    @IBOutlet weak var lblProAmt: UILabel!
    @IBOutlet weak var lblDis: UILabel!
    @IBOutlet weak var lblGross: UILabel!
    @IBOutlet weak var lblProm: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblNet: UILabel!
    @IBOutlet weak var lblFocTitle: UILabel!

    var focShow = false {
        didSet {
            lblFocTitle.isHidden = !focShow
        }
    }
    var isDespatched = false
    var delegate: OrderCellDelegate?
    var temp = [Int]()
    var products: NSOrderedSet? = nil {
        didSet {
            temp.removeAll()
            if products?.count ?? 0 > 0 {
                var j = 0
                var k = 0
                for i in products! {
                    temp.append(k)
                    if let sproduct = i as? SOrderProducts, sproduct.focQuantity > 0{
                        let t = ["Quantity" : sproduct.focQuantity] as [String : Any]
                        temp.append(5000 + j)
                        focProducts.append(t)
                        j = j + 1
                    }
                    k = k + 1
                }
            }
            tableView.reloadData()
        }
    }
    
    var focProducts = [[String: Any]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 44; // set to whatever your "average" cell height is
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    func configureCell(order: SOrder, s: Setting) {
//        let customer = CustomerDetails.getCustomerByID(cid: NSNumber(value: order.companyID))
        self.lblCustomerNm.text = String.isNullOrEmpty(order.customerName) ? "Customer Not Mapped" :  order.customerName
        self.lblProposalDt.text = Utils.getDatestringWithGMT(gmtDateString:(Utils.getDateBigFormatToDefaultFormat(date:order.createdTime, format: "yyyy/MM/dd HH:mm:ss")) ?? "", format:"dd-MMM")
        self.lblProposalNo.text = "\(order.seriesPrefix)\(order.seriesPostfix)"
        
        if(s.requireDiscountAndTaxAmountInSO == 1) {
            lblProAmt.text = "\(order.totalNetAmount)"
            lblDis.text = "\(order.totalDiscount)"
            lblGross.text = "\(order.totalGrossAmount)"
            lblProm.text = "\(order.totalPromotionAmount)"
            lblTax.text = "\(order.totalTaxAmount)"
            lblNet.text = "\(order.finalSalesAmount)"
            if (s.requirePromotionInSO == 0) {
                vwProm.isHidden = true
            }
        }else{
            vwProm.isHidden = true
            vwTax.isHidden = true
            vwDis.isHidden = true
            vwProAmt.isHidden = true
            vwGross.isHidden = true
            vwNet.isHidden = true
        }
    }
    
    @IBAction func btnDeleteSO(_ sender: Any) {
        delegate?.deleteSO(cell: self)
    }
    
    @IBAction func btnShare(_ sender: Any) {
        delegate?.shareSO(cell: self)
    }

    @IBAction func btnDispatchOrderItem(_ sender: Any) {
        delegate?.dispatchSO(cell: self)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableView.layer.removeAllAnimations()
        if let obj = object as? UITableView {
            if obj == self.tableView && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    cnstTblHeight.constant = newSize.height
                }
            }
        }
    }
}

extension OrderCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = (self.products?.count ?? 0) + focProducts.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! OrderProdDescCell
        let index = temp[indexPath.row]
        if index >= 5000 {
            cell.configureCell1(product: focProducts[index - 5000], isFocShow: false)
            if !focShow {
                focShow = false//sproduct.focQuantity > 0
            }
        }else{
            if let sproduct = products?[index] as? SOrderProducts {
                cell.configureCell(product: sproduct, isFocShow: false)
                if !focShow {
                    focShow = false//sproduct.focQuantity > 0
                }
            }
        }
        if self.isDespatched {
            cell.lblProductQty.textColor = #colorLiteral(red: 0.06031910787, green: 0.6, blue: 0.3607843137, alpha: 1)
        }else{
            cell.lblProductQty.textColor = #colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.3215686275, alpha: 1)
        }
        cell.selectionStyle = .none

        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
