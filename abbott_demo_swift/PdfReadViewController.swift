//
//  PdfReadViewController.swift
//  abbott_demo_swift
//
//  Created by elijah on 2017/9/2.
//  Copyright © 2017年 elijah. All rights reserved.
//

import Foundation
import UIKit

class PdfReadViewController: UIViewController {
    var file_name:String?
    var file_path:String?
    var web_view = UIWebView()
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        self.title = file_name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //establish_web_view()
        get_pdf(file_path: file_path!)
    }
    
    func establish_web_view(){
        web_view.frame = self.view.frame
        web_view.center = self.view.center
        web_view.center.y += 60
        self.view.addSubview(web_view)
    }
    
    func get_pdf(file_path:String){
        Http_Center().get_file("http://127.0.0.1:8000/pdf_dir/" + file_path) { (data:Data) in
            // 指定寫入目錄
            let doc_path = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            // 指定檔名
            let doc_path2 = doc_path.appendingPathComponent(file_path)
            do {
                // 寫入
                try data.write(to: doc_path2, options: Data.WritingOptions.atomic)
                
                // 讀取
                let requeat = NSURLRequest(url: doc_path2)
                self.webView.loadRequest(requeat as URLRequest)
            } catch {
                print("error writing to url:", doc_path2, error)
            }
        }
    }
    
}


















