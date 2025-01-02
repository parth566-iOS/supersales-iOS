//
//  RestAPIManager.swift
//  SuperSales
//
//  Created by Apple on 21/06/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import Foundation
import Alamofire
@_exported import AlamofireObjectMapper

public typealias ArrParameters = [Parameters]

extension ArrParameters {
    func rs_jsonString(withPrettyPrint prettyPrint: Bool) -> String? {
        var jsonData: Data? = nil
        do {
            jsonData = try JSONSerialization.data(
                withJSONObject: self,
                options: .prettyPrinted)
        } catch {
        }
        if jsonData == nil {
            return "{}"
        } else {
            if let jsonData = jsonData {
                return String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\\\\", with: "\\")
            }
        }
        return nil
    }
}

extension Parameters {
    func rs_jsonString(withPrettyPrint prettyPrint: Bool) -> String? {
        var jsonData: Data? = nil
        do {
            jsonData = try JSONSerialization.data(
                withJSONObject: self,
                options: .prettyPrinted)
        } catch {
        }
        if jsonData == nil {
            return "{}"
        } else {
            if let jsonData = jsonData {
                return String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\\\\", with: "\\")
            }
        }
        return nil
    }
}

// Created structure for singleton object of Session Maanager
// Timeout interval for request and response is 60 sec respectively
struct AlamofireAppManager {
    static let shared: SessionManager = {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.configuration.timeoutIntervalForRequest = 120
        sessionManager.session.configuration.timeoutIntervalForResource = 120
//        sessionManager.session.configuration.waitsForConnectivity = true
        return sessionManager
    }()
}

class RestAPIManager {
    class func httpRequest(_ url: URLConvertible, _ httpMethod: HTTPMethod = .post, parameters: Parameters? = nil, isTeamWorkUrl: Bool = false, isFull: Bool = false,isMappFromModel:Bool = false ,completionHandler: @escaping(_ response: Any?, _ success: Bool, _ error: Error?) -> Void) {
        
        let finalAPIUrl = (isTeamWorkUrl ? ConstantURL.kBaseTeamworkURL : ConstantURL.kBaseURL) + "\(url)"
                
        AlamofireAppManager.shared.request(finalAPIUrl,
                                           method: httpMethod,
                                           parameters: parameters)
            .responseJSON { (response) in
                if isMappFromModel {
                    parseJsonResponse2(response, isFull, completionHandler: completionHandler)
                }else{
                    parseJsonResponse(response, isFull, completionHandler: completionHandler)
                }
            }
    }
    
    class func httpRequests <T: Decodable> (_ url: URLConvertible, _ httpMethod: HTTPMethod = .post, parameters: Parameters? = nil, isTeamWorkUrl: Bool = false,isMappFromModel:Bool = false ,completionHandler: @escaping (T)->()) {
        
        let finalAPIUrl = (isTeamWorkUrl ? ConstantURL.kBaseTeamworkURL : ConstantURL.kBaseURL) + "\(url)"
        
        AlamofireAppManager.shared.request(finalAPIUrl,
                                           method: httpMethod,
                                           parameters: parameters)
        .responseJSON { (response) in
            if isMappFromModel {
                if let JSON = response.data, JSON.count > 0 {
                    do {
                        let obj = try JSONDecoder().decode(T.self, from: JSON)
                        completionHandler(obj)
                    }
                    catch let jsonError {
                        print("failed to download data", jsonError)
                    }
                }
            }
        }
    }
    
    fileprivate class func parseJsonResponse(
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
    
    fileprivate class func parseJsonResponse2(
        _ response: DataResponse<Any>,
        _ isFull: Bool,
        completionHandler: @escaping (_ response: Any?,_ success:Bool,_ error: NSError?) -> Void) {
        print(response)
        switch response.result {
        case .success(let JSON):
            let jsonResponse = JSON as? [String: Any] ?? [:]
            let status = jsonResponse["status"] as? String
            if status == "Success"{
                if let data = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let shiftTiming = try decoder.decode(APIResponseShiftTiming.self, from: data)
                        completionHandler(shiftTiming.data, true, nil)
                        return
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                        let err = NSError(domain: "", code: 5555, userInfo: [NSLocalizedDescriptionKey: "Error decoding JSON"])
                        completionHandler(nil, false, err)
                        return
                    }
                }
            }else if status == "Invalid Token" {
                let err = NSError.init(domain: "", code: 5555, userInfo: [NSLocalizedDescriptionKey : "Invalid Token"])
                completionHandler(nil, false, err)
                return
            }else if status == "Error" {
                let err = NSError.init(domain: "", code: 5555, userInfo: [NSLocalizedDescriptionKey : jsonResponse["message"] ?? ""])
                completionHandler(nil, false, err)
                return
            }
           // completionHandler(jsonResponse["data"], true, nil)
        case .failure(let error):
            completionHandler(nil, false, error as NSError)
            return
        }
    }
}
