//
//  Leadselection.swift
//  SuperSales
//
//  Created by Apple on 25/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit

class Leadselection: BaseViewController {
    
    @IBOutlet weak var lblSelectionTitle: UILabel!
    var selectionFor =  SelectionOf.lead
    var tap:UITapGestureRecognizer!
    var leadType:[[String:Any]]!
    var visitType:[[String:Any]]!
    var arrVisitType:[CompanyMenus]!
//    var arrLeftVisitType:[[String:Any]]!
//    var arrRightVisitType:[[String:Any]]!
    @IBOutlet var collectionLeadSelection: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if(selectionFor == SelectionOf.lead){}else{
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.btnback?.image = UIImage.init(named: "icon_arrow_left")
        self.btnback?.tintColor = UIColor.gray
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        if(selectionFor == SelectionOf.lead){}else{
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0/255.0, green: 144/255.0, blue: 247/255.0, alpha: 1.0)
        self.btnback?.image = UIImage.init(named: "icon_arrow_back")
        self.btnback?.tintColor = UIColor.white
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let activeaccount = Utils().getActiveAccount()
        self.setleftbtn(btnType: BtnLeft.back,navigationItem: self.navigationItem)
        collectionLeadSelection.delegate = self
        collectionLeadSelection.dataSource = self
        
        if(selectionFor == SelectionOf.lead){
        self.title = "Add Lead"
         lblSelectionTitle.textColor = UIColor.black
         lblSelectionTitle.text = "Select Lead Type"
         lblSelectionTitle.font = UIFont.boldSystemFont(ofSize: 22)//UIFont.systemFont(ofSize: 22)
        //set value
        leadType = [[String:Any]]()//icon_lead_cold
        leadType.append(["title":"Hot","img": UIImage.init(named: "icon_lead_hot") ?? UIImage(),"menuID":0])
       
        leadType.append(["title":"Warm" as String,"img":UIImage.init(named: "icon_lead_warm") ?? UIImage(),"menuID":1])
            
        leadType.append(["title":"Cold" as String,"img":UIImage.init(named: "icon_lead_cold")  ?? UIImage(),"menuID":2])
         
        }
        else{
            self.title = "Add Visit"
            lblSelectionTitle.textColor = UIColor.lightGray
            lblSelectionTitle.text = "Select Visit Type"
            lblSelectionTitle.font = UIFont.systemFont(ofSize: 22)
            arrVisitType = Utils.getVisitOptionMenu(roleId:activeaccount?.role?.id ?? 0)
            visitType = [[String:Any]]()
//            arrLeftVisitType = [[String:Any]]()
//            arrRightVisitType = [[String:Any]]()
            for visittype in arrVisitType{
                
                switch visittype.menuID{
                case 28:
                    visitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_planvisit") ?? UIImage(),"menuID":visittype.menuID])
            //    arrLeftVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_planvisit") ?? UIImage()])
                break
                    
                case 29:
                visitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_coldcall") ?? UIImage(),"menuID":visittype.menuID])
            //    arrRightVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_coldcall") ?? UIImage()])
                break
                    
                case 30:
                visitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_unplannedvisit") ?? UIImage(),"menuID":visittype.menuID])
         //           arrLeftVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_unplannedvisit") ?? UIImage()])
                break
                    
                case 31:
                visitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_corporate") ?? UIImage(),"menuID":visittype.menuID])
         //           arrRightVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_corporate") ?? UIImage()])
                break
                    
                case 32:
                visitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_manual") ?? UIImage(),"menuID":visittype.menuID])
          //          arrLeftVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_manual") ?? UIImage()])
                break
                    
                case 33:
                visitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_beatplan") ?? UIImage(),"menuID":visittype.menuID])
             //       arrRightVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_beatplan") ?? UIImage()])
                break
                    
                case 34:
                visitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_planvisit") ?? UIImage(),"menuID":visittype.menuID])
            //    arrLeftVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_planvisit") ?? UIImage()])
                break
                    
                default:
                    print("nothing")
                }
            }
            
            
//            arrVisitType.sort { (c1, c2) -> Bool in
//                c1.menuID > c2.menuID
//            }
//            for i in 0...arrVisitType.count-1{
//                let
//                print(arrVisitType[i].menuValue)
//                if((i % 2) == 0){
//                    arrLeftVisitType.append(visitType[i])
//                }else{
//                    arrRightVisitType.append(visitType[i])
//                }
//            }
            collectionLeadSelection.reloadData()
        }
        // Do any additional setup after loading the viewwarm.
        
//   let tap1 = UITapGestureRecognizer(target: self, action:  #selector(wasTapped(sender:)))
//        tap1.numberOfTapsRequired = 1 // Default value
//        view.isUserInteractionEnabled = true
//        view.addGestureRecognizer(tap1)
    }
    


}
extension Leadselection :UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(selectionFor ==  SelectionOf.lead){
        return leadType.count
        }else{
            return visitType.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "leadType", for: indexPath) as? LeadTypeCell ?? LeadTypeCell()
        cell.titleLeadType.setMultilineLabel(lbl: cell.titleLeadType)
        var leadTypeobject:[String:Any]
        if(selectionFor ==  SelectionOf.lead){
        leadTypeobject = (leadType?[indexPath.row])!
        }else{
//            if(indexPath.row < arrLeftVisitType.count){
//                leadTypeobject = arrLeftVisitType[indexPath.row]
//            }else{
//
//                leadTypeobject =  arrRightVisitType[indexPath.row - arrLeftVisitType.count]
//            }
           leadTypeobject = visitType[indexPath.row]
          
        }
       
        cell.titleLeadType.textAlignment = .center
        cell.imgLeadType.image = (leadTypeobject["img"] as? UIImage ?? UIImage())
       cell.titleLeadType.text = (leadTypeobject["title"] as? String ?? "" )
 //       cell.titleLeadType.text = "\(leadTypeobject["menuID"] ?? 0)"//(String(leadTypeobject["menuID"]) as? String)
        

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    
    if(selectionFor ==  SelectionOf.lead){
        Common.skipVisitSelection = true
        if let viewAddLead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.AddLead) as? AddLead{
        AddLead.isEditLead = false
        if(indexPath.row == 0){
        viewAddLead.leadtype = LeadType.hot
            }else if(indexPath.row == 1){
        viewAddLead.leadtype = LeadType.warm
            }else{
        viewAddLead.leadtype = LeadType.cold
            }
//    self.navigationController?.popViewController(animated: true)
    self.navigationController!.pushViewController(viewAddLead, animated: true)
        }
