//
//  Sql_center.swift
//  abbott_demo_swift
//
//  Created by elijah on 2017/9/2.
//  Copyright © 2017年 elijah. All rights reserved.
//

import Foundation
import SQLite

public class SQL_center {
    var sql_db:Connection?
    var Local_file = Table("local_file")
    var History_record = Table("History_record")
    let id = Expression<Int64>("id")
    var file_name = Expression<String>("file_name")
    var file_tags = Expression<String>("file_tags")
    var file_path = Expression<String>("file_path")
    
    // main func
    func connect_sql(){
        let urls = FileManager.default
            .urls(
                for: .documentDirectory,
                in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString
            + "sqlite3.db"
        do{
            self.sql_db = try Connection(sqlitePath)
            print("資料庫連線成功")
        }
        catch{
            print("資料庫錯誤")
            print(error)
        }
    }
    func establish_all_table(){
        establish_Local_file()
        establish_History_record()
    }
    
    // Local_file
    func establish_Local_file(){
        do{
            try sql_db?.run(Local_file.create { t in
                t.column(id, primaryKey: true)
                t.column(file_name)
                t.column(file_tags)
            })
            print("表單建立成功")
        }
        catch{
            print("資料庫錯誤")
            print(error)
        }
    }
    func insert_file(file_name:String, tags:String){
        do{
            let insert = Local_file.insert(
                self.file_name <- file_name,
                self.file_tags <- tags
            )
            try sql_db!.run(insert)
        }
        catch{
            print("ERROR!!! insert_file")
            print(error)
        }
    }
    func remove_file(file_name:String){
        do{
            let query = Local_file.filter(self.file_name == file_name)
            try sql_db!.run(query.delete())
        }
        catch{
            print("ERROR!!! remove_file")
            print(error)
        }
    }
    func get_local_files() -> Array<Dictionary<String,String>>{
        do{
            var result_list:Array<Dictionary<String,String>> = []
            for datas in try sql_db!.prepare(Local_file.order(id.desc)){
                let temp_dic = [
                    "file_name": datas[file_name],
                    "file_tags": datas[file_tags]
                ]
                result_list.append(temp_dic)
            }
            return result_list
        }
        catch{
            print("ERROR!! get_local_files")
            print(error)
        }
        return []
    }
    
    // History_record
    func establish_History_record(){
        do{
            try sql_db?.run(History_record.create { t in
                t.column(id, primaryKey: true)
                t.column(file_name)
                t.column(file_tags)
                t.column(file_path)
            })
            print("表單建立成功")
        }
        catch{
            print("資料庫錯誤")
            print(error)
        }
    }
    func insert_history(file_name:String, file_path:String, file_tags:String){
        do{
            let insert = History_record.insert(
                self.file_name <- file_name,
                self.file_path <- file_path,
                self.file_tags <- file_tags
            )
            try sql_db!.run(insert)
        }
        catch{
            print("ERROR insert_history")
            print(error)
        }
    }
    func get_history() -> Array<Dictionary<String,String>>{
        var result_list:Array<Dictionary<String,String>> = []
        do{
            let query = History_record.order(id.desc).limit(5)
            for data in try sql_db!.prepare(query){
                print("0011----------")
                print(data[file_name])
                let temp_dic = [
                    "file_name": data[file_name],
                    "file_path": data[file_path],
                    "file_tags": data[file_tags]
                ]
                result_list.append(temp_dic)
            }
        }
        catch{
            print("ERROR!!!  get_history")
            print(error)
        }
        return result_list
    }
    
}

























