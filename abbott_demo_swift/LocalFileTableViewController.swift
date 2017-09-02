//
//  LocalFileTableViewController.swift
//  abbott_demo_swift
//
//  Created by elijah on 2017/9/2.
//  Copyright © 2017年 elijah. All rights reserved.
//

import Foundation
import UIKit

class LocalFileTableViewController: UITableViewController {
    struct local_cell_data_type {
        var file_name:String
        var file_tags:String
    }
    var data_list:Array<local_cell_data_type> = []
    
    // MARK: override func
    override func viewDidLoad() {
        print("-----------")
        print(get_all_file()!)
    }
    override func viewDidAppear(_ animated: Bool) {
        reload_table()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_list.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileListCell", for: indexPath) as! TableViewCell
        let data = self.data_list[indexPath.row]
        cell.fileName.text = data.file_name
        cell.fileLabel.text = data.file_tags
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "刪除") { (act:UITableViewRowAction, index:IndexPath) in
            let file_name = self.data_list[index.row].file_name
            self.delete_file(file_name: file_name)
            sql_database.remove_file(file_name: file_name)
            self.tableView.beginUpdates()
            self.data_list.remove(at: index.row)
            self.tableView.deleteRows(at: [index], with: .left)
            self.tableView.endUpdates()
        }
        return [delete]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next_view = segue.destination as! PdfReadViewController_local
        let index = self.tableView.indexPathForSelectedRow!.row
        let data = data_list[index]
        next_view.file_name = data.file_name
        next_view.file_path = data.file_name + ".pdf"
    }
    
    // MARK: internal func
    func reload_table(){
        self.data_list = []
        let data_list = sql_database.get_local_files()
        for datas in data_list{
            let temp_obj = local_cell_data_type(file_name: datas["file_name"]!, file_tags: datas["file_tags"]!)
            self.data_list.append(temp_obj)
        }
        self.tableView.reloadData()
    }
    func get_all_file() -> Array<String>?{
        var filePaths:Array<String> = []
        do {
            let urlForDocument = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)
            let url = urlForDocument[0] as URL
            let array = try FileManager.default.contentsOfDirectory(atPath: url.path)
            for fileName in array {
                filePaths.append(fileName)
            }
            
        } catch let error as NSError {
            print("get file path error: \(error)")
        }
        
        return filePaths
    }
    func delete_file(file_name:String){
        do {
            let urlForDocument = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)
            let url = urlForDocument[0] as URL
            let file = url.appendingPathComponent(file_name + ".pdf")
            try FileManager.default.removeItem(at: file)
        } catch let error as NSError {
            print("get file path error: \(error)")
        }
    }
    
}













