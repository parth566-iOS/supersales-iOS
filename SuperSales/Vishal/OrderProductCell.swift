//
//  OrderProductCell.swift
//  SuperSales
//
//  Created by Apple on 18/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift

class OrderProductCell: UITableViewCell {
    var deleteAction: ((Any) -> Void)?
    var blockCollapse:((Any) -> Void)?
    var blockValueChanged:((Int, String) -> Void)?
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var lblProductNmTemp: UILabel!
    @IBOutlet weak var lblProductNm: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var txtPrice: ACFloatingTextfield!
    @IBOutlet weak var txtQty: ACFloatingTextfield!
    @IBOutlet weak var txtDiscount: ACFloatingTextfield!
    @IBOutlet weak var txtDiscountRupees: ACFloatingTextfield!

    @IBOutlet weak var lblProAmt: UILabel!
    @IBOutlet weak var lblProDis: UILabel!
    @IBOutlet weak var lblAmtAfterDiscount: UILabel!
    @IBOutlet weak var lblSGSTLabel: UILabel!
    @IBOutlet weak var lblSGSTAmt: UILabel!
    @IBOutlet weak var lblCGSTAmtLabel: UILabel!
    @IBOutlet weak var lblCGSTAmt: UILabel!
    @IBOutlet weak var cGSTView: UIView!
    @IBOutlet weak var sGSTView: UIView!
    @IBOutlet weak var lblNetAmt: UILabel!
    @IBOutlet var btnDisCat: [UIButton]!

    // FOC
    @IBOutlet weak var txtFOC: ACFloatingTextfield!
    @IBOutlet weak var btnFOCSwitch: UIButton!

    // ABC Discount Congiguration (We have hide default textfield of % and value)
    // First Step we have to hide using contraint

    @IBOutlet weak var txtDisC: ACFloatingTextfield!
    @IBOutlet weak var txtDisCVal: ACFloatingTextfield!

    @IBOutlet weak var lblAdditional: UILabel!
    @IBOutlet weak var btnAddiSwitch: UIButton!
    @IBOutlet weak var btnStep1: UIButton!
    @IBOutlet weak var btnStep2: UIButton!

    @IBOutlet weak var txtDisB: ACFloatingTextfield!
    @IBOutlet weak var txtDisBVal: ACFloatingTextfield!

    @IBOutlet weak var txtDisA: ACFloatingTextfield!
    @IBOutlet weak var txtDisAVal: ACFloatingTextfield!
    @IBOutlet weak var btnCollapse: UIButton!

    @IBOutlet weak var vwFOC: UIView!
    @IBOutlet weak var vwFOC1: UIView!
    @IBOutlet weak var vwDisPerValRadio: UIView!
    @IBOutlet weak var vwDisC: UIView!
    @IBOutlet weak var vwAddi: UIView!
    @IBOutlet weak var vw2StepView: UIView!
    @IBOutlet weak var vwDisB: UIView!
    @IBOutlet weak var vwDisA: UIView!

    @IBOutlet weak var cnstBtnAmtTop: NSLayoutConstraint!
    @IBOutlet weak var cnstBtnAmtHeight: NSLayoutConstraint!

