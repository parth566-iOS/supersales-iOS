//
//  APIManager.swift
//  SuperSales
//
//  Created by Apple on 24/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

// swiftlint:disable line_length
typealias SettingBlock1 = (setting: Setting,error:NSError)
public typealias ResponseBlock = (totalpage:Int,pagesAvailable:Int,lastSyncTime:String?,result:Any,status:String,message:String,error:NSError,responseType:ResponseType)
public typealias ResponseBlockstr = (messagestr:String,status:Bool)
public typealias ResponseBlockWithTotalRecord = (totalRecords:Int,totalpage:Int,pagesAvailable:Int,lastSyncTime:String?,result:Any,status:String,message:String,error:NSError,responseType:ResponseType)
//,responseType:ResponseType
//public typealias ResponseBlockWithArray  = (result:[Any],error:String)
//public typealias ResponseBlockWithDictionary  = (result:[String:Any],error:String)


//, success: (responseBlock)? = nil,error:(responseBlock)? = nil
func apicall(url:String,param:[String:Any],method:Apicallmethod,completion: @escaping (ResponseBlock) -> Void)
{
//    var request: Alamofire.Request? {
//        didSet {
//            oldValue?.cancel()
//        }
//    }
    let url = URL.init(string: url)!

    var resultdic:[String:Any]?
    var resultArr:[[String:Any]]?
    var resultAny:[Any]?
    var resultStr:String?
    //check internet
    if(Utils.isReachable() == true){
        var httpMethod:HTTPMethod!
        if(method == Apicallmethod.get){
            httpMethod = HTTPMethod.get
        }else if(method == Apicallmethod.post){
            httpMethod = HTTPMethod.post
        }

        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        manager.session.configuration.timeoutIntervalForResource = 120
     //  print("url = \(url) , parameter = \(param)")
        manager.request(url, method: httpMethod , parameters:param)
                .responseJSON {
                    response in
                    switch (response.result){
                    
                    case .success( _):
//                    print("response = \(response)")
//
                    var dict:[String:AnyObject]?
                        do{
                        dict = try  JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        if(JSONSerialization.isValidJSONObject(dict ?? [String:AnyObject]())){
                    
                        let responsemodel = RootClass.init(dictionary: dict ?? [String:AnyObject]())
                        if(responsemodel.status!.lowercased() == "success"){
                                               
                                            resultdic = dict?["data"] as? [String : Any]
                                            resultArr = dict?["data"] as? [[String:Any]]
                                            resultAny = dict?["data"] as? [Any]
                                            resultStr = dict?["data"] as? String
                                if(resultdic ==  nil){
              
                                                            if(resultdic != nil){
                                                                return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0,responsemodel.lastSynchTime,result:resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
                                                            }else if(resultArr !=  nil){
                                                                return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0,responsemodel.lastSynchTime,result:resultArr ?? [[String:Any]](),responsemodel.status ?? "" ,responsemodel.message!,error:Common.returnnoerror(),responseType:ResponseType.arr))
                                                            }else if(resultStr != nil){
                                                                return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0,responsemodel.lastSynchTime,result:resultStr ?? String(),responsemodel.status ?? "" ,responsemodel.message!,error:Common.returnnoerror(),responseType:ResponseType.string))
                                                            }else{
                                return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0,responsemodel.lastSynchTime,result:resultAny ?? [[String:Any]](),responsemodel.status ?? "" ,responsemodel.message!,error:Common.returnnoerror(),responseType:ResponseType.arrOfAny))
                                    }
                    //                                    }catch{
                    //                                        print(error.localizedDescription)
                    //                                    }
                                                    }else {
                                                        return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,result:resultdic ?? [String:Any]() ,responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
                                                    }
                    
                                                }else if(responsemodel.status?.lowercased() == "invalid token"){
                                                    let loginobject = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.LoginView) as? Login
                                                        loginobject?.logout()
                                                    let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":"Invalid- token"])
                                                    return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message!,error,responseType:ResponseType.none))
                    
                                                }else if(responsemodel.status?.lowercased() == "error"){
                                            print(responsemodel.message!)
                        let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":responsemodel.message ?? ""])
                                                
                                                    return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message!,error,responseType:ResponseType.none))
                                                }
                                            }else{
                                        let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":"Invalid-Json"])
                return completion((0,0,"",resultdic ?? [String:Any](), "error","Invalid-Json",error,responseType:ResponseType.none))
                                            }
                    
                                        }catch{
                            print(error.localizedDescription)
            return completion((0,0,"",resultdic ?? [String:Any](),"error","",error as NSError,responseType:ResponseType.none))
                                        }
                                            //convertToDictionary(text: response)
                    
                    
                    //                    }else{
                    //                        return completion((resultdic ?? [String:Any](), "Invalid - json"))
                    //                    }
                    
            case .failure(let error):
        return completion((0,0,"",resultdic ?? [String:Any](),"error","Something went wrong please try again",error as NSError,responseType:ResponseType.none))
                    
                    
                

  //  request = Alamofire.request(url, method: httpMethod , parameters:param)
