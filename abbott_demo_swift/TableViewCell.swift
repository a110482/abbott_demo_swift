//
//  table_view_cell.swift
//  abbott_demo_swift
//
//  Created by elijah on 2017/8/29.
//  Copyright © 2017年 elijah. All rights reserved.
//

import Foundation
import UIKit
class TableViewCell: UITableViewCell {
    //out_let
    @IBOutlet var fileName:UILabel!
    @IBOutlet var fileLabel:UILabel!
    
}

struct TableViewCell_type {
    var file_name:String?
    var tags:Array<String>
    var file_path:String?
}
