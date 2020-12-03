//
//  HttpUtility.swift
//  Medtrail_Assignment
//
//  Created by shivendra pandey on 3/12/20.
//  Copyright © 2020 shivendra pandey. All rights reserved.
//

import Foundation
public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case delete  = "DELETE"
}
struct url_component {
    static let scheme   = "https"
    static let host = "www.flickr.com"
    static let path = "/services/rest/"
}
struct HttpUtility
{
    
    func performRequest<T:Codable>(requestUrl: URL,methodType method: HTTPMethod, requestBody: Data?, resultType: T.Type, completionHandler:@escaping(_ result: T?,_ isSuccess : Bool )-> Void)
    {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            if error != nil {
                let error = (error?.localizedDescription ?? Constants.UserMessage.SomethingWentWrong)
                self.handleError(error)
                completionHandler(nil, false)
                return
            }
            guard let responceCode = httpUrlResponse as? HTTPURLResponse, (200...299).contains(responceCode.statusCode) else {
                self.handleError()
                completionHandler(nil, false)
                return
            }
            guard let responceDataModel = try? JSONDecoder().decode(T.self, from: data!) else{
                self.handleError()
                completionHandler(nil, false)
                return
            }
            completionHandler(responceDataModel, true)
        }.resume()
    }
    
    func handleError(_ message : String = Constants.UserMessage.SomethingWentWrong) -> () {
        DispatchQueue.main.async {
            MyHelper.showAlertTostWithTitle(nil, message : message)
        }
    }
}





