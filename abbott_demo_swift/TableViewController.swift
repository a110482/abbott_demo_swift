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

class TableViewController: UITableViewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate, UISearchBarDelegate {
    @IBOutlet weak var tblFileList: UITableView!
    var data_list:Array<TableViewCell_type> = []
    var fileURLs = [NSURL]()
    let quickLookController = QLPreviewController()
    let fileNames = ["AppCoda-PDF.pdf", "AppCoda-Pages.pages", "AppCoda-Word.docx", "AppCoda-Keynote.key", "AppCoda-Text.txt", "AppCoda-Image.jpeg","AppCoda-PDF-kopia.pdf","SamplePDFFile_5mb.pdf","AppCoda-Ppt.ppt"  ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--viewDidLoad--")
        
        configureTableView()
        navigationItem.title = "File Search Demo"
        quickLookController.dataSource = self
        quickLookController.delegate = self
        //prepareFileURLs()
        present(quickLookController, animated: true, completion: nil)
    }
    
    // MARK: 自製函式區
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return fileURLs.count
    }
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return fileURLs[index]
    }
    func prepareFileURLs() {
        fileURLs = []
        for file in data_list {
            let fileParts = file.file_path?.components(separatedBy:".")
            let fileParts2 = "http://127.0.0.1:8000/" + fileParts![0]
            if let fileURL = Bundle.main.url(forResource: fileParts2, withExtension: fileParts?[1]) {
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    fileURLs.append(fileURL as NSURL)
                }
            }
        }
    }
    
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        print("The Preview Controller will be dismissed.")
        tblFileList.reloadData()
    }
    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        //tblFileList.deselectRow(at: tblFileList.indexPathForSelectedRow!, animated: true)
        print("The Preview Controller has been dismissed.")
    }
    
    func previewController(_ controller: QLPreviewController, shouldOpen url: URL, for item: QLPreviewItem) -> Bool {
        if item as? NSURL == fileURLs[0] {
            return true
        }
        else {
            print("Will not open URL \(url.absoluteString)")
        }
        return false
    }
    
    func extractAndBreakFilenameInComponents(fileURL: NSURL) -> (fileName: String, fileExtension: String) {
        // Break the NSURL path into its components and create a new array with those components.
        let fileURLParts = fileURL.path!.components(separatedBy:"/")
        
        // Get the file name from the last position of the array above.
        let fileName = fileURLParts.last
        
        // Break the file name into its components based on the period symbol (".").
        let filenameParts = fileName?.components(separatedBy:".")
        
        // Return a tuple.
        return (filenameParts![0], filenameParts![1])
    }
    
    func getFileTypeFromFileExtension(fileExtension: String) -> String {
        var fileType = ""
        switch fileExtension {
        case "docx":
            fileType = "Microsoft Word document"
        case "pages":
            fileType = "Pages document"
        case "jpeg":
            fileType = "Image document"
        case "key":
            fileType = "Keynote document"
        case "pdf":
            fileType = "PDF document"
        case "ppt":
            fileType = "PPT document"
        case "pptx":
            fileType = "PPTX document"
        default:
            fileType = "Text document"
        }
        return fileType
    }
    
    
    func configureTableView() {
        tblFileList.delegate = self
        tblFileList.dataSource = self
        tblFileList.register(UINib(nibName: "FileListCell", bundle: nil), forCellReuseIdentifier: "idCellFile")
        tblFileList.reloadData()
    }
    
    // MARK: TableView 內建函式
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileListCell", for: indexPath) as! TableViewCell
//        let currentFileParts = extractAndBreakFilenameInComponents(fileURL: fileURLs[indexPath.row])
//        cell.textLabel?.text = currentFileParts.fileName
//        cell.detailTextLabel?.text = getFileTypeFromFileExtension(fileExtension: currentFileParts.fileExtension)
        cell.fileName.text = data_list[indexPath.row].file_name
        var tag_str = ""
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
        prepareFileURLs()
        self.tableView.reloadData()
    }
    
    // ET AREA ====================
    // "cell did select" & "prepare segue" 我要用  不要重複 call
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if QLPreviewController.canPreview(fileURLs[indexPath.row]) {
            quickLookController.currentPreviewItemIndex = indexPath.row
            navigationController?.pushViewController(quickLookController, animated: true )
        }
    }
    
    // ET AREA ====================
}












