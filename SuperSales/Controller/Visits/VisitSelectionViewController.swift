//
//  VisitSelectionViewController.swift
//  SuperSales
//
//  Created by Apple on 03/02/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

class VisitSelectionViewController: BaseViewController {
    //MARK: - IBOutlet
    
    @IBOutlet weak var collectionViewVisitSelection: UICollectionView!
    
   /* @IBOutlet weak var vwPlanVisit: UIView!
    
    @IBOutlet weak var imgPlanVisit: UIImageView!
    
    @IBOutlet weak var lblPlanVisit: UILabel!
    
    @IBOutlet weak var vwColdCallVisit: UIView!
    
    
    @IBOutlet weak var imgColdCallVisit: UIImageView!
    
    
    @IBOutlet weak var lblColdCallVisit: UILabel!
    
    @IBOutlet weak var vwDirectCheckinVisit: UIView!
    
    @IBOutlet weak var imgDirectCheckinVisit: UIImageView!
    
    @IBOutlet weak var lblDirectCheckinVisit: UILabel!
    
    
    @IBOutlet weak var vwManualVisit: UIView!
    
    @IBOutlet weak var imgManualVisit: UIImageView!
    
    @IBOutlet weak var lblManualVisit: UILabel!
    
    @IBOutlet weak var vwBeatPlanVisit: UIView!
    @IBOutlet weak var imgBeatPlanVisit: UIImageView!
    
    @IBOutlet weak var lblBeatPlanVisit: UILabel!
    
    @IBOutlet weak var vwJoinVisit: UIView!
    
    @IBOutlet weak var imgJoinVisit: UIImageView!
    
    @IBOutlet weak var lblJoinVisit: UILabel!*/
    
    //MARK: - variables
    
    var visitType:[[String:Any]]!
    
    var arrVisitType:[CompanyMenus]!
    
