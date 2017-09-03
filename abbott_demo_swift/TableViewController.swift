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

class TableViewController: UITableViewController {
    @IBOutlet weak var tblFileList: UITableView!
    var data_list:Array<TableViewCell_type> = []
    // 主要資料清單
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--viewDidLoad--")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let save_btn = UITableViewRowAction(style: .default, title: "儲存") { (act:UITableViewRowAction, index:IndexPath) in
            let file_path = self.data_list[index.row].file_path!
            let file_name = self.data_list[index.row].file_name!
            let tags = self.data_list[index.row].tags
            self.get_pdf(file_path: file_path, file_name: file_name, tags: tags)
        }
        return [save_btn]
    }
    func get_pdf(file_path:String, file_name:String, tags:Array<String>){
        Http_Center().get_file(media_dir + file_path) { (data:Data) in
            // 指定寫入目錄
            let doc_path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            // 指定檔名
            let doc_path2 = doc_path.appendingPathComponent(file_name + ".pdf")
            do {
                // 寫入file
                try data.write(to: doc_path2, options: Data.WritingOptions.atomic)
                
                // 寫入DB
                var tag_str = ""
                for c in tags{
                    tag_str = "\(tag_str)  \(c)"
                }
                sql_database.insert_file(file_name: file_name, tags: tag_str)
                
                let alert = UIAlertController(title: "通知", message: "儲存完畢", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                
            } catch {
                print("error writing to url:", doc_path2, error)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next_view = segue.destination as! PdfReadViewController
        let index = self.tableView.indexPathForSelectedRow!.row
        next_view.file_name = data_list[index].file_name
        next_view.file_path = data_list[index].file_path
        var tag_str = ""
        for c in data_list[index].tags{
            tag_str = "\(tag_str)  \(c)"
        }
        sql_database.insert_history(file_name: data_list[index].file_name!, file_path: data_list[index].file_path!, file_tags: tag_str)
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

class HistoryTableViewController: TableViewController {
    override func viewDidAppear(_ animated: Bool) {
        load_table_data()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next_view = segue.destination as! PdfReadViewController
        let index = self.tableView.indexPathForSelectedRow!.row
        next_view.file_name = data_list[index].file_name
        next_view.file_path = data_list[index].file_path
    }
    func load_table_data(){
        data_list = []
        let history_data = sql_database.get_history()
        for data in history_data{
            let tags_list = data["file_tags"]!.components(separatedBy: "  ")
            let temp_obj = TableViewCell_type(
                file_name: data["file_name"]!,
                tags: tags_list,
                file_path: data["file_path"]
            )
            data_list.append(temp_obj)
        }
        self.tableView.reloadData()
    }
}










