//
//  Quizmodel.swift
//  SuperSales
//
//  Created by mac on 28/01/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit

class Quizmodel: NSObject {
   
        var isActive:Bool!
        var isQuizAvailable:Bool!
        var option4:String!
        var option3:String!
        var option2:String!
        var option1:String!
        var applicationID:Int = 0
        var lastModifiedBy:Int = 0
        var singleAnswerKey:Bool!
        var quizID:Double = 0.0 
        var createdByName:String!
        var createdBy:Int = 0
        var answer:Int = 0
        var documentID:Int = 0
        var lastModified:String!
        var createdTime:String!
        var questionText:String!
        var companyID:Int = 0
        
        func initwithDicForQuestion(dic:[String:Any])->Quizmodel{
            self.isActive = Common.returndefaultbool(dic: dic, keyvalue: "isActive")
            self.isQuizAvailable = Common.returndefaultbool(dic: dic, keyvalue: "isQuizAvailable")
            self.singleAnswerKey = Common.returndefaultbool(dic: dic, keyvalue: "singleAnswerKey")
            self.option4 = Common.returndefaultstring(dic: dic, keyvalue: "option4")
            self.option3 = Common.returndefaultstring(dic: dic, keyvalue: "option3")
            self.option2 = Common.returndefaultstring(dic: dic, keyvalue: "option2")
            self.option1 = Common.returndefaultstring(dic: dic, keyvalue: "option1")
            self.lastModified = Common.returndefaultstring(dic: dic, keyvalue: "lastModified")
            self.createdTime = Common.returndefaultstring(dic: dic, keyvalue: "createdTime")
            self.questionText = Common.returndefaultstring(dic: dic, keyvalue: "questionText")
            self.applicationID = Common.returndefaultInteger(dic: dic, keyvalue: "applicationID")
            self.lastModifiedBy = Common.returndefaultInteger(dic: dic, keyvalue: "lastModifiedBy")
            self.quizID = Common.returndefaultdouble(dic: dic, keyvalue: "quizID")
            self.createdByName = Common.returndefaultstring(dic: dic, keyvalue: "createdByName")
            self.createdBy = Common.returndefaultInteger(dic: dic, keyvalue: "createdBy")
            self.answer = Common.returndefaultInteger(dic: dic, keyvalue: "answer")
            self.documentID = Common.returndefaultInteger(dic: dic, keyvalue: "documentID")
            self.companyID = Common.returndefaultInteger(dic: dic, keyvalue: "companyID")
            
            return self
        }
        
    
}
