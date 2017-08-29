//
//  EnteryView.swift
//  abbott_demo_swift
//
//  Created by elijah on 2017/8/29.
//  Copyright © 2017年 elijah. All rights reserved.
//

import Foundation
import UIKit

class EntryView:UIViewController, UISearchBarDelegate{
    
    @IBOutlet weak var search_bar: UISearchBar!
    @IBOutlet weak var tableview: UIView!
    
    override func viewDidLoad() {
        search_bar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count >= 2{
            
            let send_dic = [
                "search_text": searchText
            ]
            Http_Center().request_data("get_query_advice", send_dic: send_dic as Dictionary<String, AnyObject>, InViewAct: { (return_dic:Dictionary<String, AnyObject>?) in
                if return_dic != nil{
                    print((return_dic!["result_list"] as! Array<Dictionary<String,AnyObject>>).count)
                    for unit in return_dic!["result_list"] as! Array<Dictionary<String,AnyObject>>{
                        print(unit["file_path"])
                        print(unit["file_name"])
                        print(unit["tags"])
                    }
                }
            })
        }
    }
    
}









