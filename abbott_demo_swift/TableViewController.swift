//
//  ViewController.swift
//  abbott_demo_swift
//
//  Created by elijah on 2017/8/29.
//  Copyright © 2017年 elijah. All rights reserved.
//

import UIKit
import QuickLook
import Foundation

class TableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var tblFileList: UITableView!
    var data_list:Array<TableViewCell_type> = []
    // 主要資料清單
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--viewDidLoad--")
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileListCell", for: indexPath) as! TableViewCell
        cell.fileName.text = data_list[indexPath.row].file_name
        var tag_str = ""
        // cell 上要顯示的 tag 文字
        for tas_text in data_list[indexPath.row].tags{
            tag_str = "\(tag_str)  \(tas_text)"
        }
        cell.fileLabel.text = tag_str
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_list.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next_view = segue.destination as! PdfReadViewController
        let index = self.tableView.indexPathForSelectedRow!.row
        next_view.file_name = data_list[index].file_name
        next_view.file_path = data_list[index].file_path
    }
    
    func update_date(new_data_list:Array<Dictionary<String,AnyObject>>){
        data_list = []
        for datas in new_data_list{
            let temp_obj = TableViewCell_type(
                file_name: datas["file_name"] as? String,
                tags: (datas["tags"] as? Array<String>)!,
                file_path: datas["file_path"] as? String
            )
            data_list.append(temp_obj)
        }
        self.tableView.reloadData()
    }
}