    //MARK: - View Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.btnback?.image = UIImage.init(named: "icon_arrow_left")
        self.btnback?.tintColor = UIColor.gray
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)

        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0/255.0, green: 144/255.0, blue: 247/255.0, alpha: 1.0)
        self.btnback?.image = UIImage.init(named: "icon_arrow_back")
        self.btnback?.tintColor = UIColor.white
    }

    //MARK: - method
    func setUI(){
       
        self.setleftbtn(btnType: BtnLeft.back,navigationItem: self.navigationItem)
       
        self.title = ""
        let activeaccount = Utils().getActiveAccount()
        arrVisitType = Utils.getVisitOptionMenu(roleId:activeaccount?.role?.id ?? 0)
        visitType = [[String:Any]]()
        collectionViewVisitSelection.delegate = self
        collectionViewVisitSelection.dataSource = self
        collectionViewVisitSelection.reloadData()
        self.collectionViewVisitSelection.reloadData()
     /*   imgJoinVisit.image = nil
        lblJoinVisit.text = ""
        vwPlanVisit.isHidden = true
        vwColdCallVisit.isHidden = true
        vwJoinVisit.isHidden = true
        vwManualVisit.isHidden = true
        vwBeatPlanVisit.isHidden = true
        vwDirectCheckinVisit.isHidden = true
        
        for visittype in arrVisitType{
            print(visittype.menuID)
            switch visittype.menuID{
            case 28:
                imgPlanVisit.image = UIImage.init(named: "icon_visitselection_planvisit") ?? UIImage()
                lblPlanVisit.text = visittype.menuLocalText
                vwPlanVisit.isHidden = false
        //    arrLeftVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_planvisit") ?? UIImage()])
            break
                
            case 29:
                imgColdCallVisit.image = UIImage.init(named: "icon_visitselection_coldcall") ?? UIImage()
                lblColdCallVisit.text = visittype.menuLocalText
                vwColdCallVisit.isHidden = false
        //    arrRightVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_coldcall") ?? UIImage()])
            break
                
            case 30:
                imgDirectCheckinVisit.image = UIImage.init(named: "icon_visitselection_unplannedvisit") ?? UIImage()
                lblDirectCheckinVisit.text = visittype.menuLocalText
                vwDirectCheckinVisit.isHidden =  false
     //           arrLeftVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_unplannedvisit") ?? UIImage()])
            break
                
            case 31:
//                imgDirectCheckinVisit.image = UIImage.init(named: "icon_visitselection_unplannedvisit") ?? UIImage()
//                lblDirectCheckinVisit.text = visittype.menuLocalText
            visitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_corporate") ?? UIImage(),"menuID":visittype.menuID])
                
     //           arrRightVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_corporate") ?? UIImage()])
            break
                
            case 32:
                imgManualVisit.image = UIImage.init(named: "icon_visitselection_manual") ?? UIImage()
                lblManualVisit.text = visittype.menuLocalText
            visitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_manual") ?? UIImage(),"menuID":visittype.menuID])
                vwManualVisit.isHidden =  false
      //          arrLeftVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_manual") ?? UIImage()])
            break
                
            case 33:
                imgBeatPlanVisit.image = UIImage.init(named: "icon_visitselection_beatplan") ?? UIImage()
                lblBeatPlanVisit.text = visittype.menuLocalText
            visitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_beatplan") ?? UIImage(),"menuID":visittype.menuID])
                vwBeatPlanVisit.isHidden = false
         //       arrRightVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_beatplan") ?? UIImage()])
            break
                
            case 34:
                imgJoinVisit.image = UIImage.init(named: "icon_visitselection_planvisit") ?? UIImage()
                lblJoinVisit.text = visittype.menuLocalText
                vwJoinVisit.isHidden = false
            //visitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_planvisit") ?? UIImage(),"menuID":visittype.menuID])
        //    arrLeftVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_planvisit") ?? UIImage()])
            break
                
            default:
                print("nothing")
            }
        }
      
        let planvisitRecogniser = UITapGestureRecognizer.init(target:self, action: #selector(self.planvisitSelected))
            
            vwPlanVisit.addGestureRecognizer(planvisitRecogniser)
        let coldcallvisitRecogniser = UITapGestureRecognizer.init(target:self, action: #selector(self.coldcallvisitSelected))
            
            vwColdCallVisit.addGestureRecognizer(coldcallvisitRecogniser)
        let beatplanvisitRecogniser = UITapGestureRecognizer.init(target:self, action: #selector(self.beatplanvisitSelected))
            
        vwBeatPlanVisit.addGestureRecognizer(beatplanvisitRecogniser)
        let directcheckinvisitRecogniser = UITapGestureRecognizer.init(target:self, action: #selector(self.directcheckinvisitSelected))
            
        vwDirectCheckinVisit.addGestureRecognizer(directcheckinvisitRecogniser)
        let manualvisitRecogniser = UITapGestureRecognizer.init(target:self, action: #selector(self.manualvisitSelected))
            
        vwManualVisit.addGestureRecognizer(manualvisitRecogniser)
        let jointvisitRecogniser = UITapGestureRecognizer.init(target:self, action: #selector(self.jointvisitSelected))
            
        vwJoinVisit.addGestureRecognizer(jointvisitRecogniser)*/
    }
    @objc func planvisitSelected(){
        if let addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddplanVisitView) as? AddPlanVisit{
            Common.skipVisitSelection = true
//    self.dismiss(animated: false) {
        self.navigationController!.pushViewController(addplanvisit, animated: true)
        }
    }
    @objc func coldcallvisitSelected(){
        if let addunplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddUnplanVisitView) as? AddUnPlanVisit{
            Common.skipVisitSelection = true
//    self.dismiss(animated: false) {
        self.navigationController!.pushViewController(addunplanvisit, animated: true)
        }
    }
    @objc func beatplanvisitSelected(){
        if   let beatplancontainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanConatinerview) as? BeatPlanContainerView{
            Common.skipVisitSelection = true
        self.navigationController!.pushViewController(beatplancontainer, animated: true)
        }
    }
    @objc func directcheckinvisitSelected(){
        if let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView)  as? AddJoinVisitViewController{
            Common.skipVisitSelection = false
           
        addjointvisit.visitType = VisitType.directvisitcheckin
//        self.dismiss(animated: false) {
//            self.parent?.navigationController!.pushViewController(addjointvisit, animated: true)
//        }
     //   self.navigationController?.popViewController(animated: true)
        self.navigationController!.pushViewController(addjointvisit, animated: true)
        }
    }
    @objc func manualvisitSelected(){
        if let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView)  as? AddJoinVisitViewController{
            Common.skipVisitSelection = false
           
   addjointvisit.visitType = VisitType.manualvisit
//    self.dismiss(animated: false) {
        self.navigationController!.pushViewController(addjointvisit, animated: true)
        }
    }
    @objc func jointvisitSelected(){
        var arrmenuID = [Int]()
         arrmenuID = arrVisitType.map{
            Int($0.menuID)
        }
        if(arrmenuID.contains(34)){
        if  let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView) as?  AddJoinVisitViewController{
            Common.skipVisitSelection = true
        addjointvisit.visitType = VisitType.joinvisit
        //    self.dismiss(animated: false) {
        self.navigationController!.pushViewController(addjointvisit, animated: true)
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
extension VisitSelectionViewController :UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count of visit type = \(arrVisitType.count)")
      //  collectionView.layoutGuides.item
      //  [self.myCollectionViewFlowLayout setItemSize:CGSizeMake(320, 320)];
        return arrVisitType.count
        
    }
    //override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("came in cell for method")
//        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "visitselectioncell", for: indexPath) as? VisitSelection ?? VisitSelection()
//        return cell
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "visitselectioncell", for: indexPath) as? VisitSelection{
//            cell.contentView.backgroundColor = UIColor.red
//        return cell
//        }else{
//            print("not get cell")
//            return UICollectionViewCell()
//        }
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "visitselectioncell", for: indexPath) as? VisitSelection{
//            let visittype = arrVisitType[indexPath.row]
//            cell.lblVisitTypeName.text = visittype.menuLocalText
//
////            if(visittype.menuID == 28){
////
////                cell.imgVisitType.image  = UIImage.init(named: "icon_visitselection_planvisit") ?? UIImage()
////            }
//            switch visittype.menuID{
//            case 28:
//                cell.imgVisitType.image  = UIImage.init(named: "icon_visitselection_planvisit") ?? UIImage()
//
//        //    arrLeftVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_planvisit") ?? UIImage()])
//            break
//
//            case 29:
//                cell.imgVisitType.image  = UIImage.init(named: "icon_visitselection_coldcall") ?? UIImage()
//
//        //    arrRightVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_coldcall") ?? UIImage()])
//            break
//
//            case 30:
//                cell.imgVisitType.image  = UIImage.init(named: "icon_visitselection_unplannedvisit") ?? UIImage()
//
//     //           arrLeftVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_unplannedvisit") ?? UIImage()])
//            break
//
//            case 31:
////                imgDirectCheckinVisit.image = UIImage.init(named: "icon_visitselection_unplannedvisit") ?? UIImage()
////                lblDirectCheckinVisit.text = visittype.menuLocalText
//            visitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_corporate") ?? UIImage(),"menuID":visittype.menuID])
//
//     //           arrRightVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_corporate") ?? UIImage()])
//            break
//
//            case 32:
//                cell.imgVisitType.image  = UIImage.init(named: "icon_visitselection_manual") ?? UIImage()
//
//            visitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_manual") ?? UIImage(),"menuID":visittype.menuID])
//
//      //          arrLeftVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_manual") ?? UIImage()])
//            break
//
//            case 33:
//                cell.imgVisitType.image  = UIImage.init(named: "icon_visitselection_beatplan") ?? UIImage()
//
//            visitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_beatplan") ?? UIImage(),"menuID":visittype.menuID])
//
//         //       arrRightVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_beatplan") ?? UIImage()])
//            break
//
//            case 34:
//                cell.imgVisitType.image  = UIImage.init(named: "icon_visitselection_planvisit") ?? UIImage()
//
//
//            //visitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_planvisit") ?? UIImage(),"menuID":visittype.menuID])
//        //    arrLeftVisitType.append(["title":visittype.menuLocalText,"img": UIImage.init(named: "icon_visitselection_planvisit") ?? UIImage()])
//            break
//
//            default:
//                print("nothing")
//            }
//
//
//            return cell
//        }else{
//        return UICollectionViewCell()
//        }
       
            
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "leadType", for: indexPath) as? LeadTypeCell ?? LeadTypeCell()
            cell.titleLeadType.setMultilineLabel(lbl: cell.titleLeadType)
            var leadTypeobject:[String:Any]