//        if let request = request as? DataRequest {
//            request.responseString { response in
//                /*    sessionManager.request(url,parameters:param).validate(statusCode: 200..<300).responseJSON { response in*/
//    switch response.result{
//
//case .success( _):
//
//var dict:[String:AnyObject]?
//    do{
//    dict = try  JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
//    if(JSONSerialization.isValidJSONObject(dict ?? [String:AnyObject]())){
//
//    let responsemodel = RootClass.init(dictionary: dict ?? [String:AnyObject]())
//            if(responsemodel.status!.lowercased() == "success"){
//            // do{
//
//            if(JSONSerialization.isValidJSONObject(responsemodel.data!)){
//    let dic = responsemodel.data as? [String:Any] ?? [String:Any]()
//
//    print("\(dic)")
//}else{
//    print("Invalid json API manager")
//}
//                                //                        }catch{
//                                //                            print(error.localizedDescription)
//                                //                            return completion((resultdic ?? [String:Any](),"",error as NSError,responseType:ResponseType.none))
//                                //                        }
//                        resultdic = dict?["data"] as? [String : Any]
//                        resultArr = dict?["data"] as? [[String:Any]]
//                                resultAny = dict?["data"] as? [Any]
//
//            if(resultdic ==  nil){
////                                    do{
//            let arr = Common.returndefaultarray(dic: dict ?? [String:Any]() , keyvalue: "data")///try JSONSerialization.jsonObject(with: response.data!, options: []) as? [Any]
//                                        print(arr)
//                                        let dic = Common.returndefaultdictionary(dic: dict ?? [String:Any](), keyvalue: "data")
//                                        print(dic)
//                                        if(resultdic != nil){
//                                            return completion((result:resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
//                                        }else if(resultArr !=  nil){
//                                            return completion((result:resultArr ?? [[String:Any]](),responsemodel.status ?? "" ,responsemodel.message!,error:Common.returnnoerror(),responseType:ResponseType.arr))
//                                        }else{
//            return completion((result:resultAny ?? [[String:Any]](),responsemodel.status ?? "" ,responsemodel.message!,error:Common.returnnoerror(),responseType:ResponseType.arrOfAny))
//                }
////                                    }catch{
////                                        print(error.localizedDescription)
////                                    }
//                                }else {
//                                    return completion(( result:resultdic ?? [String:Any]() ,responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
//                                }
//
//                            }else if(responsemodel.status?.lowercased() == "invalid token"){
//                                let loginobject = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.LoginView) as? Login
//                                    loginobject?.logout()
//                                let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":"Invalid- token"])
//                                return completion((resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message!,error,responseType:ResponseType.none))
//
//                            }else if(responsemodel.status?.lowercased() == "error"){
//                        print(responsemodel.message!)
//    let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":responsemodel.message ?? ""])
//    return completion((resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message!,error,responseType:ResponseType.none))
//                            }
//                        }else{
//                    let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":"Invalid-Json"])
//                    return completion((resultdic ?? [String:Any](), "error","Invalid-Json",error,responseType:ResponseType.none))
//                        }
//
//                    }catch{
//        print(error.localizedDescription)
//        return completion((resultdic ?? [String:Any](),"error","",error as NSError,responseType:ResponseType.none))
//                    }
//                        //convertToDictionary(text: response)
//
//
////                    }else{
////                        return completion((resultdic ?? [String:Any](), "Invalid - json"))
////                    }
//
//                case .failure(let error):
//                    return completion((resultdic ?? [String:Any](),"Something went wrong please try again", "error",error as NSError,responseType:ResponseType.none))
//
//
//                }
//
//            }
//        }
    }
                }
    }else{
     
        let error = NSError.init(domain: "", code: 2, userInfo:["localiseddescription":"Internet is not Available"])
        return completion((0,0,"",result:[:],"internet not available","",error:error,responseType:ResponseType.none))
    }
    
}

