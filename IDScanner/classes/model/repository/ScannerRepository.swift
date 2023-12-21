//
//  ScannerRepository.swift
//  IDScanner
//
//  Created by Lee on 25/6/2021.
//

import Foundation
import SwiftyJSON
import SwiftyTesseract

class ScannerRepository: BaseRepository {

    func submitImage(fileData: Data, filename: String, mimeType: String, completionHandler: @escaping (_ isSuccess:Bool, _ imageInfoList: [String: Any]?,_ keyOrdering: [String]?, _ error: Error?) -> Void) {

        let relUrl = ConstantURL.URL_ID_SCAN
        let otherParams:[String:Any] = [:]

        do {
            try CoreRESTfulManager.instance.reqUpload(relUrl: relUrl, fileKey: "image", fileData:fileData, fileName:filename, mimeType:mimeType, otherParams: otherParams) { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { [weak self] result in
                        print(result)
                        do{
                            if result.error == nil, let data = result.data {
                                let keys = self?.getJsonKeyOrder(jsonData: data)
                                
                                
                                let imageInfoList = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
//                                var sortedImageInfoList: [[String: Any]]? = []
//                                keys?.enumerated().forEach({ (index,key) in
//                                    if let value = imageInfoList?[key] {
//                                        sortedImageInfoList?.append([key : value])
//                                    }
//                                })
                                
                                
                                completionHandler(true, imageInfoList, keys, nil)
                            } else {
                                completionHandler(false, nil, nil,result.error)
                            }
                        }  catch {
                            print("JSON Error")
                            completionHandler(false, nil, nil, error)
                        }
                    }
                    break
                case .failure(let encodingError):
                    print(encodingError.localizedDescription)
                    completionHandler(false, nil, nil ,encodingError)
                    break
                }
            }
        } catch {
            print(error.localizedDescription)
            completionHandler(false, nil, nil,error)
        }
    }

    func getJsonKeyOrder(jsonData: Data) -> [String] {
        var keys : [String] = []
        let jsonStr = String(decoding: jsonData, as: UTF8.self)
        let jsonContent = jsonStr.dropFirst().dropLast() //remove {}
        let keyPairs = jsonContent.split(separator: ",")
        for pairs in keyPairs {
            let keyStr = pairs.split(separator: ":")[0].dropFirst().dropLast() //remove ""
            keys.append(String(keyStr))
        }
        return keys
    }
}