//        self.dismiss(animated: false) {
//             self.parent?.navigationController!.pushViewController(viewAddLead, animated: true)
//        }
    
    }else{
    let selectedCompanyMenu = arrVisitType[indexPath.row]
    print(selectedCompanyMenu.menuID)
    switch selectedCompanyMenu.menuID {
           
    case 28:
        if let addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddplanVisitView) as? AddPlanVisit{
//    self.dismiss(animated: false) {
        self.navigationController!.pushViewController(addplanvisit, animated: true)
        }
   // }
   break
                
    case 29:
        if let addunplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddUnplanVisitView) as? AddUnPlanVisit{
//    self.dismiss(animated: false) {
        self.navigationController!.pushViewController(addunplanvisit, animated: true)
        }
 //   }
    break
                
    case 30:
    //direct visit checkin
        if let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView)  as? AddJoinVisitViewController{
            Common.skipVisitSelection = false
            
        addjointvisit.visitType = VisitType.directvisitcheckin
//        self.dismiss(animated: false) {
//            self.parent?.navigationController!.pushViewController(addjointvisit, animated: true)
//        }
     //   self.navigationController?.popViewController(animated: true)
        self.navigationController!.pushViewController(addjointvisit, animated: true)
        }
 
    break
                
    case 31:
                //corporate visit
//    let addcorporatevisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView)        as! AddJoinVisitViewController
//
//    addcorporatevisit.visitType = VisitType.joinvisit
// //   self.navigationController?.popViewController(animated: true)
//    self.navigationController!.pushViewController(addcorporatevisit, animated: true)
//    self.dismiss(animated: false) {
//        self.parent?.navigationController!.pushViewController(addcorporatevisit, animated: true)
//    }
    
    break
                
    case 32:
                //manual visit
        if let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView)  as? AddJoinVisitViewController{
            Common.skipVisitSelection = false

   addjointvisit.visitType = VisitType.manualvisit
//    self.dismiss(animated: false) {
        self.navigationController!.pushViewController(addjointvisit, animated: true)
        }
    //}

                break
    case 33:
    //beat plan
        if   let beatplancontainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanConatinerview) as? BeatPlanContainerView{
        self.navigationController!.pushViewController(beatplancontainer, animated: true)
        }
    break
        
    case 34:
        //Joint visit
        if  let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView) as?  AddJoinVisitViewController{
        
        addjointvisit.visitType = VisitType.joinvisit
        //    self.dismiss(animated: false) {
        self.navigationController!.pushViewController(addjointvisit, animated: true)
        }
    default:
    print("")
            }
        
            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
         print("did deselect")
    }
    
    
    
}

extension Leadselection:UICollectionViewDelegateFlowLayout{
    //Use for size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: ((collectionView.frame.width - 30)/2), height: ((collectionView.frame.width - 30)/2))
        //(collectionView.frame.width - 100)/2
    }
    //Use for interspacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}