func apicallCustomerList(url:String,param:[String:Any],method:Apicallmethod,completion: @escaping (ResponseBlockWithTotalRecord) -> Void) {
//    var request: Alamofire.Request? {
//        didSet {
//            oldValue?.cancel()
//        }
//    }
    let url = URL.init(string: url)!

    var resultdic:[String:Any]?
    var resultArr:[[String:Any]]?
    var resultAny:[Any]?
    var resultStr:String?
    //check internet
    if(Utils.isReachable() == true){
        var httpMethod:HTTPMethod!
        if(method == Apicallmethod.get){
            httpMethod = HTTPMethod.get
        }else if(method == Apicallmethod.post){
            httpMethod = HTTPMethod.post
        }

        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        manager.session.configuration.timeoutIntervalForResource = 120
     //  print("url = \(url) , parameter = \(param)")
        manager.request(url, method: httpMethod , parameters:param)
                .responseJSON {
                    response in
                    switch (response.result){
                    
                    case .success( _):
//                    print("response = \(response)")
//
                    var dict:[String:AnyObject]?
                        do{
                        dict = try  JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        if(JSONSerialization.isValidJSONObject(dict ?? [String:AnyObject]())){
                    
                        let responsemodel = RootClass.init(dictionary: dict ?? [String:AnyObject]())
                        if(responsemodel.status!.lowercased() == "success"){
                                               
                                            resultdic = dict?["data"] as? [String : Any]
                                            resultArr = dict?["data"] as? [[String:Any]]
                                            resultAny = dict?["data"] as? [Any]
                                            resultStr = dict?["data"] as? String
                                if(resultdic ==  nil){
              
                                                            if(resultdic != nil){
                                                                return completion((responsemodel.totalRecords ?? 0 ,responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0,responsemodel.lastSynchTime,result:resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
                                                            }else if(resultArr !=  nil){
                                                                return completion((responsemodel.totalRecords ?? 0 ,responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0,responsemodel.lastSynchTime,result:resultArr ?? [[String:Any]](),responsemodel.status ?? "" ,responsemodel.message!,error:Common.returnnoerror(),responseType:ResponseType.arr))
                                                            }else if(resultStr != nil){
                                                                return completion((responsemodel.totalRecords ?? 0,responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0,responsemodel.lastSynchTime,result:resultStr ?? String(),responsemodel.status ?? "" ,responsemodel.message!,error:Common.returnnoerror(),responseType:ResponseType.string))
                                                            }else{
                                                                return completion((responsemodel.totalRecords ?? 0 ,responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0,responsemodel.lastSynchTime,result:resultAny ?? [[String:Any]](),responsemodel.status ?? "" ,responsemodel.message!,error:Common.returnnoerror(),responseType:ResponseType.arrOfAny))
                                    }
                    //                                    }catch{
                    //                                        print(error.localizedDescription)
                    //                                    }
                                                    }else {
                                                        return completion((responsemodel.totalRecords ?? 0 ,responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,result:resultdic ?? [String:Any]() ,responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
                                                    }
                    
                                                }else if(responsemodel.status?.lowercased() == "invalid token"){
                                                    let loginobject = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.LoginView) as? Login
                                                        loginobject?.logout()
                                                    let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":"Invalid- token"])
                                                    return completion((responsemodel.totalRecords ?? 0 ,responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message!,error,responseType:ResponseType.none))
                    
                                                }else if(responsemodel.status?.lowercased() == "error"){
                                            print(responsemodel.message!)
                        let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":responsemodel.message ?? ""])
                                                
                                                    return completion((responsemodel.totalRecords ?? 0 ,responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message!,error,responseType:ResponseType.none))
                                                }
                                            }else{
                                        let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":"Invalid-Json"])
                return completion((0,0,0,"",resultdic ?? [String:Any](), "error","Invalid-Json",error,responseType:ResponseType.none))
                                            }
                    
                                        }catch{
                            print(error.localizedDescription)
                                            return completion((0,0,0,"",resultdic ?? [String:Any](),"error","",error as NSError,responseType:ResponseType.none))
                                        }
                                            //convertToDictionary(text: response)
                    
                    
                    //                    }else{
                    //                        return completion((resultdic ?? [String:Any](), "Invalid - json"))
                    //                    }
                    
            case .failure(let error):
        return completion((0,0,0,"",resultdic ?? [String:Any](),"error","Something went wrong please try again",error as NSError,responseType:ResponseType.none))
                    
     
    }
                }
    }else{
     
        let error = NSError.init(domain: "", code: 2, userInfo:["localiseddescription":"Internet is not Available"])
        return completion((0,0,0,"",result:[:],"internet not available","",error:error,responseType:ResponseType.none))
    }
    
}

    func cancelRequest(request:DataRequest){
        request.cancel()
    }
    
func APICallDefaultSetting(apirequest:DataRequest ,compeletion:@escaping (SettingBlock1)-> Void){
    APIcall(apirequest: apirequest) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)  in
        if(error.code == 0){
            let setting = Setting.init(dictionary: (arr as? [String : Any] ?? [String:Any]()))
        //dic["SalesOrderLoadPage"] = 1
            print("arr of setting = \(arr)")
        let userdefault = UserDefaults.standard
        userdefault.setValue(arr, forKey: Constant.kUserSetting)
        userdefault.synchronize()
        
    compeletion((setting:setting,NSError.init(domain: "", code: 0, userInfo: [String:Any]())))

    }else{
        
        let dic1 = [String:Any]()
        let setting = Setting.init(dictionary: dic1)
        let errorOfApi = NSError.init(domain: "default", code: 0, userInfo: ["localisedescription":error])
        compeletion((setting:setting,error:errorOfApi))
    }
    }
                /*  if(error.code == 0){
                let setting = Setting.init(dictionary: arr as? [String : Any] ?? [String:Any]())
                //dic["SalesOrderLoadPage"] = 1
   
                let userdefault = UserDefaults.standard
                userdefault.setValue(arr, forKey: Constant.kUserSetting)
                userdefault.synchronize()
                
            compeletion((setting:setting,NSError.init(domain: "", code: 0, userInfo: [String:Any]())))

            }else{
                let dic1 = [String:Any]()
                let setting = Setting.init(dictionary: dic1)
                let errorOfApi = NSError.init(domain: "default", code: 0, userInfo: ["localisedescription":error])
                compeletion((setting:setting,error:errorOfApi))
            }*/
        
}
    func APIcall(apirequest:DataRequest ,completion: @escaping (ResponseBlock) -> Void) {
    //    var request: Alamofire.Request? {
    //        didSet {
    //            oldValue?.cancel()
    //        }
    //    }
      /*  let url = URL.init(string: url)!

        var resultdic:[String:Any]?
        var resultArr:[[String:Any]]?
        var resultAny:[Any]?
        //check internet
        if(Utils.isReachable() == true){
            var httpMethod:HTTPMethod!
            if(method == Apicallmethod.get){
                httpMethod = HTTPMethod.get
            }else if(method == Apicallmethod.post){
                httpMethod = HTTPMethod.post
            }

            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 120
            manager.session.configuration.timeoutIntervalForResource = 120
           
            manager.request(url, method: httpMethod , parameters:param)*/
        var resultdic:[String:Any]?
        var resultArr:[[String:Any]]?
        var resultAny:[Any]?
        if(Utils.isReachable() == true){
        apirequest
                    .responseJSON {
                        response in
                        switch (response.result){
              
                        case .success( _):
                            print("response = \(response)")
                        var dict:[String:AnyObject]?
                            do{
                            dict = try  JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                            if(JSONSerialization.isValidJSONObject(dict ?? [String:AnyObject]())){
                        
                            let responsemodel = RootClass.init(dictionary: dict ?? [String:AnyObject]())
                                    if(responsemodel.status!.lowercased() == "success"){
                                    // do{
                        
                                    if(JSONSerialization.isValidJSONObject(responsemodel.data!)){
                            let dic = responsemodel.data as? [String:Any] ?? [String:Any]()
                        
                         
                        }else{
                            print("Invalid json API manager")
                        }
                                                        //                        }catch{
                                                        //                            print(error.localizedDescription)
                                                        //                            return completion((resultdic ?? [String:Any](),"",error as NSError,responseType:ResponseType.none))
                                                        //                        }
                                                resultdic = dict?["data"] as? [String : Any]
                                                resultArr = dict?["data"] as? [[String:Any]]
                                                        resultAny = dict?["data"] as? [Any]
                        
                                    if(resultdic ==  nil){
                        //                                    do{
                                    let arr = Common.returndefaultarray(dic: dict ?? [String:Any]() , keyvalue: "data")///try JSONSerialization.jsonObject(with: response.data!, options: []) as? [Any]
                                                                print(arr)
                                                                let dic = Common.returndefaultdictionary(dic: dict ?? [String:Any](), keyvalue: "data")
                                                                print(dic)
                                                                if(resultdic != nil){
                                                                    return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0,responsemodel.lastSynchTime,result:resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
                                                                }else if(resultArr !=  nil){
                                                                    return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0,responsemodel.lastSynchTime,result:resultArr ?? [[String:Any]](),responsemodel.status ?? "" ,responsemodel.message!,error:Common.returnnoerror(),responseType:ResponseType.arr))
                                                                }else{
                                    return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0,responsemodel.lastSynchTime,result:resultAny ?? [[String:Any]](),responsemodel.status ?? "" ,responsemodel.message!,error:Common.returnnoerror(),responseType:ResponseType.arrOfAny))
                                        }
                        //                                    }catch{
                        //                                        print(error.localizedDescription)
                        //                                    }
                                                        }else {
                                                            return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,result:resultdic ?? [String:Any]() ,responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
                                                        }
                        
                                                    }else if(responsemodel.status?.lowercased() == "invalid token"){
                                                        let loginobject = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.LoginView) as? Login
                                                            loginobject?.logout()
                                                        let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":"Invalid- token"])
                                                        return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message!,error,responseType:ResponseType.none))
                        
                                                    }else if(responsemodel.status?.lowercased() == "error"){
                                                print(responsemodel.message!)
                            let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":responsemodel.message ?? ""])
                                                    
        return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message!,error,responseType:ResponseType.none))
                                                    }
                                                }else{
                                            let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":"Invalid-Json"])
                    return completion((0,0,"",resultdic ?? [String:Any](), "error","Invalid-Json",error,responseType:ResponseType.none))
                                                }
                        
                                            }catch{
                                print(error.localizedDescription)
                return completion((0,0,"",resultdic ?? [String:Any](),"error","",error as NSError,responseType:ResponseType.none))
                                            }
                                                //convertToDictionary(text: response)
                        
                        
                        //                    }else{
                        //                        return completion((resultdic ?? [String:Any](), "Invalid - json"))
                        //                    }
                        
                case .failure(let error):
            return completion((0,0,"",resultdic ?? [String:Any](),"error","Something went wrong please try again",error as NSError,responseType:ResponseType.none))
                        
                        
                    }

      //  request = Alamofire.request(url, method: httpMethod , parameters:param)
    //        if let request = request as? DataRequest {
    //            request.responseString { response in
    //                /*    sessionManager.request(url,parameters:param).validate(statusCode: 200..<300).responseJSON { response in*/
    //    switch response.result{
    //
    //case .success( _):
    //
    //var dict:[String:AnyObject]?
    //    do{
    //    dict = try  JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
    //    if(JSONSerialization.isValidJSONObject(dict ?? [String:AnyObject]())){
    //
    //    let responsemodel = RootClass.init(dictionary: dict ?? [String:AnyObject]())
    //            if(responsemodel.status!.lowercased() == "success"){
    //            // do{
    //
    //            if(JSONSerialization.isValidJSONObject(responsemodel.data!)){
    //    let dic = responsemodel.data as? [String:Any] ?? [String:Any]()
    //
    //    print("\(dic)")
    //}else{
    //    print("Invalid json API manager")
    //}
    //                                //                        }catch{
    //                                //                            print(error.localizedDescription)
    //                                //                            return completion((resultdic ?? [String:Any](),"",error as NSError,responseType:ResponseType.none))
    //                                //                        }
    //                        resultdic = dict?["data"] as? [String : Any]
    //                        resultArr = dict?["data"] as? [[String:Any]]
    //                                resultAny = dict?["data"] as? [Any]
    //
    //            if(resultdic ==  nil){
    ////                                    do{
    //            let arr = Common.returndefaultarray(dic: dict ?? [String:Any]() , keyvalue: "data")///try JSONSerialization.jsonObject(with: response.data!, options: []) as? [Any]
    //                                        print(arr)
    //                                        let dic = Common.returndefaultdictionary(dic: dict ?? [String:Any](), keyvalue: "data")
    //                                        print(dic)
    //                                        if(resultdic != nil){
    //                                            return completion((result:resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
    //                                        }else if(resultArr !=  nil){
    //                                            return completion((result:resultArr ?? [[String:Any]](),responsemodel.status ?? "" ,responsemodel.message!,error:Common.returnnoerror(),responseType:ResponseType.arr))
    //                                        }else{
    //            return completion((result:resultAny ?? [[String:Any]](),responsemodel.status ?? "" ,responsemodel.message!,error:Common.returnnoerror(),responseType:ResponseType.arrOfAny))
    //                }
    ////                                    }catch{
    ////                                        print(error.localizedDescription)
    ////                                    }
    //                                }else {
    //                                    return completion(( result:resultdic ?? [String:Any]() ,responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
    //                                }
    //
    //                            }else if(responsemodel.status?.lowercased() == "invalid token"){
    //                                let loginobject = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.LoginView) as? Login
    //                                    loginobject?.logout()
    //                                let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":"Invalid- token"])
    //                                return completion((resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message!,error,responseType:ResponseType.none))
    //
    //                            }else if(responsemodel.status?.lowercased() == "error"){
    //                        print(responsemodel.message!)
    //    let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":responsemodel.message ?? ""])
    //    return completion((resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message!,error,responseType:ResponseType.none))
    //                            }
    //                        }else{
    //                    let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":"Invalid-Json"])
    //                    return completion((resultdic ?? [String:Any](), "error","Invalid-Json",error,responseType:ResponseType.none))
    //                        }
    //
    //                    }catch{
    //        print(error.localizedDescription)
    //        return completion((resultdic ?? [String:Any](),"error","",error as NSError,responseType:ResponseType.none))
    //                    }
    //                        //convertToDictionary(text: response)
    //
    //
    ////                    }else{
    ////                        return completion((resultdic ?? [String:Any](), "Invalid - json"))
    ////                    }
    //
    //                case .failure(let error):
    //                    return completion((resultdic ?? [String:Any](),"Something went wrong please try again", "error",error as NSError,responseType:ResponseType.none))
    //
    //
    //                }
    //
    //            }
    //        }
        
            
                    }
            
        }else{
         
            let error = NSError.init(domain: "", code: 2, userInfo:["localiseddescription":"Internet is not Available"])
            return completion((0,0,"",result:[:],"internet not available","",error:error,responseType:ResponseType.none))
        }
    //Alamofire.request(URL.init(string: url), method: .post, parameters: param, encoding: ParameterEncoding.encode(JSONEncoding.default), headers: .default).respon

   /* class func httpRequestAPI(_ url: URLConvertible, _ httpMethod: HTTPMethod = .post, parameters: Parameters? = nil, isTeamWorkUrl: Bool = false, isFull: Bool = false, completionHandler: @escaping(_ response: Any?, _ success: Bool, _ error: Error?) -> Void) {
        
        let finalAPIUrl = (isTeamWorkUrl ? ConstantURL.kBaseTeamworkURL : ConstantURL.kBaseURL) + "\(url)"
                
        AlamofireAppManager.shared.request(finalAPIUrl,
                                           method: httpMethod,
                                           parameters: parameters)
            .responseJSON { (response) in
                parseJsonResponseAPI(response, isFull, completionHandler: completionHandler)
            }
    }
    
    fileprivate class func parseJsonResponseAPI(
        _ response: DataResponse<Any>,
        _ isFull: Bool,
        completionHandler: @escaping (_ response: Any?,_ success:Bool,_ error: NSError?) -> Void) {
        print(response)
        switch response.result {
        case .success(let JSON):
            let jsonResponse = JSON as? [String: Any] ?? [:]
            let status = jsonResponse["status"] as? String
            if status == "Success"{
                completionHandler(isFull ? jsonResponse : jsonResponse["data"], true, nil)
                return
            }else if status == "Invalid Token" {
                let err = NSError.init(domain: "", code: 5555, userInfo: [NSLocalizedDescriptionKey : "Invalid Token"])
                completionHandler(nil, false, err)
                return
            }else if status == "Error" {
                let err = NSError.init(domain: "", code: 5555, userInfo: [NSLocalizedDescriptionKey : jsonResponse["message"] ?? ""])
                completionHandler(nil, false, err)
                return
            }
            completionHandler(jsonResponse["data"], true, nil)
        case .failure(let error):
            completionHandler(nil, false, error as NSError)
            return
        }
    }
*/
}


