//
//  WinChartListCell.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/11/6.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class WinChartListCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var listTableView: UITableView!
    var listModel:[ChartWinListModel] = []{
        didSet{
            self.listTableView.separatorStyle = .none
            self.listTableView.reloadData()
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        self.listTableView.separatorStyle = .none
        self.listTableView.register(UINib(nibName: "ChartListCell", bundle: nil), forCellReuseIdentifier: "chartListCell")
        // Initialization code
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listModel.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chartListCell", for: indexPath) as! ChartListCell
        cell.selectionStyle = .none
        cell.listModel = listModel[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
}
