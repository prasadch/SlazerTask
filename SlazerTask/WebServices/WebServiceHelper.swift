//
//  WebServiceHelper.swift
//  SlazerTask
//
//  Created by Prasad Ch on 29/08/19.
//  Copyright © 2019 Prasad Ch. All rights reserved.
//

import Foundation
import Alamofire

typealias RequestCompletionHandler = (_ responseData : Data, _ statusCode: Int, _ error: Error?) -> Void
typealias UploadImageCompletionHandler = (_ uploaded: Bool, _ error: Error?) -> Void

enum RequestMethod : String, CaseIterable {
    case GET = "GET"
    case POST = "POST"
}

func makeAPIRequest(requestUrl: String, paramValues: [String:Any], requestMethod: RequestMethod ,completionHandler: @escaping RequestCompletionHandler) {
    
    guard let url = URL(string: requestUrl) else {
        return
    }
    
    let updatedParamValues = NSMutableDictionary(dictionary: paramValues)
    
    let progressView = AJProgressView()
    progressView.show()
    
    Alamofire.request(url, method: requestMethod == .GET ? .get : .post, parameters: updatedParamValues as? [String : Any], encoding: URLEncoding.default).validate().responseJSON {
        response in
        
        var currentRequestStatusCode = 0
        
        if let statusCode = response.response?.statusCode {
            currentRequestStatusCode = statusCode
        }
        
        progressView.hide()
        
        switch response.result {
            
        case .failure(let error):
            
            print(error)
            
            if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                print(responseString)
                
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                    if let _ = dictionary, currentRequestStatusCode == 403 {
                        //Error part
                    }
                    else {
                        completionHandler(data, currentRequestStatusCode, error)
                    }
                }
                catch {
                    print("Error in response")
                }
            }
            
        case .success(let responseObject):
            print(responseObject)
            
            if let data = response.data {
                completionHandler(data, currentRequestStatusCode, nil)
            }
        }
    }
}

func uploadImageIntoServer(image: UIImage, paramValues: [String:String], completionHandler: @escaping UploadImageCompletionHandler) {
    
    let imgData = image.jpegData(compressionQuality: 0.2)
    
    let progressView = AJProgressView()
    progressView.show()
    
    Alamofire.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(imgData!, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")
        for (key, value) in paramValues {
            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
        } //Optional for extra parameters
    },
                     to:Constants.API.kMyAccount)
    { (result) in
        switch result {
        case .success(let upload, _, _):
            
            upload.uploadProgress(closure: { (progress) in
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            
            upload.responseJSON { response in
                //                print(response.result.value)
                completionHandler(true, nil)
                progressView.hide()
            }
            
        case .failure(let encodingError):
            print(encodingError)
            completionHandler(false, encodingError)
            progressView.hide()
        }
    }
}






