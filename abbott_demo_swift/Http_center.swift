//
//  Http_center.swift
//  abbott_demo_swift
//
//  Created by elijah on 2017/8/29.
//  Copyright © 2017年 elijah. All rights reserved.
//

import Foundation

class Http_Center{
    func request_data(_ mode:String, send_dic:Dictionary<String,AnyObject>,InViewAct: @escaping (_ returnData:Dictionary<String,AnyObject>?)->Void){
        let url = "\(server_host)demo_url/"
        let jsonData = json_dumps2(send_dic as NSDictionary)
        let sendData = "mode=\(mode);msg=\(jsonData!)"
        ajax(url, sendDate: sendData, retryCount:5) { (returnDic) in
            if !returnDic.isEmpty{
                InViewAct(returnDic)
            }
            else{
                InViewAct(nil)
            }
        }
    }
    
    
    fileprivate func ajax(_ url:String, sendDate:String,retryCount:Int ,outPutDic:@escaping (Dictionary<String,AnyObject>) -> Void){
        var ouput:String?
        var ouput_json = [String:AnyObject]()
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
//        request.allHTTPHeaderFields = ["Cookie":cookie_new.get_cookie()]
//        request.allHTTPHeaderFields = ["X-CSRFToken":cookie_new.get_csrf()]
        request.allHTTPHeaderFields = ["Referer":"\(server_host)"]
        request.httpBody = sendDate.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if error != nil{
                print("======連線錯誤======")
                print(error as Any)
                if retryCount > 0{
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                        sleep(1)
                        self.ajax(url, sendDate: sendDate, retryCount:retryCount-1, outPutDic: outPutDic)
                    }
                    
                }
                else{
                    outPutDic([:])
                }
                
            }
            else{
                ouput = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
                if let res = response as? HTTPURLResponse{
                    print("http complete")
                    let status = res.statusCode
                    if status == 200{
                        ouput_json = json_load(ouput!) as! Dictionary
                        //print(ouput_json)
                        outPutDic(ouput_json)
                        //print(response)
                    }
                    else{
                        print("http state\(status)")
                        print(sendDate)
                        print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as Any)
                    }
                }
                else{
                    print("http statusCode error")
                }
                
            }
        })
        task.resume()
        
        
    }
    
    func ajax2(_ url:String, sendDate:String,retryCount:Int,cookie:String? ,outPutDic:@escaping (Dictionary<String,AnyObject>) -> Void){
        if cookie != nil{
            var ouput:String?
            var ouput_json = [String:AnyObject]()
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            let csrf = getCSRFToken(cookie!)
            //        print("======cookie=======")
            //        print(cookie)
            //        print(isInternetAvailable())
            request.allHTTPHeaderFields = ["Cookie":cookie!]
            request.allHTTPHeaderFields = ["X-CSRFToken":csrf!]
            request.allHTTPHeaderFields = ["Referer":"\(server_host)"]
            request.httpBody = sendDate.data(using: String.Encoding.utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                if error != nil{
                    print("======連線錯誤======")
                    print(error!)
                    if retryCount > 0{
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                            sleep(1)
                            self.ajax(url, sendDate: sendDate, retryCount:retryCount-1, outPutDic: outPutDic)
                        }
                        
                    }
                    else{
                        outPutDic([:])
                    }
                    
                }
                else{
                    ouput = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
                    if let res = response as? HTTPURLResponse{
                        let status = res.statusCode
                        if status == 200{
                            ouput_json = json_load(ouput!) as! Dictionary
                            //print(ouput_json)
                            outPutDic(ouput_json)
                            //print(response)
                        }
                        else{
                            outPutDic([:])
                            //print(response)
                            //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
                            print(sendDate)
                            print("http error state:\(status)")
                        }
                    }
                    
                }
            })
            task.resume()
        }
        else{
            print("cookie is nil")
        }
        
        
        
    }
    
    func get_file(_ url:String,getdata:@escaping (_ data:Data)->Void){
        var ouput:Data?
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if error != nil{
                print("連線錯誤")
            }
            else{
                ouput = data!
                if let res = response as? HTTPURLResponse{
                    let status = res.statusCode
                    if status != 200{
                        print(response)
                        print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
                    }
                    
                }
                getdata(ouput!)
            }
        })
        
        task.resume()
    }
}
