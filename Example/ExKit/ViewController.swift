//
//  ViewController.swift
//  ExKit
//
//  Created by ZhouYuzhen on 11/08/2020.
//  Copyright (c) 2020 ZhouYuzhen. All rights reserved.
//

import UIKit
import ExKit
import SnapKit

class ViewController: ExBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = ExKeyboardAvoidingTableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            
            let field = UITextField()
            cell?.contentView.addSubview(field)
            field.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
            }
        }
        
        if let field = cell?.contentView.subviews.first as? UITextField {
            field.placeholder = "提示\(indexPath.row)"
        }
        return cell!
    }
    
}
