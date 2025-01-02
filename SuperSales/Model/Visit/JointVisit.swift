//
//  JointVisit.swift
//  SuperSales
//
//  Created by Apple on 21/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit


class JointVisit: Decodable {
    var CompanyID:NSInteger?
    var CreatedBy:NSInteger?
    var ID:NSInteger?
    var EndTime:String?
    var MemberName:String?
    var StartTime:String?
    var MemberID:NSInteger?
    var UserID:NSInteger?
    
}

/*struct Quizmodel{
   /**
    ["isActive": 1, "isQuizAvailable": 0, "option3": re, "applicationID": 2, "lastModifiedBy": 8830, "singleAnswerKey": 1, "quizID": 107, "createdByName": Deepak Shah ., "createdBy": 8830, "answer": 1000, "documentID": 206, "option1": fd, "lastModified": 2021/08/02 00:00:00, "createdTime": 2021/08/02 00:00:00, "companyID": 1198, "option4": fs, "option2": ew, "questionText": test]
    */
   let isActive:Bool
   let isQuizAvailable:Bool
   let option3:String
   let applicationId:Int
   let lastModifiedBy:Int
   let singleAnswerKey:Bool
   let quizID:NSNumber
   
   enum CodingKeys: String, CodingKey {
       
       
      
       
           case isActive
           case isQuizAvailable
           case option3
           case applicationId
           case lastModifiedBy
       }
}
extension Quizmodel:Decodable{
   public init(from decoder: Decoder) throws {
       let values = try decoder.container(keyedBy: CodingKeys.self)
       let option3 = try values.decode(String.self, forKey: .option3)
       let isQuizAvailable = try values.decode(String.self, forKey: .isQuizAvailable)
       let isActive = try values.decode(String.self, forKey: .isActive)
       let applicationId = try values.decode(String.self, forKey: .applicationId)
       let lastModifiedBy = try values.decode(String.self, forKey: .lastModifiedBy)

           // Decode to `Location` struct, and then convert back to `CLLocation`.
           // It's very tricky
          // let locationModel = try values.decode(Quizmodel.self, forKey: .)
          // location = CLLocation(model: locationModel)
       self.init(isActive: isActive, isQuizAvailable: isQuizAvailable, option3: option3, applicationId: applicationId, lastModifiedBy: lastModifiedBy)
       }
}
*/
