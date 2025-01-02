//
//  AddLeadFourthStep.swift
//  SuperSales
//
//  Created by Apple on 20/07/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import StepSlider
import DropDown
import PaddingLabel

class AddLeadFourthStep: BaseViewController {
    
    
    var selectedInteraction = InteractionType.metting
    @IBOutlet weak var tfNextActionDate: UITextField!
    
    @IBOutlet weak var stkReminder: UIStackView!
    @IBOutlet var slider: StepSlider!
    @IBOutlet weak var tfNextActionTime: UITextField!
    
    @IBOutlet weak var scrlFourthview: UIScrollView!
    @IBOutlet weak var tfReminderDate: UITextField!
    @IBOutlet weak var tfReminderTime: UITextField!
    
    //   @IBOutlet weak var tfOrderValue: UITextField!
    
    @IBOutlet weak var lblOrderExpectedTitle: UILabel!
    @IBOutlet weak var tfOrderExpectedDate: UITextField!
    
    @IBOutlet weak var vwNextActionInteraction: UIView!
    
    @IBOutlet weak var btnNextInteractionMeeting: UIButton!
    
    @IBOutlet weak var btnNextInteractionCall: UIButton!
    
    
    
    @IBOutlet weak var btnNextInteractionMail: UIButton!
    
    @IBOutlet weak var vwActionNeededToCloseLead: UIView!
    
    @IBOutlet weak var btnNextInteractionMessage: UIButton!
    
    @IBOutlet weak var stackDateTimeTitle: UIStackView!
    
    
    @IBOutlet weak var stackDateTimeControl: UIStackView!
    
    @IBOutlet weak var lblAdditionalReminderTitle: PaddingLabel!
    
    @IBOutlet weak var vwReminder: UIView!
    @IBOutlet weak var tvRemarks: Placeholdertextview!
    
    @IBOutlet weak var vwLeadStage6: UIView!
    
    @IBOutlet weak var vwLeadstage5: UIView!
    @IBOutlet weak var lblLeadStag5Title: UILabel!
    
    @IBOutlet weak var lblLeadStage6Title: UILabel!
    @IBOutlet weak var btnLeadStage6: UIButton!
    
    @IBOutlet weak var btnLeadStage5: UIButton!
    
    public static  var nextActionID = NSNumber.init(value:1)
    public static var leadQualified = NSNumber.init(value: 0)
    public static var leadDemoDone = NSNumber.init(value: 0)
    public static var leadProposalGiven = NSNumber.init(value: 0)
    public static var leadNegotiationDone = NSNumber.init(value: 0)
    public static var isLead5Stage = NSNumber.init(value: 0)
    public static var isLead6Stage = NSNumber.init(value: 0)
    public static var nextActionTime:String! = Utils.getDateWithAppendingDayLang(day: 0, date: Date() , format: "yyyy/MM/dd HH:mm:ss")
    public static var reminderTime:String! = Utils.getDateWithAppendingDayLang(day: 0, date: Date() , format: "yyyy/MM/dd HH:mm:ss")
    public static var orderexpectedTime:String! = Utils.getDateWithAppendingDayLang(day: 0, date: Date() , format: "yyyy/MM/dd HH:mm:ss")
    public static var nextActionDate:Date!
    public static var isReminderSelected:Bool! =  false
    public static var strReminderDate:String! = ""
    public static var strReminerTime:String! = ""
    public static  var orderExpectedDate:Date!
    public static  var reminderDate:Date!
    public static var response:String! = ""
    public static var remarks:String! = ""
    public static var positivity = NSNumber.init(value:0)
    public static var  originalAssignee:NSNumber = NSNumber.init(value:0)
    public static var arrOfLowerLevelUser:[CompanyUsers]!
    @IBOutlet var tvActionNeedToCloseOrder: Placeholdertextview!
    
    @IBOutlet var stkReminderTitle: UIStackView!
    
    
    @IBOutlet var stkReminderValue: UIStackView!
    
    
    @IBOutlet var btnLeadQualified: UIButton!
    
    
    @IBOutlet var btnLeadDemoDone: UIButton!
    
    
    @IBOutlet var btnLeadProposalGiven: UIButton!
    
    
    @IBOutlet var btnLeadFinalisation: UIButton!
    
    @IBOutlet var vwLeadQualified: UIView!
    
    
    @IBOutlet var vwTrialDone: UIView!
    
    
    @IBOutlet var vwProposalSubmited: UIView!
    
    
    @IBOutlet var vwLeadFinalisation: UIView!
    
    @IBOutlet var lblLeadQualifiedTitle: UILabel!
    
    @IBOutlet var lblTrialDoneTitle: UILabel!
    
    @IBOutlet var lblProposalSubmitedTitle: UILabel!
    
    
    @IBOutlet var lblLeadFinalisationTitle: UILabel!
    
    @IBOutlet var vwChanceOfGettingOrder: UIView!
    @IBOutlet var btnAddPictureForLeadQuality: UIButton!
    @IBOutlet weak var NextActionIndicator: UIButton!
    
    @IBOutlet var tfAssignSalesPerson: UITextField!
    @IBOutlet weak var stckViewForExe: UIStackView!
    var datepicker:UIDatePicker = UIDatePicker()
    var initalleaddic:[String:Any] = [String:Any]()
    var editLeaddic:[String:Any] = [String:Any]()
    