//func apicall(url:String,param:[String:Any],method:Apicallmethod,completion: @escaping (ResponseBlock) -> Void) {
//    var request: Alamofire.Request? {
//        didSet {
//            oldValue?.cancel()
//        }
//    }
//    let url = URL.init(string: url)!
//
//    var resultdic:[String:Any]?
//    var resultArr:[[String:Any]]?
//    //check internet
//    if(Utils.isReachable() == true){
//        var httpMethod:HTTPMethod!
//        if(method == Apicallmethod.get){
//            httpMethod = HTTPMethod.get
//        }else if(method == Apicallmethod.post){
//            httpMethod = HTTPMethod.post
//        }
//        request = Alamofire.request(url, method: httpMethod , parameters:param)
//        if let request = request as? DataRequest {
//            request.responseJSON { (response) in
//                print(response)
//            }
//           /* request.responseString { response in
//
//                switch response.result {
//
//                case .success( _):
//
//                    var dict:[String:Any]?
//                    do{
//                        dict = try  JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]
//                        if(JSONSerialization.isValidJSONObject(dict ?? [String:Any]())){
//
//                            let responsemodel = RootClass.init(dictionary: dict ?? [String:Any]())
//                            if(responsemodel.status!.lowercased() == "success"){
//                                //                        do{
//
//                                if(JSONSerialization.isValidJSONObject(responsemodel.data!)){
//                                    let dic = responsemodel.data as? [String:Any] ?? [String:Any]()
//                                    let arr = responsemodel.data as? [[String:Any]] ?? [[String:Any]]()
//                                    let str =  responsemodel.data as? String ?? ""
//                                    print("\(dic),\(arr),\(str)")
//                                }else{
//                                    print("Invalid json API manager")
//                                }
//                                //                        }catch{
//                                //                            print(error.localizedDescription)
//                                //                            return completion((resultdic ?? [String:Any](),"",error as NSError,responseType:ResponseType.none))
//                                //                        }
//                                resultdic = dict?["data"] as? [String : Any]
//                                resultArr = dict?["data"] as? [[String:Any]]
//                                if(resultdic ==  nil){
//                                    do{
//                                        let arr = Common.returndefaultarray(dic: dict ?? [String:Any]() , keyvalue: "data")///try JSONSerialization.jsonObject(with: response.data!, options: []) as? [Any]
//                                        print(arr)
//                                        let dic = Common.returndefaultdictionary(dic: dict ?? [String:Any](), keyvalue: "data")
//                                        print(dic)
//                                        if(resultArr == nil){
//                                            return completion((result:resultdic ?? [String:Any](),responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
//                                        }else{
//                                            return completion((result:resultArr ?? [[String:Any]](),responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.arr))
//                                        }
//                                    }catch{
//                                        print(error.localizedDescription)
//                                    }
//                                }else{
//                                    return completion(( result:resultdic ?? [String:Any]() ,responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
//                                }
//
//                            }else if(responsemodel.status?.lowercased() == "invalid token"){
//                                let loginobject = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.LoginView) as! Login
//                                loginobject.logout()
//                                let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":"Invalid- token"])
//                                return completion((resultdic ?? [String:Any](),responsemodel.message!,error,responseType:ResponseType.none))
//
//                            }else if(responsemodel.status?.lowercased() == "error"){
//                                let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":responsemodel.message ?? ""])
//                                return completion((resultdic ?? [String:Any](),responsemodel.message!,error,responseType:ResponseType.none))
//                            }
//                        }else{
//
//                        }
//
//                    }catch{
//                        print(error.localizedDescription)
//                        return completion((resultdic ?? [String:Any](),"",error as NSError,responseType:ResponseType.none))
//                    }
//                    //convertToDictionary(text: response)
//
//
//                    //                    }else{
//                    //                        return completion((resultdic ?? [String:Any](), "Invalid - json"))
//                    //                    }
//
//                case .failure(let error):
//                    return completion((resultdic ?? [String:Any](),"Something went wrong please try again",error as NSError,responseType:ResponseType.none))
//
//
//                }
//
//            }*/
//        }
//    }else{
//        //Common.showalert(msg: "Internet is not Available")
//        let error = NSError.init(domain: "", code: 2, userInfo: ["localiseddescription":"Internet is not Available"])
//        return completion((result:[:],"",error:error,responseType:ResponseType.none))
//    }
//    //Alamofire.request(URL.init(string: url), method: .post, parameters: param, encoding: ParameterEncoding.encode(JSONEncoding.default), headers: .default).respon
//
//
//}

