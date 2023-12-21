//
//  CoreRESTfulManager.swift
//  WebForm
//
//  Created by Lee on 8/1/2020.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import Alamofire
import Reachability
import ObjectMapper
import SwiftyJSON

class CoreRESTfulManager: NSObject {
    
    static let instance:CoreRESTfulManager = CoreRESTfulManager()
    
    static let customSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        //            .background(withIdentifier: Bundle.main.bundleIdentifier!) //not use background may timeout
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 120 //seconds
        configuration.timeoutIntervalForResource = 120
        configuration.httpMaximumConnectionsPerHost = 6
        //configuration.urlCredentialStorage = nil //clear for "CredStore - performQuery - Error copying matching creds.  Error=-25300"
      
        var serverTrustPolicies: [String: ServerTrustPolicy] = [:]
        serverTrustPolicies[ConstantURL.DOMAIN_PRO] = .disableEvaluation
        serverTrustPolicies[ConstantURL.DOMAIN_DEV] = .disableEvaluation
        return Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        
    }()
    
    override init() {
        super.init()
    }
    
    func reqPost( relUrl:String, parametersJsonStr:String?, completionHandler: @escaping (DataResponse<Any>) -> Void) throws -> DataRequest? {
        return try reqSend(relUrl: relUrl, parametersJsonStr: parametersJsonStr, method: .post, completionHandler: completionHandler)
    }
    
    func reqGet( relUrl:String, completionHandler: @escaping (DataResponse<Any>) -> Void) throws -> DataRequest? {
        return try reqSend(relUrl: relUrl, parametersJsonStr: nil, completionHandler: completionHandler)
    }
    
    func reqSend(relUrl:String, parametersJsonStr:String?, method: HTTPMethod = .get, completionHandler: @escaping (DataResponse<Any>) -> Void) throws -> DataRequest? {
        
        var finalURL = relUrl
        if (!relUrl.starts(with: "http")) {
            finalURL = ConstantURL.isPro() ? ConstantURL.DOMAIN_PRO : ConstantURL.DOMAIN_DEV
            finalURL = finalURL + relUrl
        }
        DLog("finalURL : \(finalURL)")
        
        //let currentUser = AppDataManager.instance.currentUser
        
        //let apiKey = AppDataManager.instance.currentUser?.ApiKey ?? ""
        
        if (method == .get) {
            
            if let data = parametersJsonStr?.data(using: .utf8) {
                do {
                    var paramDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    var paramStr = ""
                    for key in paramDict!.keys {
                        if paramStr.isEmpty {
                            paramStr = "?\(key)=\(paramDict![key]!)"
                        } else {
                            paramStr += "&\(key)=\(paramDict![key]!)"
                        }
                    }
                    finalURL += paramStr
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
        
        var request = URLRequest(url: URL(string: finalURL)!)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = ["Content-Type":"application/json"]
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        //request.setValue("\(apiKey)", forHTTPHeaderField: "apikey")
        
        if let parametersJsonStr = parametersJsonStr {
            let data = (method == .get) ? Data() : (parametersJsonStr.data(using: .utf8))! as! Data
            request.httpBody = data
        }

        let req = CoreRESTfulManager.customSessionManager.request(request)
            .responseJSON { (response) in
                #if DEBUG
                DLog("response: \(response)")
                #endif
                completionHandler(response)
        }
        return req
    }

    func reqUpload(relUrl:String, fileKey:String, fileData:Data, fileName:String, mimeType:String, otherParams:[String:Any], completionHandler: @escaping (SessionManager.MultipartFormDataEncodingResult) -> Void) throws -> Void {

        var finalURL = relUrl
        if (!relUrl.starts(with: "http")) {
            finalURL = ConstantURL.isPro() ? ConstantURL.DOMAIN_PRO : ConstantURL.DOMAIN_DEV
            finalURL = finalURL + relUrl
        }
        DLog("finalURL : \(finalURL)")
        let url = URL(string: finalURL)!

        //TODO: need update hedaer apiKey
        let headers: HTTPHeaders = [
            "APIkey":"",
            "Content-Type":"multipart/form-data"
        ]

        CoreRESTfulManager.customSessionManager.upload(multipartFormData: { multipartFormData in

            multipartFormData.append(fileData, withName: fileKey, fileName: fileName, mimeType: mimeType)

            for (key, value) in otherParams {
                if let data = value as? Data {
                    multipartFormData.append(data, withName: key)
                } else if let data = value as? String {
                    multipartFormData.append(data.data(using: .utf8)!, withName: key)
                }
            }
        }, to: url,
        headers: headers) { response in
            completionHandler(response)
        }
    }
}