    var completionBlock: ((OrderProductCell, Bool) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configuareUI(s: Setting) {
        if s.fOCToggleInSO == 1{
            btnFOCSwitch.isSelected = false
            vwFOC1.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellConfiguare(dict: SelectedProduct, block:@escaping ((OrderProductCell, Bool) -> Void)) {
        completionBlock = block
        lblProductNm.text = dict.productName
        txtPrice.text = dict.price ?? ""
        txtQty.text = "\(dict.quantity?.toInt() ?? 0)"

        let s = Utils().getActiveSetting()
        if (s.fOCToggleInSO == 1) {
            self.vwFOC.isHidden = false
            if (dict.isFOC) {
                self.btnFOCSwitch.isSelected = true
                self.vwFOC1.isHidden = false
                self.txtFOC.text = "\(dict.focQuantity)"
                self.txtFOC.isUserInteractionEnabled = true;
            }else{
                self.txtFOC.text = "0"
                self.btnFOCSwitch.isSelected = false
                self.txtFOC.isUserInteractionEnabled = false;
                self.vwFOC1.isHidden = true
            }
        }else{
            self.vwFOC.isHidden = true
            self.vwFOC1.isHidden = true
            if (dict.focQuantity > 0) {
                self.txtFOC.text = "\(dict.focQuantity)"
                self.vwFOC.isHidden = false
                self.vwFOC1.isHidden = false
            }else{
                self.vwFOC.isHidden = true
                self.vwFOC1.isHidden = true
            }
        }

        if (dict.disType != 2 || dict.customerClass == 4) {
            self.txtDiscount.text = String(format: "%.2f", Double(dict.salesDiscount ?? "0.0") ?? 0.0);
            vwDisPerValRadio.isHidden = false
            txtDiscount.isHidden = true
            txtDiscountRupees.isHidden = true
                // 1 for Percentage and 2 for value(Decimal value in INR)
            let btn1 = btnDisCat[0]
            let btn2 = btnDisCat[1]
            if (dict.disInPerVal == 1) {
                btn1.isSelected = true;
                btn2.isSelected = false;
                txtDiscount.isHidden = false
            }else{
                btn2.isSelected = true;
                btn1.isSelected = false;
                txtDiscountRupees.isHidden = false
            }

            let proDis = (txtPrice.text!.toDouble() * txtQty.text!.toDouble()) * (dict.salesDiscount!.toDouble() / 100)
            self.txtDiscountRupees.text = String(format: "%.2f", proDis)
            
            dict.proDis = proDis
            self.lblProDis.text = String(format: "%.2f", proDis)

            vwDisC.isHidden = true
            vwAddi.isHidden = true
            vw2StepView.isHidden = true
            vwDisB.isHidden = true
            vwDisA.isHidden = true

            if (s.requireDiscountAndTaxAmountInSO == 0) {
//                self.btnPercentage.selected = YES;
//                self.btnValue.selected = NO;
//                _txtDiscount.hidden = NO;
//                _txtDiscountRupees.hidden = YES;
//                self.cnstDisPerValRadio.constant = 0.0;
//                self.cnstDisPerValRadio.constant = 0.0;
//                self.cnstDiscount.constant = 0.0;
//                self.cnstDiscountValue.constant = 0.0;
//                self.cnstTxtPriceTop.constant=0;
//                self.txtPrice.hidden = YES;
//                self.cnstTxtPriceHeight.constant = 0;
            }
        }else{
            self.vwDisPerValRadio.isHidden = true
            if (dict.customerClass == 1) {
                // Customer Class A and if customer is not selected then value is calculated based on Customer Class A
                vwDisC.isHidden = true;
                vwAddi.isHidden = true;
                vw2StepView.isHidden = true;

                txtDisB.text = String(format: "%.2f", dict.disB);

                if (dict.disB <= 0) {
                    self.txtDisBVal.text = "0.0";
                }else{
                    txtDisBVal.text = String(format: "%.2f", (txtPrice.text!.toDouble() * txtQty.text!.toDouble() * (txtDisB.text!.toDouble() / 100)))
                }
                
                txtDisA.text = String(format:"%.2f", dict.disA);
                if (dict.disA <= 0) {
                    self.txtDisAVal.text = "0.0"
                }else{
                    txtDisA.text = String(format:"%.2f", dict.disA);
                    txtDisAVal.text = String(format:"%.2f", (txtPrice.text!.toDouble() * txtQty.text!.toDouble() - txtDisBVal.text!.toDouble()) * (txtDisA.text!.toDouble() / 100))
                }
                
                dict.proDis = txtDisAVal.text!.toDouble() + txtDisBVal.text!.toDouble()
                self.lblProDis.text = String(format:"%.2f", dict.proDis );
                if (s.requireDiscountAndTaxAmountInSO == 0) {
                    vwDisA.isHidden = true
                    vwDisB.isHidden = true
//                    self.cnstTxtPriceTop.constant=0;
//                    self.txtPrice.hidden = YES;
//                    self.cnstTxtPriceHeight.constant = 0;
                }else{
                    vwDisA.isHidden = false
                    vwDisB.isHidden = false
//                    self.cnstTxtPriceTop.constant=6;
//                    self.txtPrice.hidden = NO;
//                    self.cnstTxtPriceHeight.constant = 52;
                }
            }else if (dict.customerClass == 2) { // Customer Class B
                vwDisC.isHidden = false
                self.txtDisC.placeholder = "Discount B(%)"
                self.txtDisCVal.placeholder = "Discount B(Value)"
                vwAddi.isHidden = false;
                self.lblAdditional.text = "Allow 2 step discount";
                self.btnAddiSwitch.isSelected = dict.isAllow

                if (dict.isInclusive != nil) {
                    vwAddi.isHidden = true;
                    vw2StepView.isHidden = true;
                }
                if (dict.disB <= 0) {
                    self.txtDisC.text = "0.0"
                    self.txtDisCVal.text = "0.0"
                }else{
                    txtDisC.text = String(format:"%.2f", dict.disB);
                    txtDisCVal.text = String(format:"%.2f", (((txtPrice.text!.toDouble() * txtQty.text!.toDouble()) * txtDisC.text!.toDouble()) / 100))
                }
                if (s.requireDiscountAndTaxAmountInSO == 0) {
                    vwDisC.isHidden = true;
//                    self.cnstTxtPriceTop.constant=0;
//                    self.txtPrice.hidden = YES;
//                    self.cnstTxtPriceHeight.constant = 0;
                }else{
                    vwDisC.isHidden = false;
//                    self.cnstTxtPriceTop.constant=6;
//                    self.txtPrice.hidden = NO;
//                    self.cnstTxtPriceHeight.constant = 52;
                }
                if (self.btnAddiSwitch.isSelected) {
                    vwDisA.isHidden = false;

                    if (dict.disA <= 0) {
                        self.txtDisA.text = "0.0"
                        self.txtDisAVal.text = "0.0"
                    }else{
                        txtDisA.text = String(format:"%.2f", dict.disA);
                        txtDisAVal.text = String(format:"%.2f", ((txtPrice.text!.toDouble() * txtQty.text!.toDouble() - txtDisCVal.text!.toDouble()) * (txtDisA.text!.toDouble() / 100)))
                    }
                    if (s.requireDiscountAndTaxAmountInSO == 0) {
                        vwDisA.isHidden = true;
//                        self.cnstTxtPriceTop.constant=0;
//                        self.txtPrice.hidden = YES;
//                        self.cnstTxtPriceHeight.constant = 0;
                    }else{
                        vwDisA.isHidden = false;
//                        self.cnstTxtPriceTop.constant=6;
//                        self.txtPrice.hidden = NO;
//                        self.cnstTxtPriceHeight.constant = 52;
                    }
                }else{
                    vw2StepView.isHidden = true;
                    vwDisB.isHidden = true;
                    vwDisA.isHidden = true;
                    txtDisA.text = "0.0"
                    txtDisAVal.text = "0.0"
                }

                vwDisB.isHidden = true; // it is hidden because of above 2 textfield take place
                dict.proDis = txtDisAVal.text!.toDouble() + txtDisCVal.text!.toDouble()

                self.lblProDis.text = String(format:"%.2f",dict.proDis );
            }else if (dict.customerClass == 3){ // Customer Class C
                vwAddi.isHidden = false
                self.lblAdditional.text = "Additional discount";
                self.btnAddiSwitch.isSelected = dict.isAllow

                if (dict.isInclusive != nil) {
                    vwAddi.isHidden = true;
                }
                if (self.btnAddiSwitch.isSelected) {
                    if (dict.isInclusive != nil) {
                        vw2StepView.isHidden = true;
                    }else{
                        vw2StepView.isHidden = false;
                    }
                    vwDisC.isHidden = true;
                    txtDisC.text = "0.0"
                    txtDisCVal.text = "0.0"
                    btnStep1.isSelected = dict.isFirstStep
                    btnStep2.isSelected = !dict.isFirstStep
                    if (btnStep1.isSelected) {
                        vwDisB.isHidden = false;
                        vwDisA.isHidden = true;

                        txtDisB.text = String(format:"%.2f", dict.disB);
                        txtDisBVal.text = String(format:"%.2f", ((txtPrice.text!.toDouble() * txtQty.text!.toDouble()) * (txtDisB.text!.toDouble() / 100)))
                        txtDisC.text = "0.0"
                        txtDisCVal.text = "0.0"
                        txtDisA.text = "0.0"
                        txtDisAVal.text = "0.0"
                        if (s.requireDiscountAndTaxAmountInSO == 0) {
                            vwDisB.isHidden = true;
//                            self.cnstTxtPriceTop.constant=0;
//                            self.txtPrice.hidden = YES;
//                            self.cnstTxtPriceHeight.constant = 0;
                        }else{
                            vwDisB.isHidden = false;
//                            self.cnstTxtPriceTop.constant=6;
//                            self.txtPrice.hidden = NO;
//                            self.cnstTxtPriceHeight.constant = 52;
                        }
                    }else{
                        vwDisB.isHidden = false;
                        vwDisA.isHidden = false;

                        if (dict.disB <= 0) {
                            self.txtDisB.text = "0.0"
                            self.txtDisBVal.text = "0.0"
                        }else{
                            txtDisB.text = String(format:"%.2f", dict.disB);
                            txtDisBVal.text = String(format:"%.2f",((txtPrice.text!.toFloat() * txtQty.text!.toFloat() * dict.disB)) / 100)
                        }
                        if (dict.disA <= 0) {
                            self.txtDisA.text = "0.0"
                            self.txtDisAVal.text = "0.0"
                        }else{
                            txtDisA.text = String(format:"%.2f", dict.disA);
                            txtDisAVal.text = String(format:"%.2f",((txtPrice.text!.toDouble() * txtQty.text!.toDouble() - txtDisBVal.text!.toDouble()) * (txtDisA.text!.toDouble() / 100)))
                        }
                        if (s.requireDiscountAndTaxAmountInSO == 0) {
                            vwDisA.isHidden = true;
                            vwDisB.isHidden = true;
//                            self.cnstTxtPriceTop.constant=0;
//                            self.txtPrice.hidden = YES;
//                            self.cnstTxtPriceHeight.constant = 0;
                        }else{
                            vwDisA.isHidden = false
                            vwDisB.isHidden = false
//                            self.cnstTxtPriceTop.constant=6;
//                            self.txtPrice.hidden = NO;
//                            self.cnstTxtPriceHeight.constant = 52;
                        }
                    }
                }else{
                    vw2StepView.isHidden = true;
                    vwDisC.isHidden = false;

                    self.txtDisC.placeholder = "Discount C(%)";
                    self.txtDisCVal.placeholder = "Discount C(Value)";

                    vwDisB.isHidden = true
                    vwDisA.isHidden = true

                    txtDisA.text = "0.0"
                    txtDisAVal.text = "0.0"
                    txtDisB.text = "0.0"
                    txtDisBVal.text = "0.0"
                    txtDisC.text = "0.0"
                    txtDisCVal.text = "0.0"
                    if (dict.disC <= 0) {
                        self.txtDisC.text = "0.0"
                        self.txtDisCVal.text = "0.0"
                    }else{
                        txtDisC.text = String(format:"%.2f", dict.disC);
                        txtDisCVal.text = String(format:"%.2f", (txtPrice.text!.toDouble() * txtQty.text!.toDouble()) * (txtDisC.text!.toDouble() / 100));
                    }
                    if (s.requireDiscountAndTaxAmountInSO == 0) {
                        vwDisC.isHidden = true
//                        self.cnstTxtPriceTop.constant=0;
//                        self.txtPrice.hidden = YES;
//                        self.cnstTxtPriceHeight.constant = 0;
                    }else{
                        vwDisC.isHidden = false
//                        self.cnstTxtPriceTop.constant=6;
//                        self.txtPrice.hidden = NO;
//                        self.cnstTxtPriceHeight.constant = 52;
                    }
                }
                
                let proDis = txtDisAVal.text!.toDouble() + txtDisBVal.text!.toDouble() + txtDisCVal.text!.toDouble()
                dict.proDis = proDis
                self.lblProDis.text = String(format:"%.2f",proDis);
    //C initially 2 textfield Discount C(%), Discount C(value) after that “Additional discount (Yes/No)
    //    4 text field Discount B(%), Discount B(value),Discount A(%), Discount A(value)

            }else{ // Customer Class D
                vwDisC.isHidden = true;
                vwAddi.isHidden = true;
                vw2StepView.isHidden = true;
                vwDisB.isHidden = true;
                vwDisA.isHidden = true;
            }
        }
        
        dict.proAmt = (txtPrice.text!.toDouble() * txtQty.text!.toDouble())
        self.lblProAmt.text = String(format:"%.2f", dict.proAmt)
        
        dict.proAftDisAmt = ((txtPrice.text!.toDouble() * txtQty.text!.toDouble()) - dict.proDis)
        self.lblAmtAfterDiscount.text = String(format:"%.2f", dict.proAftDisAmt)
        
        if (dict.isVat) {
            if (dict.isInclusive != nil) {
                if (dict.isInclusive == "Inclusive") {
                    self.lblSGSTLabel.text = String(format:"VAT @%.2f%% Incl.", dict.vATPercentage)
                    let proTax = ((txtPrice.text!.toDouble() * txtQty.text!.toDouble() - dict.proDis) * Double(dict.vATPercentage)) / (100 + Double(dict.vATPercentage))
                    let netAmt = (txtPrice.text!.toDouble() * txtQty.text!.toDouble()) - dict.proDis
                    self.lblSGSTAmt.text = String(format:"%.2f", proTax)
                    dict.proTax = proTax
                    dict.netAmt = netAmt
                    self.lblNetAmt.text = String(format:"%.2f", netAmt);
                }else{
                    self.lblSGSTLabel.text = String(format:"VAT @%.2f%% Excl.", dict.vATPercentage)
                    let proTax = (((txtPrice.text!.toDouble() * txtQty.text!.toDouble()) - dict.proDis) * Double(dict.vATPercentage)) / 100
                    self.lblSGSTAmt.text = String(format:"%.2f", proTax)
                    dict.proTax = proTax
                    let netAmt = ((txtPrice.text!.toDouble() * txtQty.text!.toDouble()) - dict.proDis) + lblSGSTAmt.text!.toDouble() + lblCGSTAmt.text!.toDouble()

                    dict.netAmt = netAmt
                    self.lblNetAmt.text = String(format:"%.2f", netAmt);
                }
            }else{
                let vt = MetadataVATCodes.getVatPerFromID(ID: NSNumber(value: dict.vatID ?? 0))
                if (vt?.inclusiveExclusive == "Inclusive") {
                    self.lblSGSTLabel.text = String(format: "VAT @%.2f%% Incl.",vt?.tAXPercentage ?? 0.0);
                    let temp = 100.0 + Double(vt?.tAXPercentage ?? 0.0)
                    let proTax = (((txtPrice.text!.toDouble() * txtQty.text!.toDouble()) - dict.proDis) * Double(vt?.tAXPercentage ?? 0.0)) / temp
                    self.lblSGSTAmt.text = String(format:"%.2f", proTax);
                    dict.proTax = proTax
                    let netAmt = ((txtPrice.text!.toDouble() * txtQty.text!.toDouble()) - dict.proDis)
                    dict.netAmt = netAmt
                    self.lblNetAmt.text = String(format:"%.2f", netAmt);
                }else{
                    self.lblSGSTLabel.text = String(format: "VAT @%.2f%% Excl.",vt?.tAXPercentage ?? 0.0);
                    let proTax = (((txtPrice.text!.toDouble() * txtQty.text!.toDouble()) - dict.proDis) * Double(vt?.tAXPercentage ?? 0.0)) / 100
                    self.lblSGSTAmt.text = String(format:"%.2f", proTax);
                    dict.proTax = proTax
                    let netAmt = ((txtPrice.text!.toDouble() * txtQty.text!.toDouble()) - dict.proDis) + self.lblSGSTAmt.text!.toDouble() + self.lblCGSTAmt.text!.toDouble()
                    dict.netAmt = netAmt
                    self.lblNetAmt.text = String(format:"%.2f", netAmt);
                }
            }
            self.lblCGSTAmtLabel.text = "";
            self.lblCGSTAmt.text = "";
            cGSTView.isHidden = true
            sGSTView.backgroundColor = .clear
        }else{
            sGSTView.backgroundColor = #colorLiteral(red: 0.9043686986, green: 0.9506070018, blue: 0.994002521, alpha: 1)
            cGSTView.isHidden = false
            sGSTView.isHidden = false
            if (dict.taxType == "VAT") {
                self.lblSGSTLabel.text = String(format:"SGST @%.2f%%",dict.SGSTTax)
                self.lblSGSTAmt.text = String(format: "%.2f", (((txtPrice.text!.toDouble() * txtQty.text!.toDouble()) - dict.proDis) * dict.SGSTTax)/100)
                self.lblCGSTAmtLabel.text = String(format:"CGST @%.2f%%",dict.CGSTTax);
                self.lblCGSTAmt.text = String(format:"%.2f", (((txtPrice.text!.toDouble() * txtQty.text!.toDouble()) - dict.proDis) * dict.CGSTTax)/100)
                let a = ((((txtPrice.text!.toDouble() * txtQty.text!.toDouble()) - dict.proDis) * dict.SGSTTax)/100)
                let b = ((((txtPrice.text!.toDouble() * txtQty.text!.toDouble()) - dict.proDis) * dict.CGSTTax)/100)
                dict.proTax = (a + b)
                if dict.SGSTTax == 0 && dict.CGSTTax == 0 {
                    cGSTView.isHidden = true
                    sGSTView.isHidden = true
                }
            }else if (dict.taxType == "CST") {
                self.lblSGSTLabel.text = String(format:"IGST @%.2f%%",dict.IGSTTax)
                self.lblSGSTAmt.text = String(format:"%.2f", (((txtPrice.text!.toDouble() * txtQty.text!.toDouble() - dict.proDis) * dict.IGSTTax)/100))
                self.lblCGSTAmtLabel.text = "";
                self.lblCGSTAmt.text = "";
                dict.proTax = ((((txtPrice.text!.toDouble() * txtQty.text!.toDouble()) - dict.proDis) * dict.IGSTTax)/100)
                if dict.IGSTTax == 0 {
                    sGSTView.isHidden = true
                }
                cGSTView.isHidden = true
            }else{
                self.lblSGSTLabel.text = "";
                self.lblSGSTAmt.text = "";
                self.lblCGSTAmtLabel.text = "";
                self.lblCGSTAmt.text = "";
                cGSTView.isHidden = true
                sGSTView.isHidden = true
                dict.proTax = 0.0
            }
            let a = ((Double(txtPrice.text ?? "") ?? 0.0) * (Double(txtQty.text ?? "0.0") ?? 0.0))
            let b = a - dict.proDis
            let c = b + lblSGSTAmt.text!.toDouble() + (Double(lblCGSTAmt.text ?? "") ?? 0.0)
            let netAmt = c
            dict.netAmt = netAmt
            self.lblNetAmt.text = String(format:"%.2f", netAmt);
        }

    }

    func cellConfiguare1(dict: SelectedProduct) {
        let s = Utils().getActiveSetting()

        if (dict.disType != 2 || dict.customerClass == 4) {
//            self.txtDiscount.text = String(format: "%.2f", Double(dict.salesDiscount ?? "0.0") ?? 0.0);
            vwDisPerValRadio.isHidden = false
            txtDiscount.isHidden = true
            txtDiscountRupees.isHidden = true
                // 1 for Percentage and 2 for value(Decimal value in INR)
            let btn1 = btnDisCat[0]
            let btn2 = btnDisCat[1]
            if (dict.disInPerVal == 1) {
                btn1.isSelected = true;
                btn2.isSelected = false;
                txtDiscount.isHidden = false
            }else{
                btn2.isSelected = true;
                btn1.isSelected = false;
                txtDiscountRupees.isHidden = false
            }

            let proDis = (dict.price!.toDouble() * dict.quantity!.toDouble()) * (dict.salesDiscount!.toDouble() / 100)
            if !self.txtDiscountRupees.isEditing {
                self.txtDiscountRupees.text = String(format: "%.2f", proDis)
            }
            
            dict.proDis = proDis
            self.lblProDis.text = String(format: "%.2f", proDis)

            vwDisC.isHidden = true
            vwAddi.isHidden = true
            vw2StepView.isHidden = true
            vwDisB.isHidden = true
            vwDisA.isHidden = true

            if (s.requireDiscountAndTaxAmountInSO == 0) {
            }
        }else{
            self.vwDisPerValRadio.isHidden = true
            if (dict.customerClass == 1) {
                // Customer Class A and if customer is not selected then value is calculated based on Customer Class A
                vwDisC.isHidden = true;
                vwAddi.isHidden = true;
                vw2StepView.isHidden = true;

                txtDisB.text = String(format: "%.2f", dict.disB);

                if (dict.disB <= 0) {
                    self.txtDisBVal.text = "0.0";
                }else{
                    txtDisBVal.text = String(format: "%.2f", (dict.price!.toDouble() * dict.quantity!.toDouble() * (txtDisB.text!.toDouble() / 100)))
                }
                
                txtDisA.text = String(format:"%.2f", dict.disA);
                if (dict.disA <= 0) {
                    self.txtDisAVal.text = "0.0"
                }else{
                    txtDisA.text = String(format:"%.2f", dict.disA);
                    txtDisAVal.text = String(format:"%.2f", (dict.price!.toDouble() * dict.quantity!.toDouble() - txtDisBVal.text!.toDouble()) * (txtDisA.text!.toDouble() / 100))
                }
                
                dict.proDis = txtDisAVal.text!.toDouble() + txtDisBVal.text!.toDouble()
                self.lblProDis.text = String(format:"%.2f", dict.proDis );
                if (s.requireDiscountAndTaxAmountInSO == 0) {
                    vwDisA.isHidden = true
                    vwDisB.isHidden = true
                }else{
                    vwDisA.isHidden = false
                    vwDisB.isHidden = false
                }
            }else if (dict.customerClass == 2) { // Customer Class B
                vwDisC.isHidden = false
                self.txtDisC.placeholder = "Discount B(%)"
                self.txtDisCVal.placeholder = "Discount B(Value)"
                vwAddi.isHidden = false;
                self.lblAdditional.text = "Allow 2 step discount";
                self.btnAddiSwitch.isSelected = dict.isAllow

                if (dict.isInclusive != nil) {
                    vwAddi.isHidden = true;
                    vw2StepView.isHidden = true;
                }
                if (dict.disB <= 0) {
                    self.txtDisC.text = "0.0"
                    self.txtDisCVal.text = "0.0"
                }else{
                    txtDisC.text = String(format:"%.2f", dict.disB);
                    txtDisCVal.text = String(format:"%.2f", (((dict.price!.toDouble() * dict.quantity!.toDouble()) * txtDisC.text!.toDouble()) / 100))
                }
                if (s.requireDiscountAndTaxAmountInSO == 0) {
                    vwDisC.isHidden = true;
                }else{
                    vwDisC.isHidden = false;
                }
                if (self.btnAddiSwitch.isSelected) {
                    vwDisA.isHidden = false;

                    if (dict.disA <= 0) {
                        self.txtDisA.text = "0.0"
                        self.txtDisAVal.text = "0.0"
                    }else{
                        txtDisA.text = String(format:"%.2f", dict.disA);
                        txtDisAVal.text = String(format:"%.2f", ((dict.price!.toDouble() * dict.quantity!.toDouble() - txtDisCVal.text!.toDouble()) * (txtDisA.text!.toDouble() / 100)))
                    }
                    if (s.requireDiscountAndTaxAmountInSO == 0) {
                        vwDisA.isHidden = true;
                    }else{
                        vwDisA.isHidden = false;
                    }
                }else{
                    vw2StepView.isHidden = true;
                    vwDisB.isHidden = true;
                    vwDisA.isHidden = true;
                    txtDisA.text = "0.0"
                    txtDisAVal.text = "0.0"
                }

                vwDisB.isHidden = true; // it is hidden because of above 2 textfield take place
                dict.proDis = txtDisAVal.text!.toDouble() + txtDisCVal.text!.toDouble()

                self.lblProDis.text = String(format:"%.2f",dict.proDis );
            }else if (dict.customerClass == 3){ // Customer Class C
                vwAddi.isHidden = false
                self.lblAdditional.text = "Additional discount";
                self.btnAddiSwitch.isSelected = dict.isAllow

                if (dict.isInclusive != nil) {
                    vwAddi.isHidden = true;
                }
                if (self.btnAddiSwitch.isSelected) {
                    if (dict.isInclusive != nil) {
                        vw2StepView.isHidden = true;
                    }else{
                        vw2StepView.isHidden = false;
                    }
                    vwDisC.isHidden = true;
                    txtDisC.text = "0.0"
                    txtDisCVal.text = "0.0"
                    btnStep1.isSelected = dict.isFirstStep
                    btnStep2.isSelected = !dict.isFirstStep
                    if (btnStep1.isSelected) {
                        vwDisB.isHidden = false;
                        vwDisA.isHidden = true;

                        txtDisB.text = String(format:"%.2f", dict.disB);
                        txtDisBVal.text = String(format:"%.2f", ((dict.price!.toDouble() * dict.quantity!.toDouble()) * (txtDisB.text!.toDouble() / 100)))
                        txtDisC.text = "0.0"
                        txtDisCVal.text = "0.0"
                        txtDisA.text = "0.0"
                        txtDisAVal.text = "0.0"
                        if (s.requireDiscountAndTaxAmountInSO == 0) {
                            vwDisB.isHidden = true;
                        }else{
                            vwDisB.isHidden = false;
                        }
                    }else{
                        vwDisB.isHidden = false;
                        vwDisA.isHidden = false;

                        if (dict.disB <= 0) {
                            self.txtDisB.text = "0.0"
                            self.txtDisBVal.text = "0.0"
                        }else{
                            txtDisB.text = String(format:"%.2f", dict.disB);
                            txtDisBVal.text = String(format:"%.2f",((dict.price!.toFloat() * dict.quantity!.toFloat() * dict.disB)) / 100)
                        }
                        if (dict.disA <= 0) {
                            self.txtDisA.text = "0.0"
                            self.txtDisAVal.text = "0.0"
                        }else{
                            txtDisA.text = String(format:"%.2f", dict.disA);
                            txtDisAVal.text = String(format:"%.2f",((dict.price!.toDouble() * dict.quantity!.toDouble() - txtDisBVal.text!.toDouble()) * (txtDisA.text!.toDouble() / 100)))
                        }
                        if (s.requireDiscountAndTaxAmountInSO == 0) {
                            vwDisA.isHidden = true;
                            vwDisB.isHidden = true;
                        }else{
                            vwDisA.isHidden = false
                            vwDisB.isHidden = false
                        }
                    }
                }else{
                    vw2StepView.isHidden = true;
                    vwDisC.isHidden = false;

                    self.txtDisC.placeholder = "Discount C(%)";
                    self.txtDisCVal.placeholder = "Discount C(Value)";

                    vwDisB.isHidden = true
                    vwDisA.isHidden = true

                    txtDisA.text = "0.0"
                    txtDisAVal.text = "0.0"
                    txtDisB.text = "0.0"
                    txtDisBVal.text = "0.0"
                    txtDisC.text = "0.0"
                    txtDisCVal.text = "0.0"
                    if (dict.disC <= 0) {
                        self.txtDisC.text = "0.0"
                        self.txtDisCVal.text = "0.0"
                    }else{
                        txtDisC.text = String(format:"%.2f", dict.disC);
                        txtDisCVal.text = String(format:"%.2f", (dict.price!.toDouble() * dict.quantity!.toDouble()) * (txtDisC.text!.toDouble() / 100));
                    }
                    if (s.requireDiscountAndTaxAmountInSO == 0) {
                        vwDisC.isHidden = true
                    }else{
                        vwDisC.isHidden = false
                    }
                }
                
                let proDis = txtDisAVal.text!.toDouble() + txtDisBVal.text!.toDouble() + txtDisCVal.text!.toDouble()
                dict.proDis = proDis
                self.lblProDis.text = String(format:"%.2f",proDis);
    //C initially 2 textfield Discount C(%), Discount C(value) after that “Additional discount (Yes/No)
    //    4 text field Discount B(%), Discount B(value),Discount A(%), Discount A(value)

            }else{ // Customer Class D
                vwDisC.isHidden = true;
                vwAddi.isHidden = true;
                vw2StepView.isHidden = true;
                vwDisB.isHidden = true;
                vwDisA.isHidden = true;
            }
        }
        
        dict.proAmt = (dict.price!.toDouble() * dict.quantity!.toDouble())
        self.lblProAmt.text = String(format:"%.2f", dict.proAmt)
        
        dict.proAftDisAmt = ((dict.price!.toDouble() * dict.quantity!.toDouble()) - dict.proDis)
        self.lblAmtAfterDiscount.text = String(format:"%.2f", dict.proAftDisAmt)
        
        if (dict.isVat) {
            if (dict.isInclusive != nil) {
                if (dict.isInclusive == "Inclusive") {
                    self.lblSGSTLabel.text = String(format:"VAT @%.2f%% Incl.", dict.vATPercentage)
                    let proTax = ((dict.price!.toDouble() * dict.quantity!.toDouble() - dict.proDis) * Double(dict.vATPercentage)) / (100 + Double(dict.vATPercentage))
                    let netAmt = (dict.price!.toDouble() * dict.quantity!.toDouble()) - dict.proDis
                    self.lblSGSTAmt.text = String(format:"%.2f", proTax)
                    dict.proTax = proTax
                    dict.netAmt = netAmt
                    self.lblNetAmt.text = String(format:"%.2f", netAmt);
                }else{
                    self.lblSGSTLabel.text = String(format:"VAT @%.2f%% Excl.", dict.vATPercentage)
                    let proTax = (((dict.price!.toDouble() * dict.quantity!.toDouble()) - dict.proDis) * Double(dict.vATPercentage)) / 100
                    self.lblSGSTAmt.text = String(format:"%.2f", proTax)
                    dict.proTax = proTax
                    let netAmt = ((dict.price!.toDouble() * dict.quantity!.toDouble()) - dict.proDis) + lblSGSTAmt.text!.toDouble() + lblCGSTAmt.text!.toDouble()

                    dict.netAmt = netAmt
                    self.lblNetAmt.text = String(format:"%.2f", netAmt);
                }
            }else{
                let vt = MetadataVATCodes.getVatPerFromID(ID: NSNumber(value: dict.vatID ?? 0))
                if (vt?.inclusiveExclusive == "Inclusive") {
                    self.lblSGSTLabel.text = String(format: "VAT @%.2f%% Incl.",vt?.tAXPercentage ?? 0.0);
                    let temp = 100.0 + Double(vt?.tAXPercentage ?? 0.0)
                    let proTax = (((dict.price!.toDouble() * dict.quantity!.toDouble()) - dict.proDis) * Double(vt?.tAXPercentage ?? 0.0)) / temp
                    self.lblSGSTAmt.text = String(format:"%.2f", proTax);
                    dict.proTax = proTax
                    let netAmt = ((dict.price!.toDouble() * dict.quantity!.toDouble()) - dict.proDis)
                    dict.netAmt = netAmt
                    self.lblNetAmt.text = String(format:"%.2f", netAmt);
                }else{
                    self.lblSGSTLabel.text = String(format: "VAT @%.2f%% Excl.",vt?.tAXPercentage ?? 0.0);
                    let proTax = (((dict.price!.toDouble() * dict.quantity!.toDouble()) - dict.proDis) * Double(vt?.tAXPercentage ?? 0.0)) / 100
                    self.lblSGSTAmt.text = String(format:"%.2f", proTax);
                    dict.proTax = proTax
                    let netAmt = ((dict.price!.toDouble() * dict.quantity!.toDouble()) - dict.proDis) + self.lblSGSTAmt.text!.toDouble() + self.lblCGSTAmt.text!.toDouble()
                    dict.netAmt = netAmt
                    self.lblNetAmt.text = String(format:"%.2f", netAmt);
                }
            }
            self.lblCGSTAmtLabel.text = "";
            self.lblCGSTAmt.text = "";
            cGSTView.isHidden = true
        }else{
            cGSTView.isHidden = false
            sGSTView.isHidden = false
            if (dict.taxType == "VAT") {
                self.lblSGSTLabel.text = String(format:"SGST @%.2f%%",dict.SGSTTax)
                self.lblSGSTAmt.text = String(format: "%.2f", (((dict.price!.toDouble() * dict.quantity!.toDouble()) - dict.proDis) * dict.SGSTTax)/100)
                self.lblCGSTAmtLabel.text = String(format:"CGST @%.2f%%",dict.CGSTTax);
                self.lblCGSTAmt.text = String(format:"%.2f", (((dict.price!.toDouble() * dict.quantity!.toDouble()) - dict.proDis) * dict.CGSTTax)/100)
                let a = ((((dict.price!.toDouble() * dict.quantity!.toDouble()) - dict.proDis) * dict.SGSTTax)/100)
                let b = ((((dict.price!.toDouble() * dict.quantity!.toDouble()) - dict.proDis) * dict.CGSTTax)/100)
                dict.proTax = (a + b)
                if dict.SGSTTax == 0 && dict.CGSTTax == 0 {
                    cGSTView.isHidden = true
                    sGSTView.isHidden = true
                }
            }else if (dict.taxType == "CST") {
                self.lblSGSTLabel.text = String(format:"IGST @%.2f%%",dict.IGSTTax)
                self.lblSGSTAmt.text = String(format:"%.2f", (((dict.price!.toDouble() * dict.quantity!.toDouble() - dict.proDis) * dict.IGSTTax)/100))
                self.lblCGSTAmtLabel.text = "";
                self.lblCGSTAmt.text = "";
                dict.proTax = ((((dict.price!.toDouble() * dict.quantity!.toDouble()) - dict.proDis) * dict.IGSTTax)/100)
                if dict.IGSTTax == 0 {
                    sGSTView.isHidden = true
                }
                cGSTView.isHidden = true
            }else{
                self.lblSGSTLabel.text = "";
                self.lblSGSTAmt.text = "";
                self.lblCGSTAmtLabel.text = "";
                self.lblCGSTAmt.text = "";
                cGSTView.isHidden = true
                sGSTView.isHidden = true
                dict.proTax = 0.0
            }
            let a = ((Double(dict.price ?? "") ?? 0.0) * (Double(dict.quantity ?? "0.0") ?? 0.0))
            let b = a - dict.proDis
            let c = b + lblSGSTAmt.text!.toDouble() + (Double(lblCGSTAmt.text ?? "") ?? 0.0)
            let netAmt = c
            dict.netAmt = netAmt
            self.lblNetAmt.text = String(format:"%.2f", netAmt);
        }

    }

    
    func cellSmallConfigure(s: Setting, dict: SelectedProduct) {
        let s = Utils().getActiveSetting()
        var string = ""
        if (s.requireDiscountAndTaxAmountInSO == 1) {
            string = String(format: "%@\nQuantity: %@, Amount: %.2lf", dict.productName ?? "", dict.quantity ?? "0", dict.proAftDisAmt)
        }else{
            string = String(format: "%@\nQuantity: %@", dict.productName ?? "", dict.quantity ?? "0");
        }
        self.formatttedString(myString: string, productName: dict.productName ?? "", color: #colorLiteral(red: 0.3019607843, green: 0.3098039216, blue: 0.3647058824, alpha: 1))
    }
    
    func cellBonusPromotionConfigure(dict: FreeBonusProduct) {
        let string = String(format: "%@\nQuantity: %d", dict.productName , dict.freeProductQty)
        self.formatttedString(myString: string, productName: dict.productName, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        
    }
    
    fileprivate func formatttedString(myString: String, productName: String, color: UIColor) {
        let attrStri = NSMutableAttributedString(string: myString)
        let nsRange = NSString(string: myString).range(of: productName, options: String.CompareOptions.caseInsensitive)
        let nsRange1 = NSString(string: myString).range(of: "Quantity", options: String.CompareOptions.caseInsensitive)
        let nsRange2 = NSString(string: myString).range(of: "Amount", options: String.CompareOptions.caseInsensitive)

        attrStri.addAttributes([NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font: UIFont.init(name: AppFontName.bold, size: 18.0) as Any], range: nsRange)
        attrStri.addAttributes([NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font: UIFont.init(name: AppFontName.bold, size: 18.0) as Any], range: nsRange1)
        attrStri.addAttributes([NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font: UIFont.init(name: AppFontName.bold, size: 18.0) as Any], range: nsRange2)
        self.lblProductNmTemp.textColor = color
        self.lblProductNmTemp.attributedText = attrStri
    }
    
    //MARK: - IBActions
    @IBAction func selectAllowFoc(_ sender: Any) {
        let button = sender as!UIButton
        button.isSelected = !button.isSelected
        vwFOC1.isHidden = !button.isSelected
        completionBlock?(self, true)
    }
    
    @IBAction func selectDiscountType(_ sender: Any) {
        let button = sender as! UIButton
        for b in btnDisCat {
            b.isSelected = false
        }
        txtDiscount.isHidden = true
        txtDiscountRupees.isHidden = true
        button.isSelected = true
        if (button.tag == 1) {
            txtDiscount.isHidden = false
        }else{
            txtDiscountRupees.isHidden = false
        }
        completionBlock?(self,true);
    }
    
    @IBAction func selectDisSteps(_ sender: Any) {
        let btn = sender as! UIButton
        if (btn == self.btnStep1) {
            self.btnStep1.isSelected = true;
            self.btnStep2.isSelected = false;
        }else{
            self.btnStep1.isSelected = false;
            self.btnStep2.isSelected = true;
        }
        completionBlock?(self,true);
    }

    @IBAction func switchOnOff(_ sender: Any) {
        self.btnAddiSwitch.isSelected = !self.btnAddiSwitch.isSelected;
        self.btnStep1.isSelected = self.btnAddiSwitch.isSelected;
        self.btnStep2.isSelected = false

        completionBlock?(self,true);
    }

    @IBAction func buttonPressed(_ sender: Any) {
        self.deleteAction?(sender)
    }

    @IBAction func buttonExpandPressed(_ sender: Any) {
        self.blockCollapse?(sender)
    }

}

extension OrderProductCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == txtQty || textField == txtDiscount || textField == txtDiscountRupees || textField == txtFOC) {
            if (textField.text!.toDouble() <= 0) {
                textField.text = "";
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == txtQty || textField == txtDiscount || textField == txtDiscountRupees || textField == txtFOC) {
            if (textField.text!.toDouble() <= 0) {
                textField.text = "0"
            }
        }
        completionBlock?(self,false);
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let stringRange = Range(range, in: textField.text ?? "") else { return false }
        let updatedText = textField.text?.replacingCharacters(in: stringRange, with: string) ?? ""

        let stringsArray = updatedText.components(separatedBy: ".")

        if (textField == txtQty) {
                // Check for an absurdly large amount
            if (stringsArray.count > 0) {
                let dollarAmount = stringsArray[0];
                if (dollarAmount.count > 5) {
                    return false
                }
            }
            
                // Check for more than 2 chars after the decimal point
            if (stringsArray.count > 1) {
                let centAmount = stringsArray[1];
                if (centAmount.count > 2){
                    return false
                }
            }
            
                // Check for a second decimal point
            if (stringsArray.count > 2){
                return false;
            }
            self.txtDiscountRupees.text = String(format: "%.2f", (txtPrice.text!.toDouble() * (Double(updatedText ) ?? 0.0) * (txtDiscount.text!.toDouble()))/100)
            blockValueChanged?(2,updatedText)
            completionBlock?(self,false);
            return true;
        }else if (textField == txtPrice) {
                // Check for an absurdly large amount
            if (stringsArray.count > 0) {
                let dollarAmount = stringsArray[0]
                if (dollarAmount.count > 7) {
                    return false
                }
            }
            
                // Check for more than 2 chars after the decimal point
            if (stringsArray.count > 1) {
                let centAmount = stringsArray[1]
                if (centAmount.count > 2){
                    return false
                }
            }
            
                // Check for a second decimal point
            if (stringsArray.count > 2){
                return false
            }
            self.txtDiscountRupees.text = String(format: "%.2f", (txtPrice.text!.toDouble() * (Double(updatedText ) ?? 0.0) * (txtDiscount.text!.toDouble()))/100)
            blockValueChanged?(1,updatedText)
            completionBlock?(self,false);
            return true;
        }else if (textField == txtDiscount){
            // Check for deletion of the $ sign
            if (range.location == 0 && (textField.text ?? "")!.hasPrefix("$")){
                return false
            }
            
            
            // Check for an absurdly large amount
            if (stringsArray.count > 0) {
                let dollarAmount = stringsArray[0];
                if (dollarAmount.count > 3) {
                    return false
                }
            }
            
            // Check for more than 2 chars after the decimal point
            if (stringsArray.count > 1) {
                let centAmount = stringsArray[1];
                if (centAmount.count > 2) {
                    return false
                }
            }
            
            // Check for a second decimal point
            if (stringsArray.count > 2) {
                return false
            }
            if (textField == txtDiscount) {
                if (Double(updatedText) ?? 0.0 < 100) {
                }else{
                    return false
                }
            }
            
            self.txtDiscountRupees.text = String(format: "%.2f", (txtPrice.text!.toDouble() * (Double(updatedText) ?? 0.0) * (txtQty.text!.toDouble()))/100)
            blockValueChanged?(3,updatedText)
            completionBlock?(self,false);
            return true;
        }else if (textField == txtDiscountRupees){
            if(stringsArray.count > 0){
                let beforeDot = stringsArray[0];
                if(beforeDot.count > 5){
                    return false
                }
            }
            
            
            // Check for an absurdly large amount
            if (stringsArray.count > 0) {
                let dollarAmount = stringsArray[0];
                if (dollarAmount.count > "\(txtPrice.text!.toDouble() * txtQty.text!.toDouble())".count) {
                    return false
                }
            }
            
            // Check for more than 2 chars after the decimal point
            if (stringsArray.count > 1)
            {
                let centAmount = stringsArray[1];
                if (centAmount.count > 2) {
                    return false
                }
            }
            
            // Check for a second decimal point
            if (stringsArray.count > 2) {
                return false
            }
            if (textField == txtDiscountRupees) {
                if (Double(updatedText) ?? 0.0 <= (txtPrice.text!.toDouble() * txtQty.text!.toDouble())-1) {
                }else{
                    return false
                }
            }
            
            self.txtDiscount.text = String(format: "%.2f", (updatedText.toDouble() * 100)/((txtPrice.text!.toDouble() * txtQty.text!.toDouble())));
            blockValueChanged?(4,self.txtDiscount.text ?? "0.0")
            completionBlock?(self,false);
            return true
        }else if (textField == txtFOC){
                // Check for an absurdly large amount
            if (stringsArray.count > 0) {
                let dollarAmount = stringsArray[0];
                if (dollarAmount.count > 5) {
                    return false
                }
            }

                // Check for more than 2 chars after the decimal point
            if (stringsArray.count > 1) {
                let centAmount = stringsArray[1];
                if (centAmount.count > 2) {
                    return false
                }
            }

                // Check for a second decimal point
            if (stringsArray.count > 2){
                return false
            }
            return true
        }
        return true
    }
}