func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}
//typealias PostCompletionHandler = (NSDictionary) -> ()
//typealias CompeletionHandler = (String,Any)->()
/*
func post(postUrl: String, body: [String: AnyObject], completionHandler: @escaping (PostCompletionHandler)){
    
    let url = URL(string:postUrl)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")    // Set as JSON content-type
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    if(body.count > 0){
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
        if error != nil{
            print(error?.localizedDescription ?? "Error")
            return
        }
        
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
            if json != nil {
                completionHandler(json!)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    task.resume()
}
struct Result {
    var status: String
    var message: String
    var data: Array<Dictionary<String, Any>>
    var dataString : Array<String>
    //  var dataInt: Array<Int>
    
    init(_ dictionary: [String: Any]) {
        self.status = dictionary["status"] as? String ?? ""
        self.message = dictionary["message"] as? String ?? " "
        print(dictionary["data"] ?? [[String:AnyObject]]())
        
        // if(type(of: dictionary["data"])as Array<Dictionary>){
        self.data = dictionary["data"] as? Array<Dictionary> ?? [[String: Any]]()
        if(self.data.count == 0){
            self.dataString = dictionary["data"] as? Array<String> ?? [String]()
        }else{
            self.dataString = [String]()
        }
        
       
        
    }
}
func callAPIget(methodName:String , url:String , parameter:[String:Any],  completionHandler:@escaping (CompeletionHandler)){
    
    if(Utils.isReachable() == true){
        //  var resultModel:Result
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFJSONResponseSerializer.init(readingOptions: .allowFragments)
        manager.responseSerializer.acceptableContentTypes =  NSSet(objects: "application/json","text/plain") as? Set<String>
        var result:Any = " ";
        var status:String = " "
        //
        //    var finishedprocess:Bool = false
        //
        
        manager.get(url , parameters: parameter, progress:
            { (progress) in
                print(url)
                print(progress)
        }, success: { (datatask, response) in
            // resultModel = Result(response as! [String : Any])
            var responseDic = response as! [String:Any]
            print(responseDic)
            if((responseDic["status"] as! String)=="Success"){
               
                result = response ?? ""
                status = "Success"
                
                completionHandler(status,result)
            }
            else{
                completionHandler(status,responseDic)
            }
            
        },failure : { (datatask,error) in
            print(error.localizedDescription as Any)
            result = error
            status = "fail"
            
            completionHandler(status,result)
            //   return("false","some thing went wrong please try again","na")
            
        })
        
    }else{
        completionHandler("false","internet-failure")
    }
    
    // return(resultModel.status,resultModel.message,resultModel.data)
    
}

func callAPIPost(methodName:String , url:String , parameter:[String:Any],  completionHandler:@escaping (CompeletionHandler)){
    if(Utils.isReachable() == true){
        //  var resultModel:Result
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFJSONResponseSerializer.init(readingOptions: .allowFragments)
        manager.responseSerializer.acceptableContentTypes =  NSSet(objects: "application/json","text/plain") as? Set<String>
        var result:Any = " ";
        var status:String = " "
        //
        //    var finishedprocess:Bool = false
        //
        
        manager.post(url , parameters: parameter, progress:
            { (progress) in
                print(url)
                print(progress)
        }, success: { (datatask, response) in
            // resultModel = Result(response as! [String : Any])
            var responseDic = response as! [String:Any]
            print(responseDic)
            if((responseDic["status"] as! String)=="Success"){
                //   let jsonData = (responseDic["data"] as! String).data(using:String.Encoding.utf8)
                result = response ?? ""
                status = "Success"
                
                completionHandler(status,result)
            }else{
                result = response ?? ""
                completionHandler(status,result)
            }
            
            
        },failure : { (datatask,error) in
            print(error.localizedDescription as Any)
            result = error
            status = "fail"
            
            completionHandler(status,result)
            //   return("false","some thing went wrong please try again","na")
            
        })
        
    }
    else{
        completionHandler("false","internet-failure")
    }
    
    // return(resultModel.status,resultModel.message,resultModel.data)
    
}
 */
