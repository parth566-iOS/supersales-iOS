//
//	RootClass.swift
//
//	Create by Mukesh Yadav on 30/12/2019


//
//    RootClass.swift
//
//    Create by Mukesh Yadav on 30/12/2019

import JSONParserSwift

//swiftlint:disable type_body_length
class Setting: ParsableModel {
   // static let shared = Setting()
    
    //swiftlint:disable file_length
    var actionInAutoApprovalSTrade: NSNumber?
    var additionalReminderTextInLead: String?
    var addressSettingsForAttendance: NSNumber!
    var adminInvoiceApproval: NSNumber?
    var adminProposalApproval: NSNumber?
    var adminSalesOrderApproval: NSNumber?
    var alarmReminder: NSNumber?
    var allowMultipleDistributorInPurchaseSTrade: NSNumber?
    var allowInfluencerInCustType:NSNumber?
    var allowDistributorInCustType:NSNumber?
    var allowStockistInCustType:NSNumber?
    var allowEndUserInCustType:NSNumber?
    var allowRetailerInCustType:NSNumber?
    var allowCorporateInCustType:NSNumber?
    var updatedByEndUserInCustType:NSNumber?
    var updatedByStockistInCustType:NSNumber?
    var updatedByDistributorInCustType:NSNumber?
    var updatedByRetailerInCustType:NSNumber?
    var updatedByCorporateInCustType:NSNumber?
    var updatedByInfluencerInCustType:NSNumber?
    var displayDistributorInCustType:String?
    var displayEndUserInCustType:String?
    var displayInfluencerInCustType:String?
    var displayStockistInCustType:String?
    var displayRetailerInCustType:String?
    var displayCorporateInCustType:String?
    
    var allowSalesOnlyIfPurchaseSTrade: NSNumber?
    var allowSelfieInAttendance: NSNumber?
    var allowSrNoInDistributorSTrade: NSNumber?
    var allowZeroPriceInSO: NSNumber?
    var areaSetupType: NSNumber?
    var areaTypeID: NSNumber?
    var assignBeatPlanApproval: NSNumber?
    var autoCheckOutAttendance: NSNumber?
    var barCodeInProduct: NSNumber?
    var cGSTSurcharges: NSNumber?
    var cGSTTax: NSNumber?
    var cSTSurcharges: NSNumber?
    var cSTTax: NSNumber?
    var cSTTaxNumber: String?
    var coldCallReminder: NSNumber?
    var coldCallReminderFirst: NSNumber?
    var coldCallReminderMissed: NSNumber?
    var coldCallReminderSecond: NSNumber?
    var companyID: NSNumber?
    var createBeatPlanApproval: NSNumber?
    var createdBy: NSNumber?
    var createdTime: String?
    var customTagging: NSNumber?
    var customerAVisits: NSNumber?
    var customerApproval:NSNumber?
    var customerBVisits: NSNumber?
    var customerCVisits: NSNumber?
    var customerDVisits: NSNumber?
    var customerInExpense: NSNumber?
    var customerOTPVerification: NSNumber?
    var customerProfileInUnplannedVisit: NSNumber?
    var customerVisitReminder: NSNumber?
    var customerVisitsDuration: NSNumber?
    var dailyVistiApplication: NSNumber?
    var daysToWaitInAutoApprovalSTrade: NSNumber?
    var directSalesOrder: NSNumber?
    var disableCheckoutInVisit: NSNumber?
    var disableOrderFromPlusMenu: NSNumber?
    var disableVisitFromPlusMenu: NSNumber?
    var discountType: NSNumber?
    var discountValue: NSNumber?
    var enableWarrantyIDValidation: NSNumber?
    var endTime: String?
    var exciseDuty: NSNumber?
    var exciseSurcharges: NSNumber?
    var expenseApproval: NSNumber?
    var fOCToggleInSO: NSNumber?
    var firstCheckInAttendance: NSNumber?
    var iD: NSNumber?
    var iGSTSurcharges: NSNumber?
    var iGSTTax: NSNumber?
    var influencerInLead: NSNumber?
    var addSecondInfluencerInLead: NSNumber?
    
    var invoiceConditions: String?
    var invoiceDueDays: NSNumber?
    var invoiceFormat: String?
    var invoiceProductPermission: NSNumber?
    var invoiceReminder: NSNumber?
    var invoiceReminderFirst: NSNumber?
    var invoiceReminderMissed: NSNumber?
    
    var invoiceReminderSecond: NSNumber?
    var invoiceTemplateID: NSNumber?
    var invoiceTerms: String?
    var isActive: NSNumber?
    var isCustomerClassEditable: NSNumber?
    var isFirstSrNoOrProductCodeInSrNo: NSNumber?
    var isLoyaltyEnabled: NSNumber?
    var joinPromotionInCustomerMandatory: NSNumber?
    var lastModifiedBy: NSNumber?
    var lastModifiedTime: String?
    var leadCustomerProfile: NSNumber?
    var leadCustomerProfileURL: String?
    var leadManualCheckInApproval: NSNumber?
    var leadProductPermission: NSNumber?
    var leadQualifiedTextInLead: String?
    var leadReminder: NSNumber?
    var leadReminderFirst: NSNumber?
    var leadReminderMissed: NSNumber?
    var leadReminderSecond: NSNumber?
    var leadsAutoAssign: NSNumber?
    var localTax: NSNumber?
    var localTaxID: NSNumber?
    var locationTrackCustomer: NSNumber?
    var locationTrackSalesForce: NSNumber?
    var manageBom: NSNumber?
    var manageBomDiscount: NSNumber?
    var manageCGST: NSNumber?
    var manageCST: NSNumber?
    var manageExciseDuty: NSNumber?
    var manageIGST: NSNumber?
    var manageLocalTax: NSNumber?
    var managePayment: NSNumber?
    var manageProductPromotionJoin: NSNumber?
    var managePromotionBudget: NSNumber?
    var managePurchaseOrder: NSNumber?
    var manageSGST: NSNumber?
    var manageServiceTax: NSNumber?
    var manageVat: NSNumber?
    var managerApplyManualAttendance: NSNumber?
    var managerApproveCheckInCheckOutUpdate: NSNumber?
    var managerApproveCustomerVendorTravelCheckInCheckOut: NSNumber?
    var managerApproveLeave: NSNumber?
    var managerApproveManualAttendance: NSNumber?
    var managerInvoiceApproval: NSNumber?
    var managerLeadsAssign: NSNumber?
    var managerLeadsReassign: NSNumber?
    var managerPaymentReceivedApproval: NSNumber?
    var managerProposalApproval: NSNumber?
    var managerPurchaseOrderApproval: NSNumber?
    var managerPurchaseOrderCancellation: NSNumber?
    var managerSalesOrderApproval: NSNumber?
    var managerSalesOrderCancellation: NSNumber?
    var managerSalesTargetApproval: NSNumber?
    var managerSelfAssignLead: NSNumber?
    var managerShowTracking: NSNumber?
    var managerTrackSalesExecutive: NSNumber?
    var managerTrackSalesRepresentative: NSNumber?
    var managerWorkingHoursTracking: NSNumber?
    var mandatoryCustomerSegment: NSNumber?
    var mandatoryLeadUpdateStatus: NSNumber?
    var mandatoryPictureInCreateCustomer: NSNumber?
    var mandatoryPictureInVisit: NSNumber?
    var mandatoryTrialSuccessfulStatusForOrderInLead: NSNumber?
    var mandatoryDistributorToStockiestMapping:NSNumber?
    var mandatoryDistributorRetailerMapping:NSNumber?
    var mandatoryVisitReport: NSNumber?
    var maxOrderQty: NSNumber?
    var maximumVisitConfiguration: NSNumber?
    var modeOfPayReferenceRequiredInCollection: NSNumber?
    var customerRequiredInActivity: NSNumber?
    var addParticipantInActivity: NSNumber?
    var monthInInvoiceOrderSuggestQty: NSNumber?
    var negotiationTextInLead: String?
    var oTPConfirmationAtPromotion: NSNumber?
    var pANNumber: String?
    var perHourTravelInKM: NSNumber?
    var plusMenuInVisitDetail: NSNumber?
    var priceEditable: NSNumber?
    var priceEditableDistributorPOSTrade: NSNumber?
    var priceEditableRetailerPOSTrade: NSNumber?
    var productInterestedInUnplannedVisit: NSNumber?
    var productMandatoryInLead: NSNumber?
    var productSelectionTypeInSTrade: NSNumber?
    var proposalConditions: String?
    var proposalFormat: String?
    var proposalProductPermission: NSNumber?
    var proposalSubTextInLead: String?
    var proposalTemplateID: NSNumber?
    var proposalTerms: String?
    var purchaseOrderConditions: String?
    var purchaseOrderFormat: String?
    var purchaseOrderTemplateID: NSNumber?
    var purchaseOrderTerms: String?
    var requireAddNewCustomerInVisitLeadOrder: NSNumber?
    var requireCustCodeInCustomer: NSNumber?
    var requireCustomerTypeInUnplannedVisit: NSNumber?
    var requireDeliveryDaysAndTnCInSO: NSNumber?
    var requireDiscountAndTaxAmountInSO: NSNumber?
    var requireKeyCustInCustomer: NSNumber?
    var requirePromotionInSO: NSNumber?
    var requireSOFromVisitBeforeCheckOut: NSNumber?
    var requireTaxInCustomer: NSNumber?
    var requireTempCustomerProfile: NSNumber?
    var requireTownInCustomer: NSNumber?
    var requireVisitCollection: NSNumber?
    var requireVisitCounterShare: NSNumber?
    var sGSTSurcharges: NSNumber?
    var sGSTTax: NSNumber?
    var sMSInVisitCheckIn: NSNumber?
    var sORequireWarrantyAndDealerCode: NSNumber?
    var salesExecutiveApplyManualAttendance: NSNumber?
    var salesExecutiveApproveCheckInCheckOutUpdate: NSNumber?
    var salesExecutiveApproveCustomerVendorTravelCheckInCheckOut: NSNumber?
    var salesExecutiveApproveLeave: NSNumber?
    var salesExecutiveApproveManualAttendance: NSNumber?
    var salesExecutiveCreateInvoice: NSNumber?
    var salesExecutivePaymentReceivedApproval: NSNumber?
    var salesExecutiveSelfAssignLead: NSNumber?
    var salesExecutiveShowTracking: NSNumber?
    var salesExecutiveTrackSalesRepresentative: NSNumber?
    var salesExecutiveWorkingHoursTracking: NSNumber?
    var salesOrderConditions: String?
    var salesOrderFormat: String?
    var salesOrderFulfillmentFrom: NSNumber?
    var salesOrderProductPermission: NSNumber?
    var salesOrderReportPermission: NSNumber?
    var salesOrderTemplateID: NSNumber?
    var salesOrderTerms: String?
    var salesRepresantativeApplyManualAttendance: NSNumber?
    var salesRepresentativeShowTracking: NSNumber?
    var salesRepresentativeWorkingHoursTracking: NSNumber?
    var sendNotnInSOMaxDiscount: NSNumber?
    var serviceSurcharges: NSNumber?
    var serviceTax: NSNumber?
    var serviceTaxNumber: String?
    var shelfSpaceUnit: String?
    var showActionCloseOrderInLead: NSNumber?
    var showAdditionalReminderInLead: NSNumber?
    var showKPIOnSplashScreen: NSNumber?
    var showLeadQualifiedInLead: NSNumber?
    var showNegotiationInLead: NSNumber?
    var showOurChancesInLead: NSNumber?
    var showProductDrive: NSNumber?
    var showProposalSubInLead: NSNumber?
    var showShelfSpace: NSNumber?
    var showSuggestOrderQty: NSNumber?
    var showTrialDoneInLead: NSNumber?
    var startTime: String?
    var stockUpdateInOrder: NSNumber?
    var storeCheckCompetition: NSNumber?
    var storeCheckOwnBrand: NSNumber?
    var suggestOrderQtyCalculation: NSNumber?
    var territoryInCustomer: NSNumber?
    var territoryMandatoryInBeatPlan: NSNumber?
    var totalCharsInFirstSlab: NSNumber?
    var totalCharsInSrNo: NSNumber?
    var travelCheckInExecutiveApproval: NSNumber?
    var travelCheckInManagerApproval: NSNumber?
    var trialDoneTextInLead: String?
    var vATAdditionalTax: NSNumber?
    var vATSurcharges: NSNumber?
    var vATTax: NSNumber?
    var vATTaxNumber: String?
    var vatCodeFrom: NSNumber?
    var vatGst: NSNumber?
    var viewCompanyStock: NSNumber?
    var visitCheckInApproval: NSNumber?
    var visitCheckInCheckoutDiff: NSNumber?
    var visitManualCheckInApproval: NSNumber?
    var visitMenuOnHomeScreen: NSNumber?
    var visitModule: NSNumber?
    var visitProductPermission: NSNumber?
    var visitReminder: NSNumber?
    var visitReminderFirst: NSNumber?
    var visitReminderMissed: NSNumber?
    var visitReminderSecond: NSNumber?
    var visitStepsRequired: NSNumber?
    var salesOrderLoadPage: NSNumber?
   
    
    
    //MARK: Setting For Add Edit Customer 8/4/22
   
    var customerMobileValidation:NSNumber?  = NSNumber.init(value: 0)
    var custMobileNoLength:NSNumber? = NSNumber.init(value: 0)
    var requiLandLineNumInCustomer:NSNumber? = NSNumber.init(value: 0)
    var requiImagesInCustomer:NSNumber? = NSNumber.init(value: 0)
    var requiredSegmentInCustomer:NSNumber? = NSNumber.init(value: 0)
    var requiBirthDateInCustomer:NSNumber? = NSNumber.init(value: 0)
    var requiAnniversaryDateInCustomer:NSNumber? = NSNumber.init(value: 0)
    var requiEmailOrderToInCustomer:NSNumber? = NSNumber.init(value: 0)
    var requiredBeatPlanDropDownInCustomer:NSNumber? = NSNumber.init(value: 0)
    var requiContactInCustomer:NSNumber? = NSNumber.init(value: 0)
    var requiredClassInCustomer:NSNumber? = NSNumber.init(value: 0)
    var requiVCardInCustomer:NSNumber? = NSNumber.init(value: 0)
    var requiEmailIDInCustomer:NSNumber? = NSNumber.init(value: 0)
    var requiDescriInCustomer:NSNumber? = NSNumber.init(value: 0)
    var requireCustomerKYC:NSNumber? = NSNumber.init(value: 0)
  
    var mandatoryCustomerContact:NSNumber? = NSNumber.init(value: 0)
    var requireCustomerAadharKYC:NSNumber? = NSNumber.init(value: 0)
    var percentageOfSharedRoom:NSNumber? = NSNumber.init(value: 0)
   
    var leadStage6Text: String?
    var leadStage5Text: String?
    var classA:String = ""
    var classB:String = ""
    var classC:String = ""
    var classD:String = ""
   
    var exportCustomerURL:String = ""
    
    //visit report
    var requiContactPersonInVisitReport:NSNumber? = NSNumber.init(value: 0)
    var requiInteractionDateTimeInVisitReport:NSNumber? = NSNumber.init(value: 0)
    
    
    //visit
    var allowEditVisitDataForPreviousDate:NSNumber? = NSNumber.init(value: 0)
    var requiStoreCheckConditionInVisit:NSNumber? = NSNumber.init(value: 0)
    var RequiContactPersonInAddVisit:NSNumber? = NSNumber.init(value: 0)
    
    
    var miniNoOfVisitFrValidAtte:NSNumber? = NSNumber.init(value: 0)
    var requiredValidAttendance:NSNumber? = NSNumber.init(value: 0)
    
