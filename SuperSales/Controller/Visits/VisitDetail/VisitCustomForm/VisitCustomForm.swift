//
//  File.swift
//  SuperSales
//
//  Created by ebsadmin on 26/02/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import Foundation
import SVProgressHUD
import CarbonKit
import IQKeyboardManagerSwift

class VisitCustomForm: BaseViewController, CustomSearchBarDelegate {
    var visitType:VisitType!

    let setting = Utils().getActiveSetting()
    let account = Utils().getActiveAccount()
    var lstForms : [CustomForm]? {
        didSet{
            self.configureUI()
        }
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.loadCompanyStock()
    }
    
    // MARK: - APICall
    private func configureUI() {
        print("Setup UI")
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIStackView.self)
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        // Create a UIScrollView
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Create a UIStackView
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        // Set scrollView constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Set stackView constraints to the scrollView's contentLayoutGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        // Add custom views to the stackView
        let textFieldText = CustomTextFieldView(title: "Text", placeholder: "", textFieldType: .normal)
        textFieldText.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(textFieldText)

        let textFieldDate = CustomTextFieldView(title: "Date", placeholder: "", textFieldType: .date)
        textFieldDate.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(textFieldDate)
        
        let textFieldNumber = CustomTextFieldView(title: "Number", placeholder: "", textFieldType: .decimal)
        textFieldNumber.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(textFieldNumber)

        let textFieldPhone = CustomTextFieldView(title: "Phone Number", placeholder: "", textFieldType: .phone)
        textFieldPhone.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(textFieldPhone)

        let customView = CustomRadioButtonView()
        customView.setTitle("Radio Button")
        customView.addRadioButton("Yes")
        customView.addRadioButton("No")
        
        stackView.addArrangedSubview(customView)
        
        let viewAddPicture = CustomImagePickerView()
        stackView.addArrangedSubview(viewAddPicture)
        
        let checkBoxes = CheckboxGroupView(title: "Multiple check box", options: ["Option 1","Option 2","Option 3","Option 4","Option 5"])
        stackView.addArrangedSubview(checkBoxes)

        let viewSwitch = CustomSwitchView(title: "Boolean")
        stackView.addArrangedSubview(viewSwitch)
        
        let textFieldSearch = CustomTextFieldView(title: "Customer", placeholder: "", textFieldType: .search)
        textFieldSearch.delegate = self
        textFieldSearch.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(textFieldSearch)

        self.addDropDownCustomView(stackView: stackView)
    }
    
    private func addDropDownCustomView(stackView: UIStackView) {
        let customView = DropDownCustomView()
        customView.translatesAutoresizingMaskIntoConstraints = false

        let options1: [DropdownOption] = [
            DropdownOption(id: 1, value: "Option 1"),
            DropdownOption(id: 2, value: "Option 2"),
            DropdownOption(id: 3, value: "Option 3")
        ]

        let dependentOptions: [Int: [DropdownOption]] = [
            1: [
                DropdownOption(id: 1, value: "Option 1 - 1"),
                DropdownOption(id: 2, value: "Option 1 - 2"),
                DropdownOption(id: 3, value: "Option 1 - 3")
            ],
            2: [
                DropdownOption(id: 4, value: "Option 2 - 1"),
                DropdownOption(id: 5, value: "Option 2 - 2"),
                DropdownOption(id: 6, value: "Option 2 - 3")
            ],
            3: [
                DropdownOption(id: 7, value: "Option 3 - 1"),
                DropdownOption(id: 8, value: "Option 3 - 2"),
                DropdownOption(id: 9, value: "Option 3 - 3")
            ]
        ]

        customView.configure(with: options1, dependentOptions: dependentOptions, enableSecondDropDown: true)

        stackView.addArrangedSubview(customView)
    }

    
    func onSearch() {/*
        if (self.activeuser?.roleId?.intValue ?? 0 > 6 && self.activesetting.customerApproval == 1) {
            Utils.toastmsg(message:"You are not permitted to add customer, Please contact Admin for permission", view: self.view)
        } else if (self.activeuser?.roleId?.intValue ?? 0 > 6 && self.activesetting.customerApproval == 2) {
            Utils.toastmsg(message:"It require approval to add customer, Please contact Admin for permission", view: self.view)
        } else {
            if let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                addCustomer.isVendor = false
                AddCustomer.isFromInfluencer = 0
                addCustomer.isForAddAddress = false
                addCustomer.isFromColdCallVisit = false
                
                var editcustomer = CustomerDetails()
                if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory || visitType == VisitType.manualvisit){
                    addCustomer.isEditCustomer = true
                    if let editcustomer1 = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: planVisit?.customerID ?? 0) ?? NSNumber.init(value:0)) as? CustomerDetails{
                        editcustomer = editcustomer1
                        addCustomer.isFromColdCallVisit = false
                        addCustomer.selectedCustomer = editcustomer
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(addCustomer, animated: true)
                        }
                    }else{
                        Utils.toastmsg(message:"Customer is not mapped So you can't edit",view:self.view)
                    }
                    
                }else{
                    //editcustomer = unplanVisit.tempCustomerObj
                    if let cust = CustomerDetails.getCustomerByID(cid: unplanVisit?.tempCustomerID ?? 0) as? CustomerDetails{
                        addCustomer.isEditCustomer = true
                        addCustomer.isFromColdCallVisit = true
                        
                        editcustomer = cust
                        if let tempcustomer = unplanVisit?.tempCustomerObj{
                            addCustomer.selectedCustomerForUnplan = tempcustomer
                        }
                    }else{
                        addCustomer.isEditCustomer = false
                        if let tempcustomer = unplanVisit?.tempCustomerObj{
                            addCustomer.selectedCustomerForUnplan = tempcustomer
                        }
                    }
                    if let tempcustomer = unplanVisit?.tempCustomerObj{
                        
                        addCustomer.selectedCustomerForUnplan = tempcustomer
                        
                    }
                    addCustomer.origiAssigneeFromCCVisit = unplanVisit?.originalAssignee
                    addCustomer.isFromColdCallVisit = true
                    addCustomer.selectedCustomer = editcustomer
                    self.navigationController?.pushViewController(addCustomer, animated: true)
                }
            }
        }*/
    }
    
    // MARK: - APICall
    func loadCompanyStock(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        
        var maindict = [String: Any]()
        maindict["UserID"] = account?.userID
        maindict["CompanyID"] = account?.company?.iD

        print(maindict)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        RestAPIManager.httpRequest(ConstantURL.getVisitCustomForm, .get,parameters: maindict, isTeamWorkUrl: true, isFull: true) { (response, success, error) in
            SVProgressHUD.dismiss()
            if error != nil {
                self.view.window?.makeToast(error?.localizedDescription)
            }else if let resOrder = response as? [String: Any] {
                do {
                    let encoded = try JSONSerialization.data(withJSONObject: resOrder, options: .prettyPrinted)
                    if let decoded = try? JSONDecoder().decode(VisitCustomFormJson.self, from: encoded) {
                        self.lstForms = decoded.data
                    }
                } catch {
                    print(error.localizedDescription)
                }
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
}
