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
    
    override func viewDidLoad() {
        self.title = file_name
        establish_wev_view()
        get_pdf(file_path: file_path!)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        establish_wev_view()
        web_view.backgroundColor = UIColor.red
        get_pdf(file_path: file_path!)
    }
    func establish_wev_view(){
        web_view.frame = self.view.frame
        web_view.center = self.view.center
        self.view.addSubview(web_view)
    }
    
    func get_pdf(file_path:String){
        print("http://127.0.0.1:8000/pdf_dir/" + file_path)
        //let file_path_part = file_path.components(separatedBy: ".")
        //let sec_file_path = file_path_part[file_path_part.count - 1]
        //let first_file_path = try! get_part_of_string(string: file_path, from: 0, before: (file_path.characters.count - sec_file_path.characters.count - 1))
        //let pdf_loc = Bundle.main.url(forResource: (first_file_path), withExtension: sec_file_path)
        Http_Center().get_file("http://127.0.0.1:8000/pdf_dir/" + file_path) { (data:Data) in
            let doc_path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let doc_path2 = doc_path.appendingPathComponent(file_path)
            do {
                // writing to disk
                try data.write(to: doc_path2, options: Data.WritingOptions.atomic)
                
                // saving was successful. any code posterior code goes here
                // reading from disk
                let requeat = NSURLRequest(url: doc_path2)
                self.web_view.loadRequest(requeat as URLRequest)
                print("=====dddddd")
            } catch {
                print("error writing to url:", doc_path2, error)
            }
            
        }
    }
    
}


