/*
func postwithmultipartData(strUrl:String,img: UIImage,param:[String:Any])
{
    
    let myUrl = NSURL(string: strUrl);
    //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
    
    let request = NSMutableURLRequest(url:myUrl! as URL);
    request.httpMethod = "POST";
    
//        let param = [
//            "firstName"  : "Sergey",
//            "lastName"    : "Kargopolov",
//            "userId"    : "9"
//        ]
        if param != nil {
            for (key, value) in param {
    
                body.append(Data.init(base64Encoded: "--\(boundary)\r\n")!)
                body.append(Data.init(base64Encoded:"Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")!)
                body.append(Data.init(base64Encoded:"\(value)\r\n")!)
            }
        }
    //  let boundary = generateBoundaryString()
    let boundary = "Boundary-\(UUID().uuidString)"
    request.setValue("multipart/form-data; boundary=\("Boundary-\(UUID().uuidString)")", forHTTPHeaderField: "Content-Type")
    
    
    let imageData = img.jpegData(compressionQuality: 1)
    //UIImageJPEGRepresentation(img, 1)
    
    if(imageData==nil)  { return; }
    
    request.httpBody = createBodyWithParameters(parameters: param as? [String : String], filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
    
    
    //myActivityIndicator.startAnimating();
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        
        if error != nil {
            print("error=\(error)")
            return
        }
        
        // You can print out response object
        print("******* response = \(response)")
        
        // Print out reponse body
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print("****** response data = \(responseString!)")
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
            
            print(json)
            
            //            DispatchQueue.async()(execute:(dispatch_get_main_queue(),{
            //               // self.myActivityIndicator.stopAnimating()
            //                self.myImageView.image = nil;
            //            }));
            
        }catch
        {
            print(error)
        }
        
    }
    
    task.resume()
}


func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
    let body = NSMutableData();
    
    if parameters != nil {
        for (key, value) in parameters! {
            
            body.append(Data.init(base64Encoded: "--\(boundary)\r\n")!)
            body.append(Data.init(base64Encoded:"Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")!)
            body.append(Data.init(base64Encoded:"\(value)\r\n")!)
        }
    }
    
    let filename = "user-profile.jpg"
    let mimetype = "image/jpg"
    
    body.append(Data.init(base64Encoded:"--\(boundary)\r\n")!)
    body.append(Data.init(base64Encoded:"Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")!)
    body.append(Data.init(base64Encoded:"Content-Type: \(mimetype)\r\n\r\n")!)
    body.append(imageDataKey as Data)
    body.append(Data.init(base64Encoded:"\r\n")!)
    
    
    
    body.append(Data.init(base64Encoded:"--\(boundary)--\r\n")!)
    
    return body
}

*/
//MARK: - Uplaod User Profile Pic
/*func uploadImageToServerFromApp(nameOfApi : NSString, parameters : NSString, uploadedImage : UIImage, withCurrentTask :RequestType, andDelegate :AnyObject,viewController:UIViewController)->Void {
    if (Utils.isReachable() == true){
        currentTask = withCurrentTask
        let myRequestUrl = NSString(format: "%@",nameOfApi)
        let url = (myRequestUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request = URLRequest(url: URL(string:url as String)!) as! NSMutableURLRequest
        request.httpMethod = "POST"
       // let boundary = generateBoundaryString()
        //define the multipart request type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let image_data = uploadedImage.pngData()
        if(image_data == nil){
            return
        }
        let body = NSMutableData()
        let fname = "image.png"
        let mimetype = "image/png"
        //define the data post parameter
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"image\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("hi\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"image\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                // print("error=\(String(describing: error))")
                Common.showalert(title: "Supersales", msg: "Server not responding, please try later", view: viewController)
              
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                // print("statusCode should be 200, but is \(httpStatus.statusCode)")
                // print("response = \(String(describing: response))")
                self.delegate?.internetConnectionFailedIssue()
            }else{
                do {
                    self.responseDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                    // self.Responsedata = data as NSData
                    //self.responseDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: AnyObject] as NSDictionary;

                    self.delegate?.responseReceived()
                } catch {
                    //print("error serializing JSON: \(error)")
                }
            }
        }
        task.resume()
    }
    else{
        // print("Internet Connection not Available!")
        Common.showalert(title: "Supersales", msg: "No Internet Connection..", view: viewController)
        // Common.showAlertMessage(title: "App Name", message: "No Internet Connection..")
    }
}*/
/*
func createRequest(userid: String, password: String, email: String) throws -> URLRequest {
    let parameters = [
        "user_id"  : userid,
        "email"    : email,
        "password" : password]  // build your dictionary however appropriate

    let boundary = generateBoundaryString()

    let url = URL(string: "https://example.com/imageupload.php")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

    let fileURL = Bundle.main.url(forResource: "image1", withExtension: "png")!
    request.httpBody = try createBody(with: parameters, filePathKey: "file", urls: [fileURL], boundary: boundary)

    return request
}

/// Create body of the `multipart/form-data` request
///
/// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service.
/// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
/// - parameter urls:         The optional array of file URLs of the files to be uploaded.
/// - parameter boundary:     The `multipart/form-data` boundary.
///
/// - returns:                The `Data` of the body of the request.

private func createBody(with parameters: [String: String]?, filePathKey: String, urls: [URL], boundary: String) throws -> Data {
    var body = Data()

    parameters?.forEach { (key, value) in
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        body.append("\(value)\r\n")
    }

    for url in urls {
        let filename = url.lastPathComponent
        let data = try Data(contentsOf: url)
        let mimetype = mimeType(for: filename)

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimetype)\r\n\r\n")
        body.append(data)
        body.append("\r\n")
    }

    body.append("--\(boundary)--\r\n")
    return body
}

/// Create boundary string for multipart/form-data request
///
/// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.

private func generateBoundaryString() -> String {
    return "Boundary-\(UUID().uuidString)"
}

/// Determine mime type on the basis of extension of a file.
///
/// This requires `import MobileCoreServices`.
///
/// - parameter path:         The path of the file for which we are going to determine the mime type.
///
/// - returns:                Returns the mime type if successful. Returns `application/octet-stream` if unable to determine mime type.

private func mimeType(for path: String) -> String {
    let pathExtension = URL(fileURLWithPath: path).pathExtension as NSString

    guard
        let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, nil)?.takeRetainedValue(),
        let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue()
    else {
        return "application/octet-stream"
    }

    return mimetype as String
}*/
/*func uploadImage(){
let image = UIImage.init(named: "myImage")
let imgData = image!.jpegData(compressionQuality: 0.2)!

 let parameters = ["name": rname] //Optional for extra parameter

Alamofire.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(imgData, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")
        for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            } //Optional for extra parameters
    },
to:"mysite/upload.php")
{ (result) in
    switch result {
    case .success(let upload, _, _):

        upload.uploadProgress(closure: { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
        })

        upload.responseJSON { response in
             print(response.result.value)
        }

    case .failure(let encodingError):
        print(encodingError)
    }
}
}*/

