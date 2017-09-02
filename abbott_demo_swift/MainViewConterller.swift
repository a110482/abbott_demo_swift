//
//  MainViewConterller.swift
//  abbott_demo_swift
//
//  Created by elijah on 2017/9/2.
//  Copyright © 2017年 elijah. All rights reserved.
//

import Foundation
import UIKit

class MainViewConterller: UIViewController {
    override func viewDidLoad() {
        print("+++")
        sql_database.connect_sql()
        sql_database.establish_all_table()
    }
}
