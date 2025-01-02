//
//  EnumHelper.swift
//  SuperSales
//
//  Created by Apple on 26/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import Foundation

enum Alignment{
    case left
    case center
    case right
}

enum Dashboardscreen{
    case salesplan
    case dashboardvisit
    case dashboardlead
    case dashboardorder
    case salesreport
}
enum SelectionMode{
    case single
    case multiple
    case none
}
enum ProductSelectionFromView{
    case proposal
    case visit
    case stock
    case lead
    case leadupdatestatus
    case salesorder
    case potential
  
}
enum VisitType{
    case coldcallvisitHistory
    case planedvisitHistory
    case coldcallvisit
    case coldcallvisitwithdicheckin
    case planedvisit
    case corporatevisit
    case manualvisit
    case directvisitcheckin
    case beatplan
    case joinvisit
    case activityvisit
}
enum LeadType{
    case hot
    case warm
    case cold
}
enum LatestCheckinForDay{
    case checkedIn
    case checkedOut
    case none
}

enum ViewFor{
    case firstInfluencer
    case secondInfluencer
    case customer
    case companyuser
    case product
    case visitoutcome
    case leadoutcome
    case productcategory
    case productsubcategory
    case customersegment
    case customerClass
    case territory
    case beatplan
    case visitStep
    case vendor
    case town
    case document
    case viewForTageCustomer
    case lead
    
}

public enum ResponseType{
    case dic
    case arr
    case string
    case arrOfAny
    case none
}

enum PromotionType{
    case flat
    case bonus
}

enum UserLatestActivityForVisit {
    case checkedIn
    case checkedOut
    case none
}

enum UserLatestActivityForLead {
    case checkedIn
    case checkedOut
    case none
}

enum ChartFor {
    case visitDone
    case visitUpdated
    case visitMissed
    case leadAssigned
    case leadAdded
    case leadUpdated
}
enum BtnLeft{
    case menu
    case back
}

enum BtnRight{
    case home
    case detail
    case camera
    case others
    case editMap
    case homeedit
    case edit
    case othershome
    case none
}

enum SelectionOf{
    case visit
    case lead
}

enum Apicallmethod{
    case get
    case post
}

enum Leadstage{
    case leadstage1
    case leadstage2
    case leadstage3
    case leadstage4
}

enum InteractionType{
    case metting
    case call
    case mail
    case message
}

enum CustomerSelectionMode{
    case single
    case multiple
}

