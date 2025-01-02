//
//  Feedback.swift
//  SuperSales
//
//  Created by Apple on 06/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
class Feedback {
    
    /*
     @property(nonatomic,assign)int iD;
     @property(nonatomic,strong)NSString *desc;
     @property(nonatomic,assign)int companyID;
     @property(nonatomic,assign)int createdBy;
     @property(nonatomic,strong)NSString *createdTime;
     @property(nonatomic,strong)NSString *lastModified;
     @property(nonatomic,assign)int isActive;
     @property(nonatomic,assign)int questionIndex;
     @property(nonatomic,assign)int lastModifiedBy;
     @property(nonatomic,strong)NSString *createdByName;
     @property(nonatomic,strong)NSString *userAnswerValue;
     @property(nonatomic,assign)int answerID;
     @property(nonatomic,assign)int visitId;
     @property(nonatomic,strong)NSString *Description;
     **/
   var iD: Int?
   var desc: String?
   var companyID: Int?
   var createdBy: Int?
   var createdTime: String?
   var lastModified: String?
   var isActive: Int?
   var questionIndex: Int?
   var lastModifiedBy: Int?
   var createdByName: String?
   var userAnswerValue: String?
    var option1:String?
    var option2:String?
    var option3:String?
    var option4:String?
   var answerID: Int?
   var visitId: Int?
   var description: String?
    
    enum CodingKeys: String, CodingKey {
      
       case iD = "id"
       case desc
       case companyID
       case createdBy
       case createdTime
       case lastModified
       case isActive
       case questionIndex
       case lastModifiedBy
       case createdByName
       case userAnswerValue
        case option1
        case option2
        case option3
        case option4
        
       case answerID
       case visitId
       case description
   }
    func initwithdic(dic:[String:Any])->Feedback{
        self.iD = Common.returndefaultInteger(dic: dic, keyvalue: "id")
        self.desc = Common.returndefaultstring(dic: dic, keyvalue: "desc")
        self.companyID = Common.returndefaultInteger(dic: dic, keyvalue: "CompanyID")
        self.createdBy = Common.returndefaultInteger(dic: dic, keyvalue: "CreatedBy")
        self.createdTime = Common.returndefaultstring(dic: dic, keyvalue: "createdTime")
          self.lastModified = Common.returndefaultstring(dic: dic, keyvalue: "lastModified")
         self.questionIndex = Common.returndefaultInteger(dic: dic, keyvalue: "questionIndex")
        //lastModifiedBy
        self.isActive = Common.returndefaultInteger(dic: dic, keyvalue: "isActive")
        self.questionIndex = Common.returndefaultInteger(dic: dic, keyvalue: "questionIndex")
        self.lastModifiedBy = Common.returndefaultInteger(dic: dic, keyvalue: "lastModifiedBy")
        self.createdByName = Common.returndefaultstring(dic: dic, keyvalue: "createdByName")
        self.userAnswerValue = Common.returndefaultstring(dic: dic, keyvalue: "userAnswerValue")
        self.option1 = Common.returndefaultstring(dic: dic, keyvalue: "option1")
        self.option2 = Common.returndefaultstring(dic: dic, keyvalue: "option2")
        self.option3 = Common.returndefaultstring(dic: dic, keyvalue: "option3")
        self.option4 = Common.returndefaultstring(dic: dic, keyvalue: "option4")
        self.description =  Common.returndefaultstring(dic: dic, keyvalue: "Description")
        return self
    }
}

//extension Feedback : Encodable{
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//           try container.encode(iD, forKey: .iD)
//           try container.encode(desc, forKey: .desc)
//           try container.encode(companyID, forKey: .companyID)
//           try container.encode(createdBy, forKey: .createdBy)
//           try container.encode(createdTime, forKey: .createdTime)
//           try container.encode(lastModified, forKey:  .lastModified)
//           try container.encode(isActive, forKey:  .isActive)
//           try container.encode(questionIndex, forKey:  .questionIndex)
//           try container.encode(lastModifiedBy, forKey:  .lastModifiedBy)
//           try container.encode(createdByName, forKey:  .createdByName)
//          try container.encode(userAnswerValue, forKey:  .userAnswerValue)
//          try container.encode(answerID, forKey:  .answerID)
//         try container.encode(visitId, forKey:  .visitId)
//         try container.encode(description, forKey:  .description)
//        
//        
//    }
//}
//extension Feedback : Decodable{
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//           iD = try container.decode(Int.self, forKey: .iD)
//          companyID = try container.decode(Int.self, forKey: .companyID)
//          createdBy = try container.decode(Int.self, forKey: .createdBy)
//        isActive = try container.decode(Int.self, forKey: .isActive)
//        questionIndex = try container.decode(Int.self, forKey: .questionIndex)
//        lastModifiedBy = try container.decode(Int.self, forKey: .lastModifiedBy)
//         answerID = try container.decode(Int.self, forKey: .answerID)//visitId
//        visitId = try container.decode(Int.self, forKey: .visitId)
//           desc = try container.decode(String.self, forKey: .desc)
//        createdTime = try container.decode(String.self, forKey: .createdTime)
//        lastModified = try container.decode(String.self, forKey: .lastModified)
//        createdByName = try container.decode(String.self, forKey: .createdByName)
//        userAnswerValue = try container.decode(String.self, forKey: .userAnswerValue)
//        description = try container.decode(String.self, forKey: .description)
//    }
//}