//            if(selectionFor ==  SelectionOf.lead){
//            leadTypeobject = (leadType?[indexPath.row])!
//            }else{
    //            if(indexPath.row < arrLeftVisitType.count){
    //                leadTypeobject = arrLeftVisitType[indexPath.row]
    //            }else{
    //
    //                leadTypeobject =  arrRightVisitType[indexPath.row - arrLeftVisitType.count]
    //            }
               leadTypeobject = visitType[indexPath.row]
               
          //  }
           
            cell.titleLeadType.textAlignment = .center
            cell.imgLeadType.image = (leadTypeobject["img"] as? UIImage ?? UIImage())
           cell.titleLeadType.text = (leadTypeobject["title"] as? String ?? "" )
     //       cell.titleLeadType.text = "\(leadTypeobject["menuID"] ?? 0)"//(String(leadTypeobject["menuID"]) as? String)
            

            return cell
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
//        if(selectionFor ==  SelectionOf.lead){
//            Common.skipVisitSelection = true
//            if let viewAddLead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.AddLead) as? AddLead{
//            AddLead.isEditLead = false
//            if(indexPath.row == 0){
//            viewAddLead.leadtype = LeadType.hot
//                }else if(indexPath.row == 1){
//            viewAddLead.leadtype = LeadType.warm
//                }else{
//            viewAddLead.leadtype = LeadType.cold
//                }
//    //    self.navigationController?.popViewController(animated: true)
//        self.navigationController!.pushViewController(viewAddLead, animated: true)
//            }
    //        self.dismiss(animated: false) {
    //             self.parent?.navigationController!.pushViewController(viewAddLead, animated: true)
    //        }
        
//        }else{
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
            
       //         }
            
        }
        
        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
             print("did deselect")
        }
        
        
        
    }

    extension VisitSelection:UICollectionViewDelegateFlowLayout{
        //Use for size
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            print()
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