    var contactBecomeCustomerInColdCall:NSNumber? = NSNumber.init(value: 0)
    var requireCustomerShopEstKYC:NSNumber? = NSNumber.init(value: 0)
    var visitUpdateStockProductPermission:NSNumber? = NSNumber.init(value: 0)
    var autoSharingOrderToRetailer:NSNumber? = NSNumber.init(value: 0)
    var askBeforeCloseLeadAfterSalesOrderCreate:NSNumber? = NSNumber.init(value: 0)
    var autoSharingOrderToDistributor:NSNumber? = NSNumber.init(value: 0)
    var inventoryForRetailerSTrade:NSNumber? = NSNumber.init(value: 0)
    var isExecutiveCanDownloadCustReport:NSNumber? = NSNumber.init(value: 0)
    var requireCustomerPanKYC:NSNumber? = NSNumber.init(value: 0)
    var customerPotential:NSNumber? = NSNumber.init(value: 0)
    var maxDiscountManagerApproval:NSNumber? = NSNumber.init(value: 0)
    var enableTownVisitTarget:NSNumber? = NSNumber.init(value: 0)
    var inventoryForDistributorSTrade:NSNumber? = NSNumber.init(value: 0)
    
   
    var leadStage5:NSNumber? = NSNumber.init(value: 0)
    var leadStage6:NSNumber? = NSNumber.init(value: 0)
  
    
    var requireCustomerOtherKYC:NSNumber? = NSNumber.init(value: 0)
   
  
    var autoSharingOrderToManager:NSNumber? = NSNumber.init(value: 0)
    var requiStoreCheckJustificationInVisitInCompetitor:NSNumber? = NSNumber.init(value: 0)
    var requireCustomerGstKYC:NSNumber? = NSNumber.init(value: 0)
    var gstTaxNumber:NSNumber? = NSNumber.init(value: 0)
    var allowCreatorToUpdateDespatch:NSNumber? = NSNumber.init(value: 0)
    var requiInteractionTypeInVisitReport:NSNumber? = NSNumber.init(value: 0)
    var requireCustomerVoterKYC:NSNumber? = NSNumber.init(value: 0)
    var isDisplayLoadCustomFormDataButton:NSNumber? = NSNumber.init(value: 0)
    var allowEditOrderForPreviousDate:NSNumber? = NSNumber.init(value: 0)
    var allowNegInventoryRetailerSTrade:NSNumber? = NSNumber.init(value: 0)
    var smsDailyReportToManager:NSNumber? = NSNumber.init(value: 0)
    var splashScreenUponVisitCheckin:NSNumber? = NSNumber.init(value: 0)
    var apiForCustomerHistory:NSNumber? = NSNumber.init(value: 0)
    var immediateManagerApproval:NSNumber? = NSNumber.init(value: 0)
    var smsDailyReportToManagersManager:NSNumber? = NSNumber.init(value: 0)
    var distributorToStockistMappingInCustomer:NSNumber? = NSNumber.init(value: 0)
    var displayNextMeetingTimeInColdCall:NSNumber? = NSNumber.init(value: 0)
    var warrentyIDFirstTwoDigit:NSNumber? = NSNumber.init(value: 0)
    var visitCloseOtpRequireOrNot:NSNumber? = NSNumber.init(value: 0)
    var requiProductInAddVisit:NSNumber? = NSNumber.init(value: 0)
    var requiInteractionTypeInAddVisit:NSNumber? = NSNumber.init(value: 0)
    var autoSharingOrderToCreator:NSNumber? = NSNumber.init(value: 0)
    var requireCustomerDrivingLicenceKYC:NSNumber? = NSNumber.init(value: 0)
    var warrantyIDNoOfDigit:NSNumber? = NSNumber.init(value: 0)
    var exportCustomerEnableDisable:NSNumber? = NSNumber.init(value: 0)
    var requiStoreCheckJustificationInVisit:NSNumber? = NSNumber.init(value: 0)
    var requiDirectVisitFromLeadInAddVisit:NSNumber? = NSNumber.init(value: 0)
    var freezeOpeningStockSTrade:NSNumber? = NSNumber.init(value: 0)
    var allowNegInventoryDistributorSTrade:NSNumber? = NSNumber.init(value: 0)
    var miniTimeOfVisitFrValid:NSNumber? = NSNumber.init(value: 0)
    var noOfDayForApprOfDeviInVAtte:NSNumber? = NSNumber.init(value: 0)
    var issueManagementEnable:NSNumber? = NSNumber.init(value: 0)
    var sendSMSToCustUponCreationPlannedVisit:NSNumber? = NSNumber.init(value: 0)
    var numberOfKYC:NSNumber? = NSNumber.init(value: 0)
    var nextActionNewVisitCreation = 0
    var closeVisitAtEndOfDay = 0
    var closeVisitUpon = 0
    var visitToBeDownloadedUponLogin = 0
    var percentageOfSelfAccomodation = NSNumber.init(value: 0)
    var RequireMedicalInSL:NSNumber? = NSNumber.init(value: 0)
    var MinSLReqForMedical: NSNumber? = NSNumber.init(value: 0)
    var mandatoryRemarksInLeadStatus:NSNumber? = NSNumber.init(value: 0)
    var mandatoryRemarkInvisitReport:NSNumber? = NSNumber.init(value: 0)
//singleton class
//    static let shared = Setting()

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    // swiftlint:disable function_body_length
    required  init(dictionary: [String:Any]){
        super.init(dictionary: [:])
       //print("Dictionary is = \(dictionary)")
        RequireMedicalInSL = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "RequireMedicalInSL")
        MinSLReqForMedical = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "MinSLReqForMedical")
        mandatoryRemarksInLeadStatus = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "mandatoryRemarksInLeadStatus")
        mandatoryRemarkInvisitReport = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "mandatoryRemarkInvisitReport")
        
        percentageOfSelfAccomodation = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "percentageOfSelfAccomodation")
        percentageOfSharedRoom = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "percentageOfSharedRoom")
        actionInAutoApprovalSTrade = dictionary["ActionInAutoApprovalSTrade"] as? NSNumber
        addParticipantInActivity = dictionary["AddParticipantInActivity"] as? NSNumber
        customerRequiredInActivity = dictionary["CustomerRequiredInActivity"] as? NSNumber
        additionalReminderTextInLead = dictionary["AdditionalReminderTextInLead"] as? String
        addressSettingsForAttendance = dictionary["AddressSettingsForAttendance"] as? NSNumber ?? NSNumber.init(value:0)
        adminInvoiceApproval = dictionary["AdminInvoiceApproval"] as? NSNumber
        adminProposalApproval = dictionary["AdminProposalApproval"] as? NSNumber
        adminSalesOrderApproval = dictionary["AdminSalesOrderApproval"] as? NSNumber
        alarmReminder = dictionary["AlarmReminder"] as? NSNumber
        allowInfluencerInCustType = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "allowInfluencerInCustType")//dictionary["allowInfluencerInCustType"] as? NSNumber

        allowStockistInCustType = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "allowStockistInCustType")//dictionary["allowStockistInCustType"] as? NSNumber
        allowRetailerInCustType = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "allowRetailerInCustType")//dictionary["allowRetailerInCustType"] as? NSNumber
        allowCorporateInCustType = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "allowCorporateInCustType")//dictionary["allowCorporateInCustType"] as? NSNumber
        allowDistributorInCustType = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "allowDistributorInCustType")//dictionary["allowDistributorInCustType"] as? NSNumber
        allowEndUserInCustType = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "allowEndUserInCustType")//dictionary["allowEndUserInCustType"] as? NSNumber
        updatedByStockistInCustType = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "updatedByStockistInCustType")//dictionary["updatedByStockistInCustType"] as? NSNumber
        updatedByRetailerInCustType = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "updatedByRetailerInCustType")//dictionary["updatedByRetailerInCustType"] as? NSNumber
        updatedByCorporateInCustType = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "updatedByCorporateInCustType")//dictionary["updatedByCorporateInCustType"] as? NSNumber
        updatedByInfluencerInCustType = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "updatedByInfluencerInCustType")//dictionary["updatedByInfluencerInCustType"] as? NSNumber
        updatedByDistributorInCustType = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "updatedByDistributorInCustType")//dictionary["updatedByDistributorInCustType"] as? NSNumber
        updatedByEndUserInCustType = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "updatedByEndUserInCustType")//dictionary["updatedByEndUserInCustType"] as? NSNumber
    

        allowMultipleDistributorInPurchaseSTrade = dictionary["AllowMultipleDistributorInPurchaseSTrade"] as? NSNumber
        allowSalesOnlyIfPurchaseSTrade = dictionary["AllowSalesOnlyIfPurchaseSTrade"] as? NSNumber
        allowSelfieInAttendance = dictionary["AllowSelfieInAttendance"] as? NSNumber
        allowSrNoInDistributorSTrade = dictionary["AllowSrNoInDistributorSTrade"] as? NSNumber
        allowZeroPriceInSO = dictionary["AllowZeroPriceInSO"] as? NSNumber
        areaSetupType = dictionary["AreaSetupType"] as? NSNumber
        areaTypeID = dictionary["AreaTypeID"] as? NSNumber
        assignBeatPlanApproval = dictionary["AssignBeatPlanApproval"] as? NSNumber
        autoCheckOutAttendance = dictionary["AutoCheckOutAttendance"] as? NSNumber
        barCodeInProduct = dictionary["BarCodeInProduct"] as? NSNumber
        cGSTSurcharges = dictionary["CGSTSurcharges"] as? NSNumber
        cGSTTax = dictionary["CGSTTax"] as? NSNumber
        cSTSurcharges = dictionary["CSTSurcharges"] as? NSNumber
        cSTTax = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "CSTTax")//dictionary["CSTTax"] as? NSNumber
        cSTTaxNumber = dictionary["CSTTaxNumber"] as? String
        coldCallReminder = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "ColdCallReminder")//dictionary["ColdCallReminder"] as? NSNumber
        coldCallReminderFirst = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "ColdCallReminderFirst")//dictionary["ColdCallReminderFirst"] as? NSNumber
        coldCallReminderMissed = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "ColdCallReminderMissed")//dictionary["ColdCallReminderMissed"] as? NSNumber
        coldCallReminderSecond = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "ColdCallReminderSecond")//dictionary["ColdCallReminderSecond"] as? NSNumber
        companyID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "CompanyID")//dictionary["CompanyID"] as? NSNumber
        createBeatPlanApproval = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "CreateBeatPlanApproval")//dictionary["CreateBeatPlanApproval"] as? NSNumber
        createdBy = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "CreatedBy")//dictionary["CreatedBy"] as? NSNumber
        displayStockistInCustType = Common.returndefaultstring(dic: dictionary, keyvalue: "displayStockistInCustType")//dictionary["displayStockistInCustType"] as? String
        displayRetailerInCustType = Common.returndefaultstring(dic: dictionary, keyvalue: "displayRetailerInCustType")//dictionary["displayRetailerInCustType"] as? String
        displayCorporateInCustType = Common.returndefaultstring(dic: dictionary, keyvalue: "displayCorporateInCustType")//dictionary["displayCorporateInCustType"] as? String
        displayInfluencerInCustType = Common.returndefaultstring(dic: dictionary, keyvalue: "displayInfluencerInCustType")//dictionary["displayInfluencerInCustType"] as? String
        displayDistributorInCustType = Common.returndefaultstring(dic: dictionary, keyvalue: "displayDistributorInCustType")//dictionary["displayDistributorInCustType"] as? String
        displayEndUserInCustType = Common.returndefaultstring(dic: dictionary, keyvalue: "displayEndUserInCustType")//dictionary["displayEndUserInCustType"] as? String
        createdTime =  Common.returndefaultstring(dic: dictionary, keyvalue: "CreatedTime")//dictionary["CreatedTime"] as? String
        customTagging = dictionary["CustomTagging"] as? NSNumber
        customerAVisits = dictionary["CustomerAVisits"] as? NSNumber
        customerBVisits = dictionary["CustomerBVisits"] as? NSNumber
        customerApproval = dictionary["CustomerApproval"] as? NSNumber
        customerCVisits = dictionary["CustomerCVisits"] as? NSNumber
        customerDVisits = dictionary["CustomerDVisits"] as? NSNumber
        customerInExpense = dictionary["CustomerInExpense"] as? NSNumber
        customerOTPVerification = dictionary["CustomerOTPVerification"] as? NSNumber
        customerProfileInUnplannedVisit = dictionary["CustomerProfileInUnplannedVisit"] as? NSNumber
        customerVisitReminder = dictionary["CustomerVisitReminder"] as? NSNumber
        customerVisitsDuration = dictionary["CustomerVisitsDuration"] as? NSNumber
        dailyVistiApplication = dictionary["DailyVistiApplication"] as? NSNumber
        daysToWaitInAutoApprovalSTrade = dictionary["DaysToWaitInAutoApprovalSTrade"] as? NSNumber
        directSalesOrder = dictionary["DirectSalesOrder"] as? NSNumber
        disableCheckoutInVisit = dictionary["DisableCheckoutInVisit"] as? NSNumber
        disableOrderFromPlusMenu = dictionary["DisableOrderFromPlusMenu"] as? NSNumber
        disableVisitFromPlusMenu = dictionary["DisableVisitFromPlusMenu"] as? NSNumber
        discountType = dictionary["DiscountType"] as? NSNumber
        discountValue = dictionary["DiscountValue"] as? NSNumber
        enableWarrantyIDValidation = dictionary["EnableWarrantyIDValidation"] as? NSNumber
        endTime = dictionary["EndTime"] as? String
        exciseDuty = dictionary["ExciseDuty"] as? NSNumber
        exciseSurcharges = dictionary["ExciseSurcharges"] as? NSNumber
        expenseApproval = dictionary["ExpenseApproval"] as? NSNumber
        fOCToggleInSO = dictionary["FOCToggleInSO"] as? NSNumber
        firstCheckInAttendance = dictionary["FirstCheckInAttendance"] as? NSNumber
        iD = dictionary["ID"] as? NSNumber
        iGSTSurcharges = dictionary["IGSTSurcharges"] as? NSNumber
        iGSTTax = dictionary["IGSTTax"] as? NSNumber
        influencerInLead = dictionary["InfluencerInLead"] as? NSNumber
        addSecondInfluencerInLead = dictionary["AddSecondInfluencerInLead"] as? NSNumber
        
        invoiceConditions = dictionary["InvoiceConditions"] as? String
        invoiceDueDays = dictionary["InvoiceDueDays"] as? NSNumber
        invoiceFormat = dictionary["InvoiceFormat"] as? String
        invoiceProductPermission = dictionary["InvoiceProductPermission"] as? NSNumber
        invoiceReminder = dictionary["InvoiceReminder"] as? NSNumber
        invoiceReminderFirst = dictionary["InvoiceReminderFirst"] as? NSNumber
        invoiceReminderMissed = dictionary["InvoiceReminderMissed"] as? NSNumber
        invoiceReminderSecond = dictionary["InvoiceReminderSecond"] as? NSNumber
        invoiceTemplateID = dictionary["InvoiceTemplateID"] as? NSNumber
        invoiceTerms = dictionary["InvoiceTerms"] as? String
        isActive = dictionary["IsActive"] as? NSNumber
        isCustomerClassEditable = dictionary["IsCustomerClassEditable"] as? NSNumber
        isFirstSrNoOrProductCodeInSrNo = dictionary["IsFirstSrNoOrProductCodeInSrNo"] as? NSNumber
        isLoyaltyEnabled = dictionary["IsLoyaltyEnabled"] as? NSNumber
        joinPromotionInCustomerMandatory = dictionary["JoinPromotionInCustomerMandatory"] as? NSNumber
        lastModifiedBy = dictionary["LastModifiedBy"] as? NSNumber
        lastModifiedTime = dictionary["LastModifiedTime"] as? String
        leadCustomerProfile = dictionary["LeadCustomerProfile"] as? NSNumber
        leadCustomerProfileURL = dictionary["LeadCustomerProfileURL"] as? String
        leadManualCheckInApproval = dictionary["LeadManualCheckInApproval"] as? NSNumber
        leadProductPermission = dictionary["LeadProductPermission"] as? NSNumber
        leadQualifiedTextInLead = dictionary["LeadQualifiedTextInLead"] as? String
        leadReminder = dictionary["LeadReminder"] as? NSNumber
        leadStage5Text = dictionary["leadStage5Text"] as? String ?? ""
        nextActionNewVisitCreation = dictionary["nextActionNewVisitCreation"] as? Int ?? 0
        
        
        leadReminderFirst = dictionary["LeadReminderFirst"] as? NSNumber
        leadReminderMissed = dictionary["LeadReminderMissed"] as? NSNumber
        leadReminderSecond = dictionary["LeadReminderSecond"] as? NSNumber
        leadsAutoAssign = dictionary["LeadsAutoAssign"] as? NSNumber
        localTax = dictionary["LocalTax"] as? NSNumber
        localTaxID = dictionary["LocalTaxID"] as? NSNumber
        locationTrackCustomer = dictionary["LocationTrackCustomer"] as? NSNumber
        locationTrackSalesForce = dictionary["LocationTrackSalesForce"] as? NSNumber
        manageBom = dictionary["ManageBom"] as? NSNumber
        manageBomDiscount = dictionary["ManageBomDiscount"] as? NSNumber
        manageCGST = dictionary["ManageCGST"] as? NSNumber
        manageCST = dictionary["ManageCST"] as? NSNumber
        manageExciseDuty = dictionary["ManageExciseDuty"] as? NSNumber
        manageIGST = dictionary["ManageIGST"] as? NSNumber
        manageLocalTax = dictionary["ManageLocalTax"] as? NSNumber
        managePayment = dictionary["ManagePayment"] as? NSNumber
        manageProductPromotionJoin = dictionary["ManageProductPromotionJoin"] as? NSNumber
        managePromotionBudget = dictionary["ManagePromotionBudget"] as? NSNumber
        managePurchaseOrder = dictionary["ManagePurchaseOrder"] as? NSNumber
        manageSGST = dictionary["ManageSGST"] as? NSNumber
        manageServiceTax = dictionary["ManageServiceTax"] as? NSNumber
        manageVat = dictionary["ManageVat"] as? NSNumber
        mandatoryDistributorToStockiestMapping = dictionary["mandatoryDistributorToStockiestMapping"] as? NSNumber
        mandatoryDistributorRetailerMapping = dictionary["mandatoryDistributorRetailerMapping"] as? NSNumber
        managerApplyManualAttendance = dictionary["ManagerApplyManualAttendance"] as? NSNumber
        managerApproveCheckInCheckOutUpdate = dictionary["ManagerApproveCheckInCheckOutUpdate"] as? NSNumber
        managerApproveCustomerVendorTravelCheckInCheckOut = dictionary["ManagerApproveCustomerVendorTravelCheckInCheckOut"] as? NSNumber
        managerApproveLeave = dictionary["ManagerApproveLeave"] as? NSNumber
        managerApproveManualAttendance = dictionary["ManagerApproveManualAttendance"] as? NSNumber
        managerInvoiceApproval = dictionary["ManagerInvoiceApproval"] as? NSNumber
        managerLeadsAssign = dictionary["ManagerLeadsAssign"] as? NSNumber
        managerLeadsReassign = dictionary["ManagerLeadsReassign"] as? NSNumber
        managerPaymentReceivedApproval = dictionary["ManagerPaymentReceivedApproval"] as? NSNumber
        managerProposalApproval = dictionary["ManagerProposalApproval"] as? NSNumber
        managerPurchaseOrderApproval = dictionary["ManagerPurchaseOrderApproval"] as? NSNumber
        managerPurchaseOrderCancellation = dictionary["ManagerPurchaseOrderCancellation"] as? NSNumber
        managerSalesOrderApproval = dictionary["ManagerSalesOrderApproval"] as? NSNumber
        managerSalesOrderCancellation = dictionary["ManagerSalesOrderCancellation"] as? NSNumber
        managerSalesTargetApproval = dictionary["ManagerSalesTargetApproval"] as? NSNumber
        managerSelfAssignLead = dictionary["ManagerSelfAssignLead"] as? NSNumber
        managerShowTracking = dictionary["ManagerShowTracking"] as? NSNumber
        managerTrackSalesExecutive = dictionary["ManagerTrackSalesExecutive"] as? NSNumber
        managerTrackSalesRepresentative = dictionary["ManagerTrackSalesRepresentative"] as? NSNumber
        managerWorkingHoursTracking = dictionary["ManagerWorkingHoursTracking"] as? NSNumber
        mandatoryCustomerSegment = dictionary["MandatoryCustomerSegment"] as? NSNumber
        mandatoryLeadUpdateStatus = dictionary["MandatoryLeadUpdateStatus"] as? NSNumber
        mandatoryPictureInCreateCustomer = dictionary["MandatoryPictureInCreateCustomer"] as? NSNumber
        mandatoryPictureInVisit = dictionary["MandatoryPictureInVisit"] as? NSNumber
        mandatoryTrialSuccessfulStatusForOrderInLead = dictionary["MandatoryTrialSuccessfulStatusForOrderInLead"] as? NSNumber
        mandatoryVisitReport = dictionary["MandatoryVisitReport"] as? NSNumber
        maxOrderQty = dictionary["MaxOrderQty"] as? NSNumber
        maximumVisitConfiguration = dictionary["MaximumVisitConfiguration"] as? NSNumber
        modeOfPayReferenceRequiredInCollection = dictionary["ModeOfPayReferenceRequiredInCollection"] as? NSNumber
        monthInInvoiceOrderSuggestQty = dictionary["MonthInInvoiceOrderSuggestQty"] as? NSNumber
        negotiationTextInLead = dictionary["NegotiationTextInLead"] as? String
        oTPConfirmationAtPromotion = dictionary["OTPConfirmationAtPromotion"] as? NSNumber
        pANNumber = dictionary["PANNumber"] as? String
        perHourTravelInKM = dictionary["PerHourTravelInKM"] as? NSNumber
        plusMenuInVisitDetail = dictionary["PlusMenuInVisitDetail"] as? NSNumber
        priceEditable = dictionary["PriceEditable"] as? NSNumber
        priceEditableDistributorPOSTrade = dictionary["PriceEditableDistributorPOSTrade"] as? NSNumber
        priceEditableRetailerPOSTrade = dictionary["PriceEditableRetailerPOSTrade"] as? NSNumber
        productInterestedInUnplannedVisit = dictionary["ProductInterestedInUnplannedVisit"] as? NSNumber
        productMandatoryInLead = dictionary["ProductMandatoryInLead"] as? NSNumber
        productSelectionTypeInSTrade = dictionary["ProductSelectionTypeInSTrade"] as? NSNumber
        proposalConditions = dictionary["ProposalConditions"] as? String
        proposalFormat = dictionary["ProposalFormat"] as? String
        proposalProductPermission = dictionary["ProposalProductPermission"] as? NSNumber
        proposalSubTextInLead = dictionary["ProposalSubTextInLead"] as? String
        proposalTemplateID = dictionary["ProposalTemplateID"] as? NSNumber
        proposalTerms = dictionary["ProposalTerms"] as? String
        purchaseOrderConditions = dictionary["PurchaseOrderConditions"] as? String
        purchaseOrderFormat = dictionary["PurchaseOrderFormat"] as? String
        purchaseOrderTemplateID = dictionary["PurchaseOrderTemplateID"] as? NSNumber
        purchaseOrderTerms = dictionary["PurchaseOrderTerms"] as? String
        requireAddNewCustomerInVisitLeadOrder = dictionary["RequireAddNewCustomerInVisitLeadOrder"] as? NSNumber
        requireCustCodeInCustomer = dictionary["RequireCustCodeInCustomer"] as? NSNumber
        requireCustomerTypeInUnplannedVisit = dictionary["RequireCustomerTypeInUnplannedVisit"] as? NSNumber
        requireDeliveryDaysAndTnCInSO = dictionary["RequireDeliveryDaysAndTnCInSO"] as? NSNumber
        requireDiscountAndTaxAmountInSO = dictionary["RequireDiscountAndTaxAmountInSO"] as? NSNumber
        requireKeyCustInCustomer = dictionary["RequireKeyCustInCustomer"] as? NSNumber
        requirePromotionInSO = dictionary["RequirePromotionInSO"] as? NSNumber
        requireSOFromVisitBeforeCheckOut = dictionary["RequireSOFromVisitBeforeCheckOut"] as? NSNumber
        requireTaxInCustomer = dictionary["RequireTaxInCustomer"] as? NSNumber
        requireTempCustomerProfile = dictionary["RequireTempCustomerProfile"] as? NSNumber
        requireTownInCustomer = dictionary["RequireTownInCustomer"] as? NSNumber
        requireVisitCollection = dictionary["RequireVisitCollection"] as? NSNumber
        requireVisitCounterShare = dictionary["RequireVisitCounterShare"] as? NSNumber
        sGSTSurcharges = dictionary["SGSTSurcharges"] as? NSNumber
        sGSTTax = dictionary["SGSTTax"] as? NSNumber
        sMSInVisitCheckIn = dictionary["SMSInVisitCheckIn"] as? NSNumber
        sORequireWarrantyAndDealerCode = dictionary["SORequireWarrantyAndDealerCode"] as? NSNumber
        salesExecutiveApplyManualAttendance = dictionary["SalesExecutiveApplyManualAttendance"] as? NSNumber
        salesExecutiveApproveCheckInCheckOutUpdate = dictionary["SalesExecutiveApproveCheckInCheckOutUpdate"] as? NSNumber
        salesExecutiveApproveCustomerVendorTravelCheckInCheckOut = dictionary["SalesExecutiveApproveCustomerVendorTravelCheckInCheckOut"] as? NSNumber
        salesExecutiveApproveLeave = dictionary["SalesExecutiveApproveLeave"] as? NSNumber
        salesExecutiveApproveManualAttendance = dictionary["SalesExecutiveApproveManualAttendance"] as? NSNumber
        salesExecutiveCreateInvoice = dictionary["SalesExecutiveCreateInvoice"] as? NSNumber
        salesExecutivePaymentReceivedApproval = dictionary["SalesExecutivePaymentReceivedApproval"] as? NSNumber
        salesExecutiveSelfAssignLead = dictionary["SalesExecutiveSelfAssignLead"] as? NSNumber
        salesExecutiveShowTracking = dictionary["SalesExecutiveShowTracking"] as? NSNumber
        salesExecutiveTrackSalesRepresentative = dictionary["SalesExecutiveTrackSalesRepresentative"] as? NSNumber
        salesExecutiveWorkingHoursTracking = dictionary["SalesExecutiveWorkingHoursTracking"] as? NSNumber
        salesOrderConditions = dictionary["SalesOrderConditions"] as? String
        salesOrderFormat = dictionary["SalesOrderFormat"] as? String
        salesOrderFulfillmentFrom = dictionary["SalesOrderFulfillmentFrom"] as? NSNumber
        salesOrderProductPermission = dictionary["SalesOrderProductPermission"] as? NSNumber
        salesOrderReportPermission = dictionary["SalesOrderReportPermission"] as? NSNumber
        salesOrderTemplateID = dictionary["SalesOrderTemplateID"] as? NSNumber
        salesOrderTerms = dictionary["SalesOrderTerms"] as? String
        salesRepresantativeApplyManualAttendance = dictionary["SalesRepresantativeApplyManualAttendance"] as? NSNumber
        salesRepresentativeShowTracking = dictionary["SalesRepresentativeShowTracking"] as? NSNumber
        salesRepresentativeWorkingHoursTracking = dictionary["SalesRepresentativeWorkingHoursTracking"] as? NSNumber
        sendNotnInSOMaxDiscount = dictionary["SendNotnInSOMaxDiscount"] as? NSNumber
        serviceSurcharges = dictionary["ServiceSurcharges"] as? NSNumber
        serviceTax = dictionary["ServiceTax"] as? NSNumber
        serviceTaxNumber = dictionary["ServiceTaxNumber"] as? String
        shelfSpaceUnit = dictionary["ShelfSpaceUnit"] as? String
        showActionCloseOrderInLead = dictionary["ShowActionCloseOrderInLead"] as? NSNumber
        showAdditionalReminderInLead = dictionary["ShowAdditionalReminderInLead"] as? NSNumber
        showKPIOnSplashScreen = dictionary["ShowKPIOnSplashScreen"] as? NSNumber
        showLeadQualifiedInLead = dictionary["ShowLeadQualifiedInLead"] as? NSNumber
        showNegotiationInLead = dictionary["ShowNegotiationInLead"] as? NSNumber
        showOurChancesInLead = dictionary["ShowOurChancesInLead"] as? NSNumber
        showProductDrive = dictionary["ShowProductDrive"] as? NSNumber
        showProposalSubInLead = dictionary["ShowProposalSubInLead"] as? NSNumber
        showShelfSpace = dictionary["ShowShelfSpace"] as? NSNumber
        showSuggestOrderQty = dictionary["ShowSuggestOrderQty"] as? NSNumber
        showTrialDoneInLead = dictionary["ShowTrialDoneInLead"] as? NSNumber
        startTime = dictionary["StartTime"] as? String
        stockUpdateInOrder = dictionary["StockUpdateInOrder"] as? NSNumber
        storeCheckCompetition = dictionary["StoreCheckCompetition"] as? NSNumber
        storeCheckOwnBrand = dictionary["StoreCheckOwnBrand"] as? NSNumber
        suggestOrderQtyCalculation = dictionary["SuggestOrderQtyCalculation"] as? NSNumber
        territoryInCustomer = dictionary["TerritoryInCustomer"] as? NSNumber
        territoryMandatoryInBeatPlan = dictionary["TerritoryMandatoryInBeatPlan"] as? NSNumber
        totalCharsInFirstSlab = dictionary["TotalCharsInFirstSlab"] as? NSNumber
        totalCharsInSrNo = dictionary["TotalCharsInSrNo"] as? NSNumber
        travelCheckInExecutiveApproval = dictionary["TravelCheckInExecutiveApproval"] as? NSNumber
        travelCheckInManagerApproval = dictionary["TravelCheckInManagerApproval"] as? NSNumber
        trialDoneTextInLead = dictionary["TrialDoneTextInLead"] as? String
        vATAdditionalTax = dictionary["VATAdditionalTax"] as? NSNumber
        vATSurcharges = dictionary["VATSurcharges"] as? NSNumber
        vATTax = dictionary["VATTax"] as? NSNumber
        vATTaxNumber = dictionary["VATTaxNumber"] as? String
        vatCodeFrom = dictionary["VatCodeFrom"] as? NSNumber
        vatGst = dictionary["VatGst"] as? NSNumber
        viewCompanyStock = dictionary["ViewCompanyStock"] as? NSNumber
        visitCheckInApproval = dictionary["VisitCheckInApproval"] as? NSNumber
        visitCheckInCheckoutDiff = dictionary["VisitCheckInCheckoutDiff"] as? NSNumber
        visitManualCheckInApproval = dictionary["VisitManualCheckInApproval"] as? NSNumber
        visitMenuOnHomeScreen = dictionary["VisitMenuOnHomeScreen"] as? NSNumber
        visitModule = dictionary["VisitModule"] as? NSNumber
        visitProductPermission = dictionary["VisitProductPermission"] as? NSNumber
        visitReminder = dictionary["VisitReminder"] as? NSNumber
        visitReminderFirst = dictionary["VisitReminderFirst"] as? NSNumber
        visitReminderMissed = dictionary["VisitReminderMissed"] as? NSNumber
        visitReminderSecond = dictionary["VisitReminderSecond"] as? NSNumber
        visitStepsRequired = dictionary["VisitStepsRequired"] as? NSNumber
        salesOrderLoadPage = dictionary["SalesOrderLoadPage"] as? NSNumber
    
        
        
        
        exportCustomerURL = Common.returndefaultstring(dic: dictionary, keyvalue: "exportCustomerURL")
        
        classB = Common.returndefaultstring(dic: dictionary, keyvalue: "classB")
        
        leadStage6Text = Common.returndefaultstring(dic: dictionary, keyvalue: "leadStage6Text")
        
        
        
        classA = Common.returndefaultstring(dic: dictionary, keyvalue: "classA")
        
        classC = Common.returndefaultstring(dic: dictionary, keyvalue: "classC")
        
        classD = Common.returndefaultstring(dic: dictionary, keyvalue: "classD")
        
        
        requireCustomerAadharKYC = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requireCustomerAadharKYC")
        
        requiContactPersonInVisitReport = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "RequiContactPersonInVisitReport")
        
        
        
        
        mandatoryCustomerContact = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "MandatoryCustomerContact")
        
        requireCustomerKYC = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requireCustomerKYC")
        
       
        
        requiDescriInCustomer = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requiDescriInCustomer")
        
        requiEmailIDInCustomer = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requiEmailIDInCustomer")
        
        
        requiVCardInCustomer = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requiVCardInCustomer")
        requiredClassInCustomer = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requiredClassInCustomer")
        
        requiContactInCustomer = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requiContactInCustomer")
        
        requiInteractionTypeInVisitReport = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "RequiInteractionTypeInVisitReport")
        
        requiredBeatPlanDropDownInCustomer = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requiredBeatPlanDropDownInCustomer")
        
        requiEmailOrderToInCustomer = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requiEmailOrderToInCustomer")
        
        
        requiAnniversaryDateInCustomer = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requiAnniversaryDateInCustomer")
        
      
        requiBirthDateInCustomer = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requiBirthDateInCustomer")
        
        requiredSegmentInCustomer = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requiredSegmentInCustomer")
        
        
        requiImagesInCustomer = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requiImagesInCustomer")
        requiLandLineNumInCustomer = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requiLandLineNumInCustomer")
        
        custMobileNoLength = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "custMobileNoLength")
        
        customerMobileValidation = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "CustomerMobileValidation")
        
        requiStoreCheckConditionInVisit = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requiStoreCheckConditionInVisit")
        
        RequiContactPersonInAddVisit = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "RequiContactPersonInAddVisit")
        
        miniNoOfVisitFrValidAtte = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "miniNoOfVisitFrValidAtte")
        
        requiredValidAttendance = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requiredValidAttendance")
        
        contactBecomeCustomerInColdCall = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "contactBecomeCustomerInColdCall")
        
        requireCustomerShopEstKYC = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requireCustomerShopEstKYC")
        autoSharingOrderToRetailer = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "autoSharingOrderToRetailer")
        
        autoSharingOrderToCreator = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "autoSharingOrderToCreator")
        
        askBeforeCloseLeadAfterSalesOrderCreate = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "askBeforeCloseLeadAfterSalesOrderCreate")
        
        autoSharingOrderToDistributor = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "autoSharingOrderToDistributor")
        inventoryForRetailerSTrade = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "InventoryForRetailerSTrade")
        isExecutiveCanDownloadCustReport = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "isExecutiveCanDownloadCustReport")
        requireCustomerPanKYC = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requireCustomerPanKYC")
        customerPotential = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "CustomerPotential")
        maxDiscountManagerApproval = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "MaxDiscountManagerApproval")
       
        
        enableTownVisitTarget = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "enableTownVisitTarget")
        
        inventoryForDistributorSTrade = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "InventoryForDistributorSTrade")
        
        leadStage5 = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "leadStage5")
        
        leadStage6 = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "leadStage6")
        
        requireCustomerOtherKYC = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requireCustomerOtherKYC")
        
        autoSharingOrderToManager = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "autoSharingOrderToManager")
        
        
        requireCustomerGstKYC = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requireCustomerGstKYC")
        gstTaxNumber = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "gstTaxNumber")
        
        allowCreatorToUpdateDespatch = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "allowCreatorToUpdateDespatch")
        
       
        
        requiStoreCheckJustificationInVisitInCompetitor = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "RequiStoreCheckJustificationInVisitInCompetitor")
        
        requireCustomerVoterKYC = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requireCustomerVoterKYC")
        
        
        isDisplayLoadCustomFormDataButton = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "isDisplayLoadCustomFormDataButton")
        
      
        allowEditOrderForPreviousDate = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "allowEditOrderForPreviousDate")
        
        allowNegInventoryRetailerSTrade = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "AllowNegInventoryRetailerSTrade")
        
        
        smsDailyReportToManager = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "smsDailyReportToManager")
        splashScreenUponVisitCheckin = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "splashScreenUponVisitCheckin")
        
        apiForCustomerHistory = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "apiForCustomerHistory")
        
        immediateManagerApproval = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "immediateManagerApproval")
        
        smsDailyReportToManagersManager = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "smsDailyReportToManagersManager")
        
        distributorToStockistMappingInCustomer = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "DistributorToStockistMappingInCustomer")
        
        displayNextMeetingTimeInColdCall = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "displayNextMeetingTimeInColdCall")
        
        warrentyIDFirstTwoDigit = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "warrentyIDFirstTwoDigit")
        
        visitCloseOtpRequireOrNot = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "visitCloseOtpRequireOrNot")
        
        requiProductInAddVisit = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "RequiProductInAddVisit")
        requiInteractionTypeInAddVisit = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "RequiInteractionTypeInAddVisit")
        
        
        requireCustomerDrivingLicenceKYC = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "requireCustomerDrivingLicenceKYC")
        warrantyIDNoOfDigit = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "warrantyIDNoOfDigit")
        exportCustomerEnableDisable = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "exportCustomerEnableDisable")
        requiStoreCheckJustificationInVisit = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "RequiStoreCheckJustificationInVisit")
        
        requiDirectVisitFromLeadInAddVisit = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "RequiDirectVisitFromLeadInAddVisit")
        freezeOpeningStockSTrade = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "freezeOpeningStockSTrade")
        allowNegInventoryDistributorSTrade = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "allowNegInventoryDistributorSTrade")
        miniTimeOfVisitFrValid = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "miniTimeOfVisitFrValid")
        noOfDayForApprOfDeviInVAtte = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "noOfDayForApprOfDeviInVAtte")
        issueManagementEnable = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "IssueManagementEnable")
        sendSMSToCustUponCreationPlannedVisit = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "sendSMSToCustUponCreationPlannedVisit")
        numberOfKYC = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "numberOfKYC")
        closeVisitAtEndOfDay = Common.returndefaultInteger(dic: dictionary, keyvalue: "closeVisitAtEndOfDay")
        closeVisitUpon = Common.returndefaultInteger(dic: dictionary, keyvalue: "closeVisitUpon")
        visitToBeDownloadedUponLogin = Common.returndefaultInteger(dic: dictionary, keyvalue: "visitToBeDownloadedUponLogin")
        allowEditVisitDataForPreviousDate = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "allowEditVisitDataForPreviousDate")
        
        requiInteractionDateTimeInVisitReport = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "RequiInteractionDateTimeInVisitReport")
        
        visitUpdateStockProductPermission = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "VisitUpdateStockProductPermission")
        
        
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    
    // swiftlint:disable cyclomatic_complexity

    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        if mandatoryRemarkInvisitReport != nil{
            dictionary["mandatoryRemarkInvisitReport"] =  mandatoryRemarkInvisitReport
        }
        
        if mandatoryRemarksInLeadStatus != nil{
            dictionary["mandatoryRemarksInLeadStatus"] =  mandatoryRemarksInLeadStatus
        }
        if RequireMedicalInSL != nil{
            dictionary["RequireMedicalInSL"] =  RequireMedicalInSL
        }
        if MinSLReqForMedical != nil{
            dictionary["MinSLReqForMedical"] =  MinSLReqForMedical
        }
        if actionInAutoApprovalSTrade != nil{
            dictionary["ActionInAutoApprovalSTrade"] = actionInAutoApprovalSTrade
        }
        if addParticipantInActivity != nil{
            dictionary["AddParticipantInActivity"] = addParticipantInActivity
        }
        
        if percentageOfSelfAccomodation != nil{
            dictionary["percentageOfSelfAccomodation"] =  percentageOfSelfAccomodation
        }
        
        if mandatoryDistributorToStockiestMapping != nil{
            dictionary["mandatoryDistributorToStockiestMapping"] = mandatoryDistributorToStockiestMapping
        }
        
        if customerRequiredInActivity != nil{
            dictionary["customerRequiredInActivity"] = customerRequiredInActivity
        }
        
        if percentageOfSharedRoom != nil{
            dictionary["percentageOfSharedRoom"] = percentageOfSharedRoom
        }
        if allowDistributorInCustType !=  nil{
            dictionary["allowDistributorInCustType"] = allowDistributorInCustType
        }
        
        if allowInfluencerInCustType !=  nil{
            dictionary["allowInfluencerInCustType"] = allowInfluencerInCustType
        }
        
        if allowCorporateInCustType !=  nil{
            dictionary["allowCorporateInCustType"] = allowCorporateInCustType
        }
        
        if allowRetailerInCustType !=  nil{
            dictionary["allowRetailerInCustType"] = allowRetailerInCustType
        }
        
        if allowEndUserInCustType !=  nil{
            dictionary["allowEndUserInCustType"] = allowEndUserInCustType
        }
        
        if allowStockistInCustType !=  nil{
            dictionary["allowStockistInCustType"] = allowStockistInCustType
        }
        
        
        if updatedByDistributorInCustType !=  nil{
            dictionary["updatedByDistributorInCustType"] = updatedByDistributorInCustType
        }
        
        if updatedByInfluencerInCustType !=  nil{
            dictionary["updatedByInfluencerInCustType"] = updatedByInfluencerInCustType
        }
        
        if updatedByCorporateInCustType !=  nil{
            dictionary["updatedByCorporateInCustType"] = updatedByCorporateInCustType
        }
        
        if updatedByRetailerInCustType !=  nil{
            dictionary["updatedByRetailerInCustType"] = updatedByRetailerInCustType
        }
        
        if updatedByEndUserInCustType !=  nil{
            dictionary["updatedByEndUserInCustType"] = updatedByEndUserInCustType
        }
        
        if updatedByStockistInCustType !=  nil{
            dictionary["updatedByStockistInCustType"] = updatedByStockistInCustType
        }
        
        /*  var displayDistributorInCustType:String?
         var displayEndUserInCustType:String?
         var displayInfluencerInCustType:String?
         var displayStockistInCustType:String?
         var displayRetailerInCustType:String?
         var displayCorporateInCustType:String?**/
        
        if displayDistributorInCustType !=  nil{
            dictionary["displayDistributorInCustType"] = displayDistributorInCustType
        }
        
        if displayEndUserInCustType !=  nil{
            dictionary["displayEndUserInCustType"] = displayEndUserInCustType
        }
        
        if displayInfluencerInCustType !=  nil{
            dictionary["displayInfluencerInCustType"] = displayInfluencerInCustType
        }
        
        if displayStockistInCustType !=  nil{
            dictionary["displayStockistInCustType"] = displayStockistInCustType
        }
        
        if displayRetailerInCustType !=  nil{
            dictionary["displayRetailerInCustType"] = displayRetailerInCustType
        }
        
        if displayCorporateInCustType !=  nil{
            dictionary["displayCorporateInCustType"] = displayCorporateInCustType
        }
        
        if additionalReminderTextInLead != nil{
            dictionary["AdditionalReminderTextInLead"] = additionalReminderTextInLead
        }
        if addressSettingsForAttendance != nil{
            dictionary["AddressSettingsForAttendance"] = addressSettingsForAttendance
        }
        if adminInvoiceApproval != nil{
            dictionary["AdminInvoiceApproval"] = adminInvoiceApproval
        }
        if adminProposalApproval != nil{
            dictionary["AdminProposalApproval"] = adminProposalApproval
        }
        if adminSalesOrderApproval != nil{
            dictionary["AdminSalesOrderApproval"] = adminSalesOrderApproval
        }
        if alarmReminder != nil{
            dictionary["AlarmReminder"] = alarmReminder
        }
        if allowMultipleDistributorInPurchaseSTrade != nil{
            dictionary["AllowMultipleDistributorInPurchaseSTrade"] = allowMultipleDistributorInPurchaseSTrade
        }
        if allowSalesOnlyIfPurchaseSTrade != nil{
            dictionary["AllowSalesOnlyIfPurchaseSTrade"] = allowSalesOnlyIfPurchaseSTrade
        }
        if allowSelfieInAttendance != nil{
            dictionary["AllowSelfieInAttendance"] = allowSelfieInAttendance
        }
        if allowSrNoInDistributorSTrade != nil{
            dictionary["AllowSrNoInDistributorSTrade"] = allowSrNoInDistributorSTrade
        }
        if allowZeroPriceInSO != nil{
            dictionary["AllowZeroPriceInSO"] = allowZeroPriceInSO
        }
        if areaSetupType != nil{
            dictionary["AreaSetupType"] = areaSetupType
        }
        if areaTypeID != nil{
            dictionary["AreaTypeID"] = areaTypeID
        }
        if assignBeatPlanApproval != nil{
            dictionary["AssignBeatPlanApproval"] = assignBeatPlanApproval
        }
        if autoCheckOutAttendance != nil{
            dictionary["AutoCheckOutAttendance"] = autoCheckOutAttendance
        }
        if barCodeInProduct != nil{
            dictionary["BarCodeInProduct"] = barCodeInProduct
        }
        if cGSTSurcharges != nil{
            dictionary["CGSTSurcharges"] = cGSTSurcharges
        }
        if cGSTTax != nil{
            dictionary["CGSTTax"] = cGSTTax
        }
        if cSTSurcharges != nil{
            dictionary["CSTSurcharges"] = cSTSurcharges
        }
        if cSTTax != nil{
            dictionary["CSTTax"] = cSTTax
        }
        if cSTTaxNumber != nil{
            dictionary["CSTTaxNumber"] = cSTTaxNumber
        }
        if coldCallReminder != nil{
            dictionary["ColdCallReminder"] = coldCallReminder
        }
        if coldCallReminderFirst != nil{
            dictionary["ColdCallReminderFirst"] = coldCallReminderFirst
        }
        if coldCallReminderMissed != nil{
            dictionary["ColdCallReminderMissed"] = coldCallReminderMissed
        }
        if coldCallReminderSecond != nil{
            dictionary["ColdCallReminderSecond"] = coldCallReminderSecond
        }
        if companyID != nil{
            dictionary["CompanyID"] = companyID
        }
        if createBeatPlanApproval != nil{
            dictionary["CreateBeatPlanApproval"] = createBeatPlanApproval
        }
        if createdBy != nil{
            dictionary["CreatedBy"] = createdBy
        }
        if createdTime != nil{
            dictionary["CreatedTime"] = createdTime
        }
        if customTagging != nil{
            dictionary["CustomTagging"] = customTagging
        }
        if customerAVisits != nil{
            dictionary["CustomerAVisits"] = customerAVisits
        }
        if customerBVisits != nil{
            dictionary["CustomerBVisits"] = customerBVisits
        }
        if customerApproval != nil{
            dictionary["CustomerApproval"] = customerApproval
        }
        
        if customerCVisits != nil{
            dictionary["CustomerCVisits"] = customerCVisits
        }
        if customerDVisits != nil{
            dictionary["CustomerDVisits"] = customerDVisits
        }
        if customerInExpense != nil{
            dictionary["CustomerInExpense"] = customerInExpense
        }
        if customerOTPVerification != nil{
            dictionary["CustomerOTPVerification"] = customerOTPVerification
        }
        if customerProfileInUnplannedVisit != nil{
            dictionary["CustomerProfileInUnplannedVisit"] = customerProfileInUnplannedVisit
        }
        if customerVisitReminder != nil{
            dictionary["CustomerVisitReminder"] = customerVisitReminder
        }
        if customerVisitsDuration != nil{
            dictionary["CustomerVisitsDuration"] = customerVisitsDuration
        }
        if dailyVistiApplication != nil{
            dictionary["DailyVistiApplication"] = dailyVistiApplication
        }
        if daysToWaitInAutoApprovalSTrade != nil{
            dictionary["DaysToWaitInAutoApprovalSTrade"] = daysToWaitInAutoApprovalSTrade
        }
        if directSalesOrder != nil{
            dictionary["DirectSalesOrder"] = directSalesOrder
        }
        if disableCheckoutInVisit != nil{
            dictionary["DisableCheckoutInVisit"] = disableCheckoutInVisit
        }
        if disableOrderFromPlusMenu != nil{
            dictionary["DisableOrderFromPlusMenu"] = disableOrderFromPlusMenu
        }
        if disableVisitFromPlusMenu != nil{
            dictionary["DisableVisitFromPlusMenu"] = disableVisitFromPlusMenu
        }
        if discountType != nil{
            dictionary["DiscountType"] = discountType
        }
        if discountValue != nil{
            dictionary["DiscountValue"] = discountValue
        }
        if enableWarrantyIDValidation != nil{
            dictionary["EnableWarrantyIDValidation"] = enableWarrantyIDValidation
        }
        if endTime != nil{
            dictionary["EndTime"] = endTime
        }
        if exciseDuty != nil{
            dictionary["ExciseDuty"] = exciseDuty
        }
        if exciseSurcharges != nil{
            dictionary["ExciseSurcharges"] = exciseSurcharges
        }
        if expenseApproval != nil{
            dictionary["ExpenseApproval"] = expenseApproval
        }
        if fOCToggleInSO != nil{
            dictionary["FOCToggleInSO"] = fOCToggleInSO
        }
        if firstCheckInAttendance != nil{
            dictionary["FirstCheckInAttendance"] = firstCheckInAttendance
        }
        if iD != nil{
            dictionary["ID"] = iD
        }
        if iGSTSurcharges != nil{
            dictionary["IGSTSurcharges"] = iGSTSurcharges
        }
        if iGSTTax != nil{
            dictionary["IGSTTax"] = iGSTTax
        }
        if influencerInLead != nil{
            dictionary["InfluencerInLead"] = influencerInLead
        }
        if addSecondInfluencerInLead != nil{
            dictionary["AddSecondInfluencerInLead"] = addSecondInfluencerInLead
        }
        if invoiceConditions != nil{
            dictionary["InvoiceConditions"] = invoiceConditions
        }
        if invoiceDueDays != nil{
            dictionary["InvoiceDueDays"] = invoiceDueDays
        }
        if invoiceFormat != nil{
            dictionary["InvoiceFormat"] = invoiceFormat
        }
        if invoiceProductPermission != nil{
            dictionary["InvoiceProductPermission"] = invoiceProductPermission
        }
        if invoiceReminder != nil{
            dictionary["InvoiceReminder"] = invoiceReminder
        }
        if invoiceReminderFirst != nil{
            dictionary["InvoiceReminderFirst"] = invoiceReminderFirst
        }
        if invoiceReminderMissed != nil{
            dictionary["InvoiceReminderMissed"] = invoiceReminderMissed
        }
        if invoiceReminderSecond != nil{
            dictionary["InvoiceReminderSecond"] = invoiceReminderSecond
        }
        if invoiceTemplateID != nil{
            dictionary["InvoiceTemplateID"] = invoiceTemplateID
        }
        if invoiceTerms != nil{
            dictionary["InvoiceTerms"] = invoiceTerms
        }
        if isActive != nil{
            dictionary["IsActive"] = isActive
        }
        if isCustomerClassEditable != nil{
            dictionary["IsCustomerClassEditable"] = isCustomerClassEditable
        }
        if isFirstSrNoOrProductCodeInSrNo != nil{
            dictionary["IsFirstSrNoOrProductCodeInSrNo"] = isFirstSrNoOrProductCodeInSrNo
        }
        if isLoyaltyEnabled != nil{
            dictionary["IsLoyaltyEnabled"] = isLoyaltyEnabled
        }
        if joinPromotionInCustomerMandatory != nil{
            dictionary["JoinPromotionInCustomerMandatory"] = joinPromotionInCustomerMandatory
        }
        if lastModifiedBy != nil{
            dictionary["LastModifiedBy"] = lastModifiedBy
        }
        if lastModifiedTime != nil{
            dictionary["LastModifiedTime"] = lastModifiedTime
        }
        if leadCustomerProfile != nil{
            dictionary["LeadCustomerProfile"] = leadCustomerProfile
        }
        if leadCustomerProfileURL != nil{
            dictionary["LeadCustomerProfileURL"] = leadCustomerProfileURL
        }
        if leadManualCheckInApproval != nil{
            dictionary["LeadManualCheckInApproval"] = leadManualCheckInApproval
        }
        if leadProductPermission != nil{
            dictionary["LeadProductPermission"] = leadProductPermission
        }
        if leadQualifiedTextInLead != nil{
            dictionary["LeadQualifiedTextInLead"] = leadQualifiedTextInLead
        }
        if leadReminder != nil{
            dictionary["LeadReminder"] = leadReminder
        }
        if leadReminderFirst != nil{
            dictionary["LeadReminderFirst"] = leadReminderFirst
        }
        if leadReminderMissed != nil{
            dictionary["LeadReminderMissed"] = leadReminderMissed
        }
        if leadReminderSecond != nil{
            dictionary["LeadReminderSecond"] = leadReminderSecond
        }
        if leadsAutoAssign != nil{
            dictionary["LeadsAutoAssign"] = leadsAutoAssign
        }
        if localTax != nil{
            dictionary["LocalTax"] = localTax
        }
        if localTaxID != nil{
            dictionary["LocalTaxID"] = localTaxID
        }
        if locationTrackCustomer != nil{
            dictionary["LocationTrackCustomer"] = locationTrackCustomer
        }
        if locationTrackSalesForce != nil{
            dictionary["LocationTrackSalesForce"] = locationTrackSalesForce
        }
        if manageBom != nil{
            dictionary["ManageBom"] = manageBom
        }
        if manageBomDiscount != nil{
            dictionary["ManageBomDiscount"] = manageBomDiscount
        }
        if manageCGST != nil{
            dictionary["ManageCGST"] = manageCGST
        }
        if manageCST != nil{
            dictionary["ManageCST"] = manageCST
        }
        if manageExciseDuty != nil{
            dictionary["ManageExciseDuty"] = manageExciseDuty
        }
        if manageIGST != nil{
            dictionary["ManageIGST"] = manageIGST
        }
        if manageLocalTax != nil{
            dictionary["ManageLocalTax"] = manageLocalTax
        }
        if managePayment != nil{
            dictionary["ManagePayment"] = managePayment
        }
        if manageProductPromotionJoin != nil{
            dictionary["ManageProductPromotionJoin"] = manageProductPromotionJoin
        }
        if managePromotionBudget != nil{
            dictionary["ManagePromotionBudget"] = managePromotionBudget
        }
        if managePurchaseOrder != nil{
            dictionary["ManagePurchaseOrder"] = managePurchaseOrder
        }
        if manageSGST != nil{
            dictionary["ManageSGST"] = manageSGST
        }
        if manageServiceTax != nil{
            dictionary["ManageServiceTax"] = manageServiceTax
        }
        if manageVat != nil{
            dictionary["ManageVat"] = manageVat
        }
        if managerApplyManualAttendance != nil{
            dictionary["ManagerApplyManualAttendance"] = managerApplyManualAttendance
        }
        if managerApproveCheckInCheckOutUpdate != nil{
            dictionary["ManagerApproveCheckInCheckOutUpdate"] = managerApproveCheckInCheckOutUpdate
        }
        if managerApproveCustomerVendorTravelCheckInCheckOut != nil{
            dictionary["ManagerApproveCustomerVendorTravelCheckInCheckOut"] = managerApproveCustomerVendorTravelCheckInCheckOut
        }
        if managerApproveLeave != nil{
            dictionary["ManagerApproveLeave"] = managerApproveLeave
        }
        if managerApproveManualAttendance != nil{
            dictionary["ManagerApproveManualAttendance"] = managerApproveManualAttendance
        }
        if managerInvoiceApproval != nil{
            dictionary["ManagerInvoiceApproval"] = managerInvoiceApproval
        }
        if managerLeadsAssign != nil{
            dictionary["ManagerLeadsAssign"] = managerLeadsAssign
        }
        if managerLeadsReassign != nil{
            dictionary["ManagerLeadsReassign"] = managerLeadsReassign
        }
        if managerPaymentReceivedApproval != nil{
            dictionary["ManagerPaymentReceivedApproval"] = managerPaymentReceivedApproval
        }
        if managerProposalApproval != nil{
            dictionary["ManagerProposalApproval"] = managerProposalApproval
        }
        if managerPurchaseOrderApproval != nil{
            dictionary["ManagerPurchaseOrderApproval"] = managerPurchaseOrderApproval
        }
        if managerPurchaseOrderCancellation != nil{
            dictionary["ManagerPurchaseOrderCancellation"] = managerPurchaseOrderCancellation
        }
        if managerSalesOrderApproval != nil{
            dictionary["ManagerSalesOrderApproval"] = managerSalesOrderApproval
        }
        if managerSalesOrderCancellation != nil{
            dictionary["ManagerSalesOrderCancellation"] = managerSalesOrderCancellation
        }
        if managerSalesTargetApproval != nil{
            dictionary["ManagerSalesTargetApproval"] = managerSalesTargetApproval
        }
        if managerSelfAssignLead != nil{
            dictionary["ManagerSelfAssignLead"] = managerSelfAssignLead
        }
        if managerShowTracking != nil{
            dictionary["ManagerShowTracking"] = managerShowTracking
        }
        if managerTrackSalesExecutive != nil{
            dictionary["ManagerTrackSalesExecutive"] = managerTrackSalesExecutive
        }
        if managerTrackSalesRepresentative != nil{
            dictionary["ManagerTrackSalesRepresentative"] = managerTrackSalesRepresentative
        }
        if managerWorkingHoursTracking != nil{
            dictionary["ManagerWorkingHoursTracking"] = managerWorkingHoursTracking
        }
        if mandatoryCustomerSegment != nil{
            dictionary["MandatoryCustomerSegment"] = mandatoryCustomerSegment
        }
        if mandatoryLeadUpdateStatus != nil{
            dictionary["MandatoryLeadUpdateStatus"] = mandatoryLeadUpdateStatus
        }
        if mandatoryPictureInCreateCustomer != nil{
            dictionary["MandatoryPictureInCreateCustomer"] = mandatoryPictureInCreateCustomer
        }
        if mandatoryPictureInVisit != nil{
            dictionary["MandatoryPictureInVisit"] = mandatoryPictureInVisit
        }
        if mandatoryTrialSuccessfulStatusForOrderInLead != nil{
            dictionary["MandatoryTrialSuccessfulStatusForOrderInLead"] = mandatoryTrialSuccessfulStatusForOrderInLead
        }
        if mandatoryVisitReport != nil{
            dictionary["MandatoryVisitReport"] = mandatoryVisitReport
        }
        if maxOrderQty != nil{
            dictionary["MaxOrderQty"] = maxOrderQty
        }
        if maximumVisitConfiguration != nil{
            dictionary["MaximumVisitConfiguration"] = maximumVisitConfiguration
        }
        if mandatoryDistributorRetailerMapping != nil{
            dictionary["mandatoryDistributorRetailerMapping"] = mandatoryDistributorRetailerMapping
        }
        if modeOfPayReferenceRequiredInCollection != nil{
            dictionary["ModeOfPayReferenceRequiredInCollection"] = modeOfPayReferenceRequiredInCollection
        }
        if monthInInvoiceOrderSuggestQty != nil{
            dictionary["MonthInInvoiceOrderSuggestQty"] = monthInInvoiceOrderSuggestQty
        }
        if negotiationTextInLead != nil{
            dictionary["NegotiationTextInLead"] = negotiationTextInLead
        }
        if oTPConfirmationAtPromotion != nil{
            dictionary["OTPConfirmationAtPromotion"] = oTPConfirmationAtPromotion
        }
        if pANNumber != nil{
            dictionary["PANNumber"] = pANNumber
        }
        if perHourTravelInKM != nil{
            dictionary["PerHourTravelInKM"] = perHourTravelInKM
        }
        if plusMenuInVisitDetail != nil{
            dictionary["PlusMenuInVisitDetail"] = plusMenuInVisitDetail
        }
        if priceEditable != nil{
            dictionary["PriceEditable"] = priceEditable
        }
        if priceEditableDistributorPOSTrade != nil{
            dictionary["PriceEditableDistributorPOSTrade"] = priceEditableDistributorPOSTrade
        }
        if priceEditableRetailerPOSTrade != nil{
            dictionary["PriceEditableRetailerPOSTrade"] = priceEditableRetailerPOSTrade
        }
        if productInterestedInUnplannedVisit != nil{
            dictionary["ProductInterestedInUnplannedVisit"] = productInterestedInUnplannedVisit
        }
        if productMandatoryInLead != nil{
            dictionary["ProductMandatoryInLead"] = productMandatoryInLead
        }
        if productSelectionTypeInSTrade != nil{
            dictionary["ProductSelectionTypeInSTrade"] = productSelectionTypeInSTrade
        }
        if proposalConditions != nil{
            dictionary["ProposalConditions"] = proposalConditions
        }
        if proposalFormat != nil{
            dictionary["ProposalFormat"] = proposalFormat
        }
        if proposalProductPermission != nil{
            dictionary["ProposalProductPermission"] = proposalProductPermission
        }
        if proposalSubTextInLead != nil{
            dictionary["ProposalSubTextInLead"] = proposalSubTextInLead
        }
        if proposalTemplateID != nil{
            dictionary["ProposalTemplateID"] = proposalTemplateID
        }
        if proposalTerms != nil{
            dictionary["ProposalTerms"] = proposalTerms
        }
        if purchaseOrderConditions != nil{
            dictionary["PurchaseOrderConditions"] = purchaseOrderConditions
        }
        if purchaseOrderFormat != nil{
            dictionary["PurchaseOrderFormat"] = purchaseOrderFormat
        }
        if purchaseOrderTemplateID != nil{
            dictionary["PurchaseOrderTemplateID"] = purchaseOrderTemplateID
        }
        if purchaseOrderTerms != nil{
            dictionary["PurchaseOrderTerms"] = purchaseOrderTerms
        }
        if requireAddNewCustomerInVisitLeadOrder != nil{
            dictionary["RequireAddNewCustomerInVisitLeadOrder"] = requireAddNewCustomerInVisitLeadOrder
        }
        if requireCustCodeInCustomer != nil{
            dictionary["RequireCustCodeInCustomer"] = requireCustCodeInCustomer
        }
        if requireCustomerTypeInUnplannedVisit != nil{
            dictionary["RequireCustomerTypeInUnplannedVisit"] = requireCustomerTypeInUnplannedVisit
        }
        if requireDeliveryDaysAndTnCInSO != nil{
            dictionary["RequireDeliveryDaysAndTnCInSO"] = requireDeliveryDaysAndTnCInSO
        }
        if requireDiscountAndTaxAmountInSO != nil{
            dictionary["RequireDiscountAndTaxAmountInSO"] = requireDiscountAndTaxAmountInSO
        }
        if requireKeyCustInCustomer != nil{
            dictionary["RequireKeyCustInCustomer"] = requireKeyCustInCustomer
        }
        if requirePromotionInSO != nil{
            dictionary["RequirePromotionInSO"] = requirePromotionInSO
        }
        if requireSOFromVisitBeforeCheckOut != nil{
            dictionary["RequireSOFromVisitBeforeCheckOut"] = requireSOFromVisitBeforeCheckOut
        }
        if requireTaxInCustomer != nil{
            dictionary["RequireTaxInCustomer"] = requireTaxInCustomer
        }
        if requireTempCustomerProfile != nil{
            dictionary["RequireTempCustomerProfile"] = requireTempCustomerProfile
        }
        if requireTownInCustomer != nil{
            dictionary["RequireTownInCustomer"] = requireTownInCustomer
        }
        if requireVisitCollection != nil{
            dictionary["RequireVisitCollection"] = requireVisitCollection
        }
        if requireVisitCounterShare != nil{
            dictionary["RequireVisitCounterShare"] = requireVisitCounterShare
        }
        if sGSTSurcharges != nil{
            dictionary["SGSTSurcharges"] = sGSTSurcharges
        }
        if sGSTTax != nil{
            dictionary["SGSTTax"] = sGSTTax
        }
        if sMSInVisitCheckIn != nil{
            dictionary["SMSInVisitCheckIn"] = sMSInVisitCheckIn
        }
        if sORequireWarrantyAndDealerCode != nil{
            dictionary["SORequireWarrantyAndDealerCode"] = sORequireWarrantyAndDealerCode
        }
        if salesExecutiveApplyManualAttendance != nil{
            dictionary["SalesExecutiveApplyManualAttendance"] = salesExecutiveApplyManualAttendance
        }
        if salesExecutiveApproveCheckInCheckOutUpdate != nil{
            dictionary["SalesExecutiveApproveCheckInCheckOutUpdate"] = salesExecutiveApproveCheckInCheckOutUpdate
        }
        if salesExecutiveApproveCustomerVendorTravelCheckInCheckOut != nil{
            dictionary["SalesExecutiveApproveCustomerVendorTravelCheckInCheckOut"] = salesExecutiveApproveCustomerVendorTravelCheckInCheckOut
        }
        if salesExecutiveApproveLeave != nil{
            dictionary["SalesExecutiveApproveLeave"] = salesExecutiveApproveLeave
        }
        if salesExecutiveApproveManualAttendance != nil{
            dictionary["SalesExecutiveApproveManualAttendance"] = salesExecutiveApproveManualAttendance
        }
        if salesExecutiveCreateInvoice != nil{
            dictionary["SalesExecutiveCreateInvoice"] = salesExecutiveCreateInvoice
        }
        if salesExecutivePaymentReceivedApproval != nil{
            dictionary["SalesExecutivePaymentReceivedApproval"] = salesExecutivePaymentReceivedApproval
        }
        if salesExecutiveSelfAssignLead != nil{
            dictionary["SalesExecutiveSelfAssignLead"] = salesExecutiveSelfAssignLead
        }
        if salesExecutiveShowTracking != nil{
            dictionary["SalesExecutiveShowTracking"] = salesExecutiveShowTracking
        }
        if salesExecutiveTrackSalesRepresentative != nil{
            dictionary["SalesExecutiveTrackSalesRepresentative"] = salesExecutiveTrackSalesRepresentative
        }
        if salesExecutiveWorkingHoursTracking != nil{
            dictionary["SalesExecutiveWorkingHoursTracking"] = salesExecutiveWorkingHoursTracking
        }
        if salesOrderConditions != nil{
            dictionary["SalesOrderConditions"] = salesOrderConditions
        }
        if salesOrderFormat != nil{
            dictionary["SalesOrderFormat"] = salesOrderFormat
        }
        if salesOrderFulfillmentFrom != nil{
            dictionary["SalesOrderFulfillmentFrom"] = salesOrderFulfillmentFrom
        }
        if salesOrderProductPermission != nil{
            dictionary["SalesOrderProductPermission"] = salesOrderProductPermission
        }
        if salesOrderReportPermission != nil{
            dictionary["SalesOrderReportPermission"] = salesOrderReportPermission
        }
        if salesOrderTemplateID != nil{
            dictionary["SalesOrderTemplateID"] = salesOrderTemplateID
        }
        if salesOrderTerms != nil{
            dictionary["SalesOrderTerms"] = salesOrderTerms
        }
        if salesRepresantativeApplyManualAttendance != nil{
            dictionary["SalesRepresantativeApplyManualAttendance"] = salesRepresantativeApplyManualAttendance
        }
        if salesRepresentativeShowTracking != nil{
            dictionary["SalesRepresentativeShowTracking"] = salesRepresentativeShowTracking
        }
        if salesRepresentativeWorkingHoursTracking != nil{
            dictionary["SalesRepresentativeWorkingHoursTracking"] = salesRepresentativeWorkingHoursTracking
        }
        if sendNotnInSOMaxDiscount != nil{
            dictionary["SendNotnInSOMaxDiscount"] = sendNotnInSOMaxDiscount
        }
        if serviceSurcharges != nil{
            dictionary["ServiceSurcharges"] = serviceSurcharges
        }
        if serviceTax != nil{
            dictionary["ServiceTax"] = serviceTax
        }
        if serviceTaxNumber != nil{
            dictionary["ServiceTaxNumber"] = serviceTaxNumber
        }
        if shelfSpaceUnit != nil{
            dictionary["ShelfSpaceUnit"] = shelfSpaceUnit
        }
        if showActionCloseOrderInLead != nil{
            dictionary["ShowActionCloseOrderInLead"] = showActionCloseOrderInLead
        }
        if showAdditionalReminderInLead != nil{
            dictionary["ShowAdditionalReminderInLead"] = showAdditionalReminderInLead
        }
        if showKPIOnSplashScreen != nil{
            dictionary["ShowKPIOnSplashScreen"] = showKPIOnSplashScreen
        }
        if showLeadQualifiedInLead != nil{
            dictionary["ShowLeadQualifiedInLead"] = showLeadQualifiedInLead
        }
        if showNegotiationInLead != nil{
            dictionary["ShowNegotiationInLead"] = showNegotiationInLead
        }
        if showOurChancesInLead != nil{
            dictionary["ShowOurChancesInLead"] = showOurChancesInLead
        }
        if showProductDrive != nil{
            dictionary["ShowProductDrive"] = showProductDrive
        }
        if showProposalSubInLead != nil{
            dictionary["ShowProposalSubInLead"] = showProposalSubInLead
        }
        if showShelfSpace != nil{
            dictionary["ShowShelfSpace"] = showShelfSpace
        }
        if showSuggestOrderQty != nil{
            dictionary["ShowSuggestOrderQty"] = showSuggestOrderQty
        }
        if showTrialDoneInLead != nil{
            dictionary["ShowTrialDoneInLead"] = showTrialDoneInLead
        }
        if startTime != nil{
            dictionary["StartTime"] = startTime
        }
        if stockUpdateInOrder != nil{
            dictionary["StockUpdateInOrder"] = stockUpdateInOrder
        }
        if storeCheckCompetition != nil{
            dictionary["StoreCheckCompetition"] = storeCheckCompetition
        }
        if storeCheckOwnBrand != nil{
            dictionary["StoreCheckOwnBrand"] = storeCheckOwnBrand
        }
        if suggestOrderQtyCalculation != nil{
            dictionary["SuggestOrderQtyCalculation"] = suggestOrderQtyCalculation
        }
        if territoryInCustomer != nil{
            dictionary["TerritoryInCustomer"] = territoryInCustomer
        }
        if territoryMandatoryInBeatPlan != nil{
            dictionary["TerritoryMandatoryInBeatPlan"] = territoryMandatoryInBeatPlan
        }
        if totalCharsInFirstSlab != nil{
            dictionary["TotalCharsInFirstSlab"] = totalCharsInFirstSlab
        }
        if totalCharsInSrNo != nil{
            dictionary["TotalCharsInSrNo"] = totalCharsInSrNo
        }
        if travelCheckInExecutiveApproval != nil{
            dictionary["TravelCheckInExecutiveApproval"] = travelCheckInExecutiveApproval
        }
        if travelCheckInManagerApproval != nil{
            dictionary["TravelCheckInManagerApproval"] = travelCheckInManagerApproval
        }
        if trialDoneTextInLead != nil{
            dictionary["TrialDoneTextInLead"] = trialDoneTextInLead
        }
        if vATAdditionalTax != nil{
            dictionary["VATAdditionalTax"] = vATAdditionalTax
        }
        if vATSurcharges != nil{
            dictionary["VATSurcharges"] = vATSurcharges
        }
        if vATTax != nil{
            dictionary["VATTax"] = vATTax
        }
        if vATTaxNumber != nil{
            dictionary["VATTaxNumber"] = vATTaxNumber
        }
        if vatCodeFrom != nil{
            dictionary["VatCodeFrom"] = vatCodeFrom
        }
        if vatGst != nil{
            dictionary["VatGst"] = vatGst
        }
        if viewCompanyStock != nil{
            dictionary["ViewCompanyStock"] = viewCompanyStock
        }
        if visitCheckInApproval != nil{
            dictionary["VisitCheckInApproval"] = visitCheckInApproval
        }
        if visitCheckInCheckoutDiff != nil{
            dictionary["VisitCheckInCheckoutDiff"] = visitCheckInCheckoutDiff
        }
        if visitManualCheckInApproval != nil{
            dictionary["VisitManualCheckInApproval"] = visitManualCheckInApproval
        }
        if visitMenuOnHomeScreen != nil{
            dictionary["VisitMenuOnHomeScreen"] = visitMenuOnHomeScreen
        }
        if visitModule != nil{
            dictionary["VisitModule"] = visitModule
        }
        if visitProductPermission != nil{
            dictionary["VisitProductPermission"] = visitProductPermission
        }
        if visitReminder != nil{
            dictionary["VisitReminder"] = visitReminder
        }
        if visitReminderFirst != nil{
            dictionary["VisitReminderFirst"] = visitReminderFirst
        }
        if visitReminderMissed != nil{
            dictionary["VisitReminderMissed"] = visitReminderMissed
        }
        if visitReminderSecond != nil{
            dictionary["VisitReminderSecond"] = visitReminderSecond
        }
        if visitStepsRequired != nil{
            dictionary["VisitStepsRequired"] = visitStepsRequired
        }
        if salesOrderLoadPage != nil{
            dictionary["SalesOrderLoadPage"] = salesOrderLoadPage
        }
        
        
        if requiContactPersonInVisitReport != nil{
            dictionary["RequiContactPersonInVisitReport"] = requiContactPersonInVisitReport
        }
        
        if requiInteractionDateTimeInVisitReport != nil{
            dictionary["RequiInteractionDateTimeInVisitReport"] = requiInteractionDateTimeInVisitReport
        }
        
        
        if allowEditVisitDataForPreviousDate != nil{
            dictionary["allowEditVisitDataForPreviousDate"] = allowEditVisitDataForPreviousDate
        }
        
        if requiStoreCheckConditionInVisit != nil{
            dictionary["requiStoreCheckConditionInVisit"] = requiStoreCheckConditionInVisit
        }
        
        
        if RequiContactPersonInAddVisit != nil{
            dictionary["RequiContactPersonInAddVisit"] = RequiContactPersonInAddVisit
        }
        
        if miniNoOfVisitFrValidAtte != nil{
            dictionary["miniNoOfVisitFrValidAtte"] = miniNoOfVisitFrValidAtte
        }
        
        if requiredValidAttendance != nil{
            dictionary["requiredValidAttendance"] = requiredValidAttendance
        }
        
        
        if contactBecomeCustomerInColdCall != nil{
            dictionary["contactBecomeCustomerInColdCall"] = contactBecomeCustomerInColdCall
        }
        
        if requireCustomerShopEstKYC != nil{
            dictionary["requireCustomerShopEstKYC"] = requireCustomerShopEstKYC
        }
        
        
        
        if visitUpdateStockProductPermission != nil{
            dictionary["VisitUpdateStockProductPermission"] = visitUpdateStockProductPermission
        }
        
        if autoSharingOrderToRetailer != nil{
            dictionary["autoSharingOrderToRetailer"] = autoSharingOrderToRetailer
        }
        
        if askBeforeCloseLeadAfterSalesOrderCreate != nil{
            dictionary["askBeforeCloseLeadAfterSalesOrderCreate"] = askBeforeCloseLeadAfterSalesOrderCreate
        }
        
        
        if autoSharingOrderToDistributor != nil{
            dictionary["autoSharingOrderToDistributor"] = autoSharingOrderToDistributor
        }
        
        if inventoryForRetailerSTrade != nil{
            dictionary["InventoryForRetailerSTrade"] = inventoryForRetailerSTrade
        }
        
        
        if isExecutiveCanDownloadCustReport != nil{
            dictionary["isExecutiveCanDownloadCustReport"] = isExecutiveCanDownloadCustReport
        }
        
        
        
        if requireCustomerPanKYC != nil{
            dictionary["requireCustomerPanKYC"] = requireCustomerPanKYC
        }
        
        if customerPotential != nil{
            dictionary["CustomerPotential"] = customerPotential
        }
        
        if maxDiscountManagerApproval != nil{
            dictionary["MaxDiscountManagerApproval"] = maxDiscountManagerApproval
        }
        
        
        if enableTownVisitTarget != nil{
            dictionary["enableTownVisitTarget"] = enableTownVisitTarget
        }
        
        if inventoryForDistributorSTrade != nil{
            dictionary["InventoryForDistributorSTrade"] = inventoryForDistributorSTrade
        }
        
        
        
        
        
        
        if leadStage5 != nil{
            dictionary["leadStage5"] = leadStage5
        }
        
        if leadStage6 != nil{
            dictionary["leadStage6"] = leadStage6
        }
        
        
        if requireCustomerOtherKYC != nil{
            dictionary["requireCustomerOtherKYC"] = requireCustomerOtherKYC
        }
        
        if autoSharingOrderToManager != nil{
            dictionary["autoSharingOrderToManager"] = autoSharingOrderToManager
        }
        
        
        if requireCustomerGstKYC != nil{
            dictionary["requireCustomerGstKYC"] = requireCustomerGstKYC
        }
        
        if gstTaxNumber != nil{
            dictionary["gstTaxNumber"] = gstTaxNumber
        }
               
               
        
        
        
        
        
        
        if classA.count > 0{
            dictionary["classA"] = classA
        }
        if classB.count > 0{
            dictionary["classB"] = classB
        }
        if classC.count > 0{
            dictionary["classC"] = classC
        }
        if classD.count > 0{
            dictionary["classD"] = classD
        }
        if exportCustomerURL.count > 0{
            dictionary["exportCustomerURL"] = exportCustomerURL
        }
        if leadStage5Text?.count ?? 0 > 0{
            dictionary["leadStage5Text"] = leadStage5Text
        }
        if leadStage6Text?.count ?? 0 > 0{
            dictionary["leadStage6Text"] = leadStage6Text
        }
                
        if requireCustomerAadharKYC != nil{
            dictionary["requireCustomerAadharKYC"] = requireCustomerAadharKYC
        }
        if mandatoryCustomerContact != nil{
            dictionary["MandatoryCustomerContact"] = mandatoryCustomerContact
        }
        
     
        if requiVCardInCustomer != nil{
            dictionary["requiVCardInCustomer"] = requiVCardInCustomer
        }
        if requiEmailIDInCustomer != nil{
            dictionary["requiEmailIDInCustomer"] = requiEmailIDInCustomer
        }
        if requiDescriInCustomer != nil{
            dictionary["requiDescriInCustomer"] = requiDescriInCustomer
        }
        if requireCustomerKYC != nil{
            dictionary["requireCustomerKYC"] = requireCustomerKYC
        }
        
        
        if requiredClassInCustomer != nil{
            dictionary["requiredClassInCustomer"] = requiredClassInCustomer
        }
        if requiContactInCustomer != nil{
            dictionary["requiContactInCustomer"] = requiContactInCustomer
        }
        
        if requiredBeatPlanDropDownInCustomer != nil{
            dictionary["requiredBeatPlanDropDownInCustomer"] = requiredBeatPlanDropDownInCustomer
        }
        if requiEmailOrderToInCustomer != nil{
            dictionary["requiEmailOrderToInCustomer"] = requiEmailOrderToInCustomer
            
        }
        
        if requiAnniversaryDateInCustomer != nil{
            dictionary["requiAnniversaryDateInCustomer"] = requiAnniversaryDateInCustomer
        }
        if requiBirthDateInCustomer != nil{
            dictionary["requiBirthDateInCustomer"] = requiBirthDateInCustomer
        }
        if requiredSegmentInCustomer != nil{
            dictionary["requiredSegmentInCustomer"] = requiredSegmentInCustomer
        }
        if requiImagesInCustomer != nil{
            dictionary["requiImagesInCustomer"] = requiImagesInCustomer
        }
        
        if requiLandLineNumInCustomer != nil{
            dictionary["requiLandLineNumInCustomer"] = requiLandLineNumInCustomer
        }
        
        if custMobileNoLength != nil{
            dictionary["custMobileNoLength"] = custMobileNoLength
        }
        if customerMobileValidation != nil{
            dictionary["CustomerMobileValidation"] = customerMobileValidation
        }
        
        
        if allowCreatorToUpdateDespatch != nil{
            dictionary["allowCreatorToUpdateDespatch"] = allowCreatorToUpdateDespatch
        }
        
        
        if requiInteractionTypeInVisitReport != nil{
            dictionary["RequiInteractionTypeInVisitReport"] = requiInteractionTypeInVisitReport
        }
    
        if requiStoreCheckJustificationInVisitInCompetitor != nil{
            dictionary["RequiStoreCheckJustificationInVisitInCompetitor"] = requiStoreCheckJustificationInVisitInCompetitor
        }
        
        if requireCustomerVoterKYC != nil{
            dictionary["requireCustomerVoterKYC"] = requireCustomerVoterKYC
        }
    
        if isDisplayLoadCustomFormDataButton != nil{
            dictionary["isDisplayLoadCustomFormDataButton"] = isDisplayLoadCustomFormDataButton
        }
        
        
        if allowEditOrderForPreviousDate != nil{
            dictionary["allowEditOrderForPreviousDate"] = allowEditOrderForPreviousDate
        }
    
        if allowNegInventoryRetailerSTrade != nil{
            dictionary["AllowNegInventoryRetailerSTrade"] = allowNegInventoryRetailerSTrade
        }
        
        if smsDailyReportToManager != nil{
            dictionary["smsDailyReportToManager"] = smsDailyReportToManager
        }
    
        if splashScreenUponVisitCheckin != nil{
            dictionary["splashScreenUponVisitCheckin"] = splashScreenUponVisitCheckin
        }
        
        
        
        if requiProductInAddVisit != nil{
            dictionary["requiProductInAddVisit"] = requiProductInAddVisit
        }
    
        
        
        
        
        if apiForCustomerHistory != nil{
            dictionary["apiForCustomerHistory"] = apiForCustomerHistory
        }
        
        
        
        if immediateManagerApproval != nil{
            dictionary["immediateManagerApproval"] = immediateManagerApproval
        }
    
        
        
        
        if smsDailyReportToManagersManager != nil{
            dictionary["smsDailyReportToManagersManager"] =   smsDailyReportToManagersManager
        }
        
   
        if distributorToStockistMappingInCustomer != nil{
            dictionary["DistributorToStockistMappingInCustomer"] = distributorToStockistMappingInCustomer
        }
    
        if displayNextMeetingTimeInColdCall != nil{
            dictionary["displayNextMeetingTimeInColdCall"] = displayNextMeetingTimeInColdCall
        }
        
        if warrentyIDFirstTwoDigit != nil{
            dictionary["warrentyIDFirstTwoDigit"] = warrentyIDFirstTwoDigit
        }
    
        if visitCloseOtpRequireOrNot != nil{
            dictionary["visitCloseOtpRequireOrNot"] = visitCloseOtpRequireOrNot
        }
        
        
  
        
    
        if requiInteractionTypeInAddVisit != nil{
            dictionary["RequiInteractionTypeInAddVisit"] = requiInteractionTypeInAddVisit
        }
        
        if autoSharingOrderToCreator != nil{
            dictionary["autoSharingOrderToCreator"] = autoSharingOrderToCreator
        }
    
        if requireCustomerDrivingLicenceKYC != nil{
            dictionary["requireCustomerDrivingLicenceKYC"] = requireCustomerDrivingLicenceKYC
        }
        
        
        
        if warrantyIDNoOfDigit != nil{
            dictionary["warrantyIDNoOfDigit"] = warrantyIDNoOfDigit
        }
    
        if exportCustomerEnableDisable != nil{
            dictionary["exportCustomerEnableDisable"] = exportCustomerEnableDisable
        }
        
        
        
        
        if requiStoreCheckJustificationInVisit != nil{
            dictionary["RequiStoreCheckJustificationInVisit"] = requiStoreCheckJustificationInVisit
        }
        
        
        
        
        if requiDirectVisitFromLeadInAddVisit != nil{
            dictionary["RequiDirectVisitFromLeadInAddVisit"] = requiDirectVisitFromLeadInAddVisit
        }

        if freezeOpeningStockSTrade != nil{
            dictionary["freezeOpeningStockSTrade"] = freezeOpeningStockSTrade
        }
        
        if allowNegInventoryDistributorSTrade != nil{
            dictionary["allowNegInventoryDistributorSTrade"] = allowNegInventoryDistributorSTrade
        }
        
        if miniTimeOfVisitFrValid != nil{
            dictionary["miniTimeOfVisitFrValid"] = miniTimeOfVisitFrValid
        }
        if noOfDayForApprOfDeviInVAtte != nil{
            dictionary["noOfDayForApprOfDeviInVAtte"] = noOfDayForApprOfDeviInVAtte
        }
        
        
      
        if issueManagementEnable != nil{
            dictionary["IssueManagementEnable"] = issueManagementEnable
        }
    
        if issueManagementEnable != nil{
            dictionary["issueManagementEnable"] = issueManagementEnable
        }
        
        if sendSMSToCustUponCreationPlannedVisit != nil{
            dictionary["sendSMSToCustUponCreationPlannedVisit"] = sendSMSToCustUponCreationPlannedVisit
        }
        if numberOfKYC != nil{
            dictionary["numberOfKYC"] = numberOfKYC
        }
        
        
        
        
        
        
        
        if nextActionNewVisitCreation != nil{
            dictionary["nextActionNewVisitCreation"] = nextActionNewVisitCreation
        }
        
        if closeVisitAtEndOfDay != nil{
            dictionary["closeVisitAtEndOfDay"] = closeVisitAtEndOfDay
        }
        
        if closeVisitUpon != nil{
            dictionary["closeVisitUpon"] = closeVisitUpon
        }
        if visitToBeDownloadedUponLogin != nil{
            dictionary["visitToBeDownloadedUponLogin"] = visitToBeDownloadedUponLogin
        }
        
        
        
        
        
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
   /* @objc required init(coder aDecoder: NSCoder)
    {
         super.init(dictionary: [:])
         actionInAutoApprovalSTrade = aDecoder.decodeObject(forKey: "ActionInAutoApprovalSTrade") as? NSNumber
         additionalReminderTextInLead = aDecoder.decodeObject(forKey: "AdditionalReminderTextInLead") as? String
        addressSettingsForAttendance = aDecoder.decodeObject(forKey: "AddressSettingsForAttendance") as? NSNumber ?? NSNumber.init(value:0)
         adminInvoiceApproval = aDecoder.decodeObject(forKey: "AdminInvoiceApproval") as? NSNumber
         adminProposalApproval = aDecoder.decodeObject(forKey: "AdminProposalApproval") as? NSNumber
         adminSalesOrderApproval = aDecoder.decodeObject(forKey: "AdminSalesOrderApproval") as? NSNumber
         alarmReminder = aDecoder.decodeObject(forKey: "AlarmReminder") as? NSNumber
         allowMultipleDistributorInPurchaseSTrade = aDecoder.decodeObject(forKey: "AllowMultipleDistributorInPurchaseSTrade") as? NSNumber
         allowSalesOnlyIfPurchaseSTrade = aDecoder.decodeObject(forKey: "AllowSalesOnlyIfPurchaseSTrade") as? NSNumber
         allowSelfieInAttendance = aDecoder.decodeObject(forKey: "AllowSelfieInAttendance") as? NSNumber
         allowSrNoInDistributorSTrade = aDecoder.decodeObject(forKey: "AllowSrNoInDistributorSTrade") as? NSNumber
         allowZeroPriceInSO = aDecoder.decodeObject(forKey: "AllowZeroPriceInSO") as? NSNumber
         areaSetupType = aDecoder.decodeObject(forKey: "AreaSetupType") as? NSNumber
         areaTypeID = aDecoder.decodeObject(forKey: "AreaTypeID") as? NSNumber
         assignBeatPlanApproval = aDecoder.decodeObject(forKey: "AssignBeatPlanApproval") as? NSNumber
         autoCheckOutAttendance = aDecoder.decodeObject(forKey: "AutoCheckOutAttendance") as? NSNumber
         barCodeInProduct = aDecoder.decodeObject(forKey: "BarCodeInProduct") as? NSNumber
         cGSTSurcharges = aDecoder.decodeObject(forKey: "CGSTSurcharges") as? NSNumber
         cGSTTax = aDecoder.decodeObject(forKey: "CGSTTax") as? NSNumber
         cSTSurcharges = aDecoder.decodeObject(forKey: "CSTSurcharges") as? NSNumber
         cSTTax = aDecoder.decodeObject(forKey: "CSTTax") as? NSNumber
         cSTTaxNumber = aDecoder.decodeObject(forKey: "CSTTaxNumber") as? String
         coldCallReminder = aDecoder.decodeObject(forKey: "ColdCallReminder") as? NSNumber
         coldCallReminderFirst = aDecoder.decodeObject(forKey: "ColdCallReminderFirst") as? NSNumber
         coldCallReminderMissed = aDecoder.decodeObject(forKey: "ColdCallReminderMissed") as? NSNumber
         coldCallReminderSecond = aDecoder.decodeObject(forKey: "ColdCallReminderSecond") as? NSNumber
         companyID = aDecoder.decodeObject(forKey: "CompanyID") as? NSNumber
         createBeatPlanApproval = aDecoder.decodeObject(forKey: "CreateBeatPlanApproval") as? NSNumber
         createdBy = aDecoder.decodeObject(forKey: "CreatedBy") as? NSNumber
         createdTime = aDecoder.decodeObject(forKey: "CreatedTime") as? String
         customTagging = aDecoder.decodeObject(forKey: "CustomTagging") as? NSNumber
         customerAVisits = aDecoder.decodeObject(forKey: "CustomerAVisits") as? NSNumber
         customerBVisits = aDecoder.decodeObject(forKey: "CustomerBVisits") as? NSNumber
        customerApproval = aDecoder.decodeObject(forKey: "CustomerApproval") as? NSNumber
         customerCVisits = aDecoder.decodeObject(forKey: "CustomerCVisits") as? NSNumber
         customerDVisits = aDecoder.decodeObject(forKey: "CustomerDVisits") as? NSNumber
         customerInExpense = aDecoder.decodeObject(forKey: "CustomerInExpense") as? NSNumber
         customerOTPVerification = aDecoder.decodeObject(forKey: "CustomerOTPVerification") as? NSNumber
         customerProfileInUnplannedVisit = aDecoder.decodeObject(forKey: "CustomerProfileInUnplannedVisit") as? NSNumber
         customerVisitReminder = aDecoder.decodeObject(forKey: "CustomerVisitReminder") as? NSNumber
         customerVisitsDuration = aDecoder.decodeObject(forKey: "CustomerVisitsDuration") as? NSNumber
         dailyVistiApplication = aDecoder.decodeObject(forKey: "DailyVistiApplication") as? NSNumber
         daysToWaitInAutoApprovalSTrade = aDecoder.decodeObject(forKey: "DaysToWaitInAutoApprovalSTrade") as? NSNumber
         directSalesOrder = aDecoder.decodeObject(forKey: "DirectSalesOrder") as? NSNumber
         disableCheckoutInVisit = aDecoder.decodeObject(forKey: "DisableCheckoutInVisit") as? NSNumber
         disableOrderFromPlusMenu = aDecoder.decodeObject(forKey: "DisableOrderFromPlusMenu") as? NSNumber
         disableVisitFromPlusMenu = aDecoder.decodeObject(forKey: "DisableVisitFromPlusMenu") as? NSNumber
         discountType = aDecoder.decodeObject(forKey: "DiscountType") as? NSNumber
         discountValue = aDecoder.decodeObject(forKey: "DiscountValue") as? NSNumber
         enableWarrantyIDValidation = aDecoder.decodeObject(forKey: "EnableWarrantyIDValidation") as? NSNumber
         endTime = aDecoder.decodeObject(forKey: "EndTime") as? String
         exciseDuty = aDecoder.decodeObject(forKey: "ExciseDuty") as? NSNumber
         exciseSurcharges = aDecoder.decodeObject(forKey: "ExciseSurcharges") as? NSNumber
         expenseApproval = aDecoder.decodeObject(forKey: "ExpenseApproval") as? NSNumber
         fOCToggleInSO = aDecoder.decodeObject(forKey: "FOCToggleInSO") as? NSNumber
         firstCheckInAttendance = aDecoder.decodeObject(forKey: "FirstCheckInAttendance") as? NSNumber
         iD = aDecoder.decodeObject(forKey: "ID") as? NSNumber
         iGSTSurcharges = aDecoder.decodeObject(forKey: "IGSTSurcharges") as? NSNumber
         iGSTTax = aDecoder.decodeObject(forKey: "IGSTTax") as? NSNumber
         influencerInLead = aDecoder.decodeObject(forKey: "InfluencerInLead") as? NSNumber
        addSecondInfluencerInLead = aDecoder.decodeObject(forKey: "AddSecondInfluencerInLead") as? NSNumber
        
         invoiceConditions = aDecoder.decodeObject(forKey: "InvoiceConditions") as? String
         invoiceDueDays = aDecoder.decodeObject(forKey: "InvoiceDueDays") as? NSNumber
         invoiceFormat = aDecoder.decodeObject(forKey: "InvoiceFormat") as? String
         invoiceProductPermission = aDecoder.decodeObject(forKey: "InvoiceProductPermission") as? NSNumber
         invoiceReminder = aDecoder.decodeObject(forKey: "InvoiceReminder") as? NSNumber
         invoiceReminderFirst = aDecoder.decodeObject(forKey: "InvoiceReminderFirst") as? NSNumber
         invoiceReminderMissed = aDecoder.decodeObject(forKey: "InvoiceReminderMissed") as? NSNumber
         invoiceReminderSecond = aDecoder.decodeObject(forKey: "InvoiceReminderSecond") as? NSNumber
         invoiceTemplateID = aDecoder.decodeObject(forKey: "InvoiceTemplateID") as? NSNumber
         invoiceTerms = aDecoder.decodeObject(forKey: "InvoiceTerms") as? String
         isActive = aDecoder.decodeObject(forKey: "IsActive") as? NSNumber
         isCustomerClassEditable = aDecoder.decodeObject(forKey: "IsCustomerClassEditable") as? NSNumber
         isFirstSrNoOrProductCodeInSrNo = aDecoder.decodeObject(forKey: "IsFirstSrNoOrProductCodeInSrNo") as? NSNumber
         isLoyaltyEnabled = aDecoder.decodeObject(forKey: "IsLoyaltyEnabled") as? NSNumber
         joinPromotionInCustomerMandatory = aDecoder.decodeObject(forKey: "JoinPromotionInCustomerMandatory") as? NSNumber
         lastModifiedBy = aDecoder.decodeObject(forKey: "LastModifiedBy") as? NSNumber
         lastModifiedTime = aDecoder.decodeObject(forKey: "LastModifiedTime") as? String
         leadCustomerProfile = aDecoder.decodeObject(forKey: "LeadCustomerProfile") as? NSNumber
         leadCustomerProfileURL = aDecoder.decodeObject(forKey: "LeadCustomerProfileURL") as? String
         leadManualCheckInApproval = aDecoder.decodeObject(forKey: "LeadManualCheckInApproval") as? NSNumber
         leadProductPermission = aDecoder.decodeObject(forKey: "LeadProductPermission") as? NSNumber
         leadQualifiedTextInLead = aDecoder.decodeObject(forKey: "LeadQualifiedTextInLead") as? String
         leadReminder = aDecoder.decodeObject(forKey: "LeadReminder") as? NSNumber
         leadReminderFirst = aDecoder.decodeObject(forKey: "LeadReminderFirst") as? NSNumber
         leadReminderMissed = aDecoder.decodeObject(forKey: "LeadReminderMissed") as? NSNumber
         leadReminderSecond = aDecoder.decodeObject(forKey: "LeadReminderSecond") as? NSNumber
         leadsAutoAssign = aDecoder.decodeObject(forKey: "LeadsAutoAssign") as? NSNumber
         localTax = aDecoder.decodeObject(forKey: "LocalTax") as? NSNumber
         localTaxID = aDecoder.decodeObject(forKey: "LocalTaxID") as? NSNumber
         locationTrackCustomer = aDecoder.decodeObject(forKey: "LocationTrackCustomer") as? NSNumber
         locationTrackSalesForce = aDecoder.decodeObject(forKey: "LocationTrackSalesForce") as? NSNumber
         manageBom = aDecoder.decodeObject(forKey: "ManageBom") as? NSNumber
         manageBomDiscount = aDecoder.decodeObject(forKey: "ManageBomDiscount") as? NSNumber
         manageCGST = aDecoder.decodeObject(forKey: "ManageCGST") as? NSNumber
         manageCST = aDecoder.decodeObject(forKey: "ManageCST") as? NSNumber
         manageExciseDuty = aDecoder.decodeObject(forKey: "ManageExciseDuty") as? NSNumber
         manageIGST = aDecoder.decodeObject(forKey: "ManageIGST") as? NSNumber
         manageLocalTax = aDecoder.decodeObject(forKey: "ManageLocalTax") as? NSNumber
         managePayment = aDecoder.decodeObject(forKey: "ManagePayment") as? NSNumber
         manageProductPromotionJoin = aDecoder.decodeObject(forKey: "ManageProductPromotionJoin") as? NSNumber
         managePromotionBudget = aDecoder.decodeObject(forKey: "ManagePromotionBudget") as? NSNumber
         managePurchaseOrder = aDecoder.decodeObject(forKey: "ManagePurchaseOrder") as? NSNumber
         manageSGST = aDecoder.decodeObject(forKey: "ManageSGST") as? NSNumber
         manageServiceTax = aDecoder.decodeObject(forKey: "ManageServiceTax") as? NSNumber
         manageVat = aDecoder.decodeObject(forKey: "ManageVat") as? NSNumber
         managerApplyManualAttendance = aDecoder.decodeObject(forKey: "ManagerApplyManualAttendance") as? NSNumber
         managerApproveCheckInCheckOutUpdate = aDecoder.decodeObject(forKey: "ManagerApproveCheckInCheckOutUpdate") as? NSNumber
         managerApproveCustomerVendorTravelCheckInCheckOut = aDecoder.decodeObject(forKey: "ManagerApproveCustomerVendorTravelCheckInCheckOut") as? NSNumber
         managerApproveLeave = aDecoder.decodeObject(forKey: "ManagerApproveLeave") as? NSNumber
         managerApproveManualAttendance = aDecoder.decodeObject(forKey: "ManagerApproveManualAttendance") as? NSNumber
         managerInvoiceApproval = aDecoder.decodeObject(forKey: "ManagerInvoiceApproval") as? NSNumber
         managerLeadsAssign = aDecoder.decodeObject(forKey: "ManagerLeadsAssign") as? NSNumber
         managerLeadsReassign = aDecoder.decodeObject(forKey: "ManagerLeadsReassign") as? NSNumber
         managerPaymentReceivedApproval = aDecoder.decodeObject(forKey: "ManagerPaymentReceivedApproval") as? NSNumber
         managerProposalApproval = aDecoder.decodeObject(forKey: "ManagerProposalApproval") as? NSNumber
         managerPurchaseOrderApproval = aDecoder.decodeObject(forKey: "ManagerPurchaseOrderApproval") as? NSNumber
         managerPurchaseOrderCancellation = aDecoder.decodeObject(forKey: "ManagerPurchaseOrderCancellation") as? NSNumber
         managerSalesOrderApproval = aDecoder.decodeObject(forKey: "ManagerSalesOrderApproval") as? NSNumber
         managerSalesOrderCancellation = aDecoder.decodeObject(forKey: "ManagerSalesOrderCancellation") as? NSNumber
         managerSalesTargetApproval = aDecoder.decodeObject(forKey: "ManagerSalesTargetApproval") as? NSNumber
         managerSelfAssignLead = aDecoder.decodeObject(forKey: "ManagerSelfAssignLead") as? NSNumber
         managerShowTracking = aDecoder.decodeObject(forKey: "ManagerShowTracking") as? NSNumber
         managerTrackSalesExecutive = aDecoder.decodeObject(forKey: "ManagerTrackSalesExecutive") as? NSNumber
         managerTrackSalesRepresentative = aDecoder.decodeObject(forKey: "ManagerTrackSalesRepresentative") as? NSNumber
         managerWorkingHoursTracking = aDecoder.decodeObject(forKey: "ManagerWorkingHoursTracking") as? NSNumber
         mandatoryCustomerSegment = aDecoder.decodeObject(forKey: "MandatoryCustomerSegment") as? NSNumber
         mandatoryLeadUpdateStatus = aDecoder.decodeObject(forKey: "MandatoryLeadUpdateStatus") as? NSNumber
         mandatoryPictureInCreateCustomer = aDecoder.decodeObject(forKey: "MandatoryPictureInCreateCustomer") as? NSNumber
         mandatoryPictureInVisit = aDecoder.decodeObject(forKey: "MandatoryPictureInVisit") as? NSNumber
         mandatoryTrialSuccessfulStatusForOrderInLead = aDecoder.decodeObject(forKey: "MandatoryTrialSuccessfulStatusForOrderInLead") as? NSNumber
         mandatoryVisitReport = aDecoder.decodeObject(forKey: "MandatoryVisitReport") as? NSNumber
         maxOrderQty = aDecoder.decodeObject(forKey: "MaxOrderQty") as? NSNumber
         maximumVisitConfiguration = aDecoder.decodeObject(forKey: "MaximumVisitConfiguration") as? NSNumber
         modeOfPayReferenceRequiredInCollection = aDecoder.decodeObject(forKey: "ModeOfPayReferenceRequiredInCollection") as? NSNumber
         monthInInvoiceOrderSuggestQty = aDecoder.decodeObject(forKey: "MonthInInvoiceOrderSuggestQty") as? NSNumber
         negotiationTextInLead = aDecoder.decodeObject(forKey: "NegotiationTextInLead") as? String
         oTPConfirmationAtPromotion = aDecoder.decodeObject(forKey: "OTPConfirmationAtPromotion") as? NSNumber
         pANNumber = aDecoder.decodeObject(forKey: "PANNumber") as? String
         perHourTravelInKM = aDecoder.decodeObject(forKey: "PerHourTravelInKM") as? NSNumber
         plusMenuInVisitDetail = aDecoder.decodeObject(forKey: "PlusMenuInVisitDetail") as? NSNumber
         priceEditable = aDecoder.decodeObject(forKey: "PriceEditable") as? NSNumber
         priceEditableDistributorPOSTrade = aDecoder.decodeObject(forKey: "PriceEditableDistributorPOSTrade") as? NSNumber
         priceEditableRetailerPOSTrade = aDecoder.decodeObject(forKey: "PriceEditableRetailerPOSTrade") as? NSNumber
         productInterestedInUnplannedVisit = aDecoder.decodeObject(forKey: "ProductInterestedInUnplannedVisit") as? NSNumber
         productMandatoryInLead = aDecoder.decodeObject(forKey: "ProductMandatoryInLead") as? NSNumber
         productSelectionTypeInSTrade = aDecoder.decodeObject(forKey: "ProductSelectionTypeInSTrade") as? NSNumber
         proposalConditions = aDecoder.decodeObject(forKey: "ProposalConditions") as? String
         proposalFormat = aDecoder.decodeObject(forKey: "ProposalFormat") as? String
         proposalProductPermission = aDecoder.decodeObject(forKey: "ProposalProductPermission") as? NSNumber
         proposalSubTextInLead = aDecoder.decodeObject(forKey: "ProposalSubTextInLead") as? String
         proposalTemplateID = aDecoder.decodeObject(forKey: "ProposalTemplateID") as? NSNumber
         proposalTerms = aDecoder.decodeObject(forKey: "ProposalTerms") as? String
         purchaseOrderConditions = aDecoder.decodeObject(forKey: "PurchaseOrderConditions") as? String
         purchaseOrderFormat = aDecoder.decodeObject(forKey: "PurchaseOrderFormat") as? String
         purchaseOrderTemplateID = aDecoder.decodeObject(forKey: "PurchaseOrderTemplateID") as? NSNumber
         purchaseOrderTerms = aDecoder.decodeObject(forKey: "PurchaseOrderTerms") as? String
         requireAddNewCustomerInVisitLeadOrder = aDecoder.decodeObject(forKey: "RequireAddNewCustomerInVisitLeadOrder") as? NSNumber
         requireCustCodeInCustomer = aDecoder.decodeObject(forKey: "RequireCustCodeInCustomer") as? NSNumber
         requireCustomerTypeInUnplannedVisit = aDecoder.decodeObject(forKey: "RequireCustomerTypeInUnplannedVisit") as? NSNumber
         requireDeliveryDaysAndTnCInSO = aDecoder.decodeObject(forKey: "RequireDeliveryDaysAndTnCInSO") as? NSNumber
         requireDiscountAndTaxAmountInSO = aDecoder.decodeObject(forKey: "RequireDiscountAndTaxAmountInSO") as? NSNumber
         requireKeyCustInCustomer = aDecoder.decodeObject(forKey: "RequireKeyCustInCustomer") as? NSNumber
         requirePromotionInSO = aDecoder.decodeObject(forKey: "RequirePromotionInSO") as? NSNumber
         requireSOFromVisitBeforeCheckOut = aDecoder.decodeObject(forKey: "RequireSOFromVisitBeforeCheckOut") as? NSNumber
         requireTaxInCustomer = aDecoder.decodeObject(forKey: "RequireTaxInCustomer") as? NSNumber
         requireTempCustomerProfile = aDecoder.decodeObject(forKey: "RequireTempCustomerProfile") as? NSNumber
         requireTownInCustomer = aDecoder.decodeObject(forKey: "RequireTownInCustomer") as? NSNumber
         requireVisitCollection = aDecoder.decodeObject(forKey: "RequireVisitCollection") as? NSNumber
         requireVisitCounterShare = aDecoder.decodeObject(forKey: "RequireVisitCounterShare") as? NSNumber
         sGSTSurcharges = aDecoder.decodeObject(forKey: "SGSTSurcharges") as? NSNumber
         sGSTTax = aDecoder.decodeObject(forKey: "SGSTTax") as? NSNumber
         sMSInVisitCheckIn = aDecoder.decodeObject(forKey: "SMSInVisitCheckIn") as? NSNumber
         sORequireWarrantyAndDealerCode = aDecoder.decodeObject(forKey: "SORequireWarrantyAndDealerCode") as? NSNumber
         salesExecutiveApplyManualAttendance = aDecoder.decodeObject(forKey: "SalesExecutiveApplyManualAttendance") as? NSNumber
         salesExecutiveApproveCheckInCheckOutUpdate = aDecoder.decodeObject(forKey: "SalesExecutiveApproveCheckInCheckOutUpdate") as? NSNumber
         salesExecutiveApproveCustomerVendorTravelCheckInCheckOut = aDecoder.decodeObject(forKey: "SalesExecutiveApproveCustomerVendorTravelCheckInCheckOut") as? NSNumber
         salesExecutiveApproveLeave = aDecoder.decodeObject(forKey: "SalesExecutiveApproveLeave") as? NSNumber
         salesExecutiveApproveManualAttendance = aDecoder.decodeObject(forKey: "SalesExecutiveApproveManualAttendance") as? NSNumber
         salesExecutiveCreateInvoice = aDecoder.decodeObject(forKey: "SalesExecutiveCreateInvoice") as? NSNumber
         salesExecutivePaymentReceivedApproval = aDecoder.decodeObject(forKey: "SalesExecutivePaymentReceivedApproval") as? NSNumber
         salesExecutiveSelfAssignLead = aDecoder.decodeObject(forKey: "SalesExecutiveSelfAssignLead") as? NSNumber
         salesExecutiveShowTracking = aDecoder.decodeObject(forKey: "SalesExecutiveShowTracking") as? NSNumber
         salesExecutiveTrackSalesRepresentative = aDecoder.decodeObject(forKey: "SalesExecutiveTrackSalesRepresentative") as? NSNumber
         salesExecutiveWorkingHoursTracking = aDecoder.decodeObject(forKey: "SalesExecutiveWorkingHoursTracking") as? NSNumber
         salesOrderConditions = aDecoder.decodeObject(forKey: "SalesOrderConditions") as? String
         salesOrderFormat = aDecoder.decodeObject(forKey: "SalesOrderFormat") as? String
         salesOrderFulfillmentFrom = aDecoder.decodeObject(forKey: "SalesOrderFulfillmentFrom") as? NSNumber
         salesOrderProductPermission = aDecoder.decodeObject(forKey: "SalesOrderProductPermission") as? NSNumber
         salesOrderReportPermission = aDecoder.decodeObject(forKey: "SalesOrderReportPermission") as? NSNumber
         salesOrderTemplateID = aDecoder.decodeObject(forKey: "SalesOrderTemplateID") as? NSNumber
         salesOrderTerms = aDecoder.decodeObject(forKey: "SalesOrderTerms") as? String
         salesRepresantativeApplyManualAttendance = aDecoder.decodeObject(forKey: "SalesRepresantativeApplyManualAttendance") as? NSNumber
         salesRepresentativeShowTracking = aDecoder.decodeObject(forKey: "SalesRepresentativeShowTracking") as? NSNumber
         salesRepresentativeWorkingHoursTracking = aDecoder.decodeObject(forKey: "SalesRepresentativeWorkingHoursTracking") as? NSNumber
         sendNotnInSOMaxDiscount = aDecoder.decodeObject(forKey: "SendNotnInSOMaxDiscount") as? NSNumber
         serviceSurcharges = aDecoder.decodeObject(forKey: "ServiceSurcharges") as? NSNumber
         serviceTax = aDecoder.decodeObject(forKey: "ServiceTax") as? NSNumber
         serviceTaxNumber = aDecoder.decodeObject(forKey: "ServiceTaxNumber") as? String
         shelfSpaceUnit = aDecoder.decodeObject(forKey: "ShelfSpaceUnit") as? String
         showActionCloseOrderInLead = aDecoder.decodeObject(forKey: "ShowActionCloseOrderInLead") as? NSNumber
         showAdditionalReminderInLead = aDecoder.decodeObject(forKey: "ShowAdditionalReminderInLead") as? NSNumber
         showKPIOnSplashScreen = aDecoder.decodeObject(forKey: "ShowKPIOnSplashScreen") as? NSNumber
         showLeadQualifiedInLead = aDecoder.decodeObject(forKey: "ShowLeadQualifiedInLead") as? NSNumber
         showNegotiationInLead = aDecoder.decodeObject(forKey: "ShowNegotiationInLead") as? NSNumber
         showOurChancesInLead = aDecoder.decodeObject(forKey: "ShowOurChancesInLead") as? NSNumber
         showProductDrive = aDecoder.decodeObject(forKey: "ShowProductDrive") as? NSNumber
         showProposalSubInLead = aDecoder.decodeObject(forKey: "ShowProposalSubInLead") as? NSNumber
         showShelfSpace = aDecoder.decodeObject(forKey: "ShowShelfSpace") as? NSNumber
         showSuggestOrderQty = aDecoder.decodeObject(forKey: "ShowSuggestOrderQty") as? NSNumber
         showTrialDoneInLead = aDecoder.decodeObject(forKey: "ShowTrialDoneInLead") as? NSNumber
         startTime = aDecoder.decodeObject(forKey: "StartTime") as? String
         stockUpdateInOrder = aDecoder.decodeObject(forKey: "StockUpdateInOrder") as? NSNumber
         storeCheckCompetition = aDecoder.decodeObject(forKey: "StoreCheckCompetition") as? NSNumber
         storeCheckOwnBrand = aDecoder.decodeObject(forKey: "StoreCheckOwnBrand") as? NSNumber
         suggestOrderQtyCalculation = aDecoder.decodeObject(forKey: "SuggestOrderQtyCalculation") as? NSNumber
         territoryInCustomer = aDecoder.decodeObject(forKey: "TerritoryInCustomer") as? NSNumber
         territoryMandatoryInBeatPlan = aDecoder.decodeObject(forKey: "TerritoryMandatoryInBeatPlan") as? NSNumber
         totalCharsInFirstSlab = aDecoder.decodeObject(forKey: "TotalCharsInFirstSlab") as? NSNumber
         totalCharsInSrNo = aDecoder.decodeObject(forKey: "TotalCharsInSrNo") as? NSNumber
         travelCheckInExecutiveApproval = aDecoder.decodeObject(forKey: "TravelCheckInExecutiveApproval") as? NSNumber
         travelCheckInManagerApproval = aDecoder.decodeObject(forKey: "TravelCheckInManagerApproval") as? NSNumber
         trialDoneTextInLead = aDecoder.decodeObject(forKey: "TrialDoneTextInLead") as? String
         vATAdditionalTax = aDecoder.decodeObject(forKey: "VATAdditionalTax") as? NSNumber
         vATSurcharges = aDecoder.decodeObject(forKey: "VATSurcharges") as? NSNumber
         vATTax = aDecoder.decodeObject(forKey: "VATTax") as? NSNumber
         vATTaxNumber = aDecoder.decodeObject(forKey: "VATTaxNumber") as? String
         vatCodeFrom = aDecoder.decodeObject(forKey: "VatCodeFrom") as? NSNumber
         vatGst = aDecoder.decodeObject(forKey: "VatGst") as? NSNumber
         viewCompanyStock = aDecoder.decodeObject(forKey: "ViewCompanyStock") as? NSNumber
         visitCheckInApproval = aDecoder.decodeObject(forKey: "VisitCheckInApproval") as? NSNumber
         visitCheckInCheckoutDiff = aDecoder.decodeObject(forKey: "VisitCheckInCheckoutDiff") as? NSNumber
         visitManualCheckInApproval = aDecoder.decodeObject(forKey: "VisitManualCheckInApproval") as? NSNumber
         visitMenuOnHomeScreen = aDecoder.decodeObject(forKey: "VisitMenuOnHomeScreen") as? NSNumber
         visitModule = aDecoder.decodeObject(forKey: "VisitModule") as? NSNumber
         visitProductPermission = aDecoder.decodeObject(forKey: "VisitProductPermission") as? NSNumber
         visitReminder = aDecoder.decodeObject(forKey: "VisitReminder") as? NSNumber
         visitReminderFirst = aDecoder.decodeObject(forKey: "VisitReminderFirst") as? NSNumber
         visitReminderMissed = aDecoder.decodeObject(forKey: "VisitReminderMissed") as? NSNumber
         visitReminderSecond = aDecoder.decodeObject(forKey: "VisitReminderSecond") as? NSNumber
         visitStepsRequired = aDecoder.decodeObject(forKey: "VisitStepsRequired") as? NSNumber
        salesOrderLoadPage = aDecoder.decodeObject(forKey:"SalesOrderLoadPage") as? NSNumber
    }
    
//    required init(dictionary: [String : Any]) {
//        super.init(dictionary: [:])
//    }
    
    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if actionInAutoApprovalSTrade != nil{
            aCoder.encode(actionInAutoApprovalSTrade, forKey: "ActionInAutoApprovalSTrade")
        }
        if additionalReminderTextInLead != nil{
            aCoder.encode(additionalReminderTextInLead, forKey: "AdditionalReminderTextInLead")
        }
        if addressSettingsForAttendance != nil{
            aCoder.encode(addressSettingsForAttendance, forKey: "AddressSettingsForAttendance")
        }
        if adminInvoiceApproval != nil{
            aCoder.encode(adminInvoiceApproval, forKey: "AdminInvoiceApproval")
        }
        if adminProposalApproval != nil{
            aCoder.encode(adminProposalApproval, forKey: "AdminProposalApproval")
        }
        if adminSalesOrderApproval != nil{
            aCoder.encode(adminSalesOrderApproval, forKey: "AdminSalesOrderApproval")
        }
        if alarmReminder != nil{
            aCoder.encode(alarmReminder, forKey: "AlarmReminder")
        }
        if allowMultipleDistributorInPurchaseSTrade != nil{
            aCoder.encode(allowMultipleDistributorInPurchaseSTrade, forKey: "AllowMultipleDistributorInPurchaseSTrade")
        }
        if allowSalesOnlyIfPurchaseSTrade != nil{
            aCoder.encode(allowSalesOnlyIfPurchaseSTrade, forKey: "AllowSalesOnlyIfPurchaseSTrade")
        }
        if allowSelfieInAttendance != nil{
            aCoder.encode(allowSelfieInAttendance, forKey: "AllowSelfieInAttendance")
        }
        if allowSrNoInDistributorSTrade != nil{
            aCoder.encode(allowSrNoInDistributorSTrade, forKey: "AllowSrNoInDistributorSTrade")
        }
        if allowZeroPriceInSO != nil{
            aCoder.encode(allowZeroPriceInSO, forKey: "AllowZeroPriceInSO")
        }
        if areaSetupType != nil{
            aCoder.encode(areaSetupType, forKey: "AreaSetupType")
        }
        if areaTypeID != nil{
            aCoder.encode(areaTypeID, forKey: "AreaTypeID")
        }
        if assignBeatPlanApproval != nil{
            aCoder.encode(assignBeatPlanApproval, forKey: "AssignBeatPlanApproval")
        }
        if autoCheckOutAttendance != nil{
            aCoder.encode(autoCheckOutAttendance, forKey: "AutoCheckOutAttendance")
        }
        if barCodeInProduct != nil{
            aCoder.encode(barCodeInProduct, forKey: "BarCodeInProduct")
        }
        if cGSTSurcharges != nil{
            aCoder.encode(cGSTSurcharges, forKey: "CGSTSurcharges")
        }
        if cGSTTax != nil{
            aCoder.encode(cGSTTax, forKey: "CGSTTax")
        }
        if cSTSurcharges != nil{
            aCoder.encode(cSTSurcharges, forKey: "CSTSurcharges")
        }
        if cSTTax != nil{
            aCoder.encode(cSTTax, forKey: "CSTTax")
        }
        if cSTTaxNumber != nil{
            aCoder.encode(cSTTaxNumber, forKey: "CSTTaxNumber")
        }
        if coldCallReminder != nil{
            aCoder.encode(coldCallReminder, forKey: "ColdCallReminder")
        }
        if coldCallReminderFirst != nil{
            aCoder.encode(coldCallReminderFirst, forKey: "ColdCallReminderFirst")
        }
        if coldCallReminderMissed != nil{
            aCoder.encode(coldCallReminderMissed, forKey: "ColdCallReminderMissed")
        }
        if coldCallReminderSecond != nil{
            aCoder.encode(coldCallReminderSecond, forKey: "ColdCallReminderSecond")
        }
        if companyID != nil{
            aCoder.encode(companyID, forKey: "CompanyID")
        }
        if createBeatPlanApproval != nil{
            aCoder.encode(createBeatPlanApproval, forKey: "CreateBeatPlanApproval")
        }
        if createdBy != nil{
            aCoder.encode(createdBy, forKey: "CreatedBy")
        }
        if createdTime != nil{
            aCoder.encode(createdTime, forKey: "CreatedTime")
        }
        if customTagging != nil{
            aCoder.encode(customTagging, forKey: "CustomTagging")
        }
        if customerAVisits != nil{
            aCoder.encode(customerAVisits, forKey: "CustomerAVisits")
        }
        if customerApproval != nil{
            aCoder.encode(customerApproval , forKey:"CustomerApproval")
        }
        if customerBVisits != nil{
            aCoder.encode(customerBVisits, forKey: "CustomerBVisits")
        }
        if customerCVisits != nil{
            aCoder.encode(customerCVisits, forKey: "CustomerCVisits")
        }
        if customerDVisits != nil{
            aCoder.encode(customerDVisits, forKey: "CustomerDVisits")
        }
        if customerInExpense != nil{
            aCoder.encode(customerInExpense, forKey: "CustomerInExpense")
        }
        if customerOTPVerification != nil{
            aCoder.encode(customerOTPVerification, forKey: "CustomerOTPVerification")
        }
        if customerProfileInUnplannedVisit != nil{
            aCoder.encode(customerProfileInUnplannedVisit, forKey: "CustomerProfileInUnplannedVisit")
        }
        if customerVisitReminder != nil{
            aCoder.encode(customerVisitReminder, forKey: "CustomerVisitReminder")
        }
        if customerVisitsDuration != nil{
            aCoder.encode(customerVisitsDuration, forKey: "CustomerVisitsDuration")
        }
        if dailyVistiApplication != nil{
            aCoder.encode(dailyVistiApplication, forKey: "DailyVistiApplication")
        }
        if daysToWaitInAutoApprovalSTrade != nil{
            aCoder.encode(daysToWaitInAutoApprovalSTrade, forKey: "DaysToWaitInAutoApprovalSTrade")
        }
        if directSalesOrder != nil{
            aCoder.encode(directSalesOrder, forKey: "DirectSalesOrder")
        }
        if disableCheckoutInVisit != nil{
            aCoder.encode(disableCheckoutInVisit, forKey: "DisableCheckoutInVisit")
        }
        if disableOrderFromPlusMenu != nil{
            aCoder.encode(disableOrderFromPlusMenu, forKey: "DisableOrderFromPlusMenu")
        }
        if disableVisitFromPlusMenu != nil{
            aCoder.encode(disableVisitFromPlusMenu, forKey: "DisableVisitFromPlusMenu")
        }
        if discountType != nil{
            aCoder.encode(discountType, forKey: "DiscountType")
        }
        if discountValue != nil{
            aCoder.encode(discountValue, forKey: "DiscountValue")
        }
        if enableWarrantyIDValidation != nil{
            aCoder.encode(enableWarrantyIDValidation, forKey: "EnableWarrantyIDValidation")
        }
        if endTime != nil
        {
            aCoder.encode(endTime, forKey: "EndTime")
        }
        if exciseDuty != nil
        {
            aCoder.encode(exciseDuty, forKey: "ExciseDuty")
        }
        if exciseSurcharges != nil
        {
            aCoder.encode(exciseSurcharges, forKey: "ExciseSurcharges")
        }
        if expenseApproval != nil
        {
            aCoder.encode(expenseApproval, forKey: "ExpenseApproval")
        }
        if fOCToggleInSO != nil
        {
            aCoder.encode(fOCToggleInSO, forKey: "FOCToggleInSO")
        }
        if firstCheckInAttendance != nil
        {
            aCoder.encode(firstCheckInAttendance, forKey: "FirstCheckInAttendance")
        }
        if iD != nil{
            aCoder.encode(iD, forKey: "ID")
        }
        if iGSTSurcharges != nil{
            aCoder.encode(iGSTSurcharges, forKey: "IGSTSurcharges")
        }
        if iGSTTax != nil{
            aCoder.encode(iGSTTax, forKey: "IGSTTax")
        }
        if influencerInLead != nil{
            aCoder.encode(influencerInLead, forKey: "InfluencerInLead")
        }
        if addSecondInfluencerInLead != nil{
            aCoder.encode(addSecondInfluencerInLead, forKey: "AddSecondInfluencerInLead")
        }
        if invoiceConditions != nil{
            aCoder.encode(invoiceConditions, forKey: "InvoiceConditions")
        }
        if invoiceDueDays != nil{
            aCoder.encode(invoiceDueDays, forKey: "InvoiceDueDays")
        }
        if invoiceFormat != nil{
            aCoder.encode(invoiceFormat, forKey: "InvoiceFormat")
        }
        if invoiceProductPermission != nil{
            aCoder.encode(invoiceProductPermission, forKey: "InvoiceProductPermission")
        }
        if invoiceReminder != nil{
            aCoder.encode(invoiceReminder, forKey: "InvoiceReminder")
        }
        if invoiceReminderFirst != nil{
            aCoder.encode(invoiceReminderFirst, forKey: "InvoiceReminderFirst")
        }
        if invoiceReminderMissed != nil{
            aCoder.encode(invoiceReminderMissed, forKey: "InvoiceReminderMissed")
        }
        if invoiceReminderSecond != nil{
            aCoder.encode(invoiceReminderSecond, forKey: "InvoiceReminderSecond")
        }
        if invoiceTemplateID != nil{
            aCoder.encode(invoiceTemplateID, forKey: "InvoiceTemplateID")
        }
        if invoiceTerms != nil{
            aCoder.encode(invoiceTerms, forKey: "InvoiceTerms")
        }
        if isActive != nil{
            aCoder.encode(isActive, forKey: "IsActive")
        }
        if isCustomerClassEditable != nil{
            aCoder.encode(isCustomerClassEditable, forKey: "IsCustomerClassEditable")
        }
        if isFirstSrNoOrProductCodeInSrNo != nil{
            aCoder.encode(isFirstSrNoOrProductCodeInSrNo, forKey: "IsFirstSrNoOrProductCodeInSrNo")
        }
        if isLoyaltyEnabled != nil{
            aCoder.encode(isLoyaltyEnabled, forKey: "IsLoyaltyEnabled")
        }
        if joinPromotionInCustomerMandatory != nil{
            aCoder.encode(joinPromotionInCustomerMandatory, forKey: "JoinPromotionInCustomerMandatory")
        }
        if lastModifiedBy != nil{
            aCoder.encode(lastModifiedBy, forKey: "LastModifiedBy")
        }
        if lastModifiedTime != nil{
            aCoder.encode(lastModifiedTime, forKey: "LastModifiedTime")
        }
        if leadCustomerProfile != nil{
            aCoder.encode(leadCustomerProfile, forKey: "LeadCustomerProfile")
        }
        if leadCustomerProfileURL != nil{
            aCoder.encode(leadCustomerProfileURL, forKey: "LeadCustomerProfileURL")
        }
        if leadManualCheckInApproval != nil{
            aCoder.encode(leadManualCheckInApproval, forKey: "LeadManualCheckInApproval")
        }
        if leadProductPermission != nil{
            aCoder.encode(leadProductPermission, forKey: "LeadProductPermission")
        }
        if leadQualifiedTextInLead != nil{
            aCoder.encode(leadQualifiedTextInLead, forKey: "LeadQualifiedTextInLead")
        }
        if leadReminder != nil{
            aCoder.encode(leadReminder, forKey: "LeadReminder")
        }
        if leadReminderFirst != nil{
            aCoder.encode(leadReminderFirst, forKey: "LeadReminderFirst")
        }
        if leadReminderMissed != nil{
            aCoder.encode(leadReminderMissed, forKey: "LeadReminderMissed")
        }
        if leadReminderSecond != nil{
            aCoder.encode(leadReminderSecond, forKey: "LeadReminderSecond")
        }
        if leadsAutoAssign != nil{
            aCoder.encode(leadsAutoAssign, forKey: "LeadsAutoAssign")
        }
        if localTax != nil{
            aCoder.encode(localTax, forKey: "LocalTax")
        }
        if localTaxID != nil{
            aCoder.encode(localTaxID, forKey: "LocalTaxID")
        }
        if locationTrackCustomer != nil{
            aCoder.encode(locationTrackCustomer, forKey: "LocationTrackCustomer")
        }
        if locationTrackSalesForce != nil{
            aCoder.encode(locationTrackSalesForce, forKey: "LocationTrackSalesForce")
        }
        if manageBom != nil{
            aCoder.encode(manageBom, forKey: "ManageBom")
        }
        if manageBomDiscount != nil{
            aCoder.encode(manageBomDiscount, forKey: "ManageBomDiscount")
        }
        if manageCGST != nil{
            aCoder.encode(manageCGST, forKey: "ManageCGST")
        }
        if manageCST != nil{
            aCoder.encode(manageCST, forKey: "ManageCST")
        }
        if manageExciseDuty != nil{
            aCoder.encode(manageExciseDuty, forKey: "ManageExciseDuty")
        }
        if manageIGST != nil{
            aCoder.encode(manageIGST, forKey: "ManageIGST")
        }
        if manageLocalTax != nil{
            aCoder.encode(manageLocalTax, forKey: "ManageLocalTax")
        }
        if managePayment != nil{
            aCoder.encode(managePayment, forKey: "ManagePayment")
        }
        if manageProductPromotionJoin != nil{
            aCoder.encode(manageProductPromotionJoin, forKey: "ManageProductPromotionJoin")
        }
        if managePromotionBudget != nil{
            aCoder.encode(managePromotionBudget, forKey: "ManagePromotionBudget")
        }
        if managePurchaseOrder != nil{
            aCoder.encode(managePurchaseOrder, forKey: "ManagePurchaseOrder")
        }
        if manageSGST != nil{
            aCoder.encode(manageSGST, forKey: "ManageSGST")
        }
        if manageServiceTax != nil{
            aCoder.encode(manageServiceTax, forKey: "ManageServiceTax")
        }
        if manageVat != nil{
            aCoder.encode(manageVat, forKey: "ManageVat")
        }
        if managerApplyManualAttendance != nil{
            aCoder.encode(managerApplyManualAttendance, forKey: "ManagerApplyManualAttendance")
        }
        if managerApproveCheckInCheckOutUpdate != nil{
            aCoder.encode(managerApproveCheckInCheckOutUpdate, forKey: "ManagerApproveCheckInCheckOutUpdate")
        }
        if managerApproveCustomerVendorTravelCheckInCheckOut != nil{
            aCoder.encode(managerApproveCustomerVendorTravelCheckInCheckOut, forKey: "ManagerApproveCustomerVendorTravelCheckInCheckOut")
        }
        if managerApproveLeave != nil{
            aCoder.encode(managerApproveLeave, forKey: "ManagerApproveLeave")
        }
        if managerApproveManualAttendance != nil{
            aCoder.encode(managerApproveManualAttendance, forKey: "ManagerApproveManualAttendance")
        }
        if managerInvoiceApproval != nil{
            aCoder.encode(managerInvoiceApproval, forKey: "ManagerInvoiceApproval")
        }
        if managerLeadsAssign != nil{
            aCoder.encode(managerLeadsAssign, forKey: "ManagerLeadsAssign")
        }
        if managerLeadsReassign != nil{
            aCoder.encode(managerLeadsReassign, forKey: "ManagerLeadsReassign")
        }
        if managerPaymentReceivedApproval != nil{
            aCoder.encode(managerPaymentReceivedApproval, forKey: "ManagerPaymentReceivedApproval")
        }
        if managerProposalApproval != nil{
            aCoder.encode(managerProposalApproval, forKey: "ManagerProposalApproval")
        }
        if managerPurchaseOrderApproval != nil{
            aCoder.encode(managerPurchaseOrderApproval, forKey: "ManagerPurchaseOrderApproval")
        }
        if managerPurchaseOrderCancellation != nil{
            aCoder.encode(managerPurchaseOrderCancellation, forKey: "ManagerPurchaseOrderCancellation")
        }
        if managerSalesOrderApproval != nil{
            aCoder.encode(managerSalesOrderApproval, forKey: "ManagerSalesOrderApproval")
        }
        if managerSalesOrderCancellation != nil{
            aCoder.encode(managerSalesOrderCancellation, forKey: "ManagerSalesOrderCancellation")
        }
        if managerSalesTargetApproval != nil{
            aCoder.encode(managerSalesTargetApproval, forKey: "ManagerSalesTargetApproval")
        }
        if managerSelfAssignLead != nil{
            aCoder.encode(managerSelfAssignLead, forKey: "ManagerSelfAssignLead")
        }
        if managerShowTracking != nil{
            aCoder.encode(managerShowTracking, forKey: "ManagerShowTracking")
        }
        if managerTrackSalesExecutive != nil{
            aCoder.encode(managerTrackSalesExecutive, forKey: "ManagerTrackSalesExecutive")
        }
        if managerTrackSalesRepresentative != nil{
            aCoder.encode(managerTrackSalesRepresentative, forKey: "ManagerTrackSalesRepresentative")
        }
        if managerWorkingHoursTracking != nil{
            aCoder.encode(managerWorkingHoursTracking, forKey: "ManagerWorkingHoursTracking")
        }
        if mandatoryCustomerSegment != nil{
            aCoder.encode(mandatoryCustomerSegment, forKey: "MandatoryCustomerSegment")
        }
        if mandatoryLeadUpdateStatus != nil{
            aCoder.encode(mandatoryLeadUpdateStatus, forKey: "MandatoryLeadUpdateStatus")
        }
        if mandatoryPictureInCreateCustomer != nil{
            aCoder.encode(mandatoryPictureInCreateCustomer, forKey: "MandatoryPictureInCreateCustomer")
        }
        if mandatoryPictureInVisit != nil{
            aCoder.encode(mandatoryPictureInVisit, forKey: "MandatoryPictureInVisit")
        }
        if mandatoryTrialSuccessfulStatusForOrderInLead != nil{
            aCoder.encode(mandatoryTrialSuccessfulStatusForOrderInLead, forKey: "MandatoryTrialSuccessfulStatusForOrderInLead")
        }
        if mandatoryVisitReport != nil{
            aCoder.encode(mandatoryVisitReport, forKey: "MandatoryVisitReport")
        }
        if maxOrderQty != nil{
            aCoder.encode(maxOrderQty, forKey: "MaxOrderQty")
        }
        if maximumVisitConfiguration != nil{
            aCoder.encode(maximumVisitConfiguration, forKey: "MaximumVisitConfiguration")
        }
        if modeOfPayReferenceRequiredInCollection != nil{
            aCoder.encode(modeOfPayReferenceRequiredInCollection, forKey: "ModeOfPayReferenceRequiredInCollection")
        }
        if monthInInvoiceOrderSuggestQty != nil{
            aCoder.encode(monthInInvoiceOrderSuggestQty, forKey: "MonthInInvoiceOrderSuggestQty")
        }
        if negotiationTextInLead != nil{
            aCoder.encode(negotiationTextInLead, forKey: "NegotiationTextInLead")
        }
        if oTPConfirmationAtPromotion != nil{
            aCoder.encode(oTPConfirmationAtPromotion, forKey: "OTPConfirmationAtPromotion")
        }
        if pANNumber != nil{
            aCoder.encode(pANNumber, forKey: "PANNumber")
        }
        if perHourTravelInKM != nil{
            aCoder.encode(perHourTravelInKM, forKey: "PerHourTravelInKM")
        }
        if plusMenuInVisitDetail != nil{
            aCoder.encode(plusMenuInVisitDetail, forKey: "PlusMenuInVisitDetail")
        }
        if priceEditable != nil{
            aCoder.encode(priceEditable, forKey: "PriceEditable")
        }
        if priceEditableDistributorPOSTrade != nil{
            aCoder.encode(priceEditableDistributorPOSTrade, forKey: "PriceEditableDistributorPOSTrade")
        }
        if priceEditableRetailerPOSTrade != nil{
            aCoder.encode(priceEditableRetailerPOSTrade, forKey: "PriceEditableRetailerPOSTrade")
        }
        if productInterestedInUnplannedVisit != nil{
            aCoder.encode(productInterestedInUnplannedVisit, forKey: "ProductInterestedInUnplannedVisit")
        }
        if productMandatoryInLead != nil{
            aCoder.encode(productMandatoryInLead, forKey: "ProductMandatoryInLead")
        }
        if productSelectionTypeInSTrade != nil{
            aCoder.encode(productSelectionTypeInSTrade, forKey: "ProductSelectionTypeInSTrade")
        }
        if proposalConditions != nil{
            aCoder.encode(proposalConditions, forKey: "ProposalConditions")
        }
        if proposalFormat != nil{
            aCoder.encode(proposalFormat, forKey: "ProposalFormat")
        }
        if proposalProductPermission != nil{
            aCoder.encode(proposalProductPermission, forKey: "ProposalProductPermission")
        }
        if proposalSubTextInLead != nil{
            aCoder.encode(proposalSubTextInLead, forKey: "ProposalSubTextInLead")
        }
        if proposalTemplateID != nil{
            aCoder.encode(proposalTemplateID, forKey: "ProposalTemplateID")
        }
        if proposalTerms != nil{
            aCoder.encode(proposalTerms, forKey: "ProposalTerms")
        }
        if purchaseOrderConditions != nil{
            aCoder.encode(purchaseOrderConditions, forKey: "PurchaseOrderConditions")
        }
        if purchaseOrderFormat != nil{
            aCoder.encode(purchaseOrderFormat, forKey: "PurchaseOrderFormat")
        }
        if purchaseOrderTemplateID != nil{
            aCoder.encode(purchaseOrderTemplateID, forKey: "PurchaseOrderTemplateID")
        }
        if purchaseOrderTerms != nil{
            aCoder.encode(purchaseOrderTerms, forKey: "PurchaseOrderTerms")
        }
        if requireAddNewCustomerInVisitLeadOrder != nil{
            aCoder.encode(requireAddNewCustomerInVisitLeadOrder, forKey: "RequireAddNewCustomerInVisitLeadOrder")
        }
        if requireCustCodeInCustomer != nil{
            aCoder.encode(requireCustCodeInCustomer, forKey: "RequireCustCodeInCustomer")
        }
        if requireCustomerTypeInUnplannedVisit != nil{
            aCoder.encode(requireCustomerTypeInUnplannedVisit, forKey: "RequireCustomerTypeInUnplannedVisit")
        }
        if requireDeliveryDaysAndTnCInSO != nil{
            aCoder.encode(requireDeliveryDaysAndTnCInSO, forKey: "RequireDeliveryDaysAndTnCInSO")
        }
        if requireDiscountAndTaxAmountInSO != nil{
            aCoder.encode(requireDiscountAndTaxAmountInSO, forKey: "RequireDiscountAndTaxAmountInSO")
        }
        if requireKeyCustInCustomer != nil{
            aCoder.encode(requireKeyCustInCustomer, forKey: "RequireKeyCustInCustomer")
        }
        if requirePromotionInSO != nil{
            aCoder.encode(requirePromotionInSO, forKey: "RequirePromotionInSO")
        }
        if requireSOFromVisitBeforeCheckOut != nil{
            aCoder.encode(requireSOFromVisitBeforeCheckOut, forKey: "RequireSOFromVisitBeforeCheckOut")
        }
        if requireTaxInCustomer != nil{
            aCoder.encode(requireTaxInCustomer, forKey: "RequireTaxInCustomer")
        }
        if requireTempCustomerProfile != nil{
            aCoder.encode(requireTempCustomerProfile, forKey: "RequireTempCustomerProfile")
        }
        if requireTownInCustomer != nil{
            aCoder.encode(requireTownInCustomer, forKey: "RequireTownInCustomer")
        }
        if requireVisitCollection != nil{
            aCoder.encode(requireVisitCollection, forKey: "RequireVisitCollection")
        }
        if requireVisitCounterShare != nil{
            aCoder.encode(requireVisitCounterShare, forKey: "RequireVisitCounterShare")
        }
        if sGSTSurcharges != nil{
            aCoder.encode(sGSTSurcharges, forKey: "SGSTSurcharges")
        }
        if sGSTTax != nil{
            aCoder.encode(sGSTTax, forKey: "SGSTTax")
        }
        if sMSInVisitCheckIn != nil{
            aCoder.encode(sMSInVisitCheckIn, forKey: "SMSInVisitCheckIn")
        }
        if sORequireWarrantyAndDealerCode != nil{
            aCoder.encode(sORequireWarrantyAndDealerCode, forKey: "SORequireWarrantyAndDealerCode")
        }
        if salesExecutiveApplyManualAttendance != nil{
            aCoder.encode(salesExecutiveApplyManualAttendance, forKey: "SalesExecutiveApplyManualAttendance")
        }
        if salesExecutiveApproveCheckInCheckOutUpdate != nil{
            aCoder.encode(salesExecutiveApproveCheckInCheckOutUpdate, forKey: "SalesExecutiveApproveCheckInCheckOutUpdate")
        }
        if salesExecutiveApproveCustomerVendorTravelCheckInCheckOut != nil{
            aCoder.encode(salesExecutiveApproveCustomerVendorTravelCheckInCheckOut, forKey: "SalesExecutiveApproveCustomerVendorTravelCheckInCheckOut")
        }
        if salesExecutiveApproveLeave != nil{
            aCoder.encode(salesExecutiveApproveLeave, forKey: "SalesExecutiveApproveLeave")
        }
        if salesExecutiveApproveManualAttendance != nil{
            aCoder.encode(salesExecutiveApproveManualAttendance, forKey: "SalesExecutiveApproveManualAttendance")
        }
        if salesExecutiveCreateInvoice != nil{
            aCoder.encode(salesExecutiveCreateInvoice, forKey: "SalesExecutiveCreateInvoice")
        }
        if salesExecutivePaymentReceivedApproval != nil{
            aCoder.encode(salesExecutivePaymentReceivedApproval, forKey: "SalesExecutivePaymentReceivedApproval")
        }
        if salesExecutiveSelfAssignLead != nil{
            aCoder.encode(salesExecutiveSelfAssignLead, forKey: "SalesExecutiveSelfAssignLead")
        }
        if salesExecutiveShowTracking != nil{
            aCoder.encode(salesExecutiveShowTracking, forKey: "SalesExecutiveShowTracking")
        }
        if salesExecutiveTrackSalesRepresentative != nil{
            aCoder.encode(salesExecutiveTrackSalesRepresentative, forKey: "SalesExecutiveTrackSalesRepresentative")
        }
        if salesExecutiveWorkingHoursTracking != nil{
            aCoder.encode(salesExecutiveWorkingHoursTracking, forKey: "SalesExecutiveWorkingHoursTracking")
        }
        if salesOrderConditions != nil{
            aCoder.encode(salesOrderConditions, forKey: "SalesOrderConditions")
        }
        if salesOrderFormat != nil{
            aCoder.encode(salesOrderFormat, forKey: "SalesOrderFormat")
        }
        if salesOrderFulfillmentFrom != nil{
            aCoder.encode(salesOrderFulfillmentFrom, forKey: "SalesOrderFulfillmentFrom")
        }
        if salesOrderProductPermission != nil{
            aCoder.encode(salesOrderProductPermission, forKey: "SalesOrderProductPermission")
        }
        if salesOrderReportPermission != nil{
            aCoder.encode(salesOrderReportPermission, forKey: "SalesOrderReportPermission")
        }
        if salesOrderTemplateID != nil{
            aCoder.encode(salesOrderTemplateID, forKey: "SalesOrderTemplateID")
        }
        if salesOrderTerms != nil{
            aCoder.encode(salesOrderTerms, forKey: "SalesOrderTerms")
        }
        if salesRepresantativeApplyManualAttendance != nil{
            aCoder.encode(salesRepresantativeApplyManualAttendance, forKey: "SalesRepresantativeApplyManualAttendance")
        }
        if salesRepresentativeShowTracking != nil{
            aCoder.encode(salesRepresentativeShowTracking, forKey: "SalesRepresentativeShowTracking")
        }
        if salesRepresentativeWorkingHoursTracking != nil{
            aCoder.encode(salesRepresentativeWorkingHoursTracking, forKey: "SalesRepresentativeWorkingHoursTracking")
        }
        if sendNotnInSOMaxDiscount != nil{
            aCoder.encode(sendNotnInSOMaxDiscount, forKey: "SendNotnInSOMaxDiscount")
        }
        if serviceSurcharges != nil{
            aCoder.encode(serviceSurcharges, forKey: "ServiceSurcharges")
        }
        if serviceTax != nil{
            aCoder.encode(serviceTax, forKey: "ServiceTax")
        }
        if serviceTaxNumber != nil{
            aCoder.encode(serviceTaxNumber, forKey: "ServiceTaxNumber")
        }
        if shelfSpaceUnit != nil{
            aCoder.encode(shelfSpaceUnit, forKey: "ShelfSpaceUnit")
        }
        if showActionCloseOrderInLead != nil{
            aCoder.encode(showActionCloseOrderInLead, forKey: "ShowActionCloseOrderInLead")
        }
        if showAdditionalReminderInLead != nil{
            aCoder.encode(showAdditionalReminderInLead, forKey: "ShowAdditionalReminderInLead")
        }
        if showKPIOnSplashScreen != nil{
            aCoder.encode(showKPIOnSplashScreen, forKey: "ShowKPIOnSplashScreen")
        }
        if showLeadQualifiedInLead != nil{
            aCoder.encode(showLeadQualifiedInLead, forKey: "ShowLeadQualifiedInLead")
        }
        if showNegotiationInLead != nil{
            aCoder.encode(showNegotiationInLead, forKey: "ShowNegotiationInLead")
        }
        if showOurChancesInLead != nil{
            aCoder.encode(showOurChancesInLead, forKey: "ShowOurChancesInLead")
        }
        if showProductDrive != nil{
            aCoder.encode(showProductDrive, forKey: "ShowProductDrive")
        }
        if showProposalSubInLead != nil{
            aCoder.encode(showProposalSubInLead, forKey: "ShowProposalSubInLead")
        }
        if showShelfSpace != nil{
            aCoder.encode(showShelfSpace, forKey: "ShowShelfSpace")
        }
        if showSuggestOrderQty != nil{
            aCoder.encode(showSuggestOrderQty, forKey: "ShowSuggestOrderQty")
        }
        if showTrialDoneInLead != nil{
            aCoder.encode(showTrialDoneInLead, forKey: "ShowTrialDoneInLead")
        }
        if startTime != nil{
            aCoder.encode(startTime, forKey: "StartTime")
        }
        if stockUpdateInOrder != nil{
            aCoder.encode(stockUpdateInOrder, forKey: "StockUpdateInOrder")
        }
        if storeCheckCompetition != nil{
            aCoder.encode(storeCheckCompetition, forKey: "StoreCheckCompetition")
        }
        if storeCheckOwnBrand != nil{
            aCoder.encode(storeCheckOwnBrand, forKey: "StoreCheckOwnBrand")
        }
        if suggestOrderQtyCalculation != nil{
            aCoder.encode(suggestOrderQtyCalculation, forKey: "SuggestOrderQtyCalculation")
        }
        if territoryInCustomer != nil{
            aCoder.encode(territoryInCustomer, forKey: "TerritoryInCustomer")
        }
        if territoryMandatoryInBeatPlan != nil{
            aCoder.encode(territoryMandatoryInBeatPlan, forKey: "TerritoryMandatoryInBeatPlan")
        }
        if totalCharsInFirstSlab != nil{
            aCoder.encode(totalCharsInFirstSlab, forKey: "TotalCharsInFirstSlab")
        }
        if totalCharsInSrNo != nil{
            aCoder.encode(totalCharsInSrNo, forKey: "TotalCharsInSrNo")
        }
        if travelCheckInExecutiveApproval != nil{
            aCoder.encode(travelCheckInExecutiveApproval, forKey: "TravelCheckInExecutiveApproval")
        }
        if travelCheckInManagerApproval != nil{
            aCoder.encode(travelCheckInManagerApproval, forKey: "TravelCheckInManagerApproval")
        }
        if trialDoneTextInLead != nil{
            aCoder.encode(trialDoneTextInLead, forKey: "TrialDoneTextInLead")
        }
        if vATAdditionalTax != nil{
            aCoder.encode(vATAdditionalTax, forKey: "VATAdditionalTax")
        }
        if vATSurcharges != nil{
            aCoder.encode(vATSurcharges, forKey: "VATSurcharges")
        }
        if vATTax != nil{
            aCoder.encode(vATTax, forKey: "VATTax")
        }
        if vATTaxNumber != nil{
            aCoder.encode(vATTaxNumber, forKey: "VATTaxNumber")
        }
        if vatCodeFrom != nil{
            aCoder.encode(vatCodeFrom, forKey: "VatCodeFrom")
        }
        if vatGst != nil{
            aCoder.encode(vatGst, forKey: "VatGst")
        }
        if viewCompanyStock != nil{
            aCoder.encode(viewCompanyStock, forKey: "ViewCompanyStock")
        }
        if visitCheckInApproval != nil{
            aCoder.encode(visitCheckInApproval, forKey: "VisitCheckInApproval")
        }
        if visitCheckInCheckoutDiff != nil{
            aCoder.encode(visitCheckInCheckoutDiff, forKey: "VisitCheckInCheckoutDiff")
        }
        if visitManualCheckInApproval != nil{
            aCoder.encode(visitManualCheckInApproval, forKey: "VisitManualCheckInApproval")
        }
        if visitMenuOnHomeScreen != nil{
            aCoder.encode(visitMenuOnHomeScreen, forKey: "VisitMenuOnHomeScreen")
        }
        if visitModule != nil{
            aCoder.encode(visitModule, forKey: "VisitModule")
        }
        if visitProductPermission != nil{
            aCoder.encode(visitProductPermission, forKey: "VisitProductPermission")
        }
        if visitReminder != nil{
            aCoder.encode(visitReminder, forKey: "VisitReminder")
        }
        if visitReminderFirst != nil{
            aCoder.encode(visitReminderFirst, forKey: "VisitReminderFirst")
        }
        if visitReminderMissed != nil{
            aCoder.encode(visitReminderMissed, forKey: "VisitReminderMissed")
        }
        if visitReminderSecond != nil{
            aCoder.encode(visitReminderSecond, forKey: "VisitReminderSecond")
        }
        if visitStepsRequired != nil{
            aCoder.encode(visitStepsRequired, forKey: "VisitStepsRequired")
        }
        if salesOrderLoadPage != nil{
            aCoder.encode(salesOrderLoadPage, forKey: "SalesOrderLoadPage")
        }

    }*/
    
}