    var arrOfFilteredLowerLeverUser:[CompanyUsers] = [CompanyUsers]()
    var arrOfLowerLevelUserName:[NSString] = [NSString]()
    var arrOfFilteredLowerLevelUserName:[NSString] = [NSString]()
    var assignUserDropdown:DropDown! = DropDown()
    var strNextActionTime = ""
    var strReminderTime = ""
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        AddLeadFourthStep.positivity = NSNumber.init(value: (6 - slider.index))
        AddLeadFourthStep.remarks = self.tvRemarks.text
        AddLeadFourthStep.response = tvActionNeedToCloseOrder.text
    }
    
    // MARK: - Method
    func setUI(){
        
     //   lblAdditionalReminderTitle = PaddingLabel.init(frame: lblAdditionalReminderTitle.frame)
       // lblAdditionalReminderTitle.leftInset = 10.0
        if BaseViewController.staticlowerUser.count > 0 {
            self.stckViewForExe.isHidden = false
        }else {
            self.stckViewForExe.isHidden = true
        }
        if(self.activesetting.showOurChancesInLead == NSNumber.init(value: 1)){
            self.vwChanceOfGettingOrder.isHidden = false
        }else{
            self.vwChanceOfGettingOrder.isHidden = true
        }
        
        if(self.activesetting.showActionCloseOrderInLead == NSNumber.init(value: 1)){
            self.vwActionNeededToCloseLead.isHidden = false
        }else{
            self.vwActionNeededToCloseLead.isHidden = true
        }
        
     //   if(self.activeuser.)
        AddLeadFourthStep.arrOfLowerLevelUser = BaseViewController.staticlowerUser
        scrlFourthview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 300, right: 0)
        tfAssignSalesPerson.setrightImage(img: UIImage.init(named: "icon_search_black")!)
        datepicker.setCommonFeature()
        tfNextActionDate.inputView = datepicker
        tfNextActionTime.inputView = datepicker
        tfReminderDate.inputView = datepicker
        tfReminderTime.inputView = datepicker
        tfOrderExpectedDate.inputView = datepicker
        tfNextActionDate.delegate = self
        tfNextActionTime.delegate = self
        tfReminderDate.delegate = self
        tfReminderTime.delegate = self
        tfOrderExpectedDate.delegate = self
        
        
        
        tfNextActionDate.setCommonFeature()
        tfNextActionTime.setCommonFeature()
        tfReminderDate.setCommonFeature()
        tfReminderTime.setCommonFeature()
        tfOrderExpectedDate.setCommonFeature()
        
        tvRemarks.delegate = self
        //   DispatchQueue.global(qos: .background).async {
        self.fetchuser{
            (arrOfuser,error) in
            
        }
        //  }
        
        arrOfLowerLevelUserName = AddLeadFourthStep.arrOfLowerLevelUser.map{
            String.init(format: "%@ %@", $0.firstName , $0.lastName)
        } as [NSString] as [NSString]
        self.initDropDown()
        self.tfAssignSalesPerson.delegate =  self
        
        self.tfNextActionDate.addBorders(edges: .bottom, color: UIColor.black, cornerradius: 0)
        self.tfNextActionTime.addBorders(edges: .bottom, color: UIColor.black, cornerradius: 0)
        self.tfAssignSalesPerson.addBorders(edges: .bottom, color: UIColor.black, cornerradius: 0)
        self.tfOrderExpectedDate.addBorders(edges: .bottom, color: UIColor.black, cornerradius: 0)
        self.tfReminderDate.addBorders(edges: .bottom, color: UIColor.black, cornerradius: 0)
        self.tfReminderTime.addBorders(edges: .bottom, color: UIColor.black, cornerradius: 0)
        if(self.activesetting.showLeadQualifiedInLead == 1){
            vwLeadQualified.isHidden = false
            if(self.activesetting.leadQualifiedTextInLead?.count ?? 0 > 0){
                
                self.lblLeadQualifiedTitle.text = self.activesetting.leadQualifiedTextInLead
                
            }else{
                self.lblLeadQualifiedTitle.text = "Lead Qualified/Prospect"
                
            }
        }else{
            vwLeadQualified.isHidden = true
        }
        if(self.activesetting.showTrialDoneInLead == 1){
            vwTrialDone.isHidden = false
            if(self.activesetting.trialDoneTextInLead?.count ?? 0 > 0 ){
                self.lblTrialDoneTitle.text  = self.activesetting.trialDoneTextInLead
            }else{
                self.lblTrialDoneTitle.text  = "Demo/Trial Done"
            }
        }else{
            vwTrialDone.isHidden = true
        }
        if(self.activesetting.showNegotiationInLead == 1){
            vwLeadFinalisation.isHidden = false
            if(self.activesetting.negotiationTextInLead?.count ?? 0 > 0){
                self.lblLeadFinalisationTitle.text = self.activesetting.negotiationTextInLead
            }else{
                self.lblLeadFinalisationTitle.text = "Negotiation/Finalisation"
            }
        }else{
            vwLeadFinalisation.isHidden = true
        }
        
        if(self.activesetting.showProposalSubInLead == 1){
            vwProposalSubmited.isHidden = false
            if(self.activesetting.proposalSubTextInLead?.count ?? 0 > 0){
                self.lblProposalSubmitedTitle.text = self.activesetting.proposalSubTextInLead
            }else{
                self.lblProposalSubmitedTitle.text = "Proposal Given"
            }
        }else{
            vwProposalSubmited.isHidden = true
        }
        
        if(self.activesetting.leadStage5 == 1){
            vwLeadstage5.isHidden = false
//            if(objLead.leadstage5 == 1){
//                btnLeadStage5.isSelected = true
//                btnLeadStage5.isUserInteractionEnabled = false
//            }
            if(self.activesetting.leadStage5Text?.count ?? 0 > 0){
                
                self.lblLeadStag5Title.text = self.activesetting.leadStage5Text
                
            }else{
                self.lblLeadStag5Title.text = "Lead Stage 5"
                
            }
        }else{
            vwLeadstage5.isHidden = true
        }
        
        
        
        if(self.activesetting.leadStage6 == 1){
            vwLeadStage6.isHidden = false
//            if(objLead.leadstage6 == 1){
//                btnLeadStage6.isSelected = true
//                btnLeadStage6.isUserInteractionEnabled = false
//            }
            if(self.activesetting.leadStage6Text?.count ?? 0 > 0){
                
                self.lblLeadStage6Title.text = self.activesetting.leadStage6Text
                
            }else{
                self.lblLeadStage6Title.text = "Lead Stage 6"
                
            }
        }else{
            vwLeadStage6.isHidden = true
        }
        
        
        
        if(AddLeadFourthStep.isReminderSelected){
           
           
            self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            if(AddLead.isEditLead){
            if let remindertime =  AddLead.objLead.reminderTime as? String{
            datepicker.date = self.dateFormatter.date(from:remindertime ?? "2021/10/10 11:10:10") ?? Date()
            }else{
                datepicker.date = Date()
            }
            }else{
                datepicker.date = self.dateFormatter.date(from:AddLeadFourthStep.strReminderDate ?? "2021/10/10 11:10:10") ?? Date()
            }
            AddLeadFourthStep.reminderDate = Utils.getNSDateWithAppendingDay(day: 0, date1: datepicker.date, format: "yyyy/MM/dd HH:mm:ss")
            if let remindertimeInDate = AddLeadFourthStep.reminderDate as? Date{
            tfReminderDate.text = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.reminderDate ?? Date(), format: "dd-MM-yyyy")
            tfReminderTime.text = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.reminderDate ?? Date(), format: "hh:mm a")
                vwReminder.isHidden = false
                NextActionIndicator.isSelected = true
            }else{
                vwReminder.isHidden = true
                tfReminderDate.text = Utils.getDateWithAppendingDayLang(day: 0, date: Date(), format: "dd-MM-yyyy")
                tfReminderTime.text = Utils.getDateWithAppendingDayLang(day: 0, date:  Date(), format: "hh:mm a")
            }
            AddLeadFourthStep.strReminderDate =  tfReminderDate.text
            NextActionIndicator.isSelected =  true
            self.setNextAction(selected: true)
        }else{
            NextActionIndicator.isSelected =  false 
            self.setNextAction(selected: false)
            
          
        }
        
     
        AddLeadFourthStep.response = tvActionNeedToCloseOrder.text
       // AddLeadFourthStep.positivity = NSNumber.init(value: (6 - slider.index))
        
        if(AddLead.isEditLead == true){
            tvRemarks.text = AddLead.objLead.remarks
            AddLeadFourthStep.remarks = self.tvRemarks.text
            slider.index =  UInt((6 - Int(AddLeadFourthStep.positivity)))
            
           // slider.index = 7 -  AddLead.
            tvActionNeedToCloseOrder.text = AddLeadFourthStep.response
            self.tvRemarks.text = AddLeadFourthStep.remarks
            self.dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
//            let nactDate = self.dateFormatter.string(from: Utils.getDateBigFormatToCurrent(date: AddLead.objLead.nextActionTime, format:"yyyy/MM/dd HH:mm:ss"))
//            self.tfNextActionDate.text  = Utils.getDatestringWithGMT(gmtDateString: nactDate, format: "dd-MM-yyyy")//Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.nextActionDate , format: "dd-MM-yyyy")
        //    self.tfNextActionTime.text = Utils.getDatestringWithGMT(gmtDateString: nactDate, format: "hh:mm a")
            self.tfNextActionDate.text = Utils.getDate(date: AddLeadFourthStep.nextActionDate as! NSDate, withFormat: "dd-MM-yyyy")
            self.tfNextActionTime.text = Utils.getDate(date: AddLeadFourthStep.nextActionDate as! NSDate, withFormat: "hh:mm a")
            
//            if let strdt = Utils.getDateBigFormatToDefaultFormat(date: AddLeadFourthStep.nextActionTime , format: "yyyy/MM/dd HH:mm:ss") as? String{
//            let date = Utils.getDateFromStringWithFormat(gmtDateString: strdt)
//            self.tfNextActionTime.text = Utils.getDateWithAppendingDay(day: 0, date: date, format: "hh:mm a", defaultTimeZone: true)//Utils.getDatestringWithGMT(gmtDateString: nactDate, format: "hh:mm a")//Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.nextActionDate , format: "HH:mm a")
                
//            }
           /* if let strnextactiontime = AddLead.objLead.nextActionTime{
             Utils.getDateBigFormatToDefaultFormat(date: latestvisitreport.nextActionTime, format: "dd-MM-yyyy")
                if let date =  self.dateFormatter.date(from: strnextactiontime){
                    self.dateFormatter.dateFormat = "dd-MM-yyyy"
                    print(date)
                    self.tfNextActionDate.text  =  self.dateFormatter.string(from: date)
                    var datecomponent = DateComponents()
                    let calender = NSCalendar.current
                    if let companytimezone = Utils().getActiveAccount()?.company?.timeZone as? String{
                       
                            dateFormatter.locale  = NSLocale.init(localeIdentifier: "US") as Locale
                            dateFormatter.timeZone =  TimeZone.init(identifier:companytimezone)
                            datecomponent.timeZone = TimeZone.init(identifier:companytimezone)
                        }else{
                            dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
                            datecomponent.timeZone = NSTimeZone.default
                        }
                    
                
                    let  date1 = calender.date(byAdding: datecomponent, to: date)
//                    self.dateFormatter.locale =  NSLocale.init(localeIdentifier: "UTC") as Locale
//                    self.dateFormatter.timeZone =  NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone
                    self.dateFormatter.dateFormat = "HH:mm a"
                    self.tfNextActionTime.text = self.dateFormatter.string(from: date1 ?? Date())
                }
            }*/
            strNextActionTime = ""
            if let strdate = tfNextActionDate.text{
                strNextActionTime.append(strdate)
            }
            if let strtime =  tfNextActionTime.text{
                strNextActionTime.append("  \(strtime)")
            }
            
            self.selectedNextActionInteractionType(tag:AddLeadFourthStep.nextActionID.int64Value)
            if(AddLead.objLead.reminder  > 0){
                // AddLeadFourthStep.reminderDate = AddLead.objLead.reminderTime
                self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                datepicker.date = self.dateFormatter.date(from:AddLead.objLead.reminderTime ?? "2021/10/10 11:10:10") ?? Date()
                AddLeadFourthStep.reminderDate = Utils.getNSDateWithAppendingDay(day: 0, date1: datepicker.date, format: "yyyy/MM/dd HH:mm:ss")
                tfReminderDate.text = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.reminderDate ?? Date(), format: "dd-MM-yyyy")
                tfReminderTime.text = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.reminderDate ?? Date(), format: "hh:mm a")
                AddLeadFourthStep.strReminderDate =  tfReminderDate.text
                
                
                
                
                
                
            }
            
            // if()
            if let oed = AddLead.objLead.orderExpectedDate as? String {
                AddLeadFourthStep.orderExpectedDate = Utils.getDateFromStringWithFormat(gmtDateString: oed)
                let date = Utils.getDateFromStringWithFormat(gmtDateString: oed)
                self.dateFormatter.dateFormat = "dd-MM-yyyy"
                tfOrderExpectedDate.text = self.dateFormatter.string(from: date)
              //  tfOrderExpectedDate.text =  Utils.getDatestringWithGMT(gmtDateString:oed, format: "dd-MM-yyyy") //Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: AddLead.objLead.orderExpectedDate ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss") ?? "22-2-2010", format: "dd-MM-yyyy")
              //  self.tfOrderExpectedDate.text = Utils.getDatestringWithGMT(gmtDateString:  oed ?? "22-10-2021" ,  format: "dd-MM-yyyy")
                //Utils.getDateWithAppendingDay(day: 0, date: AddLeadFourthStep.orderExpectedDate, format: "dd-MM-yyyy", defaultTimeZone: true)
                // AddLeadFourthStep.orderExpectedDate = Utils.getDateFromString(date: self.tfOrderExpectedDate.text ?? "22-10-2021")
            }else{
                self.tfOrderExpectedDate.text = Utils.getDateWithAppendingDay(day: 7, date: Date(), format: "dd-MM-yyyy", defaultTimeZone: true)
                AddLeadFourthStep.orderExpectedDate = Utils.getDateFromString(date: self.tfOrderExpectedDate.text ?? "22-10-2021")
            }
            
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            /*  self.editLeaddic =  AddLead.LeadDic["addleadjson"] as! [String : Any]
             print("dic of edit lead = \(self.editLeaddic)")
             self.editLeaddic["NextActionTime"] = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.nextActionDate , format: "yyyy/MM/dd HH:mm:ss")
             self.editLeaddic["OrderExpectedDate"] = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.orderExpectedDate , format: "yyyy/MM/dd HH:mm:ss")
             self.editLeaddic["ReminderTime"] = Utils.getDateWithAppendingDayLang(day: 0, date: dateFormatter.date(from: AddLeadFourthStep.reminderTime ?? "2020/03/10 02:12:12") ?? Date(), format: "yyyy/MM/dd HH:mm:ss")//AddLead.objLead.reminderTime
             AddLead.LeadDic["addleadjson"] = self.editLeaddic
             */
            btnAddPictureForLeadQuality.isHidden = true
            
            if(AddLeadFourthStep.leadQualified == 1){
                btnLeadQualified.isSelected = true
            }else{
                btnLeadQualified.isSelected = false
            }
            if(AddLeadFourthStep.leadDemoDone == 1){
                btnLeadDemoDone.isSelected = true
            }else{
                btnLeadDemoDone.isSelected = false
            }
            if(AddLeadFourthStep.leadNegotiationDone == 1){
                btnLeadFinalisation.isSelected = true
            }else{
                btnLeadFinalisation.isSelected = false
            }
            if(AddLeadFourthStep.leadProposalGiven == 1){
                btnLeadProposalGiven.isSelected = true
            }else{
                btnLeadProposalGiven.isSelected = false
            }
            if(AddLeadFourthStep.isLead5Stage == 1){
                btnLeadStage5.isSelected = true
            }else{
                btnLeadStage5.isSelected = false
            }
            if(AddLeadFourthStep.isLead6Stage == 1){
                btnLeadStage6.isSelected = true
            }else{
                btnLeadStage6.isSelected = false
            }
            tvRemarks.text = AddLead.objLead.remarks
            
            AddLeadFourthStep.remarks = self.tvRemarks.text
            if(AddLead.objLead.leadStatusList.count > 0){
                
                //  if let lastoutcome = objLead.leadStatusList.lastObject as? LeadStatusList{
                for lastoutCome in  AddLead.objLead.leadStatusList{
                    if let lastoutcome =  lastoutCome as? LeadStatusList{
                        if(lastoutcome.isLeadQualified == 1){
                            btnLeadQualified.isSelected = true
                            
                        }
                        if(lastoutcome.isTrialDone == 1){
                            btnLeadDemoDone.isSelected = true
                            
                        }
                        if(lastoutcome.proposalSubmitted == 1){
                            btnLeadProposalGiven.isSelected = true
                            
                        }
                        if(lastoutcome.isNegotiationDone == 1){
                            btnLeadFinalisation.isSelected = true
                            
                        }
                        if(lastoutcome.leadstage5 == 1){
                            btnLeadStage5.isSelected = true
                            
                        }
                        if(lastoutcome.leadstage6 == 1){
                            btnLeadStage6.isSelected = true
                            
                        }
                    }
                }
                
                
            }
            
        }else{
            
            let calender = NSCalendar.current
            let dayComponent = NSDateComponents.init()
            dayComponent.day = 1
            let nextDate  = calender.date(byAdding: dayComponent as DateComponents, to: Date())
            AddLeadFourthStep.nextActionDate = calender.date(bySettingHour: 10, minute: 0, second: 0, of: nextDate ?? Date()) ?? Date()
            datepicker.date =  AddLeadFourthStep.nextActionDate  ?? Date()
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            tfNextActionDate.text = self.dateFormatter.string(from: datepicker.date)
            self.dateFormatter.dateFormat = "hh:mm a"
            tfNextActionTime.text = self.dateFormatter.string(from: datepicker.date)
            strNextActionTime = ""
            if let strdate = tfNextActionDate.text{
                strNextActionTime.append(strdate)
            }
            if let strtime =  tfNextActionTime.text{
                strNextActionTime.append("  \(strtime)")
            }
          
            slider.index =  UInt((6 - Int(AddLeadFourthStep.positivity)))
            print("setted index = \(UInt((6 - Int(AddLeadFourthStep.positivity)))), postivity = \(AddLeadFourthStep.positivity)")
            slider.setIndex(UInt((6 - Int(AddLeadFourthStep.positivity))), animated: true)
            
//            self.dateFormatter.dateFormat =  "yyyy/MM/dd hh:mm:ss"
//            let nactDate = self.dateFormatter.string(from: AddLeadFourthStep.nextActionDate)
//            //[Utils getDatestringWithGMT:obj.nextActionTime andFormat:@"dd-MM-yyyy, hh:mm a"]
//            self.tfNextActionDate.text  = Utils.getDatestringWithGMT(gmtDateString: nactDate, format: "dd-MM-yyyy")//Utils.getDateUTCWithAppendingDay(day: 0, date: nactDate ?? Date(), format: "dd-MM-yyyy", defaultTimeZone: true)//Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.nextActionDate , format: "dd-MM-yyyy")
//            //Utils.getDatestringWithGMT(gmtDateString:strvrt, format: "hh:mm  a")
//            self.tfNextActionTime.text = Utils.getDatestringWithGMT(gmtDateString: nactDate, format: "hh:mm a")
            btnAddPictureForLeadQuality.isHidden = true
            if(AddLeadFourthStep.isReminderSelected){
                self.setNextAction(selected: true)
            }else{
            self.setNextAction(selected: false)
            }
            datepicker.date =  Date()
            datepicker.minimumDate = Date()
            
            if let strorderexpecteddate =  AddLeadFourthStep.orderExpectedDate as? Date{
                AddLeadFourthStep.orderExpectedDate = strorderexpecteddate
                self.dateFormatter.dateFormat = "dd-MM-yyyy"
                self.tfOrderExpectedDate.text = self.dateFormatter.string(from: AddLeadFourthStep.orderExpectedDate)
            }else{
                self.tfOrderExpectedDate.text =  Utils.getDateWithAppendingDay(day: 7, date: Date(), format: "dd-MM-yyyy", defaultTimeZone: true)
                self.dateFormatter.dateFormat = "dd-MM-yyyy"
                
                AddLeadFourthStep.orderExpectedDate = self.dateFormatter.date(from: self.tfOrderExpectedDate.text ?? "22-10-2021") // Utils.getDateFromString(date: self.tfOrderExpectedDate.text ?? "22-10-2021")
                
            }
            
            if let strnextActionDate =  AddLeadFourthStep.nextActionDate as? Date{
                AddLeadFourthStep.nextActionDate = strnextActionDate
            }else{
                AddLeadFourthStep.nextActionDate = Date()
            }
            
            if let strreminderDate =  AddLeadFourthStep.reminderDate as? Date{
                AddLeadFourthStep.reminderDate = strreminderDate
            }else{
                AddLeadFourthStep.reminderDate = Date()
            }
            
          //  self.tfOrderExpectedDate.text = Utils.getDateWithAppendingDay(day: 0, date:  AddLeadFourthStep.orderExpectedDate, format: "dd-MM-yyyy", defaultTimeZone: true)
            //   self.selectedNextActionInteractionType(tag:AddLeadFourthStep.nextActionID.int64Value)
            //self.btnNextActionInteractionClicked(btnNextInteractionMeeting)
            if let selectednextactionid =  AddLeadFourthStep.nextActionID as? NSNumber{
                self.selectedNextActionInteractionType(tag:selectednextactionid.int64Value)
            }else{
                self.btnNextActionInteractionClicked(self.btnNextInteractionMeeting)
            }
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            
            self.dateFormatter.dateFormat = "hh:mm a"
            
            
            //  orderExpectedDate =
            
            self.dateFormatter.dateFormat = "dd MMM,yyyy hh:mm a"
            
            /*           self.initalleaddic =  AddLead.LeadDic["addleadjson"] as! [String : Any]
             initalleaddic["NextActionTime"] = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.nextActionDate , format: "yyyy/MM/dd HH:mm:ss")
             
             initalleaddic["OrderExpectedDate"] = Utils.getDateWithAppendingDayLang(day: 1, date: AddLeadFourthStep.orderExpectedDate , format: "yyyy/MM/dd HH:mm:ss")
             
             initalleaddic["ReminderTime"] = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.reminderDate , format: "yyyy/MM/dd HH:mm:ss")
             AddLead.LeadDic["addleadjson"] = initalleaddic*/
            
            
            
            
            self.tvActionNeedToCloseOrder.text = AddLeadFourthStep.response
            self.tvRemarks.text = AddLeadFourthStep.remarks
          //Utils.getDateUTCWithAppendingDay(day: 0, date: nactDate ?? Date(), format: "HH:mm a", defaultTimeZone: true)//Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.nextActionDate , format: "hh:mm a")
        }
        
        var strsalespersonname = ""
        if let assigneeuser =  CompanyUsers().getUser(userId: AddLeadFourthStep.originalAssignee) as? CompanyUsers{
            //if let firstname = assigneeuser.firstName{
            strsalespersonname.append(assigneeuser.firstName)
            // }
            //  if let secondname = assigneeuser.lastName{
            strsalespersonname.append(String.init(format:" \(assigneeuser.lastName)"))
            // }
        }else{
            
            if let firstname = self.activeuser?.firstName{
                strsalespersonname.append(firstname)
            }
            if let secondname = self.activeuser?.lastName{
                strsalespersonname.append(String.init(format:" \(secondname)"))
            }
        }
        self.tfAssignSalesPerson.text = strsalespersonname
        if(self.activesetting.showAdditionalReminderInLead == NSNumber.init(value: 1)){
            stkReminder.isHidden = false
        }else{
            stkReminder.isHidden = true
        }
    }
    

    func initDropDown(){
        assignUserDropdown.anchorView = tfAssignSalesPerson//searchAssignUser
        assignUserDropdown.bottomOffset = CGPoint.init(x: 0, y: tfAssignSalesPerson.bounds.size.height+20)
        
        assignUserDropdown.dataSource = arrOfFilteredLowerLevelUserName as [String]
        assignUserDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfAssignSalesPerson.text = item
            let assignee = self.arrOfFilteredLowerLeverUser[index]
            AddLeadFourthStep.originalAssignee = assignee.entity_id
        }
        assignUserDropdown.reloadAllComponents()
    }
    func changeAssigneeAsperCustomerSelection(){
        var taggedToIDListOfUserID  = [Int]()
        AddLeadFourthStep.arrOfLowerLevelUser = [CompanyUsers]()
        if let selectedCustomer = LeadCustomerDetail.selectedCustomer as? CustomerDetails{
        taggedToIDListOfUserID = selectedCustomer.taggedToIDList.map(
            {
                //taggedUserID
                ($0 as! TaggedToIDList).taggedUserID
                
            })
        }
        for user in BaseViewController.staticlowerUser{
            if(user.entity_id == self.activeuser?.userID){
                AddLeadFourthStep.arrOfLowerLevelUser.append(user)
            }else if(taggedToIDListOfUserID.contains(Int(user.entity_id)) && user.role_id != 9){
                AddLeadFourthStep.arrOfLowerLevelUser.append(user)
            }
            
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
    //MARK: - IBAction
    
    
    @IBAction func ChanceOfOrederGetChanged(_ sender: StepSlider) {
        AddLeadFourthStep.positivity = NSNumber.init(value: (6 - slider.index))
    }
    
    
    @IBAction func btnLeadQualifiedClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        print(sender.isSelected)
        if(sender.isSelected == true){
            AddLeadFourthStep.leadQualified = NSNumber.init(value:1)
        }else{
            AddLeadFourthStep.leadQualified = NSNumber.init(value:0)
        }
        
        
        
    }
    
    @IBAction func btnTrialDoneClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true){
            AddLeadFourthStep.leadDemoDone = NSNumber.init(value:1)
        }else{
            AddLeadFourthStep.leadDemoDone = NSNumber.init(value:0)
        }
        
    }
    
    
    
    @IBAction func btnAddPictureLeadQuallityClicked(_ sender: UIButton) {
        
        
        
        
        
    }
    
    @IBAction func btnLeadProposalClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        print(sender.isSelected)
        print(btnLeadDemoDone.isSelected)
        if(sender.isSelected == true){
            AddLeadFourthStep.leadProposalGiven = NSNumber.init(value:1)
        }else{
            AddLeadFourthStep.leadProposalGiven = NSNumber.init(value:0)
        }
    }
    
    @IBAction func btnLead5StageClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        
        if(sender.isSelected){
            AddLeadFourthStep.isLead5Stage = NSNumber.init(value:1)
        }else{
            AddLeadFourthStep.isLead5Stage = NSNumber.init(value:0)
        }
    }
    @IBAction func btnLead6StageClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        
        if(sender.isSelected){
            AddLeadFourthStep.isLead6Stage = NSNumber.init(value:1)
        }else{
            AddLeadFourthStep.isLead6Stage = NSNumber.init(value:0)
        }
    }
    
    
    
    
    
    
    
    
    @IBAction func btnLeadFinalisationClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true){
            AddLeadFourthStep.leadNegotiationDone = NSNumber.init(value:1)
        }else{
            AddLeadFourthStep.leadNegotiationDone = NSNumber.init(value:0)
        }
        
    }
    @IBAction func btnNextActionInteractionClicked(_ sender: UIButton) {
        AddLeadFourthStep.nextActionID = NSNumber.init(value: sender.tag)
        
        self.selectedNextActionInteractionType(tag:Int64(sender.tag))
    }
    
    
    
    @IBAction func btnNextactionIndicatorClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.setNextAction(selected: sender.isSelected)
    }
    
    //MARK: - Method
    func setNextAction(selected:Bool)->(){
        if(selected == true){
            AddLeadFourthStep.isReminderSelected = true
        
            vwReminder.isHidden = false
            
        
        }else{
           
            vwReminder.isHidden = true
           
            AddLeadFourthStep.isReminderSelected = false
          
            
        }
    }
    func selectedNextActionInteractionType(tag:Int64){
        switch tag {
        case 1:
            
            // sender.isSelected = !sender.isSelected
            btnNextInteractionMeeting.isSelected = true
            btnNextInteractionCall.isSelected = false
            btnNextInteractionMail.isSelected = false
            btnNextInteractionMessage.isSelected = false
            selectedInteraction = InteractionType.metting
            break
            
        case 2:
            //  sender.isSelected = !sender.isSelected
            btnNextInteractionMeeting.isSelected = false
            btnNextInteractionCall.isSelected = true
            btnNextInteractionMail.isSelected = false
            btnNextInteractionMessage.isSelected = false
            selectedInteraction = InteractionType.call
            break
            
        case 3:
            //  sender.isSelected = !sender.isSelected
            btnNextInteractionMeeting.isSelected = false
            btnNextInteractionCall.isSelected = false
            btnNextInteractionMail.isSelected = true
            btnNextInteractionMessage.isSelected = false
            selectedInteraction = InteractionType.mail
            break
            
        case 4:
            // sender.isSelected = !sender.isSelected
            btnNextInteractionMeeting.isSelected = false
            btnNextInteractionCall.isSelected = false
            btnNextInteractionMail.isSelected = false
            btnNextInteractionMessage.isSelected = true
            selectedInteraction = InteractionType.message
            break
            
        default:
            print("Its default case")
        }
//        if(AddLeadFourthStep.nextActionID.intValue > 0){
//            
//        }else{
//            
//            let calender = Calendar.current
//            var daycomponent = DateComponents.init()
//            daycomponent.day = 1
//            if let date =  calender.date(byAdding: daycomponent, to: Date()) as? Date{
//                AddLeadFourthStep.nextActionDate = calender.date(bySettingHour: 10, minute: 0, second: 0, of: date) ?? Date()
//                print(AddLeadFourthStep.nextActionDate ?? "f4g4")
//                
//            }
//            
//            self.dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
//            let nactDate = self.dateFormatter.string(from: AddLeadFourthStep.nextActionDate)
//            tfNextActionDate.text = Utils.getDatestringWithGMT(gmtDateString: nactDate, format: "dd-MM-yyyy")//Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.nextActionDate ?? Date(), format: "dd-MM-yyyy")
//            tfNextActionTime.text = Utils.getDatestringWithGMT(gmtDateString: nactDate, format: "hh:mm a")//Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.nextActionDate ?? Date(), format: "hh:mm a")
//        }
    }
    
}
extension AddLeadFourthStep:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if(textField == tfNextActionDate){
           self.dateFormatter.dateFormat = "dd-MM-yyyy"
           datepicker.datePickerMode = .date
           dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
           let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
           datepicker.date = dateNextActionTime ?? Date()
           return true
       }
       else if(textField == tfNextActionTime){
           self.dateFormatter.dateFormat = "hh:mm a"
           datepicker.datePickerMode = .time
           dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        if let dateNextActionTime = dateFormatter.date(from: strNextActionTime){
       
           datepicker.date = dateNextActionTime
        }else{
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm a"
            if let dateNextActionTime1 = dateFormatter.date(from: strNextActionTime){
            datepicker.date = dateNextActionTime1
            }else{
                datepicker.date = Date()
                self.dateFormatter.dateFormat = "hh:mm a"
                tfNextActionTime.text = dateFormatter.string(from: datepicker.date)
            }
        }
           return true
       }else if(textField == tfReminderDate){
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        datepicker.datePickerMode = .date
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        let dateNextActionTime = dateFormatter.date(from: strReminderTime)
        datepicker.date = dateNextActionTime ?? Date()
        return true
    }
    else if(textField == tfReminderTime){
        self.dateFormatter.dateFormat = "hh:mm a"
        datepicker.datePickerMode = .time
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        let dateNextActionTime = dateFormatter.date(from: strReminderTime)
        datepicker.date = dateNextActionTime ?? Date()
        return true
    }else if(textField == tfOrderExpectedDate){
        datepicker.minimumDate = Date()
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        datepicker.datePickerMode = .date
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
      var strorderexpecteddate = ""
        if let stroedt = tfOrderExpectedDate.text as? String{
        strorderexpecteddate = String.init(format:"\(stroedt) 10:00 am")
        }
        if let dateNextActionTime = dateFormatter.date(from: strorderexpecteddate ?? ""){
    
            datepicker.date = dateNextActionTime 
        }else{
            datepicker.date = Date()
        }
        return true
    }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == tfNextActionDate){
            datepicker.datePickerMode = .date
            datepicker.date = AddLeadFourthStep.nextActionDate
        }else if(textField == tfNextActionTime){
            datepicker.datePickerMode = .time
            datepicker.date = AddLeadFourthStep.nextActionDate
        }else if(textField == tfOrderExpectedDate){
            datepicker.datePickerMode = .date
           // datepicker.date = AddLeadFourthStep.orderExpectedDate
        }else  if(textField == tfReminderDate){
            datepicker.datePickerMode = .date
            datepicker.date = AddLeadFourthStep.reminderDate ?? Date()
        }else if(textField == tfReminderTime){
            datepicker.datePickerMode = .time
            datepicker.date = AddLeadFourthStep.reminderDate ?? Date()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == tfAssignSalesPerson){
            AddLeadFourthStep.arrOfLowerLevelUser = BaseViewController.staticlowerUser
            if let selectedcustomer = LeadCustomerDetail.selectedCustomer as? CustomerDetails{
            if let cust  = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:LeadCustomerDetail.selectedCustomer.iD))
                as? CustomerDetails
            {
               // selectedCustomer = cust
                self.changeAssigneeAsperCustomerSelection()
            }
            arrOfLowerLevelUserName =   AddLeadFourthStep.arrOfLowerLevelUser.map{
                String.init(format: "%@ %@", $0.firstName , $0.lastName)
            } as [NSString]
            arrOfFilteredLowerLevelUserName =
                arrOfLowerLevelUserName.filter({(item: NSString) -> Bool in
                    let checkedstr = textField.text//?.trimmingCharacters(in: .whitespaces) ?? "@$W$")
                    let stringMatch1 = item.localizedCaseInsensitiveContains(checkedstr ?? "")
                    
                    return stringMatch1
                })
            arrOfFilteredLowerLeverUser =  AddLeadFourthStep.arrOfLowerLevelUser.filter({ (item:CompanyUsers) -> Bool in
                let checkedstr = (textField.text?.trimmingCharacters(in: .whitespaces) ?? "@$W$")
                let assigneeusername = String.init(format:"\(item.firstName) \(item.lastName)")
                print("assigne name = \(assigneeusername)")
                let stringMatch1 = assigneeusername.localizedCaseInsensitiveContains(checkedstr)
                
                return stringMatch1
            })
            
            
            
            assignUserDropdown.dataSource = arrOfFilteredLowerLevelUserName as [String]
            assignUserDropdown.reloadAllComponents()
            
            assignUserDropdown.show()
            }
            return true
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        /*
         if(textField == tfDate){
             dateFormatter.dateFormat = "dd-MM-yyyy"
             tfDate.text =  dateFormatter.string(from: datepicker.date)
             
             strNextActionTime = ""
             if let strdate = tfDate.text{
                 strNextActionTime.append(strdate)
             }
             if let strtime =  tfTime.text{
                 strNextActionTime.append("  \(strtime)")
             }
            
         
           
         }else{
             dateFormatter.dateFormat = "hh:mm a"
             tfTime.text =  dateFormatter.string(from: datepicker.date)
             strNextActionTime = ""
             if let strdate = tfDate.text{
                 strNextActionTime.append(strdate)
             }
             if let strtime =  tfTime.text{
                 strNextActionTime.append("  \(strtime)")
             }
            
             //Utils.getDate(date: nextactiondate as! NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")
         //Utils.getDateBigFormatToDefaultFormat(date: latestvisitreport.nextActionTime, format: "dd-MM-yyyy")
         }
         **/
        if(textField == tfNextActionDate){
            AddLeadFourthStep.nextActionDate = Utils.getNSDateWithAppendingDay(day: 0, date1: datepicker.date, format: "yyyy/MM/dd HH:mm:ss")
            textField.text = Utils.getDateWithAppendingDay(day: 0, date: AddLeadFourthStep.nextActionDate, format: "dd-MM-yyyy", defaultTimeZone: true)
            tfNextActionTime.text = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.nextActionDate ?? Date(), format: "hh:mm a")
            dateFormatter.dateFormat = "dd-MM-yyyy"
            tfNextActionDate.text =  dateFormatter.string(from: datepicker.date)
            
            strNextActionTime = ""
            if let strdate = tfNextActionDate.text{
                strNextActionTime.append(strdate)
            }
            if let strtime =  tfNextActionTime.text{
                strNextActionTime.append("  \(strtime)")
            }
        }else if(textField == tfNextActionTime){
            AddLeadFourthStep.nextActionDate = Utils.getNSDateWithAppendingDay(day: 0, date1: datepicker.date, format: "yyyy/MM/dd HH:mm:ss")
            textField.text = Utils.getDateWithAppendingDay(day: 0, date: AddLeadFourthStep.nextActionDate, format: "hh:mm a", defaultTimeZone: true)
            dateFormatter.dateFormat = "hh:mm a"
            tfNextActionTime.text =  dateFormatter.string(from: datepicker.date)
            strNextActionTime = ""
            if let strdate = tfNextActionDate.text{
                strNextActionTime.append(strdate)
            }
            if let strtime =  tfNextActionTime.text{
                strNextActionTime.append("  \(strtime)")
            }
        }else if(textField == tfReminderDate){
            AddLeadFourthStep.reminderDate = Utils.getNSDateWithAppendingDay(day: 0, date1: datepicker.date, format: "yyyy/MM/dd HH:mm:ss")
            tfReminderDate.text = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.reminderDate ?? Date(), format: "dd-MM-yyyy")
            tfReminderTime.text = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.reminderDate ?? Date(), format: "hh:mm a")
            AddLeadFourthStep.strReminderDate =  tfReminderDate.text
            dateFormatter.dateFormat = "dd-MM-yyyy"
            tfReminderDate.text =  dateFormatter.string(from: datepicker.date)
            strReminderTime = ""
            if let strdate = tfReminderDate.text{
                strReminderTime.append(strdate)
            }
            if let strtime =  tfReminderTime.text{
                strReminderTime.append("  \(strtime)")
            }
        }else if(textField == tfReminderTime){
            AddLeadFourthStep.reminderDate = Utils.getNSDateWithAppendingDay(day: 0, date1: datepicker.date, format: "yyyy/MM/dd HH:mm:ss")
            tfReminderTime.text = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.reminderDate ?? Date(), format: "hh:mm a")
            AddLeadFourthStep.strReminerTime = tfReminderTime.text
            dateFormatter.dateFormat = "hh:mm a"
            tfReminderTime.text =  dateFormatter.string(from: datepicker.date)
            strReminderTime = ""
            if let strdate = tfReminderDate.text{
                strReminderTime.append(strdate)
            }
            if let strtime =  tfReminderTime.text{
                strReminderTime.append("  \(strtime)")
            }
        }
        else if(textField == tfOrderExpectedDate){
            AddLeadFourthStep.orderExpectedDate = Utils.getNSDateWithAppendingDay(day: 0, date1: datepicker.date, format: "yyyy/MM/dd HH:mm:ss")
            textField.text = Utils.getDateWithAppendingDay(day: 0, date: AddLeadFourthStep.orderExpectedDate, format: "dd-MM-yyyy", defaultTimeZone: true)
        }
    }
}
extension AddLeadFourthStep:UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        AddLeadFourthStep.remarks = textView.text
        AddLeadFourthStep.response = tvActionNeedToCloseOrder.text
        AddLeadFourthStep.positivity = NSNumber.init(value: (6 - slider.index))
        /* if(AddLead.isEditLead == false){
         self.initalleaddic =  AddLead.LeadDic["addleadjson"] as! [String : Any]
         self.initalleaddic["Remarks"] = textView.text
         self.initalleaddic["CustomerOrientationID"] = NSNumber.init(value: (6 - slider.index))
         AddLeadFourthStep.response = tvActionNeedToCloseOrder.text
         if(self.activesetting.showActionCloseOrderInLead == 1){
         AddLeadFourthStep.response = tvActionNeedToCloseOrder.text
         self.initalleaddic["Response"] = AddLeadFourthStep.response
         }else{
         self.initalleaddic["Response"] = ""
         }
         AddLead.LeadDic["addleadjson"] = self.initalleaddic
         }else{
         self.editLeaddic =  AddLead.LeadDic["addleadjson"] as! [String : Any]
         self.editLeaddic["Remarks"] = textView.text
         self.editLeaddic["CustomerOrientationID"] = NSNumber.init(value: (6 - slider.index))
         if(self.activesetting.showActionCloseOrderInLead == 1){
         self.editLeaddic["Response"] = tvActionNeedToCloseOrder.text
         }else{
         self.editLeaddic["Response"] = ""
         }
         AddLead.LeadDic["addleadjson"] = self.editLeaddic
         }*/
    }
}