/*func uploadImageMultipart(fullUrl:String,img:UIImage,imgparamname:String,param:[String:Any],completion: @escaping (ResponseBlock) -> Void) {
    if(Utils.isReachable() == true) {

//            var parameters : [String:String] = [:]
//            parameters["auth_key"] = loginUser?.authKey!
//            parameters["first_name"] = firstName
//            parameters["last_name"] = lastName

//            let url = "\(baseUrl)\(basicAuthenticationUrl.updateProfile)"
//            print(url)


            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in param {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                let imageData = img.jpegData(compressionQuality: 0.2)

                if let data = imageData {
                    multipartFormData.append(data, withName: "image_url", fileName: "image.png", mimeType: "image/png")
                }

            }, usingThreshold: UInt64.init(), to: fullUrl, method: .post) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print("Succesfully uploaded  = \(response)")
                        if let err = response.error{

                            print(err)
                            return
                        }

                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")

                }
            }
        }

}
*/
func postWithMultipartBody(fullUrl:String,img:UIImage,imgparamname:String,param:[String:Any],completion: @escaping (ResponseBlock) -> Void) {
     if(Utils.isReachable() == true){
        var resultdic:[String:Any]?
        var resultArr:[[String:Any]]?
        var resultString:String?
        let imageData = img.jpegData(compressionQuality: 0.1)
    if(Utils.isReachable() == true){
    Alamofire.upload(multipartFormData: { (multipartFormData) in
        if(imageData !=  nil){
           // multipartFormData.append(imageData!, withName: imgparamname, mimeType: "image/jpg")
            multipartFormData.append(imageData!, withName: imgparamname, fileName: "image.jpeg", mimeType: "image/jpeg")
        }
        // let boundary = "Boundary-\(UUID().uuidString)"
        if(param.count > 0){
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }
    }, to: fullUrl) { (result) in
        switch result{
        case .success(let upload, _, _):
            upload.responseJSON(completionHandler: { (dataResponse) in
                var dict:[String:AnyObject]?
                do{
                    dict = try  JSONSerialization.jsonObject(with: dataResponse.data!, options: []) as? [String:AnyObject]
                    if(JSONSerialization.isValidJSONObject(dict ?? [String:AnyObject]())){
                        let responsemodel = RootClass.init(dictionary: dict ?? [String:AnyObject]())
                        if(responsemodel.status!.lowercased() == "success"){
                            if(JSONSerialization.isValidJSONObject(responsemodel.data!)){
//                                let dic = responsemodel.data as? [String:Any] ?? [String:Any]()
                            }else{
                                print("Invalid json API manager")
                            }
                            resultString = dict?["data"] as? String
                            resultdic = dict?["data"] as? [String : Any]
                            resultArr = dict?["data"] as? [[String:Any]]
                            if let string = resultString as? String{
                                return completion((responsemodel.totalPages ?? 0, responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,result:string ,responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
                            }else if let dic = resultdic as? [String:Any]{
                                return completion((responsemodel.totalPages ?? 0, responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,result:dic ,responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
                            }else if let arr = resultArr as? [[String:Any]]{
                                return completion((responsemodel.totalPages ?? 0, responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,result:arr ,responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
                            }else{
                                return completion((responsemodel.totalPages ?? 0, responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,result:resultdic ?? [String:Any]() ,responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
                            }
//                            if(resultdic ==  nil){
//                                //                                    do{
//                                let arr = Common.returndefaultarray(dic: dict ?? [String:Any]() , keyvalue: "data")///try JSONSerialization.jsonObject(with: response.data!, options: []) as? [Any]
//                                print(arr)
//                                let dic = Common.returndefaultdictionary(dic: dict ?? [String:Any](), keyvalue: "data")
//                                print(dic)
//                                if(resultArr == nil){
//                                    return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,result:resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
//                                }else{
//                                    return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,result:resultArr ?? [[String:Any]](),responsemodel.status ?? "" ,responsemodel.message!,error:Common.returnnoerror(),responseType:ResponseType.arr))
//                                }
//                                //                                    }catch{
//                                //                                        print(error.localizedDescription)
//                                //                                    }
//                            }else{
//                                return completion((responsemodel.totalPages ?? 0, responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,result:resultdic ?? [String:Any]() ,responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
//                            }

                        }else if(responsemodel.status?.lowercased() == "invalid token"){
                            //Invalid Token
                            let loginobject = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.LoginView) as? Login
                            loginobject?.logout()
                            
                            let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":"Invalid- token"])
                            return completion(( responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message!,error,responseType:ResponseType.none))
                            
                        }else if(responsemodel.status?.lowercased() == "error"){
                            print(responsemodel.message!)
                            let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":responsemodel.message ?? ""])
                      
                            return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message!,error,responseType:ResponseType.none))
                        }
                    }else{
                         let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":"Invalid-Json"])
                         return completion((0,0,"",result:[:],"Invalid - json","",error: error,responseType:ResponseType.none))
                    }
                }catch{
                    print(error.localizedDescription)
                }

            })
            
        case .failure(let error):
            print("Error in upload: \(error.localizedDescription)")
            //onError?(error)
            return completion((0,0,"",result:[:],"internet not available","",error:error as NSError,responseType:ResponseType.none))
        }
    
    }
   
        }
     }else{
        let error = NSError.init(domain: "", code: 2, userInfo: ["localiseddescription":"Internet is not Available"])
        return completion((0,0,"",result:[:],"internet not available","",error:error,responseType:ResponseType.none))
    }
}

func postWithMultipartBodyWithImgArr(fullUrl:String,arrimg:[UIImage],arrimgparamname:[String],param:[String:Any],completion: @escaping (ResponseBlock) -> Void) {
     if(Utils.isReachable() == true){
        var resultdic:[String:Any]?
        var resultArr:[[String:Any]]?
       
   
    Alamofire.upload(multipartFormData: { (multipartFormData) in
        if(arrimg.count > 0){
        for i in 0...arrimg.count-1{
        let img = arrimg[i]
        let paramName = arrimgparamname[i]
        let imageData = img.jpegData(compressionQuality: 0.1)
        if(imageData !=  nil){
           // multipartFormData.append(imageData!, withName: imgparamname, mimeType: "image/jpg")
            
            multipartFormData.append(imageData!, withName: paramName, fileName: "image.jpeg", mimeType: "image/jpeg")
        }
        
        // let boundary = "Boundary-\(UUID().uuidString)"
        
        }
        }
        if(param.count > 0){
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }
    }, to: fullUrl) {
        (result) in
        switch result{
        case .success(let upload, _, _):
            upload.responseJSON(completionHandler: { (dataResponse) in
                var dict:[String:AnyObject]?
                do{
                    dict = try  JSONSerialization.jsonObject(with: dataResponse.data!, options: []) as? [String:AnyObject]
                    if(JSONSerialization.isValidJSONObject(dict ?? [String:AnyObject]())){
let responsemodel = RootClass.init(dictionary: dict ?? [String:AnyObject]())
                        if(responsemodel.status!.lowercased() == "success"){
                            if(JSONSerialization.isValidJSONObject(responsemodel.data)){
                              
                            }else{
                                print("Invalid json API manager")
                            }
                          
                            resultdic = dict?["data"] as? [String : Any]
                            resultArr = dict?["data"] as? [[String:Any]]
                            if(resultdic ==  nil){
                                //                                    do{
                                let arr = Common.returndefaultarray(dic: dict ?? [String:Any]() , keyvalue: "data")///try JSONSerialization.jsonObject(with: response.data!, options: []) as? [Any]
                                print(arr)
                                let dic = Common.returndefaultdictionary(dic: dict ?? [String:Any](), keyvalue: "data")
                                print(dic)
                                if(resultArr == nil){
                                    return completion(( responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,result:resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
                                }else{
                                    return completion((responsemodel.totalPages ?? 0,0,"",result:resultArr ?? [[String:Any]](),responsemodel.status ?? "" ,responsemodel.message!,error:Common.returnnoerror(),responseType:ResponseType.arr))
                                }
                                //                                    }catch{
                                //                                        print(error.localizedDescription)
                                //                                    }
                            }else{
                                return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 , responsemodel.lastSynchTime,result:resultdic ?? [String:Any]() ,responsemodel.status ?? "",responsemodel.message! ,error:Common.returnnoerror(),responseType:ResponseType.dic))
                            }

                        }else if(responsemodel.status?.lowercased() == "invalid token"){
                            //Invalid Token
                            let loginobject = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.LoginView) as? Login
                            loginobject?.logout()
                            
                            let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":"Invalid- token"])
      
                            
                            return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message!,error,responseType:ResponseType.none))
                            
                        }else if(responsemodel.status?.lowercased() == "error"){
                            print(responsemodel.message!)
                            let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":responsemodel.message ?? ""])
                            return completion((responsemodel.totalPages ?? 0,responsemodel.pagesAvailable ?? 0 ,responsemodel.lastSynchTime,resultdic ?? [String:Any](),responsemodel.status ?? "",responsemodel.message!,error,responseType:ResponseType.none))
                        }
                    }else{
                         let error = NSError.init(domain: "", code: 1, userInfo: ["localiseddescription":"Invalid-Json"])
                         return completion((0,0,"",result:[:],"Invalid - json","",error: error,responseType:ResponseType.none))
                    }
                }catch{
                  
                        //completion((result:[:],"false",error.localizedDescription,error:error ,responseType:ResponseType.none))
                    print(error.localizedDescription)
                }

            })
            
        case .failure(let error):
            print("Error in upload: \(error.localizedDescription)")
            //onError?(error)
            return completion((0,0,"",result:[:],"","internet not available",error:error as NSError,responseType:ResponseType.none))
        }
    
    }
   
        
     }else{
        let error = NSError.init(domain: "", code: 2, userInfo: ["localiseddescription":"Internet is not Available"])
        return completion((0,0,"",result:[:],"internet not available","",error:error,responseType:ResponseType.none))
    }
}
