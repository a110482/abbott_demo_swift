//
//  ViewController.swift
//  abbott_demo_swift
//
//  Created by elijah on 2017/8/29.
//  Copyright © 2017年 elijah. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {
    var data_list:Array<TableViewCell_type> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--viewDidLoad--")
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_list.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func update_date(new_data_list:Array<Dictionary<String,AnyObject>>){
        
    }
    
    // ET AREA ====================
    // "cell did select" & "prepare segue" 我要用  不要重複 call
    
    
    // ET AREA ====================
}












